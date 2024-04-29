package org.banditbul.bandi.station.repository;

import org.banditbul.bandi.station.entity.Station;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StationRepository extends JpaRepository<Station, Integer> {
    public Station findByLoginId(String loginId);

    public Optional<Station> findByName(String stationName);
}
