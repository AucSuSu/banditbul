package org.banditbul.bandi.station.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.io.Serial;
import java.io.Serializable;

@Getter
@Setter
@AllArgsConstructor
@ToString
public class StationSessionDto implements Serializable{
    @Serial
    private static final long serialVersionUID = 1L;
    private int id;
    private String name;
    private String loginId;
    private int line;
    private String role;
}
