import 'package:fl_pkgtesting/constants/image_assets.dart';
import 'package:fl_pkgtesting/main.dart';
import 'package:fl_pkgtesting/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum StatusSnackBar {
  info,
  warning,
  error,
  success,
  alert,
  none,
}

class SnackBarService {
  static void showSnackBar({
    required String content,
    StatusSnackBar status = StatusSnackBar.none,
    int showInSecond = 1000,
    double bottomPadding = 55,
    int maxLines = 1,
  }) {
    BuildContext? context = navigatorKeys.currentContext;
    if (context == null || !context.mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: showInSecond),
        content: Row(
          children: [
            SvgPicture.asset(getIcon(status)),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                content,
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: getColorSnackBar(status),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: bottomPadding, left: 20, right: 20),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

Color getColorSnackBar(StatusSnackBar type) {
  switch (type) {
    // case StatusSnackBar.info:
    //   return priorityColor;
    case StatusSnackBar.warning:
      return yellowWarning;
    case StatusSnackBar.error:
      return primaryRedColor;
    case StatusSnackBar.success:
      return primaryGreen;
    default:
      return raisinBlackColor;
  }
}

String getIcon(StatusSnackBar type) {
  switch (type) {
    case StatusSnackBar.info:
      return infoToolTipWhiteSVG;
    case StatusSnackBar.warning:
      return warningTriangleWhiteSVG;
    case StatusSnackBar.error:
      return errorCircleWhiteSVG;
    case StatusSnackBar.success:
      return successCircleWhiteSVG;
    default:
      return infoToolTipWhiteSVG;
  }
}
