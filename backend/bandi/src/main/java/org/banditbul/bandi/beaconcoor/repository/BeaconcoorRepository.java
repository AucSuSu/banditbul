package org.banditbul.bandi.beaconcoor.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface BeaconcoorRepository extends JpaRepository<Beaconcoor, Integer> {

    public Optional<Beaconcoor> findByBeaconId(String beaconId);
}
