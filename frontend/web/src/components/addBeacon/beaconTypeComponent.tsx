import { useState } from "react";
import React from "react";
import styles from "./beaconTypeComponent.module.css";
import { RequestAddBeacon } from "../../util/type";
import axios from "axios";

interface IScreenDoorProps {
    x: number;
    y: number;
    floor: number;
    closeModal: Function;
}

interface ButtonsProps {
    save: () => void;
    cancel: () => void;
}

const ButtonContainer: React.FC<ButtonsProps> = ({ save, cancel }) => {
    return (
        <>
            <div className={styles.buttonContainer}>
                <div className={styles.saveButton} onClick={save}>
                    저장하기
                </div>
                <div className={styles.cancelButton} onClick={cancel}>
                    취소
                </div>
            </div>
        </>
    );
};

const addBeaconRequest = async (data: RequestAddBeacon) => {
    const api = "https://banditbul.co.kr/api";

    try {
        const response = await axios.post(`${api}/beacon`, data);
        console.log(response);
        alert("성공");
    } catch (error) {
        console.error(error);
        alert("실패");
    }
};

// 화장실
export const Toilet: React.FC<IScreenDoorProps> = (props) => {
    const [boySelectShow, setBoySelectShow] = useState<boolean>(false);
    const [girSelectShow, setGirlSelectShow] = useState<boolean>(false);
    const [boy, setBoy] = useState<string | null>(null);
    const [girl, setGirl] = useState<string | null>(null);

    const [formData, setFormData] = useState({
        macAddress: "",
        latitude: 0,
        longitude: 0,
    });

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
    };

    const saveBeacon = () => {
        const data: RequestAddBeacon = {
            macAddress: formData.macAddress,
            range: 2,
            longitude: formData.longitude,
            latitude: formData.latitude,
            beaconType: "TOILET",
            x: props.x,
            y: props.y,
            floor: props.floor,
            manDir: boy,
            womanDir: girl,
        };

        console.log(data);
        addBeaconRequest(data);
        props.closeModal();
    };

    const cancel = () => {
        props.closeModal();
    };

    return (
        <>
            <div className={styles.inputContainer}>
                <div className={styles.column}>
                    <div className={styles.question}>비콘의 주소 </div>
                    <input
                        name="macAddress"
                        type="text"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>위도 </div>
                    <input
                        name="latitude"
                        type="number"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>경도 </div>
                    <input
                        type="text"
                        name="longitude"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>남자 화장실 위치</div>
                    <ul
                        className={styles.dropdownInBox}
                        onClick={() => {
                            setBoySelectShow(!boySelectShow);
                        }}
                    >
                        {boy === null
                            ? "없음"
                            : (() => {
                                  switch (boy) {
                                      case "R":
                                          return "오른쪽";
                                      case "L":
                                          return "왼쪽";
                                      default:
                                          return "앞쪽";
                                  }
                              })()}
                        {boySelectShow && (
                            <ul className={styles.dropdownContainer}>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setBoy(null);
                                        setBoySelectShow(false);
                                    }}
                                >
                                    없음
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setBoy("R");
                                        setBoySelectShow(false);
                                    }}
                                >
                                    오른쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setBoy("L");
                                        setBoySelectShow(false);
                                    }}
                                >
                                    왼쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setBoy("F");
                                        setBoySelectShow(false);
                                    }}
                                >
                                    앞쪽
                                </li>
                            </ul>
                        )}
                    </ul>
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>여자 화장실 위치</div>
                    <ul
                        className={styles.dropdownInBox}
                        onClick={() => {
                            setGirlSelectShow(!girSelectShow);
                        }}
                    >
                        {girl === null
                            ? "없음"
                            : (() => {
                                  switch (girl) {
                                      case "R":
                                          return "오른쪽";
                                      case "L":
                                          return "왼쪽";
                                      default:
                                          return "앞쪽";
                                  }
                              })()}
                        {girSelectShow && (
                            <ul className={styles.dropdownContainer}>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setGirl(null);
                                        setGirlSelectShow(false);
                                    }}
                                >
                                    없음
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setGirl("R");
                                        setGirlSelectShow(false);
                                    }}
                                >
                                    오른쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setGirl("L");
                                        setGirlSelectShow(false);
                                    }}
                                >
                                    왼쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setGirl("F");
                                        setGirlSelectShow(false);
                                    }}
                                >
                                    앞쪽
                                </li>
                            </ul>
                        )}
                    </ul>
                </div>
            </div>
            <ButtonContainer save={saveBeacon} cancel={cancel} />
        </>
    );
};

