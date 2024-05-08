import axios, { AxiosInstance } from 'axios';
import { useNavigate } from 'react-router-dom';

const BASE_URL = 'https://banditbul.co.kr/api';

axios.defaults.withCredentials = true;

// formData
const Auth = (): AxiosInstance => {
  const navigate = useNavigate()

  const axiosInstance = axios.create({
    baseURL: BASE_URL,
    headers: {
      'Content-Type': 'multipart/form-data'
  }
  });

  axiosInstance.interceptors.response.use(
    (response) => {
      return response;
    },
    async (error) => {
      if (error.response.status === 401) {
        alert('로그인 만료')
        navigate('/')
      }

      return Promise.reject(error);
    }
  );

  return axiosInstance;
};

export default Auth;

// 기본
export const Axios = (): AxiosInstance => {
  const navigate = useNavigate()

  const axiosInstance = axios.create({
    baseURL: BASE_URL,
  });

  axiosInstance.interceptors.response.use(
    (response) => {
      return response;
    },
    async (error) => {
      if (error.response.status === 401) {
        alert('로그인 만료')
        navigate('/')
      }

      return Promise.reject(error);
    }
  );

  return axiosInstance;
};
