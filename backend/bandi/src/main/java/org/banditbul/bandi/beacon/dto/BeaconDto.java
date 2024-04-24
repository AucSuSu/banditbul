package org.banditbul.bandi.beacon.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class BeaconDto {

    private String macAddress;
    private int stationId;
    private Double latitude;
    private Double longitude;
    private int range;
    private String beaconType;
    private boolean isUp;
    private String manDir;
    private String womanDir;
    private int number;
    private String landmark;
    private String elevator;
    private String escalator;
    private String stair;

}
