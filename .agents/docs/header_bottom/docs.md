# 헤더와 bottom
공통적으로 사용될 헤더와 bottom 컴포넌트를 만들기 위한 지침이다.

## 공통지침 
- 기존 컴포넌트와 스타일 토큰을 먼저 찾아서 재사용하고,
없을 때만 새 컴포넌트를 만들어줘.
- 반응형은 iPhone 16 Pro 기준 모바일 우선으로 맞춰줘.

- 참고섹션 url 1: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2338-1050&t=MxUj4cCr1Lu8U3oK-4
- 참고섹션 url 2: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2338-1069&t=MxUj4cCr1Lu8U3oK-4

## 헤더
헤더는 세 종류가 있다.
1. "Header_no_backarrow" 컴포넌트 
- 뒤로가지않아도 되는 상황에 사용
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2401-2649&t=MxUj4cCr1Lu8U3oK-4

2."Header_backarrow" 컴포넌트
- 뒤로가기가 필요한 상황에 사용
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2348-1864&t=MxUj4cCr1Lu8U3oK-4

3."채팅 상세 목록 헤더" 컴포넌트
- 채팅방 상세보기 화면에서만 사용
  - 해당 채팅방의 모임이름, 인원수 표시
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2401-2648&t=MxUj4cCr1Lu8U3oK-4

### 헤더요소
- "back_arrow 1", "textlogo 1", "globe 1" 컴포넌트를 활용해 헤더를 만든다.

### 기능
- "back_arrow 1"를 클릭시 뒤로가기를 지원한다.
- "globe 1"를 클릭시 "한/중/영/일" 다국어 uiux전환을 지원한다. 이는 팝업이 뜨며, 팝업에서 드롭다운 형태로 언어를 변경할 수 있도록 한다. 
- globe 기반 다국어 전환은 후속 개발 범위로 두고, 현재 단계에서는 공통 헤더 구조만 먼저 적용한다.
- plus를 제외하곤 해당 화면에 있을 땐 activated, 그렇지 않을 땐 deactivated 상태이다.

## bottom
기본적으로 "bottom_home" 컴포넌트의 모양이다
하단에 home, explore, plus, chat, profile이 존재한다.

## 요소
- home: "home_activated 1" 컴포넌트
- explore: "explore_activated 1"
- plus: "plus_btn 1"
- chat: "chat_deactivated 1"
- profile: profile_deactivated 1

### 기능
각 화면이 아직 구성되지 않았을것이므로, 임시로 마련해둔다.
- home을 누를 경우 "A.홈화면"으로 이동한다.
  - 참고 url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-2076&t=MxUj4cCr1Lu8U3oK-4
- explore를 누를 경우 "B.둘러보기 화면"으로 이동한다.
  - 참고 url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-2077&t=MxUj4cCr1Lu8U3oK-4
- plus를 누를 경우 조건이 2가지이다.
  - 일반 유저인 경우: "C-1.모임 생성화면"으로 이동한다.
  - 사업자 유저인 경우:"E.클래스 등록 화면"으로 이동한다.
- chat: "G.채팅방 목록"으로 이동한다.
  - 참고 url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-2095&t=MxUj4cCr1Lu8U3oK-4
- profile을 누를 경우 "I-1.마이페이지"으로 이동한다.
  - 참고 url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-2013&t=MxUj4cCr1Lu8U3oK-4
