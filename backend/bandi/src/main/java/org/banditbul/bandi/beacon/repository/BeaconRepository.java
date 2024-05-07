package org.banditbul.bandi.beacon.repository;

import org.banditbul.bandi.beacon.dto.IndvBeacon;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.station.entity.Station;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface BeaconRepository extends JpaRepository<Beacon, String> {

    public Optional<Beacon> findById(String beaconId);
    List<Beacon> findByIdIn(List<String> beaconIds);
    public List<Beacon> findAllByStationAndFloor(Station station, int floor);
    public List<Beacon> findAllByStation(Station station);
}
