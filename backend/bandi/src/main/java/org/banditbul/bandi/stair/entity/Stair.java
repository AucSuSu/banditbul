package org.banditbul.bandi.stair.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.point.entity.Point;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Stair {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "stair_id")
    private Integer id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "beacon_id")
    private Beacon beacon;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "point_id")
    private Point point;

    private boolean isUp;

    public Stair(Beacon beacon, Point point, boolean isUp) {
        this.beacon = beacon;
        this.point = point;
        this.isUp = isUp;
    }
}
