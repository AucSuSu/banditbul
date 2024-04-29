package org.banditbul.bandi.edge.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.banditbul.bandi.point.entity.Point;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Edge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "edge_id")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "point1_id")
    private Point point1;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "point2_id")
    private Point point2;

    @Column(name = "distance")
    private int distance;

    @Column(name = "station_id")
    private Integer stationId;

    public Edge(Point point1, Point point2, int distance, Integer stationId) {
        this.point1 = point1;
        this.point2 = point2;
        this.distance = distance;
        this.stationId = stationId;
    }
}
