import '../features/onboarding/domain/onboarding_flow.dart';
import '../shared/network/mateya_api_client.dart';

typedef HostAccessProbe = Future<void> Function();

class FlowKindResolution {
  const FlowKindResolution({
    required this.flowKind,
    this.updatedRole,
    this.probeFailedWithNetwork = false,
  });

  final FlowKind flowKind;
  final String? updatedRole;
  final bool probeFailedWithNetwork;
}

bool isHostRole(String? role) {
  final normalizedRole = role?.trim().toUpperCase() ?? '';
  return normalizedRole == 'BUSINESS' || normalizedRole == 'HOST';
}

Future<FlowKindResolution> resolveFlowKind({
  required String? currentRole,
  required HostAccessProbe probeHostAccess,
}) async {
  final hasHostRole = isHostRole(currentRole);

  try {
    await probeHostAccess();
    return FlowKindResolution(
      flowKind: FlowKind.host,
      updatedRole: hasHostRole ? null : 'BUSINESS',
    );
  } on MateyaApiException catch (error) {
    if (error.type == ApiFailureType.network) {
      return FlowKindResolution(
        flowKind: hasHostRole ? FlowKind.host : FlowKind.guest,
        probeFailedWithNetwork: true,
      );
    }

    return FlowKindResolution(
      flowKind: FlowKind.guest,
      updatedRole: hasHostRole ? 'USER' : null,
    );
  }
}
