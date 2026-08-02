import 'package:flutter_test/flutter_test.dart';
import 'package:weather_station_dashboard/core/utils/data_sampler.dart';

void main() {
  group('DataSampler.uniformSample', () {
    test('returns the input untouched when it is already small enough', () {
      final data = List.generate(12, (i) => i);
      expect(DataSampler.uniformSample(data, 30), equals(data));
    });

    test('reduces a large list to exactly the target count', () {
      final data = List.generate(1000, (i) => i);
      expect(DataSampler.uniformSample(data, 30), hasLength(30));
    });

    test('keeps the first and last readings', () {
      final data = List.generate(721, (i) => i);
      final sampled = DataSampler.uniformSample(data, 30);
      expect(sampled.first, 0);
      expect(sampled.last, 720);
    });

    test('spaces the samples evenly', () {
      final sampled = DataSampler.uniformSample(List.generate(100, (i) => i), 5);
      expect(sampled, [0, 25, 50, 74, 99]);
    });

    test('rejects a target below two points', () {
      expect(
        () => DataSampler.uniformSample([1, 2, 3], 1),
        throwsArgumentError,
      );
    });
  });
}
