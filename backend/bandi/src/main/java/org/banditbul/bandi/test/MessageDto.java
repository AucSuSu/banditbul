package org.banditbul.bandi.test;

import lombok.Data;

@Data
public class MessageDto {
    private String type; //메세지 유형
    private String content; //메세지 내용
    private String sessionId; //속한 세션
}
