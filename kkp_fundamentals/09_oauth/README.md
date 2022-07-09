# Connect to OIDC Provider

## Configure OIDC Provider

### Create OAuth Consent Screen

Visit https://console.cloud.google.com/apis/credentials/consent and create an OAuth Consent Screen. In the Tab `OAuth Consent Screen` choose `External` and fill in 
* `App name`
* `User support email`
* Add the `Authorized Domain` with the domain `loodse.training`

### Create an OAuth 2.0 Client ID

Visit https://console.cloud.google.com/apis/credentials and click the button `Create Credentials` and choose `OAuth client ID`
* Choose `Application Type` with type `Web application` and fill in a proper name.
* Add the following `Authorized redirect URI` with the URI `https://<DOMAIN>/dex/callback`. Fill in your domain.

### Connect KKP to the OIDC Provider

Add the following to the file `values.yaml` in the section `dex`. Do not miss to fill in the missing values.
```yaml
connectors:
  - type: google
    id: google
    name: Google
    config:
      clientID: <CLIENT-ID>
      clientSecret: <CLIENT-SECRET>
      redirectURI: https://<DOMAIN>/dex/callback
      hostedDomains:
        - loodse.training
```

Apply the changes
```bash
kubermatic-installer --charts-directory ~/kkp/charts deploy \
    --config ~/kkp/kubermatic.yaml \
    --helm-values ~/kkp/values.yaml
```

Now, after signing out, you can log in with Google. Note that this is a new user which does not have admin permissions.

## Change the role of a user

```bash
kubectl get user

# Change the field `spec.admin` to true
kubectl edit user XXXXX
```

Now you have admin permissions also for this user.

Jump > [Home](../README.md) | Previous > [Addons](../08_addons/README.md) | Next > [Setup Master/Seed MLA](../10_master_seed_clusters_mla/README.md)
