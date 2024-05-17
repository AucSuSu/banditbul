import React from "react";
import styled from "styled-components";

interface ToggleButtonProps {
    state: boolean;
    setState: React.Dispatch<React.SetStateAction<boolean>>;
}

interface SwitchLabelProps {
    isChecked: boolean;
}

const ToggleButton: React.FC<ToggleButtonProps> = ({ state, setState }) => {
    const toggleHandler = () => {
        setState(!state);
    };

    return (
        <StyledCheckbox>
            <InputCheckbox
                type="checkbox"
                id="toggleBtn"
                checked={state}
                onChange={toggleHandler}
            />
            <SwitchLabel htmlFor="toggleBtn" isChecked={state} />
        </StyledCheckbox>
    );
};

export default ToggleButton;

const StyledCheckbox = styled.div`
    position: relative;
    display: inline-block;
    margin-right: auto;
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
    width: 100px;
    height: 40px;
    background: #ffffff;
    position: relative;
    display: inline-block;
    border-radius: 50px;
    transition: background-color 0.4s;
    border: solid 3px #AA9FE3;
    color : black;

    &:after {
        content: "${({ isChecked }) => (isChecked ? "비콘" : "경로")}";
        position: absolute;
        width: 60px;
        height: 30px;
        border-radius: 50px;
        background: #fff;
        top: 2.5px;
        left: 5px;
        z-index: 2;
        box-shadow: 0 0 5px rgba(0, 0, 0, 0.2);
        transition: left 0.5s, background-color 0.5s;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    ${InputCheckbox}:checked + & {
        border: solid 3px #AA9FE3;
        &:after {
            left: calc(100% - 65px);
            background: #AA9FE3;
            color: white;
        }
    }
`;
