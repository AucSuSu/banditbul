package org.banditbul.bandi.point.service;

import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.point.dto.PointDto;
import org.banditbul.bandi.point.entity.Point;
import org.banditbul.bandi.point.repository.PointRepository;
import org.banditbul.bandi.station.repository.StationRepository;
import org.banditbul.bandi.station.service.StationService;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PointService {

    private final PointRepository pointRepository;
    private final StationService stationService;
}
