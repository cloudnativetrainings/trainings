package com.loodse.training;

import org.springframework.boot.actuate.endpoint.annotation.Endpoint;
import org.springframework.boot.actuate.endpoint.annotation.ReadOperation;
import org.springframework.boot.actuate.health.Health;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

@Endpoint(id="liveness")
@Component
public class LivenessProbe {

    @ReadOperation
    public ResponseEntity<Health> liveness() {
        if (MyController.HEALTHY) {
            return ResponseEntity.ok(Health.up().build());
        } else {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Health.down().build());
        }
    }

}