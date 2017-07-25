# ecb_fx

Foreign Exchange (FX) rates from the European Central Bank.
The rates refresh around 4 PM CET daily.

## Usage

A simple usage example:

````dart
import 'dart:async';

import 'package:ecb_fx/ecb_fx.dart';
import 'package:http_client/console.dart' as http;

Future main() async {
  http.Client httpClient = new http.ConsoleClient();
  EcbFxClient ecbFxClient = new EcbFxClient(httpClient);

  EcbFxRates rates = await ecbFxClient.getCurrent();
  print('Current USD/EUR rate: ${rates.getDecimal('USD')}');
}
````

## Links

- [ECB developer information](http://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html#dev)
- [source code][source]
- contributors: [Agilord][agilord]

[source]: https://github.com/agilord/ecb_fx
[agilord]: https://www.agilord.com/
