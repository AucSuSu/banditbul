package org.banditbul.bandi.station.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
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

    public Station(String name, String loginID, String password, int line) {
        this.name = name;
        this.loginID = loginID;
        this.password = password;
        this.line = line;
    }
}