// 개찰구
export const Gate: React.FC<IScreenDoorProps> = (props) => {
    const [dirSelectShow, setDirSelectShow] = useState<boolean>(false);
    const [escalatorSelectShow, setEscalatorSelectShow] =
        useState<boolean>(false);
    const [elevatorSelectShow, setElevatorSelectShow] =
        useState<boolean>(false);

    const [dir, setDir] = useState<string | null>(null);
    const [stairSelectShow, setStairSelectShow] = useState<boolean>(false);
    const [escalator, setEscalator] = useState<string | null>(null);
    const [elevator, setElevator] = useState<string | null>(null);
    const [stair, setStair] = useState<string | null>(null);

    const [formData, setFormData] = useState({
        macAddress: "",
        longitude: 0,
        latitude: 0,
    });

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
    };

    const saveBeacon = () => {
        const data: RequestAddBeacon = {
            macAddress: formData.macAddress,
            range: 2,
            longitude: formData.longitude,
            latitude: formData.latitude,
            x: props.x,
            y: props.y,
            beaconType: "GATE",
            floor: props.floor,
            isUp: dir == null ? null : dir == "상행",
            elevator: elevator,
            escalator: escalator,
            stair: stair,
        };

        console.log(data);
        addBeaconRequest(data);
        props.closeModal();
    };

    const cancel = () => {
        props.closeModal();
    };

    return (
        <>
            <div className={styles.inputContainer}>
                <div className={styles.column}>
                    <div className={styles.question}>비콘의 주소 </div>
                    <input
                        name="macAddress"
                        type="text"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>위도 </div>
                    <input
                        name="latitude"
                        type="number"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>경도 </div>
                    <input
                        type="text"
                        name="longitude"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>엘리베이터 </div>
                    <ul
                        className={styles.dropdownInBox}
                        onClick={() => {
                            setElevatorSelectShow(!elevatorSelectShow);
                        }}
                    >
                        {elevator === null
                            ? "없음"
                            : (() => {
                                  switch (elevator) {
                                      case "R":
                                          return "오른쪽";
                                      case "L":
                                          return "왼쪽";
                                      default:
                                          return "앞쪽";
                                  }
                              })()}

                        {elevatorSelectShow && (
                            <ul className={styles.dropdownContainer}>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setElevator(null);
                                        setElevatorSelectShow(
                                            !elevatorSelectShow
                                        );
                                    }}
                                >
                                    없음
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setElevator("R");
                                        setElevatorSelectShow(
                                            !elevatorSelectShow
                                        );
                                    }}
                                >
                                    오른쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setElevator("L");
                                        setElevatorSelectShow(
                                            !elevatorSelectShow
                                        );
                                    }}
                                >
                                    왼쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setElevator("F");
                                        setElevatorSelectShow(
                                            !elevatorSelectShow
                                        );
                                    }}
                                >
                                    앞쪽
                                </li>
                            </ul>
                        )}
                    </ul>
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>에스컬레이터 </div>
                    <ul
                        className={styles.dropdownInBox}
                        onClick={() => {
                            setEscalatorSelectShow(!escalatorSelectShow);
                        }}
                    >
                        {escalator === null
                            ? "없음"
                            : (() => {
                                  switch (escalator) {
                                      case "R":
                                          return "오른쪽";
                                      case "L":
                                          return "왼쪽";
                                      default:
                                          return "앞쪽";
                                  }
                              })()}
                        {escalatorSelectShow && (
                            <ul className={styles.dropdownContainer}>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setEscalator(null);
                                        setEscalatorSelectShow(
                                            !escalatorSelectShow
                                        );
                                    }}
                                >
                                    없음
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setEscalator("R");
                                        setEscalatorSelectShow(
                                            !escalatorSelectShow
                                        );
                                    }}
                                >
                                    오른쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setEscalator("L");
                                        setEscalatorSelectShow(
                                            !escalatorSelectShow
                                        );
                                    }}
                                >
                                    왼쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setEscalator("F");
                                        setEscalatorSelectShow(
                                            !escalatorSelectShow
                                        );
                                    }}
                                >
                                    앞쪽
                                </li>
                            </ul>
                        )}
                    </ul>
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>계단 </div>
                    <ul
                        className={styles.dropdownInBox}
                        onClick={() => {
                            setStairSelectShow(!stairSelectShow);
                        }}
                    >
                        {stair === null
                            ? "없음"
                            : (() => {
                                  switch (stair) {
                                      case "R":
                                          return "오른쪽";
                                      case "L":
                                          return "왼쪽";
                                      default:
                                          return "앞쪽";
                                  }
                              })()}
                        {stairSelectShow && (
                            <ul className={styles.dropdownContainer}>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setStair("F");
                                        setStairSelectShow(!stairSelectShow);
                                    }}
                                >
                                    없음
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setStair("R");
                                        setStairSelectShow(!stairSelectShow);
                                    }}
                                >
                                    오른쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setStair("L");
                                        setStairSelectShow(!stairSelectShow);
                                    }}
                                >
                                    왼쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setStair("F");
                                        setStairSelectShow(!stairSelectShow);
                                    }}
                                >
                                    앞쪽
                                </li>
                            </ul>
                        )}
                    </ul>
                </div>
                <div className={styles.column}>
                    <div className={styles.question}> 방향 </div>
                    <ul
                        className={styles.dropdownInBox}
                        onClick={() => {
                            setDirSelectShow(!dirSelectShow);
                        }}
                    >
                        {dir == null ? "상행,하행 모두" : dir}
                        {dirSelectShow && (
                            <ul className={styles.dropdownContainer}>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setDir(null);
                                        setDirSelectShow(false);
                                    }}
                                >
                                    상행,하행
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setDir("상행");
                                        setDirSelectShow(false);
                                    }}
                                >
                                    상행
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setDir("하행");
                                        setDirSelectShow(false);
                                    }}
                                >
                                    하행
                                </li>
                            </ul>
                        )}
                    </ul>
                </div>
            </div>
            <ButtonContainer save={saveBeacon} cancel={cancel} />
        </>
    );
};

