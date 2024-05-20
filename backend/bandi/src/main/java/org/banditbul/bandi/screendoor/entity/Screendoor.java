package org.banditbul.bandi.screendoor.entity;

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
public class Screendoor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "screendoor_id")
    private Integer id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "beacon_id")
    private Beacon beacon;

    private String direction;

    public Screendoor(Beacon beacon, String direction) {
        this.beacon = beacon;
        this.direction = direction;
    }
}
