enum OnboardingTermsType {
  serviceTerms('SERVICE_TERMS'),
  privacyThirdParty('PRIVACY_THIRD_PARTY'),
  locationBasedService('LOCATION_BASED_SERVICE'),
  ageOver14('AGE_OVER_14');

  const OnboardingTermsType(this.apiType);

  final String apiType;
}

class OnboardingTermsSection {
  const OnboardingTermsSection({required this.title, required this.body});

  final String title;
  final String body;
}

class OnboardingTermsDocument {
  const OnboardingTermsDocument({
    required this.type,
    required this.title,
    required this.summary,
    required this.sections,
  });

  final OnboardingTermsType type;
  final String title;
  final String summary;
  final List<OnboardingTermsSection> sections;
}

const List<OnboardingTermsDocument>
kRequiredOnboardingTermsDocuments = <OnboardingTermsDocument>[
  OnboardingTermsDocument(
    type: OnboardingTermsType.serviceTerms,
    title: '서비스 이용 약관',
    summary: '메이트야 서비스 이용을 위한 기본 조건, 이용자 책임, 서비스 운영 기준을 안내합니다.',
    sections: <OnboardingTermsSection>[
      OnboardingTermsSection(
        title: '서비스 목적',
        body:
            '메이트야는 국내 사용자와 외국인이 모임, 클래스, 지역 기반 활동을 안전하게 탐색하고 참여할 수 있도록 연결하는 플랫폼입니다.',
      ),
      OnboardingTermsSection(
        title: '회원가입 및 계정 관리',
        body:
            '회원은 본인 명의의 정보로 가입해야 하며, 휴대전화 인증과 약관 동의를 완료해야 서비스를 이용할 수 있습니다. 계정 정보가 변경되면 최신 상태로 유지해야 합니다.',
      ),
      OnboardingTermsSection(
        title: '서비스 이용 조건',
        body:
            '회원은 관련 법령과 본 약관을 준수해야 하며, 타인의 권리를 침해하거나 서비스 운영을 방해하는 행위를 해서는 안 됩니다. 일부 기능은 본인 확인이나 추가 인증이 필요할 수 있습니다.',
      ),
      OnboardingTermsSection(
        title: '금지 행위',
        body:
            '허위 정보 등록, 타인 사칭, 불법 홍보, 음란물 또는 혐오 표현 게시, 비정상적인 자동화 접근, 운영 정책 우회를 위한 시도는 금지됩니다. 위반 시 게시물 삭제, 이용 제한, 계정 정지 조치가 이루어질 수 있습니다.',
      ),
      OnboardingTermsSection(
        title: '서비스 중단 및 변경',
        body:
            '메이트야는 점검, 장애 대응, 정책 변경 또는 외부 제휴 사정에 따라 서비스 일부를 변경하거나 일시 중단할 수 있습니다. 중요한 변경은 앱 내 공지 또는 적절한 수단으로 안내합니다.',
      ),
      OnboardingTermsSection(
        title: '책임 제한',
        body:
            '메이트야는 천재지변, 통신 장애, 이용자 귀책 사유로 발생한 손해에 대해 법령이 허용하는 범위에서 책임을 제한할 수 있습니다. 다만 회사의 고의 또는 중대한 과실이 있는 경우에는 예외로 합니다.',
      ),
      OnboardingTermsSection(
        title: '문의처',
        body:
            '서비스 이용 중 문의가 필요하면 앱 내 고객지원 채널 또는 운영팀 이메일을 통해 접수할 수 있으며, 접수된 내용은 운영 정책에 따라 순차적으로 처리됩니다.',
      ),
    ],
  ),
  OnboardingTermsDocument(
    type: OnboardingTermsType.privacyThirdParty,
    title: '개인정보 제3자 제공 동의',
    summary: '활동 운영, 예약 진행, 고객 응대에 필요한 범위에서 개인정보가 제3자에게 제공되는 기준을 설명합니다.',
    sections: <OnboardingTermsSection>[
      OnboardingTermsSection(
        title: '제공받는 자',
        body: '메이트야 내 모임/클래스를 운영하는 호스트 또는 서비스 운영에 필요한 제휴 사업자',
      ),
      OnboardingTermsSection(
        title: '제공 목적',
        body: '참여 신청 확인, 호스트와의 원활한 일정 조율, 현장 운영 지원, 고객 문의 대응 및 분쟁 처리',
      ),
      OnboardingTermsSection(
        title: '제공 항목',
        body: '이름, 휴대전화 번호, 활동 신청 정보, 대표 언어, 참여 이력 중 서비스 제공에 필요한 최소 항목',
      ),
      OnboardingTermsSection(
        title: '보유 및 이용 기간',
        body:
            '제공 목적 달성 시까지 또는 관련 법령상 보존 의무 기간까지 보관되며, 이후에는 지체 없이 삭제하거나 익명화합니다.',
      ),
      OnboardingTermsSection(
        title: '동의 거부 권리 및 불이익',
        body:
            '회원은 개인정보 제3자 제공 동의를 거부할 수 있습니다. 다만 활동 참여, 예약 확인, 호스트와의 연락이 필요한 일부 서비스 이용이 제한될 수 있습니다.',
      ),
    ],
  ),
  OnboardingTermsDocument(
    type: OnboardingTermsType.locationBasedService,
    title: '위치기반서비스 이용약관',
    summary: '현재 위치와 활동 지역 정보를 활용해 주변 모임과 추천 결과를 제공하는 방식 및 보호 기준을 안내합니다.',
    sections: <OnboardingTermsSection>[
      OnboardingTermsSection(
        title: '위치정보 수집 목적',
        body: '주변 활동 추천, 동네 인증, 거리 기반 정렬, 지역 맞춤형 콘텐츠 제공을 위해 위치정보를 수집할 수 있습니다.',
      ),
      OnboardingTermsSection(
        title: '위치정보 이용 범위',
        body:
            '수집된 위치정보는 회원이 요청한 기능 제공 범위 안에서만 사용되며, 광고 추적이나 무관한 목적으로 사용하지 않습니다.',
      ),
      OnboardingTermsSection(
        title: '위치정보 보관 기간',
        body:
            '즉시성 기능에 필요한 실시간 위치는 기능 처리 후 보관하지 않으며, 활동 지역 인증 결과는 서비스 운영상 필요한 기간 동안 계정 정보와 함께 관리됩니다.',
      ),
      OnboardingTermsSection(
        title: '위치정보 제3자 제공 여부',
        body: '회원의 별도 동의 또는 법령상 근거가 없는 한 개인 위치정보를 제3자에게 제공하지 않습니다.',
      ),
      OnboardingTermsSection(
        title: '동의 철회 방법',
        body:
            '회원은 단말기 설정에서 위치 권한을 변경하거나 앱 내 설정 변경을 통해 위치기반서비스 이용 동의를 철회할 수 있습니다. 철회 시 일부 추천 기능이 제한될 수 있습니다.',
      ),
      OnboardingTermsSection(
        title: '문의처 및 보호 책임',
        body:
            '위치정보 이용과 관련한 문의 또는 민원은 메이트야 고객지원 채널로 접수할 수 있으며, 회사는 관련 법령에 따라 위치정보 보호 책임 체계를 운영합니다.',
      ),
    ],
  ),
  OnboardingTermsDocument(
    type: OnboardingTermsType.ageOver14,
    title: '만 14세 이상 확인',
    summary: '메이트야 회원가입은 만 14세 이상만 가능하며, 연령 확인과 관련한 이용 제한 기준을 안내합니다.',
    sections: <OnboardingTermsSection>[
      OnboardingTermsSection(
        title: '연령 확인',
        body: '회원은 회원가입 시 본인이 만 14세 이상임을 확인하고 이에 동의해야 합니다.',
      ),
      OnboardingTermsSection(
        title: '가입 제한',
        body: '만 14세 미만 사용자는 메이트야 회원가입 및 서비스 이용이 제한됩니다.',
      ),
      OnboardingTermsSection(
        title: '허위 확인에 대한 조치',
        body:
            '연령을 허위로 확인하여 가입한 사실이 확인되면 서비스 이용 제한, 계정 해지 또는 필요한 추가 확인 절차가 진행될 수 있습니다.',
      ),
    ],
  ),
];

OnboardingTermsDocument onboardingTermsDocumentForType(
  OnboardingTermsType type,
) {
  return kRequiredOnboardingTermsDocuments.firstWhere(
    (document) => document.type == type,
  );
}
