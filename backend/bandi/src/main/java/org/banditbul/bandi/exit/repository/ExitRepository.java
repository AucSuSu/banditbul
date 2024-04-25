package org.banditbul.bandi.exit.repository;

import org.banditbul.bandi.exit.entity.Exit;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ExitRepository extends JpaRepository<Exit, Integer> {
    public Optional<Exit> findByBeaconId(String beaconId);
}
