package org.banditbul.bandi.screendoor.repository;

import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.screendoor.entity.Screendoor;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ScreendoorRepository extends JpaRepository<Screendoor, Long> {

    Optional<Screendoor> findByBeacon(Beacon beacon);

}
