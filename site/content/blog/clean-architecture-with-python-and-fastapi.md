+++
title = 'Clean Architecture with Python and FastAPI'
date = 2025-03-30T00:00:00-06:00
description = '''
Build beautiful software using Robert C. Martin's (Uncle Bob) Clean
Architecture with Python and FastAPI.
'''
author = 'Nickolas Kraus'
featured = true
draft = false
+++

<p style="text-align: center;">
  <img src="/images/blog/clean-architecture-with-python-and-fastapi/cover.png"/>
</p>

## Overview

>Before reading this blog post, first read [The Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

Python and FastAPI are not prescriptive on code layout. This gives us the benefit of a very expressive language, but the drawback of not having a prescribed structure to keep things organized. We know that:

1. Our technology stack gives us the freedom to choose our project organization.
2. Systems not acted upon by outside forces tend toward chaos (e.g., entropy).

We want to select an organizational paradigm that will help current and future project maintainers by:

- Making it obvious where code should live.
- Encouraging decoupling of code in a productive way.
- Reducing the time for new developers to contribute to the project.

An established pattern like [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) provides a benefit through a structure that can be readily adopted instead of spending time defining your own structure.

### The Clean Architecture

The primary objective of *Clean Architecture* is separation of concerns. This is achieved by dividing the software into layers. There is at least one layer for business rules and another for interfaces.

#### The Dependency Rule

The overriding rule that makes Clean Architecture work is *The Dependency Rule*. This rule states that *source code dependencies* can only point *inwards*. Nothing in an inner circle can know anything at all about something in an outer circle. In particular, the name of something declared in an outer circle must not be mentioned by the code in an inner circle. This includes functions, classes, variables, or any other named software entity.

### Enterprise Rules vs. Application Rules

Clean Architecture proposes a method for organizing code based on a distinction between *enterprise* business rules (entities) and *application* business rules (use cases):

**Enterprise Rules**

*Enterprise business rules are external and encapsulate the most general and high-level rules.*

- Define the structure of data in our REST API.
- Define the data type of each field in a structure.
- Define which fields are required.
- Define limits on fields (lengths, min/max, etc.).
- Changes to these rules change the interface of the application.

**Application Rules**

*Application business rules are internal and encapsulate the logic for orchestrating the flow of data to and from the entities.*

- Define how data (database or otherwise) interact with each other.
- Enforce business rules, for example:
    - Each user has a unique ID.
    - Each user must have an associated password.
    - No two users can have the same ID.
- Changes to these rules change the operation of the application.

## Implementation

With regard to a Python and FastAPI application, a code organization paradigm can be adopted based on the approach outlined in [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

As such, the following layers (from outermost to innermost) and concepts in each layer are used:

| Layer                      | Concepts                    |
| -------------------------- | --------------------------- |
| Frameworks & Drivers       | `FastAPI`                   |
| Interface Adapters         | `controllers`, `middleware` |
| Application Business Rules | `usecases`                  |
| Enterprise Business Rules  | `entities`                  |

The flow can be described as:

>`controllers` invoke `usecases` and `middleware`, which operate on `entities`.

### FastAPI

FastAPI is a web framework for building APIs with Python. It resides in the outermost layer and communicates to the next circle inwards (Interface Adapters).

### controllers

`controllers` comprise the HTTP endpoints and convert data from requests to the format most convenient for the use cases and entities. Request and response data is defined using [Pydantic models](https://docs.pydantic.dev/latest/concepts/models/).

They will:
- Define HTTP endpoints.
- Determine the correct HTTP status code based on the output of the `usecases` layer.

They will **not**:
- Make requests to external services directly (i.e., use `requests`).

### middleware

`middleware` contains functionality that is commonly used by the `controllers` or `usecases` layers. Examples could include:

- Implementing authentication/authorization for HTTP endpoints.
- Tracing or metrics reporting.
- Clients that interact with external systems.

Some middleware is created by the developer, while others may be third-party libraries, such as the [AWS SDK for Python (Boto3)](https://aws.amazon.com/sdk-for-python/). Third-party libraries do not need to exist in the middleware section of the code base, but should be used in the same way.

They will:
- Provide interfaces for use cases to use.

They will **not**:
- Access data from systems they are not related to.
- Depend on other middleware.

### usecases

>The software in this layer contains *application specific* business rules. It encapsulates and implements all of the use cases of the system. These use cases orchestrate the flow of data to and from the entities, and direct those entities to use their *enterprise wide* business rules to achieve the goals of the use case.

`usecases` comprise the logic for executing the operation of the application. Use cases may use middleware for interacting with external systems and entities for structuring data.

They will:
- Include application specific business rules in the implementation of their interfaces.
- Use middleware to access external systems.
- Encapsulate the entire business case, including requests to external systems.
- Raise appropriate exceptions to the caller (i.e. `FooNotFound` when an entity is requested, but does not exist).

They will **not**:
- Access `usecases` outside themselves.
- Access `controllers`.

### entities

>Entities encapsulate *Enterprise wide* business rules. An entity can be an object with methods, or it can be a set of data structures and functions. It doesn’t matter so long as the entities could be used by many different applications in the enterprise.

Entities are low-level data structures that can be used throughout the code base.

They will:
- Include enterprise wide business rules:
  - Which fields are required.
  - Type of fields.
- Include common data structures used throughout the layers of the application:
  - Define request and response types.
  - Define exceptions.
  - Define data structures that can be received from external systems.

They will **not**:
- Access any stored data.
- Access any systems.

Entities are intended to be the core of the application and least likely to be modified. Their implementation may take a few forms, all of which should support being completely decoupled from dependencies:
- [Pydantic models](https://docs.pydantic.dev/latest/concepts/models/)
- [Pydantic dataclasses](https://docs.pydantic.dev/latest/concepts/dataclasses/)
- Exceptions

### File Structure

The file structure to store these layers has the following layout:

```
└── app
    ├── controllers
    ├── entities
    ├── middleware
    ├── usecases
    └── app.py
```

## Conclusion

Using an organizational paradigm such as Clean Architecture protects against the degradation of a code base as it grows by defining clear separations between software layers.
