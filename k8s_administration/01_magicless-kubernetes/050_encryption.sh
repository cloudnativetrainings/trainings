#!/bin/bash

set -euxo pipefail

ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
cat > secrets/encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF

for instance in master-{0..2}; do
  gcloud compute scp secrets/encryption-config.yaml ${instance}:
done
