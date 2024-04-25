package org.banditbul.bandi.screendoor.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.banditbul.bandi.common.HttpStatusEnum;
import org.banditbul.bandi.common.Message;
import org.banditbul.bandi.screendoor.Service.ScreendoorService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
@Slf4j
public class ScreendoorController {

    private final ScreendoorService screendoorService;
    @GetMapping("/stationinfo/{beaconId}")
    public ResponseEntity<Message> getStationName(@PathVariable(value = "beaconId") String beaconId){

        String stationName = screendoorService.getStationName(beaconId);
        Message message = new Message(HttpStatusEnum.OK, stationName + " 역 이름 출력 완료", stationName);
        return new ResponseEntity<>(message, HttpStatus.OK);

    }

}
