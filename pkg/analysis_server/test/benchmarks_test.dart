// Copyright (c) 2014, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.=> defineTests();

/// This tests the benchmarks in benchmark/benchmark.test, and ensures that our
/// benchmarks can run.
import 'dart:convert';
import 'dart:io';

import 'package:analyzer_utilities/package_root.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() => defineTests();

String get _serverSourcePath {
  return path.join(packageRoot, 'analysis_server');
}

void defineTests() {
  group('benchmarks', () {
    var benchmarks = _listBenchmarks();

    test('can list', () {
      expect(benchmarks, isNotEmpty);
    });

    const benchmarkIdsToSkip = {
      'analysis-flutter-analyze',
      'das-flutter',
      'lsp-flutter',
    };

    for (var benchmarkId in benchmarks) {
      if (benchmarkIdsToSkip.contains(benchmarkId)) {
        continue;
      }

      test(benchmarkId, () {
        var r = Process.runSync(
          Platform.resolvedExecutable,
          [
            path.join('benchmark', 'benchmarks.dart'),
            'run',
            '--repeat=1',
            '--quick',
            benchmarkId
          ],
          workingDirectory: _serverSourcePath,
        );
        expect(r.exitCode, 0,
            reason: 'exit: ${r.exitCode}\n${r.stdout}\n${r.stderr}');
      });
    }
  });
}

List<String> _listBenchmarks() {
  var result = Process.runSync(
    Platform.resolvedExecutable,
    [path.join('benchmark', 'benchmarks.dart'), 'list', '--machine'],
    workingDirectory: _serverSourcePath,
  );
  Map m = json.decode(result.stdout);
  List benchmarks = m['benchmarks'];
  return benchmarks.map((b) => b['id']).cast<String>().toList();
}
