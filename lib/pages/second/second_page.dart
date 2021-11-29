import 'package:flutter/material.dart';
import 'package:flutter_mvvm/mvvm/view.abs.dart';
import 'package:flutter_mvvm/pages/second/second_page_vm.dart';
import 'package:flutter_mvvm/ui_components/app_button.dart';

class SecondPage extends View<SecondPageViewModel> {
  const SecondPage({required SecondPageViewModel viewModel, Key? key})
      : super.model(viewModel, key: key);

  @override
  _SecondPageState createState() => _SecondPageState(viewModel);
}

class _SecondPageState extends ViewState<SecondPage, SecondPageViewModel> {
  _SecondPageState(SecondPageViewModel viewModel) : super(viewModel);

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SecondPageState>(
      stream: viewModel.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final state = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Second Page'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '''You have pushed the button this many times ${state.count} in the previous page''',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      onTap: viewModel.thirdPageButtonTapped,
                      child: Text(
                        'Go to third page',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            ?.copyWith(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