// 출구
export const Exit: React.FC<IScreenDoorProps> = (props) => {
    const [escalatorSelectShow, setEscalatorSelectShow] =
        useState<boolean>(false);
    const [elevatorSelectShow, setElevatorSelectShow] =
        useState<boolean>(false);
    const [stairSelectShow, setStairSelectShow] = useState<boolean>(false);
    const [escalator, setEscalator] = useState<string | null>(null);
    const [elevator, setElevator] = useState<string | null>(null);
    const [stair, setStair] = useState<string | null>(null);

    const [formData, setFormData] = useState({
        macAddress: "",
        longitude: 0,
        latitude: 0,
        landmark: "",
        number: 0,
    });

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
    };

    const saveBeacon = () => {
        const data: RequestAddBeacon = {
            macAddress: formData.macAddress,
            range: 2,
            longitude: formData.longitude,
            latitude: formData.latitude,
            x: props.x,
            y: props.y,
            beaconType: "EXIT",
            floor: props.floor,
            number: formData.number,
            landmark: formData.landmark,
            elevator: elevator,
            escalator: escalator,
            stair: stair,
        };

        console.log(data);
        addBeaconRequest(data);
        props.closeModal();
    };

    const cancel = () => {
        props.closeModal();
    };

    return (
        <>
            <div className={styles.inputContainer}>
                <div className={styles.column}>
                    <div className={styles.question}>비콘의 주소</div>
                    <input
                        name="macAddress"
                        type="text"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>위도 </div>
                    <input
                        name="latitude"
                        type="number"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>경도 </div>
                    <input
                        type="text"
                        name="longitude"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>출구 번호 </div>
                    <input
                        name="exitNumber"
                        type="number"
                        min="1"
                        placeholder="ex) 5"
                        onChange={handleChange}
                    />
                </div>

                <div className={styles.column}>
                    <div className={styles.question}>엘리베이터 </div>
                    <ul
                        className={styles.dropdownInBox}
                        onClick={() => {
                            setElevatorSelectShow(!elevatorSelectShow);
                        }}
                    >
                        {elevator === null
                            ? "없음"
                            : (() => {
                                  switch (elevator) {
                                      case "R":
                                          return "오른쪽";
                                      case "L":
                                          return "왼쪽";
                                      default:
                                          return "앞쪽";
                                  }
                              })()}

                        {elevatorSelectShow && (
                            <ul className={styles.dropdownContainer}>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setElevator(null);
                                        setElevatorSelectShow(
                                            !elevatorSelectShow
                                        );
                                    }}
                                >
                                    없음
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setElevator("R");
                                        setElevatorSelectShow(
                                            !elevatorSelectShow
                                        );
                                    }}
                                >
                                    오른쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setElevator("L");
                                        setElevatorSelectShow(
                                            !elevatorSelectShow
                                        );
                                    }}
                                >
                                    왼쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setElevator("F");
                                        setElevatorSelectShow(
                                            !elevatorSelectShow
                                        );
                                    }}
                                >
                                    앞쪽
                                </li>
                            </ul>
                        )}
                    </ul>
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>에스컬레이터 </div>
                    <ul
                        className={styles.dropdownInBox}
                        onClick={() => {
                            setEscalatorSelectShow(!escalatorSelectShow);
                        }}
                    >
                        {escalator === null
                            ? "없음"
                            : (() => {
                                  switch (escalator) {
                                      case "R":
                                          return "오른쪽";
                                      case "L":
                                          return "왼쪽";
                                      default:
                                          return "앞쪽";
                                  }
                              })()}
                        {escalatorSelectShow && (
                            <ul className={styles.dropdownContainer}>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setEscalator(null);
                                        setEscalatorSelectShow(
                                            !escalatorSelectShow
                                        );
                                    }}
                                >
                                    없음
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setEscalator("R");
                                        setEscalatorSelectShow(
                                            !escalatorSelectShow
                                        );
                                    }}
                                >
                                    오른쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setEscalator("L");
                                        setEscalatorSelectShow(
                                            !escalatorSelectShow
                                        );
                                    }}
                                >
                                    왼쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setEscalator("F");
                                        setEscalatorSelectShow(
                                            !escalatorSelectShow
                                        );
                                    }}
                                >
                                    앞쪽
                                </li>
                            </ul>
                        )}
                    </ul>
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>계단 </div>
                    <ul
                        className={styles.dropdownInBox}
                        onClick={() => {
                            setStairSelectShow(!stairSelectShow);
                        }}
                    >
                        {stair === null
                            ? "없음"
                            : (() => {
                                  switch (stair) {
                                      case "R":
                                          return "오른쪽";
                                      case "L":
                                          return "왼쪽";
                                      default:
                                          return "앞쪽";
                                  }
                              })()}
                        {stairSelectShow && (
                            <ul className={styles.dropdownContainer}>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setStair("F");
                                        setStairSelectShow(!stairSelectShow);
                                    }}
                                >
                                    없음
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setStair("R");
                                        setStairSelectShow(!stairSelectShow);
                                    }}
                                >
                                    오른쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setStair("L");
                                        setStairSelectShow(!stairSelectShow);
                                    }}
                                >
                                    왼쪽
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setStair("F");
                                        setStairSelectShow(!stairSelectShow);
                                    }}
                                >
                                    앞쪽
                                </li>
                            </ul>
                        )}
                    </ul>
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>랜드 마크 정보</div>
                    <input
                        name="exitNumber"
                        type="text"
                        placeholder="ex) 롯데백화점, CGV"
                        onChange={handleChange}
                    />
                </div>
            </div>
            <ButtonContainer save={saveBeacon} cancel={cancel} />
        </>
    );
};

