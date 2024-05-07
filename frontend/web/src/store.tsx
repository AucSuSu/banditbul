import { create } from "zustand";
import { persist } from "zustand/middleware";
import axios from "axios";
import { MapInfo } from "./util/type";

interface StationStore {
    testData: string;
    setTestData: (newData: string) => void;
}

interface WebSocketStore {
    webSocket: WebSocket | null;
    setWebSocket: (ws: WebSocket) => void;
}

export const stationStore = create<StationStore>()(
    persist(
        (set) => ({
            testData: "arim",
            setTestData: (newData) => set(() => ({ testData: newData })),
        }),
        { name: "stationStore" }
    )
);

export const getMapFunc = async (floor: number): Promise<MapInfo> => {
    const api = "https://banditbul.co.kr/api";
    // zustand 에서 값 가져오기
    try {
        const response = await axios.get(`${api}/beaconlist/${floor}`);
        const data = response.data.object;
        console.log(data);
        return data;
    } catch (error) {
        console.error(error);
        alert("실패");
        throw error;
    }
};

const useWebSocketStore = create<WebSocketStore>((set) => ({
    webSocket: null,
    setWebSocket: (ws) => set({ webSocket: ws }),
}));

export default useWebSocketStore;
