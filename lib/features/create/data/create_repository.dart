import 'dart:io';

import 'package:flutter/material.dart';

import '../../../app/app_config.dart';
import '../../../shared/auth/auth_session.dart';
import '../../../shared/network/http_transport.dart';
import '../../../shared/network/mateya_api_client.dart';
import '../domain/create_models.dart';

part 'create_repository_api.dart';
part 'create_repository_mock.dart';
part 'create_repository_api_support.dart';
part 'create_repository_mock_support.dart';

abstract interface class CreateRepository {
  Future<CreateEditableDraft> fetchEditableDraft({
    required String id,
    required CreateFlowType flowType,
  });

  Future<List<CreatePlaceSuggestion>> fetchRecommendedPlaces({
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
    String? categoryDetailCode,
  });

  Future<List<CreatePlaceSuggestion>> searchPlaces({
    required String query,
    required CreateFlowType flowType,
    Set<String> categoryIds = const <String>{},
    String? categoryDetailCode,
  });

  Future<CreateSubmitResult> submit(
    CreateSubmissionDraft draft, {
    String? editingId,
  });

  Future<void> delete({required String id, required CreateFlowType flowType});
}

enum CreateRepositoryFailureType { network, server }

class CreateRepositoryException implements Exception {
  const CreateRepositoryException(this.type, {this.message});

  final CreateRepositoryFailureType type;
  final String? message;
}
