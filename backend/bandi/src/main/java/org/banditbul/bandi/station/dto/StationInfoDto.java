package org.banditbul.bandi.station.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
@AllArgsConstructor
public class StationInfoDto {

    private int line;
    private String stationName;
}
