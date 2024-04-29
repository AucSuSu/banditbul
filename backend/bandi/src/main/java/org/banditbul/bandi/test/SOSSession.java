package org.banditbul.bandi.test;

import lombok.Builder;
import lombok.Data;
import org.springframework.web.socket.WebSocketSession;

import java.util.HashSet;
import java.util.Set;
// dev
@Data
public class SOSSession {

    private String sessionId;
    private Set<WebSocketSession> sessions = new HashSet<>();
    @Builder
    public SOSSession(String sessionId) {
        this.sessionId = sessionId;
    }
}
