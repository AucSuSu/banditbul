package org.banditbul.bandi.gate.repository;

import org.banditbul.bandi.gate.entity.Gate;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GateRepository extends JpaRepository<Gate, Integer> {

    public Optional<Gate> findByBeaconId(String beaconId);
}
