import 'package:code_assets/code_assets.dart';
import 'package:ffmpeg_kit_extended_flutter/build_hook/config.dart';
import 'package:test/test.dart';

import '../hook/build.dart';

void main() {
  const releases =
      'https://github.com/MSOB7YY/ffmpeg-kit-builders/releases/download';
  const namida = {'type': 'namida', 'gpl': false, 'small': true};

  test('an app without configuration gets the namida bundle', () {
    final artifact = nativeBundleArtifact(
      config: const {'gpl': false, 'small': true},
      os: OS.android,
      architecture: Architecture.arm64,
    );
    expect(defaultBundleType, 'namida');
    expect(artifact.filename, 'bundle-namida-shared-small-lgpl-release.aar');
  });

  test('names the namida bundle of every platform like the builders do', () {
    final expected = {
      (OS.android, Architecture.arm64):
          'v$version-android/bundle-namida-shared-small-lgpl-release.aar',
      (
        OS.iOS,
        Architecture.arm64,
      ): 'v$version-ios/bundle-namida-ios-universal-small-lgpl.xcframework.zip',
      (
        OS.macOS,
        Architecture.x64,
      ): 'v$version-macos/bundle-namida-macos-universal-small-lgpl.xcframework.zip',
      (
        OS.windows,
        Architecture.x64,
      ): 'v$version-windows/bundle-namida-windows-x86_64-shared-small-lgpl.zip',
      (OS.linux, Architecture.x64):
          'v$version-linux/bundle-namida-linux-x86_64-shared-small-lgpl.zip',
    };
    for (final MapEntry(key: (os, architecture), value: path)
        in expected.entries) {
      final artifact = nativeBundleArtifact(
        config: namida,
        os: os,
        architecture: architecture,
      );
      expect(artifact.url, '$releases/$path', reason: '$os');
      expect(artifact.filename, path.split('/').last, reason: '$os');
    }
  });

  test('keeps the upstream bundle names for the other types', () {
    final artifact = nativeBundleArtifact(
      config: const {'type': 'debug', 'gpl': true, 'small': true},
      os: OS.linux,
      architecture: Architecture.x64,
    );
    expect(artifact.filename, 'bundle-base-linux-x86_64-shared-debug-gpl.zip');
  });

  test('rejects unknown bundle types', () {
    expect(
      () => nativeBundleArtifact(
        config: const {'type': 'minimal'},
        os: OS.android,
        architecture: Architecture.arm64,
      ),
      throwsException,
    );
  });

  test('verifies digests against the same repository it downloads from', () {
    expect(
      releaseAssetsApiUrl('v$version-android'),
      'https://api.github.com/repos/$artifactRepository/releases/tags/v$version-android',
    );
    expect(releases, contains(artifactRepository));
  });
}
