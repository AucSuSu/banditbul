package org.banditbul.bandi.beacon.controller;

import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.beacon.service.BeaconService;
import org.banditbul.bandi.common.HttpStatusEnum;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.banditbul.bandi.common.Message;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class BeaconController {

    private final BeaconService beaconService;

    @GetMapping("/sos/{beaconId}")
    public ResponseEntity<Message> sendSos(@PathVariable(value = "beaconId") String beaconId){
        Message message = new Message(HttpStatusEnum.OK, "sos 전달 완료", beaconId);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }

    @GetMapping("/beacon/info/{beaconId}")
    public ResponseEntity<Message> getBeaconInfo(@PathVariable(value = "beaconId") String beaconId){

        // 어떤 시설물인지에 따라서 각자의 dto 만들어서 해당 dto를 보내줘야함
        // 여러 dto 클래스들이 구현하는 공통 인터페이스인 BeaconInfoDto를 사용해 메소드가 일관된 타입을 반환하도록 보장
        BeaconInfoDto beaconInfoDto = beaconService.giveInfo(beaconId);
        Message message = new Message(HttpStatusEnum.OK, "비콘 시설물 출력 완료", beaconInfoDto);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }


}
