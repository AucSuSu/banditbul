package org.banditbul.bandi.toilet.dto;

import lombok.Data;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;
import org.banditbul.bandi.common.Dir;

@Data
public class ToiletDto implements BeaconInfoDto {

    private Dir manDir;
    private Dir womanDir;

    public ToiletDto(Dir manDir, Dir womanDir) {
        this.manDir = manDir;
        this.womanDir = womanDir;
    }
}
