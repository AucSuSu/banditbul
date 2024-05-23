E102# :house_with_garden: 반딧불이 - 시각장애인 길찾기 서비스
![icon](./exec/icon.png)

## :link: 반딧불이 링크(웹 화면): [반딧불이 :banditbul: 으로 이동](https://banditbul.co.kr)
## :cinema: 소개 영상 보기: [UCC](https://youtu.be/SHvd28duZ0A)
## 소개 PPT: [내돈내산 PPT](https://lab.ssafy.com/s10-bigdata-recom-sub2/S10P22E204/-/blob/master/exec/10%EA%B8%B0_%ED%8A%B9%ED%99%94PJT_%EB%B0%9C%ED%91%9C%EC%9E%90%EB%A3%8C_E204.pdf?ref_type=heads)

## :date: 프로젝트 진행 기간
**2024.04.08(월) ~ 2024.05.17(금)**: 6weeks

SSAFY 10기 2학기 자율 프로젝트 - 반딧불이 :house:


## :cherry_blossom: 내돈내산 기획 배경
:bulb: 지방 거주자가 서울에 자취방을 구할 때 정보 부족으로 인한 어려움을 해결
:heavy_check_mark: 집을 구할 때 인프라를 기준으로 동네를 정할 수 있도록 **인프라 기반 선호도** 조사
:heavy_check_mark: 인프라 기반으로 동을 군집화하여 적절한 동네를 사용자에게 추천해준다!

## :hammer: 개발 환경 및 기술 스택
### FE
<img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=JavaScript&logoColor=white">
<img src="https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white"><br>
<img src="https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB">
<img src="https://img.shields.io/badge/typescript-3178C6?style=for-the-badge&logo=typescript&logoColor=white">
<img src="https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white"><br>
<img src="https://img.shields.io/badge/flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white">

### BE
<img src="https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white"><br>
<img src="https://img.shields.io/badge/springboot-6DB33F?style=for-the-badge&logo=springboot&logoColor=white">
<img src="https://img.shields.io/badge/Hibernate-59666C?style=for-the-badge&logo=Hibernate&logoColor=white">
<img src="https://img.shields.io/badge/Gradle-02303A.svg?style=for-the-badge&logo=Gradle&logoColor=white"><br>
<img src="https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white">
<img src="https://img.shields.io/badge/redis-%23DD0031.svg?&style=for-the-badge&logo=redis&logoColor=white">
<img src="https://img.shields.io/badge/Spring_Security-6DB33F?style=for-the-badge&logo=Spring-Security&logoColor=white">

### INFRA
<img src="https://img.shields.io/badge/amazonec2-FF9900?style=for-the-badge&logo=amazonec2&logoColor=white">
<img src="https://img.shields.io/badge/amazonrds-527FFF?style=for-the-badge&logo=amazonrds&logoColor=white"><br>
<img src="https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=Jenkins&logoColor=white">
<img src="https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white">

<img src="https://img.shields.io/badge/nginx-009639?style=for-the-badge&logo=nginx&logoColor=white">

### 버전/이슈 관리
<img src="https://img.shields.io/badge/GitLab-330F63?style=for-the-badge&logo=gitlab&logoColor=white"> <img src="https://img.shields.io/badge/GIT-E44C30?style=for-the-badge&logo=git&logoColor=white">


### 협업
<img src="https://img.shields.io/badge/Mattermost-0058CC?style=for-the-badge&logo=Mattermost&logoColor=white"> <img src="https://img.shields.io/badge/Gerrit-EEEEEE?style=for-the-badge&logo=gerrit&logoColor=white"/>
<img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white">
<img src="https://img.shields.io/badge/Notion-%23000000.svg?style=for-the-badge&logo=notion&logoColor=white">
<img src="https://img.shields.io/badge/Jira-0052CC?style=for-the-badge&logo=Jira&logoColor=white">


## :bar_chart: 아키텍처 구조
![아키텍처구조](./readme_files/아키텍처구조도.png)

## :file_folder: 프로젝트 파일 구조

<details>
<summary><b>FE</b></summary>
<pre>
<code>
여기구조도 넣어야함
</code>
</pre>
</details>


<details>
<summary><b>BE</b></summary>
<pre>
<code>
여기 구조도 넣어야함
 </code>
 </pre>
</details>


<details>
<summary><b>ML</b></summary>
<pre>
<code>
</code>
</pre>
</details>


## :sparkler: 반딧불이 주요 기능
### 0. 메인 화면
- 메인페이지에서 현재역에서 목적지 역, 화장실까지 가는 길찾기 기능과 SOS 기능을 사용할 수 있습니다.
![EntryPage](./readme_files/메인페이지.jpg)

### 1. 길찾기 기능
- 현재 위치에서 목표로하는 지하철역이나 화장실까지 길찾기가 가능합니다.
![길찾기](./readme_files/길안내.gif)

### 2. SOS 기능
![도움 요청](./readme_files/도움요청접수.gif)

### 3. 모니터링 페이지
- 앱 사용자의 위치를 추적해서 어디에 몇명이 있는지 확인가능 합니다.
- SOS 요청이 온 비콘 위치를 파악이 가능합니다.
<br>
![모니터링 페이지](./readme_files/sos.png)


## :memo: 프로젝트 산출물
- [프로토타입](https://www.figma.com/design/1NuhYsXKYgQ7yBdlf5K6bw/%EB%B0%98%EB%94%A7%EB%B6%88%EC%9D%B4?node-id=0-1&t=0te8ipivObtRz7Pq-0)
- [API 명세서](https://www.notion.so/ca30758094e2428d8c77a3b9a2d7967c?v=488b4874a45f42b7bc9de9bb810dc361)
- [ERD](https://www.erdcloud.com/d/M6pxrgNRqzHRv6Sqa)
- [포팅 매뉴얼](https://lab.ssafy.com/s10-final/S10P31E102/-/blob/master/exec/%ED%8F%AC%ED%8C%85%EB%A7%A4%EB%89%B4%EC%96%BC.md?ref_type=heads)


## :family: 팀원 소개
<table>
  <tbody>
    <tr>
      <td align="center"><a href="https://github.com/ttaho"><img src="./readme_files/윤태호.png" width="100px;" alt=""/><br /><sub><b>BE 팀장 : 윤태호</b></sub></a><br /></td>
      <td align="center"><a href="https://github.com/MunsooKang"><img src="./readme_files/강문수.png" width="100px;" alt=""/><br /><sub><b>FE 팀원 : 강문수</b></sub></a><br /></td>
      <td align="center"><a href="https://github.com/arim-kim"><img src="./readme_files/김아림.png" width="100px;" alt=""/><br /><sub><b>BE 팀원 : 김아림</b></sub></a><br /></td>
      <td align="center"><a href="https://github.com/makie082"><img src="./readme_files/우미경.png" width="100px;" alt=""/><br /><sub><b>BE 팀원 : 우미경</b></sub></a><br /></td>
      <td align="center"><a href="https://github.com/dogfish000"><img src="./readme_files/윤태우.png" width="100px;" alt=""/><br /><sub><b>FE 팀원 : 윤태우</b></sub></a><br /></td>
      <td align="center"><a href="https://github.com/RaelJung"><img src="./readme_files/정라엘.png" width="100px;" alt=""/><br /><sub><b>FE 팀원 : 정라엘</b></sub></a><br /></td>
    </tr>
  </tbody>
</table>