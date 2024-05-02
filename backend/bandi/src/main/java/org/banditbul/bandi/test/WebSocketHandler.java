//package org.banditbul.bandi.test;
//
//import com.fasterxml.jackson.databind.ObjectMapper;
//import lombok.extern.slf4j.Slf4j;
//import org.banditbul.bandi.beacon.dto.BeaconInfoDto;
//import org.banditbul.bandi.beacon.service.BeaconService;
//import org.springframework.web.socket.*;
//import org.springframework.web.socket.handler.TextWebSocketHandler;
//
//import java.io.IOException;
//import java.util.HashMap;
//import java.util.Set;
//
//@Slf4j
//public class WebSocketHandler extends TextWebSocketHandler { // 웹 소켓 연결 및 메시지 처리 로직
//
//    // 여기서 관리하기
//    private static ObjectMapper objectMapper = new ObjectMapper();
//    private static SOSService sosService;
//
//    private static BeaconService beaconService;
//
//    // 클라이언트가 연결되면 호출됨
//    @Override
//    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
//        log.info("** afterConnectionEstablished **");
//    }
//
//    // 클라이언트로부터 메시지를 받았을 때 처리 로직
//    @Override
//    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
//        String payload = message.getPayload();
//        MessageDto messageDto = objectMapper.readValue(payload, MessageDto.class);
//        SOSSession room = sosService.findBySessionId(messageDto.getSessionId());
//        Set<WebSocketSession> sessions = room.getSessions();
//
//        System.out.println(messageDto);
//
//        if(messageDto.getType() == Type.ENTER){
//            sessions.add(session);
//            sendToEachSocket(sessions, new TextMessage(objectMapper.writeValueAsString(messageDto)));
//        }else if(messageDto.getType() == Type.SOS){
//            sessions.add(session);
//        }else if(messageDto.getType() == Type.SOS_ACCEPT){
//            sendToEachSocket(sessions, new TextMessage(objectMapper.writeValueAsString(messageDto)));
//        }else if(messageDto.getType() == Type.SOS_FAIL){
//            sendToEachSocket(sessions, new TextMessage(objectMapper.writeValueAsString(messageDto)));
//            sessions.remove(session);
//        }else if(messageDto.getType() == Type.MONITOR){
//
//        }else if(messageDto.getType() == Type.INFO){
//            // if 세션 안에 있다면
//            BeaconInfoDto beaconInfoDto = beaconService.giveInfo(messageDto.getBeaconId());
//            sendToEachSocket(sessions, new TextMessage(objectMapper.writeValueAsString(beaconInfoDto)));
//        }
//    }
//
//    private  void sendToEachSocket(Set<WebSocketSession> sessions, TextMessage message){
//        sessions.parallelStream().forEach( roomSession -> {
//            try {
//                System.out.println(message);
//                roomSession.sendMessage(message);
//            } catch (IOException e) {
//                e.printStackTrace();
//            }
//        });
//    }
//
//    @Override
//    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
//        log.info("** afterConnectionEstablished **");
//    }
//}
