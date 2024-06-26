package org.banditbul.bandi.toilet.repository;

import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.toilet.entity.Toilet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ToiletRepository extends JpaRepository<Toilet, Integer> {

    Optional<Toilet> findByBeacon(Beacon beacon);
}
