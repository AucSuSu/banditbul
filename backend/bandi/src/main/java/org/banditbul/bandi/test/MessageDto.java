package org.banditbul.bandi.test;

import lombok.Data;

@Data
public class MessageDto {
    private Type type; //메세지 유형
    private String beaconId; //비콘 id
}
