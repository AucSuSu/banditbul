import { useState, FormEvent } from "react";
import axios from 'axios';
import idImage from '../assets/id.png';
import passwordImage from '../assets/pw.png';

const Login = () => {
    const [id, setId] = useState('');
    const [password, setPassword] = useState('');

    const handleLogin = async (e:FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        try {
            const response = await axios.post('ssafy.io', { id, password });
            console.log(response);
            alert('성공');
        } catch (error) {
            console.error(error);
            alert('실패');
        }
    };

    return (
        <div className="flex-c h-screen w-full bg-yellow-100">
            <form className="flex-cc h-[50%] w-[60%] bg-slate-200" onSubmit={handleLogin}>
                <div className="flex items-center h-[15%] w-[60%] border-basic m-2.5">
                    <img className="w-[5%] object-cover mx-5" src={idImage} alt="id" />
                    <input className="border-l-2 pl-2.5" type="text" value={id} placeholder="아이디" onChange={e => setId(e.target.value)} />
                </div>
                <div className='flex items-center h-[15%] w-[60%] border-basic m-2.5'>
                    <img className="w-[5%] object-cover mx-5 " src={passwordImage} alt="password" />
                    <input className="border-l-2 pl-2.5 " type="password" value={password} placeholder="비밀번호" onChange={e => setPassword(e.target.value)} />
                </div>
                <button className="border-2 bg-red-200 p-3 rounded-lg shadow-sm text-white font-bold hover:scale-105" type="submit">로그인</button>
            </form>
        </div>
    );
};

export default Login;
