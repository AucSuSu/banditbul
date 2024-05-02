package org.banditbul.bandi.test;

public enum Type {
    SOS, ENTER, SOS_ACCEPT, SOS_FAIL, INFO, MONITOR;
    // SOS : 도움 요청
        // SOS_ACCPET : 관리자가 요청 수락
        // SOS_FAIL : 관리자가 거부하기
    // ENTER : SESSION 안에 들어갔을 때
    // MONITOR : 실시간 확인 맵 - 웹으로
    // INFO : 비콘 권역 안에 들어갔을 때, 시설물 정보를 알려주기 위한 세션 - 앱으로
}
