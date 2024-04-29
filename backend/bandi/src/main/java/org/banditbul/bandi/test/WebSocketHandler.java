package org.banditbul.bandi.test;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.socket.*;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.HashMap;
import java.util.Set;

@Slf4j
public class WebSocketHandler extends TextWebSocketHandler {

    // 여기서 관리하기
    private static ObjectMapper objectMapper = new ObjectMapper();
    private static SOSService sosService;
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        log.info("** afterConnectionEstablished **");
    }

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        MessageDto messageDto = objectMapper.readValue(payload, MessageDto.class);
        SOSSession room = sosService.findBySessionId(messageDto.getSessionId());
        Set<WebSocketSession> sessions = room.getSessions();

        System.out.println(messageDto);
        if(messageDto.getType().equals("SOS")) {
            sessions.add(session);
            sendToEachSocket(sessions, new TextMessage(objectMapper.writeValueAsString(messageDto)));
        }else if(messageDto.getType().equals("ENTER")){
            sessions.add(session);
        }else if(messageDto.getType().equals("OK")){
            sendToEachSocket(sessions, new TextMessage(objectMapper.writeValueAsString(messageDto)));
        }else if(messageDto.getType().equals("QUIT")){
            sendToEachSocket(sessions, new TextMessage(objectMapper.writeValueAsString(messageDto)));
            sessions.remove(session);
        }
    }

    private  void sendToEachSocket(Set<WebSocketSession> sessions, TextMessage message){
        sessions.parallelStream().forEach( roomSession -> {
            try {
                System.out.println(message);
                roomSession.sendMessage(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        });
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        log.info("** afterConnectionEstablished **");
    }
}
