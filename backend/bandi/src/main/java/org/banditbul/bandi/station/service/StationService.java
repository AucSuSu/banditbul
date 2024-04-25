package org.banditbul.bandi.station.service;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.point.entity.Point;
import org.banditbul.bandi.station.entity.Station;
import org.banditbul.bandi.station.repository.StationRepository;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class StationService {
    private final StationRepository stationRepository;

    @Transactional
    public Station findById(int stationId){
        return stationRepository.findById(stationId).orElseThrow(() -> new EntityNotFoundException("해당하는 station이 없습니다."));
    }
}
