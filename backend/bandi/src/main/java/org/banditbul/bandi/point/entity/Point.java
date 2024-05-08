package org.banditbul.bandi.point.entity;

import jakarta.persistence.*;
import lombok.*;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.station.entity.Station;

@Entity
@Getter @Setter
@NoArgsConstructor
public class Point {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "point_id")
    private Integer id;

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.REMOVE)
    @JoinColumn(name = "beacon_id")
    private Beacon beacon;

    public Point(Beacon beacon) {
        this.beacon = beacon;
    }
}
