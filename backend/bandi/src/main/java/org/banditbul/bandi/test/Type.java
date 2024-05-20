package org.banditbul.bandi.test;

public enum Type {
    SOS, ENTER, SOS_ACCEPT, SOS_FAIL, CANCEL, MONITOR, HEARTBEAT, BEACON, CLOSE;
    // SOS : 도움 요청
        // SOS_ACCPET : 관리자가 요청 수락
        // SOS_FAIL : 관리자가 거부하기
    // CANCEL : 사용자가 도움 요청 취소
    // ENTER : SESSION 안에 들어갔을 때
    // MONITOR : 실시간 확인 맵 - 웹으로
    // HEARTBEAT: 재연결
    // BEACON : 비콘 권역 안에 들어갔을 때, 앱에서 서버로 알림
    // CLOSE: 세션 나가기
}
