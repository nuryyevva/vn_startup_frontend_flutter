import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'error_mapper.freezed.dart';

/// Every failure mode the app's UI actually needs to branch on. Built by
/// [mapDioException] from the backend's `{"error":{"code","message"}}`
/// envelope — screens should switch on this, never inspect a raw
/// [DioException] or show `error.message` from the backend directly for
/// codes that have a typed, localized variant here.
@freezed
sealed class AppException with _$AppException implements Exception {
  const factory AppException.invalidCredentials() = InvalidCredentialsException;
  const factory AppException.emailTaken() = EmailTakenException;
  const factory AppException.invalidEmail() = InvalidEmailException;
  const factory AppException.weakPassword() = WeakPasswordException;
  const factory AppException.sessionExpired() = SessionExpiredException;
  const factory AppException.insufficientDiamonds() = InsufficientDiamondsException;
  const factory AppException.topUpUnavailable() = TopUpUnavailableException;
  const factory AppException.sessionLimitReached() = SessionLimitReachedException;
  const factory AppException.sceneLocked() = SceneLockedException;
  const factory AppException.notFound() = NotFoundException;
  const factory AppException.rateLimited() = RateLimitedException;
  const factory AppException.networkError() = NetworkErrorException;
  const factory AppException.validation(String rawMessage) = ValidationException;
  const factory AppException.unknown(String? code, String rawMessage) = UnknownException;
}

extension AppExceptionLocalization on AppException {
  /// A user-safe, localized message. For codes the backend doesn't have a
  /// typed variant for, falls back to the backend's own `message` field
  /// (still shown to the user, since it's meant to be human-readable) —
  /// only truly unrecognized failures fall back to a generic string.
  String localizedMessage() {
    return switch (this) {
      InvalidCredentialsException() => 'errors.invalidCredentials'.tr(),
      EmailTakenException() => 'errors.emailTaken'.tr(),
      InvalidEmailException() => 'errors.invalidEmail'.tr(),
      WeakPasswordException() => 'errors.weakPassword'.tr(),
      SessionExpiredException() => 'errors.sessionExpired'.tr(),
      InsufficientDiamondsException() => 'errors.insufficientDiamonds'.tr(),
      TopUpUnavailableException() => 'shop.comingSoon'.tr(),
      SessionLimitReachedException() => 'errors.sessionLimitReached'.tr(),
      SceneLockedException() => 'errors.insufficientDiamonds'.tr(),
      NotFoundException() => 'errors.unknownError'.tr(),
      RateLimitedException() => 'errors.unknownError'.tr(),
      NetworkErrorException() => 'errors.networkError'.tr(),
      ValidationException(:final rawMessage) => rawMessage,
      UnknownException(:final rawMessage) => rawMessage,
    };
  }
}

const _validationCodes = {
  'invalid_body',
  'missing_fields',
  'invalid_session_id',
  'empty_message',
  'message_too_long',
  'invalid_story_id',
  'invalid_scene_id',
  'missing_choice_id',
  'choice_not_in_scene',
  'invalid_amount',
  'scene_not_locked',
  'free_dialog_disabled',
};

const _sessionExpiredCodes = {
  'token_expired',
  'invalid_token',
  'invalid_refresh_token',
  'missing_token',
  'missing_refresh_token',
};

const _notFoundCodes = {'story_not_found', 'scene_not_found', 'choice_not_found', 'profile_not_found', 'session_not_found'};

const _sessionLimitCodes = {'session_ended', 'session_not_active'};

AppException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionError:
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return const AppException.networkError();
    default:
      break;
  }

  final data = error.response?.data;
  String? code;
  String? message;
  if (data is Map<String, dynamic>) {
    final errorObj = data['error'];
    if (errorObj is Map<String, dynamic>) {
      code = errorObj['code'] as String?;
      message = errorObj['message'] as String?;
    }
  }

  if (code == null) {
    return AppException.unknown(null, message ?? 'errors.unknownError'.tr());
  }

  if (code == 'invalid_credentials') return const AppException.invalidCredentials();
  if (code == 'email_taken') return const AppException.emailTaken();
  if (code == 'invalid_email') return const AppException.invalidEmail();
  if (code == 'weak_password') return const AppException.weakPassword();
  if (code == 'insufficient_funds') return const AppException.insufficientDiamonds();
  if (code == 'top_up_unavailable') return const AppException.topUpUnavailable();
  if (code == 'scene_locked') return const AppException.sceneLocked();
  if (code == 'rate_limited') return const AppException.rateLimited();
  if (_sessionExpiredCodes.contains(code)) return const AppException.sessionExpired();
  if (_sessionLimitCodes.contains(code)) return const AppException.sessionLimitReached();
  if (_notFoundCodes.contains(code)) return const AppException.notFound();
  if (_validationCodes.contains(code)) return AppException.validation(message ?? code);

  return AppException.unknown(code, message ?? 'errors.unknownError'.tr());
}
