
package org.banditbul.bandi.beacon.service;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.beacon.dto.BeaconDto;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.beacon.entity.BeaconTYPE;
import org.banditbul.bandi.beacon.repository.BeaconRepository;
import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.common.exception.ExistException;
import org.banditbul.bandi.elevator.dto.ElevatorDto;
import org.banditbul.bandi.elevator.entity.Elevator;
import org.banditbul.bandi.elevator.repository.ElevatorRepository;
import org.banditbul.bandi.exit.dto.ExitDto;
import org.banditbul.bandi.exit.entity.Exit;
import org.banditbul.bandi.exit.repository.ExitRepository;
import org.banditbul.bandi.gate.dto.GateDto;
import org.banditbul.bandi.gate.entity.Gate;
import org.banditbul.bandi.gate.repository.GateRepository;
import org.banditbul.bandi.point.entity.Point;
import org.banditbul.bandi.point.repository.PointRepository;
import org.banditbul.bandi.screendoor.dto.ScreendoorDto;
import org.banditbul.bandi.screendoor.entity.Screendoor;
import org.banditbul.bandi.screendoor.repository.ScreendoorRepository;
import org.banditbul.bandi.stair.dto.StairDto;
import org.banditbul.bandi.stair.entity.Stair;
import org.banditbul.bandi.stair.repository.StairRepository;
import org.banditbul.bandi.station.entity.Station;
import org.banditbul.bandi.station.repository.StationRepository;
import org.banditbul.bandi.toilet.dto.ToiletDto;
import org.banditbul.bandi.toilet.entity.Toilet;
import org.banditbul.bandi.toilet.repository.ToiletRepository;
import org.springframework.stereotype.Service;
import java.util.Optional;
@Service
@RequiredArgsConstructor
public class BeaconService {
    private final BeaconRepository beaconRepository;
    private final ToiletRepository toiletRepository;
    private final GateRepository gateRepository;
    private final ExitRepository exitRepository;
    private final ElevatorRepository elevatorRepository;
    private final StairRepository stairRepository;
    private final ScreendoorRepository screendoorRepository;
    private final PointRepository pointRepository;
    private final StationRepository stationRepository;
    public int getStationId(String beaconId){
        Beacon beacon = beaconRepository.findById(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 beacon이 없습니다."));
        return beacon.getStation().getId();
    }
    public BeaconInfoDto giveInfo(String beaconId) throws EntityNotFoundException{
        Beacon beacon = beaconRepository.findById(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 beacon이 없습니다."));
        // 우선 비콘ID로 해당 비콘의 시설물을 찾자
        // 해당하는 시설물: 개찰구 gate, 화장실 toilet, 출구 exit, 계단 stair, 엘리베이터 elevator, 스크린도어 screendoor
        BeaconTYPE beaconType = beacon.getBeaconType(); // toilet, gate, exit, stair, elevator, screendoor
        if (beaconType == BeaconTYPE.TOILET){
            Toilet toilet = toiletRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 화장실이 없습니다."));
            return new ToiletDto(toilet.getManDir(), toilet.getWomanDir());
        } else if (beaconType == BeaconTYPE.GATE){
            Gate gate = gateRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 개찰구가 없습니다."));
            return new GateDto(gate.getIsUp(), gate.getElevator(), gate.getEscalator(), gate.getStair());
        } else if (beaconType == BeaconTYPE.EXIT){
            Exit exit = exitRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 출구가 없습니다."));
            return new ExitDto(exit.getNumber(), exit.getLandmark(), exit.getElevator(), exit.getEscalator(), exit.getStair());
        } else if (beaconType == BeaconTYPE.STAIR){
            Stair stair = stairRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 계단이 없습니다."));
            return new StairDto(stair.isUp());
        } else if (beaconType == BeaconTYPE.ELEVATOR){
            Elevator elevator = elevatorRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 엘리베이터가 없습니다."));
            return new ElevatorDto(elevator.isUp());
        } else if (beaconType == BeaconTYPE.SCREENDOOR){
            Screendoor screendoor = screendoorRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 스크린도어가 없습니다."));
            return new ScreendoorDto(screendoor.getDirection());
        }
        throw new EntityNotFoundException("알 수 없는 비콘 타입입니다.");
    }
    public String createBeacon(BeaconDto beaconDto){
        Station station = stationRepository.findById(beaconDto.getStationId()).orElseThrow(() -> new EntityNotFoundException("해당하는 station이 없습니다."));
        BeaconTYPE beaconType = beaconDto.getBeaconType();
        // 이미 그 비콘 id가 있으면 예외던지기
        Optional<Beacon> check = beaconRepository.findById(beaconDto.getMacAddress());
        if( check.isPresent() ){
            throw new ExistException("이미 존재하는 비콘 주소 입니다.");
        }
        Beacon beacon = new Beacon(beaconDto.getMacAddress(), station, beaconDto.getX(), beaconDto.getY(), beaconDto.getFloor(), beaconDto.getLatitude(), beaconDto.getLongitude(), beaconDto.getRange(), beaconType);
        beaconRepository.save(beacon);
        // 비콘 타입이 뭔지에 따라 다른 테이블에 저장하기.
        if(beaconType == BeaconTYPE.TOILET){
            toiletRepository.save(new Toilet(beacon, beaconDto.getManDir(), beaconDto.getWomanDir()));
        }else if(beaconType == BeaconTYPE.GATE){
            gateRepository.save(new Gate(beacon, beaconDto.isUp(), beaconDto.getElevator(), beaconDto.getEscalator(), beaconDto.getStair()));
        }else if(beaconType == BeaconTYPE.EXIT){
            exitRepository.save(new Exit(beacon, beaconDto.getNumber(), beaconDto.getLandmark(), beaconDto.getElevator(), beaconDto.getEscalator(), beaconDto.getStair()));
        }else if(beaconType == BeaconTYPE.STAIR){
            stairRepository.save(new Stair(beacon, beaconDto.isUp()));
        }else if(beaconType == BeaconTYPE.ELEVATOR){
            elevatorRepository.save(new Elevator(beacon, beaconDto.isUp()));
        }else if(beaconType == BeaconTYPE.SCREENDOOR){
            screendoorRepository.save(new Screendoor(beacon, beaconDto.getDirection()));
        }else if(beaconType == BeaconTYPE.POINT){
            pointRepository.save(new Point(beacon));
        }
        return beacon.getId();
    }
}
