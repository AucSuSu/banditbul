
package org.banditbul.bandi.beacon.controller;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.banditbul.bandi.beacon.dto.BeaconDto;
import org.banditbul.bandi.beacon.dto.FloorInfoDto;
import org.banditbul.bandi.beacon.dto.SosDto;
import org.banditbul.bandi.beacon.service.BeaconService;
import org.banditbul.bandi.common.HttpStatusEnum;
import org.banditbul.bandi.station.dto.StationSessionDto;
import org.banditbul.bandi.station.service.StationService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.banditbul.bandi.common.Message;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@Slf4j
public class BeaconController {
    private final BeaconService beaconService;
    private final StationService stationService;

    @DeleteMapping("/beacon/{beaconId}")
    public ResponseEntity<Message> deleteBeacon(@PathVariable(value = "beaconId") String beaconId){
        beaconService.deleteBeacon(beaconId);
        Message message = new Message(HttpStatusEnum.OK,  "비콘 삭제 완료", beaconId);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }

    @GetMapping("/stationinfo/{beaconId}")
    public ResponseEntity<Message> getStationName(@PathVariable(value = "beaconId") String beaconId){

        String stationName = beaconService.getStationName(beaconId);
        Message message = new Message(HttpStatusEnum.OK, stationName + " 역 이름 출력 완료", stationName);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
    @GetMapping("/beaconlist/{floor}")
    public ResponseEntity<Message> getBeaconList(@PathVariable(value = "floor") int floor, HttpSession session){
        StationSessionDto user = (StationSessionDto) session.getAttribute("user");
        FloorInfoDto floorInfoDto = beaconService.getFloorInfoDto(floor, user.getId());
        Message message = new Message(HttpStatusEnum.OK, "해당 역의 해당 층의 비콘 및 엣지 리스트 전달 완료", floorInfoDto);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
    @GetMapping("/sos/{beaconId}")
    public ResponseEntity<Message> sendSos(@PathVariable(value = "beaconId") String beaconId){
        int stationId = beaconService.getStationId(beaconId);
        String loginId = stationService.findLoginId(stationId);
        SosDto sosDto = SosDto.builder().sessionId(loginId).build();
        Message message = new Message(HttpStatusEnum.OK, "sos 전달 완료", sosDto);
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
        log.info("beacon 추가 컨트롤러 시작");

        StationSessionDto user = (StationSessionDto) session.getAttribute("user");
        System.out.println("유저 확인");
        System.out.println(user);
        // 어떤 시설물인지에 따라서 각자의 dto 만들어서 해당 dto를 보내줘야함
        // 여러 dto 클래스들이 구현하는 공통 인터페이스인 BeaconInfoDto를 사용해 메소드가 일관된 타입을 반환하도록 보장
        dto.setStationId(user.getId());
        String beacon = beaconService.createBeacon(dto);
        Message message = new Message(HttpStatusEnum.OK, "비콘 등록", beacon);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }
}
