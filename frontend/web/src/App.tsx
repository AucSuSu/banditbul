import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Login from './components/Login'
import Map from './components/Map'
import Privacy from './components/Privacy';

const App = () => {
  return (
    <>
      <Router>
          <Routes>
            <Route path="/" element={<Login />} />
            <Route path="/map" element={<Map />} />
            <Route path="/privacy" element={<Privacy />} />
          </Routes>
      </Router>
    </>
  )
}

export default App
