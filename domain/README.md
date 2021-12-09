# Domain Package

All the general business logic must live in this package in form of composable Use Cases (also known as interactors). These Use Cases must be contained to single responsibility logic. One might have a Use Case that's as simple as making a call to a data source through a repository interface and not perform any other operation on top of that, but there will be many scenarios where it'll be required to compose multiple use cases into a new one in order to satisfy a piece of business logic. For example, a business requirement may be that upon logging out all user’s data must be wipe out and user should be prompted to give feedback. So creating a `LogoutUseCase` that makes use of `ClearUserDataUseCase` and `PromptFeedbackUseCase` makes sense.

The Domain Package depends solely on `Common` and `Entities` packages (and any common third party package that all packages/layers use, for example, `rxdart`). It also exposes Repository Interfaces which abstract any data source from the business logic and might be implemented by multiple different packages as needed.

Finally, the Domain Package might have some Data Structures which, as the name suggests, are structures representing data for certain business logic. That might be by aggregating data from multiple entities or other things
