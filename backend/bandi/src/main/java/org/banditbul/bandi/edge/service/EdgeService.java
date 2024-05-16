
package org.banditbul.bandi.edge.service;
import java.util.stream.Collectors;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.banditbul.bandi.beacon.entity.Beacon;
import org.banditbul.bandi.beacon.entity.BeaconTYPE;
import org.banditbul.bandi.beacon.repository.BeaconRepository;
import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.common.exception.ExistException;
import org.banditbul.bandi.edge.dto.CheckPointDto;
import org.banditbul.bandi.edge.dto.EdgeDto;
import org.banditbul.bandi.edge.dto.ResultRouteDto;
import org.banditbul.bandi.edge.entity.Edge;
import org.banditbul.bandi.edge.repository.EdgeRepository;
import org.banditbul.bandi.elevator.entity.Elevator;
import org.banditbul.bandi.elevator.repository.ElevatorRepository;
import org.banditbul.bandi.escalator.entity.Escalator;
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
import java.util.*;
@Service
@RequiredArgsConstructor
public class EdgeService {
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


    public void deleteEdge(int edgeId){

        edgeRepository.deleteById(edgeId);

    }

    public ResultRouteDto navCurStation(String beaconId, String dest){
        // 0. dest에서 역, 출구로 두개 쪼개기 아마 split 쓸듯?  substring?


        // 공백을 기준으로 문자열을 분할하여 배열로 저장합니다.
        String[] parts = dest.split("\\s+");

        // 첫 번째 요소는 역 이름입니다.
        String stationName = parts[0];

        // 나머지 요소들을 모두 출구 번호로 합칩니다.
        StringBuilder exitNumberBuilder = new StringBuilder();
        for (int i = 1; i < parts.length; i++) {
            exitNumberBuilder.append(parts[i]);
            if (i < parts.length - 1) {
                exitNumberBuilder.append(" "); // 출구 번호 사이에 공백을 추가합니다.
            }
        }
        int exitNumber = 0;
        try{
            exitNumber = Integer.parseInt(exitNumberBuilder.toString().replaceAll("[^0-9]", ""));
        }catch (NumberFormatException e){
            throw new NumberFormatException("출구를 입력하지 않았습니다.");
        }

        System.out.println("역 이름: " + stationName);
        System.out.println("출구 번호: " + exitNumber);




        // 1. beaconId로 시작 비콘 찾기
        Beacon startBeacon = beaconRepository.findById(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 비콘이 없습니다"));
        // 2. 현재 역과 도착역 찾기
        Station startStation = startBeacon.getStation();
        Station destStation = stationRepository.findByName(stationName).orElseThrow(() -> new EntityNotFoundException("해당하는 station이 없습니다."));
        int curStationId = startStation.getId();
        int destStationId = destStation.getId();
        // 2-1. 상행/하행 개찰구(첫번째 도착점) 찾기
        // 상행(다대포 95번) ~ 하행(노포 135번)
        // 출발역 안에 있는 모든 beacon과 edge 리스트 가져오기
        List<Beacon> beaconList = startStation.getBeaconList();
        List<Edge> edgeList = startStation.getEdgeList();
        // 2-2 비콘들을 돌면서 비콘 종류가 개찰구인 것들을 찾아오기
        // 해당 역에 있는 모든 개찰구의 beaconId 찾기
        List<String> beaconIdList = new ArrayList<>();
        for( Beacon beacon : beaconList){
            if( beacon.getBeaconType().equals(BeaconTYPE.GATE)) beaconIdList.add(beacon.getId());
        }
        // beaconId로 gate 객체 불러오기
        List<Gate> gateList = new ArrayList<>();

        for( String bId : beaconIdList){
            Beacon beacon = beaconRepository.findById(bId)
                .orElseThrow(() -> new EntityNotFoundException("해당하는 비콘이 없습니다."));
            Gate gate = gateRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 개찰구가 없습니다."));
            gateList.add(gate);
        }
        // 찾아진 Gate들에 대한 처리 로직 - 상행/하행 골라주기
        Beacon destBeacon = null; // 내 목적지가 되는 gate!
        Gate destGate = null;
        for (Gate gate : gateList) {
            if (gate.getIsUp() == null) {
                destBeacon = gate.getBeacon();
                destGate = gate;
                break;
            } else if (destStationId > curStationId && !gate.getIsUp()) { // 하행
                destBeacon = gate.getBeacon();
                destGate = gate;
                break;
            } else if (destStationId < curStationId && gate.getIsUp()) { // 상행
                destBeacon = gate.getBeacon();
                destGate = gate;
                break;
            }
        }
        // 3. 현재 비콘에서 개찰구 비콘까지의 경로 구하기
        // 출발 비콘: startBeacon
        // 도착 비콘: destBeacon
        // 다익스트라 알고리즘으로 경로상의 비콘 ID 리스트를 얻음
        List<String> list = dij(startBeacon, destBeacon, beaconList, edgeList);
        // ID 리스트를 사용하여 비콘 객체 리스트를 가져옴
        List<Beacon> beacons = findBeaconsOrdered(list);
        // CCW 알고리즘으로 방향 결정
        List<String> directions = ccw(beacons);
        // 결과 리스트 생성
        List<CheckPointDto> resultList = new ArrayList<>();
        // 첫 번째 비콘에 대한 방향 초기화
        if( beacons.size() == 1){
            resultList.add(new CheckPointDto(destBeacon.getId(), 0, formatGateInfo(destGate)));
        }
        else if (beacons.size() > 1) {

            Beacon beacon1 = beacons.get(0);
            Beacon beacon2 = beacons.get(1);

            Edge edge = edgeRepository.findByBeacon1AndBeacon2(beacon1, beacon2);
            if(edge == null){
                edge = edgeRepository.findByBeacon1AndBeacon2(beacon2, beacon1);
            }

            resultList.add(new CheckPointDto(beacons.get(0).getId(), edge.getDistance(),"직진"));
        }
        for (int i = 1; i < beacons.size() - 1; i++) {
            Beacon current = beacons.get(i);
            Beacon next = beacons.get(i + 1);

            // Edge 테이블에서 current와 next 사이의 거리 가져오기
            Edge edge = edgeRepository.findByBeacon1AndBeacon2(current, next);
            if (edge == null) {
                edge = edgeRepository.findByBeacon1AndBeacon2(next, current); // 양방향 검색
            }

            // 여기까지 왔는데 간선이 없으면 exception 던지자
            if(edge == null) throw new EntityNotFoundException("찾으려는 간선이 없습니다.");

            int distance = (edge != null) ? edge.getDistance() : 0;

            // 비콘 ID, 거리, 방향 정보 포함하여 결과 리스트에 추가
            resultList.add(new CheckPointDto(current.getId(), distance, directions.get(i-1)));
        }
        // 마지막 비콘에 대한 텍스트 추가
        if (beacons.size() >= 2) {
            resultList.add(new CheckPointDto(destBeacon.getId(), 0,formatGateInfo(destGate)));
        }

        // 4. 목적지 역에서 개찰구에서 출구까지

        // 일단 전체 비콘과 간선 불러오기
        List<Beacon> destStationBeaconList = destStation.getBeaconList();
        List<Edge> destStationEdgeList = destStation.getEdgeList();

        // 해당 역에 있는 모든 개찰구의 beaconId 찾기
        List<String> gateIdList = new ArrayList<>();
        for( Beacon beacon : destStationBeaconList){
            if( beacon.getBeaconType().equals(BeaconTYPE.GATE)) gateIdList.add(beacon.getId());
        }
        // beaconId로 gate 찾기
        Gate destinationGate = null;

        for( String bId : gateIdList){
            Beacon beacon = beaconRepository.findById(bId)
                .orElseThrow(() -> new EntityNotFoundException("해당하는 비콘이 없습니다."));
            Gate gate = gateRepository.findByBeacon(beacon).orElseThrow(() -> new EntityNotFoundException("해당하는 개찰구가 없습니다."));
            if( gate.getIsUp() == !destGate.getIsUp()) destinationGate = gate;
        }
        System.out.println(destinationGate);
        // Gate 들에서 나올 게이트 골라주기 (시작점)
        Beacon startGate = destinationGate.getBeacon();

        Exit exit = exitRepository.findByNumber(exitNumber)
            .orElseThrow(() -> new EntityNotFoundException("출구번호에 맞는 해당역의 출구가 없습니다."));
        Beacon destExit = exit.getBeacon(); // 목적지 역의 출구 비콘

        // 개찰구 비콘에서 출구 비콘까지의 경로 구하기
        // 다익스트라 알고리즘으로 경로상의 비콘 ID 리스트를 얻음
        System.out.println("시작 개찰구 : " + startGate);
        System.out.println("출구 : " + destExit);
        List<String> destList = dij(startGate, destExit, destStationBeaconList, destStationEdgeList);
        // ID 리스트를 사용하여 비콘 객체 리스트를 가져옴
        List<Beacon> beaconsList = findBeaconsOrdered(destList);
        // CCW 알고리즘으로 방향 결정
        List<String> directionList = ccw(beaconsList);
        System.out.println(directionList);

        // 결과 리스트 생성
        List<CheckPointDto> resultList2 = new ArrayList<>();
        // 첫 번째 비콘에 대한 방향 초기화
        if(beaconsList.size() == 1){
            resultList2.add(new CheckPointDto(destExit.getId(), 0,formatExitInfo(exit)));
        }
        else if (beaconsList.size() > 1) {
            Beacon beacon1 = beaconsList.get(0);
            Beacon beacon2 = beaconsList.get(1);

            Edge edge = edgeRepository.findByBeacon1AndBeacon2(beacon1, beacon2);
            if(edge == null){
                edge = edgeRepository.findByBeacon1AndBeacon2(beacon2, beacon1);
            }
            resultList2.add(new CheckPointDto(beacon1.getId(), edge.getDistance(),"직진"));
        }
        for (int i = 1; i < beaconsList.size() - 1; i++) {
            Beacon current = beaconsList.get(i);
            System.out.println(current.getId());
            Beacon next = beaconsList.get(i + 1);

            // Edge 테이블에서 current와 next 사이의 거리 가져오기
            Edge edge = edgeRepository.findByBeacon1AndBeacon2(current, next);
            if (edge == null) {
                edge = edgeRepository.findByBeacon1AndBeacon2(next, current); // 양방향 검색
            }

            // 여기까지 왔는데 간선이 없으면 exception 던지자
            if(edge == null) throw new EntityNotFoundException("찾으려는 간선이 없습니다.");

            int distance = (edge != null) ? edge.getDistance() : 0;

            // 비콘 ID, 거리, 방향 정보 포함하여 결과 리스트에 추가
            resultList2.add(new CheckPointDto(current.getId(), distance, directionList.get(i-1)));
        }
        // 마지막 비콘에 대한 텍스트 추가
        if (beacons.size() >= 2) {
            resultList2.add(new CheckPointDto(destExit.getId(), 0,formatExitInfo(exit)));
        }
        ResultRouteDto dto = new ResultRouteDto(resultList, resultList2);
        System.out.println(resultList);
        return dto;
    }

    // 현재역의 화장실까지 가는 경로를 return
    public ResultRouteDto navToilet(String beaconId){

        // 1. beaconId로 시작 비콘 찾기
        Beacon startBeacon = beaconRepository.findById(beaconId).orElseThrow(() -> new EntityNotFoundException("해당하는 비콘이 없습니다"));
        Station startStation = startBeacon.getStation();
        // 2. 그 역의 화장실 찾기
        // 출발역 안에 있는 모든 beacon과 edge 리스트 가져오기
        List<Beacon> beaconList = startStation.getBeaconList();
        List<Edge> edgeList = startStation.getEdgeList();
        // 2-2 비콘들을 돌면서 비콘 종류가 화장실인것들을 찾아오기
        // 해당 역에 있는 모든 화장실의 beaconId 찾기
        List<String> beaconIdList = new ArrayList<>();
        for( Beacon beacon : beaconList){
            if( beacon.getBeaconType().equals(BeaconTYPE.TOILET)) beaconIdList.add(beacon.getId());
        }
        // beaconId로 gate 객체 불러오기
        List<Toilet> toiletList = new ArrayList<>();

        for( String bId : beaconIdList){
            Beacon toiletBeacon = beaconRepository.findById(bId)
                .orElseThrow(() -> new EntityNotFoundException("해당하는 비콘이 없습니다."));
            Toilet toilet = toiletRepository.findByBeacon(toiletBeacon).orElseThrow(() -> new EntityNotFoundException("해당하는 화장실이 없습니다."));
            toiletList.add(toilet);
        }
        // 찾아진 화장실들에 대한 처리 로직 - 현재위치에서 가장 가까운 화장실 고르기
        Beacon destBeacon = null; // 내 목적지가 되는 화장실 비콘
        Toilet destToilet = null;
        double min = Double.MAX_VALUE;
        for (Toilet toilet : toiletList) {
            Beacon beacon = toilet.getBeacon();
            Double longitude = beacon.getLongitude();
            Double latitude = beacon.getLatitude();
            double distance = distance(latitude, longitude, startBeacon.getLatitude(), startBeacon.getLongitude());
            if( min > distance) {
                destBeacon = beacon;
                destToilet = toilet;
            }
        }

        // 3. 현재 비콘에서 화장실 비콘까지의 경로 구하기
        // 출발 비콘: startBeacon
        // 도착 비콘: destBeacon
        // 다익스트라 알고리즘으로 경로상의 비콘 ID 리스트를 얻음
        List<String> list = dij(startBeacon, destBeacon, beaconList, edgeList);
        // ID 리스트를 사용하여 비콘 객체 리스트를 가져옴
        List<Beacon> beacons = findBeaconsOrdered(list);
        // CCW 알고리즘으로 방향 결정
        List<String> directions = ccw(beacons);
        System.out.println(beacons);

        // 결과 리스트 생성
        System.out.println(beacons.size());
        List<CheckPointDto> resultList = new ArrayList<>();
        // 첫 번째 비콘에 대한 방향 초기화
        if(beacons.size() == 1){
            resultList.add(new CheckPointDto(destBeacon.getId(), 0,formatToiletInfo(destToilet)));
        }
        else if (beacons.size() > 1) {

            Beacon beacon1 = beacons.get(0);
            Beacon beacon2 = beacons.get(1);

            Edge edge = edgeRepository.findByBeacon1AndBeacon2(beacon1, beacon2);
            if(edge == null){
                edge = edgeRepository.findByBeacon1AndBeacon2(beacon2, beacon1);
            }
            resultList.add(new CheckPointDto(beacons.get(0).getId(), edge.getDistance(),"직진"));
        }
        for (int i = 1; i < beacons.size() - 1; i++) {
            Beacon current = beacons.get(i);
            System.out.println(current.getId());
            Beacon next = beacons.get(i + 1);

            // Edge 테이블에서 current와 next 사이의 거리 가져오기
            Edge edge = edgeRepository.findByBeacon1AndBeacon2(current, next);
            if (edge == null) {
                edge = edgeRepository.findByBeacon1AndBeacon2(next, current); // 양방향 검색
            }

            // 여기까지 왔는데 간선이 없으면 exception 던지자
            if(edge == null) throw new EntityNotFoundException("찾으려는 간선이 없습니다.");

            int distance = (edge != null) ? edge.getDistance() : 0;

            // 비콘 ID, 거리, 방향 정보 포함하여 결과 리스트에 추가
            resultList.add(new CheckPointDto(current.getId(), distance, directions.get(i-1)));
        }
        // 마지막 비콘에 대한 텍스트 추가
        if (beacons.size() >= 2) {
            resultList.add(new CheckPointDto(destBeacon.getId(), 0,formatToiletInfo(destToilet)));
        }

        System.out.println(resultList);
        ResultRouteDto dto = new ResultRouteDto(resultList);
        return dto;
    }

    private List<String> dij(Beacon start, Beacon dest, List<Beacon> beaconList, List<Edge> edgeList){
        HashMap<String, Boolean> visited = new HashMap<>(); // 방문 여부 체크
        HashMap<String, Integer> distance = new HashMap<>(); // 각 비콘까지의 최단 거리
        HashMap<String, String> path = new HashMap<>(); // 최단 경로를 추적
        final int INF = Integer.MAX_VALUE;

        // 그래프 초기화
        HashMap<String, ArrayList<Node>> graph = new HashMap<>();
        for (Edge edge : edgeList) {
            graph.putIfAbsent(edge.getBeacon1().getId(), new ArrayList<>());
            graph.putIfAbsent(edge.getBeacon2().getId(), new ArrayList<>());
            graph.get(edge.getBeacon1().getId()).add(new Node(edge.getBeacon2().getId(), edge.getDistance()));
            graph.get(edge.getBeacon2().getId()).add(new Node(edge.getBeacon1().getId(), edge.getDistance()));
        }

        // 모든 비콘의 거리를 무한대로 초기화
        for (Beacon beacon : beaconList) {
            distance.put(beacon.getId(), INF);
            visited.put(beacon.getId(), false);
        }

        // 시작점의 거리를 0으로 설정
        PriorityQueue<Node> pq = new PriorityQueue<>();
        distance.put(start.getId(), 0);
        pq.offer(new Node(start.getId(), 0));

        while(!pq.isEmpty()) {
            Node currentNode = pq.poll();
            String currentId = currentNode.beaconId;

            // 이미 방문한 정점은 건너뛰기
            if (visited.get(currentId)) continue;
            visited.put(currentId, true);

            // 현재 정점과 인접한 정점들에 대한 처리
            for (Node adjacent : graph.getOrDefault(currentId, new ArrayList<>())) {
                if (distance.get(adjacent.beaconId) > distance.get(currentId) + adjacent.distance) {
                    distance.put(adjacent.beaconId, distance.get(currentId) + adjacent.distance);
                    pq.offer(new Node(adjacent.beaconId, distance.get(adjacent.beaconId)));
                    path.put(adjacent.beaconId, currentId);
                }
            }
        }

        // 최단 경로 복원
        return reconstructPath(path, start.getId(), dest.getId());
    }
    private List<String> reconstructPath(HashMap<String, String> path, String startId, String destId) {
        LinkedList<String> route = new LinkedList<>();
        for (String at = destId; path.containsKey(at); at = path.get(at)) {
            route.addFirst(at);
        }
        route.addFirst(startId);
        return route;
    }
    class Node implements Comparable<Node> {
        String beaconId;
        int distance;

        public Node(String beaconId, int distance) {
            this.beaconId = beaconId;
            this.distance = distance;
        }

        @Override
        public int compareTo(Node other) {
            return Integer.compare(this.distance, other.distance);
        }
    }
    public List<Beacon> findBeaconsOrdered(List<String> beaconIds) {
        // 데이터베이스에서 ID 리스트에 있는 모든 Beacon 객체를 가져옵니다.
        List<Beacon> beacons = beaconRepository.findByIdIn(beaconIds);

        // 가져온 Beacon 리스트를 원래 beaconIds 리스트의 순서대로 정렬합니다.
        Map<String, Integer> indexMap = new HashMap<>();
        for (int i = 0; i < beaconIds.size(); i++) {
            indexMap.put(beaconIds.get(i), i);
        }

        return beacons.stream()
            .sorted(Comparator.comparingInt(beacon -> indexMap.get(beacon.getId())))
            .collect(Collectors.toList());
    }
    private double distance(double lat1, double lon1, double lat2, double lon2) {

        double theta = lon1 - lon2;
        double dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.cos(deg2rad(theta));

        dist = Math.acos(dist);
        dist = rad2deg(dist);
        dist = dist * 60 * 1.1515 * 1609.344;

        return dist;
    }
    public List<String> ccw(List<Beacon> beacons) {
        List<String> directions = new ArrayList<>();
        for (int i = 1; i < beacons.size() - 1; i++) {
            Beacon A = beacons.get(i - 1);
            Beacon B = beacons.get(i);
            Beacon C = beacons.get(i + 1);
            // CCW 공식 적용
            double ccw = (B.getY() - A.getY()) * (C.getX() - A.getX()) -
                (B.getX() - A.getX()) * (C.getY() - A.getY());

            if (ccw > 0) {
                directions.add("왼쪽");
            } else if (ccw < 0) {
                directions.add("오른쪽");
            } else {
                directions.add("직진");
            }
        }
        return directions;
    }


    private double deg2rad(double deg) {
        return (deg * Math.PI / 180.0);
    }
    private double rad2deg(double rad) {
        return (rad * 180 / Math.PI);
    }

    // 개찰구 정보를 문자열로 변환
    private String formatGateInfo(Gate gate) {
        StringBuilder sb = new StringBuilder();
        sb.append("개찰구 정보: ");
        sb.append(gate.getIsUp() ? "상행 " : "하행 ");
        sb.append("엘리베이터: ").append(gate.getElevator()).append(", ");
        sb.append("에스컬레이터: ").append(gate.getEscalator()).append(", ");
        sb.append("계단: ").append(gate.getStair());
        return sb.toString();
    }

    private String formatToiletInfo(Toilet toilet) {
        StringBuilder sb = new StringBuilder();
        sb.append("화장실 정보: ");
        sb.append("여자화장실: ").append(toilet.getWomanDir()).append(", ");
        sb.append("남자화장실: ").append(toilet.getManDir()).append(", ");
        return sb.toString();
    }

    private String formatExitInfo(Exit exit) {
        StringBuilder sb = new StringBuilder();
        sb.append("출구 정보: " + exit.getNumber() + "번 출구");
        sb.append("엘리베이터: ").append(exit.getElevator()).append(", ");
        sb.append("에스컬레이터: ").append(exit.getEscalator()).append(", ");
        sb.append("계단: ").append(exit.getStair());
        return sb.toString();
    }

    public Integer addEdge(EdgeDto dto){
        Beacon beacon1 = beaconRepository.findById(dto.getBeacon1()).orElseThrow(() -> new EntityNotFoundException("비콘을 찾을 수 없습니다"));
        Beacon beacon2 = beaconRepository.findById(dto.getBeacon2()).orElseThrow(() -> new EntityNotFoundException("비콘을 찾을 수 없습니다"));
        Station station = stationRepository.findById(dto.getStationId()).orElseThrow(() -> new EntityNotFoundException("해당하는 station이 없습니다."));


        // 양방향 체크를 통해 에지 존재 여부 확인
        boolean exists = edgeRepository.existsByBeacon1AndBeacon2OrBeacon2AndBeacon1(beacon1, beacon2, beacon2, beacon1);
        if (exists) {
            throw new ExistException("이미 해당하는 에지가 존재합니다 (양방향).");
        }

        int meter = (int) distance(beacon1.getLatitude(), beacon1.getLongitude(), beacon2.getLatitude(), beacon2.getLongitude());
        Edge edge = new Edge(beacon1, beacon2, meter, station);
        Edge save = edgeRepository.save(edge);
        return save.getDistance();
    }
}
