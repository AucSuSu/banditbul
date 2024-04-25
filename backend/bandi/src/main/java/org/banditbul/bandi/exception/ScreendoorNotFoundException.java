package org.banditbul.bandi.exception;

import lombok.Getter;

@Getter
public class ScreendoorNotFoundException extends RuntimeException{

    private Object screendoor;
    public ScreendoorNotFoundException(Object screendoor){
        super("해당하는 screendoor 정보를 찾을 수 없습니다. 찜 정보 : " + screendoor.toString());
        this.screendoor = screendoor;
    }
}
