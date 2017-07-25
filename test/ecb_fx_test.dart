// Copyright (c) 2017, Agilord. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:ecb_fx/ecb_fx.dart';
import 'package:http_client/console.dart';
import 'package:test/test.dart';

void main() {
  group('Query ECB', () {
    Client httpClient;
    EcbFxClient ecbFxClient;

    setUp(() {
      httpClient = new ConsoleClient();
      ecbFxClient = new EcbFxClient(httpClient);
    });

    tearDown(() async {
      await httpClient.close();
    });

    void expectRates(EcbFxRates rates, int days) {
      expect(rates, isNotNull);
      expect(new DateTime.now().difference(DateTime.parse(rates.date)).inDays,
          lessThan(days));
      expect(rates.getDouble('USD'), inInclusiveRange(0.1, 10.0)); // optimistic
      expect(rates.getDouble('GBP'), inInclusiveRange(0.1, 10.0)); // optimistic
      expect(rates.getDouble('CHF'), inInclusiveRange(0.1, 10.0)); // optimistic
    }

    test('Get current', () async {
      EcbFxRates rates = await ecbFxClient.getCurrent();
      expectRates(rates, 7);
    });

    test('Get last 90 days', () async {
      List<EcbFxRates> ratesList = await ecbFxClient.getLast90Days();
      expect(ratesList, isNotNull);
      expect(ratesList.length, inInclusiveRange(50, 100));
      for (int i = 0; i < ratesList.length; i++) {
        expectRates(ratesList[i], i + 14 + (i ~/ 7) * 2);
      }
    });
  });
}
