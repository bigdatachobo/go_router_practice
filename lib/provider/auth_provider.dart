import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_practice/model/user_model.dart';
import 'package:go_router_practice/screen/1_screen.dart';
import 'package:go_router_practice/screen/2_screen.dart';
import 'package:go_router_practice/screen/3_screen.dart';
import 'package:go_router_practice/screen/error_screen.dart';
import 'package:go_router_practice/screen/home_screen.dart';
import 'package:go_router_practice/screen/login_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authStateProvider = AuthNotifier(ref: ref);

  return GoRouter(
    initialLocation: '/login',
    errorBuilder: (context, state) {
      return ErrorScreen(error: state.error.toString());
    },
    // redirect
    redirect: authStateProvider._redirectLogic,
    // refresh
    // 상태가 바뀔때마다 redirect를 재실행하는게 refresh
    refreshListenable: authStateProvider,
    routes: authStateProvider._routes,
  );
});

class AuthNotifier extends ChangeNotifier {
  final Ref ref;

  AuthNotifier({
    required this.ref,
  }) {
    ref.listen<UserModel?>(userProvider, (previous, next) {
      if (previous != next) {
        notifyListeners(); // ChangeNotifier를 바라보는 모든 widget들을 리빌딩하라고하는 listener
      }
    });
  }

  String? _redirectLogic(GoRouterState state) {
    // UserModel의 인스턴스 또는 null
    final user = ref.read(userProvider);

    // 로그인을 하려는 상태인지
    final loggingIn = state.location == '/login';

    // 유저 정보가 없다 - 로그인한 상태가 아니다.
    //
    // 유저 정보가 없고 (로그인 안한 상태)
    // 로그인하려는 중이 아니라면
    // 로그인 페이지로 이동한다.
    if (user == null) {
      // redirect 함수에 전달할 인자가 null이면 원래 이동하던 곳으로 이동하고
      // '/login'을 반환하면 이동하려던 곳으로 가지않고 로그인 페이지로 강제로 이동한다.
      return loggingIn ? null : '/login';
    }

    // 유저 정보가 있는데,(이미 로그인한 상태)
    // 로그인 페이지라면
    // 홈으로 이동
    if (loggingIn) {
      return '/';
    }

    // 나머지 상태에선 원래 가려던 페이지로 보냄.
    return null;
  }

  List<GoRoute> get _routes => [
        GoRoute(
          path: '/login',
          builder: (_, state) => LoginScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (_, state) => HomeScreen(),
          routes: [
            GoRoute(path: 'one', builder: (_, state) => OneScreen(), routes: [
              GoRoute(path: 'two', builder: (_, state) => TwoScreen(), routes: [
                GoRoute(
                  path: 'three',
                  name: ThreeScreen.routeName,
                  builder: (_, state) => ThreeScreen(),
                )
              ])
            ]),
          ],
        ),
      ];
}

// 아래 notifier class를 만들었으니 provider 생성해준다.
final userProvider = StateNotifierProvider<UserStateNotifier, UserModel?>(
  (ref) => UserStateNotifier(),
  // 반환값이 UserStateNotifier이고 어디서든 listen 가능
  // AuthNotifier에서 listen 할거임.
);

// 로그인한 상태면 UserModel 인스턴스 상태로 넣어주기
// 로그아웃 상태면 null 상태로 넣어주기
class UserStateNotifier extends StateNotifier<UserModel?> {
  UserStateNotifier() : super(null);

  login({
    required String name,
  }) {
    state = UserModel(name: name);
  }

  logout() {
    state = null;
  }
}
