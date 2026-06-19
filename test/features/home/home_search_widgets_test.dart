import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/features/home/presentation/widgets/home_search_widgets.dart';

void main() {
  testWidgets('search placeholder and helper disappear on focus', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeSearchBar(
            controller: controller,
            focusNode: focusNode,
            hintText: '이름, 장소를 검색해 보세요',
            helperText: '누구와도 메이트가 되는 곳, 메이트야',
            onFilterTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('이름, 장소를 검색해 보세요'), findsOneWidget);
    expect(find.text('누구와도 메이트가 되는 곳, 메이트야'), findsOneWidget);

    focusNode.requestFocus();
    await tester.pump();

    expect(find.text('이름, 장소를 검색해 보세요'), findsNothing);
    expect(find.text('누구와도 메이트가 되는 곳, 메이트야'), findsNothing);
  });
}
