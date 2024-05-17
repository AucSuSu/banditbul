import styled from "styled-components";

interface PropsData {
    line: string;
    name: string;
}

const FlaxBox = styled.div`
    display: flex;
    align-items: center;
    justify-content: center;
`;

const OutRound = styled(FlaxBox)`
    height: 13vh;
    width: 19.5vw;
    margin-top: 2vh;
    margin-bottom: 2vh;
    margin-left: auto;
    margin-right: auto;
    border-radius: 100px;
    background-color: #f68500;
    font-size: xx-large;
`;

const InnerRound = styled(FlaxBox)`
    height: 90%;
    width: 96%;
    border-radius: 100px;
    background-color: white;
    color: black;
    box-shadow: 4px 6px 6px rgba(0, 0, 0, 0.4);
`;

const LineBox = styled(FlaxBox)`
    height: 60px;
    width: 60px;
    border-radius: 100%;
    margin-left: 20px;
    margin-right: auto;
    background-color: #d2d0d0;
    font-family: TheJamsil5Bold;
    box-shadow: 4px 6px 6px rgba(0, 0, 0, 0.4);
    font-size: 30px;
`;

const NameBox = styled(FlaxBox)`
    margin-right: auto;
    margin-left: -20px;
    font-family: TheJamsil5Bold;
    font-size: 30px;
`;

const Header: React.FC<PropsData> = ({ line, name }) => {
    return (
        <>
            <OutRound>
                <InnerRound>
                    <LineBox>{line}</LineBox>
                    <NameBox>{name}</NameBox>
                </InnerRound>
            </OutRound>
        </>
    );
};
export default Header;
