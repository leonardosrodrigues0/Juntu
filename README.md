# Juntu Frontend

Juntu iOS app frontend built in UIKit.

![Juntu](./juntu.png)

## Firebase

The app uses Firebase realtime database and storage to get its data and images, respectively. The **installed pods are pushed to the repository** so that the version is common to all developers. In order to install, update or remove pods, use [Firebase setup documentation](https://firebase.google.com/docs/ios/setup) to install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started).

To install new pods, add them to the Podfile and run:

```
pod install
```

To update Firebase and other pods:

```
pod update
```

## SwiftLint

Use SwiftLint to write source code for this repository. Lint rules are described in `.swiftlint.yml`. To install it with `brew`, run:

```
brew install swiftlint
```
