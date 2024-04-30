import { useEffect, useState, useRef } from "react";
import React from "react";
import Draggable, { DraggableData, DraggableEvent } from "react-draggable";
// import redBeacon from "../assets/redBeacon.gif";
import blueBeacon from "../assets/blueBeacon.gif";
import defaultBeacon from "../assets/defaultBeacon.gif";
import yellowBeacon from "../assets/yellowBeacon.gif";
import testBg from "../assets/testBg.png";
import { Beacon } from "../util/type.tsx";
import {
    ScreenDoor,
    BathRoom,
    Exit,
    Gate,
    Stair,
    Elevator,
} from "./addBeacon/beaconTypeComponent.tsx";
import styles from "./map.module.css";

const types = [
    "미선택",
    "화장실",
    "개찰구",
    "출구",
    "계단",
    "엘리베이터",
    "스크린도어",
];

const floorType = ["대합실", "승강장"];

const Map: React.FC = () => {
    const [floor, setFloor] = useState<number>(0);
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

    // websocket
    const ws = useRef<WebSocket | null>(null); // ws 객체
    // sos 하는 beaconId를 담아둘거임 !
    const [sosBeaconIdList, setSosBeaconIdList] = useState<string[]>([]);

    // 이후에 backend로 받아오기
    const [beacons, setBeacons] = useState<Beacon[]>([
        {
            type: "화장실",
            beaconId: "1",
            coord: { x: 40, y: 30 },
            name: "Beacon 1",
        },
        {
            type: "개찰구",
            beaconId: "2",
            coord: { x: 300, y: 1000 },
            name: "Beacon 2",
        },
        {
            type: "화장실",
            beaconId: "3",
            coord: { x: 40, y: 1000 },
            name: "Beacon 3",
        },
    ]);

    const [page] = useState(0);

    useEffect(() => {
        // websocket 객체 연결
        ws.current = new WebSocket("https://k10e102.k.ssafy.io:8080/socket");

        // listner
        ws.current.onopen = () => {
            console.log("web socket 연결");
        };

        ws.current.onclose = () => {
            console.log("web socket 연결 끊어짐");
        };

        ws.current.onerror = () => {
            console.log("web socket 에러 발생");
        };

        ws.current.onmessage = (event: MessageEvent) => {
            console.log(event.data); // 메세지 출력하기

            // 만약 websocket에서 보내준 메세지의 sessionId가 내 id와 같은 경우
            // sosBeaconList에 추가하기
            setSosBeaconIdList((prev) => [...prev, event.data.beaconId]);
        };

        // 수락 메세지를 보낸 경우 sosBeaconList에서 수락한 비콘 삭제하기

        // websocket ==
        const resizeBeacon = () => {
            console.log("resize");
            const parentTarget = document.querySelector(
                "#model"
            ) as HTMLElement;
            const parentElement = parentTarget.parentElement;
            if (!parentElement) return;
            // 부모 요소의 너비와 높이 가져오삼
            const parentWidth = parentElement.offsetWidth;
            const parentHeight = parentElement.offsetHeight;
            // 백분율 계산
            const newX = (x / parentWidth) * parentWidth;
            const newY = (y / parentHeight) * parentHeight;
            // 상대적인 위치를 상태로 업데이트
            setX(newX);
            setY(newY);
            // 비콘의 위치 업데이트
            const updatedBeacons = beacons.map((beacon) => ({
                ...beacon,
                coord: {
                    // 기존 parentWidth로 바꿔주기
                    x: (beacon.coord.x / parentWidth) * 100,
                    y: (beacon.coord.y / parentHeight) * 100,
                },
            }));
            console.log(updatedBeacons);
            setBeacons(updatedBeacons);
        };
        resizeBeacon();
        window.addEventListener("resize", resizeBeacon);
        return () => {
            setNewBeacon(null);
            window.removeEventListener("resize", resizeBeacon);
        };
    }, []);

    const addBeaconModal = () => {
        setModalshow(true);

        const locate = () => {
            setLocateIng(true);
            setNewBeacon({
                type: types[0],
                beaconId: "1",
                coord: { x: 0, y: 0 },
                name: "beacon",
            });
            setX(0);
            setY(0);
        };

        locate(); // 비콘 새로 놓기
    };

    const sendAcceptMessage = (beaconId: string) => {
        if (ws.current?.OPEN) {
            var data = {
                type: "SOS_ACCEPT",
                beaconId: beaconId,
            };
            ws.current.send(JSON.stringify(data));
        }
    };

    const sendNoMessage = (beaconId: string) => {
        if (ws.current?.OPEN) {
            var data = {
                type: "SOS_ACCEPT",
                beaconId: beaconId,
            };

            ws.current.send(JSON.stringify(data));
        }
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
                            onClick={() => setFloor(index)}
                            style={{
                                cursor: "pointer",
                                backgroundColor:
                                    floor == index ? "navy" : "ivory",
                            }}
                        >
                            {e}
                        </div>
                    ))}
                </div>
                <div className={styles.contentContainer}>
                    <div
                        className={styles.model}
                        id="model"
                        style={{
                            backgroundImage: `url(${testBg})`,
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

                        {beacons.map((point, index) => (
                            <div>
                                {/* {deleteSelectBeacon &&
                                    point.beaconId == deleteSelectBeacon && (
                                        <Modal
                                            isOpen={modalOpen}
                                            onClose={closeModal}
                                            onConfirm={handleConfirm}
                                        />
                                    )} */}
                                <img
                                    key={index}
                                    src={
                                        point.beaconId == clickedId
                                            ? blueBeacon
                                            : defaultBeacon
                                    }
                                    className={styles.beaconItem}
                                    style={{
                                        left: `${point.coord.x}px`,
                                        top: `${point.coord.y}px`,
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
                                    deleteSelectBeacon == item.beaconId ? (
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
                                            <div className={styles.beaconId}>
                                                {" "}
                                                {item.name}
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
                <BathRoom
                    x={x}
                    y={y}
                    floor={floor}
                    closeModal={closeAddModal}
                />
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
