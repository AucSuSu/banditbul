package org.banditbul.bandi.edge.repository;

import org.banditbul.bandi.edge.entity.Edge;
import org.banditbul.bandi.station.entity.Station;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EdgeRepository extends JpaRepository<Edge, Integer> {

    public List<Edge> findAllByStation(Station station);
}
