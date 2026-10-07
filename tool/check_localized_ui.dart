import 'dart:io';

const _roots = <String>['lib/app', 'lib/features'];

final _candidatePatterns = <RegExp>[
  RegExp(r'''\bText\(\s*(?:const\s+)?(['"])(.*?)\1'''),
  RegExp(r'''\btooltip\s*:\s*(['"])(.*?)\1'''),
  RegExp(r'''\blabelText\s*:\s*(['"])(.*?)\1'''),
  RegExp(r'''\bsemanticLabel\s*:\s*(['"])(.*?)\1'''),
];

final _letters = RegExp(r'[A-Za-z\u4e00-\u9fff]');
final _bracedInterpolation = RegExp(r'\$\{[^}]*\}');
final _simpleInterpolation = RegExp(r'\$[A-Za-z_]\w*');

bool _isPresentationFile(String path) {
  if (!path.endsWith('.dart')) return false;
  if (path.startsWith('lib/app/')) return true;
  return path.contains('/presentation/');
}

bool _containsLiteralPlayerText(String line) {
  for (final pattern in _candidatePatterns) {
    for (final match in pattern.allMatches(line)) {
      var content = match.group(2) ?? '';
      content = content.replaceAll(_bracedInterpolation, '');
      content = content.replaceAll(_simpleInterpolation, '');
      if (_letters.hasMatch(content)) return true;
    }
  }
  return false;
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
        if (_containsLiteralPlayerText(line)) {
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
