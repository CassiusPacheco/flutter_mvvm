import 'package:flutter_mvvm/mvvm/view_model.abs.dart';
import 'package:flutter_mvvm/routes.dart';
import 'package:rxdart/subjects.dart';

class SecondPageState {
  final int count;

  SecondPageState({
    this.count = 0,
  });

  SecondPageState copyWith({
    int? count,
  }) {
    return SecondPageState(
      count: count ?? this.count,
    );
  }
}

class SecondPageViewModel extends ViewModel {
  final _stateSubject =
      BehaviorSubject<SecondPageState>.seeded(SecondPageState());
  Stream<SecondPageState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  SecondPageViewModel({required int count}) {
    _stateSubject.add(SecondPageState(count: count));
  }

  void thirdPageButtonTapped() {
    _routesSubject.add(
      const AppRouteSpec(name: '/third'),
    );
  }

  @override
  void dispose() {
    _stateSubject.close();
    _routesSubject.close();
  }
}
