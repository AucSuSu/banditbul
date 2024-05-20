package org.banditbul.bandi.escalator.repository;

import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.escalator.entity.Escalator;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface EscalatorRepository extends JpaRepository<Escalator, Integer> {
    Optional<Escalator> findByBeacon(Beacon beacon);
}
