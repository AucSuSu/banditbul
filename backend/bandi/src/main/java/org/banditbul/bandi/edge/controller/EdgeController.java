
package org.banditbul.bandi.edge.controller;
import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.common.Dir;
import org.banditbul.bandi.common.HttpStatusEnum;
import org.banditbul.bandi.common.Message;
import org.banditbul.bandi.edge.dto.EdgeDto;
import org.banditbul.bandi.edge.service.EdgeService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.ArrayList;
import java.util.List;
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class EdgeController {
    private final EdgeService edgeService;
    @GetMapping("/navigation")
    public ResponseEntity<Message> getNavigation(@RequestParam("beacon_id") String beacon_id,
                                                 @RequestParam("destStation") String destStation){
        // 1. 현재 역 파악 - 비콘 id로 들어옴
        // 2. 해당 역에서 개찰구까지 경로 추천
        // 3. 목적지 역에서 개찰구에서 출구까지
        // destStation에서 몇번역 몇번출구가 들어옴
        List<Dir> nav = new ArrayList<>();
        Message message = new Message(HttpStatusEnum.OK, "까지 길 찾기 완료", nav);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
    @GetMapping("/nav/toilet")
    public ResponseEntity<Message> getToiletNavigation(@RequestParam("beacon_id") String beacon_id){
        List<Dir> nav = new ArrayList<>();
        Message message = new Message(HttpStatusEnum.OK, "화장실까지 길 찾기 완료", nav);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
    @PostMapping("/edge")
    public ResponseEntity<Message> addEdge(@RequestBody EdgeDto dto){
        Integer edgeId = edgeService.addEdge(dto);
        Message message = new Message(HttpStatusEnum.OK, "간선 생성 완료", edgeId);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
}
