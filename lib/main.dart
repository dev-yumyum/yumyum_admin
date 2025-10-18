import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

import 'core/services/navigation_service.dart';
import 'core/services/service_locator.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 서비스 로케이터 초기화
  ServiceLocator().initialize();
  
  // 웹에서 URL의 # 제거 (깔끔한 URL)
  if (kIsWeb) {
    setPathUrlStrategy();
  }
  
  // 웹 성능 최적화 설정
  if (kIsWeb) {
    // 웹에서 스크롤 성능 향상
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    });
  }
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080), // 웹 기준 디자인 크기
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'YumYum CRM - 포장 서비스 관리자',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: _router,
          
          // 웹 최적화 설정 및 폰트 스케일 제한
          builder: (context, child) {
            // 폰트 스케일 팩터 30% 증가 (1.3배)
            final mediaQueryData = MediaQuery.of(context);
            final scaledTextScaleFactor = mediaQueryData.textScaleFactor * 1.3;
            
            Widget constrainedChild = MediaQuery(
              data: mediaQueryData.copyWith(
                textScaleFactor: scaledTextScaleFactor,
              ),
              child: child!,
            );
            
            // 웹에서 스크롤바 커스터마이징
            return kIsWeb
                ? ScrollConfiguration(
                    behavior: const MaterialScrollBehavior().copyWith(
                      scrollbars: true,
                      overscroll: false,
                      physics: const BouncingScrollPhysics(),
                    ),
                    child: constrainedChild,
                  )
                : constrainedChild;
          },
          
          // 웹 성능 최적화
          scrollBehavior: kIsWeb
              ? const MaterialScrollBehavior().copyWith(
                  scrollbars: true,
                  overscroll: false,
                )
              : null,
        );
      },
    );
  }
}
