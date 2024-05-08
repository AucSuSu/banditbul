import { useState, FormEvent } from "react";
import { useNavigate } from "react-router-dom";
import Auth, {Axios} from '../util/axios';
import idImage from "../assets/id.png";
import passwordImage from "../assets/pw.png";


const Login = () => {
    const auth = Auth()
    const [loginId, setLoginId] = useState("");
    const [password, setPassword] = useState("");
    const navigate = useNavigate();

    const handleLogin = async (e: FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        console.log(loginId, password);

        const formData = new FormData();
        formData.append("loginId", loginId);
        formData.append("password", password);

        try {
            const response = await auth.post('/login', formData);
            console.log(response);
            alert("성공");
            navigate(`/Map`);
        } catch (error) {
            console.error(error);
            alert("실패");
        }
        // navigate(`/Map`);
    };

    const handleLogout = () => {
        const axios = Axios()
        axios
            .post(
                "/logout",
                {},
            )
            .then((response) => {
                console.log("로그아웃 성공", response);
            })
            .catch((error) => {
                console.error("로그아웃 실패", error);
            });
    };
    

    return (
        <div className="flex-cc h-screen w-full bg-yellow-100 font-jamsil">
            <button onClick={handleLogout}>TEST LOGOUT</button>
            <h1 className="text-4xl">Banditbul</h1>
            <form className="flex-cc h-[50%] w-[60%] bg-slate-200" onSubmit={handleLogin}>
                <div className="flex items-center h-[15%] w-[60%] border-basic m-2.5">
                    <img className="w-[5%] object-cover mx-5" src={idImage} alt="id" />
                    <input className="w-[60%] h-[80%] pl-2.5 mr-2" type="text" value={loginId} placeholder="아이디" onChange={e => setLoginId(e.target.value)} />
                </div>
                <div className='flex items-center h-[15%] w-[60%] border-basic m-2.5'>
                    <img className="w-[5%] object-cover mx-5 " src={passwordImage} alt="password" />
                    <input className="w-[60%] h-[80%] border-2 border-gray pl-2.5 mr-2 rounded-lg" type="password" value={password} placeholder="비밀번호" onChange={e => setPassword(e.target.value)} />
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
