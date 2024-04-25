package org.banditbul.bandi.beacon.dto;

import lombok.*;
import org.banditbul.bandi.common.Dir;

@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BeaconDto {

    private String macAddress;
    private int stationId;
    private Double latitude;
    private Double longitude;
    private int range;
    private String beaconType;
    private boolean isUp;
    private Dir manDir;
    private Dir womanDir;
    private int number;
    private String landmark;
    private Dir elevator;
    private Dir escalator;
    private Dir stair;
    private String direction;
    private int x;
    private int y;
    private int floor;

}
