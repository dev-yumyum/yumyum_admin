import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? userName;
  final String? userRole;

  AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.userName,
    this.userRole,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? userName,
    String? userRole,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userRole: userRole ?? this.userRole,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String userId, String password) async {
    // TODO: 실제 API 호출
    await Future.delayed(const Duration(seconds: 1));

    // 임시: 모든 로그인 허용
    state = AuthState(
      isAuthenticated: true,
      userId: userId,
      userName: '관리자',
      userRole: 'MASTER',
    );
  }

  void logout() {
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

