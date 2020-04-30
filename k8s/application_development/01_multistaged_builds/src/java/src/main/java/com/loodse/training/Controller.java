package com.loodse.training;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class Controller {

    private static final Logger LOG = LoggerFactory.getLogger(Controller.class);

	@GetMapping("/")
	public String root() {
        LOG.info("root request");
		return "hello";
    }
   
}