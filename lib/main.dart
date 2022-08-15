import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_getway/payment_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51LX8VRAEkScjvlBq11KXJeKHCb3ksEbOwqyartQQ7PMmSyug6jyUGEDkRgmvLSpEzDXmWkUUacr1uRpW8hszcbhv00GNOvovBb";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final obj = PaymentController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
        child: ElevatedButton(
          onPressed: () {
            print('watting.................');
            obj.makePayment(amount: '5', currency: "USD");
            print("ok done");
          },
          child: const Text("Payments"),
        ),
      )),
    );
  }
}
