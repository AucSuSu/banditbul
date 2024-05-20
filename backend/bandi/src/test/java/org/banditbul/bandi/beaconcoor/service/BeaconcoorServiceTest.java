//package org.banditbul.bandi.beaconcoor.service;
//
//import jakarta.transaction.Transactional;
//import org.banditbul.bandi.beacon.entity.Beacon;
//import org.banditbul.bandi.beacon.entity.BeaconTYPE;
//import org.banditbul.bandi.beacon.repository.BeaconRepository;
//import org.banditbul.bandi.station.entity.Station;
//import org.banditbul.bandi.station.repository.StationRepository;
//import org.junit.jupiter.api.DisplayName;
//import org.junit.jupiter.api.Test;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.test.context.ActiveProfiles;
//
//import static org.junit.jupiter.api.Assertions.assertEquals;
//
//@SpringBootTest
//@ActiveProfiles("test")
//public class BeaconcoorServiceTest {
//
//    @Autowired
//    private BeaconcoorService beaconcoorService;
//
//    @Autowired
//    private BeaconRepository beaconRepository;
//
//    @Autowired
//    private StationRepository stationRepository;
//
//    @Test
//    @Transactional
//    @DisplayName("역 이름 출력 test")
//    void testGetStationName(){
//        // Given
//        // 필요한 데이터 저장
//        Station station = stationRepository.save(new Station("하단역", "loginId", "123123", 1));
//        Beacon beacon = beaconRepository.save(new Beacon(station, 1,1,1,23.423423, 23.23423, 30, BeaconTYPE.POINT));
//        System.out.println("station: "+station.getId());
//        System.out.println("beacon: "+station.getId()+"의 이름은 "+station.getName());
//
//        // When
//        String stationName = beaconcoorService.getStationName(beacon.getId());
//
//        // Then
//        assertEquals(stationName, station.getName());
//    }
//}
