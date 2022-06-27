docker build -t ueber/kkp-addons:v2.18.1-hust .
docker push ueber/kkp-addons:v2.18.1-hust

cat image/Yin_yang.svg | base64 -w0
