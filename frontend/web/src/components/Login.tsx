import { useState, FormEvent } from "react";
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import idImage from '../assets/id.png';
import passwordImage from '../assets/pw.png';

const Login = () => {
    const [loginId, setLoginId] = useState('');
    const [password, setPassword] = useState('');
    const navigate = useNavigate();
    const api = 'https://k10e102.k.ssafy.io:8080'
    // const api = 'https://localhost:8080'
    const handleLogin = async (e:FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        console.log(loginId, password)
        try {
            const response = await axios.post(`${api}/api/login`, { loginId, password });
            console.log(response);
            alert('성공');
        } catch (error) {
            console.error(error);
            alert('실패');
        }
        navigate(`/map`);
    };

    return (
        <div className="flex-cc h-screen w-full bg-yellow-100 font-jamsil">
            <h1 className="text-4xl">Banditbul</h1>
            <form className="flex-cc h-[50%] w-[60%] bg-slate-200" onSubmit={handleLogin}>
                <div className="flex items-center h-[15%] w-[60%] border-basic m-2.5">
                    <img className="w-[5%] object-cover mx-5" src={idImage} alt="id" />
                    <input className=" w-full border-l-2 pl-2.5 mr-2" type="text" value={loginId} placeholder="아이디" onChange={e => setLoginId(e.target.value)} />
                </div>
                <div className='flex items-center h-[15%] w-[60%] border-basic m-2.5'>
                    <img className="w-[5%] object-cover mx-5 " src={passwordImage} alt="password" />
                    <input className="w-full border-l-2 pl-2.5 mr-2" type="password" value={password} placeholder="비밀번호" onChange={e => setPassword(e.target.value)} />
                </div>
                <button className="w-[60%] h-[12.5%] border-2
                rounded-lg shadow-sm text-white font-bold
                bg-pink-200
                hover:scale-105  hover:bg-pos-100" type="submit">로그인</button>
                {/* bg-gradient-to-r to-pink-200 via-pink-400 from-blue-200
                transition-all duration-500 bg-size-200 bg-pos-0 */}
            </form>
                <p>문의사항 : www.banditbul.com</p>
        </div>
    );
};

export default Login;
