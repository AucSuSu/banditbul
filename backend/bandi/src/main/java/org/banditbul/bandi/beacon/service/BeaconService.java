package org.banditbul.bandi.beacon.service;

import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.beacon.dto.BeaconDto;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.beacon.repository.BeaconRepository;
import org.banditbul.bandi.beaconcoor.dto.BeaconcoorDto;
import org.banditbul.bandi.beaconcoor.entity.Beaconcoor;
import org.banditbul.bandi.beaconcoor.service.BeaconcoorService;
import org.banditbul.bandi.elevator.entity.Elevator;
import org.banditbul.bandi.elevator.repository.ElevatorRepository;
import org.banditbul.bandi.exit.entity.Exit;
import org.banditbul.bandi.exit.repository.ExitRepository;
import org.banditbul.bandi.gate.entity.Gate;
import org.banditbul.bandi.gate.repository.GateRepository;
import org.banditbul.bandi.point.dto.PointDto;
import org.banditbul.bandi.point.entity.Point;
import org.banditbul.bandi.point.service.PointService;

import org.banditbul.bandi.screendoor.entity.Screendoor;
import org.banditbul.bandi.screendoor.repository.ScreendoorRepository;
import org.banditbul.bandi.stair.entity.Stair;
import org.banditbul.bandi.stair.repository.StairRepository;
import org.banditbul.bandi.toilet.entity.Toilet;
import org.banditbul.bandi.toilet.repository.ToiletRepository;
import org.springframework.stereotype.Service;

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
    private final PointService pointService;
    private final BeaconcoorService beaconcoorService;

    public String createBeacon(BeaconDto beaconDto){
        String beaconType = beaconDto.getBeaconType();
        Beacon beacon = new Beacon(beaconDto.getMacAddress(), beaconType);
        beaconRepository.save(beacon);

        PointDto pointDto = new PointDto();
        pointDto.setStationId(beaconDto.getStationId());
        pointDto.setLatitude(beaconDto.getLatitude());
        pointDto.setLongitude(beaconDto.getLongitude());
        pointDto.setRange(beaconDto.getRange());
        Point point = pointService.createPoint(pointDto);

        BeaconcoorDto beaconcoorDto = new BeaconcoorDto();
        beaconcoorDto.setX(beaconDto.getX());
        beaconcoorDto.setY(beaconDto.getY());
        beaconcoorDto.setFloor(beaconDto.getFloor());
        beaconcoorDto.setStationId(beaconDto.getStationId());
        Beaconcoor coor = beaconcoorService.createCoor(beaconcoorDto);

        // 비콘 타입이 뭔지에 따라 다른 테이블에 저장하기.
        if(beaconType.equals("toilet")){
            Toilet toilet = new Toilet();
            toilet.setBeacon(beacon);
            toilet.setPoint(point);
            toilet.setManDir(beaconDto.getManDir());
            toilet.setWomanDir(beaconDto.getWomanDir());
            toiletRepository.save(toilet);
        }else if(beaconType.equals("gate")){
            gateRepository.save(new Gate(beacon, point, beaconDto.isUp()));
        }else if(beaconType.equals("exit")){
            exitRepository.save(new Exit(beacon, point, beaconDto.getNumber(), beaconDto.getLandmark(), beaconDto.getElevator(), beaconDto.getEscalator(), beaconDto.getStair()));
        }else if(beaconType.equals("stair")){
            stairRepository.save(new Stair(beacon, point, beaconDto.isUp()));
        }else if(beaconType.equals("elevator")){
            elevatorRepository.save(new Elevator(beacon, point, beaconDto.isUp()));
        }else if(beaconType.equals("screendoor")){
            screendoorRepository.save(new Screendoor(beacon, point, beaconDto.getDirection()));
        }
        return beacon.getId();
    }
}
