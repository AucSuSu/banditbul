package org.banditbul.bandi.beaconcoor.service;

import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.beaconcoor.dto.BeaconcoorDto;
import org.banditbul.bandi.beaconcoor.repository.BeaconcoorRepository;
import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.station.service.StationService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class BeaconcoorService {

    private final BeaconcoorRepository beaconcoorRepository;
    private final StationService stationService;

    public String getStationName(String beaconId){

        return beaconcoorRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 beaconcoor이 없습니다."))
                .getStation().getName();
    }

    public Beaconcoor createCoor(BeaconcoorDto dto){
        Beaconcoor beaconcoor = new Beaconcoor();
        beaconcoor.setStation(stationService.findById(dto.getStationId()));
        beaconcoor.setX(dto.getX());
        beaconcoor.setY(dto.getY());
        beaconcoor.setFloor(dto.getFloor());
        beaconcoor.setBeaconId(dto.getBeaconId());
        beaconcoorRepository.save(beaconcoor);
        return beaconcoor;
    }
}
