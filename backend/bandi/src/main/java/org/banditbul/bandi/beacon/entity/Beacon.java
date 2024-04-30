package org.banditbul.bandi.beacon.entity;

import jakarta.persistence.*;
import lombok.*;
import org.banditbul.bandi.station.entity.Station;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
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
    private BeaconTYPE beaconType;

    public Beacon(Station station, int x, int y, int floor, Double latitude, Double longitude, int range, BeaconTYPE beaconType) {
        this.station = station;
        this.x = x;
        this.y = y;
        this.floor = floor;
        this.latitude = latitude;
        this.longitude = longitude;
        this.range = range;
        this.beaconType = beaconType;
    }
}