// 엘리베이터
export const Elevator: React.FC<IScreenDoorProps> = (props) => {
    const [dirSelectShow, setDirSelectShow] = useState<boolean>(false);
    const [dir, setDir] = useState<string>("내려가는");

    const [formData, setFormData] = useState({
        macAddress: "",
        longitude: 0,
        latitude: 0,
    });

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
    };

    const saveBeacon = () => {
        const data: RequestAddBeacon = {
            macAddress: formData.macAddress,
            range: 2,
            longitude: formData.longitude,
            latitude: formData.latitude,
            x: props.x,
            y: props.y,
            beaconType: "ELEVATOR",
            floor: props.floor,
            isUp: dir == "내려가는",
        };

        console.log(data);
        addBeaconRequest(data);
        props.closeModal();
    };

    const cancel = () => {
        props.closeModal();
    };

    return (
        <>
            <div className={styles.inputContainer}>
                <div className={styles.column}>
                    <div className={styles.question}>비콘의 주소 </div>
                    <input
                        name="macAddress"
                        type="text"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>위도 </div>
                    <input
                        name="latitude"
                        type="number"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>경도 </div>
                    <input
                        type="text"
                        name="longitude"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>엘리베이터</div>
                    <ul
                        className={styles.dropdownInBox}
                        onClick={() => {
                            setDirSelectShow(!dirSelectShow);
                        }}
                    >
                        {dir}
                        {dirSelectShow && (
                            <ul className={styles.dropdownContainer}>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setDir("내려가는");
                                        setDirSelectShow(!dirSelectShow);
                                    }}
                                >
                                    내려가는
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setDir("올라가는");
                                        setDirSelectShow(!dirSelectShow);
                                    }}
                                >
                                    올라가는
                                </li>
                            </ul>
                        )}
                    </ul>
                </div>
            </div>
            <ButtonContainer save={saveBeacon} cancel={cancel} />
        </>
    );
};

