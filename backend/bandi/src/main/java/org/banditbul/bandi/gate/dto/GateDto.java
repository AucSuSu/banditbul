package org.banditbul.bandi.gate.dto;

import lombok.Data;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;

@Data
public class GateDto implements BeaconInfoDto {

    private boolean isUp;

    public GateDto(boolean isUp) {
        this.isUp = isUp;
    }
}
