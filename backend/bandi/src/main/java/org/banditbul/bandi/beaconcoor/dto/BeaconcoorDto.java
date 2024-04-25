package org.banditbul.bandi.beaconcoor.dto;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class BeaconcoorDto {
    private int coorId;
    private String beaconId;
    private int stationId;
    private int x;
    private int y;
    private int floor;
}
