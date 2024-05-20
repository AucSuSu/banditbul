
package org.banditbul.bandi.station.entity;
import jakarta.persistence.*;
import lombok.*;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.edge.entity.Edge;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
@Entity
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
//@ToString
public class Station {
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
    @OneToMany(mappedBy = "station")
    List<Beacon> beaconList = new ArrayList<>();
    @OneToMany(mappedBy = "station")
    List<Edge> edgeList = new ArrayList<>();
    public Station(String name, String loginID, String password, int line) {
        this.name = name;
        this.loginId = loginID;
        this.password = password;
        this.line = line;
        this.role = "USER";
    }
}
