package org.banditbul.bandi.beacon.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Beacon {
    @Id
    @Column(name = "beacon_id")
    private String id;

    @Column(name = "beacon_type")
    private String beacon_type;
}
