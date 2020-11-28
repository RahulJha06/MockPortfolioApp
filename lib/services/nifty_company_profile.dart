import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as _http;
import 'package:portfolio_monitor/models/company_profile.dart';

class NiftyCompanyProfileAPI {
  static Random _generateRandom = new Random();
  static Map<String, dynamic> _basePrice = {};
  static Map<String, dynamic> _currentPrice = {};

  static Future<List<dynamic>> getDummyCompanyProfile() async {
    _http.Response data = await _http.get(
        "http://us-central1-stock-fantasy-fd46e.cloudfunctions.net/helloWorld");
    List<dynamic> _result = jsonDecode(data.body);
    List<dynamic> _formattedData = _result.map((e) {
      Company c = new Company();
      c.industry = "Technology";
      c.name = e["symbol"];
      if (_basePrice[e["symbol"]] == null) {
        print("called");
        c.openingPrice = double.parse(
            ((_generateRandom.nextDouble() * 400) + 100)
                .toStringAsPrecision(5));
        _basePrice[e["symbol"]] = c.openingPrice;
      } else {
        c.openingPrice = (_basePrice[e["symbol"]]);
      }
      if (_generateRandom.nextBool()) {
        c.currentPrice = double.parse(
            (c.openingPrice + (_generateRandom.nextDouble() * 10))
                .toStringAsPrecision(5));
      } else {
        c.currentPrice = double.parse(
            (c.openingPrice - (_generateRandom.nextDouble() * 10))
                .toStringAsPrecision(5));
      }
      _currentPrice.update(c.name, (value) => c.currentPrice, ifAbsent: () {
        _currentPrice[c.name] = c.currentPrice;
      });
      c.image =
          "https://mediabrief.com/wp-content/uploads/2019/05/image-NIFTY-Indices-696-LOGO-INPOST-BODYNew-brand-identity-Vikram-Limaye-MD-CEO-NSE-mediabrief.jpg";
      return c;
    }).toList();
    return _formattedData;
  }

  static double getOpeningPrice(String companyName) {
    return _basePrice[companyName];
  }

  static double getCurrentPrice(String companyName) {
    return _currentPrice[companyName];
  }
}
