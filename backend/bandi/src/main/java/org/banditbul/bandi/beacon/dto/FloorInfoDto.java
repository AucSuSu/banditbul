package org.banditbul.bandi.beacon.dto;

import lombok.Data;
import org.banditbul.bandi.edge.dto.IndvEdge;

import java.util.List;

@Data
public class FloorInfoDto {

    List<IndvBeacon> beaconList;
    List<IndvEdge> edgeList;
    String mapImageUrl;

    public FloorInfoDto(List<IndvBeacon> beaconList, List<IndvEdge> edgeList, String mapImageUrl) {
        this.beaconList = beaconList;
        this.edgeList = edgeList;
        this.mapImageUrl = mapImageUrl;
    }
}
