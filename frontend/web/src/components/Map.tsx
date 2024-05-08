import { useEffect, useState, useRef } from "react";
import React from "react";
import Draggable, { DraggableData, DraggableEvent } from "react-draggable";
// import redBeacon from "../assets/redBeacon.gif";
import blueBeacon from "../assets/blueBeacon.gif";
import defaultBeacon from "../assets/defaultBeacon.gif";
import yellowBeacon from "../assets/yellowBeacon.gif";
// import testBg from "../assets/testBg.png";
import { Beacon, Edge, MapInfo } from "../util/type.tsx";
import {
    ScreenDoor,
    Toilet,
    Exit,
    Gate,
    Stair,
    Elevator,
    Escalator,
} from "./addBeacon/beaconTypeComponent.tsx";
import styles from "./map.module.css";
import { getMapFunc } from "../store.tsx";
import { Axios } from '../util/axios.ts';

const types = [
    "미선택",
    "화장실",
    "개찰구",
    "출구",
    "계단",
    "엘리베이터",
    "에스컬레이터",
    "스크린도어",
];

const floorType = [
    { title: "대합실", floor: -1 },
    { title: "승강장", floor: -2 },
];

const Map: React.FC = () => {
    const axios = Axios()
    const [floor, setFloor] = useState<number>(-1);
    const [addEdgeState, setAddEdgeState] = useState<boolean>(false);
    // const [edgeList, setEdgeList] = useState<Edge[]>([
    //     // { beacon1: "1", beacon2: "2" },
    //     // { beacon1: "2", beacon2: "3" },
    //     // { beacon1: "3", beacon2: "1" },
    // ]);
    const [edgeList, setEdgeList] = useState<Edge[]>([]);
    const [x, setX] = useState<number>(0);
    const [y, setY] = useState<number>(0);
    const [dropDownOpen, setDropDownOpen] = useState<boolean>(false);
    const [clickedId, setClickedId] = useState<string>("-1");
    const [selectType, setSelectType] = useState<number>(0);
    const [locateIng, setLocateIng] = useState<boolean>(false);
    const [modalshow, setModalshow] = useState<boolean>(false);
    const [newBeacon, setNewBeacon] = useState<Beacon | null>(null);
    const [, setModalOpen] = useState(false);
    const [deleteSelectBeacon, setDeleteSelectBeacon] = useState<string | null>(
        null
    );
    const [selectedEdges, setSelectedEdges] = useState<string[]>([]);
    const [mapImgaeUrl, setMapImageUrl] = useState<string>();

    // websocket
    const ws = useRef<WebSocket | null>(null); // ws 객체
    // test 용
    const [sosBeaconIdList, setSosBeaconIdList] = useState<Set<string>>(
        new Set(["11:22:33:44:60"])
    );

    // sos 하는 beaconId를 담아둘거임 ! -> 현재 빌드를 위해서 이거 죽이고
    // const [sosBeaconIdList, _] = useState<Set<string>>(new Set());

    // 이후에 backend로 받아오기
    const [beacons, setBeacons] = useState<Beacon[]>([
        {
            beaconId: "1",
            x: 40,
            y: 30,
        },
        {
            beaconId: "11:22:33:44:55",
            x: 40,
            y: 30,
        },
        {
            beaconId: "11:22:33:44:60",
            x: 40,
            y: 30,
        },
    ]);

    const [page] = useState(0);

    const getMapInfo = async (floor: number) => {
        try {
            const data: MapInfo = await getMapFunc(floor);
            if (data != undefined) {
                setBeacons(data.beaconList);
                setEdgeList(data.edgeList);
                setMapImageUrl(data.mapImageUrl);
                alert("성공");
            }
        } catch (error) {
            console.log(error);
            alert("실패");
        }
    };

    // const getMapInfo = async (floor: number) => {
    //     const api = "https://banditbul.co.kr/api";
    //     // zustand 에서 값 가져오기
    //     try {
    //         const response = await axios.get(`${api}/beaconlist/${floor}`);
    //         const data = response.data.object;
    //         console.log(data);
    //         setBeacons(data.beaconList);
    //         setAddEdgeState(data.edgeList);
    //         setMapImageUrl(data.mapImgaeUrl);
    //         alert("성공");
    //         // return data;
    //     } catch (error) {
    //         console.error(error);
    //         alert("실패");
    //     }
    // };

    useEffect(() => {
        getMapInfo(floor);
        //websocket 객체 연결
        ws.current = new WebSocket("wss://banditbul.co.kr/socket");
        //ws.current = new WebSocket("wss://localhost:8080/socket");

        // listner
        ws.current.onopen = () => {
            console.log("web socket 연결");
            const data = {
                sessionId: "b",
                type: "ENTER",
                beaconId: null,
            };
            ws.current!.send(JSON.stringify(data));
        };

        ws.current.onclose = () => {
            console.log("web socket 연결 끊어짐");
            ws.current = new WebSocket("wss://banditbul.co.kr/socket");
        };

        ws.current.onerror = () => {
            console.log("web socket 에러 발생");
            ws.current = new WebSocket("wss://banditbul.co.kr/socket");
        };

        ws.current.onmessage = (event: MessageEvent) => {
            console.log("socket 통신 메세지" + event.data); // 메세지 출력하기
            // 만약 websocket에서 보내준 메세지의 sessionId가 내 id와 같은 경우
            // sosBeaconList에 추가하기
            const newSosBeaconIdList = sosBeaconIdList.add(event.data.beaconId);
            if (!newSosBeaconIdList.has(event.data.beaconId)) {
                setSosBeaconIdList(newSosBeaconIdList);
            }
        };

        // 수락 메세지를 보낸 경우 sosBeaconList에서 수락한 비콘 삭제하기

        // websocket ==
        // const resizeBeacon = () => {
        //     console.log("resize");
        //     const parentTarget = document.querySelector(
        //         "#model"
        //     ) as HTMLElement;
        //     const parentElement = parentTarget.parentElement;
        //     if (!parentElement) return;
        //     // 부모 요소의 너비와 높이 가져오삼
        //     const parentWidth = parentElement.offsetWidth;
        //     const parentHeight = parentElement.offsetHeight;
        //     // 백분율 계산
        //     const newX = (x / parentWidth) * parentWidth;
        //     const newY = (y / parentHeight) * parentHeight;
        //     // 상대적인 위치를 상태로 업데이트
        //     setX(newX);
        //     setY(newY);
        //     // 비콘의 위치 업데이트
        //     const updatedBeacons = beacons.map((beacon) => ({
        //         ...beacon,
        //         coord: {
        //             // 기존 parentWidth로 바꿔주기
        //             x: (beacon.x / parentWidth) * 100,
        //             y: (beacon.y / parentHeight) * 100,
        //         },
        //     }));
        //     console.log(updatedBeacons);
        //     setBeacons(updatedBeacons);
        // };
        // resizeBeacon();
        // window.addEventListener("resize", resizeBeacon);
        // return () => {
        //     setNewBeacon(null);
        //     window.removeEventListener("resize", resizeBeacon);
        // };
    }, [floor]);

    useEffect(() => {
        return () => {
            const data = {
                sessionId: "b",
                type: "CLOSE",
                beaconId: null,
            };
            ws.current!.send(JSON.stringify(data));
        };
    }, []);

    // 간선 연결하기
    const handleRadioChange = (beaconId: string) => {
        // 이미 연결되어 있는 거면 취소
        if (selectedEdges.includes(beaconId)) {
            console.log("지우기");
            const updatedItems = selectedEdges.filter(
                (item) => item !== beaconId
            );
            setSelectedEdges(updatedItems);
            // 연결 안되어 있는 거면 넣어주기
        } else {
            if (selectedEdges.length == 2) {
                alert("두개의 포인트만 연결할 수 있습니다.");
                return;
            }
            console.log("추가하기");
            setSelectedEdges((prev) => [...prev, beaconId]);
        }
    };

    const addBeaconModal = () => {
        setAddEdgeState(false);
        setModalshow(true);

        const locate = () => {
            setLocateIng(true);
            setNewBeacon({
                type: types[0],
                beaconId: "1",
                x: 0,
                y: 0,
            });
            setX(0);
            setY(0);
        };

        locate(); // 비콘 새로 놓기
    };

    const addEdgeModal = async () => {
        if (addEdgeState) {
            console.log(selectedEdges.length);
            if (selectedEdges.length == 2) {
                // 간선 axios

                try {
                    const response = await axios.post(
                        `edge`,
                        {
                            beacon1: selectedEdges[0],
                            beacon2: selectedEdges[1],
                        }
                    );
                    console.log(response);
                    getMapInfo(floor);
                    alert("성공");
                } catch (error) {
                    console.error(error);
                    alert("실패");
                }
            } else {
                alert("간선을 두개 선택해주세요");
            }
        }
        // 각 비콘 선택 가능하게 하기
        setAddEdgeState(!addEdgeState);
        // setSelectedEdges([]);
        // 버튼은 저장하기로 바꾸기
    };

    const sendAcceptMessage = (beaconId: string) => {
        if (ws.current?.OPEN) {
            const data = {
                sessionId: "b",
                type: "SOS_ACCEPT",
                beaconId: beaconId,
            };
            ws.current.send(JSON.stringify(data));
        } else {
            ws.current = new WebSocket("wss://banditbul.co.kr/socket");
            const data = {
                sessionId: "b",
                type: "SOS_ACCEPT",
                beaconId: beaconId,
            };
            ws.current.send(JSON.stringify(data));
        }
        // sosList에서 비콘 지우기
        sosBeaconIdList.delete(beaconId);
        const updateSet = new Set(sosBeaconIdList);
        setSosBeaconIdList(updateSet);
    };

    const sendNoMessage = (beaconId: string) => {
        if (ws.current?.OPEN) {
            const data = {
                sessionId: "b",
                type: "SOS_FAIL",
                beaconId: beaconId,
            };
            ws.current.send(JSON.stringify(data));
        } else {
            ws.current = new WebSocket("wss://banditbul.co.kr/socket");
        }

        sosBeaconIdList.delete(beaconId);
        const updateSet = new Set(sosBeaconIdList);
        setSosBeaconIdList(updateSet);
    };

    // 저장이 완료 되었거나 완료하지 않고 닫은 경우
    const closeAddModal = () => {
        // 리스트 새로 받아오기 ===
        setNewBeacon(null); // 없애야함
        setModalshow(false);
        setSelectType(0);
    };

    const clickType = (i: number) => {
        setSelectType(i + 1);
    };

    const handleDrag = (e: DraggableEvent, ui: DraggableData) => {
        if (!e.target) return;

        // 상대 위치 계산
        // const parentTarget = document.querySelector(".model") as HTMLElement;
        // const parentElement = parentTarget.parentElement;
        // if (!parentElement) return; // 예외 처리: 부모 요소가 없는 경우
        // // 부모 요소의 너비와 높이 가져오기
        // const parentWidth = parentElement.offsetWidth;
        // const parentHeight = parentElement.offsetHeight;
        // // 드래그된 요소의 위치 계산
        // const relativeX = (ui.x / parentWidth) * 100;
        // const relativeY = (ui.y / parentHeight) * 100;

        setX(ui.x);
        setY(ui.y);
    };

    const deleteBeacon = (beaconId: string) => {
        console.log("delete beacon : " + beaconId);
    };

    const handleMouseOver = (beaconId: string) => {
        console.log(beaconId);
        setClickedId(beaconId);
    };

    const handleMouseOut = () => {
        setClickedId("-1");
    };

    // 삭제 컴포넌트 열기
    const openModal = () => {
        setModalOpen(true);
    };

    // 삭제 컴포넌트 닫긷
    const closeModal = () => {
        setModalOpen(false);
        setDeleteSelectBeacon(null);
    };

    // 예 버튼 클릭 시 실행 함수
    const handleConfirm = () => {
        // 여기에 예 버튼을 눌렀을 때 실행할 함수를 호출하거나 코드를 작성하세요.
        alert("삭제 함수 실행"); // 예시로 경고창을 띄움
        closeModal(); // 모달 닫기
        if (deleteSelectBeacon) {
            alert("삭제 완료");
            deleteBeacon(deleteSelectBeacon);
        } else {
            console.log("삭제 오류");
        }
        setDeleteSelectBeacon(null);
    };

    return (
        <>
            <div className={styles.mainContainer}>
                {page}
                <div className={styles.des_container}>
                    {floorType.map((e, index) => (
                        <div
                            key={index}
                            onClick={() => setFloor(e.floor)}
                            style={{
                                cursor: "pointer",
                                backgroundColor:
                                    floor == index ? "navy" : "ivory",
                            }}
                        >
                            {e.title}
                        </div>
                    ))}
                </div>
                <div className={styles.contentContainer}>
                    <div
                        className={styles.model}
                        id="model"
                        style={{
                            backgroundImage: `url(${mapImgaeUrl})`,
                            backgroundSize: "contain",
                            backgroundPosition: "center",
                            backgroundRepeat: "no-repeat",
                        }}
                    >
                        {newBeacon && (
                            <Draggable
                                onStop={(e, ui) => handleDrag(e, ui)}
                                key={newBeacon.beaconId}
                                position={{
                                    x: x,
                                    y: y,
                                }}
                                bounds="parent" // 부모 내에서만 이동할 수 있게 하기 !
                                disabled={!locateIng}
                            >
                                <img
                                    key={newBeacon.beaconId}
                                    src={yellowBeacon}
                                    className={styles.newBeaconItem}
                                    style={{
                                        cursor: locateIng ? "grab" : "default",
                                    }}
                                />
                            </Draggable>
                        )}

                        {edgeList.map((edge, index) => {
                            const beacon1 = edge.beacon1;
                            const beacon2 = edge.beacon2;
                            const startPoint = beacons.find(
                                (point) => point.beaconId === beacon1
                            )!;
                            const endPoint = beacons.find(
                                (point) => point.beaconId === beacon2
                            )!;

                            return (
                                <svg
                                    key={`line-${index}`}
                                    className={styles.edge}
                                >
                                    <line
                                        x1={startPoint.x + 15}
                                        y1={startPoint.y + 15}
                                        x2={endPoint.x + 15}
                                        y2={endPoint.y + 15}
                                        style={{
                                            stroke: "black",
                                            strokeWidth: 2,
                                        }}
                                    />
                                </svg>
                            );
                        })}

                        {beacons.map((point, index) => (
                            <div key={index}>
                                <img
                                    key={index}
                                    src={
                                        point.beaconId == clickedId
                                            ? blueBeacon
                                            : defaultBeacon
                                    }
                                    className={styles.beaconItem}
                                    style={{
                                        left: `${point.x}px`,
                                        top: `${point.y}px`,
                                    }}
                                />
                            </div>
                        ))}
                    </div>

                    <div className={styles.beaconList}>
                        {modalshow ? (
                            <>
                                <div className={styles.addContentContainer}>
                                    <div className={styles.inputTextBox}>
                                        <ul
                                            className={styles.dropdownInBox}
                                            onClick={() => {
                                                setDropDownOpen(!dropDownOpen);
                                                console.log("clicked");
                                            }}
                                        >
                                            <div
                                                className={styles.selectedItem}
                                            >
                                                {types[selectType]}
                                                {/* {dropDownOpen ? "▼" : "▲"} */}
                                                <div
                                                    className={
                                                        styles.horizontalLine
                                                    }
                                                ></div>
                                            </div>
                                            {dropDownOpen && (
                                                <ul
                                                    className={
                                                        styles.dropdownContainer
                                                    }
                                                    style={{}}
                                                >
                                                    {types
                                                        .slice(1)
                                                        .map((data, index) => (
                                                            <li
                                                                className={
                                                                    styles.dropdownItem
                                                                }
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
                                        <div className={styles.typeTitle}>
                                            등록하기
                                        </div>
                                    </div>
                                    {Options(
                                        selectType,
                                        x,
                                        y,
                                        floor,
                                        closeAddModal
                                    )}
                                </div>
                            </>
                        ) : (
                            <div className={styles.beaconScroll}>
                                {beacons.map((item, index) =>
                                    sosBeaconIdList.has(item.beaconId) ? (
                                        <div
                                            className={styles.sosbeaconListItem}
                                            key={index}
                                            onMouseOver={() =>
                                                handleMouseOver(item.beaconId)
                                            }
                                        >
                                            <div
                                                className={
                                                    styles.sosBeaconContent
                                                }
                                            >
                                                <p
                                                    className={
                                                        styles.sosBeaconTitle
                                                    }
                                                >
                                                    SOS 신호가 발생되었습니다
                                                    <br />
                                                    {/* 위치를 확인하고 도움을
                                                    주세요 */}
                                                </p>
                                            </div>
                                            <div
                                                className={
                                                    styles.yesNoContainer
                                                }
                                            >
                                                <span
                                                    className={
                                                        styles.sosAcceptButton
                                                    }
                                                    onClick={() => {
                                                        sendAcceptMessage(
                                                            item.beaconId
                                                        );
                                                    }}
                                                >
                                                    수락
                                                </span>
                                                <span
                                                    className={
                                                        styles.sosDenyButton
                                                    }
                                                    onClick={() => {
                                                        sendNoMessage(
                                                            item.beaconId
                                                        );
                                                    }}
                                                >
                                                    거부
                                                </span>
                                            </div>
                                        </div>
                                    ) : deleteSelectBeacon == item.beaconId ? (
                                        <>
                                            <div
                                                className={
                                                    styles.beaconListItem
                                                }
                                                key={index}
                                                onMouseOver={() =>
                                                    handleMouseOver(
                                                        item.beaconId
                                                    )
                                                }
                                                onMouseOut={handleMouseOut}
                                            >
                                                {" "}
                                                <div
                                                    className={
                                                        styles.deleteModalContent
                                                    }
                                                >
                                                    <p
                                                        className={
                                                            styles.deleteDes
                                                        }
                                                    >
                                                        삭제하시겠습니까?
                                                    </p>
                                                    <div
                                                        className={
                                                            styles.yesNoContainer
                                                        }
                                                    >
                                                        <span
                                                            onClick={
                                                                handleConfirm
                                                            }
                                                            className={
                                                                styles.ModaldeleteButton
                                                            }
                                                        >
                                                            예
                                                        </span>
                                                        <span
                                                            className={
                                                                styles.deleteModalCloseButton
                                                            }
                                                            onClick={closeModal}
                                                        >
                                                            아니오
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </>
                                    ) : (
                                        <div
                                            className={styles.beaconListItem}
                                            key={index}
                                            onMouseOver={() =>
                                                handleMouseOver(item.beaconId)
                                            }
                                            onMouseOut={handleMouseOut}
                                        >
                                            {addEdgeState && (
                                                <input
                                                    type="radio"
                                                    id={`option-${index}`}
                                                    checked={selectedEdges.includes(
                                                        item.beaconId
                                                    )}
                                                    onClick={() =>
                                                        handleRadioChange(
                                                            item.beaconId
                                                        )
                                                    }
                                                />
                                            )}
                                            <div className={styles.beaconId}>
                                                {" "}
                                                {item.beaconId}
                                            </div>

                                            <div
                                                className={
                                                    styles.beaconDeleteButton
                                                }
                                                onClick={() => {
                                                    openModal();
                                                    setDeleteSelectBeacon(
                                                        item.beaconId
                                                    );
                                                }}
                                            >
                                                삭제하기
                                            </div>
                                        </div>
                                    )
                                )}
                                <div className={styles.addEdgeButton}>
                                    <div
                                        onClick={addEdgeModal}
                                        style={{ cursor: "pointer" }}
                                    >
                                        {addEdgeState
                                            ? "저장하기"
                                            : "경로 등록하기"}
                                    </div>
                                </div>
                                <div className={styles.floatingButton}>
                                    <div
                                        onClick={addBeaconModal}
                                        style={{ cursor: "pointer" }}
                                    >
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

function Options(
    type: number,
    x: number,
    y: number,
    floor: number,
    closeAddModal: () => void
) {
    switch (type) {
        case 1:
            return (
                <Toilet x={x} y={y} floor={floor} closeModal={closeAddModal} />
            );
        case 2:
            return (
                <Gate x={x} y={y} floor={floor} closeModal={closeAddModal} />
            );
        case 3:
            return (
                <Exit x={x} y={y} floor={floor} closeModal={closeAddModal} />
            );
        case 4:
            return (
                <Stair x={x} y={y} floor={floor} closeModal={closeAddModal} />
            );
        case 5:
            return (
                <Elevator
                    x={x}
                    y={y}
                    floor={floor}
                    closeModal={closeAddModal}
                />
            );
        case 6:
            return (
                <Escalator
                    x={x}
                    y={y}
                    floor={floor}
                    closeModal={closeAddModal}
                />
            );
        case 7:
            return (
                <ScreenDoor
                    x={x}
                    y={y}
                    floor={floor}
                    closeModal={closeAddModal}
                />
            );
    }
}

export default Map;
