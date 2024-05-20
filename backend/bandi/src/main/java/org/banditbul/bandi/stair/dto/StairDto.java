package org.banditbul.bandi.stair.dto;

import lombok.Data;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;

@Data
public class StairDto implements BeaconInfoDto {

    private boolean isUp;

    public StairDto(boolean isUp) {
        this.isUp = isUp;
    }
}
