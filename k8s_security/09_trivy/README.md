
# Image Scanning via Trivy

## Verify Installation

```bash
# check if trivy is installed on host level
trivy --version
```

## Scan Container Images

```bash
# scan the latest image of nginx
trivy image nginx

# scan for critical issues of the latest image of nginx
trivy image --severity CRITICAL nginx

# scan the latest alpine image
trivy image alpine

# scan an older elasticsearch image
# note that the report contains Log4Shell CVE-2021-44228 => so, also the dependencies of the application get scanned
trivy image --severity CRITICAL elasticsearch:6.8.21
```
