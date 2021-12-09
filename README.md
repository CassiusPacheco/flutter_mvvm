# Flutter MVVM

[A series of blog posts](https://cassiuspacheco.com/series/flutter-mvvm-clean-arch) on how easy and clean it can be scaling an app from a simple MVVM to something similar to The Clean Architecture whilst keeping your code well tested.

## Environment Setup

The following steps are based on macOS Catalina.

1. Download and install Xcode and the Command Line Tools.

2. Download and install Android Studio. Go through the steps to install the Android SDK in its wizard.

3. Follow the initial steps described on the [Flutter website](https://flutter.dev/docs/get-started/install/macos) in regard to downloading the SDK.

4. Once the SDK is downloaded and your bash PATH is updated run `flutter doctor`.

5. Your android SDK should be property linked, but if it isn't and you have properly downloaded it, open Android Studio's SDK Manager and copy the SDK path, then run `flutter config --android-sdk path` to properly link them.

6. Run `flutter doctor` again and check if the Android SDK is linked. You may have to run `flutter doctor --android-licenses` and accept the licenses to make it work.

7. Flutter requires Cocoapods for iOS. The right way of using it is through `Bundler` so everyone in the team has the same versions installed. In the app's ios folder run `bundle install`. That should install cocoapods. In order to execute cocoapods with bundler just make sure you run them inside bundler `bundle exec pod install`.
In case it fails and you have properly download Xcode's Command Line Tools, it may be related to the ruby version that comes in the macos. To fix it download RVM by running `\curl -sSL https://get.rvm.io | bash -s stable` then `rvm install 2.6.0`, and finally `bundle install` again.

8. Run `flutter doctor` once again and check if Xcode is properly setup. You may need to run extra commands that flutter doctors suggest, but that should be it. Follow the instructions and continue to run `flutter doctor` to validate them. If developing in Visual Studio Code feel free to ignore the errors about Android Studio's plugins.

9. Run `flutter pub get` to fetch all packages if your Visual Studio Code doesn't fetch them automatically

10. Run `dart pub global activate melos` to install [Melos](https://pub.dev/packages/melos) globally. This makes managing monorepos more easily. For example by running `melos run test` it runs all tests for all projects, etc.

11. Add `export PATH="$PATH":"$HOME/.pub-cache/bin"` to your bash file

12. Run `dart pub global activate junitreport` to install [junitreport](https://pub.dev/packages/junitreport) globally. This translates the test results into a XML format understood by our CI.

13. Run `dart pub global activate clean_coverage` to install [clean_coverage](https://pub.dev/packages/clean_coverage) globally. This allows us to remove coverage for automatically generated files.

14. Run the following commands to setup the ability to run tests and gather the coverage:

```bash
brew install lcov

pip3 install wheel
pip3 install lcov_cobertura
pip3 install genhtml
```

15. Restart Terminal

16. In order to run all tests for all projects and gather coverage run `melos run coverage`. The coverage results will show in the project's root directory under `coverage/html`.

## Visual Studio Code Extensions

Suggested extensions:

- [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code) - language support and debugger for Visual Studio Code
- [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) - Proper Flutter support, debugger, etc. It should install Dart extension as well, if not download it manually.
- [Awesome Flutter Snippets](https://marketplace.visualstudio.com/items?itemName=Nash.awesome-flutter-snippets) - a list of snippets that get autocompleted for quicker and more convenient development.
- [Image Preview](https://marketplace.visualstudio.com/items?itemName=kisstkondoros.vscode-gutter-preview) - Shows image preview in the gutter and on hover

## Running the apps

Run `melos run get` to fetch all packages for all projects if your Visual Studio Code doesn't fetch them automatically.

On Visual Studio Code, go to the `Run and Debug` tab, click on `Run and Debug` button and select `Dart & Flutter`, doesn't come up automatically, then select the project you want to run.

# Architecture

The proposed apps are built inspired on the [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html). The following diagram explains the [dependency flow](https://www.uml-diagrams.org/dependency.html) of the packages and apps.

![](/assets/generic_clean_architecture_apps.jpg)

### Common Package

This is the most generic package where some highly reusable utils, common to all apps, can be placed. This package must not depend on any other internal package

### Entities Package

Contains all entities/models. Most commonly mapping JSON endpoints. Entities must not have any business logic. They’re plain data structures. This package must not depend on any other internal package

### Domain Package

All the general business logic must live in this package in form of composable Use Cases (also known as interactors). These Use Cases must be contained to single responsibility logic. One might have a Use Case that's as simple as making a call to a data source through a repository interface and not perform any other operation on top of that, but there will be many scenarios where it'll be required to compose multiple use cases into a new one in order to satisfy a piece of business logic. For example, a business requirement may be that upon logging out all user’s data must be wipe out and user should be prompted to give feedback. So creating a `LogoutUseCase` that makes use of `ClearUserDataUseCase` and `PromptFeedbackUseCase` makes sense.

The Domain Package depends solely on `Common` and `Entities` packages (and any common third party package that all packages/layers use, for example, `rxdart`). It also exposes Repository Interfaces which abstract any data source from the business logic and might be implemented by multiple different packages as needed.

Finally, the Domain Package might have some Data Structures which, as the name suggests, are structures representing data for certain business logic. That might be by aggregating data from multiple entities or other things

### Data Package

Contains the concrete implementations of the repositories responsible for orchestrating the services calls and potentially keeping state of pieces of information as required.

This package depends on `Entities` and `Common` Packages directly, as well as on the `Domain` Package in order to implement its repositories interfaces and access Data Structures. No direct access to Use Cases interfaces or implementations is allowed.

Services Interfaces are exposed by this package and might be used by other packages/apps to implement them in form of Network Clients, Databases/Storage, Platform Specific Libraries (Monitoring, Remote Toggles, Push Notification, In App Purchase, etc) and others

### Clients Package

Implements some of `Data` Package's Services Interfaces in form of Network Clients common to all apps. Since these network calls are platform agnostic it makes sense to have a specific reusable package for this.

This package depends directly on `Common` and `Entities` packages, as well as on the `Domain` and `Data` packages but only to access their interfaces. No direct access to any form of `Use Cases` or `Repositories` concrete implementations is allowed

### Design System Package

Contain Design System themes and UI components common to all apps

### App Common Package

Helpers, adaptors, utils and any other code that belongs to the App layer but is generic enough to work with any app should be put in here, so apps will be able to import them by default.

The `App Common Package` will not have any localisation specific code, and preferably no custom icons/images either.

### Apps

Apps must import all packages they depend on and glue all implementations to their respective interfaces in the Dependency Graph file using the `Common` Package's Service Locator tool.

For example, registering a link between a `Clients` Package's concrete implementation class to a `Data` Package's interface, and so on.

No concrete implementations for Use Cases, Repositories and Services are allowed outside the Dependency Graph file, only their interfaces must be used.

Platform specific Services, such as, Databases and other platform specific capabilities (Push, camera, etc) must be implemented in form of Adaptors in the app layer (or in the `App Common` package if applicable) whilst making the adaptor conform to the `Data` Package's Services Interfaces where applicable.

Widgets should contain the least amount of logic as possible. It should forward users inputs to its ViewModel and listen to its changes to update itself. ViewModels should only contain presentation logic, and make use of UseCases to execute business logic, exposing Streams and Callbacks to update the Widget's UI. ViewModels should not make direct use of Repositories and Services, UseCases are always preferred

# Naming conventions

## Interfaces (Abstract Classes)

All abstract classes when existing in their own files should have the file name ending with `.abs.dart`. This automatically excludes them from code coverage, since they usually don't have any implementation. However, any abstract class default implementation must be tested, even though it won't show up in the coverage.

## Pages

Widgets that represent a full page/screen should be suffixed with `page`.

For example, `HomeDetailPage`, `home_detail_page.dart` and `home_detail_page_test.dart`.

## Other Widgets

Widgets other than Pages should be suffixed in their files names with `_wd.dart`. No changes to the class name is required.

For example, `SomeCard` component widget has its file name as `some_card_wd.dart`.

## View Models

View Models should be suffixed with `ViewModel` in the class name but only as `_vm.dart` in the files names.

For example, `HomeDetailViewModel` for classes names, whilst `home_detail_vm.dart` and `home_detail_vm_test.dart` for files.

## Use Cases

Use cases interfaces should be suffixed with `UseCase` in the interfaces names but only as `_uc.abs.dart` in the files names. Concrete classes should be suffixed as `UseCaseImpl`, having the file name as `_uc.dart`. 

For example, `CreateUserAccountUseCase` and `create_user_account_uc.abs.dart` for interface, `CreateUseAccountUseCaseImpl`, `create_user_account_uc.dart` and `create_user_account_uc_test.dart` for concrete classes.

## Repositories

Repositories interfaces should be suffixed with `Repository` in the interfaces names and as `_repository.dart` in the files names. Concrete classes should be suffixed as `RepositoryImpl`, having the file name as `_repository.dart`.

For example, `UserRepository` and `user_repository.abs.dart` for interface, `UserRepositoryImpl`, `user_repository.dart` and `user_repository_test.dart` for concrete classes.

## Services

All services interfaces should be suffixed with `Service` in the interfaces names and as `_service.dart` in the files names. Concrete classes should be prefixed either as `Client` (`_client.dart`) for network services, or `Adaptor` (`_adaptor.dart`) for any other generic service.

For example, `UserService` and `user_service.abs.dart` for interface, `UserClient`, `user_client.dart` and `user_client_test.dart` for concrete network clients implementation.

`AnalyticsService` and `analytics_service.abs.dart` for interface, `AnalyticsAdaptor`, `analytics_adaptor.dart` and `analytics_adaptor_test.dart` for concrete adaptors implementation.

# License

MIT License

Copyright (c) 2021 Cassius Pacheco

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE
