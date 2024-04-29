package org.banditbul.bandi.gate.dto;

import lombok.Data;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;
import org.banditbul.bandi.common.Dir;

@Data
public class GateDto implements BeaconInfoDto {

    private boolean isUp;
    // 엘베, 에스컬레이터, 계단 방향
    private Dir elevator;
    private Dir escalator;
    private Dir stair;

    public GateDto(boolean isUp, Dir elevator, Dir escalator, Dir stair) {
        this.isUp = isUp;
        this.elevator = elevator;
        this.escalator = escalator;
        this.stair = stair;
    }
}
