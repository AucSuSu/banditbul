package org.banditbul.bandi.screendoor.Service;

import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.point.entity.Point;
import org.banditbul.bandi.screendoor.entity.Screendoor;
import org.banditbul.bandi.screendoor.repository.ScreendoorRepository;
import org.banditbul.bandi.station.entity.Station;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ScreendoorService {

    private final ScreendoorRepository screendoorRepository;

    public String getStationName(String beaconId){

        Screendoor screendoor = screendoorRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 screendoor 가 없습니다."));
        String stationName = screendoor.getPoint().getStation().getName();

        return stationName;
    }

}
