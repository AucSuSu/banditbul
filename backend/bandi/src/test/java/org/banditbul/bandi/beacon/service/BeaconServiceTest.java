package org.banditbul.bandi.beacon.service;

import org.banditbul.bandi.beacon.dto.BeaconDto;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.beacon.repository.BeaconRepository;
import org.banditbul.bandi.beaconcoor.dto.BeaconcoorDto;
import org.banditbul.bandi.beaconcoor.entity.Beaconcoor;
import org.banditbul.bandi.beaconcoor.service.BeaconcoorService;
import org.banditbul.bandi.common.Dir;
import org.banditbul.bandi.point.dto.PointDto;
import org.banditbul.bandi.point.entity.Point;
import org.banditbul.bandi.point.service.PointService;

import org.banditbul.bandi.toilet.entity.Toilet;
import org.banditbul.bandi.toilet.repository.ToiletRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(SpringExtension.class)
class BeaconServiceTest {

    @Mock
    private BeaconRepository beaconRepository;
    @Mock
    private ToiletRepository toiletRepository;
    @Mock
    private PointService pointService;
    @Mock
    private BeaconcoorService beaconcoorService;
    @InjectMocks
    private BeaconService beaconService;

    private BeaconDto beaconDto;
    private Beacon beacon;
    private Point point;
    private Beaconcoor coor;

    @BeforeEach
    void setUp() {
        // BeaconDto 설정
        beaconDto = BeaconDto.builder()
                .macAddress("00:11:22:33:44:55")
                .stationId(1)
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

        // Beacon, Point, Beaconcoor 객체 생성 및 목 설정
        beacon = new Beacon(beaconDto.getMacAddress(), beaconDto.getBeaconType());
        point = new Point();
        coor = new Beaconcoor();

        // 리포지토리 및 서비스 목 동작 정의
        when(beaconRepository.save(any(Beacon.class))).thenReturn(beacon);
        when(pointService.createPoint(any(PointDto.class))).thenReturn(point);
        when(beaconcoorService.createCoor(any(BeaconcoorDto.class))).thenReturn(coor);
    }

    @Test
    @DisplayName("beacon 생성 테스트(toilet)")
    void testCreateBeaconToiletType() {
        // Given
        when(toiletRepository.save(any(Toilet.class))).thenReturn(new Toilet());

        // When
        String result = beaconService.createBeacon(beaconDto);

        // Then
        assertEquals(beacon.getId(), result);
        verify(toiletRepository).save(any(Toilet.class));
        verify(beaconRepository).save(any(Beacon.class));
        verify(pointService).createPoint(any(PointDto.class));
        verify(beaconcoorService).createCoor(any(BeaconcoorDto.class));
    }

}