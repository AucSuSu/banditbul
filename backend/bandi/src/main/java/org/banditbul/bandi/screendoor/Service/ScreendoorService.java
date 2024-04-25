package org.banditbul.bandi.screendoor.Service;

import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.exception.StationNotFoundException;
import org.banditbul.bandi.screendoor.repository.ScreendoorRepository;
import org.banditbul.bandi.station.entity.Station;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ScreendoorService {

    private final ScreendoorRepository screendoorRepository;

    public String getStationName(String beaconId){

        return "hello";
    }

}
