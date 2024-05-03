package org.banditbul.bandi.beacon.entity;

import jakarta.persistence.*;
import lombok.*;
import org.banditbul.bandi.station.entity.Station;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@ToString
public class Beacon {
    @Id
    @Column(name = "beacon_id")
    private String id;

    @ManyToOne
    @JoinColumn(name = "station_id")
    private Station station;

    private int x;
    private int y;
    private int floor;
    private Double latitude;
    private Double longitude;
    private int range;

    @Enumerated(EnumType.STRING)
    private BeaconTYPE beaconType;

}
