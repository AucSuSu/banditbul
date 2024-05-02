package org.banditbul.bandi.test;

public enum Type {
    SOS, ENTER, SOS_ACCEPT, SOS_FAIL, MONITOR, BEACON;
    // SOS : 도움 요청
        // SOS_ACCPET : 관리자가 요청 수락
        // SOS_FAIL : 관리자가 거부하기
    // ENTER : SESSION 안에 들어갔을 때
    // MONITOR : 실시간 확인 맵 - 웹으로
    // BEACON : 비콘 권역 안에 들어갔을 때, 앱에서 서버로 알림
}
