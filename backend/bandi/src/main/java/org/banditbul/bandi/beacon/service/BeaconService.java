package org.banditbul.bandi.beacon.service;

import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.beacon.dto.BeaconDto;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.beacon.repository.BeaconRepository;
import org.banditbul.bandi.point.entity.Point;
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

    public String createBeacon(BeaconDto beaconDto){
        String beaconType = beaconDto.getBeaconType();
        Beacon beacon = new Beacon(beaconDto.getMacAddress(), beaconType);
        Station station = stationRepository.findById(beaconDto.getStationId());
        Point point = new Point(station, beaconDto.getLatitude(), beaconDto.getLongitude(), beaconDto.get)
        // 비콘 타입이 뭔지에 따라 다른 테이블에 저장하기.
        if( beaconType.equals("toilet")){

            new Toilet(beacon, )
        }

    }
}
