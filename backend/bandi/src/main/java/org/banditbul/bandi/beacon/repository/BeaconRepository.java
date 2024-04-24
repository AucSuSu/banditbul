package org.banditbul.bandi.beacon.repository;

import org.banditbul.bandi.beacon.entity.Beacon;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BeaconRepository extends JpaRepository<Beacon, String> {
}