// 계단
export const Stair: React.FC<IScreenDoorProps> = (props) => {
    const [dirSelectShow, setDirSelectShow] = useState<boolean>(false);
    const [dir, setDir] = useState<string>("내려가는");

    const [formData, setFormData] = useState({
        macAddress: "",
        longitude: 0,
        latitude: 0,
    });

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
    };

    const saveBeacon = () => {
        const data = {
            macAddress: formData.macAddress,

            range: 2,
            longitude: formData.longitude,
            latitude: formData.latitude,
            x: props.x,
            y: props.y,
            beaconType: "STAIR",
            floor: props.floor,
            isUp: dir == "내려가는",
        };

        console.log(data);
        addBeaconRequest(data);
        props.closeModal();
    };

    const cancel = () => {
        props.closeModal();
    };

    return (
        <>
            <div className={styles.inputContainer}>
                <div className={styles.column}>
                    <div className={styles.question}>비콘의 주소 </div>
                    <input
                        name="macAddress"
                        type="text"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>위도 </div>
                    <input
                        name="latitude"
                        type="number"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>경도 </div>
                    <input
                        type="text"
                        name="longitude"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>계단 </div>
                    <ul
                        className={styles.dropdownInBox}
                        onClick={() => {
                            setDirSelectShow(!dirSelectShow);
                        }}
                    >
                        <div className={styles.selected}>{dir} 계단</div>

                        {dirSelectShow && (
                            <ul className={styles.dropdownContainer}>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setDir("내려가는");
                                        setDirSelectShow(!dirSelectShow);
                                    }}
                                >
                                    내려가는 계단
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setDir("올라가는");
                                        setDirSelectShow(!dirSelectShow);
                                    }}
                                >
                                    올라가는 계단
                                </li>
                            </ul>
                        )}
                    </ul>
                </div>
            </div>
            <ButtonContainer save={saveBeacon} cancel={cancel} />
        </>
    );
};

