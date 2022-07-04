Client Registration
client_id	Bi_lj51ocKve0MJQRcCO6X5Z
client_secret	Z6gu-DE8IwGn5JbaKWPmzhbb7IwTCePWZRCyL-x4lxDtFVQf
User Account
login	bad-scarab@example.com
password	Bright-Eagle-41


https://authorization-server.com/authorize?
  response_type=code
  &client_id=Bi_lj51ocKve0MJQRcCO6X5Z
  &redirect_uri=https://www.oauth.com/playground/oidc.html
  &scope=openid+profile+email+photos
  &state=5YkBhSLBIxnyOWZy
  &nonce=fhGepjVbrqlssYEB

# #################################################################################################

<!-- 
automate or use UI
https://cloud.google.com/iap/docs/programmatic-oauth-clients
gcloud alpha iap oauth-brands list
gcloud alpha iap oauth-brands create --application_title=kkp-admin-2 --support_email=student-01.kkp-admin-training@loodse.training
gcloud alpha iap oauth-clients create projects/PROJECT_ID/brands/BRAND-ID --display_name=NAME
gcloud alpha iap oauth-clients create projects/PROJECT_ID/brands/BRAND-ID --display_name=NAME -->

apis&services / credentials
- create credentials -> OAuth client ID
- Application Type: Web Application
- ADD Autorized redirect URIs


https://console.cloud.google.com/apis/credentials/oauthclient?previousPage=%2Fapis%2Fcredentials%3Fproject%3Dstudent-01-kkp-admin-training&project=student-01-kkp-admin-training


https://student-01-kkp-admin-training.loodse.training/dex/callback

values.yaml => dex.connectors
```yaml
dex:
  ingress:
    host: "run.lab.kubermatic.io"
  connectors:
    - type: google
      id: google
      name: Google
      config:
        clientID: <CLIENT-ID>
        clientSecret: <CLIENT-SECRET>
        redirectURI: https://student-01-kkp-admin-training.loodse.training/dex/callback
        hostedDomains:
          - loodse.training
```

kubermatic-installer --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml

kubectl edit user b8e8b9174609b4b6cb84133c291e510774a1fc69e5bca311ca25165e371f02a9
=> make admin