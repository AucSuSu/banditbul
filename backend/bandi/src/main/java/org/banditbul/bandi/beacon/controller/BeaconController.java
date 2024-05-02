
package org.banditbul.bandi.beacon.controller;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.beacon.dto.BeaconDto;
import org.banditbul.bandi.beacon.dto.FloorInfoDto;
import org.banditbul.bandi.beacon.service.BeaconService;
import org.banditbul.bandi.common.HttpStatusEnum;
import org.banditbul.bandi.station.dto.StationSessionDto;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.banditbul.bandi.common.Message;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class BeaconController {
    private final BeaconService beaconService;

    @GetMapping("/beaconlist")
    public ResponseEntity<Message> getBeaconList(@PathVariable(value = "floor") int floor, HttpSession session){
        StationSessionDto user = (StationSessionDto) session.getAttribute("user");
        FloorInfoDto floorInfoDto = beaconService.getFloorInfoDto(floor, user.getId());
        Message message = new Message(HttpStatusEnum.OK, "해당 역의 해당 층의 비콘 및 엣지 리스트 전달 완료", floorInfoDto);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
    @GetMapping("/sos/{beaconId}")
    public ResponseEntity<Message> sendSos(@PathVariable(value = "beaconId") String beaconId){
        int stationId = beaconService.getStationId(beaconId);
        Message message = new Message(HttpStatusEnum.OK, "sos 전달 완료", stationId);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
    @GetMapping("/beacon/info/{beaconId}")
    public ResponseEntity<Message> getBeaconInfo(@PathVariable(value = "beaconId") String beaconId){
        // 어떤 시설물인지에 따라서 각자의 dto 만들어서 해당 dto를 보내줘야함
        // 여러 dto 클래스들이 구현하는 공통 인터페이스인 BeaconInfoDto를 사용해 메소드가 일관된 타입을 반환하도록 보장
        String beaconInfoDto = beaconService.giveInfo(beaconId);
        Message message = new Message(HttpStatusEnum.OK, "비콘 시설물 출력 완료", beaconInfoDto);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
    @PostMapping("/beacon")
    public ResponseEntity<Message> addBeacon(@RequestBody BeaconDto dto, HttpSession session){
        StationSessionDto user = (StationSessionDto) session.getAttribute("user");
        // 어떤 시설물인지에 따라서 각자의 dto 만들어서 해당 dto를 보내줘야함
        // 여러 dto 클래스들이 구현하는 공통 인터페이스인 BeaconInfoDto를 사용해 메소드가 일관된 타입을 반환하도록 보장
        dto.setStationId(user.getId());
        String beacon = beaconService.createBeacon(dto);
        Message message = new Message(HttpStatusEnum.OK, "비콘 등록", beacon);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
}
