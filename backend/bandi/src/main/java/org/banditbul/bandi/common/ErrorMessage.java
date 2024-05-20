package org.banditbul.bandi.common;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ErrorMessage {
    private HttpStatusEnum status;
    private String message;
}
