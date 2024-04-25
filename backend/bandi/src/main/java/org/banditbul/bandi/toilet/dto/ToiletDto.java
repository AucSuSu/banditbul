package org.banditbul.bandi.toilet.dto;

import lombok.Data;

@Data
public class ToiletDto {

    private boolean manDir;
    private boolean womanDir;

    public ToiletDto(boolean manDir, boolean womanDir) {
        this.manDir = manDir;
        this.womanDir = womanDir;
    }
}
