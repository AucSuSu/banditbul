package org.banditbul.bandi.edge.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.point.entity.Point;
import org.banditbul.bandi.station.entity.Station;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Edge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "edge_id")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "beacon_id1")
    private Beacon beacon1;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "beacon_id2")
    private Beacon beacon2;

    @Column(name = "distance")
    private int distance;

    @ManyToOne
    @JoinColumn(name = "station_id")
    private Station station;

    public Edge(Beacon beacon1, Beacon beacon2, int distance, Station station) {
        this.beacon1 = beacon1;
        this.beacon2 = beacon2;
        this.distance = distance;
        this.station = station;
    }
}
