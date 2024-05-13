
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
import org.banditbul.bandi.station.dto.StationInfoDto;
import org.banditbul.bandi.station.dto.StationSessionDto;
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

    public String findLoginId(int stationId){
        Station station = stationRepository.findById(stationId).orElseThrow(() -> new EntityNotFoundException("해당하는 station이 없습니다."));
        return station.getLoginId();
    }
    public String signUp(SignUpDto dto){
        String pwd = bCryptPasswordEncoder.encode(dto.getPassword());
        Station byLoginId = stationRepository.findByLoginId(dto.getLoginId());
        if( byLoginId == null){
            Station station = new Station(dto.getName(), dto.getLoginId(), pwd, dto.getLine());
            Station save = stationRepository.save(station);
            return save.getLoginId();
        }else{
            throw new ExistException("이미 등록된 아이디입니다.");
        }
    }
    public StationInfoDto login(LoginDto dto, HttpSession session) {
        Station station = stationRepository.findByLoginId(dto.getLoginId());
        if (station == null) {
            throw new EntityNotFoundException("사용자가 존재하지 않습니다.");
        }
        if (!bCryptPasswordEncoder.matches(dto.getPassword(), station.getPassword())) {
            throw new PasswordIncorrectException("패스워드가 일치하지 않습니다.");
        }
        System.out.println();
        // 세션에 엔티티를 바로 넣게되면 JPA의 LazyLoading issue 같은 프록시 객체 초기화 관련 문제가 발생하므로 dto를 넣어주자
        StationSessionDto user = new StationSessionDto(station.getId(), station.getName(), station.getLoginId(), station.getLine(), station.getRole());
        session.setAttribute("user", user);

        return new StationInfoDto(station.getLine(), station.getName());
    }
    public String logout(HttpSession session){
        session.removeAttribute("user");
        // 세션 무효화
        session.invalidate();
        return "Logout successful";
    }
}
