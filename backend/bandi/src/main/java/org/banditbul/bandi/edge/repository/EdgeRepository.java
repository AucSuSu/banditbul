package org.banditbul.bandi.edge.repository;

import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.edge.entity.Edge;
import org.banditbul.bandi.station.entity.Station;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EdgeRepository extends JpaRepository<Edge, Integer> {

    public List<Edge> findAllByStation(Station station);

    Edge findByBeacon1AndBeacon2(Beacon beacon1, Beacon beacon2);
    // 양방향으로 이미 존재하는 에지가 있는지 확인
    boolean existsByBeacon1AndBeacon2OrBeacon2AndBeacon1(Beacon beacon1, Beacon beacon2, Beacon beacon1Reverse, Beacon beacon2Reverse);

    List<Edge> findByBeacon1_IdOrBeacon2_Id(String beaconId1, String beaconId2);
}
