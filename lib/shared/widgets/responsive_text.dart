import 'package:flutter/material.dart';
import '../../core/utils/responsive_font_utils.dart';

/// 반응형 텍스트 위젯
/// 화면 크기에 따라 자동으로 폰트 크기가 조정됩니다.
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;
  final double? minFontSize;
  final double? maxFontSize;
  final FontSizeType fontSizeType;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
    this.fontSizeType = FontSizeType.regular,
  });

  /// 작은 텍스트용 생성자
  const ResponsiveText.small(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
  }) : fontSizeType = FontSizeType.small;

  /// 일반 텍스트용 생성자
  const ResponsiveText.regular(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
  }) : fontSizeType = FontSizeType.regular;

  /// 중간 크기 텍스트용 생성자
  const ResponsiveText.medium(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
  }) : fontSizeType = FontSizeType.medium;

  /// 큰 텍스트용 생성자
  const ResponsiveText.large(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
  }) : fontSizeType = FontSizeType.large;

  /// 제목용 생성자
  const ResponsiveText.title(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
  }) : fontSizeType = FontSizeType.title;

  /// 헤딩용 생성자
  const ResponsiveText.heading(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
  }) : fontSizeType = FontSizeType.heading;

  /// 디스플레이용 생성자
  const ResponsiveText.display(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.minFontSize,
    this.maxFontSize,
  }) : fontSizeType = FontSizeType.display;

  @override
  Widget build(BuildContext context) {
    double fontSize;

    // 폰트 크기 타입에 따라 기본 크기 결정
    switch (fontSizeType) {
      case FontSizeType.small:
        fontSize = ResponsiveFontUtils.small(context);
        break;
      case FontSizeType.regular:
        fontSize = ResponsiveFontUtils.regular(context);
        break;
      case FontSizeType.medium:
        fontSize = ResponsiveFontUtils.medium(context);
        break;
      case FontSizeType.large:
        fontSize = ResponsiveFontUtils.large(context);
        break;
      case FontSizeType.title:
        fontSize = ResponsiveFontUtils.title(context);
        break;
      case FontSizeType.heading:
        fontSize = ResponsiveFontUtils.heading(context);
        break;
      case FontSizeType.display:
        fontSize = ResponsiveFontUtils.display(context);
        break;
    }

    // 사용자 정의 최소/최대값 적용
    if (minFontSize != null && fontSize < minFontSize!) {
      fontSize = minFontSize!;
    }
    if (maxFontSize != null && fontSize > maxFontSize!) {
      fontSize = maxFontSize!;
    }

    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: fontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}

enum FontSizeType {
  small,
  regular,
  medium,
  large,
  title,
  heading,
  display,
}

/// 반응형 리치 텍스트 위젯
class ResponsiveRichText extends StatelessWidget {
  final List<InlineSpan> children;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;
  final FontSizeType fontSizeType;

  const ResponsiveRichText({
    super.key,
    required this.children,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
    this.fontSizeType = FontSizeType.regular,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize;

    switch (fontSizeType) {
      case FontSizeType.small:
        fontSize = ResponsiveFontUtils.small(context);
        break;
      case FontSizeType.regular:
        fontSize = ResponsiveFontUtils.regular(context);
        break;
      case FontSizeType.medium:
        fontSize = ResponsiveFontUtils.medium(context);
        break;
      case FontSizeType.large:
        fontSize = ResponsiveFontUtils.large(context);
        break;
      case FontSizeType.title:
        fontSize = ResponsiveFontUtils.title(context);
        break;
      case FontSizeType.heading:
        fontSize = ResponsiveFontUtils.heading(context);
        break;
      case FontSizeType.display:
        fontSize = ResponsiveFontUtils.display(context);
        break;
    }

    return RichText(
      text: TextSpan(
        children: children,
        style: TextStyle(fontSize: fontSize),
      ),
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      softWrap: softWrap,
    );
  }
}
