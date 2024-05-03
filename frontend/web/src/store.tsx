import { create } from "zustand";
import { persist } from "zustand/middleware";

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

const useWebSocketStore = create<WebSocketStore>((set) => ({
    webSocket: null,
    setWebSocket: (ws) => set({ webSocket: ws }),
}));

export default useWebSocketStore;
