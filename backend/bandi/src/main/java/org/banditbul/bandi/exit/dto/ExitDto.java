package org.banditbul.bandi.exit.dto;

import lombok.Data;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;
import org.banditbul.bandi.common.Dir;

@Data
public class ExitDto implements BeaconInfoDto {

    private Integer exitNum; // 출구 번호
    private String landmark;
    
    // 엘베, 에스컬레이터, 계단 방향
    private Dir elevator;
    private Dir escalator;
    private Dir stair;

    public ExitDto(Integer exitNum, String landmark, Dir elevator, Dir escalator, Dir stair) {
        this.exitNum = exitNum;
        this.landmark = landmark;
        this.elevator = elevator;
        this.escalator = escalator;
        this.stair = stair;
    }
}
