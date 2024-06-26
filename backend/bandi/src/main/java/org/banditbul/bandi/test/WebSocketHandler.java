package org.banditbul.bandi.test;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.*;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.io.IOException;
import java.util.Map;
import java.util.Set;

@Slf4j
@Component
@RequiredArgsConstructor
public class WebSocketHandler extends TextWebSocketHandler { // 웹 소켓 연결 및 메시지 처리 로직
    // 여기서 관리하기
    private static ObjectMapper objectMapper = new ObjectMapper();
    private final SOSService sosService;

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

        log.info("**Message Received");
        log.info("Message SessionId: "+messageDto.getSessionId());
        log.info("Message BeaconId: "+messageDto.getBeaconId());
        log.info("Message Type: "+messageDto.getType());
        log.info("Message uuId: "+messageDto.getUuId());
        log.info("Message count: "+messageDto.getCount());

        SOSSession room = sosService.findBySessionId(messageDto.getSessionId());
        Set<WebSocketSession> sessions = room.getSessions();

        //세션 입장
        if(messageDto.getType() == Type.ENTER){
            if (!sessions.contains(session)) {
                sessions.add(session);
                log.info("uuid: "+messageDto.getUuId()+"방 입장");
            }
        }
        //앱이 비콘에 들어옴
        else if(messageDto.getType() == Type.BEACON){
            //여기서 비콘 별로 사람이 얼마나 들어가있는지 연산
            sosService.updateUserBeacon(messageDto.getUuId(), messageDto.getBeaconId());
            Map<String, Integer> beaconCounts = sosService.getAllBeaconUserCounts();

            messageDto.setType(Type.MONITOR);
            messageDto.setCount(beaconCounts);

            String updatedPayload = objectMapper.writeValueAsString(messageDto); // 업데이트된 messageDto를 JSON 문자열로 변환
            TextMessage newMessage = new TextMessage(updatedPayload); // 새 TextMessage 생성
            sendToEachSocket(sessions, newMessage); // 새로운 메시지를 세션의 모든 소켓에 전송

            log.info("newMessage");
            log.info(String.valueOf(newMessage));
        }
        else if(messageDto.getType() == Type.SOS){
            if (!sessions.contains(session)) {
                sessions.add(session);
                log.info("uuid: "+messageDto.getUuId()+"방 입장");
            }
            sendToEachSocket(sessions, message);
        }
        //앱이 나감
        else if(messageDto.getType() == Type.CLOSE){
            sessions.remove(session);
            log.info("uuid: " + messageDto.getUuId() + "방 나감");
            sosService.removeUserFromBeacon(messageDto.getUuId()); // 비콘에서 사용자 제거
            Map<String, Integer> beaconCounts = sosService.getAllBeaconUserCounts();

            messageDto.setType(Type.MONITOR);
            messageDto.setCount(beaconCounts);

            String updatedPayload = objectMapper.writeValueAsString(messageDto); // 업데이트된 messageDto를 JSON 문자열로 변환
            TextMessage newMessage = new TextMessage(updatedPayload); // 새 TextMessage 생성
            sendToEachSocket(sessions, newMessage); // 새로운 메시지를 세션의 모든 소켓에 전송
        }
        else if(messageDto.getType() == Type.HEARTBEAT){
            //패스
        }
        //그 외에는 그대로 전달
        else{
            sendToEachSocket(sessions, message);
        }
    }

    private  void sendToEachSocket(Set<WebSocketSession> sessions, TextMessage message){
        sessions.removeIf(session -> !session.isOpen());  // 닫힌 세션 제거
        for (WebSocketSession roomSession : sessions) {
            try {
                if (roomSession.isOpen()) {
                    System.out.println("roomSession Id: "+ roomSession.getId());
                    System.out.println("message: "+ message+"----------------------");
                    roomSession.sendMessage(message);
                }
            } catch (IOException e) {
                log.error("Failed to send message to WebSocket session: " + e.getMessage(), e);
                // 에러가 발생한 세션을 처리하기 위한 추가 로직
            }
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        log.info("** Connection closed ** Reason: " + status.getReason() + ", Code: " + status.getCode());
    }
}
