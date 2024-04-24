import { useState } from "react"


const Login = () => {
    const [id, setId] = useState('')
    const [password, setPassword] = useState('')

    return(
        <>
            <div className="flex-c h-screen w-full bg-yellow-100">
                <div className="flex-cc h-[50%] w-[60%] bg-slate-200">
                    <div className="flex-c h-[10%] w-[60%] border-basic m-2">
                        <p className="border-r-2 border-black px-2 mx-2">🎭</p>
                        <input type="text" value={id} placeholder="아이디" onChange={e => setId(e.target.value)}/>
                    </div>
                    <div className='flex-c h-[10%] w-[60%] border-basic m-2'>
                        <p className="border-r-2 border-black px-2 mx-2">🔍</p>
                        <input type="text" value={password} placeholder="비밀번호" onChange={e => setPassword(e.target.value)}/>
                    </div>
                </div>
            </div>
        </>
    )
}
export default Login