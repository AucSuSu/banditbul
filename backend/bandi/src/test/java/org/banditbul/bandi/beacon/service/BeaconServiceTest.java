package org.banditbul.bandi.beacon.service;

import jakarta.transaction.Transactional;
import org.banditbul.bandi.beacon.dto.BeaconDto;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;
import org.banditbul.bandi.beacon.dto.FloorInfoDto;
import org.banditbul.bandi.beacon.dto.IndvBeacon;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.beacon.entity.BeaconTYPE;
import org.banditbul.bandi.beacon.repository.BeaconRepository;
import org.banditbul.bandi.common.Dir;
import org.banditbul.bandi.edge.dto.IndvEdge;
import org.banditbul.bandi.edge.entity.Edge;
import org.banditbul.bandi.edge.repository.EdgeRepository;
import org.banditbul.bandi.elevator.entity.Elevator;
import org.banditbul.bandi.elevator.repository.ElevatorRepository;
import org.banditbul.bandi.exit.dto.ExitDto;
import org.banditbul.bandi.exit.entity.Exit;
import org.banditbul.bandi.exit.repository.ExitRepository;
import org.banditbul.bandi.gate.entity.Gate;
import org.banditbul.bandi.gate.repository.GateRepository;
import org.banditbul.bandi.point.entity.Point;
import org.banditbul.bandi.point.repository.PointRepository;

