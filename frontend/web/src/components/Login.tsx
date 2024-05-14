import { useState, FormEvent } from "react";
import Auth from "../util/axios";
import idImage from "../assets/id.png";
import passwordImage from "../assets/pw.png";
import subway from '../assets/subway.png';
import {stationStore} from '../store';
import { useNavigate } from "react-router-dom";

const Login = () => {
    const auth = Auth();
    const [loginId, setLoginId] = useState("");
    const [password, setPassword] = useState("");
    const setData = stationStore(state => state.setStationData)
    const navigate = useNavigate()

    const handleLogin = async (e: FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        console.log(loginId, password);

        const formData = new FormData();
        formData.append("loginId", loginId);
        formData.append("password", password);

        try {
            const response = await auth.post("/login", formData);
            console.log(response);
            setData(response.data.object)
            alert("성공");
            navigate('./map')
        } catch (error) {
            console.error(error);
            alert("실패");
        }
    };


    return (
        <div className="flex-cc h-screen w-full font-jamsil bg-white text-black">
            <h1 className="text-4xl mt-10">Banditbul</h1>
            <div className="flex-c w-full h-full ">
                <img className="h-[80%] w-[50%] object-cover" src={subway} alt="" />
                <div className="h-[80%] w-[50%] flex-cc">
                    <form
                        className="flex-cc h-full w-full bg-slate-200"
                        onSubmit={handleLogin}
                    >
                        <div className="flex items-center h-[15%] w-[60%] border-basic m-2.5">
                            <img
                                className="w-[5%] object-cover mx-5"
                                src={idImage}
                                alt="id"
                            />
                            <input
                                className="w-[60%] h-[80%] pl-2.5 mr-2"
                                type="text"
                                value={loginId}
                                placeholder="아이디"
                                onChange={(e) => setLoginId(e.target.value)}
                            />
                        </div>
                        <div className="flex items-center h-[15%] w-[60%] border-basic m-2.5">
                            <img
                                className="w-[5%] object-cover mx-5 "
                                src={passwordImage}
                                alt="password"
                            />
                            <input
                                className="w-[60%] h-[80%] border-2 border-gray pl-2.5 mr-2 rounded-lg"
                                type="password"
                                value={password}
                                placeholder="비밀번호"
                                onChange={(e) => setPassword(e.target.value)}
                            />
                        </div>
                        <button
                            className="w-[60%] h-[12.5%] border-2
                        rounded-lg shadow-sm text-white font-bold bg-red-200
                        hover:scale-105  hover:bg-pos-100"
                            type="submit"
                        >
                            로그인
                        </button>
                    </form>
                </div>
            </div>
        </div>
    );
};

export default Login;
