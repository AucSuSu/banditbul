package org.banditbul.bandi.exit.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.common.Dir;
import org.banditbul.bandi.point.entity.Point;
@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Exit {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "exit_id")
    private Integer id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "beacon_id")
    private Beacon beacon;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "point_id")
    private Point point;

    private Integer number;
    private String landmark;

    @Enumerated(EnumType.STRING) // DB에 문자열로 저장
    private Dir elevator;

    @Enumerated(EnumType.STRING) // DB에 문자열로 저장
    private Dir escalator;

    @Enumerated(EnumType.STRING) // DB에 문자열로 저장
    private Dir stair;

    public Exit(Beacon beacon, Point point, Integer number, String landmark, Dir elevator, Dir escalator, Dir stair) {
        this.beacon = beacon;
        this.point = point;
        this.number = number;
        this.landmark = landmark;
        this.elevator = elevator;
        this.escalator = escalator;
        this.stair = stair;
    }
}
