package org.banditbul.bandi.elevator.dto;

import lombok.Data;

@Data
public class ElevatorDto {

    private boolean isUp;

    public ElevatorDto(boolean isUp) {
        this.isUp = isUp;
    }
}
