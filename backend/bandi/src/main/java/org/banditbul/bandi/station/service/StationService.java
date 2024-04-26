package org.banditbul.bandi.station.service;

import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import jdk.jshell.spi.ExecutionControl;
import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.common.exception.ExistException;
import org.banditbul.bandi.common.exception.PasswordIncorrectException;
import org.banditbul.bandi.point.entity.Point;
import org.banditbul.bandi.station.dto.LoginDto;
import org.banditbul.bandi.station.dto.SignUpDto;
import org.banditbul.bandi.station.entity.Station;
import org.banditbul.bandi.station.repository.StationRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class StationService {
    private final StationRepository stationRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;

    @Transactional
    public Station findById(int stationId){
        return stationRepository.findById(stationId).orElseThrow(() -> new EntityNotFoundException("해당하는 station이 없습니다."));
    }

    public String signUp(SignUpDto dto){
        String pwd = bCryptPasswordEncoder.encode(dto.getPassword());
        Station byLoginId = stationRepository.findByLoginId(dto.getLoginId());
        if( byLoginId == null){
            Station station = new Station(dto.getName(), dto.getLoginId(), pwd, dto.getLine());
            Station save = stationRepository.save(station);
            return "회원가입 완료 ID : " + save.getLoginId();
        }else{
            throw new ExistException("이미 등록된 아이디입니다.");
        }
    }

    public String login(LoginDto dto, HttpSession session) {
        Station user = stationRepository.findByLoginId(dto.getLoginId());
        if (user == null) {
            throw new EntityNotFoundException("사용자가 존재하지 않습니다.");
        }
        if (!bCryptPasswordEncoder.matches(dto.getPassword(), user.getPassword())) {
            throw new PasswordIncorrectException("패스워드가 일치하지 않습니다.");
        }
        session.setAttribute("user", user);
        return session.getId();
    }

}
