import { create } from 'zustand'
import { persist } from 'zustand/middleware'


interface StationStore {
  testData :  string;
  setTestData : (newData: string) => void;
}

const stationStore = create<StationStore>()(
    persist(
      (set) => ({
        testData : 'arim',
        setTestData : (newData) => set(() => ({testData : newData})),
        }),
      { name: 'stationStore' },
    ),
)

export default stationStore;
