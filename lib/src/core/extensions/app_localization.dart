import 'package:flutter/material.dart';

import '../gen/l10n/app_localizations.dart';

extension BuildContextLocalizationExtension on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this);
}
