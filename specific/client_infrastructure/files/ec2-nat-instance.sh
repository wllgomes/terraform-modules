#!/bin/bash
sudo amazon-linux-extras install epel -y
sudo yum update -y
sudo yum install "@Development tools" bind-utils bc bzip2 curl elinks git htop lsof net-tools screen tcpdump unzip vim wget bash-completion tree -y

# Install and configure SSM Agent
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl restart amazon-ssm-agent

# Config Prometheus's node exporter 

sudo cat << 'EOF' >> /etc/systemd/system/node-exporter.service
[Unit]
Description=Prometheus exporter for machine metrics
Documentation=https://github.com/prometheus/node_exporter

[Service]
Restart=always
User=prometheus
ExecStart=/usr/local/bin/node_exporter --collector.textfile.directory=/var/lib/prometheus/node-exporter
ExecReload=/bin/kill -HUP $MAINPID
TimeoutStopSec=20s
SendSIGKILL=no

[Install]
WantedBy=multi-user.target
EOF

sudo cat << 'EOF' >> /usr/local/bin/gera-metricas-prometheus.sh
#!/bin/bash
DIR="/var/lib/prometheus/node-exporter"

# Metricas do yum
echo "=> METRICAS YUM"
bash /usr/local/bin/yum.sh > ${DIR}/yum.prom
EOF

sudo cat << 'EOF' >> /usr/local/bin/yum.sh
#!/bin/bash
#
# Description: Expose metrics from yum updates.
#
# Author: Slawomir Gonet <slawek@otwiera.cz>
# 
# Based on apt.sh by Ben Kochie <superq@gmail.com>

set -u -o pipefail

# shellcheck disable=SC2016
filter_awk_script='
BEGIN { mute=1 }
/Obsoleting Packages/ {
  mute=0
}
mute && /^[[:print:]]+\.[[:print:]]+/ {
  print $3
}
'

check_upgrades() {
  /usr/bin/yum -q check-update |
    /usr/bin/xargs -n3 |
    awk "${filter_awk_script}" |
    sort |
    uniq -c |
    awk '{print "yum_upgrades_pending{origin=\""$2"\"} "$1}'
}

upgrades=$(check_upgrades)

echo '# HELP yum_upgrades_pending Yum package pending updates by origin.'
echo '# TYPE yum_upgrades_pending gauge'
if [[ -n "${upgrades}" ]] ; then
  echo "${upgrades}"
  sudo yum update -y
  sudo yum upgrade -y
else
  echo 'yum_upgrades_pending{origin=""} 0'
fi
EOF

useradd prometheus
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar zxvf node_exporter-1.7.0.linux-amd64.tar.gz
mv node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/
rm -rf node_exporter-1.7.0.linux-amd64*
chown prometheus: /usr/local/bin/node_exporter /usr/local/bin/gera-metricas-prometheus.sh /usr/local/bin/yum.sh
chmod +x /usr/local/bin/gera-metricas-prometheus.sh /usr/local/bin/yum.sh
mkdir -p /var/lib/prometheus/node-exporter && chown prometheus: -R /var/lib/prometheus/node-exporter
systemctl daemon-reload && systemctl enable node-exporter.service --now

echo "*/10 * * * * root /usr/local/bin/gera-metricas-prometheus.sh" >> /etc/crontab && systemctl restart crond

# Adjusting Localtime
sudo rm -rf /etc/localtime && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

# Firewall Setup for NAT Instance
sudo dnf -y install iptables

sudo echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/custom-ip-forwarding.conf
sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf
sudo echo "#!/bin/bash" > /etc/rc.local
sudo echo "iptables -t nat -A POSTROUTING -j MASQUERADE" >> /etc/rc.local

sudo chmod +x /etc/rc.local
sudo ln -s /etc/rc.local /etc/rc.d/rc.local
sudo systemctl enable rc-local.service --now