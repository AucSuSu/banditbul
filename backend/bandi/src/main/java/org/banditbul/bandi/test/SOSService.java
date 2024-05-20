package org.banditbul.bandi.test;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;

@Slf4j
@RequiredArgsConstructor
@Service
public class SOSService { // 세션 관리 및 생성 로직 처리
    private static final Logger LOGGER = Logger.getLogger(SOSSession.class.getName());

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
        SOSSession session = SessionS.get(sessionId);
        if (session != null) {
            LOGGER.info("Session found with ID: " + sessionId);
            return session;
        } else {
            LOGGER.warning("No session found for ID: " + sessionId);
            return null;
        }
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
        if (lastBeaconId != null) {
            if (!lastBeaconId.equals(newBeaconId)) {
                // 사용자가 이전 비콘에서 새 비콘으로 이동한 경우, 이전 비콘의 사용자 수를 감소시키고 새 비콘의 사용자 수를 증가시킵니다.
                decrementUserCount(lastBeaconId);
                incrementUserCount(newBeaconId);
                userLastBeacon.put(userId, newBeaconId);
            }
            // 만약 같은 비콘에 재입장하는 경우는 카운트 변경을 하지 않습니다.
        } else {
            // lastBeaconId가 null인 경우는 사용자가 처음 비콘에 접속한 상황입니다.
            incrementUserCount(newBeaconId);
            userLastBeacon.put(userId, newBeaconId);
        }
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

    // 앱 종료 시 모니터링에 반영
    public void removeUserFromBeacon(String userId) {
        String lastBeaconId = userLastBeacon.remove(userId);
        if (lastBeaconId != null) {
            decrementUserCount(lastBeaconId);
        }
    }
}
