package org.banditbul.bandi.edge.controller;

import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.common.Dir;
import org.banditbul.bandi.common.HttpStatusEnum;
import org.banditbul.bandi.common.Message;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class EdgeController {

    @GetMapping("/navigation")
    public ResponseEntity<Message> getNavigation(@RequestParam("beacon_id") String beacon_id,
                                                 @RequestParam("destStation") String destStation,
                                                 @RequestParam("destExitNum") int destExitNum){
        // 1. 현재 역 파악 - 비콘 id로 들어옴
        // 2. 해당 역에서 개찰구까지 경로 추천
        // 3. 목적지 역에서 개찰구에서 출구까지

        List<Dir> nav = new ArrayList<>();
        Message message = new Message(HttpStatusEnum.OK, "까지 길 찾기 완료", nav);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }


}
