package org.banditbul.bandi.point.repository;

import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.point.entity.Point;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PointRepository extends JpaRepository<Point, Integer> {

    Optional<Point> findByBeacon(Beacon beacon);
//    public Optional<List<Point>> findAllByStationId(int stationId);
}