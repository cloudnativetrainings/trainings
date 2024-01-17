package com.loodse.training;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.SmartLifecycle;
import org.springframework.stereotype.Component;

@Component
public class MyLifecycle implements SmartLifecycle {

    private static final Logger LOG = LoggerFactory.getLogger(MyLifecycle.class);

    private boolean isRunning = false;

    @Value("${my-app.start-lag:0}")
    private Integer startLag;

    @Value("${my-app.stop-lag:0}")
    private Integer stopLag;

    @Override
    public void start() {
        LOG.debug("App is starting");
        try {
            for (int i = 0; i < startLag; ++i) {
                LOG.info("Start in " + (startLag - i) + " seconds");
                Thread.sleep(1000);
            }
        } catch (Exception e) {
            LOG.error("Error on starting", e);
        }
        isRunning = true;
    }

    @Override
    public void stop() {
        LOG.debug("App is stopping");
    }

    @Override
    public void stop(final Runnable callback) {
        LOG.info("App shutdown initiated");
        try {
            for (int i = 0; i < stopLag; ++i) {
                LOG.info("Stopping in " + (stopLag - i) + " seconds");
                Thread.sleep(1000);
            }
            isRunning = false;
        } catch (Exception e) {
            LOG.error("Error on stopping", e);
        }

        try {
            callback.run();
        } catch (Exception e) {
            LOG.error("Error on shutting down", e);
        }
    }

    @Override
    public int getPhase() {
        return Integer.MAX_VALUE;
    }

    @Override
    public boolean isRunning() {
        return isRunning;
    }


}