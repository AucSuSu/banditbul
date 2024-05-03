package org.banditbul.bandi.test;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.*;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.Map;
import java.util.Set;

@Slf4j
@Component
public class WebSocketHandler extends TextWebSocketHandler { // 웹 소켓 연결 및 메시지 처리 로직
    // 여기서 관리하기
    private static ObjectMapper objectMapper = new ObjectMapper();
    private static SOSService sosService;
    private static final Logger log = LoggerFactory.getLogger(WebsocketConfig.class);

    // 클라이언트가 연결되면 호출됨
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        log.info("** afterConnectionEstablished **");
    }

    // 클라이언트로부터 메시지를 받았을 때 처리 로직
    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        String payload = message.getPayload();
        MessageDto messageDto = objectMapper.readValue(payload, MessageDto.class);
        SOSSession room = sosService.findBySessionId(messageDto.getSessionId());
        Set<WebSocketSession> sessions = room.getSessions();

        log.info("Message Received");
        log.info("Message SessionId: "+messageDto.getSessionId());
        log.info("Message BeaconId: "+messageDto.getBeaconId());
        log.info("Message Type: "+messageDto.getType());
        log.info("Message uuId: "+messageDto.getUuId());
        log.info("Message count: "+messageDto.getCount());

        //세션 입장
        if(messageDto.getType() == Type.ENTER){
            if (!sessions.contains(session)) {
                sessions.add(session);
            }
        }
        //앱이 비콘에 들어옴
        else if(messageDto.getType() == Type.BEACON){
            //여기서 비콘 별로 사람이 얼마나 들어가있는지 연산
            sosService.updateUserBeacon(messageDto.getUuId(), messageDto.getBeaconId());
            Map<String, Integer> beaconCounts = sosService.getAllBeaconUserCounts();

            messageDto.setType(Type.MONITOR);
            messageDto.setCount(beaconCounts);
            sendToEachSocket(sessions, message);
        }
        //그 외에는 그대로 패스
        else{
            sendToEachSocket(sessions, message);
        }

        //sessions.remove(session); //-> 로그아웃시 삭제
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
