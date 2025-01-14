import 'dart:ui';

// 그렇다면 이 인식은 무엇일까요?
// 따라서 이 인식은 실제로 이 EML 폴더에 존재하는 또 다른 클래스입니다.
// 그리고 열어보면 이것이 단순한 데이터 클래스라는 것을 알 수 있습니다.
// 따라서 이는 일부 데이터를 저장하기 위해 존재한다는 것을 의미합니다.
class Recognition {
  String name;
  // 그리고 우리는 이 직사각형 속성을 얻었습니다.
  // 그리고 얼굴의 위치를 저장하는 역할도 합니다.
  Rect location;
  // 그리고 나서 우리는 임베딩인 double 목록을 얻었습니다.
  // 따라서 이 속성은 얼굴에 대한 임베딩을 저장하는데 사용됩니다.
  List<double> embeddings;
  // 그리고 나서 이 거리 속성을 얻었습니다.
  // 따라서 이 거리 속성은 두 면 사이의 거리나 차이를 저장하는 데 사용됩니다.
  // 그래서 우리는 두 얼굴의 임베딩을 비교하고 차이를 계산해 보겠습니다.
  // 그리고 그 차이는 실제로 거기에 저장됩니다.
  double distance;

  /// Constructs a Category.
  Recognition(
    this.name,
    this.location,
    this.embeddings,
    this.distance,
  );
}
