# 활동 자세히보기
mateya의 활동 자세히보기에 대한 지침이다.
공통 지침으로 ".agents/docs/common.md"를 참고한다.



## D-1.자세히보기 화면
"A.홈화면"또는 "B.둘러보기 화면"의 목록 중 한 활동을 누르면 해당 화면으로 이동된다.
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-1416&t=MxUj4cCr1Lu8U3oK-11

### 기능
- 첫번째로 상단 썸네일 영역에는 대표사진과 카테고리뱃지가 좌측 위에 나온다.
- 사진은 최대 5장 까지있으며, 슬라이드를 통해 좌,우로 넘길 수 있다.
  - 맨 처음 접속시엔 항상 대표이미지가 떠있다.
- 두번째로  활동 제목과 정보들이 나온다. 정보에는 날짜, 시각 및 시간, 리뷰, 참가자수,장소가 있다.
  - 날짜 형식: 2026년 06월 25일 
  - 시각 형식: 오후 08:00 ~ 10:00
  - 리뷰 형식: 4.91 (리뷰 128개)
  - 참가자수 형식: 18/25 참여
  - 장소 형식: 서울 서대문구, 기념비공원
- 세번째로 참여자 정보가 나온다. 참가자수, 남은 인원수, 이에대한 프로그레스바, 참여한 인원들의 프로필 사진이 나온다.
  - 참가자수 형식은 다음과 같다. "18명 참여중"
  - 남은 참가자수 형식은 다음과 같다 "7명 남았어요"
  - 프로그레스바는 전체 인원에 대한 참여자수의 비율을 나타낸다.
  - 참여자들의 프로필 사진이 보이며, 8개까지 보이고 이후에는 우측에 "+8"과 같은 형태로 표기된다.
    - 해당 섹션을 참고한다: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2395-2024&t=lehsq2WBOOu9wscG-11
- 네번째로 모임을 생성한 유저인 호스트의 정보가 나온다. 호스트의 프로필 사진, 이름, 국가 및 지역, 친구추가 버튼이 있다.
  - 형식은 다음과 같다. "Lee MinJi 이민지", "Living in Seoul · Shindang dong"
- 다섯번째로 활동 소개가 나온다.
  - 양식 예시이다. "서울 한복판에서 벗어나 자연 속에서 함께 땀 흘리며 추억을 만들어보세요. 한라산 등산을 함께할 참여자를 모집합니다. 등산 경험이 많지 않아도 괜찮으며, 서로 속도를 맞춰 안전하고 즐겁게 산행할 예정입니다. 정상에서 멋진 풍경을 감상하고, 하산 후에는 자유롭게 식사나 이야기를 나누며 친목도 다질 수 있습니다. 혼자 가기 망설여졌던 분, 새로운 사람들과 건강한 취미를 즐기고 싶은 분들의 많은 참여를 기다립니다.
- 다음으로 후기 목록이 나온다.
  - 후기와 그 개수, 전체보기 버튼이 나온다. 
  - 전체보기 버튼을 클릭시 "D-2.리뷰 목록 보기"화면으로 넘어간다.
  - 현재화면에서 목록은 최대 5개까지 보인다. 
- 맨 아래에는 하단바가 있다. 하단바는 스크롤 고정이며 늘 핸드폰 화면 하단에 위치한다.
  - 하단바에는 체험료, 즐겨찾기, 공유하기, 참가하기 버튼이 있다.
  - 즐겨찾기 버튼을 통해 즐겨찾기 할 수 있다. https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2429-2030&t=lehsq2WBOOu9wscG-11
  - 공유하기 버튼을 통해 url을 복사하거나 카톡 같은 플랫폼으로 공유가 가능하다. 이부분은 실무적으로 구현한다.
  - 참가하기 버튼을 통해 활동에 참가가능하다. 


## D-2.리뷰 목록 보기
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-1414&t=MxUj4cCr1Lu8U3oK-11

### 기능
- 첫번째로 활동 제목이 나온다.
- 두번째로 평점 패널이 나온다. 평점패널에는 전체 평점 개수 및 평균과, 각 점수별로 분포 프로그레스 바가 존재한다.
  - 참고: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2398-1773&t=lehsq2WBOOu9wscG-11
- 세번째로 카테고리 목록이 나온다.
  - 목록에 대한 필터가 존재한다. 기본 최신순이며 오래된순, 평점 높은순, 평점 낮은순이다.
  - 리뷰목록은 무한 스크롤링으로 구현한다.
  - 각 리뷰에 대해 작성자 정보(프로필 사진, 이름), 작성 날짜, 평점(1점 단위), 리뷰 본문, 도움이돼요 버튼, 도움이 된 사람 수, 번역 보기가 존재한다.
    - 날짜 형식은 다음과 같다. "2026년 1월 23일"
    - 점수 형식: "4점"
    - 본문 형식: "We had a delightful stay! We loved soaking in the tub, hiking in the area, and wine tasting in Truckee."
    - 즐겨찾기 버튼은 해당 컴포넌트로 토글된다. "https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2429-2030&t=lehsq2WBOOu9wscG-11"
    - 도움이 된 사람 수 형식: "12명에게 도움이 됨"
    - 번역보기 버튼은 "번역보기", "원문보기"로 토글된다.
  - 가장 하단에는 "후기 작성하기"버튼이 있다. 이를 누르면 "D-3.리뷰 작성하기"(https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2398-2011&t=lehsq2WBOOu9wscG-11)화면처럼 리뷰쓰기 팝업을 볼 수 있다.


## D-3.리뷰 작성하기
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2398-2011&t=MxUj4cCr1Lu8U3oK-11

### 기능
- 리뷰를 작성하는 화면 팝업이다. "D-2.리뷰 목록 보기"화면이 어두워지고 그 위에 리뷰바가 나타난다.
- 좌측 위 엑스버튼을 누르면 팝업이 닫힌다.
- 별점 버튼 목록을 통해 별점을 줄 수 있다.
  - 별은 최대 5개이며, n번째 별을 누르면 n점으로 설정이된다.
  - 설정된 별은 Black 색상, 비활성화된 별은 "B7B7B7"색상이다.
  - 그 아래 리뷰 본문 입력창이 나온다.
    - 리뷰 본문 입력창 우측 하단에 글자수가 나온다. 형식은 "248/500 자"이다.
- 아래 최대 5장 이미지 삽입이 가능하다. 첫 번째이미지가 대표이미지 이며, 이미지 순서는 드래그 드랍을 통해 변경 가능하다. 이미지의 미리보기도 가능하다. 이부분은 실무적으로 구현한다.
- 하단 작성하기 버튼을 통해 작성이 가능하다.