package org.banditbul.bandi.beacon.repository;

import org.banditbul.bandi.beacon.entity.Beacon;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface BeaconRepository extends JpaRepository<Beacon, String> {

    public Optional<Beacon> findById(String beaconId);
}
