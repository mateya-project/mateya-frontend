import 'package:flutter_test/flutter_test.dart';
import 'package:mateya_app/app/flow_kind_resolver.dart';
import 'package:mateya_app/features/onboarding/domain/onboarding_flow.dart';
import 'package:mateya_app/shared/network/mateya_api_client.dart';

void main() {
  group('resolveFlowKind', () {
    test('promotes guest to host when host probe succeeds', () async {
      final resolution = await resolveFlowKind(
        currentRole: 'USER',
        probeHostAccess: () async {},
      );

      expect(resolution.flowKind, FlowKind.host);
      expect(resolution.updatedRole, 'BUSINESS');
      expect(resolution.probeFailedWithNetwork, isFalse);
    });

    test(
      'demotes stale host role to guest when host probe returns validation',
      () async {
        final resolution = await resolveFlowKind(
          currentRole: 'BUSINESS',
          probeHostAccess: () async {
            throw const MateyaApiException(
              type: ApiFailureType.validation,
              message: '사업자 접수 정보가 없습니다.',
              statusCode: 400,
              path: '/api/v1/hosts/me',
            );
          },
        );

        expect(resolution.flowKind, FlowKind.guest);
        expect(resolution.updatedRole, 'USER');
        expect(resolution.probeFailedWithNetwork, isFalse);
      },
    );

    test('keeps host flow when host probe fails only by network', () async {
      final resolution = await resolveFlowKind(
        currentRole: 'HOST',
        probeHostAccess: () async {
          throw const MateyaApiException(
            type: ApiFailureType.network,
            message: 'network error',
            path: '/api/v1/hosts/me',
          );
        },
      );

      expect(resolution.flowKind, FlowKind.host);
      expect(resolution.updatedRole, isNull);
      expect(resolution.probeFailedWithNetwork, isTrue);
    });
  });

  group('isHostRole', () {
    test('matches business and host roles', () {
      expect(isHostRole('BUSINESS'), isTrue);
      expect(isHostRole('host'), isTrue);
      expect(isHostRole('USER'), isFalse);
      expect(isHostRole(null), isFalse);
    });
  });
}
