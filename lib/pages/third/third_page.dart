import 'package:flutter/material.dart';
import 'package:flutter_mvvm/mvvm/view.abs.dart';
import 'package:flutter_mvvm/pages/third/third_page_vm.dart';
import 'package:flutter_mvvm/ui_components/app_button.dart';

class ThirdPage extends View<ThirdPageViewModel> {
  const ThirdPage({required ThirdPageViewModel viewModel, Key? key})
      : super.model(viewModel, key: key);

  @override
  _ThirdPageState createState() => _ThirdPageState(viewModel);
}

class _ThirdPageState extends ViewState<ThirdPage, ThirdPageViewModel> {
  _ThirdPageState(ThirdPageViewModel viewModel) : super(viewModel);

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Page'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                AppButton(
                  onTap: viewModel.popUntilRootButtonTapped,
                  child: Text(
                    'Pop until root',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 32),
                AppButton(
                  onTap: viewModel.popUntilHomeButtonTapped,
                  child: Text(
                    'Pop until home page',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 32),
                AppButton(
                  onTap: viewModel.popUntilSecondButtonTapped,
                  child: Text(
                    'Pop until second page',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 32),
                AppButton(
                  onTap: viewModel.popButtonTapped,
                  child: Text(
                    'Pop',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
