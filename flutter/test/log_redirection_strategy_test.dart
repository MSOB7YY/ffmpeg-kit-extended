import 'package:ffmpeg_kit_extended_flutter/src/generated/ffmpeg_kit_bindings_native.dart'
    as bindings;
import 'package:ffmpeg_kit_extended_flutter/src/log.dart';
import 'package:test/test.dart';

void main() {
  test('maps every strategy to its native value and back', () {
    for (final strategy in LogRedirectionStrategy.values) {
      final native = bindings.FFmpegKitLogRedirectionStrategy.fromValue(
        strategy.value,
      );
      expect(native.value, strategy.value);
      expect(LogRedirectionStrategy.fromValue(native.value), strategy);
    }
  });

  test('never printing maps to the native never print strategy', () {
    expect(
      LogRedirectionStrategy.neverPrintLogs.value,
      bindings
          .FFmpegKitLogRedirectionStrategy
          .FFMPEG_KIT_LOG_REDIRECTION_STRATEGY_NEVER_PRINT_LOGS
          .value,
    );
  });
}
