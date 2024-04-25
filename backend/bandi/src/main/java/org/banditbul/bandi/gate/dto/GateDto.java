package org.banditbul.bandi.gate.dto;

import lombok.Data;

@Data
public class GateDto {

    private boolean isUp;

    public GateDto(boolean isUp) {
        this.isUp = isUp;
    }
}
