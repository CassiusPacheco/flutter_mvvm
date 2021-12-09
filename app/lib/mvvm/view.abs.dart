import 'dart:async';

import 'package:app/mvvm/app_routes.dart';
import 'package:app/mvvm/view_model.abs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

abstract class View<VM extends ViewModel> extends StatefulWidget {
  final VM viewModel;

  const View.model(this.viewModel, {Key? key}) : super(key: key);
}

abstract class ViewState<V extends View, VM extends ViewModel> extends State<V>
    with RouteAware {
  late final VM _viewModel;
  late final Logger logger;

  VM get viewModel => _viewModel;

  String get _sanitisedRoutePageName {
    return '$runtimeType'.replaceAll('_', '').replaceAll('State', '');
  }

  @mustCallSuper
  ViewState(this._viewModel) {
    logger = Logger(runtimeType.toString());
    logger.fine('Created $runtimeType.');
  }

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    viewModel.init();
  }

  /// Listens to the stream and automatically routes users according to the
  /// route spec.
  StreamSubscription<AppRouteSpec> listenToRoutesSpecs(
    Stream<AppRouteSpec> routes,
  ) {
    return routes.listen((spec) async {
      switch (spec.action) {
        case AppRouteAction.pushTo:
          await Navigator.of(context).pushNamed(
            spec.name,
            arguments: spec.arguments,
          );
          break;
        case AppRouteAction.replaceWith:
          await Navigator.of(context).pushReplacementNamed(
            spec.name,
            arguments: spec.arguments,
          );
          break;
        case AppRouteAction.replaceAllWith:
          await Navigator.of(context).pushNamedAndRemoveUntil(
            spec.name,
            (route) => false,
            arguments: spec.arguments,
          );
          break;
        case AppRouteAction.pop:
          Navigator.of(context).pop();
          break;
        case AppRouteAction.popUntil:
          Navigator.of(context)
              .popUntil((route) => route.settings.name == spec.name);
          break;
        case AppRouteAction.popUntilRoot:
          Navigator.of(context).popUntil((route) => route.isFirst);
          break;
      }
    });
  }

  @mustCallSuper
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // subscribe for the change of route
    if (ModalRoute.of(context) != null) {
      routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
    }
  }

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  @mustCallSuper
  @override
  void didPopNext() {
    logger.finer('🚚 $_sanitisedRoutePageName didPopNext');
    viewModel.routingDidPopNext();
  }

  /// Called when the current route has been pushed.
  @mustCallSuper
  @override
  void didPush() {
    logger.finer('🚚 $_sanitisedRoutePageName didPush');
    viewModel.routingDidPush();
  }

  /// Called when the current route has been popped off.
  @mustCallSuper
  @override
  void didPop() {
    logger.finer('🚚 $_sanitisedRoutePageName didPop');
    viewModel.routingDidPop();
  }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  @mustCallSuper
  @override
  void didPushNext() {
    logger.finer('🚚 $_sanitisedRoutePageName didPushNext');
    viewModel.routingDidPushNext();
  }

  @mustCallSuper
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    logger.fine('Disposing $runtimeType.');
    viewModel.dispose();
    super.dispose();
  }
}
