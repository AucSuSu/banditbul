package org.banditbul.bandi.edge.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@AllArgsConstructor
@ToString
public class CheckPointDto {
    private String beaconId;
    private int distance;
    private String directionInfo;

}
