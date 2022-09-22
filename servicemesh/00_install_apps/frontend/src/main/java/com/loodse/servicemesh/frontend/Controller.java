package com.loodse.servicemesh.frontend;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
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
        return buildProperties.getName() + " " + buildProperties.getVersion() + "\n";
    }

    @RequestMapping("/cats")
    public ResponseEntity<String> callBackendApi() {
        LOG.info("Request to /cats");
        ResponseEntity<String> response = restTemplate.getForEntity("http://backend:8080/cats",
                String.class);
        return ResponseEntity.ok(response.getBody() + "\n");
    }

}