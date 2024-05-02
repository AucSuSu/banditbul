package org.banditbul.bandi.test;

import lombok.RequiredArgsConstructor;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@RequiredArgsConstructor
public class WebsocketConfig implements WebSocketConfigurer { // 웹 소켓 핸들러를 스프링 웹소켓 설정에 등록
    private final WebSocketHandler webSocketHandler;
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(webSocketHandler, "/socket").setAllowedOrigins("*");
    }
}
