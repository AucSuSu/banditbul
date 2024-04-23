package org.banditbul.bandi.station.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class Station {
    @Id
    @Column(name = "station_id")
    private int id;

    @Column(name = "name")
    private String name;

    @Column(name = "login_id")
    private String loginID;

    @Column(name = "login_pw")
    private String password;

    @Column(name = "line")
    private int line;
}
