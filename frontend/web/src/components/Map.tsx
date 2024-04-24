import { useEffect, useState } from 'react';
import testBg from '../assets/testBg.png'

type coord = {
    x: number;
    y: number;
}


// 기준 좌표값
const standardCoordinate = {
    x1 : 35, x2 : 36, y1 : 126, y2 : 127
}

const xPixel = window.innerWidth * 0.9
const yPixel = window.innerHeight * 0.8

const getPoint = (coordinate:coord) => {
    const latValue = standardCoordinate.x2 - standardCoordinate.x1
    const lonValue = standardCoordinate.y2 - standardCoordinate.y1
    const xPercentage = (coordinate.x - standardCoordinate.x1) / latValue * 100
    const yPercentage = (coordinate.y - standardCoordinate.y1) / lonValue * 100
    const xPoint = xPixel * xPercentage / 100
    const yPoint = yPixel * yPercentage / 100
    return {x : xPoint, y : yPoint} 
}

const Map: React.FC = () => {
  const [points, setPoints] = useState<{ x: number; y: number }[]>([]);
  const [page, setPage] = useState(0)
  const floor = ['지상', '지하1층', '지하2층']


  useEffect(() => {
    const interval = setInterval(() => {

      const randomLatitude = 35 + Math.random();
      const randomLongitude = 126 + Math.random();

      const point = getPoint({x: randomLatitude, y : randomLongitude});
      setPoints(prevPoints => [...prevPoints, point]);
    }, 2000);

    return () => clearInterval(interval);
  }, []);

  return (
     <> 
        {page} 
        <div>
            {floor.map((e, index) => <button key={index} onClick={()=> setPage(index)}>{e}</button>)}
        </div>
        <div className='relative h-[80vh] w-[90vw]'>
        <img src={testBg} alt="Background" className='w-full h-full object-cover'/>
        {points.map((point, index) => (
            <div
            key={index}
            className='absolute h-[5px] w-[5px] bg-red-500 rounded-full'
            style={{left: `${point.x}px`, top: `${point.y}px`}}
            />
        ))}
        </div>
    </>
  );
};

export default Map;
