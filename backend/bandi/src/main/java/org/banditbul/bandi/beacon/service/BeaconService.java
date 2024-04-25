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
