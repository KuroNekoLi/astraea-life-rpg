import 'package:astraea_life_rpg/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generated localization contract supports English and zh-TW', () {
    expect(
      AppLocalizations.supportedLocales,
      containsAll(const [Locale('en'), Locale('zh', 'TW')]),
    );
  });
}
