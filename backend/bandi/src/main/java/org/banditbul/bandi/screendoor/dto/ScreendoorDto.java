package org.banditbul.bandi.screendoor.dto;

import lombok.Data;

@Data
public class ScreendoorDto {

    private String direction; // ㅇㅇ방면 ㅇ-ㅇ 열차입니다.

    public ScreendoorDto(String direction) {
        this.direction = direction;
    }
}
