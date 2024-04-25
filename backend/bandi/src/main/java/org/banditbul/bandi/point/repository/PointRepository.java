package org.banditbul.bandi.point.repository;

import org.banditbul.bandi.point.entity.Point;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PointRepository extends JpaRepository<Point, Integer> {
}
