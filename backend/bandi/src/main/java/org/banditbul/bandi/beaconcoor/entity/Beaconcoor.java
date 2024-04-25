package org.banditbul.bandi.beaconcoor.entity;

import jakarta.persistence.*;
import lombok.*;
import org.banditbul.bandi.station.entity.Station;

@Entity
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
public class Beaconcoor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "beaconcoor_id")
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "station_id")
    private Station station;

    @Column(name = "beacon_id")
    private String beaconId;
    private int x;
    private int y;
    private int floor;
}
