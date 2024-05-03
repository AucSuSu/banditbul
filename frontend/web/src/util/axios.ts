import axios from "axios";

const BASE_URL = "https://banditbul.co.kr/api";

async function Axios(
    path: string,
    method: string,
    body: object | null = null
): Promise<any> {
    try {
        // 요청 옵션 설정
        const options: any = {
            method,
            headers: {
                "Content-Type": "application/json",
            },
            url: BASE_URL + path,
        };
        // 요청 바디 추가
        if (body !== null) {
            options.data = body;
        }
        // Axios로 HTTP 요청 보내기
        const response = await axios(options);
        // 응답 반환
        return response;
    } catch (error) {
        // 오류 처리
        throw error;
    }
}

async function Auth(
    path: string,
    method: string,
    body: object | null = null
): Promise<any> {
    try {
        // 요청 옵션 설정
        const options: any = {
            method,
            headers: {
                "Content-Type": "multipart/form-data",
            },
            url: BASE_URL + path,
        };
        // 요청 바디 추가
        if (body !== null) {
            options.data = body;
        }
        // Axios로 HTTP 요청 보내기
        const response = await axios(options);
        // 응답 반환
        return response;
    } catch (error) {
        // 오류 처리
        throw error;
    }
}

export { Axios, Auth };
