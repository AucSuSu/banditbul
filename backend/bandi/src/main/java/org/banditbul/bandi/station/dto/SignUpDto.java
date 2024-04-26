package org.banditbul.bandi.station.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class SignUpDto {

    private String name;
    private String loginId;
    private String password;
    private int line;
}
