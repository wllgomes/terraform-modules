#!/usr/bin/python3.13
import urllib3
import json
import base64
import zlib
import os
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

http = urllib3.PoolManager()


def lambda_handler(event, context):
    url_teams_webhook = os.getenv("TEAMS_WEBHOOK_URL")
    url_doc = os.getenv("URL_DOC")
    if not url_teams_webhook:
        logger.error("A variável de ambiente TEAMS_WEBHOOK_URL não está configurada.")
        return {"statusCode": 500, "body": "URL do webhook não encontrada."}

    message_body = event['Records'][0]['body']

    try:
        decoded_message = base64.b64decode(message_body)
        decompressed_message = zlib.decompress(decoded_message).decode('utf-8')
    except Exception as e:
        decompressed_message = message_body
        logger.error(f"Erro ao decodificar/descompactar: {e}")

    try:
        data = json.loads(decompressed_message)

        subject = data["action"]["subject"]
        violation_desc = data["action"]["violation_desc"]
        action_desc = data["action"]["action_desc"]

        is_cloudtrail_event = data.get("event") is not None

        if is_cloudtrail_event:
            # eventos do CloudTrail
            principal_id = data["event"]["detail"]["userIdentity"]["principalId"]
            account_id = data["event"]["account"]
            region = data["event"]["region"]
            origem = "CloudTrail"

        else:
            # eventos Periódicos
            principal_id = "N/A"
            account_id = data["account_id"]
            region = data["region"]
            origem = "Periódico"

        msg = {
            "@type": "MessageCard",
            "@context": "https://schema.org/extensions",
            "summary": "CloudCustodian Notification",
            "themeColor": "FF0000",
            "title": "🚨 Evento de Segurança Detectado",
            "sections": [
                {
                    "activityTitle": "**Notificação do CloudCustodian**",
                    "facts": [
                        {
                            "name": "👤 Usuário (principalId):",
                            "value": principal_id
                        },
                        {
                            "name": "🏢 Conta AWS (accountId):",
                            "value": account_id
                        },
                        {
                            "name": "🌍 Região AWS (region):",
                            "value": region
                        },
                        {
                            "name": "📌 Assunto:",
                            "value": subject
                        },
                        {
                            "name": "🛑 Violação:",
                            "value": violation_desc.strip()
                        },
                        {
                            "name": "🔧 Ação tomada:",
                            "value": action_desc.strip().replace('"', '').replace("\\n", " ")
                        },
                        {
                            "name": "☁️ Origem do evento:",
                            "value": origem
                        }
                    ],
                    "markdown": True
                }
            ],
            "potentialAction": [
                {
                    "@type": "OpenUri",
                    "name": "📘 Manual de Boas Práticas",
                    "targets": [
                        {
                            "os": "default",
                            "uri": url_doc
                        }
                    ]
                }
            ]
        }

    except Exception as e:
        logger.error(f"Erro ao processar a mensagem: {e}")
        logger.warning("Mensagem original (enviada como texto puro): %s", decompressed_message)

        msg = {
            "text": decompressed_message
        }

    encoded_msg = json.dumps(msg).encode('utf-8')
    resp = http.request('POST', url_teams_webhook, body=encoded_msg)

    logger.info("Resposta do Teams: %s", {
        "status_code": resp.status,
        "response": resp.data.decode('utf-8')
    })
