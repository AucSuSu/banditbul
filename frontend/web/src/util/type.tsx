export type Coord = {
    x: number;
    y: number;
};

export type Beacon = {
    type: string;
    beaconId: string;
    coord: Coord;
    name: string;
};

export type RequestAddBeacon = {
    macAddress: string;
    stationId: string;
    latitude: string;
    longitude: string;
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
