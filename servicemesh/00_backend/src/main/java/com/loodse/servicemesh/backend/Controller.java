package com.loodse.servicemesh.backend;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.info.BuildProperties;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

    @Autowired
    private BuildProperties buildProperties;

    @RequestMapping("/")
    public String root() {
        return buildProperties.getName() + " " + buildProperties.getVersion();
    }
    
}