# Data Package

Contains the concrete implementations of the repositories responsible for orchestrating the services calls and potentially keeping state of pieces of information as required.

This package depends on `Entities` and `Common` Packages directly, as well as on the `Domain` Package in order to implement its repositories interfaces and access Data Structures. No direct access to Use Cases interfaces or implementations is allowed.

Services Interfaces are exposed by this package and might be used by other packages/apps to implement them in form of Network Clients, Databases/Storage, Platform Specific Libraries (Monitoring, Remote Toggles, Push Notification, In App Purchase, etc) and others
