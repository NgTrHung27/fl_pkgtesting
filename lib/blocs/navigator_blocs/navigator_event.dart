// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fl_pkgtesting/blocs/navigator_blocs/navigator_types.dart';

abstract class NavigatorEvent {}

class UpdateNavigatorEvent extends NavigatorEvent {
  final NavigatorType navigatorType;
  final bool isExpriedToken;
  final Function()? callBack;

  UpdateNavigatorEvent(
    this.navigatorType, {
    this.isExpriedToken = false,
    this.callBack,
  });
}

class InitSlashScreen extends NavigatorEvent {
  final Function()? callBack;
  InitSlashScreen({this.callBack});
}
