import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentController {
  Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(
      {required String amount, required String currency}) async {
    try {
      paymentIntentData = await createPaymentintent(amount, currency);
      print(paymentIntentData);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                merchantDisplayName: 'Prospects',
                customerId: paymentIntentData!['customer'],
                style: ThemeMode.dark,
                paymentIntentClientSecret: paymentIntentData!['client_secret'],
                customerEphemeralKeySecret:
                    paymentIntentData!['ephemeralkey']));
        displayPaymetsheet();
      }
    } catch (e, s) {
      print("exception${e},$s");
    }
  }

  createPaymentintent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51LX8VRAEkScjvlBqlgkeyasoliKMPcXO649sqZc22CUiYwnANCRuD1fwbWn2JfmUkutZdASkPl6BFdopxAJtKwfo00F0ihKnjX',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body.toString());
    } catch (err) {
      print("error ");
    }
  }

  displayPaymetsheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print("payment successfully");
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from strip: ${e.error.localizedMessage}");
      } else {
        print("unforeseen error:${e}");
      }
    } catch (err) {
      print("exception: ${err}");
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount) * 100);
    return a.toString();
  }
}
