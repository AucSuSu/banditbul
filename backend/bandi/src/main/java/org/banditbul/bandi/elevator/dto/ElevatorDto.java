package org.banditbul.bandi.elevator.dto;

import lombok.Data;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;

@Data
public class ElevatorDto implements BeaconInfoDto {

    private boolean isUp;

    public ElevatorDto(boolean isUp) {
        this.isUp = isUp;
    }
}
