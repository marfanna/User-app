import 'package:flutter/services.dart';

enum AppFlavor {
  staging,
  prod;

  static AppFlavor get instance => switch (appFlavor) {
    'staging' => AppFlavor.staging,
    'prod' => AppFlavor.prod,
    _ => AppFlavor.prod,
  };
}
