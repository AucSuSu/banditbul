export type Coord = {
    x: number;
    y: number;
};

export type Beacon = {
    beaconTYPE?: string;
    beaconId: string;
    x: number;
    y: number;
};

export type Edge = {
    beacon1: string;
    beacon2: string;
};

export type MapInfo = {
    edgeList: Edge[];
    beaconList: Beacon[];
    mapImageUrl: string;
};

export type RequestAddBeacon = {
    macAddress: string;
    latitude: number;
    longitude: number;
    range: number;
    beaconType: string;
    isUp?: boolean | null;
    manDir?: string | null;
    womanDir?: string | null;
    number?: number;
    landmark?: string;
    elevator?: string | null;
    escalator?: string | null;
    stair?: string | null;
    x: number;
    y: number;
    floor: number;
};

export type BeaconCounts = {
    [beaconId: string]: number;
};

export function typeToKor(type: string) {
    switch (type) {
        case "TOILET":
            return "화장실";
        case "POINT":
            return "교차로";
        case "GATE":
            return "개찰구";
        case "STAIR":
            return "계단";
        case "EXIT":
            return "출구";
        case "ESCALATOR":
            return "에스컬레이터";
        case "ELEVATOR":
            return "엘리베이터";
        case "SCREENDOOR":
            return "스크린도어";
    }
}
