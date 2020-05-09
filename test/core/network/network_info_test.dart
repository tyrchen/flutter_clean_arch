import 'package:clean_arch/core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../fixture/mocks.dart';

void main() {
  NetworkInfoImpl info;
  MockDataConnectionChecker mockChecker;

  setUp(() {
    mockChecker = MockDataConnectionChecker();
    info = NetworkInfoImpl(mockChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      // arrange
      final hasConnFuture = Future.value(true);
      when(mockChecker.hasConnection).thenAnswer((_) => hasConnFuture);
      // act
      final result = info.isConnected;
      // assert
      verify(mockChecker.hasConnection);
      expect(result, hasConnFuture);
    });
  });
}
