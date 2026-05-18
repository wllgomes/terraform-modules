# S3 compatibility wrapper

This module preserves the historical `//modules/s3` source path and delegates
all resources to `../../general/s3`.

Prefer the canonical source path for new consumers:

```hcl
source = "git::https://github.com/wllgomes/terraform-modules.git//general/s3?ref=main"
```
