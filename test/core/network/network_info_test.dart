import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_tdd/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  late NetworkInfoImpl networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () {
    test(
        'should return false when Connectivity checkConnectivity() equals to ConnectivityResult.none',
        () async {
      // arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);
      // act
      final result = await networkInfo.isConnected;
      // assert
      verify(await mockConnectivity.checkConnectivity());
      expect(result, false);
    });
    test(
        'should return true when Connectivity checkConnectivity() equals to ConnectivityResult.wifi',
        () async {
      // arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      // act
      final result = await networkInfo.isConnected;
      // assert
      verify(await mockConnectivity.checkConnectivity());
      expect(result, true);
    });

    test(
        'should return true when Connectivity checkConnectivity() equals to ConnectivityResult.mobile',
        () async {
      // arrange
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.mobile);
      // act
      final result = await networkInfo.isConnected;
      // assert
      verify(await mockConnectivity.checkConnectivity());
      expect(result, true);
    });
  });
}
