// Copyright (c) 2017, Agilord. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Foreign Exchange (FX) rates from the European Central Bank.
library ecb_fx;

import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:http_client/http_client.dart';
import 'package:xml/xml.dart';

class EcbFxClient {
  final Client _client;
  EcbFxClient(Client client) : _client = client;

  Future<EcbFxRates> getCurrent() async {
    final Response response = await _client.send(new Request(
        'GET', 'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml'));
    if (response.statusCode != 200) {
      throw new Exception(
          'Request failed with status code: ${response.statusCode}');
    }
    final String xmlText = await response.readAsString();
    final XmlDocument doc = parse(xmlText);
    final XmlElement ratesRoot = doc
        .findAllElements('Cube')
        .where((elem) => elem.getAttribute('time') != null)
        .single;
    return new EcbFxRates._fromXml(ratesRoot);
  }

  Future<List<EcbFxRates>> getLast90Days() async {
    final Response response = await _client.send(new Request('GET',
        'http://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml'));
    if (response.statusCode != 200) {
      throw new Exception(
          'Request failed with status code: ${response.statusCode}');
    }
    final String xmlText = await response.readAsString();
    final XmlDocument doc = parse(xmlText);
    return doc
        .findAllElements('Cube')
        .where((elem) => elem.getAttribute('time') != null)
        .map((XmlElement elem) => new EcbFxRates._fromXml(elem))
        .toList();
  }
}

class EcbFxRates {
  final String date;
  final Map<String, Decimal> _rates;

  EcbFxRates._(this.date, this._rates);

  factory EcbFxRates._fromXml(XmlElement node) {
    final Map<String, Decimal> rates = {};
    for (XmlElement ce in node.findElements('Cube')) {
      String currency = ce.getAttribute('currency');
      String rateStr = ce.getAttribute('rate');
      if (currency == null ||
          currency.isEmpty ||
          rateStr == null ||
          rateStr.isEmpty) {
        continue;
      }
      rates[currency] = Decimal.parse(rateStr);
    }
    return new EcbFxRates._(node.getAttribute('time'), rates);
  }

  Decimal getDecimal(String currency) => _rates[currency];

  double getDouble(String currency) => getDecimal(currency)?.toDouble();
}
