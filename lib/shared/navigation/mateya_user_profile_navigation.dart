import 'package:flutter/material.dart';

import '../../features/mypage/application/mypage_controller.dart';
import '../../features/mypage/data/mypage_repository.dart';
import '../../features/mypage/presentation/screens/mypage_flow_page.dart';
import '../../features/onboarding/domain/onboarding_flow.dart';
import '../auth/auth_session.dart';
import 'mateya_auth_flow.dart';

bool _isHostRole(String? role) {
  final normalizedRole = role?.trim().toUpperCase() ?? '';
  return normalizedRole == 'BUSINESS' || normalizedRole == 'HOST';
}

Future<void> openMateyaUserProfile(BuildContext context, String userId) async {
  if (userId.isEmpty) {
    return;
  }
  final session = AuthSessionStore.instance.session;
  final currentUserId = session?.user.id.toString();
  final isHostFlow = _isHostRole(session?.user.role);
  final hasSession = AuthSessionStore.instance.hasSession;
  if (!hasSession) {
    await replaceWithMateyaOnboardingFlow(context);
    return;
  }

  if (currentUserId != null && currentUserId == userId) {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MyPageFlowPage(
          controller: MyPageController(
            repository: ApiMyPageRepository(),
            flowKind: isHostFlow ? FlowKind.host : FlowKind.guest,
          ),
          onRootBack: () => Navigator.of(context).pop(),
        ),
      ),
    );
    return;
  }

  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => MyPageFlowPage(
        controller: MyPageController(
          repository: ApiMyPageRepository(),
          flowKind: FlowKind.guest,
          initialOtherProfileUserId: userId,
        ),
        onRootBack: () => Navigator.of(context).pop(),
      ),
    ),
  );
}
