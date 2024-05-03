package org.banditbul.bandi.escalator.dto;

import lombok.Data;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;
@Data
public class EscalatorDto implements BeaconInfoDto {

    private boolean isUp;

    public EscalatorDto(boolean isUp) {
        this.isUp = isUp;
    }
}
