# 등록화면
mateya어플의 개발 명세서이다. 자세히 언급되지않은 부분은 질문하거나, 실무적으로 적절한 방안으로 처리 후 사용자에게 해당 사항을 보고한다.

## 공통지침 
- 기존 컴포넌트와 스타일 토큰을 먼저 찾아서 재사용하고,
없을 때만 새 컴포넌트를 만들어줘.
- 반응형은 iPhone 16 Pro 기준 모바일 우선으로 맞춰줘.
- 온보딩에서 입력창에대한 에러가 발생했을 경우, "입력_에러" 컴포넌트를 활용하는 방안으로 한다.
- 버튼이 비활성화 되어있으면 "버튼_비활성화"컴포넌트를 활용하는 방안으로 한다.
- 입력 필드는 unfocused일 때는 외곽선이 "iconbackground"이고, focused이면 "black"색상이다.
- 상황별로 실무적으로 적절한 애니메이션, 화면전화를 넣고 사용자에게 해당 사항을 보고한다.

## J.시작화면
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-548&t=MxUj4cCr1Lu8U3oK-4
### 기능
처음 접속하면 보이는 화면이다. "가운데로고"는 어플 시작시 fade in 된다.
- 일반 유저의 경우 하단 시작하기를 누르면 K-0. 개인정보 동의로 넘어간다.
- 호스트유저의 경우 호스트로 시작하기를 누르면 N-0.사업자 인증 화면-개인정보동의 화면으로 넘어간다.

## K-0. 개인정보 동의
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2341-1224&t=MxUj4cCr1Lu8U3oK-4
### 기능
K-1.인적사항 입력화면 위에 어두워진 후 개인정보 입력을 요하는 화면이 아래에서 위로 올라온다.
개인정보 약관 동의를 요구하는 화면이다.
- 맨 위 모두동의 체크박스를 클릭/해제하면 아래 체크박스 옵션이 모두 클릭/해제가 된다. 
- 아래 약관는 모두 각각 클릭/해제 가능하다.
- 모두 동의를 선택해야 다음으로 버튼이 클릭 가능해진다.
- 동의를 모두 선택하기 전까지 하단 버튼은 "다음으로 버튼_비활성화"컴포넌트 상태이다.
- 다음 버튼을 누르면 "K-1.인적사항 입력"화면으로 넘어간다.

## K-1.인적사항 입력
인적사항을 입력하기 시작하는 화면이다.
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-580&t=MxUj4cCr1Lu8U3oK-4
### 기능 
먼저 이름을 입력한다. 
- 이름은 문자열으로 30자 내여야한다.
- 특수문자, 숫자를 포함할 수 없다.
- 이름을 입력하면 다음으로 버튼이 활성화된다.
- 이름을 입력하기 전까지 하단 버튼은 "다음으로 버튼_비활성화"컴포넌트 상태이다.
- 이름 형식을 틀린채로 다음을 누르거나 unfocused되면 "이름입력_에러"컴포넌트로 이름입력창이 바뀐다.
- 다음 버튼을 누르면 "K-2.전화번호 입력 화면"화면으로 넘어간다.

## K-2.전화번호 입력 화면
전화번호를 통해 sms인증을 하는 화면이다
- url:
https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-714&t=MxUj4cCr1Lu8U3oK-4


### 기능
- 해당화면에서 통신사 드롭다운영역을 선택하는경우 "K-2.전화번호 입력 화면- 통산사 선택"화면으로  이어진다.
- 전화번호 입력은 국가번호 입력과 전화번호 입력 두 필드로 나뉜다.
  - 국가번호 입력시 국가번호를 입력하는 드롭다운이 나온다.
  - 전화번호는 숫자 형식으로 최대 15자 여야한다.
- 통신사, 전화번호를 모두 입력하면 인증번호 받기 버튼이 활성화된다. 
- 인증번호 받기를 누르면 "K-3. 인증번호 입력화면"으로 넘어간다.

