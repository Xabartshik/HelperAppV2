import 'package:freezed_annotation/freezed_annotation.dart';
import '../user/mobile_app_user_dto.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

/// Ответ на авторизацию
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String accessToken,
    @Default('Bearer') String tokenType,
    required MobileAppUserDto user,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => 
      _$LoginResponseFromJson(json);
}
