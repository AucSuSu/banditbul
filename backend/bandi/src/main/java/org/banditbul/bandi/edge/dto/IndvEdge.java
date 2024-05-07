package org.banditbul.bandi.edge.dto;

import lombok.Data;

@Data
public class IndvEdge {
    String beacon1;
    String beacon2;

    public IndvEdge(String beacon1, String beacon2) {
        this.beacon1 = beacon1;
        this.beacon2 = beacon2;
    }
}
