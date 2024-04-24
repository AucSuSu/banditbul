package org.banditbul.bandi.beacon.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.*;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class Beacon {
    @Id
    @Column(name = "beacon_id")
    private String id;

    @Column(name = "beacon_type")
    private String beacon_type;
}