// 에스컬레이터
export const Escalator: React.FC<IScreenDoorProps> = (props) => {
    const [dirSelectShow, setDirSelectShow] = useState<boolean>(false);
    const [dir, setDir] = useState<string>("내려가는");

    const [formData, setFormData] = useState({
        macAddress: "",
        longitude: 0,
        latitude: 0,
    });

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
    };

    const saveBeacon = () => {
        const data = {
            macAddress: formData.macAddress,
            range: 2,
            longitude: formData.longitude,
            latitude: formData.latitude,
            x: props.x,
            y: props.y,
            beaconType: "ESCALATOR",
            floor: props.floor,
            isUp: dir == "내려가는",
        };

        console.log(data);
        addBeaconRequest(data);
        props.closeModal();
    };

    const cancel = () => {
        props.closeModal();
    };

    return (
        <>
            <div className={styles.inputContainer}>
                <div className={styles.column}>
                    <div className={styles.question}>비콘의 주소 </div>
                    <input
                        name="macAddress"
                        type="text"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>위도 </div>
                    <input
                        name="latitude"
                        type="number"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>경도 </div>
                    <input
                        type="text"
                        name="longitude"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>계단 </div>
                    <ul
                        className={styles.dropdownInBox}
                        onClick={() => {
                            setDirSelectShow(!dirSelectShow);
                        }}
                    >
                        <div className={styles.selected}>
                            {dir} 에스컬레이터
                        </div>

                        {dirSelectShow && (
                            <ul className={styles.dropdownContainer}>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setDir("내려가는");
                                        setDirSelectShow(!dirSelectShow);
                                    }}
                                >
                                    내려가는 에스컬레이터
                                </li>
                                <li
                                    className={styles.dropdownItem}
                                    onClick={() => {
                                        setDir("올라가는");
                                        setDirSelectShow(!dirSelectShow);
                                    }}
                                >
                                    올라가는 에스컬레이터
                                </li>
                            </ul>
                        )}
                    </ul>
                </div>
            </div>
            <ButtonContainer save={saveBeacon} cancel={cancel} />
        </>
    );
};

// 스크린도어
export const ScreenDoor: React.FC<IScreenDoorProps> = (props) => {
    const [formData, setFormData] = useState({
        macAddress: "",
        longitude: 0,
        latitude: 0,
        direction: "",
    });

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        setFormData({
            ...formData,
            [name]: value,
        });
    };

    const saveBeacon = () => {
        const data = {
            macAddress: formData.macAddress,

            range: 2,
            longitude: formData.longitude,
            latitude: formData.latitude,
            x: props.x,
            y: props.y,
            beaconType: "SCREENDOOR",
            floor: props.floor,
            direction: formData.latitude,
        };

        console.log(data);
        addBeaconRequest(data);
        props.closeModal();
    };

    const cancel = () => {
        props.closeModal();
    };

    return (
        <>
            <div className={styles.inputContainer}>
                <div className={styles.column}>
                    <div className={styles.question}>비콘의 주소 </div>
                    <input
                        name="macAddress"
                        type="text"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>위도 </div>
                    <input
                        name="latitude"
                        type="number"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>경도 </div>
                    <input
                        type="text"
                        name="longitude"
                        placeholder="ex) 000"
                        onChange={handleChange}
                    />
                </div>
                <div className={styles.column}>
                    <div className={styles.question}>방면</div>
                    <input
                        type="text"
                        name="direction"
                        placeholder="ex) 000방면 n-n"
                        onChange={handleChange}
                    />
                </div>
            </div>
            <ButtonContainer save={saveBeacon} cancel={cancel} />
        </>
    );
};
