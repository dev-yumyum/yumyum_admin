import 'package:flutter/material.dart';
import '../utils/responsive_font_utils.dart';
import '../../shared/widgets/responsive_text.dart';

/// 반응형 폰트 사용법 예제들
/// 
/// 이 파일은 개발자들이 반응형 폰트를 올바르게 사용할 수 있도록
/// 다양한 사용 예제를 제공합니다.
class FontUsageExamples extends StatelessWidget {
  const FontUsageExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('반응형 폰트 사용 예제'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === 기본 Theme 사용법 ===
            _buildSection(
              '1. 기본 Theme 사용법 (권장)',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Display Large',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    'Headline Large',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Text(
                    'Title Large',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'Body Large',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    'Label Medium',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // === ResponsiveText 위젯 사용법 ===
            _buildSection(
              '2. ResponsiveText 위젯 사용법',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ResponsiveText.display('Display 크기 텍스트'),
                  const ResponsiveText.heading('Heading 크기 텍스트'),
                  const ResponsiveText.title('Title 크기 텍스트'),
                  const ResponsiveText.large('Large 크기 텍스트'),
                  const ResponsiveText.medium('Medium 크기 텍스트'),
                  const ResponsiveText.regular('Regular 크기 텍스트'),
                  const ResponsiveText.small('Small 크기 텍스트'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // === 커스텀 최소/최대 크기 설정 ===
            _buildSection(
              '3. 커스텀 최소/최대 크기 설정',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveText.title(
                    '최소 20px, 최대 30px로 제한된 제목',
                    minFontSize: 20,
                    maxFontSize: 30,
                  ),
                  ResponsiveText.regular(
                    '최소 14px로 제한된 본문',
                    minFontSize: 14,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // === 유틸리티 함수 직접 사용 ===
            _buildSection(
              '4. 유틸리티 함수 직접 사용',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '직접 계산된 폰트 크기',
                    style: TextStyle(
                      fontSize: ResponsiveFontUtils.responsiveFont(
                        context,
                        18,
                        minSize: 16,
                        maxSize: 22,
                      ),
                    ),
                  ),
                  Text(
                    '기본 large 크기 사용',
                    style: TextStyle(
                      fontSize: ResponsiveFontUtils.large(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // === 화면 타입별 조건부 렌더링 ===
            _buildSection(
              '5. 화면 타입별 조건부 렌더링',
              Builder(
                builder: (context) {
                  final screenType = ResponsiveFontUtils.getScreenType(context);
                  
                  switch (screenType) {
                    case ScreenType.mobile:
                      return const ResponsiveText.medium(
                        '모바일 화면입니다',
                        style: TextStyle(color: Colors.blue),
                      );
                    case ScreenType.tablet:
                      return const ResponsiveText.large(
                        '태블릿 화면입니다',
                        style: TextStyle(color: Colors.orange),
                      );
                    case ScreenType.desktop:
                      return const ResponsiveText.heading(
                        '데스크톱 화면입니다',
                        style: TextStyle(color: Colors.green),
                      );
                  }
                },
              ),
            ),

            const SizedBox(height: 32),

            // === 카드 내부에서 사용 ===
            _buildSection(
              '6. 카드 내부에서 사용 예제',
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveText.title(
                        '카드 제목',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const ResponsiveText.regular(
                        '이것은 카드 내부의 본문 텍스트입니다. '
                        '화면 크기에 따라 자동으로 조정됩니다.',
                      ),
                      const SizedBox(height: 8),
                      const ResponsiveText.small(
                        '작은 부가 정보',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // === 버튼과 함께 사용 ===
            _buildSection(
              '7. 버튼과 함께 사용',
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const ResponsiveText.medium('반응형 버튼'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const ResponsiveText.regular('일반 버튼'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // === 현재 화면 정보 ===
            _buildSection(
              '8. 현재 화면 정보',
              Builder(
                builder: (context) {
                  final mediaQuery = MediaQuery.of(context);
                  final screenType = ResponsiveFontUtils.getScreenType(context);
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveText.regular(
                        '화면 크기: ${mediaQuery.size.width.toInt()} x ${mediaQuery.size.height.toInt()}',
                      ),
                      ResponsiveText.regular(
                        '화면 타입: ${screenType.name}',
                      ),
                      ResponsiveText.regular(
                        '텍스트 스케일 팩터: ${mediaQuery.textScaleFactor.toStringAsFixed(2)}',
                      ),
                      ResponsiveText.regular(
                        'Regular 폰트 크기: ${ResponsiveFontUtils.regular(context).toStringAsFixed(1)}px',
                      ),
                      ResponsiveText.regular(
                        'Large 폰트 크기: ${ResponsiveFontUtils.large(context).toStringAsFixed(1)}px',
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }
}

/// 개발 팁과 가이드라인
class FontGuidelines {
  /// 폰트 크기 선택 가이드라인
  static const Map<String, String> fontSizeGuidelines = {
    'Display (28-40px)': '대형 제목, 히어로 섹션',
    'Heading (24-32px)': '페이지 제목, 섹션 헤더',
    'Title (20-28px)': '카드 제목, 서브 헤더',
    'Large (18-24px)': '중요한 본문, 버튼 텍스트',
    'Medium (16-20px)': '일반 본문, 리스트 아이템',
    'Regular (14-18px)': '기본 텍스트, 설명',
    'Small (12-16px)': '캡션, 라벨, 부가 정보',
  };

  /// 사용 시 주의사항
  static const List<String> usageNotes = [
    '1. 기본적으로 Theme의 textTheme을 사용하는 것을 권장합니다',
    '2. ResponsiveText는 특별한 조정이 필요한 경우에만 사용하세요',
    '3. 최소/최대 폰트 크기는 가독성을 해치지 않는 범위에서 설정하세요',
    '4. 화면 크기별로 다른 컨텐츠를 보여줘야 하는 경우 ScreenType을 활용하세요',
    '5. 폰트 크기가 너무 많이 달라지는 것을 방지하기 위해 적절한 제한을 두세요',
  ];
}
