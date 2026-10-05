import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Ashfang LockTarget Weak Node cancels downstream Pounce', () async {
    final content =
        jsonDecode(
              await rootBundle.loadString(
                'assets/content/encounters/ashfang_training_v1.json',
              ),
            )
            as Map<String, dynamic>;
    final graph = content['functionGraph'] as Map<String, dynamic>;
    final rule =
        (graph['weakNodeRules'] as List<dynamic>).single
            as Map<String, dynamic>;
    expect(rule['nodeId'], 'lock-target');
    expect(rule['cancelNodes'], ['pounce']);
    expect(content['balanceStatus'], contains('awaiting-playtest'));
  });
}
