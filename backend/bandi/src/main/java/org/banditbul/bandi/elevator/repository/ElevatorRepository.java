package org.banditbul.bandi.elevator.repository;

import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.elevator.entity.Elevator;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ElevatorRepository extends JpaRepository<Elevator, Integer> {
    Optional<Elevator> findByBeacon(Beacon beacon);
}
