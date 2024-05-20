package org.banditbul.bandi.test;

import lombok.Data;

import java.util.Map;

@Data
public class MessageDto {
    private Type type; //메세지 유형
    private Map<String, Integer> count; //비콘 수
    private String beaconId; //비콘 id
    private String sessionId; //세션 id
    private String uuId; //유저 id
}
