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
