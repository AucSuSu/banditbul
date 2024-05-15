import axios, { AxiosInstance } from "axios";

const BASE_URL = "https://banditbul.co.kr/api";

axios.defaults.withCredentials = true;

// Auth 함수 수정
const Auth = (): AxiosInstance => {
    const axiosInstance = axios.create({
        baseURL: BASE_URL,
        withCredentials: true,
    });

    axiosInstance.interceptors.response.use(
        (response) => {
            return response;
        },
        async (error) => {
            if (error.response.status === 401) {
                alert("로그인 만료");
            }
            return Promise.reject(error);
        }
    );

    return axiosInstance;
};

// Axios 함수 수정
export const Axios = (): AxiosInstance => {
    const axiosInstance = axios.create({
        baseURL: BASE_URL,
    });

    axiosInstance.interceptors.response.use(
        (response) => {
            return response;
        },
        async (error) => {
            if (error.response.status === 401) {
                alert("로그인 만료");
            }
            return Promise.reject(error);
        }
    );

    return axiosInstance;
};

export default Auth;
