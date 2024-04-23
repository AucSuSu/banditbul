import { useState } from 'react'
import Login from './components/Login'
import Map from './components/Map'

const App = () => {
  const [isLogin, setIsLogin] = useState(false)
  const handleToggle = () => {
    setIsLogin(prev => !prev)
  }
  return (
    <>
      <button onClick={handleToggle}>Toggle</button>
      {isLogin? <Map/> : <Login/>}
    </>
  )
}

export default App
