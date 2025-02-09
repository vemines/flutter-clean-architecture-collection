import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reso_coder/core/network/network_info.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
  });

  group('isConnected', () {
    test('should forward the call to NetworkInfo.isConnected', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      final result = await mockNetworkInfo.isConnected;
      // assert
      expect(result, true);
      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyNoMoreInteractions(mockNetworkInfo);
    });
  });
}
