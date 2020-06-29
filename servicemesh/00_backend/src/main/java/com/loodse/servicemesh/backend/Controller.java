package com.loodse.servicemesh.backend;

import java.security.DrbgParameters.Reseed;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

    @Autowired
    private BuildProperties buildProperties;

    private final static Logger LOG = LoggerFactory.getLogger(Controller.class);
    private boolean available = true;
    private Integer delay = 0;

    @RequestMapping("/")
    public String root() {
        LOG.info("Request to /");
        return buildProperties.getName() + " " + buildProperties.getVersion();
    }

    @RequestMapping("/api")
    public ResponseEntity<String> api() throws InterruptedException {
        LOG.info("Request to /api: timeout {} seconds, is available {}", this.delay, this.available);
        Thread.sleep(delay * 1000);
        if (this.available) {
            return ResponseEntity.ok("api available");
        } else {
            return new ResponseEntity<>("api is not available", HttpStatus.SERVICE_UNAVAILABLE);
        }
    }

    @RequestMapping("/set_available/{available}")
    public String setAvailable(@PathVariable("available") boolean available) {
        LOG.info("Request to /set_available - {}", available);
        this.available = available;
        return "set available: " + this.available;
    }

    @RequestMapping("/set_delay/{delay}")
    public String setTimeout(@PathVariable("delay") Integer delay) {
        LOG.info("Request to /set_delay - {}", delay);
        this.delay = delay;
        return "set delay: " + this.delay;
    }

}