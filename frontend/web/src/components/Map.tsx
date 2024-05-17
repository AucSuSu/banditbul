import { useEffect, useState, useRef } from "react";
import React from "react";
import Draggable, { DraggableData, DraggableEvent } from "react-draggable";
import redBeacon from "../assets/red.gif";
import blueBeacon from "../assets/blue.gif";
import defaultBeacon from "../assets/default.gif";
import yellowBeacon from "../assets/yellow.gif";
import { Beacon, Edge, BeaconCounts, typeToKor } from "../util/type.tsx";
import {
    ScreenDoor,
    Toilet,
    Exit,
    Gate,
    Stair,
    Elevator,
    Escalator,
    Point,
} from "./addBeacon/beaconTypeComponent.tsx";
import styles from "./map.module.css";
import { Axios } from "../util/axios.ts";
import ToggleButton from "./slideToggle/toggle.tsx";
import addBeaconInfo from "../assets/addBeaconInfo.png";
import Icon from "../assets/IconDownArrow.svg";
import IconDelete from "../assets/IconDelete.svg";
import IconUser from "../assets/IconUser.svg";
import IconElevator from "../assets/IconElevator.svg";
import IconEscalator from "../assets/IconEscalator.svg";
import IconExit from "../assets/IconExit.svg";
import IconStair from "../assets/IconStair.svg";
import IconInfo from "../assets/IconInfo.svg";
import IconGate from "../assets/IconGate.svg";
// import IconElevatorWhite from "../assets/IconElevatorWhite.svg";
// import IconEscalatorWhite from "../assets/IconEscalatorWhite.svg";
// import IconExitWhite from "../assets/IconExitWhite.svg";
// import IconStairWhite from "../assets/IconStairWhite.svg";
// import IconInfoWhite from "../assets/IconInfoWhite.svg";
// import IconGateWhite from "../assets/IconGateWhite.svg";
import { stationStore } from "../store";
import { useLoginStore } from "../store"; // Zustand 스토어 import
import Header from "./header.tsx";
import EdgeToggle from "../components/slideToggle/EdgeToggle.tsx";
import IconArrowPrev from "../assets/IconArrowPrev.svg";
const types = [
    "미선택",
    "화장실",
    "개찰구",
    "출구",
    "계단",
    "엘리베이터",
    "에스컬레이터",
    "스크린도어",
    "교차로",
];

const picIcons = [
    { type: "엘리베이터", img: IconElevator },
    { type: "에스컬레이터", img: IconEscalator },
    { type: "출구", img: IconExit },
    { type: "개찰구", img: IconGate },
    { type: "관리실", img: IconInfo },
    { type: "계단", img: IconStair },
];

