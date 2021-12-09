# Apps

Apps must import all packages they depend on and glue all implementations to their respective interfaces in the Dependency Graph file using the `Common` Package's Service Locator tool.

For example, registering a link between a `Clients` Package's concrete implementation class to a `Data` Package's interface, and so on.

No concrete implementations for Use Cases, Repositories and Services are allowed outside the Dependency Graph file, only their interfaces must be used.

Platform specific Services, such as, Databases and other platform specific capabilities (Push, camera, etc) must be implemented in form of Adaptors in the app layer (or in the `App Common` package if applicable) whilst making the adaptor conform to the `Data` Package's Services Interfaces where applicable.

Widgets should contain the least amount of logic as possible. It should forward users inputs to its ViewModel and listen to its changes to update itself. ViewModels should only contain presentation logic, and make use of UseCases to execute business logic, exposing Streams and Callbacks to update the Widget's UI. ViewModels should not make direct use of Repositories and Services, UseCases are always preferred
