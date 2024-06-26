package org.banditbul.bandi.toilet.entity;

import jakarta.persistence.*;
import lombok.*;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.common.Dir;
import org.banditbul.bandi.point.entity.Point;

@Entity
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class Toilet {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "toilet_id")
    private Integer id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "beacon_id")
    private Beacon beacon;

    @Enumerated(EnumType.STRING) // DB에 문자열로 저장
    private Dir manDir;

    @Enumerated(EnumType.STRING) // DB에 문자열로 저장
    private Dir womanDir;

    public Toilet(Beacon beacon, Dir manDir, Dir womanDir) {
        this.beacon = beacon;
        this.manDir = manDir;
        this.womanDir = womanDir;
    }
}
