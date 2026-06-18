import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/chat/presentation/widgets/chat_status_widgets.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';

void main() {
  testWidgets('ChatListGuidance renders the footer guidance copy', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildMateyaTheme(),
        home: const Scaffold(body: Center(child: ChatListGuidance())),
      ),
    );

    expect(find.byType(ChatListGuidance), findsOneWidget);

    final text = tester.widget<Text>(find.byType(Text));
    final message = text.data;

    expect(text.textAlign, TextAlign.center);
    expect(message, isNotNull);
    expect(message, contains('활동에 참여하면 자동으로 단체채팅방에 가입됩니다.'));
    expect(message, contains('개인 채팅은 친구인 유저와 자동으로 생성됩니다.'));
    expect(message, contains('친구가 아닌 유저와는 채팅할 수 없습니다.'));
  });
}
