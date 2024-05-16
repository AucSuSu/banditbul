package org.banditbul.bandi.beacon.dto;

import lombok.*;
import org.banditbul.bandi.edge.dto.IndvEdge;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FloorInfoDto {

    List<IndvBeacon> beaconList;
    List<IndvEdge> edgeList;
    String mapImageUrl;

}
