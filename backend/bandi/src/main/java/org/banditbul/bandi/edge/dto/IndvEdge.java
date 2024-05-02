package org.banditbul.bandi.edge.dto;

import lombok.Data;

@Data
public class IndvEdge {
    String beaconId1;
    String beaconId2;

    public IndvEdge(String beaconId1, String beaconId2) {
        this.beaconId1 = beaconId1;
        this.beaconId2 = beaconId2;
    }
}
