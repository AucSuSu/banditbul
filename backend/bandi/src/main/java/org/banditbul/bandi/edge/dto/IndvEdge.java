package org.banditbul.bandi.edge.dto;

import lombok.*;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.beacon.entity.BeaconTYPE;

import java.util.Objects;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class IndvEdge {


    String beacon1;
    String beacon2;
    int edgeId;
    BeaconTYPE beacon1Type;
    BeaconTYPE beacon2Type;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        IndvEdge indvEdge = (IndvEdge) o;
        return edgeId == indvEdge.edgeId && Objects.equals(beacon1, indvEdge.beacon1) && Objects.equals(beacon2, indvEdge.beacon2) && beacon1Type == indvEdge.beacon1Type && beacon2Type == indvEdge.beacon2Type;
    }

    @Override
    public int hashCode() {
        return Objects.hash(beacon1, beacon2, edgeId, beacon1Type, beacon2Type);
    }
}
