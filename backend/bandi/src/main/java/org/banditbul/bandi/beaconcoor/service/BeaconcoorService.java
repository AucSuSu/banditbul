package org.banditbul.bandi.beaconcoor.service;

import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.beaconcoor.dto.BeaconcoorDto;
import org.banditbul.bandi.beaconcoor.entity.Beaconcoor;
import org.banditbul.bandi.beaconcoor.repository.BeaconcoorRepository;
import org.banditbul.bandi.station.service.StationService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class BeaconcoorService {

    private final BeaconcoorRepository beaconcoorRepository;
    private final StationService stationService;

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