const Map: React.FC = () => {
    const axios = Axios();
    const stationData = stationStore((state) => state.stationData);
    const loginId = useLoginStore((state) => state.loginId);
    const [floor, setFloor] = useState<number>(-1);
    const [addEdgeState, setAddEdgeState] = useState<boolean>(false);
    const [beaconCounts, setBeaconCounts] = useState<BeaconCounts>({});
    const [edgeList, setEdgeList] = useState<Edge[]>([
        // {
        //     edgeId: 1,
        //     beacon1: "11:22:34",
        //     beacon2: "11:11:34",
        //     beacon1Type: "TOILET",
        //     beacon2Type: "TOILET",
        // },
    ]);
    const [x, setX] = useState<number>(0);
    const [y, setY] = useState<number>(0);
    const [dropDownOpen, setDropDownOpen] = useState<boolean>(false);
    const [clickedBeacon, setClickedBeacon] = useState<string>("-1");
    const [selectType, setSelectType] = useState<number>(0);
    const [locateIng, setLocateIng] = useState<boolean>(false);
    const [modalshow, setModalshow] = useState<boolean>(false);
    const [newBeacon, setNewBeacon] = useState<Beacon | null>(null);
    const [, setModalOpen] = useState(false);
    const [deleteSelectBeacon, setDeleteSelectBeacon] = useState<string | null>(
        null
    );
    const [deleteSelectEdge, setDeleteSelectEdge] = useState<number | null>(
        null
    );
    const [clickedEdge, setClickedEdge] = useState<number>(-1);
    const [selectedEdges, setSelectedEdges] = useState<Beacon[]>([]);
    const [mapImgaeUrl, setMapImageUrl] = useState<string>("https://d3h25rphev0vuf.cloudfront.net/싸피역-1.png");
    const [state, setState] = useState<boolean>(true);

    // websocket
    const ws = useRef<WebSocket | null>(null); // ws 객체
    // test 용
    const [sosBeaconIdList, setSosBeaconIdList] = useState<Set<string>>(
        new Set([])
    );


    const scrollRef = useRef<Record<string, HTMLDivElement | null>>({});


    

    // 이후에 backend로 받아오기
    const [beacons, setBeacons] = useState<Beacon[]>([
        {
            beaconId: "CA:8D:AC:9C:63:64",
            x: 765,
            y: 7,
            beaconTYPE: "TOILET",
        },
        {
            beaconId: "FB:B8:E8:D8:0E:97",
            x: 763,
            y: 185,
            beaconTYPE: "POINT",
        },
        {
            beaconId: "CA:87:66:3E:6E:38",
            x: 588,
            y: 185,
            beaconTYPE: "POINT",
        },
        {
            beaconId: "D0:41:AE:8E:5C:0A",
            x: 590,
            y: 300,
            beaconTYPE: "EXIT",
        },
        {
            beaconId: "DA:B9:B0:9A:CD:76",
            x: 68,
            y: 185,
            beaconTYPE: "STAIR",
        },
        {
            beaconId: "지하 1층 엘리베이터",
            x: 168,
            y: 64,
            beaconTYPE: "ELEVATOR",
        },
        {
            beaconId: "intersection",
            x: 166,
            y: 182,
            beaconTYPE: "POINT",
        },
        {
            beaconId: "D4:5C:67:6A:7A:7A",
            x: 321,
            y: 185,
            beaconTYPE: "GATE",
        },
    ]);

    const getMapInfo = async (floor: number) => {
        console.log("check");
        try {
            console.log("진입 시도");
            const response = await axios.get(`/beaconlist/${floor}`);
            const data = response.data.object;

            if (data != undefined) {
                setBeacons(data.beaconList);
                setEdgeList(data.edgeList);
                setMapImageUrl(data.mapImageUrl);
            }
        } catch (error) {
            console.log(error);
            console.log(beacons);
        }
    };

    useEffect(() => {
        ws.current = new WebSocket("wss://banditbul.co.kr/socket");

        // listner
        ws.current.onopen = () => {
            console.log("web socket 연결");
            const data = {
                sessionId: loginId,
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

        ws.current.onmessage = async (event: MessageEvent) => {
            console.log("socket 통신 메세지" + event.data); // 메세지 출력하기
            const d = JSON.parse(event.data);
            console.log(d.beaconId);
            // 만약 websocket에서 보내준 메세지의 sessionId가 내 id와 같은 경우
            // sosBeaconList에 추가하기
            //앱이 비콘에 입장 시 count 반환
            if (d.type === "MONITOR" && d.count) {
                console.log("Monitor 업데이트");
                setBeaconCounts((prevCounts) => ({
                    ...prevCounts,
                    ...d.count, // 여러 비콘의 카운트를 한 번에 업데이트
                }));
            } else if (d.type == "SOS") {
                const result = await Promise.resolve(
                    beacons.find((e) => e.beaconId === d.beaconId)
                );
                if (!result) {setFloor(floor === -1 ? -2 : -1)} 
                else {
                    const sosBeacon = beacons.filter(e => e.beaconId === d.beaconId);
                    setBeacons(prev => [sosBeacon[0], ...prev.filter(e => e.beaconId !== sosBeacon[0].beaconId)]);
                }
                
                
                
                if (!sosBeaconIdList.has(d.beaconId)) {
                    console.log("sosbeacon등록");
                    const newSosBeaconIdList = new Set(sosBeaconIdList); // 기존 Set 객체를 복사하여 새로운 Set 객체 생성
                    newSosBeaconIdList.add(d.beaconId); // 새로운 Set 객체에 새로운 beaconId 추가
                    setSosBeaconIdList(newSosBeaconIdList);
                } else {
                    console.log("sosbeacon현재 등록되어있음");
                    console.log(sosBeaconIdList);
                }
            } else if (d.type == "CANCEL") {
                if (sosBeaconIdList.has(d.beaconId)) {
                    const newSosBeaconIdList = new Set(sosBeaconIdList); // 기존 Set 객체를 복사하여 새로운 Set 객체 생성
                    newSosBeaconIdList.delete(d.beaconId); // 새로운 Set 객체에 새로운 beaconId 삭제
                    console.log(newSosBeaconIdList);
                    setSosBeaconIdList(newSosBeaconIdList);
                }
            }
            console.log(sosBeaconIdList);
        };
    });

    useEffect(() => {
        console.log("useEffect");
        getMapInfo(floor);
        //websocket 객체 연결
    }, [floor, addEdgeState]);

    useEffect(() => {
        return () => {
            const data = {
                sessionId: loginId,
                type: "CLOSE",
                beaconId: null,
            };
            ws.current!.send(JSON.stringify(data));
        };
    }, []);

    // 간선 연결하기
    const handleRadioChange = (beaconId: string) => {
        console.log(beaconId);
        const isIdNotPresent = selectedEdges.some(function (element) {
            return element.beaconId == beaconId;
        });

        // 갖고 있다면 true
        if (isIdNotPresent) {
            const updatedItems = selectedEdges.filter(
                (item) => item.beaconId !== beaconId
            );
            setSelectedEdges(updatedItems);
            // 연결 안되어 있는 거면 넣어주기
        } else {
            if (selectedEdges.length == 2) {
                alert("두개의 포인트만 연결할 수 있습니다.");
                return;
            }
            alert(beaconId);
            const newBeacon = beacons.find(
                (item) => item.beaconId === beaconId
            );
            setSelectedEdges((prev) => [...prev, newBeacon!]);
        }
    };

    const addBeaconModal = () => {
        setState(true);
        setAddEdgeState(false);
        setModalshow(true);

        const locate = () => {
            setLocateIng(true);
            setNewBeacon({
                beaconTYPE: types[0],
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
        setState(true);
        if (!addEdgeState) {
            setAddEdgeState((prev) => !prev);
        } else {
            if (addEdgeState) {
                console.log(selectedEdges.length);
                if (selectedEdges.length == 2) {
                    // 간선 axios
                    try {
                        const response = await axios.post(`edge`, {
                            beacon1: selectedEdges[0].beaconId,
                            beacon2: selectedEdges[1].beaconId,
                        });
                        console.log(response);

                        setAddEdgeState(!addEdgeState);
                        getMapInfo(floor);
                        setSelectedEdges([]);
                    } catch (error) {
                        console.error(error);
                    }
                } else {
                    alert("간선을 두개 선택해주세요");
                }
            }
        }
    };

    const sendAcceptMessage = (beaconId: string) => {
        if (ws.current?.OPEN) {
            const data = {
                sessionId: loginId,
                type: "SOS_ACCEPT",
                beaconId: beaconId,
                uuId: "test",
            };
            ws.current.send(JSON.stringify(data));
        } else {
            ws.current = new WebSocket("wss://banditbul.co.kr/socket");
            const data = {
                sessionId: loginId,
                type: "SOS_ACCEPT",
                beaconId: beaconId,
                uuId: "test",
            };
            ws.current.send(JSON.stringify(data));
        }

        const newSosBeaconIdList = new Set(sosBeaconIdList); // 기존 Set 객체를 복사하여 새로운 Set 객체 생성
        newSosBeaconIdList.delete(beaconId); // 새로운 Set 객체에 새로운 beaconId 삭제
        console.log(newSosBeaconIdList);
        setSosBeaconIdList(newSosBeaconIdList);
        console.log("수락");
    };

    const sendNoMessage = (beaconId: string) => {
        if (ws.current?.OPEN) {
            const data = {
                sessionId: loginId,
                type: "SOS_FAIL",
                beaconId: beaconId,
                uuId: "test",
            };
            ws.current.send(JSON.stringify(data));
        } else {
            ws.current = new WebSocket("wss://banditbul.co.kr/socket");
        }

        const newSosBeaconIdList = new Set(sosBeaconIdList); // 기존 Set 객체를 복사하여 새로운 Set 객체 생성
        newSosBeaconIdList.delete(beaconId); // 새로운 Set 객체에 새로운 beaconId 삭제
        console.log(newSosBeaconIdList);
        setSosBeaconIdList(newSosBeaconIdList);
        console.log("삭제");
    };

    // 저장이 완료 되었거나 완료하지 않고 닫은 경우
    const closeAddModal = () => {
        // 리스트 새로 받아오기 ===
        console.log("closeModal");
        setNewBeacon(null); // 없애야함
        getMapInfo(floor);
        setModalshow(false);
        setSelectType(0);
    };

    const clickType = (i: number) => {
        setSelectType(i + 1);
    };

    const handleDrag = (e: DraggableEvent, ui: DraggableData) => {
        if (!e.target) return;
        setX(ui.x);
        setY(ui.y);
    };

    const beaconHandleMouseOver = (beaconId: string) => {
        console.log(beaconId);
        setClickedBeacon(beaconId);
    };

    const beaconHandleMouseOut = () => {
        setClickedBeacon("-1");
    };

    const edgeHandleMouseOver = (edgeId: number) => {
        console.log(edgeId);
        setClickedEdge(edgeId);
    };

    const edgeHandleMouseOut = () => {
        setClickedEdge(-1);
    };

    // 삭제 컴포넌트 열기
    const openModal = () => {
        setModalOpen(true);
    };

    // 삭제 컴포넌트 닫긷
    const closeModal = () => {
        setModalOpen(false);
        setDeleteSelectBeacon(null);
        setDeleteSelectEdge(null);
    };

    // 예 버튼 클릭 시 실행 함수 -> 비콘 삭제
    const handleBeaconDeleteConfirm = async () => {
        closeModal(); // 모달 닫기
        if (deleteSelectBeacon != "-1") {
            try {
                console.log("삭제");
                const response = await axios.delete(
                    `/beacon/${deleteSelectBeacon}`
                );
                const data = response.data.object;
                console.log(data);
                getMapInfo(floor);
            } catch (error) {
                console.log(error);
            }
        } else {
            console.log("삭제 오류");
        }
        setDeleteSelectBeacon(null);
    };

    // 예 버튼 클릭 시 실행 함수 -> edge 삭제
    const handleEdgeDeleteConfirm = async () => {
        closeModal(); // 모달 닫기
        if (deleteSelectEdge != -1) {
            try {
                console.log("삭제");
                const response = await axios.delete(
                    `/edge/${deleteSelectEdge}`
                );
                const data = response.data.object;
                console.log(data);
                getMapInfo(floor);
            } catch (error) {
                console.log(error);
            }
        } else {
            console.log("삭제 오류");
        }
        setDeleteSelectEdge(null);
    };

    return (
        <>
            <div
                className={styles.mainContainer}
                style={{
                    backgroundImage: `url(https://d3h25rphev0vuf.cloudfront.net/bg.png)`,
                }}
            >
                <div className={styles.contentContainer}>
                    <div className={styles.leftBackground}>
                        <div className={styles.leftContainer}>
                        <Header
                            line={stationData.line}
                            name={stationData.stationName}
                        />
                            {!modalshow && (
                                <EdgeToggle state={state} setState={setState} />
                            )}
                            <div
                                className={styles.beaconList}
                                style={{
                                    height: modalshow ? "100%" : "80%",
                                    backgroundColor: modalshow
                                        ? "white"
                                        : "transparent",
                                    boxShadow: modalshow
                                        ? "0px 4px 16px rgba(0, 0, 0, 0.2)"
                                        : "",
                                }}
                            >
                                {modalshow ? (
                                    <>
                                        <div className={styles.addContentContainer}>
                                            <div className={styles.titleBox}>
                                                <div className={styles.optionBox}>
                                                    <div
                                                        className={styles.typeTitle}
                                                        onClick={closeAddModal}
                                                    >
                                                        <img
                                                            src={IconArrowPrev}
                                                            alt=""
                                                        />
                                                        back
                                                    </div>
                                                    <ul
                                                        className={
                                                            styles.dropdownInBox
                                                        }
                                                        onClick={() => {
                                                            setDropDownOpen(
                                                                !dropDownOpen
                                                            );
                                                        }}
                                                    >
                                                        <div
                                                            className={
                                                                styles.selectedItem
                                                            }
                                                        >
                                                            {types[selectType]}
                                                            <img
                                                                className={
                                                                    styles.downIcon
                                                                }
                                                                src={Icon}
                                                                alt=""
                                                            />
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
                                                                    .map(
                                                                        (
                                                                            data,
                                                                            index
                                                                        ) => (
                                                                            <li
                                                                                className={
                                                                                    styles.dropdownItem
                                                                                }
                                                                                key={
                                                                                    index
                                                                                }
                                                                                onClick={() =>
                                                                                    clickType(
                                                                                        index
                                                                                    )
                                                                                }
                                                                            >
                                                                                {
                                                                                    data
                                                                                }
                                                                            </li>
                                                                        )
                                                                    )}
                                                            </ul>
                                                        )}
                                                    </ul>
                                                </div>
                                                <div
                                                    className={styles.addBeaconDes}
                                                >
                                                    <img src={addBeaconInfo} />

                                                    <div
                                                        className={
                                                            styles.information
                                                        }
                                                        style={{ color: "black" }}
                                                    >
                                                        우측 반딧불 아이콘을 원하는
                                                        위치에 드래그하세요! <br />
                                                        모든 위치는 바라보는 방향
                                                        기준으로 지정해주세요.
                                                    </div>
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
                                        {state ? (
                                            <>
                                                {beacons.map((item, index) =>
                                                    sosBeaconIdList.has(
                                                        item.beaconId
                                                    ) ? (
                                                        <div
                                                            className={
                                                                styles.sosbeaconListItem
                                                            }
                                                            key={index}
                                                            onMouseOver={() =>
                                                                beaconHandleMouseOver(
                                                                    item.beaconId
                                                                )
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
                                                                    SOS 신호가
                                                                    발생되었습니다
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
                                                    ) : deleteSelectBeacon ==
                                                    item.beaconId ? (
                                                        <>
                                                            <div
                                                                className={
                                                                    styles.beaconListItem
                                                                }
                                                                key={index}
                                                                onMouseOver={() =>
                                                                    beaconHandleMouseOver(
                                                                        item.beaconId
                                                                    )
                                                                }
                                                                onMouseOut={
                                                                    beaconHandleMouseOut
                                                                }
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
                                                                                handleBeaconDeleteConfirm
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
                                                                            onClick={
                                                                                closeModal
                                                                            }
                                                                        >
                                                                            아니오
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </>
                                                    ) : (
                                                        <div
                                                            className={
                                                                styles.beaconListItem
                                                            }
                                                            key={index}
                                                            ref={(el) => (scrollRef.current[index] = el)}
                                                            onMouseOver={() =>
                                                                beaconHandleMouseOver(
                                                                    item.beaconId
                                                                )
                                                            }
                                                            onMouseOut={
                                                                beaconHandleMouseOut
                                                            }
                                                            onClick={() =>
                                                                handleRadioChange(
                                                                    item.beaconId
                                                                )
                                                            }
                                                        >
                                                            {addEdgeState && (
                                                                <input
                                                                    type="radio"
                                                                    id={`option-${index}`}
                                                                    checked={selectedEdges.some(
                                                                        (data) =>
                                                                            data.beaconId ===
                                                                            item.beaconId
                                                                    )}
                                                                />
                                                            )}
                                                            <div
                                                                className={
                                                                    styles.beaconId
                                                                }
                                                            >
                                                                {typeToKor(
                                                                    item.beaconTYPE!
                                                                )}
                                                            </div>
                                                            <img
                                                                src={IconUser}
                                                                alt=""
                                                            />
                                                            <div
                                                                className={
                                                                    styles.numberOfUser
                                                                }
                                                            >
                                                                {beaconCounts[
                                                                    item.beaconId
                                                                ]
                                                                    ? ` ${
                                                                        beaconCounts[
                                                                            item
                                                                                .beaconId
                                                                        ]
                                                                    }`
                                                                    : "0"}
                                                            </div>
                                                            <img
                                                                src={IconDelete}
                                                                alt=""
                                                                className={
                                                                    styles.beaconDeleteButton
                                                                }
                                                                onClick={() => {
                                                                    openModal();
                                                                    setDeleteSelectBeacon(
                                                                        item.beaconId
                                                                    );
                                                                }}
                                                            />
                                                        </div>
                                                    )
                                                )}
                                            </>
                                        ) : (
                                            <>
                                                {edgeList.map((item, index) =>
                                                    deleteSelectEdge ==
                                                    item.edgeId ? (
                                                        <>
                                                            <div
                                                                className={
                                                                    styles.beaconListItem
                                                                }
                                                                key={index}
                                                                onMouseOver={() =>
                                                                    edgeHandleMouseOver(
                                                                        item.edgeId
                                                                    )
                                                                }
                                                                onMouseOut={
                                                                    edgeHandleMouseOut
                                                                }
                                                            >
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
                                                                                handleEdgeDeleteConfirm
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
                                                                            onClick={
                                                                                closeModal
                                                                            }
                                                                        >
                                                                            아니오
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </>
                                                    ) : (
                                                        <>
                                                            <div
                                                                className={
                                                                    styles.beaconListItem
                                                                }
                                                                key={index}
                                                                onMouseOver={() =>
                                                                    edgeHandleMouseOver(
                                                                        item.edgeId
                                                                    )
                                                                }
                                                                onMouseOut={
                                                                    edgeHandleMouseOut
                                                                }
                                                            >
                                                                <div
                                                                    className={
                                                                        styles.beaconId
                                                                    }
                                                                >
                                                                    {typeToKor(
                                                                        item.beacon1Type!
                                                                    )}
                                                                    -
                                                                    {typeToKor(
                                                                        item.beacon2Type!
                                                                    )}
                                                                </div>
                                                                <img
                                                                    src={IconDelete}
                                                                    alt=""
                                                                    className={
                                                                        styles.beaconDeleteButton
                                                                    }
                                                                    onClick={() => {
                                                                        openModal();
                                                                        setDeleteSelectEdge(
                                                                            item.edgeId
                                                                        );
                                                                    }}
                                                                />
                                                            </div>
                                                        </>
                                                    )
                                                )}
                                            </>
                                        )}
                                    </div>
                                )}
                            </div>
                            {!modalshow && (
                                <div className={styles.buttonContainer}>
                                    <div
                                        className={styles.addEdgeButton}
                                        onClick={addEdgeModal}
                                        style={{ cursor: "pointer" }}
                                    >
                                        {addEdgeState
                                            ? "저장하기"
                                            : "경로 등록하기"}
                                    </div>
                                    {addEdgeState ? (
                                        <div
                                            className={styles.floatingButton}
                                            onClick={() => {
                                                setAddEdgeState(false);
                                                setSelectedEdges([]);
                                            }}
                                            style={{ cursor: "pointer" }}
                                        >
                                            취소하기
                                        </div>
                                    ) : (
                                        <div
                                            className={styles.floatingButton}
                                            onClick={addBeaconModal}
                                            style={{ cursor: "pointer" }}
                                        >
                                            비콘 추가 하기
                                        </div>
                                    )}
                                </div>
                            )}
                        </div>
                    </div>

                    {/* breakpoint */}

                    <div className={styles.rightContainer}>
                        <div className={styles.stationBackground}>
                        <div className={styles.modelTitleContainer}>
                            <div className={styles.picContainer}>
                                {picIcons.map((data, index) => (
                                    <div className={styles.picItem} key={index}>
                                        <img
                                            className={styles.pic}
                                            src={data.img}
                                            alt=""
                                        />
                                        <div className={styles.typeName}>
                                            {data.type}
                                        </div>
                                    </div>
                                ))}
                            </div>
                            <ToggleButton floor={floor} setFloor={setFloor} />
                        </div>
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
                                            cursor: locateIng
                                                ? "grab"
                                                : "default",
                                        }}
                                    />
                                </Draggable>
                            )}

                            <svg className={styles.edge}>
                                {selectedEdges.length == 2 && (
                                    <>
                                        <line
                                            x1={selectedEdges[0].x + 50}
                                            y1={selectedEdges[0].y + 65}
                                            x2={selectedEdges[1].x + 50}
                                            y2={selectedEdges[1].y + 65}
                                            style={{
                                                height: "1px",
                                                stroke: "#6565ff",
                                                strokeWidth: 3,
                                            }}
                                        />
                                    </>
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
                                        <line
                                            key={index}
                                            x1={startPoint.x + 50}
                                            y1={startPoint.y + 65}
                                            x2={endPoint.x + 50}
                                            y2={endPoint.y + 65}
                                            style={{
                                                height: "1px",
                                                stroke:
                                                    edge.edgeId == clickedEdge
                                                        ? "#6565ff"
                                                        : "black",
                                                strokeWidth: 3,
                                            }}
                                        />
                                    );
                                })}
                            </svg>

                            {beacons.map((point, index) => (
                                <div key={index}>
                                    <img
                                        key={index}
                                        src={
                                            sosBeaconIdList.has(point.beaconId)
                                                ? redBeacon
                                                : point.beaconId ==
                                                  clickedBeacon
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
                    </div>
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

        case 8:
            return (
                <Point x={x} y={y} floor={floor} closeModal={closeAddModal} />
            );
    }
}

export default Map;
