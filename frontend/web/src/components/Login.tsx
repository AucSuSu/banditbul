import { useState, FormEvent } from "react";
import Auth from "../util/axios";
import idImage from "../assets/id.png";
import passwordImage from "../assets/pw.png";
import subway from "../assets/loginBg.png";
import { stationStore } from "../store";
import { useNavigate } from "react-router-dom";

const Login = () => {
    const auth = Auth();
    const [loginId, setLoginId] = useState("");
    const [password, setPassword] = useState("");
    const setData = stationStore((state) => state.setStationData);
    const navigate = useNavigate();

    const handleLogin = async (e: FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        console.log(loginId, password);

        const formData = new FormData();
        formData.append("loginId", loginId);
        formData.append("password", password);

        try {
            const response = await auth.post("/login", formData);
            console.log(response);
            setData(response.data.object);
            alert("성공");
            navigate("./map");
        } catch (error) {
            console.error(error);
            alert("실패");
        }
    };

    return (
        <div className="flex-cc h-screen w-full font-jamsil bg-white text-black">
            <div className="flex-c w-full h-full ">
                <img
                    className="h-[100%] w-[50%] object-cover"
                    src={subway}
                    alt=""
                />
                <div className="h-[60%] w-[50%] flex-cc">
                    <div className="flex items-center flex-col">
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
                        <div className="flex items-center h-[15%] w-[50%] border-basic m-2.5">
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
                        <div className="flex items-center h-[15%] w-[50%] border-basic m-2.5">
                            <img
                                className="w-[5%] object-cover mx-5 "
                                src={passwordImage}
                                alt="password"
                            />
                            <input
                                className="w-[60%] h-[80%] pl-2.5 mr-2"
                                type="password"
                                value={password}
                                placeholder="비밀번호"
                                onChange={(e) => setPassword(e.target.value)}
                            />
                        </div>
                        <button
                            className="w-[20%] h-[12.5%] mt-10 border-2
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
