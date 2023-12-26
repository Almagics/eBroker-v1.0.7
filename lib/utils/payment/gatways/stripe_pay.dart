import 'dart:developer';

import 'package:ebroker/data/model/subscription_pacakage_model.dart';
import 'package:ebroker/utils/payment/gatways/stripe_service.dart';
import 'package:ebroker/utils/payment/lib/payment.dart';
import 'package:ebroker/utils/payment/lib/purchase_package.dart';
import 'package:flutter/cupertino.dart';

import '../../../settings.dart';
import '../../hive_utils.dart';

class Stripe extends Payment {
  SubscriptionPackageModel? _modal;

  @override
  Stripe setPackage(SubscriptionPackageModel modal) {
    _modal = modal;
    return this;
  }

  @override
  void pay(BuildContext context) async {
    try {
      log("Calling this pay method");
      StripeService.init(
        stripePublishable: AppSettings.stripePublishableKey,
        stripeSecrate: AppSettings.stripeSecrateKey,
      );

      final response = await StripeService.payWithPaymentSheet(
          amount: (_modal!.price! * 100).toInt(),
          currency: AppSettings.stripeCurrency,
          isTestEnvironment: true,
          metadata: {"packageId": _modal!.id, "userId": HiveUtils.getUserId()});
      log("Calling this pay method ${AppSettings.stripePublishableKey}::${AppSettings.stripeSecrateKey}");

      if (response.status == 'succeeded') {
        emit(Success(message: "Hello"));
      } else {
        emit(Failure(message: "Hello"));
      }
    } catch (_) {
      log("ERROR IS $_");
    }
  }

  @override
  void onEvent(
      BuildContext context, covariant PaymentStatus currentStatus) async {
    if (currentStatus is Success) {
      await PurchasePackage().purchase(context);
    }
  }
}
