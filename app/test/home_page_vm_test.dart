import 'dart:async';

import 'package:app/mvvm/app_routes.dart';
import 'package:app/pages/home/home_page_vm.dart';
import 'package:test/test.dart';

void main() {
  late HomePageViewModel viewModel;

  setUp(() {
    viewModel = HomePageViewModel();
  });

  group('HomePageViewModel', () {
    test('initial state starts at 0 and minus disabled', () async {
      final state = await viewModel.state.first;

      expect(state.count, 0);
      expect(state.isMinusEnabled, false);
      expect(state.isPlusEnabled, true);
    });

    test('plus button increases the count and enables minus', () async {
      viewModel.plusButtonTapped();

      final state = await viewModel.state.first;

      expect(state.count, 1);
      expect(state.isMinusEnabled, true);
      expect(state.isPlusEnabled, true);

      viewModel.dispose();
    });

    test('plus button disables at count 5', () async {
      viewModel.plusButtonTapped();
      var state = await viewModel.state.first;

      expect(state.count, 1);
      expect(state.isMinusEnabled, true);
      expect(state.isPlusEnabled, true);

      viewModel.plusButtonTapped();
      state = await viewModel.state.first;

      expect(state.count, 2);
      expect(state.isMinusEnabled, true);
      expect(state.isPlusEnabled, true);

      viewModel.plusButtonTapped();
      state = await viewModel.state.first;

      expect(state.count, 3);
      expect(state.isMinusEnabled, true);
      expect(state.isPlusEnabled, true);

      viewModel.plusButtonTapped();
      state = await viewModel.state.first;

      expect(state.count, 4);
      expect(state.isMinusEnabled, true);
      expect(state.isPlusEnabled, true);

      viewModel.plusButtonTapped();
      state = await viewModel.state.first;

      expect(state.count, 5);
      expect(state.isMinusEnabled, true);
      expect(state.isPlusEnabled, false);

      viewModel.dispose();
    });

    test('minus button disables at count 0', () async {
      viewModel.plusButtonTapped();
      var state = await viewModel.state.first;

      expect(state.count, 1);
      expect(state.isMinusEnabled, true);
      expect(state.isPlusEnabled, true);

      viewModel.minusButtonTapped();
      state = await viewModel.state.first;

      expect(state.count, 0);
      expect(state.isMinusEnabled, false);
      expect(state.isPlusEnabled, true);

      viewModel.dispose();
    });

    test('secondPageButtonTapped pushes second page', () async {
      // Set count to one
      viewModel.plusButtonTapped();
      final state = await viewModel.state.first;

      expect(state.count, 1);
      expect(state.isMinusEnabled, true);
      expect(state.isPlusEnabled, true);

      // delay execution so the event it caught by the Routes Publish
      scheduleMicrotask(viewModel.secondPageButtonTapped);
      final route = await viewModel.routes.first;

      expect(route.name, '/second');
      expect(route.action, AppRouteAction.pushTo);
      expect(route.arguments, {'count': 1});

      viewModel.dispose();
    });
  });
}
