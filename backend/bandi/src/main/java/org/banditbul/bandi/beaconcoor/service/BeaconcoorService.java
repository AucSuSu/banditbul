package org.banditbul.bandi.beaconcoor.service;

import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.beacon.repository.BeaconRepository;
import org.banditbul.bandi.beaconcoor.dto.BeaconcoorDto;
import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.station.service.StationService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class BeaconcoorService {

    private final StationService stationService;
    private final BeaconRepository beaconRepository;

    public String getStationName(String beaconId){

        return beaconRepository.findById(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 beacon이 없습니다."))
                .getStation().getName();
    }

}