## K-2.전화번호 입력 화면- 통산사 선택
- 통신사 선택 드롭다운의 화면을 보여주는 화면이다.
- 6개의 필드중 하나를 선택시, 해당 요소가 선택된다.
- 클릭하는 순간 요소의 background color가 회색으로 포인트 된다.
- url:https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2345-4329&t=MxUj4cCr1Lu8U3oK-4

## K-3. 인증번호 입력화면
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2341-1050&t=MxUj4cCr1Lu8U3oK-4

### 기능
- 상단 통신사, 전화번호 필드는 이전 화면에서 입력한 값이 유지되어 있고 수정 불가능하다.
- 인증번호는 숫자로 된 랜덤 6자이며, 백엔드에서 받아온 값과 일치해야한다.
  - 일치하지않을 경우 "K-3. 인증번호 입력화면 - 인증번호 틀림" 화면처럼 경고메시지가 안내된다.
- 인증번호는 5분 안에 입력해야하며, "하단안내-제한시간-남은시간"이 5분 제한시간을 나타내고있다. 형식은 "05:00"이다.
- 오른쪽 아래에 "인증번호 다시받기"를 통해 인증번호를 다시받을 수 있으며, 하루 최대 5번까지 가능하다.
- 인증번호를 6자 입력하면 "인증하기"버튼이 활성화되며, 이를 누르면 "M-1.동네 인증 화면 자동"화면으로 넘어간다.

## K-3. 인증번호 입력화면 - 인증번호 틀림
"K-3. 인증번호 입력화면"화면에서 인증번호가 틀렸을경우 나타나는 화면이다.
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2344-4285&t=MxUj4cCr1Lu8U3oK-4

## M-1.동네 인증 화면 자동
사용자가 동네 정보를 인증하는 화면이다.
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-716&t=MxUj4cCr1Lu8U3oK-4

### 기능
- 텍스트 "동내 안내 메시지"는 "현재 위치가 “우만동"에 있어요."와 같은 형태이다. 여기서 "우만동"은 사용자가 인증한 위치정보이다.
- 필요시 naver credentials를 사용한다. 해당 내용은 `.agents/credentials.md`에 있다.
- "네이버지도 화면"에는 네이버지도 sdk로 받아온 화면이 보인다. 
- 사용자 정보는 00구 00동까지만 확정되면 된다.
- 동네가 확정되면 "동네인증 자동 - 클릭시 가입 완료"버튼이 활성화된다. 이를 누르면 "M-3 가입완료"화면으로 넘어간다.
- 만약 인증이 되지않는 사용자는, "하단 수동인증 버튼"을 클릭하여 "M-2.동네 인증 화면 수동"화면으로 넘어가 수동인증을 할 수 있다.

## M-2.동네 인증 화면 수동
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2341-1118&t=MxUj4cCr1Lu8U3oK-4
### 기능:
- 사용자가 00시 00동 또는 00동을 "입력필드"에 입력한다. 
  - 해당 정보에 따라 "네이버지도 화면"에 네이버 지도 sdk로 받아온 정보가 표시된다.
- 동네가 확정되면 "동네인증 자동 - 클릭시 가입 완료"버튼이 활성화된다. 이를 누르면 "M-3 가입완료"화면으로 넘어간다.

## M-3 가입완료
- url: https://www.figma.com/design/BqIBscM2a1oAFrIuF8lqvK/Potfolio-Template--%EC%9D%B4%EB%A0%A5%EC%84%9C-%ED%8F%AC%ED%8A%B8%ED%8F%B4%EB%A6%AC%EC%98%A4-%ED%85%9C%ED%94%8C%EB%A6%BF---Community-?node-id=2339-717&t=MxUj4cCr1Lu8U3oK-4
### 기능
- "가입안내메시지"에 "000님
메이트야 가입을 완료했어요"과 같은 정보가 나온다.
- 여기서 000님의 000은 "K-1.인적사항 입력"화면에서 입력한 이름이다.
- 하단 "모든 유저 시작하기 버튼 - 클릭시 홈화면"는 항상 활성화되어 있으며, 이를 클릭할 경우 "메인화면-A.홈화면"으로 넘어간다. 이 화면은 추후 구현 예정이다.
