
deployment
- name: my-nginx
   image: nginx:{{ required "A nginx version is required!" .Values.tag }}

helm install required ./my-chart 

helm install required ./my-chart --set tag=1.19.2
