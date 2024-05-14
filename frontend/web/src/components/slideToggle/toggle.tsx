import React, { useState } from "react";
import styled from "styled-components";

interface ToggleButtonProps {
    floor: number;
    setFloor: React.Dispatch<React.SetStateAction<number>>;
}

interface SwitchLabelProps {
    isChecked: boolean;
}

const ToggleButton: React.FC<ToggleButtonProps> = ({ floor, setFloor }) => {
    const [isFloor, setIsFloor] = useState<boolean>(floor === -1);

    const toggleHandler = () => {
        if (floor === -1) setFloor(-2);
        else setFloor(-1);

        setIsFloor((prev) => !prev);
    };

    return (
        <StyledCheckbox>
            <InputCheckbox type="checkbox" id="toggleBtn" checked={isFloor} onChange={toggleHandler} />
            <SwitchLabel htmlFor="toggleBtn" isChecked={isFloor}/>
        </StyledCheckbox>
    );
};

export default ToggleButton;

const StyledCheckbox = styled.div`
    position: relative;
    display: inline-block;
`;

const InputCheckbox = styled.input`
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    z-index: 5;
    opacity: 0;
    cursor: pointer;
`;

const SwitchLabel = styled.label<SwitchLabelProps>`
    width: 150px;
    height: 50px;
    background: #ffffff;
    position: relative;
    display: inline-block;
    border-radius: 50px;
    transition: background-color 0.4s;
    border: solid 3px #c2bbbb;

    &:after {
        content: '${({ isChecked }) => isChecked ? "승강장" : "대합실"}';
        position: absolute;
        width: 80px;
        height: 40px;
        border-radius: 50px;
        background: #c2bbbb;
        top: 3.5px;
        left: 5px;
        z-index: 2;
        box-shadow: 0 0 5px rgba(0, 0, 0, .2);
        transition: left 0.5s, background-color 0.5s;
        display: flex;
        justify-content: center;
        align-items: center;

    }

    ${InputCheckbox}:checked + & {
        border: solid 3px #487751;
        &:after {
            left: calc(100% - 85px);
            background: #487751;
        }
    }
`;
