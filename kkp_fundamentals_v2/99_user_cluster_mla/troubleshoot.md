kubectl get namespace "mla" -o json \
  | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" \
  | kubectl replace --raw /api/v1/namespaces/mla/finalize -f -

helm --namespace mla upgrade --create-namespace --install consul ~/user-mla/charts/consul --values ~/user-mla/config/consul/values.yaml  

storageClassName: "kubermatic-fast"