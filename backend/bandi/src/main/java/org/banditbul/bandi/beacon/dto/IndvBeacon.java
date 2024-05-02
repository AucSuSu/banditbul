package org.banditbul.bandi.beacon.dto;

import lombok.Data;

@Data
public class IndvBeacon {
    String beaconId;
    int x;
    int y;

    public IndvBeacon(String beaconId, int x, int y) {
        this.beaconId = beaconId;
        this.x = x;
        this.y = y;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        IndvBeacon that = (IndvBeacon) o;

        return beaconId != null ? beaconId.equals(that.beaconId) : that.beaconId == null;
    }

    @Override
    public int hashCode() {
        return beaconId != null ? beaconId.hashCode() : 0;
    }
}
