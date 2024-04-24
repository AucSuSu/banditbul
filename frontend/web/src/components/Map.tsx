import { useEffect, useState } from "react";
import React from "react";
import Draggable, { DraggableData, DraggableEvent } from "react-draggable";
import testBg from "../assets/testBg.png";

type Coord = {
    x: number;
    y: number;
};

type Beacon = {
    type: string;
    beaconId: number;
    coord: Coord;
    name: string;
};

const types = ["미선택", "화장실", "하행개찰구", "상행개찰구", "스크린도어"];

const Map: React.FC = () => {
    const [dropDownOpen, setDropDownOpen] = useState<boolean>(false);
    const [clickedId, setClickedId] = useState<number>(-1);
    const [selectType, setSelectType] = useState<number>(0);
    const [locateIng, setLocateIng] = useState<boolean>(false);
    const [modalshow, setModalshow] = useState<boolean>(false);
    const [newBeacon, setNewBeacon] = useState<Beacon | null>(null);
    const [page, setPage] = useState(0);
    const floor = ["지상", "지하1층", "지하2층"];

    const beacons: Beacon[] = [
        {
            type: "화장실",
            beaconId: 1,
            coord: { x: 10, y: 20 },
            name: "Beacon 1",
        },
        {
            type: "상행개찰구",
            beaconId: 2,
            coord: { x: 30, y: 40 },
            name: "Beacon 2",
        },
        {
            type: "화장실",
            beaconId: 3,
            coord: { x: 587, y: 2 },
            name: "Beacon 3",
        },
    ];

    const addBeaconModal = () => {
        setModalshow(true);
    };

    const closeModal = () => {
        setNewBeacon(null);
        setModalshow(false);
    };

    const locate = () => {
        setLocateIng(true);
        setNewBeacon({
            type: types[0],
            beaconId: 1,
            coord: { x: 0, y: 0 },
            name: "beacon",
        });
    };

    const saveLocate = () => {
        setLocateIng(false);
    };

    const clickType = (i: number) => {
        setSelectType(i + 1);
    };

    const handleDrag = (e: DraggableEvent, ui: DraggableData) => {
        console.log(e);
        console.log(ui);
    };

    const deleteBeacon = (beaconId: number) => {
        console.log("delete beacon : " + beaconId);
        // 리스트 새로 받아오기
    };

    const handleMouseOver = (beaconId: number) => {
        console.log(beaconId);
        setClickedId(beaconId);
    };
    const handleMouseOut = () => {
        setClickedId(-1);
    };

    useEffect(() => {}, [newBeacon, locateIng, clickedId]);

    return (
        <>
            <div className="main_container">
                {page}
                <div className="des_container">
                    {floor.map((e, index) => (
                        <button key={index} onClick={() => setPage(index)}>
                            {e}
                        </button>
                    ))}
                </div>
                <div className="content_container">
                    <div
                        className="model relative h-[80vh] w-[70vw]"
                        id="model"
                        style={{
                            backgroundImage: `url(${testBg})`, // import한 이미지 사용
                            backgroundSize: "cover", // 배경 이미지를 컨테이너에 맞게 조정
                            backgroundPosition: "center", // 배경 이미지를 가운데 정렬
                        }}
                    >
                        {beacons.map((point, index) => (
                            <div
                                key={index}
                                className="beacon-item absolute h-[20px] w-[20px] bg-red-500 rounded-full"
                                style={{
                                    left: `${point.coord.x}px`,
                                    top: `${point.coord.y}px`,
                                    backgroundColor:
                                        point.beaconId == clickedId
                                            ? "red"
                                            : "black",
                                }}
                            />
                        ))}
                        {newBeacon && (
                            <Draggable
                                onStop={(e, ui) => handleDrag(e, ui)}
                                key={newBeacon.beaconId}
                                defaultPosition={{
                                    x: newBeacon.coord.x,
                                    y: newBeacon.coord.y,
                                }}
                                bounds="parent" // 부모 내에서만 이동할 수 있게 하기 !
                                disabled={!locateIng}
                            >
                                <div
                                    key={newBeacon.beaconId}
                                    className="new-beacon-item absolute h-[20px] w-[20px] bg-blue-500 rounded-full"
                                    style={{
                                        left: `${newBeacon.coord.x}`,
                                        top: `${newBeacon.coord.y}`,
                                        cursor: locateIng ? "grab" : "default",
                                    }}
                                />
                            </Draggable>
                        )}
                    </div>

                    <div className="beacon-list">
                        {modalshow ? (
                            <div>
                                <div className="add-content-container">
                                    <div className="InputTextBox">
                                        <div className="type-title">
                                            타입을 <br /> 결정해주세요
                                        </div>
                                        <ul
                                            className="dropdown-in-box"
                                            onClick={() => {
                                                setDropDownOpen(!dropDownOpen);
                                            }}
                                        >
                                            {types[selectType]}
                                            {dropDownOpen && (
                                                <ul
                                                    className="dropdown-container"
                                                    style={{
                                                        position: "absolute",
                                                        top: "100%",
                                                        left: 0,
                                                        backgroundColor:
                                                            "white",
                                                        zIndex: 999,
                                                    }}
                                                >
                                                    {types
                                                        .slice(1)
                                                        .map((data, index) => (
                                                            <li
                                                                key={index}
                                                                onClick={() =>
                                                                    clickType(
                                                                        index
                                                                    )
                                                                }
                                                            >
                                                                {data} {index}
                                                            </li>
                                                        ))}
                                                </ul>
                                            )}
                                        </ul>
                                    </div>
                                    {Options(selectType)}
                                    {!locateIng ? (
                                        <div
                                            className="locate-button"
                                            onClick={locate}
                                        >
                                            위치 지정하기
                                        </div>
                                    ) : (
                                        <div
                                            className="locate-button"
                                            onClick={saveLocate}
                                        >
                                            위치 저장하기
                                        </div>
                                    )}
                                </div>
                                <div className="floating-button">
                                    <div onClick={closeModal}>저장하기</div>
                                </div>
                            </div>
                        ) : (
                            <div className="beacon-scroll">
                                {beacons.map((item, index) => (
                                    <div
                                        className="beacon-list-item"
                                        key={index}
                                    >
                                        <div> {item.name}</div>
                                        <div
                                            className="beacon-modify-button"
                                            onClick={() => {
                                                deleteBeacon(item.beaconId);
                                            }}
                                            onMouseOver={() =>
                                                handleMouseOver(item.beaconId)
                                            }
                                            onMouseOut={handleMouseOut}
                                        >
                                            삭제하기
                                        </div>
                                    </div>
                                ))}
                                <div className="floating-button">
                                    <div onClick={addBeaconModal}>
                                        비콘 추가 하기
                                    </div>
                                </div>
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </>
    );
};

function Options(type: number) {
    switch (type) {
        case 1:
            return (
                <>
                    <div className="input-container">
                        <div className="input-mac">
                            <div>비콘의 주소를 입력해주세요</div>
                            <input type="text" />
                        </div>
                        <div className="input-name">
                            <div>비콘의 이름을 입력해주세요</div>
                            <input type="text" />
                        </div>
                    </div>
                </>
            );
        case 2:
            return (
                <>
                    <div>
                        <div className="input-container">
                            <div className="input-mac">
                                <div className="question">
                                    비콘의 주소를 입력해주세요
                                </div>
                                <input
                                    type="text"
                                    placeholder="ex) 영숫자 총 8자리"
                                />
                            </div>
                            <div className="input-name">
                                <div className="question">
                                    비콘의 이름을 입력해주세요
                                </div>
                                <input
                                    type="text"
                                    placeholder="ex) 4-2스크린도어 비콘"
                                />
                            </div>
                            <div className="input-togo">
                                <div className="question">
                                    어느역 방면인지 입력해주세요
                                </div>
                                <input
                                    type="text"
                                    placeholder="ex) 다대포해수욕장"
                                />
                            </div>
                            <div className="input-mac">
                                <div className="question">
                                    위도를 입력해주세요
                                </div>
                                <input type="number" placeholder="ex) 000" />
                            </div>
                            <div className="input-mac">
                                <div className="question">
                                    경도를 입력해주세요
                                </div>
                                <input type="text" placeholder="ex) 000" />
                            </div>
                        </div>
                    </div>
                </>
            );
        case 3:
            return (
                <>
                    <div>
                        <div className="input-container">
                            <div className="input-mac">
                                <div className="question">
                                    비콘의 주소를 입력해주세요
                                </div>
                                <input
                                    type="text"
                                    placeholder="ex) 영숫자 총 8자리"
                                />
                            </div>
                            <div className="input-name">
                                <div className="question">
                                    비콘의 이름을 입력해주세요
                                </div>
                                <input
                                    type="text"
                                    placeholder="ex) 4-2스크린도어 비콘"
                                />
                            </div>
                            <div className="input-togo">
                                <div className="question">
                                    어느역 방면인지 입력해주세요
                                </div>
                                <input
                                    type="text"
                                    placeholder="ex) 다대포해수욕장"
                                />
                            </div>
                        </div>
                    </div>
                </>
            );
        case 4:
            return (
                <>
                    <div>
                        <div className="input-container">
                            <div className="input-mac">
                                <div className="question">
                                    비콘의 주소를 입력해주세요
                                </div>
                                <input
                                    type="text"
                                    placeholder="ex) 영숫자 총 8자리"
                                />
                            </div>
                            <div className="input-name">
                                <div className="question">
                                    비콘의 이름을 입력해주세요
                                </div>
                                <input
                                    type="text"
                                    placeholder="ex) 4-2스크린도어 비콘"
                                />
                            </div>
                            <div className="input-togo">
                                <div className="question">
                                    어느역 방면인지 입력해주세요
                                </div>
                                <input
                                    type="text"
                                    placeholder="ex) 다대포해수욕장"
                                />
                            </div>
                            <div className="input-screenNumber">
                                <div className="question">
                                    몇번 스크린도어인지 입력해주세요
                                </div>
                                <input type="text" placeholder="ex) 4-2" />
                            </div>
                        </div>
                    </div>
                </>
            );
    }
}

export default Map;
