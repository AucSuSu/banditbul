package org.banditbul.bandi.beacon.service;

import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import org.banditbul.bandi.beacon.dto.BeaconDto;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.beacon.repository.BeaconRepository;
import org.banditbul.bandi.beaconcoor.dto.BeaconcoorDto;
import org.banditbul.bandi.beaconcoor.entity.Beaconcoor;
import org.banditbul.bandi.beaconcoor.service.BeaconcoorService;
import org.banditbul.bandi.common.Dir;
import org.banditbul.bandi.exit.dto.ExitDto;
import org.banditbul.bandi.exit.entity.Exit;
import org.banditbul.bandi.exit.repository.ExitRepository;
import org.banditbul.bandi.point.dto.PointDto;
import org.banditbul.bandi.point.entity.Point;
import org.banditbul.bandi.point.repository.PointRepository;
import org.banditbul.bandi.point.service.PointService;

import org.banditbul.bandi.station.entity.Station;
import org.banditbul.bandi.station.repository.StationRepository;
import org.banditbul.bandi.station.service.StationService;
import org.banditbul.bandi.toilet.entity.Toilet;
import org.banditbul.bandi.toilet.repository.ToiletRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

//test
@SpringBootTest
@ActiveProfiles("test")
class BeaconServiceTest {

    @Autowired
    private BeaconService beaconService;
    @Autowired
    private StationRepository stationRepository;
    @Autowired
    private ExitRepository exitRepository;
    @Autowired
    private BeaconRepository beaconRepository;
    @Autowired
    private PointRepository pointRepository;

    private BeaconDto beaconDto;


    @Test
    @Transactional
    @DisplayName("시설물 안내 테스트")
    void testGetBeaconInfo(){
        // Given: 데이터 저장
        Station station = stationRepository.save(new Station("하단역", "ice98", "123123", 1));
        Beacon beacon = beaconRepository.save(new Beacon("하단역 3번출구 비콘","exit"));
        Point point = pointRepository.save(new Point(station, 37.5665, 126.9780, 50));
        Exit exit = exitRepository.save(new Exit(beacon, point, 3, "제나우스", null, Dir.L, Dir.R));
        ExitDto exitDto = ExitDto.builder()
                        .exitNum(exit.getNumber())
                        .landmark(exit.getLandmark())
                        .elevator(exit.getElevator())
                        .escalator(exit.getEscalator())
                        .stair(exit.getStair())
                        .build();

        // When
        BeaconInfoDto beaconInfoDto = beaconService.giveInfo(beacon.getId());

        // Then
        assertEquals(beaconInfoDto, exitDto);

    }

    @Test
    @Transactional
    @DisplayName("beacon 생성 테스트(toilet)")
    void testCreateBeaconToiletType() {
        // Given
        Station save = stationRepository.save(new Station("하단역", "ice98", "123123", 1));
        System.out.println(save.getId());
        // BeaconDto 설정
        beaconDto = BeaconDto.builder()
                .macAddress("00:11:22:33:44:54")
                .stationId(save.getId())
                .latitude(37.5665)
                .longitude(126.9780)
                .range(100)
                .beaconType("toilet")
                .isUp(true)
                .manDir(Dir.L)
                .womanDir(Dir.R)
                .number(5)
                .landmark("Near Gate 3")
                .elevator(Dir.R)
                .escalator(Dir.L)
                .stair(Dir.F)
                .direction("서면방면 3-3차")
                .x(200)
                .y(150)
                .floor(2)
                .build();
        // When
        String beaconId = beaconService.createBeacon(beaconDto);

        // Then
        assertEquals(beaconDto.getMacAddress(), beaconId);
    }

}