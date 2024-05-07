
package org.banditbul.bandi.edge.controller;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.common.Dir;
import org.banditbul.bandi.common.HttpStatusEnum;
import org.banditbul.bandi.common.Message;
import org.banditbul.bandi.edge.dto.EdgeDto;
import org.banditbul.bandi.edge.dto.ResultRouteDto;
import org.banditbul.bandi.edge.service.EdgeService;
import org.banditbul.bandi.station.dto.StationSessionDto;
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
    public ResponseEntity<Message> getNavigation(@RequestParam("beaconId") String beaconId,
                                                 @RequestParam("destStation") String destStation){
        // 1. 해당 역에서 개찰구까지 경로 추천
        ResultRouteDto dto = edgeService.navCurStation(beaconId, destStation);
        Message message = new Message(HttpStatusEnum.OK, "길 찾기 완료", dto);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
    @GetMapping("/navigation/toilet")
    public ResponseEntity<Message> getToiletNavigation(@RequestParam("beaconId") String beacon_id){

        ResultRouteDto resultRouteDto = edgeService.navToilet(beacon_id);
        Message message = new Message(HttpStatusEnum.OK, "화장실까지 길 찾기 완료", resultRouteDto);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
    @PostMapping("/edge")
    public ResponseEntity<Message> addEdge(@RequestBody EdgeDto dto, HttpSession session){
        StationSessionDto user = (StationSessionDto) session.getAttribute("user");
        dto.setStationId(user.getId());
        Integer edgeId = edgeService.addEdge(dto);
        Message message = new Message(HttpStatusEnum.OK, "간선 생성 완료", edgeId + "meter");
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
}
