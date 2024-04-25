package org.banditbul.bandi.exception;

import lombok.Getter;
import org.springframework.objenesis.ObjenesisException;

@Getter
public class StationNotFoundException extends RuntimeException{

    private Object station;
    public StationNotFoundException(Object station){
        super("해당하는 역 정보를 찾을 수 없습니다. 찜 정보 : " + station.toString());
        this.station = station;
    }
}
