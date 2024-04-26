package org.banditbul.bandi.station.entity;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class Station implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "station_id")
    private Integer id;

    @Column(name = "name")
    private String name;

    @Column(name = "login_id")
    private String loginId;

    @Column(name = "login_pw")
    private String password;

    @Column(name = "line")
    private int line;

    private String role;

    public Station(String name, String loginID, String password, int line) {
        this.name = name;
        this.loginId = loginID;
        this.password = password;
        this.line = line;
        this.role = "USER";
    }
}
