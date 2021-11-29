import 'package:flutter/material.dart';
import 'package:flutter_mvvm/mvvm/view.abs.dart';
import 'package:flutter_mvvm/pages/home/home_page_vm.dart';
import 'package:flutter_mvvm/ui_components/app_button.dart';

class HomePage extends View<HomePageViewModel> {
  const HomePage({required HomePageViewModel viewModel, Key? key})
      : super.model(viewModel, key: key);

  @override
  _HomePageState createState() => _HomePageState(viewModel);
}

class _HomePageState extends ViewState<HomePage, HomePageViewModel> {
  _HomePageState(HomePageViewModel viewModel) : super(viewModel);

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomePageState>(
      stream: viewModel.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        final state = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home Page'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'You have pushed the button this many times:',
                    ),
                    const SizedBox(height: 32),
                    Text(
                      '${state.count}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                          isEnabled: state.isMinusEnabled,
                          onTap: viewModel.minusButtonTapped,
                          child: Text(
                            '-',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(color: Colors.blue),
                          ),
                        ),
                        const SizedBox(width: 32),
                        AppButton(
                          isEnabled: state.isPlusEnabled,
                          onTap: viewModel.plusButtonTapped,
                          child: Text(
                            '+',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                ?.copyWith(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      onTap: viewModel.secondPageButtonTapped,
                      child: Text(
                        'Go to second page',
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
