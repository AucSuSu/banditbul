import React, { useState } from "react";
import styled from "styled-components";
type ToggleType = {
    isFloor: boolean;
};

interface ToggleButtonProps {
    floor: number;
    setFloor: React.Dispatch<React.SetStateAction<number>>;
}

const ToggleButton: React.FC<ToggleButtonProps> = ({ floor, setFloor }) => {
    const [isFloor, setIsFloor] = useState<boolean>(floor == -1);

    const toggleHandler = () => {
        if (floor == -1) setFloor(-2);
        else setFloor(-1);

        setIsFloor((prev) => !prev);
    };

    return (
        <ButtonContainer>
            <CheckBox type="checkbox" id="toggleBtn" onChange={toggleHandler} />
            <ButtonLable htmlFor="toggleBtn" isFloor={isFloor} />
        </ButtonContainer>
    );
};

export default ToggleButton;

const ButtonContainer = styled.div`
    display: flex;
    z-index: 0;
`;

const CheckBox = styled.input`
    display: none;
`;

const ButtonLable = styled.label<ToggleType>`
    z-index: 10;
    width: 12rem;
    height: 3rem;
    border-radius: 2em;
    background-color : gray;

    ::before {
        display : flex; 
        position : absolute;
        content : '대합실'
        padding-left : 1em; 
        justify-content : flex-start; 
        align-items : center;
        width : 10rem;
        height : 3rem; 
        color : white;
        transition : all 0.2s ease-in-out;
    }

    ::after {
        display: flex;
        position: relative;
        content: '승강장';
        width: 6rem;
        height: 3rem;
        justify-content: center;
        align-items: center;
        right: 0;
        left : 6rem;
        color: black;
        font-size: 1rem;
        font-weight: bold;
        border-radius: 2rem;
        box-shadow: 1px 2px 8px rgba(0, 0, 0, 0.16);
        background: white;
        transition: all 0.2s ease-in-out;
    }

    ${(props) =>
        props.isFloor &&
        `
         &::before {
            content : '승강장';
            padding-right : 1rem; 
            justify-content : flex-end;
         };

         &::after {
            content : '대합실'
            width: 6rem;
            height : 3rem; 
            left : 0rem;
            justify-content : flex-start;
         }

        `}
`;
