1. apply the yaml files

2. curl
```bash
curl -H "Host: frontend.loodse.training" $URL
```

3. curl
```bash
curl -H "Host: backend.loodse.training" $URL
```
4. set timeout interval
```bash
curl -H "Host: backend.loodse.training" $URL/set_timeout/10
```

5. trigger frontend-backend communication
```bash
curl -H "Host: frontend.loodse.training" $URL/call_backend_timeout
```