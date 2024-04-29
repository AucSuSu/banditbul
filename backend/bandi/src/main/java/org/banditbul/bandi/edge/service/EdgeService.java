package org.banditbul.bandi.edge.service;


import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.beacon.repository.BeaconRepository;
import org.banditbul.bandi.beaconcoor.repository.BeaconcoorRepository;
import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.edge.dto.EdgeDto;
import org.banditbul.bandi.edge.entity.Edge;
import org.banditbul.bandi.edge.repository.EdgeRepository;
import org.banditbul.bandi.elevator.entity.Elevator;
import org.banditbul.bandi.elevator.repository.ElevatorRepository;
import org.banditbul.bandi.exit.entity.Exit;
import org.banditbul.bandi.exit.repository.ExitRepository;
import org.banditbul.bandi.gate.entity.Gate;
import org.banditbul.bandi.gate.repository.GateRepository;
import org.banditbul.bandi.point.entity.Point;
import org.banditbul.bandi.point.repository.PointRepository;
import org.banditbul.bandi.screendoor.entity.Screendoor;
import org.banditbul.bandi.screendoor.repository.ScreendoorRepository;
import org.banditbul.bandi.stair.entity.Stair;
import org.banditbul.bandi.stair.repository.StairRepository;
import org.banditbul.bandi.station.entity.Station;
import org.banditbul.bandi.station.repository.StationRepository;
import org.banditbul.bandi.toilet.entity.Toilet;
import org.banditbul.bandi.toilet.repository.ToiletRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class EdgeService {


    private final BeaconcoorRepository beaconcoorRepository;
    private final StationRepository stationRepository;
    private final PointRepository pointRepository;
    private final GateRepository gateRepository;
    private final BeaconRepository beaconRepository;
    private final ToiletRepository toiletRepository;
    private final ExitRepository exitRepository;
    private final StairRepository stairRepository;
    private final ElevatorRepository elevatorRepository;
    private final ScreendoorRepository screendoorRepository;
    private final EdgeRepository edgeRepository;

    public void navCurStation(String beaconId, String destStationName, int destExitNum){

        // 1. 현재 역 찾기
        // 가장 최근 접근한 비콘 id로 현재 역 id를 가지고 온다.
        int curStationId = beaconcoorRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 beaconcoor이 없습니다."))
                            .getStation().getId();
        // 시작하는 point 찾기
        Point startPoint = null;
        Beacon beacon = beaconRepository.findById(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 beacon이 없습니다."));

        // 우선 비콘ID로 해당 비콘의 시설물을 찾자
        // 해당하는 시설물: 개찰구 gate, 화장실 toilet, 출구 exit, 계단 stair, 엘리베이터 elevator, 스크린도어 screendoor
        String beaconType = beacon.getBeacon_type(); // toilet, gate, exit, stair, elevator, screendoor

        if (beaconType.equals("toilet")){
            Toilet toilet = toiletRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 화장실이 없습니다."));
            startPoint = toilet.getPoint();
        } else if (beaconType.equals("gate")){
            Gate gate = gateRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 개찰구가 없습니다."));
            startPoint = gate.getPoint();
        } else if (beaconType.equals("exit")){
            Exit exit = exitRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 출구가 없습니다."));
            startPoint = exit.getPoint();
        } else if (beaconType.equals("stair")){
            Stair stair = stairRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 계단이 없습니다."));
            startPoint = stair.getPoint();
        } else if (beaconType.equals("elevator")){
            Elevator elevator = elevatorRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 엘리베이터가 없습니다."));
            startPoint = elevator.getPoint();
        } else if (beaconType.equals("screendoor")){
            Screendoor screendoor = screendoorRepository.findByBeaconId(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 스크린도어가 없습니다."));
            startPoint = screendoor.getPoint();
        }


        // 2. 도착 역 찾기
        Station destStation = stationRepository.findByName(destStationName).orElseThrow(() -> new EntityNotFoundException("해당하는 station이 없습니다."));
        int destStationId = destStation.getId();

        // 2-1. 상행/하행 개찰구 찾기
        // 상행(다대포 95번) ~ 하행(노포 135번)
        // 역 안에 있는 모든 point 찾아주기
        List<Point> points = pointRepository.findAllByStationId(destStationId).orElseThrow(() -> new EntityNotFoundException("해당하는 point가 없습니다."));

        // 해당 역에 있는 모든 개찰구 찾기
        // Stream을 사용하여 각 Point의 ID로 Gate를 찾고, 결과를 리스트로 수집
        List<Gate> gates = points.stream()
                .map(point -> gateRepository.findByPointId(point.getId())
                        .orElseThrow(() -> new EntityNotFoundException("해당하는 gate가 없습니다.")))
                .toList();

        // 찾아진 Gate들에 대한 처리 로직 - 상행/하행 골라주기
        Point destGatePoint = null; // 내 목적지가 되는 gate!
        for (Gate gate : gates) {
            if (gate.getIsUp() == null) {
                destGatePoint = gate.getPoint();
                break;
            } else if (destStationId > curStationId && !gate.getIsUp()) { // 하행
                destGatePoint = gate.getPoint();
                break;
            } else if (destStationId < curStationId && gate.getIsUp()) { // 상행
                destGatePoint = gate.getPoint();
                break;
            }
        }


        // 2-2. 현재 비콘에서 개찰구 비콘까지의 경로 구하기
        // 개찰구까지 알려주면 그 이후에는 계단, 에스컬레이터, 엘레베이터 알아서 선택해서 스크린도어로 이동하면 되기 때매
        // 현재 포인트: startPoint
        // 도착 포인트: destGatePoint
        dij(startPoint, destGatePoint); // 다익스트라로 최단 경로 구하기


        // 3. 목적지 역에서 개찰구에서 출구까지
        Point startGatePoint = null; // 목적지 역의 상행 개찰구 point
        Point destExitPoint = null; // 목적지 역의 출구 point

        dij(startGatePoint, destExitPoint);

        int check=1;
    }

    public Integer addEdge(EdgeDto dto){
        System.out.println(dto.getPoint1());
        System.out.println(dto.getPoint2());
        Point point1 = pointRepository.findById(dto.getPoint1()).orElseThrow(() -> new EntityNotFoundException("해당하는 Point가 없습니다."));
        Point point2 = pointRepository.findById(dto.getPoint2()).orElseThrow(() -> new EntityNotFoundException("해당하는 Point가 없습니다."));
        Edge edge = new Edge(point1, point2, dto.getDistance(), dto.getStationId());
        Edge save = edgeRepository.save(edge);
        return save.getId();
    }

    private void dij(Point startPoint, Point destPoint){

    }

}
