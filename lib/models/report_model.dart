import 'package:flutter/material.dart';
import 'package:gahezha/generated/l10n.dart';

enum ReportType { pending, resolved, dismissed }

class ReportModel {
  static String getLocalizedReportStatus(
    BuildContext context,
    ReportType reportType,
  ) {
    final locale = Localizations.localeOf(context).languageCode;
    String value;

    switch (reportType) {
      case ReportType.resolved:
        value = S.of(context).resolved;
        break;
      case ReportType.dismissed:
        value = S.of(context).dismissed;
        break;
      default:
        value = S.of(context).pending;
    }

    return locale == 'en' ? value.toUpperCase() : value;
  }
}
