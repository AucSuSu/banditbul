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
    height: 12.5%;
    width: 70%;
    margin-top: 7.5%;
    margin-bottom: 12.5%;
    margin-left: auto;
    margin-right: auto;
    border-radius: 100px;
    background-color: #f68500;
    font-size: xx-large;
    box-shadow: 3px 6px 3px rgba(0, 0, 0, 0.3);
`;

const InnerRound = styled(FlaxBox)`
    height: 85%;
    width: 94%;
    border-radius: 100px;
    background-color: white;
    color: black;
    box-shadow: 4px 4px 4px rgba(0, 0, 0, 0.3);
`;

const LineBox = styled(FlaxBox)`
    height: 55px;
    width: 55px;
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
