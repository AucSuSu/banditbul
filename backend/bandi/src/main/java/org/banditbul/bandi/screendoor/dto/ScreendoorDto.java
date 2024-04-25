package org.banditbul.bandi.screendoor.dto;

import lombok.Data;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;

@Data
public class ScreendoorDto implements BeaconInfoDto {

    private String direction; // ㅇㅇ방면 ㅇ-ㅇ 열차입니다.

    public ScreendoorDto(String direction) {
        this.direction = direction;
    }
}
