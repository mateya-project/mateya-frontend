## MCP 개발 지침

### 컴포넌트 우선 원칙
- 새로운 UI를 구현하기 전에 Figma 내 기존 컴포넌트를 우선 탐색한다.
- 동일하거나 유사한 컴포넌트가 존재할 경우 반드시 재사용한다.
- 새로운 컴포넌트 생성은 기존 컴포넌트로 구현이 불가능한 경우에만 허용한다.

### 스타일 토큰 사용
- 색상, 텍스트 스타일, Radius, Shadow, Spacing은 반드시 Figma Variables 또는 Style Token을 우선 사용한다.
- Hex 값을 직접 하드코딩하지 않는다.
- Font Size, Weight, Line Height도 Figma 스타일 기준으로 적용한다.

### Auto Layout
- Auto Layout 구조를 최대한 유지하여 구현한다.
- Absolute Position은 디자인상 필수인 경우만 사용한다.
- Fixed Width / Fixed Height 여부를 확인하고 그대로 반영한다.
- Hug / Fill Container 설정을 확인하고 동일하게 구현한다.

### 컴포넌트 Variant
- Variant가 존재하는 경우 상태별 Variant를 사용한다.
- 별도 컴포넌트를 중복 생성하지 않는다.

예시
- Button / Enabled
- Button / Disabled
- Button / Loading

### 아이콘
- Figma에 존재하는 SVG를 우선 사용한다.
- 동일 아이콘을 새로 생성하지 않는다.

### 이미지
- 디자인용 더미 이미지는 Placeholder 처리한다.
- 이미지 URL은 임시값으로 구현한다.
- 실제 API 연동 시 교체 가능하도록 구현한다.

### 레이아웃
- 모바일 기준 구현한다.
- iPhone 16 Pro Frame 기준으로 작업한다.
- Safe Area를 고려한다.

### 네이밍
- Figma Layer명을 기반으로 Widget명을 생성한다.
- 의미 없는 이름(Container1, Frame23) 생성 금지

예시
ActivityCard
SearchBar
CategoryChip
FilterBottomSheet

### 상태 처리
모든 API 호출은 아래 상태를 고려한다.

- Loading
- Empty
- Success
- Validation Error
- Network Error
- Server Error

Loading 상태 UI가 존재하지 않으면 Skeleton UI를 생성한다.

### 네비게이션
명세에 명시된 화면 이동은 반드시 구현한다.

예시
홈 검색창 클릭
→ 둘러보기 화면

필터 버튼 클릭
→ 필터 Bottom Sheet

활동 카드 클릭
→ 활동 상세

### API
API 명세가 없는 경우 Mock Repository를 생성한다.

금지사항
- API 응답 구조 추측 금지
- 임의 필드 생성 금지

### 구현 전 확인
구현 시작 전 아래 순서로 진행한다.

1. Figma 컴포넌트 탐색
2. Figma 스타일 토큰 탐색
3. 기존 Variant 확인
4. 재사용 가능한 화면 확인
5. 구현 시작

### 구현 완료 후 보고
반드시 아래 내용을 보고한다.

- 재사용한 컴포넌트 목록
- 새로 생성한 컴포넌트 목록
- 새로 생성한 스타일 목록
- 명세에 없어 임의로 결정한 사항
- 구현하지 못한 항목

### MCP 주의사항

Frame 내부 Layer를 임의로 재구성하지 않는다.

Figma에 존재하는
- Auto Layout
- Component
- Variant
- Variable
- Style Token

구조를 최대한 유지하며 구현한다.

새로운 디자인을 창작하지 말고,
현재 Figma 디자인 시스템을 기반으로 구현하는 것을 우선한다.

## 명심
추가로 명세되지않은 사항은 실무적으로 적절하게 구현 후 사용자에게 보고한다.

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