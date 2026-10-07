import 'dart:io';

const _roots = <String>[
  'lib/app',
  'lib/features',
];

final _patterns = <RegExp>[
  RegExp(r'''\bText\(\s*(?:const\s+)?['"][^'"]*[A-Za-z\u4e00-\u9fff][^'"]*['"]'''),
  RegExp(r'''\btooltip\s*:\s*['"][^'"]+[A-Za-z\u4e00-\u9fff][^'"]*['"]'''),
  RegExp(r'''\blabelText\s*:\s*['"][^'"]+[A-Za-z\u4e00-\u9fff][^'"]*['"]'''),
  RegExp(r'''\bsemanticLabel\s*:\s*['"][^'"]+[A-Za-z\u4e00-\u9fff][^'"]*['"]'''),
];

bool _isPresentationFile(String path) {
  if (!path.endsWith('.dart')) return false;
  if (path.startsWith('lib/app/')) return true;
  return path.contains('/presentation/');
}

void main() {
  final violations = <String>[];

  for (final root in _roots) {
    final directory = Directory(root);
    if (!directory.existsSync()) continue;

    for (final entity in directory.listSync(recursive: true)) {
      if (entity is! File || !_isPresentationFile(entity.path)) continue;
      final lines = entity.readAsLinesSync();
      for (var index = 0; index < lines.length; index++) {
        final line = lines[index];
        if (line.contains('l10n-hardcode-ok')) continue;
        if (_patterns.any((pattern) => pattern.hasMatch(line))) {
          violations.add('${entity.path}:${index + 1}: ${line.trim()}');
        }
      }
    }
  }

  if (violations.isNotEmpty) {
    stderr.writeln(
      'Player-facing hardcoded strings found. Use AppLocalizations instead:',
    );
    for (final violation in violations) {
      stderr.writeln('  $violation');
    }
    exitCode = 1;
  }
}
