# 채팅
mateya의 채팅 구현에 대한 지침이다.
공통 지침으로 ".agents/docs/common.md"를 참고한다.

섹션 url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2401-2651&t=MxUj4cCr1Lu8U3oK-4

## G.채팅방 목록
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-1418&t=MxUj4cCr1Lu8U3oK-11

### 기능
- 상단 필터 기능: 전체, 단체, 개인 채팅방으로 필터링을 걸 수 있다.
  - 단체 채팅방 생성은 모임에 참여할 경우 생성이 된다. 이 기능은 아직 구현되지 않았으므로, 추후 연결할것이다. 
  - 단체 채팅방 생성은 모임 상세보기나 다른이의 프로필에서 친구추가를 누를 경우 생성이 된다. 이 기능은 아직 구현되지 않았으므로, 추후 연결할것이다.
- 채팅 목록
  - 채팅 사진 
    - 단체의 경우 모임 대표사진
    - 개인의 경우 프로필 사진
  - 채팅 제목
    - 단체의 경우 모임 제목
    - 개인의 경우 유저 이름
  - 가장 최근 채팅 내역
    - 최대 2줄
  - 안 읽은 알림 개수
    - 최대 20개
  - 보낸 시간
    - 예시 형식: 15분전, 6월 27일, 작년 ... 등 실무적으로 구현해줘
- 채팅 요소 하나를 누를 경우 "H.채팅방"화면으로 이어진다.

## H.채팅방
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-1419&t=MxUj4cCr1Lu8U3oK-11

### 기능 
- 채팅방 헤더
  - 채팅방 제목, 참여 인원수가 명시된다.
  - 좌측 뒤로가기와 우측 globe 아이콘이 존재한다. 
  - 뒤로가기 버튼을 누를경우 뒤로가기가 지원된다.
  - globe버튼에 대한 구현은 추후예정이다.
- 채팅
  - 채팅당 보낸이의 프로필 사진, 이름, 채팅 내용, 보낸 시간이 제공된다.
  - 채팅은 번역 보기, 원문 보기가 토글로 제공된다. 
- 채팅방 푸터
  - 사진 첨부
    - 사진 조건은 실무적으로 구현 
  - 보낼 내용 입력
  - 보내기