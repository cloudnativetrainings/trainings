package com.loodse.training;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.MeterRegistry;

@RestController
public class MyController {

    private static final Logger LOG = LoggerFactory.getLogger(MyController.class);
    public static boolean HEALTHY = true;
    public static boolean READY = true;

    private final Counter rootCounter;

    public MyController(MeterRegistry meterRegistry) {
        rootCounter = Counter.builder("my_counter").tag("app", "my-app").tag("path", "root").register(meterRegistry);
    }

    @GetMapping("/")
    public String root() {
        LOG.info("root request");
        return "hello";
    }

    @GetMapping("/counter")
    public String counter() {
        LOG.info("counter request");
        rootCounter.increment();
        return "counter";
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

    @GetMapping("/downward_api")
    public String downwardApi() {
        LOG.info("downward_api request");
        StringBuilder builder = new StringBuilder();
        builder.append("MY_NODE_NAME: " + System.getenv("MY_NODE_NAME") + "\n");
        builder.append("MY_POD_NAME: " + System.getenv("MY_POD_NAME") + "\n");
        builder.append("MY_POD_IP: " + System.getenv("MY_POD_IP") + "\n");
        return builder.toString();
    }

    @GetMapping("/set_healthy/{healthy}")
    public String setHealthy(@PathVariable(name = "healthy") boolean healthy) {
        LOG.info("set_healthy request");
        HEALTHY = healthy;
        return "healthy: " + HEALTHY;
    }

    @GetMapping("/set_ready/{ready}")
    public String setReady(@PathVariable(name = "ready") boolean ready) {
        LOG.info("set_ready request");
        READY = ready;
        return "ready: " + READY;
    }

}