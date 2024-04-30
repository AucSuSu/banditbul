package org.banditbul.bandi.point.repository;

import org.banditbul.bandi.gate.entity.Gate;
import org.banditbul.bandi.point.entity.Point;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PointRepository extends JpaRepository<Point, Integer> {

//    public Optional<List<Point>> findAllByStationId(int stationId);
}