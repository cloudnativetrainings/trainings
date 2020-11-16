
1. Build, dockerize and push frontend:2.0.0 image
```bash
cd 00_frontend
vi ./build.sh   # set the VERSION from 1.0.0 to 2.0.0
./build.sh
```

2. Verify the images exist in the container registry via the UI

3. Apply the yaml files
```bash
kubectl apply -f .
```

4. Curl the application
```bash
while true; do curl $INGRESS_HOST; sleep 1; done;
```

5. Verify that ~ 90 % of the requests are from Version 2.0.0

6. Change the percentage in the VirtualService to eg 50 % per version and apply the changes
```bash
kubectl apply -f .
```

6. curl the application
```bash
while true; do curl $INGRESS_HOST; sleep 1; done;
```

7. Verify the change you made

8. Clean up
```bash
kubectl delete -f .
```


