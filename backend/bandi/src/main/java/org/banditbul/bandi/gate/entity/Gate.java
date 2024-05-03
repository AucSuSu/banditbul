package org.banditbul.bandi.gate.entity;

import jakarta.persistence.*;
import lombok.*;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.common.Dir;
import org.banditbul.bandi.point.entity.Point;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Gate {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "gate_id")
    private Integer id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "beacon_id")
    private Beacon beacon;

    @Column(name = "is_up")
    private Boolean isUp;

    @Enumerated(EnumType.STRING) // DB에 문자열로 저장
    @Column(nullable = true)
    private Dir elevator;

    @Enumerated(EnumType.STRING) // DB에 문자열로 저장
    private Dir escalator;

    @Enumerated(EnumType.STRING) // DB에 문자열로 저장
    private Dir stair;

    public Gate(Beacon beacon, Boolean isUp,  Dir elevator, Dir escalator, Dir stair) {
        this.beacon = beacon;
        this.isUp = isUp;
        this.elevator = elevator;
        this.escalator = escalator;
        this.stair = stair;
    }
}
