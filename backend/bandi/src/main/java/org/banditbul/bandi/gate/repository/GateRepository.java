package org.banditbul.bandi.gate.repository;

import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.gate.entity.Gate;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GateRepository extends JpaRepository<Gate, Integer> {

    Optional<Gate> findByBeacon(Beacon beacon);


//    public Optional<Gate> findBy(int pointId);
}
