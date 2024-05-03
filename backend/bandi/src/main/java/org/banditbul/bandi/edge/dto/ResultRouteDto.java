package org.banditbul.bandi.edge.dto;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@AllArgsConstructor
@ToString
public class ResultRouteDto {

    private List<CheckPointDto> result1;
    private List<CheckPointDto> result2;

}
