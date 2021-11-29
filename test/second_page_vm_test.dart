import 'dart:async';

import 'package:flutter_mvvm/mvvm/app_routes.dart';
import 'package:flutter_mvvm/pages/second/second_page_vm.dart';
import 'package:test/test.dart';

void main() {
  late SecondPageViewModel viewModel;

  setUp(() {
    viewModel = SecondPageViewModel(count: 1);
  });

  group('SecondPageViewModel', () {
    test('initial state starts at given count', () async {
      final state = await viewModel.state.first;
      expect(state.count, 1);
    });

    test('thirdPageButtonTapped pushes third page', () async {
      // delay execution so the event it caught by the Routes Publish
      scheduleMicrotask(viewModel.thirdPageButtonTapped);
      final route = await viewModel.routes.first;

      expect(route.name, '/third');
      expect(route.action, AppRouteAction.pushTo);
      expect(route.arguments, {});

      viewModel.dispose();
    });
  });
}
