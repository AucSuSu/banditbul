package org.banditbul.bandi.stair.repository;

import org.banditbul.bandi.stair.entity.Stair;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StairRepository extends JpaRepository<Stair, Integer> {
    public Optional<Stair> findByBeaconId(String beaconId);
}
