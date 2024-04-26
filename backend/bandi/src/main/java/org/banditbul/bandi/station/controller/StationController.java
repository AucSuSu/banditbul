package org.banditbul.bandi.station.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.station.dto.LoginDto;
import org.banditbul.bandi.station.dto.SignUpDto;
import org.banditbul.bandi.station.service.StationService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class StationController {
    private final StationService stationService;

    @PostMapping("/signup")
    public String signUp(SignUpDto dto){
        return stationService.signUp(dto);
    }
    @PostMapping("/login")
    public String login(LoginDto dto, HttpSession session){
        return stationService.login(dto, session);
    }
}
