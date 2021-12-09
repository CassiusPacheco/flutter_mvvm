# Clients Package

Implements some of `Data` Package's Services Interfaces in form of Network Clients common to all apps. Since these network calls are platform agnostic it makes sense to have a specific reusable package for this.

This package depends directly on `Common` and `Entities` packages, as well as on the `Domain` and `Data` packages but only to access their interfaces. No direct access to any form of `Use Cases` or `Repositories` concrete implementations is allowed
