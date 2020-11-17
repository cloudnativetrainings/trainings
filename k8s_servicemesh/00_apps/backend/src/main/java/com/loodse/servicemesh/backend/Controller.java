package com.loodse.servicemesh.backend;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class Controller {

    @Autowired
    private BuildProperties buildProperties;

    private final static Logger LOG = LoggerFactory.getLogger(Controller.class);
    private final RestTemplate restTemplate = new RestTemplate();
    private boolean available = true;
    private Integer delay = 0;

    @RequestMapping("/")
    public String root() {
        LOG.info("Request to /");
        return buildProperties.getName() + " " + buildProperties.getVersion() + "\n";
    }

    @RequestMapping("/api")
    public ResponseEntity<String> api() throws InterruptedException {
        LOG.info("Request to /api: timeout {} seconds, is available {}", this.delay, this.available);
        Thread.sleep(delay * 1000);
        if (this.available) {
            return ResponseEntity.ok("api available (delay " + delay + " seconds)" + "\n");
        } else {
            return new ResponseEntity<>("api is not available (delay " + delay + " seconds)" + "\n",
                    HttpStatus.SERVICE_UNAVAILABLE);
        }
    }

    @RequestMapping("/mtls")
    public ResponseEntity<String> mtls(@RequestHeader(name = "X-Forwarded-Client-Cert", required = false) String cert) {
        if (cert == null) {
            LOG.info("Request to /mtls - no client cert header");
            return ResponseEntity.ok("mtls request - no client cert header" + "\n");
        }
        LOG.info("Request to /mtls - client cert header {}", cert);
        return ResponseEntity.ok("mtls request - client cert header " + cert + "\n");
    }

    @RequestMapping("/cats")
    public ResponseEntity<String> callBackendApi() {
        LOG.info("Request to /cats");
        ResponseEntity<String> response = restTemplate.getForEntity("https://api.thecatapi.com/v1/images/search",
                String.class);
        return ResponseEntity.ok(response.getBody() + "\n");
    }

    @RequestMapping("/set_available/{available}")
    public String setAvailable(@PathVariable("available") boolean available) {
        LOG.info("Request to /set_available - {}", available);
        this.available = available;
        return "set available: " + this.available  + "\n";
    }

    @RequestMapping("/set_delay/{delay}")
    public String setTimeout(@PathVariable("delay") Integer delay) {
        LOG.info("Request to /set_delay - {}", delay);
        this.delay = delay;
        return "set delay: " + this.delay + "\n";
    }

}