# TaskManager

TaskManager is a feature-rich task management application that allows users to efficiently manage their tasks. It is built using the Model-View-ViewModel (MVVM) architecture pattern, which promotes separation of concerns and facilitates testability and maintainability.

## Features

- User authentication: Users can recover password, and securely authenticate themselves.
- Task management: Users can create, update, and delete tasks, set due dates, assign tasks to users, and track their progress.
- User profiles: Users can view and manage their profiles, including their personal information and assigned tasks.

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern, which divides the app into three main components:

**Model**: The Model represents the data and business logic of the app. It includes entities such as User, Task, and UserProfile, as well as services for data retrieval and manipulation. In TaskManager, the Model handles tasks-related data and operations, such as creating, updating, and deleting tasks.

**View**: The View is responsible for displaying the user interface and capturing user interactions. TaskManager utilizes SwiftUI, Apple's declarative UI framework, to create intuitive and visually appealing user interfaces. SwiftUI allows for the easy composition of UI elements using a declarative syntax, making it simple to define the layout and behavior of views.

**ViewModel**: The ViewModel acts as an intermediary between the Model and the View. It handles the presentation logic, data transformations, and business rules. In TaskManager, the ViewModel provides the necessary data and commands to the View through data bindings. It enables the View to observe and react to changes in the underlying data, ensuring that the UI stays up to date with the latest information.

The MVVM architecture pattern promotes a clear separation of concerns, making the codebase easier to understand and maintain. It also facilitates unit testing of the ViewModel independently from the View and the Model.

### Advantages of using MVVM with SwiftUI in TaskManager

1. **Separation of Concerns**: The MVVM pattern separates the responsibilities of the Model, View, and ViewModel, promoting better code organization and modularity. This separation allows for easier maintenance and enhances the overall structure of the app.

2. **Testability**: MVVM facilitates unit testing by isolating the business logic and data transformations in the ViewModel. This separation enables thorough testing, leading to more reliable and bug-free code.

3. **Reusability and Composability**: SwiftUI's declarative nature and support for reusable components align well with the MVVM pattern. With ViewModel handling the presentation logic, the View becomes highly reusable and easily composable with other views or components. This reusability allows developers to build complex user interfaces by combining smaller, self-contained SwiftUI views.

4. **Data Binding and Reactive Updates**: SwiftUI's data binding and reactive updates are well-suited for MVVM. Establishing bindings between the View and the ViewModel enables real-time UI updates when the ViewModel's state changes. This reactive behavior ensures a smooth and responsive user experience.

5. **Maintainability**: MVVM improves code maintainability through its clear separation of concerns and well-defined roles for each component. The modular structure allows developers to understand and modify the codebase easily, add new features, or fix bugs without tightly coupling different parts of the application. This maintainability is crucial as the app grows in complexity and scale.

By adopting MVVM with SwiftUI in TaskManager, the application benefits from improved code organization, testability, reusability, and maintainability. It uses SwiftUI's powerful features to build a robust and responsive user interface while keeping the business logic and state management decoupled in the ViewModel. This approach enables flexible development, easier maintenance, and better overall software quality.

## Secure Token Storage with Keychain Access

In TaskManager, the user authentication system utilizes Keychain Access to securely store the user token after login. The token is a sensitive piece of information that is used for subsequent authenticated requests to the server.

