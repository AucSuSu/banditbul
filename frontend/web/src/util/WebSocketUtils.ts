// websocketUtils.ts
import useWebSocketStore from "../store";

export const sendMessage = (message: string) => {
    const webSocket = useWebSocketStore.getState().webSocket;
    if (webSocket) {
        webSocket.send(message);
    } else {
        console.error("WebSocket is not initialized");
    }
};

export const receiveMessage = (callback: (message: string) => void) => {
    const webSocket = useWebSocketStore.getState().webSocket;
    if (webSocket) {
        webSocket.onmessage = (event) => {
            callback(event.data);
        };
    } else {
        console.error("WebSocket is not initialized");
    }
};
