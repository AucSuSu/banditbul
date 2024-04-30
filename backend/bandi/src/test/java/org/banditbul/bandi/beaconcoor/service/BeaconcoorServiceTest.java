package org.banditbul.bandi.beaconcoor.service;

import jakarta.transaction.Transactional;
import org.banditbul.bandi.beaconcoor.repository.BeaconcoorRepository;
import org.banditbul.bandi.station.entity.Station;
import org.banditbul.bandi.station.repository.StationRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
@ActiveProfiles("test")
public class BeaconcoorServiceTest {

    @Autowired
    private BeaconcoorService beaconcoorService;

    @Autowired
    private BeaconcoorRepository beaconcoorRepository;

    @Autowired
    private StationRepository stationRepository;

    @Test
    @Transactional
    @DisplayName("역 이름 출력 test")
    void testGetStationName(){
        // Given
        // 필요한 데이터 저장
        Station station = stationRepository.save(new Station("하단역", "loginId", "123123", 1));
        Beaconcoor beaconcoor = beaconcoorRepository.save(new Beaconcoor(1,station,"역이름알려주는beaconId",1,1,-1));
        System.out.println("station: "+station.getId());
        System.out.println("beaconcoor: "+station.getId()+"의 이름은 "+station.getName());

        // When
        String stationName = beaconcoorService.getStationName(beaconcoor.getBeaconId());

        // Then
        assertEquals(stationName, station.getName());
    }
}
