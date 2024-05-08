package org.banditbul.bandi.station.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.common.HttpStatusEnum;
import org.banditbul.bandi.common.Message;
import org.banditbul.bandi.station.dto.LoginDto;
import org.banditbul.bandi.station.dto.SignUpDto;
import org.banditbul.bandi.station.service.StationService;
import org.banditbul.bandi.test.SOSService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class StationController {
    private final StationService stationService;
    private final SOSService sosService;

    @PostMapping("/signup")
    public ResponseEntity<Message> signUp(SignUpDto dto){
        String loginId = stationService.signUp(dto);
        Message message = new Message(HttpStatusEnum.OK, "회원가입 완료", loginId);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
    @PostMapping("/login")
    public ResponseEntity<Message> login(LoginDto dto, HttpSession session){
        String sessionId = stationService.login(dto, session);
        Message message = new Message(HttpStatusEnum.OK, "로그인 완료", sessionId);
        sosService.createRoom(dto.getLoginId());
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
    @PostMapping("/logout")
    public ResponseEntity<Message> logout(HttpSession session) {
        // 세션에서 "user"라는 속성을 제거
        String m = stationService.logout(session);
        Message message = new Message(HttpStatusEnum.OK, "로그아웃 완료", m);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
}
