package org.banditbul.bandi.stair.dto;

import lombok.Data;

@Data
public class StairDto {

    private boolean isUp;

    public StairDto(boolean isUp) {
        this.isUp = isUp;
    }
}
