import 'package:flutter/material.dart';
import 'dart:math' as math;

class ResponsiveFontUtils {
  // 기본 화면 크기 (디자인 기준)
  static const double _baseWidth = 1920.0;
  static const double _baseHeight = 1080.0;
  
  // 폰트 크기 제한값
  static const double _minFontScale = 0.8;  // 최소 80%
  static const double _maxFontScale = 1.5;  // 최대 150%
  
  /// 반응형 폰트 크기 계산
  /// [baseFontSize]: 기본 폰트 크기
  /// [context]: BuildContext
  /// [minSize]: 최소 폰트 크기 (선택사항)
  /// [maxSize]: 최대 폰트 크기 (선택사항)
  static double responsiveFont(
    BuildContext context,
    double baseFontSize, {
    double? minSize,
    double? maxSize,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    // 화면 크기 기반 스케일 계산
    final widthScale = screenWidth / _baseWidth;
    final heightScale = screenHeight / _baseHeight;
    
    // 더 작은 스케일을 기준으로 하여 극단적인 변화 방지
    double scale = math.min(widthScale, heightScale);
    
    // 화면 크기별 조정
    if (screenWidth <= 600) {
      // 모바일: 스케일을 더 작게 적용
      scale = scale * 0.9;
    } else if (screenWidth <= 1024) {
      // 태블릿: 적당한 스케일 적용
      scale = scale * 0.95;
    } else {
      // 데스크톱: 큰 화면에서는 스케일을 제한
      scale = math.min(scale, 1.2);
    }
    
    // 최소/최대 스케일 제한
    scale = math.max(_minFontScale, math.min(_maxFontScale, scale));
    
    final calculatedSize = baseFontSize * scale;
    
    // 사용자 정의 최소/최대값 적용
    if (minSize != null && calculatedSize < minSize) {
      return minSize;
    }
    if (maxSize != null && calculatedSize > maxSize) {
      return maxSize;
    }
    
    return calculatedSize;
  }
  
  /// 작은 텍스트용 (12-16)
  static double small(BuildContext context) {
    return responsiveFont(context, 14, minSize: 12, maxSize: 16);
  }
  
  /// 일반 텍스트용 (14-18)
  static double regular(BuildContext context) {
    return responsiveFont(context, 16, minSize: 14, maxSize: 18);
  }
  
  /// 중간 크기 텍스트용 (16-20)
  static double medium(BuildContext context) {
    return responsiveFont(context, 18, minSize: 16, maxSize: 20);
  }
  
  /// 큰 텍스트용 (18-24)
  static double large(BuildContext context) {
    return responsiveFont(context, 20, minSize: 18, maxSize: 24);
  }
  
  /// 제목용 (20-28)
  static double title(BuildContext context) {
    return responsiveFont(context, 24, minSize: 20, maxSize: 28);
  }
  
  /// 큰 제목용 (24-32)
  static double heading(BuildContext context) {
    return responsiveFont(context, 28, minSize: 24, maxSize: 32);
  }
  
  /// 디스플레이용 (28-40)
  static double display(BuildContext context) {
    return responsiveFont(context, 32, minSize: 28, maxSize: 40);
  }
  
  /// 화면 타입 감지
  static ScreenType getScreenType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 600) {
      return ScreenType.mobile;
    } else if (width < 1024) {
      return ScreenType.tablet;
    } else {
      return ScreenType.desktop;
    }
  }
}

enum ScreenType {
  mobile,
  tablet,
  desktop,
}

/// Text 위젯용 확장 함수
extension ResponsiveText on Text {
  Text responsive(BuildContext context, {
    double? minSize,
    double? maxSize,
  }) {
    final style = this.style ?? const TextStyle();
    final currentSize = style.fontSize ?? 16;
    
    return Text(
      data!,
      style: style.copyWith(
        fontSize: ResponsiveFontUtils.responsiveFont(
          context,
          currentSize,
          minSize: minSize,
          maxSize: maxSize,
        ),
      ),
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
