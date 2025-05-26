import 'dart:async';

import 'package:fl_pkgtesting/blocs/navigator_blocs/navigator_event.dart';
import 'package:fl_pkgtesting/blocs/navigator_blocs/navigator_state.dart';
import 'package:fl_pkgtesting/blocs/navigator_blocs/navigator_types.dart';
import 'package:fl_pkgtesting/core/logger.dart';
import 'package:fl_pkgtesting/services/token_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigatorBloc extends Bloc<NavigatorEvent, NavigatorState> {
  NavigatorBloc() : super((const NavigatorState(navigatorType: NavigatorType.splash, reload: false))) {
    on<UpdateNavigatorEvent>(_onUpdateNavigator);
    on<InitSlashScreen>(_onInitSlashScreen);
  }
  final TokenService _tokenService = TokenService();
  final controller = StreamController<NavigatorType>();

  _onUpdateNavigator(UpdateNavigatorEvent event, Emitter<NavigatorState> emit) {
    switch (event.navigatorType) {
      case NavigatorType.splash:
        emit(state.update(
          navigatorType: NavigatorType.splash,
          reload: !state.reload,
        ));
        break;

      case NavigatorType.unauthenticated:
        if (state.navigatorType != NavigatorType.unauthenticated) {
          emit(state.update(
            navigatorType: NavigatorType.unauthenticated,
            reload: !state.reload,
            isExpriedToken: event.isExpriedToken,
          ));
          break;
        }
      case NavigatorType.intro:
        emit(state.update(
          navigatorType: NavigatorType.intro,
          reload: !state.reload,
          isExpriedToken: event.isExpriedToken,
        ));
        break;
      case NavigatorType.home:
        emit(state.update(
          navigatorType: NavigatorType.home,
          reload: !state.reload,
          isExpriedToken: event.isExpriedToken,
        ));
      case NavigatorType.news:
        emit(state.update(
          navigatorType: NavigatorType.news,
          reload: !state.reload,
          isExpriedToken: event.isExpriedToken,
        ));
        break;
      case NavigatorType.notifications:
        emit(state.update(
          navigatorType: NavigatorType.notifications,
          reload: !state.reload,
          isExpriedToken: event.isExpriedToken,
        ));
      case NavigatorType.setting:
        emit(state.update(
          navigatorType: NavigatorType.setting,
          reload: !state.reload,
          isExpriedToken: event.isExpriedToken,
        ));
    }
    if (event.callBack != null) event.callBack!();
  }

  _onInitSlashScreen(InitSlashScreen event, Emitter<NavigatorState> emit) async {
    String? token = await _tokenService.getAccessToken() ?? '';
    bool? isFirstInstall = await _tokenService.getFirstInstall();
    try {
      if (isFirstInstall == null) {
        add(UpdateNavigatorEvent(NavigatorType.intro));
        await _tokenService.setFirstInstall(isFirstInstall: false);
        if (event.callBack != null) event.callBack!();
      } else {
        if (!isFirstInstall) {
          if (token == '') {
            add(UpdateNavigatorEvent(NavigatorType.unauthenticated));
          } else if (token != '') {
            add(UpdateNavigatorEvent(NavigatorType.home));
          }
        } else {
          add(UpdateNavigatorEvent(NavigatorType.intro));
        }
      }
      if (event.callBack != null) event.callBack!();
    } catch (e) {
      logger.e("navigator_bloc.dart >> error: $e");
      add(UpdateNavigatorEvent(NavigatorType.unauthenticated));
    }
  }
}
