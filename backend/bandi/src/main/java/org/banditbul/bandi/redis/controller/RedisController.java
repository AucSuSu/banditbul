package org.banditbul.bandi.redis.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RedisController {

    @PostMapping("/session")
    public String sessionTest(HttpSession httpSession) {
        String id = "test321";
        httpSession.setAttribute("sessionID", id);
        return "session TEST";
    }
}
