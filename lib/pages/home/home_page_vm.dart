import 'package:flutter_mvvm/mvvm/view_model.abs.dart';
import 'package:flutter_mvvm/routes.dart';
import 'package:rxdart/subjects.dart';

class HomePageState {
  final int count;
  final bool isMinusEnabled;
  final bool isPlusEnabled;

  HomePageState({
    this.isMinusEnabled = false,
    this.isPlusEnabled = true,
    this.count = 0,
  });

  HomePageState copyWith({
    bool? isMinusEnabled,
    bool? isPlusEnabled,
    int? count,
  }) {
    return HomePageState(
      isMinusEnabled: isMinusEnabled ?? this.isMinusEnabled,
      isPlusEnabled: isPlusEnabled ?? this.isPlusEnabled,
      count: count ?? this.count,
    );
  }
}

class HomePageViewModel extends ViewModel {
  final _stateSubject = BehaviorSubject<HomePageState>.seeded(HomePageState());
  Stream<HomePageState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  void plusButtonTapped() {
    _updateState(_stateSubject.value.count + 1);
  }

  void minusButtonTapped() {
    _updateState(_stateSubject.value.count - 1);
  }

  void secondPageButtonTapped() {
    _routesSubject.add(
      AppRouteSpec(
        name: '/second',
        arguments: {
          'count': _stateSubject.value.count,
        },
      ),
    );
  }

  void _updateState(int newCount) {
    final state = _stateSubject.value;
    _stateSubject.add(
      state.copyWith(
        count: newCount,
        isPlusEnabled: newCount < 5,
        isMinusEnabled: newCount > 0,
      ),
    );
  }

  @override
  void dispose() {
    _stateSubject.close();
    _routesSubject.close();
  }
}
