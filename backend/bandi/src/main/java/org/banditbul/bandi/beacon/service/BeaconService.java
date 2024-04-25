package org.banditbul.bandi.beacon.service;

import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.beacon.dto.BeaconDto;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.beacon.repository.BeaconRepository;
import org.banditbul.bandi.beaconcoor.dto.BeaconcoorDto;
import org.banditbul.bandi.beaconcoor.service.BeaconcoorService;
import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.point.dto.PointDto;
import org.banditbul.bandi.point.entity.Point;
import org.banditbul.bandi.point.service.PointService;
import org.banditbul.bandi.screendoor.entity.Screendoor;
import org.banditbul.bandi.station.entity.Station;
import org.banditbul.bandi.station.repository.StationRepository;
import org.banditbul.bandi.toilet.entity.Toilet;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BeaconService {

    private final BeaconRepository beaconRepository;
    private final StationRepository stationRepository;
    private final PointService pointService;
    private final BeaconcoorService beaconcoorService;


//    public dto giveInfo(String beaconId){
//
//        Beacon beacon = beaconRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 beacon이 없습니다."));
//
//        // 우선 비콘ID로 해당 비콘의 시설물을 찾자
//        // 해당하는 시설물: 개찰구 gate, 화장실 toilet, 출구 exit, 계단 stair, 엘리베이터 elevator, 스크린도어 screendoor
//        String beaconType = beacon.getBeacon_type(); // toilet, gate, exit, stair, elevator, screendoor
//
//        if (beaconType.equals("toilet")){
//
//        } else if (beaconType.equals("gate")){
//
//        } else if (beaconType.equals("exit")){
//
//        } else if (beaconType.equals("stair")){
//
//        } else if (beaconType.equals("elevator")){
//
//        } else if (beaconType.equals("screendoor")){
//
//        }
//    }

    public String createBeacon(BeaconDto beaconDto){
        String beaconType = beaconDto.getBeaconType();
        Beacon beacon = new Beacon(beaconDto.getMacAddress(), beaconType);
        PointDto pointDto = new PointDto();
        pointDto.setStationId(beaconDto.getStationId());
        pointDto.setLatitude(beaconDto.getLatitude());
        pointDto.setLongitude(beaconDto.getLongitude());
        pointDto.setRange(beaconDto.getRange());
        Point point = pointService.createPoint(pointDto);

        BeaconcoorDto beaconcoorDto = new BeaconcoorDto();
        beaconcoorDto.setX(beaconDto.getX());
        beaconcoorDto.setY(beaconDto.getY());
        beaconcoorDto.setFloor(beaconDto.getFloor());
        beaconcoorDto.setStationId(beaconDto.getStationId());
        beaconcoorService.createCoor(beaconcoorDto);
        // 비콘 타입이 뭔지에 따라 다른 테이블에 저장하기.
        return "dd";

    }
}
