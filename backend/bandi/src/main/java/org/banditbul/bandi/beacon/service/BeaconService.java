
package org.banditbul.bandi.beacon.service;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.beacon.dto.BeaconDto;
import org.banditbul.bandi.beacon.dto.BeaconInfoDto;
import org.banditbul.bandi.beacon.dto.FloorInfoDto;
import org.banditbul.bandi.beacon.dto.IndvBeacon;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.beacon.entity.BeaconTYPE;
import org.banditbul.bandi.beacon.repository.BeaconRepository;
import org.banditbul.bandi.common.Dir;
import org.banditbul.bandi.common.HttpStatusEnum;
import org.banditbul.bandi.common.Message;
import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.common.exception.ExistException;
import org.banditbul.bandi.edge.dto.IndvEdge;
import org.banditbul.bandi.edge.entity.Edge;
import org.banditbul.bandi.edge.repository.EdgeRepository;
import org.banditbul.bandi.elevator.dto.ElevatorDto;
import org.banditbul.bandi.elevator.entity.Elevator;
import org.banditbul.bandi.elevator.repository.ElevatorRepository;
import org.banditbul.bandi.escalator.entity.Escalator;
import org.banditbul.bandi.escalator.repository.EscalatorRepository;
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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.*;

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
    private final EdgeRepository edgeRepository;
    private final EscalatorRepository escalatorRepository;

    @Transactional
    public void deleteBeacon(String beaconId){
        Beacon beacon = beaconRepository.findById(beaconId).orElseThrow(() -> new EntityNotFoundException("Beacon not found"));

        List<Edge> edges = edgeRepository.findByBeacon1_IdOrBeacon2_Id(beaconId, beaconId);
        for(Edge edge:edges){
            edgeRepository.delete(edge);
        }


        BeaconTYPE beaconType = beacon.getBeaconType(); // toilet, gate, exit, stair, elevator, screendoor, escalator

        if (beaconType == BeaconTYPE.TOILET){
            Toilet toilet = toiletRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 화장실이 없습니다."));
            toiletRepository.delete(toilet);
        } else if (beaconType == BeaconTYPE.GATE){
            Gate gate = gateRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 개찰구가 없습니다."));
            gateRepository.delete(gate);
        } else if (beaconType == BeaconTYPE.EXIT){
            Exit exit = exitRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 출구가 없습니다."));
            exitRepository.delete(exit);
        } else if (beaconType == BeaconTYPE.STAIR){
            Stair stair = stairRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 계단이 없습니다."));
            stairRepository.delete(stair);
        } else if (beaconType == BeaconTYPE.ELEVATOR){
            Elevator elevator = elevatorRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 엘리베이터가 없습니다."));
            elevatorRepository.delete(elevator);
        } else if (beaconType == BeaconTYPE.ESCALATOR){
            Escalator escalator = escalatorRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 에스컬레이터가 없습니다."));
            escalatorRepository.delete(escalator);
        } else if (beaconType == BeaconTYPE.SCREENDOOR){
            Screendoor screendoor = screendoorRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 스크린도어가 없습니다."));
            // ㅇㅇ방면 ㅇ-ㅇ 열차입니다.
            screendoorRepository.delete(screendoor);
        }else if (beaconType == BeaconTYPE.POINT){
            Point point = pointRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 포인트가 없습니다."));
            pointRepository.delete(point);
        }

        beaconRepository.deleteById(beaconId);

    }


    public String getStationName(String beaconId){

        return beaconRepository.findById(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 beacon이 없습니다."))
                .getStation().getName();
    }


    public int getStationId(String beaconId){
        Beacon beacon = beaconRepository.findById(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 beacon이 없습니다."));
        return beacon.getStation().getId();
    }

    public FloorInfoDto getFloorInfoDto(int floor, int stationId){
        // 역(station) 조회
        Station station = stationRepository.findById(stationId)
                .orElseThrow(() -> new EntityNotFoundException("해당 역을 찾을 수 없습니다. ID: " + stationId));

        // 역의 비콘 조회
        List<Beacon> beacons = beaconRepository.findAllByStationAndFloor(station, floor);
        List<Edge> edges = edgeRepository.findAllByStation(station);

        // 해당 층의 비콘
        List<IndvBeacon> indvBeacons = new ArrayList<>();
        for(Beacon beacon:beacons){
            indvBeacons.add(new IndvBeacon(beacon.getId(), beacon.getX(), beacon.getY()));
        }

        // 해당 층의 엣지
        List<IndvEdge> indvEdges = new ArrayList<>();
        for(Edge edge:edges){
            if (indvBeacons.contains(new IndvBeacon(edge.getBeacon1().getId(), edge.getBeacon1().getX(), edge.getBeacon1().getY())) && indvBeacons.contains(new IndvBeacon(edge.getBeacon2().getId(), edge.getBeacon2().getX(), edge.getBeacon2().getY()))){
                indvEdges.add(new IndvEdge(edge.getBeacon1().getId(), edge.getBeacon2().getId()));
            }
        }

        String mapImageUrl = "https://d3h25rphev0vuf.cloudfront.net/" + (station.getName()+floor) + ".png";
        System.out.println(mapImageUrl);

        return new FloorInfoDto(indvBeacons, indvEdges, mapImageUrl);

    }

    public String giveInfo(String beaconId) throws EntityNotFoundException{

        Beacon beacon = beaconRepository.findById(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 beacon이 없습니다."));

        // 우선 비콘ID로 해당 비콘의 시설물을 찾자
        // 해당하는 시설물: 개찰구 gate, 화장실 toilet, 출구 exit, 계단 stair, 엘리베이터 elevator, 스크린도어 screendoor
        BeaconTYPE beaconType = beacon.getBeaconType(); // toilet, gate, exit, stair, elevator, screendoor, escalator

        Map<Dir, String> directionMap = new HashMap<>();

        directionMap.put(Dir.F, "정면");
        directionMap.put(Dir.L, "왼쪽");
        directionMap.put(Dir.R, "오른쪽");
        directionMap.put(null, "다른 곳");

        StringBuilder sb = new StringBuilder(); // 문장으로 보내줘야함

        if (beaconType == BeaconTYPE.TOILET){
            Toilet toilet = toiletRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 화장실이 없습니다."));
            sb.append("화장실입니다. 남자 화장실은 ").append(directionMap.get(toilet.getManDir())).append("에, 여자 화장실은 ").append(directionMap.get(toilet.getWomanDir())).append("에 있습니다");
            return sb.toString();
        } else if (beaconType == BeaconTYPE.GATE){
            Gate gate = gateRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 개찰구가 없습니다."));

            sb.append(gate.getIsUp()?"상행":"하행").append("선 개찰구입니다. ");
            if(gate.getElevator()!=null){
                sb.append("엘레베이터는 ").append(directionMap.get(gate.getElevator())).append("에 ");
            }
            if(gate.getEscalator()!=null){
                sb.append("에스컬레이터는 ").append(directionMap.get(gate.getEscalator())).append("에 ");
            }
            if(gate.getStair()!=null){
                sb.append("계단은 ").append(directionMap.get(gate.getStair())).append("에 ");
            }
            sb.append("있습니다.");

            return sb.toString();
        } else if (beaconType == BeaconTYPE.EXIT){
            Exit exit = exitRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 출구가 없습니다."));

            sb.append(exit.getNumber()).append("번 출구입니다. 출구로 나가시면 ").append(exit.getLandmark()).append("가 있습니다.");
            if(exit.getElevator()!=null){
                sb.append("엘레베이터는 ").append(directionMap.get(exit.getElevator())).append("에 ");
            }
            if(exit.getEscalator()!=null){
                sb.append("에스컬레이터는 ").append(directionMap.get(exit.getEscalator())).append("에 ");
            }
            if(exit.getStair()!=null){
                sb.append("계단은 ").append(directionMap.get(exit.getStair())).append("에 ");
            }
            sb.append("있습니다.");
            return sb.toString();
        } else if (beaconType == BeaconTYPE.STAIR){
            Stair stair = stairRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 계단이 없습니다."));
            sb.append(stair.isUp()?"아래로 내려가는 ":"위로 올라가는 ").append("계단입니다.");
            return sb.toString();
        } else if (beaconType == BeaconTYPE.ELEVATOR){
            Elevator elevator = elevatorRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 엘리베이터가 없습니다."));
            sb.append(elevator.isUp()?"아래로 내려가는 ":"위로 올라가는 ").append("엘레베이터입니다.");
            return sb.toString();
        } else if (beaconType == BeaconTYPE.ESCALATOR){
            Escalator escalator = escalatorRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 에스컬레이터가 없습니다."));
            sb.append(escalator.isUp()?"아래로 내려가는 ":"위로 올라가는 ").append("에스컬레이터입니다.");
            return sb.toString();
        } else if (beaconType == BeaconTYPE.SCREENDOOR){
            Screendoor screendoor = screendoorRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 스크린도어가 없습니다."));
            // ㅇㅇ방면 ㅇ-ㅇ 열차입니다.
            sb.append(screendoor.getDirection()).append(" 앞 스크린도어입니다.");
            return sb.toString();
        }
        throw new EntityNotFoundException("알 수 없는 비콘 타입입니다.");
    }


    public String createBeacon(BeaconDto beaconDto){
        System.out.println("createBeacon 메소드");
        System.out.println(beaconDto.getStationId());
        Station station = stationRepository.findById(beaconDto.getStationId()).orElseThrow(() -> new EntityNotFoundException("해당하는 station이 없습니다."));
        System.out.println("여기까지 넘어옴");
        BeaconTYPE beaconType = beaconDto.getBeaconType();
        // 이미 그 비콘 id가 있으면 예외던지기
        System.out.println(beaconDto.getMacAddress());
        Optional<Beacon> check = beaconRepository.findById(beaconDto.getMacAddress());
        System.out.println("통과");
        if( check.isPresent() ){
            throw new ExistException("이미 존재하는 비콘 주소 입니다.");
        }
        Beacon beacon = new Beacon(beaconDto.getMacAddress(), station, beaconDto.getX(), beaconDto.getY(), beaconDto.getFloor(), beaconDto.getLatitude(), beaconDto.getLongitude(), beaconDto.getRange(), beaconType);
        beaconRepository.save(beacon);
        // 비콘 타입이 뭔지에 따라 다른 테이블에 저장하기.
        if(beaconType == BeaconTYPE.TOILET){
            toiletRepository.save(new Toilet(beacon, beaconDto.getManDir(), beaconDto.getWomanDir()));
        }else if(beaconType == BeaconTYPE.GATE){
            System.out.println(beaconDto.getIsUp());
            gateRepository.save(new Gate(beacon, beaconDto.getIsUp(), beaconDto.getElevator(), beaconDto.getEscalator(), beaconDto.getStair()));
        }else if(beaconType == BeaconTYPE.EXIT){
            exitRepository.save(new Exit(beacon, beaconDto.getNumber(), beaconDto.getLandmark(), beaconDto.getElevator(), beaconDto.getEscalator(), beaconDto.getStair()));
        }else if(beaconType == BeaconTYPE.STAIR){
            stairRepository.save(new Stair(beacon, beaconDto.getIsUp()));
        }else if(beaconType == BeaconTYPE.ELEVATOR){
            elevatorRepository.save(new Elevator(beacon, beaconDto.getIsUp()));
        }else if(beaconType == BeaconTYPE.SCREENDOOR){
            screendoorRepository.save(new Screendoor(beacon, beaconDto.getDirection()));
        }else if(beaconType == BeaconTYPE.POINT){
            pointRepository.save(new Point(beacon));
        }else if(beaconType == BeaconTYPE.ESCALATOR){
            escalatorRepository.save(new Escalator(beacon, beaconDto.getIsUp()));
        }
        return beacon.getId();
    }


}
