import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/chat/domain/chat_models.dart';
import 'package:mateya_app/features/chat/presentation/widgets/chat_message_widgets.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';

void main() {
  testWidgets('IncomingGroup shows translation toggle labels', (tester) async {
    Widget buildSubject(ChatMessageGroup group) {
      return MaterialApp(
        theme: buildMateyaTheme(),
        locale: const Locale('ko'),
        supportedLocales: MateyaLocalizations.supportedLocales,
        localizationsDelegates: MateyaLocalizations.delegates,
        home: Scaffold(
          body: IncomingGroup(group: group, onToggleTranslation: () {}),
        ),
      );
    }

    await tester.pumpWidget(
      buildSubject(
        ChatMessageGroup(
          id: 'translated',
          sender: const ChatParticipant(id: 'user-1', name: 'Ji-Won'),
          sentAt: DateTime(2026, 6, 20, 13, 40),
          bubbles: const <ChatBubble>[
            ChatBubble(
              originalText: '가나다라마바사',
              translatedText: 'See you all at the palace gate.',
            ),
          ],
        ),
      ),
    );

    expect(find.text('번역 보기'), findsOneWidget);

    await tester.pumpWidget(
      buildSubject(
        ChatMessageGroup(
          id: 'original',
          sender: const ChatParticipant(id: 'user-1', name: 'Ji-Won'),
          sentAt: DateTime(2026, 6, 20, 13, 42),
          isTranslatedVisible: true,
          bubbles: const <ChatBubble>[
            ChatBubble(
              originalText: '가나다라마바사',
              translatedText: 'See you all at the palace gate.',
            ),
          ],
        ),
      ),
    );

    expect(find.text('원문 보기'), findsOneWidget);
  });
}
