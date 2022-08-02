
# scan nginx
trivy image nginx
trivy image --severity CRITICAL nginx
trivy image --severity CRITICAL nginx:1.19.2

# scan alpine
trivy image alpine:3.15.4
trivy image alpine

# do an own image with faulty dependencies

trivy image --severity CRITICAL elasticsearch:6.8.21
trivy image --severity CRITICAL elasticsearch:8.2.0

