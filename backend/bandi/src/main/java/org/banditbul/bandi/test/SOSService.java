package org.banditbul.bandi.test;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.Map;
@Slf4j
@RequiredArgsConstructor
@Service
public class SOSService {

    private final ObjectMapper objectMapper;
    private Map<String, SOSSession> SessionS;
    @PostConstruct
    private void init() {
        SessionS = new LinkedHashMap<>();
    }

    public SOSSession findBySessionId(String sessionId) {
        return SessionS.get(sessionId);
    }

    public SOSSession createRoom(String sessionId) {
        SOSSession chatRoom = SOSSession.builder()
                .sessionId(sessionId)
                .build();

        SessionS.put(sessionId, chatRoom);
        return chatRoom;
    }

}
