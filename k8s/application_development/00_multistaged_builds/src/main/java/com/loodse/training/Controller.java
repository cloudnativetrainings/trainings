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

    @GetMapping("/env")
	public String env() {
        LOG.info("env request");
        StringBuilder builder = new StringBuilder();
        builder.append("MY_ENV_1: " + System.getenv("MY_ENV_1") + "\n");
        builder.append("MY_ENV_2: " + System.getenv("MY_ENV_2") + "\n");
        builder.append("MY_ENV_3: " + System.getenv("MY_ENV_3") + "\n");        
		return builder.toString();
    }
   
}