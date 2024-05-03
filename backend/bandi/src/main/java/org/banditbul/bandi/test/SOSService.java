package org.banditbul.bandi.test;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@RequiredArgsConstructor
@Service
public class SOSService { // 세션 관리 및 생성 로직 처리

    private final ObjectMapper objectMapper;
    private Map<String, SOSSession> SessionS; // 세션id와 sossession 객체 매핑
    private Map<String, Integer> beaconUserCounts; // 비콘 ID를 키로 하고, 해당 비콘에 연결된 사용자 수를 값으로 하는 맵
    private Map<String, String> userLastBeacon;  // 사용자가 가지는 현재 비콘 아이디를 저장


    @PostConstruct
    private void init() {
        SessionS = new ConcurrentHashMap<>();
        beaconUserCounts = new ConcurrentHashMap<>();
        userLastBeacon = new ConcurrentHashMap<>();
    }   //멀티스레드 환경

    //sessionId로 존재하는 방 찾기
    public SOSSession findBySessionId(String sessionId) {
        return SessionS.get(sessionId);
    }

    //sessionId에 해당하는 방 만들기
    public SOSSession createRoom(String sessionId) {
        // SessionS Map에서 sessionId에 해당하는 SOSSession을 조회합니다.
        SOSSession chatRoom = SessionS.get(sessionId);

        // chatRoom이 null이 아니라면 이미 방이 존재한다는 의미이므로, 해당 방을 반환합니다.
        if (chatRoom != null) {
            return chatRoom;
        }

        // 만약 null이라면 새로운 방을 생성합니다.
        chatRoom = SOSSession.builder()
                .sessionId(sessionId)
                .build();

        // 새로 생성한 방을 Map에 추가합니다.
        SessionS.put(sessionId, chatRoom);

        // 새로 생성된 방을 반환합니다.
        return chatRoom;
    }

    public void updateUserBeacon(String userId, String newBeaconId) {
        String lastBeaconId = userLastBeacon.get(userId);
        if (lastBeaconId != null && !lastBeaconId.equals(newBeaconId)) {
            decrementUserCount(lastBeaconId);
        }
        incrementUserCount(newBeaconId);
        userLastBeacon.put(userId, newBeaconId);
    }

    public void incrementUserCount(String beaconId) {
        beaconUserCounts.merge(beaconId, 1, Integer::sum);
    }

    public void decrementUserCount(String beaconId) {
        beaconUserCounts.computeIfPresent(beaconId, (key, count) -> (count > 1) ? count - 1 : null);
    }

    // 모든 비콘에 대한 사용자 수를 반환
    public Map<String, Integer> getAllBeaconUserCounts() {
        return new ConcurrentHashMap<>(beaconUserCounts);
    }
}
