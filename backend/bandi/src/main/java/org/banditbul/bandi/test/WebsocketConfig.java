package org.banditbul.bandi.test;

import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@RequiredArgsConstructor
@EnableWebSocket
@Configuration
public class WebsocketConfig implements WebSocketConfigurer {
    private final WebSocketHandler webSocketHandler;

    // Create a logger instance for this class
    private static final Logger log = LoggerFactory.getLogger(WebsocketConfig.class);

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        log.debug("Registering WebSocket handlers");
        registry.addHandler(webSocketHandler, "/socket").setAllowedOrigins("*").withSockJS();
        log.info("WebSocket handler registered for '/socket' with allowed origins '*'");
    }
}
