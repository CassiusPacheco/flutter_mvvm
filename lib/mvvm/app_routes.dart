enum AppRouteAction {
  pushTo,
  pop,
  popUntil,
  popUntilRoot,
  replaceWith,
  replaceAllWith
}

class AppRouteSpec {
  /// The route that the `action` will use to perform the action (push,
  /// replace, pop, etc).
  final String name;

  /// Arguments for the route. Arguments for Pop actions are ignored.
  /// Default empty.
  final Map<String, dynamic> arguments;

  /// Defaults to `AppRouteAction.pushTo`
  final AppRouteAction action;

  const AppRouteSpec({
    required this.name,
    this.arguments = const {},
    this.action = AppRouteAction.pushTo,
  });

  const AppRouteSpec.pop()
      : name = '',
        action = AppRouteAction.pop,
        arguments = const {};

  const AppRouteSpec.popUntilRoot()
      : name = '',
        action = AppRouteAction.popUntilRoot,
        arguments = const {};
}
