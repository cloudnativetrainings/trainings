package com.loodse.servicemesh.frontend;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class Controller {

    @Autowired
    private BuildProperties buildProperties;

    private final static Logger LOG = LoggerFactory.getLogger(Controller.class);
    private final RestTemplate restTemplate = new RestTemplate();

    @RequestMapping("/")
    public String root() {
        LOG.info("Request to /");
        return buildProperties.getName() + " " + buildProperties.getVersion();
    }

    @RequestMapping("/call_backend_api")
    public ResponseEntity<String> callBackendApi() {
        LOG.info("Request to /call_backend_api");
        ResponseEntity<String> response = restTemplate.getForEntity("http://backend:8080/api", String.class);
        LOG.info("Response received from backend {}: {}", response.getStatusCode(), response.getBody());
        if (response.getStatusCode().equals(HttpStatus.OK)) {
            return ResponseEntity.ok("Backend API available: " + response.getStatusCode() + " " + response.getBody());
        } else {
            return new ResponseEntity<>(
                    "Backend API not available: " + response.getStatusCode() + " " + response.getBody(),
                    HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @RequestMapping("/call_backend_timeout")
    public ResponseEntity<String> callBackendTimeout() {
        LOG.info("Request to /call_backend_timeout");
        ResponseEntity<String> response = restTemplate.getForEntity("http://backend:8080/timeout", String.class);
        LOG.info("Response received from backend {}: {}", response.getStatusCode(), response.getBody());
        return ResponseEntity.ok("Backend Timeout available: " + response.getStatusCode() + " " + response.getBody());
    }

}