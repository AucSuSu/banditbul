import { create } from "zustand";
import { persist } from "zustand/middleware";

interface TestDataStore {
    testData: string;
    setTestData: (newData: string) => void;
}

interface LoginStore {
    loginId: string;
    setLoginId: (id: string) => void;
}

interface StationDataStore {
    stationData: { line: string, stationName: string };
    setStationData: (data: { line: string, stationName: string }) => void;
}

interface WebSocketStore {
    webSocket: WebSocket | null;
    setWebSocket: (ws: WebSocket) => void;
}

export const testDataStore = create<TestDataStore>()(
    persist(
        (set) => ({
            testData: "arim",
            setTestData: (newData) => set(() => ({ testData: newData })),
        }),
        { name: "testDataStore" }
    )
);

export const stationStore = create<StationDataStore>()(
    persist(
        (set) => ({
            stationData: { line: '', stationName: '' },
            setStationData: (data) => set(() => ({ stationData: data })),
        }),
        { name: "stationStore" }
    )
);

const useWebSocketStore = create<WebSocketStore>((set) => ({
    webSocket: null,
    setWebSocket: (ws) => set(() => ({ webSocket: ws })),
}));

export const useLoginStore = create<LoginStore>((set) => ({
    loginId: "",
    setLoginId: (id) => set({ loginId: id }),
}));


export default useWebSocketStore

// export const getMapFunc = async (floor: number): Promise<MapInfo> => {
//     const axios = Axios();
//     // zustand 에서 값 가져오기
//     try {
//         console.log("시도");
//         const response = await axios.get(`/beaconlist/${floor}`);
//         const data = response.data.object;
//         console.log(data);
//         return data;
//     } catch (error) {
//         console.error(error);
//         alert("실패");
//         throw error;
//     }
// };