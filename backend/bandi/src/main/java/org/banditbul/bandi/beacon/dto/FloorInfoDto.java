package org.banditbul.bandi.beacon.dto;

import lombok.Data;
import org.banditbul.bandi.edge.dto.IndvEdge;

import java.util.List;

@Data
public class FloorInfoDto {

    List<IndvBeacon> beaconList;
    List<IndvEdge> edgeList;

    public FloorInfoDto(List<IndvBeacon> beaconList, List<IndvEdge> edgeList) {
        this.beaconList = beaconList;
        this.edgeList = edgeList;
    }
}
