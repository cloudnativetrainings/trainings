# DestinationRule
partition a K8s Service (eg by version)

# VirtualService
how you list rules in istio
!!! there is logic in this yaml - if the first rule does not match the second will be taken

# Gateway

it is about east west routing

simple app which returns v1 or v2

the proxys are called the "data plane"
telemetry, pilot,... is called the "control plane"

# Routing
1. hellow world 
2. http header routing
3. circuit breaking
4. fault injection

What is about classical Ingress?

# Ingress Gateway

# Outbound 
by default istio blocks all outbound traffic

motivation eg: some malicious docker image talking to home

https://istiobyexample.dev/

# cat api
https://thecatapi.com/
https://docs.thecatapi.com/api-reference/
cat api key: 317af59a-7011-4071-9130-8c4e5ec020f2


istioctl dashboard kiali


# good to knows
relation between destinationrule and application is done via pod labels!!!!

retries expect 503 - SERVICE_UNAVAILABLE
