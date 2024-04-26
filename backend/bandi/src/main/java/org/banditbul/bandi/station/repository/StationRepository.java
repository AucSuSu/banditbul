package org.banditbul.bandi.station.repository;

import org.banditbul.bandi.station.entity.Station;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StationRepository extends JpaRepository<Station, Integer> {
    public Station findByLoginId(String loginId);
}
