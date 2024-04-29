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
