// Copyright (c) 2017, Agilord. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:ecb_fx/ecb_fx.dart';
import 'package:http_client/console.dart' as http;

Future main() async {
  http.Client httpClient = new http.ConsoleClient();
  EcbFxClient ecbFxClient = new EcbFxClient(httpClient);

  EcbFxRates rates = await ecbFxClient.getCurrent();
  print('Current USD/EUR rate: ${rates.getDecimal('USD')}');
}
