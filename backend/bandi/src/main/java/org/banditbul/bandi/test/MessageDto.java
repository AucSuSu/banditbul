package org.banditbul.bandi.test;

import lombok.Data;

@Data
public class MessageDto {
    private String type;
    private String content;
    private String sessionId;
}
