
# UI

install cluster-autscaler

check in Dashboard

# custom addons

{SEED}

kubectl -n kubermatic get pod kubermatic-seed-controller-manager-7d9f8f9bd8-hbv7f  -o yaml
kubectl -n kubermatic exec kubermatic-seed-controller-manager-7d9f8f9bd8-hbv7f  -- ls -alh /opt/addons




