package org.banditbul.bandi.elevator.repository;

import org.banditbul.bandi.elevator.entity.Elevator;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ElevatorRepository extends JpaRepository<Elevator, Integer> {
}
