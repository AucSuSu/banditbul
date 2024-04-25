package org.banditbul.bandi.beacon.controller;

import lombok.RequiredArgsConstructor;
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

    @GetMapping("/sos")
    public ResponseEntity<Message> sendSos(@PathVariable(value = "beaconId") String beaconId){

        Message message = new Message(HttpStatusEnum.OK, "sos 전달 완료", beaconId);
        return new ResponseEntity<>(message, HttpStatus.OK);
    }


}
