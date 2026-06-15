## 메인 화면
mateya어플의 개발 명세서이다. 자세히 언급되지않은 부분은 질문하거나, 실무적으로 적절한 방안으로 처리 후 사용자에게 해당 사항을 보고한다.

섹션 url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-723&t=MxUj4cCr1Lu8U3oK-4

## 공통지침 - 1
모든 API 요청은 아래 상태를 고려한다.

- Loading
- Success
- Validation Error
- Network Error
- Server Error(5xx)
에러 발생 시 토스트 또는 입력_에러 컴포넌트를 활용한다.

## 공통지침 - 2
- 기존 컴포넌트와 스타일 토큰을 먼저 찾아서 재사용하고,
없을 때만 새 컴포넌트를 만들어줘.
- 반응형은 iPhone 16 Pro 기준 모바일 우선으로 맞춰줘.
- 입력창에대한 에러가 발생했을 경우, "입력_에러" 컴포넌트를 활용하는 방안으로 한다.
  - 예시: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2400-2630&t=MxUj4cCr1Lu8U3oK-4
  - Error color와 Error icon을 활용한다.
- 버튼이 비활성화 되어있으면 "버튼_비활성화"컴포넌트를 활용하는 방안으로 한다.
- 입력 필드는 unfocused일 때는 외곽선이 "iconbackground"이고, focused이면 "black"색상이다.
- 상황별로 실무적으로 적절한 애니메이션, 화면전화를 넣고 사용자에게 해당 사항을 보고한다.


## A.홈화면
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-1406&t=MxUj4cCr1Lu8U3oK-11
### 기능
- 상단에 검색창에서 이름, 장소를 기준으로 검색가능하다.
  - 검색 할 경우 "B.둘러보기 화면"으로 넘어간다. 
  - 검색창에 대한 더 자세한 설명은 "B.둘러보기 화면"의 기능에서 이어서 설명한다.
- 아래에는 최고인기 게시물 1개가 나온다.
- 그 아래에는 인기게시물 3개가 나온다.
- 각 게시물은 클릭해서 상세보기로 넘어갈 수 있다. "D-1.자세히보기 화면"인데, 아직 구현되지 않았다.
- 각 개별요소에 대해 카테고리, 대표사진, 활동명, 참여인원, 날짜, 시각 및 시간, 리뷰평점이 제공된다.

## B.둘러보기 화면
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-1407&t=MxUj4cCr1Lu8U3oK-11
### 기능
- 상단에 검색창에서 이름, 장소를 기준으로 검색가능하다.
- 검색창 하단에서 카테고리를 선택할 수 있다. 카테고리 목록은 아래와 같다. 
  - 전통문화
  - 스포츠/액티비티
  - 지역축제
  - 음식체험
  - 언어교환
  - 관광/산책
  - 공예
  - 기타
- 검색결과가 페이지네이션으로 제공된다. 페이지네이션 기본 단위는 10개로 한다. 
- 각 개별요소에 대해 카테고리, 대표사진, 활동명, 참여인원, 날짜, 시각 및 시간, 리뷰평점이 제공된다.
- 검색창 우측의 필터를 누르면 "B.둘러보기 화면-필터"가 팝업으로 화면에 나온다.

## B.둘러보기 화면-필터
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2408-2357&t=MxUj4cCr1Lu8U3oK-11
### 기능 
검색에 대한 필터를 제공한다. 필터는 아래에 나열된 것과 같다.
1.정렬
- 필수선택
- 택 1 가능
- 기본: 추천순
- 이외에 인기순, 최신순, 마감임박순, 가까운 거리순
2. 카테고리
- 전체를 누를경우 택 1, 혹은 여러개 선택 가능
- 최소 1개 필수 선택
- 기본: 전체
- 이외 전통문화, 스포츠·액티비티, 지역축제, 음식체험, 언어교환, 관광·산책, 공예, 기타
3.참가대상
- 필수선택
- 기본: 누구나
- 여러개 선택가능
4.언어
- 필수선택
- 기본: 사용자 프로필의 모국어
- 여러개 선택가능
- "+ 24개 언어 더보기"버튼을 눌러 언어 체크박스 더 로딩 가능
5.지역
- 필수 선택
- 기본: 제일 좌측
- 슬라이드 바 형식. 왼쪽이 내지역 -> 오른쪽이 먼 지역
  - 내 지역(0km),1km 이내, 5km 이내, 10km 이내 존재
  -"https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2385-2465&t=MxUj4cCr1Lu8U3oK-11" 처럼 0,1,5,10에 대해 툴팁 띄워짐
6.일정
- 선택 입력
- 시작 범위 날짜
- 종료 범위 날짜
7.비용
- 선택 입력, 하나만 입력도 가능
- 최소 금액, 최대금액 필드 존재
8.모집 상태
- 모집중, 곧 마감, 신규 등록 존재 
- 필수 선택 아님
- 여러개선택가능

### 기능 2
- 좌측 하단 초기화 버튼존재. 필터 기본값으로 초기화
- 적용하기 버튼 누를시 팝업 닫히며 "B.둘러보기 화면"에서 검색 결과 보여줌.
