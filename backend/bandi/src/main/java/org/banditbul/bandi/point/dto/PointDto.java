package org.banditbul.bandi.point.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PointDto {
    private int pointId;
    private int stationId;
    private double latitude;
    private double longitude;
    private int range;
}
