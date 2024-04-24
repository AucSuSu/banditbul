package org.banditbul.bandi.station.entity;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Station {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "station_id")
    private Integer id;

    @Column(name = "name")
    private String name;

    @Column(name = "login_id")
    private String loginID;

    @Column(name = "login_pw")
    private String password;

    @Column(name = "line")
    private int line;
}
