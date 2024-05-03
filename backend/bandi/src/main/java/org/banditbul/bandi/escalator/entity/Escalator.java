package org.banditbul.bandi.escalator.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.banditbul.bandi.beacon.entity.Beacon;

@Entity
@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Escalator {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "escalator_id")
    private Integer id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "beacon_id")
    private Beacon beacon;

    private boolean isUp;

    public Escalator(Beacon beacon, boolean isUp) {
        this.beacon = beacon;
        this.isUp = isUp;
    }
}
