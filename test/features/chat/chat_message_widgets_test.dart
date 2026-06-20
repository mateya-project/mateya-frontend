import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/chat/domain/chat_models.dart';
import 'package:mateya_app/features/chat/presentation/widgets/chat_message_widgets.dart';
import 'package:mateya_app/shared/localization/mateya_localizations.dart';
import 'package:mateya_app/shared/theme/app_theme.dart';
import 'package:mateya_app/shared/widgets/mateya_translation_toggle_button.dart';

Widget buildSubject(ChatMessageGroup group, {VoidCallback? onAvatarTap}) {
  return MaterialApp(
    theme: buildMateyaTheme(),
    locale: const Locale('ko'),
    supportedLocales: MateyaLocalizations.supportedLocales,
    localizationsDelegates: MateyaLocalizations.delegates,
    home: Scaffold(
      body: IncomingGroup(
        group: group,
        onToggleTranslation: () {},
        onAvatarTap: onAvatarTap,
      ),
    ),
  );
}

void main() {
  testWidgets('IncomingGroup shows translation toggle labels', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        ChatMessageGroup(
          id: 'translated',
          sender: const ChatParticipant(id: 'user-1', name: 'Ji-Won'),
          sentAt: DateTime(2026, 6, 20, 13, 40),
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
    expect(find.text('See you all at the palace gate.'), findsOneWidget);

    await tester.pumpWidget(
      buildSubject(
        ChatMessageGroup(
          id: 'original',
          sender: const ChatParticipant(id: 'user-1', name: 'Ji-Won'),
          sentAt: DateTime(2026, 6, 20, 13, 42),
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
    expect(find.text('가나다라마바사'), findsOneWidget);
  });

  testWidgets('IncomingGroup triggers avatar tap callback', (tester) async {
    var tapCount = 0;

    await tester.pumpWidget(
      buildSubject(
        ChatMessageGroup(
          id: 'profile',
          sender: const ChatParticipant(id: 'user-1', name: 'Ji-Won'),
          sentAt: DateTime(2026, 6, 20, 13, 40),
          bubbles: const <ChatBubble>[ChatBubble(originalText: '가나다라마바사')],
        ),
        onAvatarTap: () {
          tapCount += 1;
        },
      ),
    );

    await tester.tap(find.byType(InkWell).first);
    await tester.pump();

    expect(tapCount, 1);
  });

  testWidgets(
    'IncomingGroup aligns translation toggle with the incoming bubble edge',
    (tester) async {
      await tester.pumpWidget(
        buildSubject(
          ChatMessageGroup(
            id: 'aligned',
            sender: const ChatParticipant(id: 'user-1', name: 'Ji-Won'),
            sentAt: DateTime(2026, 6, 20, 13, 40),
            bubbles: const <ChatBubble>[
              ChatBubble(
                originalText: '안녕하세요 반갑습니다.',
                translatedText: 'Hello, nice to meet you.',
              ),
            ],
          ),
        ),
      );
      await tester.pump();

      final bubbleRect = tester.getRect(find.byType(IncomingBubble));
      final toggleRect = tester.getRect(
        find.byType(MateyaTranslationToggleButton),
      );

      expect(toggleRect.right, moreOrLessEquals(bubbleRect.right, epsilon: 1));
    },
  );
}
