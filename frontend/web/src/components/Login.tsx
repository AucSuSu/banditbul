import { useState, FormEvent } from "react";
import Auth from "../util/axios";
import idImage from "../assets/id.png";
import passwordImage from "../assets/pw.png";
import { stationStore } from "../store";
import { useNavigate } from "react-router-dom";
import { useLoginStore } from "../store"; // Zustand 스토어 import

const Login = () => {
    const auth = Auth();
    const [loginId, setLoginId] = useState("");
    const [password, setPassword] = useState("");
    const [isFailed, setIsFailed] = useState(false)
    const setData = stationStore((state) => state.setStationData);
    const navigate = useNavigate();
    const setLoginIdGlobal = useLoginStore((state) => state.setLoginId); // Zustand 스토어의 setLoginId 함수 가져오기

    const handleLogin = async (e: FormEvent<HTMLFormElement>) => {
        e.preventDefault();

        const formData = new FormData();
        formData.append("loginId", loginId);
        formData.append("password", password);

        try {
            const response = await auth.post("/login", formData);
            setData(response.data.object);
            setLoginIdGlobal(loginId); // Zustand 스토어에 loginId 저장
            setIsFailed(false)
            navigate("./map");
        } catch (error) {
            setIsFailed(true)
            console.error(error);
        }
    };

    return (
        <div className="flex-cc h-screen w-full font-jamsil bg-white text-black">
            <div className="flex-c w-full h-full ">
                <img
                    className="h-[100%] w-[60%] object-cover"
                    src="https://d3h25rphev0vuf.cloudfront.net/loginBg.png"
                    alt="로그인 페이지 이미지"
                />
                <div className="h-[60%] w-[40%] flex-cc pe-40">
                    <div className="flex items-center flex-col ">
                        <div
                            className="font-PyeongChangPeaceBold text-7xl"
                            style={{
                                textShadow: "2px 2px 4px rgba(0, 0, 0, 0.5)",
                            }}
                        >
                            Banditbul
                        </div>
                        <div className="text-2xl">
                            지하철 역사 내 모니터링 플랫폼
                        </div>
                    </div>
                    <form
                        className="flex-cc h-full w-full mt-20"
                        onSubmit={handleLogin}
                    >
                        <div className="flex items-center h-[15%] w-[70%] border-basic m-2.5">
                            <img
                                className="w-[5%] object-cover mx-5"
                                src={idImage}
                                alt="id"
                            />
                            <input
                                className="w-[60%] h-[80%] pl-2.5 mr-2"
                                type="text"
                                value={loginId}
                                placeholder="아이디 입력"
                                onChange={(e) => setLoginId(e.target.value)}
                            />
                        </div>
                        <div className="flex items-center h-[15%] w-[70%] border-basic m-2.5">
                            <img
                                className="w-[5%] object-cover mx-5 "
                                src={passwordImage}
                                alt="password"
                            />
                            <input
                                className="w-[60%] h-[80%] pl-2.5 mr-2"
                                type="password"
                                value={password}
                                placeholder="비밀번호 입력"
                                onChange={(e) => setPassword(e.target.value)}
                            />
                        </div>
                            {isFailed && <p className="absolute text-red-400 animate-bounce" >아이디와 비밀번호를 확인해주세요!</p>}
                        <button
                            className="w-[20%] h-[15%] mt-10 border-2
                        rounded-full shadow-sm text-white font-bold 
                        hover:scale-105  hover:bg-pos-100"
                            type="submit"
                            style={{
                                backgroundColor: "#47467E",
                            }}
                        >
                            로그인
                        </button>
                        <div
                            className="w-[100%] h-[12.5%] mt-10 flex-cc font-TheJamsil5Bold"
                            style={{ color: "#0024A5" }}
                        >
                            문의: ssafyteamujeong@gmail.com
                        </div>
                    </form>
                </div>
            </div>
        </div>
    );
};

export default Login;