import org.banditbul.bandi.screendoor.entity.Screendoor;
import org.banditbul.bandi.screendoor.repository.ScreendoorRepository;
import org.banditbul.bandi.stair.entity.Stair;
import org.banditbul.bandi.stair.repository.StairRepository;
import org.banditbul.bandi.station.entity.Station;
import org.banditbul.bandi.station.repository.StationRepository;
import org.banditbul.bandi.toilet.entity.Toilet;
import org.banditbul.bandi.toilet.repository.ToiletRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;

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
    private ToiletRepository toiletRepository;
    @Autowired
    private GateRepository gateRepository;
    @Autowired
    private StairRepository stairRepository;
    @Autowired
    private ElevatorRepository elevatorRepository;
    @Autowired
    private ScreendoorRepository screendoorRepository;
    @Autowired
    private EdgeRepository edgeRepository;


    private BeaconDto beaconDto;

    @Test
    @Transactional
    @DisplayName("비콘 삭제 테스트")
    void testDeleteBeacon(){
        // Given
        Station hadanstation = stationRepository.save(new Station("하단역", "ice98", "123123", 1));

        Beacon beacon = beaconRepository.save(new Beacon("출구용 비콘",hadanstation, 1,1, 1, 37.5665, 126.9780, 50,BeaconTYPE.EXIT));
        String beaconId = beacon.getId();
        Beacon beacon2 = beaconRepository.save(new Beacon("화장실용 비콘",hadanstation, 1,2, 1, 37.5665, 126.9780, 50,BeaconTYPE.TOILET));
        Beacon beacon3 = beaconRepository.save(new Beacon("개찰구용 비콘",hadanstation, 1,3, 1, 37.5665, 126.9780, 50,BeaconTYPE.GATE));

        Exit exit = exitRepository.save(new Exit(beacon, 3, "제나우스", null, Dir.L, Dir.R));
        Toilet toilet = toiletRepository.save(new Toilet(beacon2, Dir.R, null));
        Gate gate = gateRepository.save(new Gate(beacon3, true, Dir.F, null, Dir.R));

        Edge edge1 = edgeRepository.save(new Edge(beacon, beacon2, 20, hadanstation));
        Edge edge2 = edgeRepository.save(new Edge(beacon, beacon3, 40, hadanstation));

        System.out.println(edgeRepository.findByBeacon1_IdOrBeacon2_Id(beacon.getId(), beacon.getId()));
        // When
        beaconService.deleteBeacon(beacon.getId());

        // Then

        Optional<Beacon> deletedBeacon = beaconRepository.findById(beaconId);
        Optional<Exit> deletedExit =  exitRepository.findById(exit.getId());
        List<Edge> deletedEdge = edgeRepository.findByBeacon1_IdOrBeacon2_Id(beaconId, beaconId);

        assertFalse(deletedBeacon.isPresent());
        assertFalse(deletedExit.isPresent());
        assertTrue(deletedEdge.isEmpty());
    }


    @Test
    @Transactional
    @DisplayName("특정 역 및 층 출력 확인 테스트")
    void testGetFloorInfoDto(){

        // Given
        Station hadanstation = stationRepository.save(new Station("하단역", "ice98", "123123", 1));
        Station dadaestation = stationRepository.save(new Station("다대포역", "ice98", "123123", 1));

        Beacon beacon = beaconRepository.save(new Beacon("출구용 비콘",hadanstation, 1,1, 1, 37.5665, 126.9780, 50,BeaconTYPE.EXIT));
        Beacon beacon2 = beaconRepository.save(new Beacon("화장실용 비콘",hadanstation, 1,2, 1, 37.5665, 126.9780, 50,BeaconTYPE.TOILET));
        Beacon beacon3 = beaconRepository.save(new Beacon("개찰구용 비콘",hadanstation, 1,3, 1, 37.5665, 126.9780, 50,BeaconTYPE.GATE));
        Beacon beacon4 = beaconRepository.save(new Beacon("계단용 비콘",hadanstation, 1,1, 2, 37.5665, 126.9780, 50,BeaconTYPE.STAIR));
        Beacon beacon5 = beaconRepository.save(new Beacon("엘베용 비콘",dadaestation, 1,1, 1, 37.5665, 126.9780, 50,BeaconTYPE.ELEVATOR));
        Beacon beacon6 = beaconRepository.save(new Beacon("스크린도어용 비콘",dadaestation, 1,1, 1, 37.5665, 126.9780, 50,BeaconTYPE.SCREENDOOR));

        Exit exit = exitRepository.save(new Exit(beacon, 3, "제나우스", null, Dir.L, Dir.R));
        Toilet toilet = toiletRepository.save(new Toilet(beacon2, Dir.R, null));
        Gate gate = gateRepository.save(new Gate(beacon3, true, Dir.F, null, Dir.R));
        Stair stair = stairRepository.save(new Stair(beacon4, true));
        Elevator elevator = elevatorRepository.save(new Elevator(beacon5, false));
        Screendoor screendoor = screendoorRepository.save(new Screendoor(beacon6, "상행선으로 가는 5-4"));

        // hadanstation: beacon3-beacon-beacon2
        Edge edge1 = edgeRepository.save(new Edge(beacon, beacon2, 20, hadanstation));
        Edge edge2 = edgeRepository.save(new Edge(beacon, beacon3, 40, hadanstation));

        // dadaestation: beacon5-beacon6
        Edge edge3 = edgeRepository.save(new Edge(beacon5, beacon6, 30, dadaestation));

        // When
        FloorInfoDto floorInfoDto = beaconService.getFloorInfoDto(1, hadanstation.getId());

        // Then
        List<IndvBeacon> expectedBeacons = List.of(new IndvBeacon(beacon.getId(), beacon.getX(), beacon.getY(), beacon.getBeaconType()),
                new IndvBeacon(beacon2.getId(), beacon2.getX(), beacon2.getY(), beacon2.getBeaconType()), new IndvBeacon(beacon3.getId(), beacon3.getX(), beacon3.getY(), beacon3.getBeaconType()));
        List<IndvEdge> expectedEdges = List.of(new IndvEdge(edge1.getBeacon1().getId(), edge1.getBeacon2().getId(), edge1.getId(), edge1.getBeacon1().getBeaconType(), edge1.getBeacon2().getBeaconType()),
                new IndvEdge(edge2.getBeacon1().getId(), edge2.getBeacon2().getId(), edge2.getId(), edge2.getBeacon1().getBeaconType(), edge2.getBeacon2().getBeaconType()));

        String expectedImageUrl = "https://d3h25rphev0vuf.cloudfront.net/"+hadanstation.getName()+"1.png";
        assertEquals(expectedBeacons, floorInfoDto.getBeaconList(), "Beacon list should match expected");
        for (IndvEdge i : expectedEdges) {
            System.out.println(i.getEdgeId());
        }
        System.out.println("================");
        for (IndvEdge i: floorInfoDto.getEdgeList()){
            System.out.println(i.getEdgeId());
        }
        assertEquals(expectedEdges, floorInfoDto.getEdgeList(), "Edge list should match expected");
        assertEquals(expectedImageUrl, floorInfoDto.getMapImageUrl(), "Image URL should match expected");
    }


    @Test
    @Transactional
    @DisplayName("시설물 안내 테스트")
    void testGetBeaconInfo(){
        // Given: 데이터 저장
        Station station = stationRepository.save(new Station("하단역", "ice98", "123123", 1));
        Beacon beacon = beaconRepository.save(new Beacon("출구용 비콘",station, 1,1, 1, 37.5665, 126.9780, 50,BeaconTYPE.EXIT));
        Beacon beacon2 = beaconRepository.save(new Beacon("화장실용 비콘",station, 1,1, 1, 37.5665, 126.9780, 50,BeaconTYPE.TOILET));
        Beacon beacon3 = beaconRepository.save(new Beacon("개찰구용 비콘",station, 1,1, 1, 37.5665, 126.9780, 50,BeaconTYPE.GATE));
        Beacon beacon4 = beaconRepository.save(new Beacon("계단용 비콘",station, 1,1, 1, 37.5665, 126.9780, 50,BeaconTYPE.STAIR));
        Beacon beacon5 = beaconRepository.save(new Beacon("엘베용 비콘",station, 1,1, 1, 37.5665, 126.9780, 50,BeaconTYPE.ELEVATOR));
        Beacon beacon6 = beaconRepository.save(new Beacon("스크린도어용 비콘",station, 1,1, 1, 37.5665, 126.9780, 50,BeaconTYPE.SCREENDOOR));


        Exit exit = exitRepository.save(new Exit(beacon, 3, "제나우스", null, Dir.L, Dir.R));
        Toilet toilet = toiletRepository.save(new Toilet(beacon2, Dir.R, null));
        Gate gate = gateRepository.save(new Gate(beacon3, true, Dir.F, null, Dir.R));
        Stair stair = stairRepository.save(new Stair(beacon4, true));
        Elevator elevator = elevatorRepository.save(new Elevator(beacon5, false));
        Screendoor screendoor = screendoorRepository.save(new Screendoor(beacon6, "상행선으로 가는 5-4"));

        // When
        System.out.println(beaconService.giveInfo(beacon.getId()));
        System.out.println(beaconService.giveInfo(beacon2.getId()));
        System.out.println(beaconService.giveInfo(beacon3.getId()));
        System.out.println(beaconService.giveInfo(beacon4.getId()));
        System.out.println(beaconService.giveInfo(beacon5.getId()));
        System.out.println(beaconService.giveInfo(beacon6.getId()));



        // Then
        assertEquals(beacon.getId(), exit.getBeacon().getId());

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
                .beaconType(BeaconTYPE.TOILET)
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