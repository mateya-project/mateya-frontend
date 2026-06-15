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
- 온보딩에서 입력창에대한 에러가 발생했을 경우, "입력_에러" 컴포넌트를 활용하는 방안으로 한다.
- 버튼이 비활성화 되어있으면 "버튼_비활성화"컴포넌트를 활용하는 방안으로 한다.
- 입력 필드는 unfocused일 때는 외곽선이 "iconbackground"이고, focused이면 "black"색상이다.
- 상황별로 실무적으로 적절한 애니메이션, 화면전화를 넣고 사용자에게 해당 사항을 보고한다.