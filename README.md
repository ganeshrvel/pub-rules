### Introduction

##### Data Channel for Dart and Flutter.

**rules** (DC) is a simple dart utility for handling exceptions and data routing.
It is not a very ideal solution to handle exceptions using try and catch at every function call, use `rules` instead. `rules` will take care of routing errors and data out of a method.

### Installation

Go to https://pub.dev/packages/rules#-installing-tab- for the latest version of **rules**

### Example

Return error or data from `getSomeLoginData` method
```dart
import 'package:rules/rules.dart';

Future<DC<Exception, LoginModel>> getSomeLoginData() async {
    try {
      return DC.data(
        someData,
      );
    } on Exception {
      return DC.error(
        CacheException(),
      );
    }
 }
```

Check for errors

```dart
void doSomething() async {
    final value = await getSomeLoginData();

    if (value.hasError) {
      // do something
    } else if (value.hasData) {
      // do something
    }
 }
```

**DC forward**
Avoid redundant error checks. Easily convert an incoming data model to another one and forward it to the callee. `DC.forward` will return the error in case it encounters with one else data will be returned.
```dart
Future<DC<Exception, UserModel>> checkSomethingAndReturn() {
    final loginData = await getSomeLoginData();

    return DC.forward(
      loginData,
      UserModel(id: loginData.data?.tokenId),
    );
  }
```

**DC pick**

```dart
  final appData = await getSomeLoginData();
  appData.pick(
    onError: (error) {
      if (error is CacheException) {
        alerts.setException(context, error);
      }
    },
    onData: (data) {
      value1 = data;
    },
    onNoData: () {
      value1 = getDefaultValue();
    },
  );

  // or

  appData.pick(
    onError: (error) {
      if (error is CacheException) {
        alerts.setException(context, error);
      }
    },
    onNoError: (data) {
      if (data != null) {
        value1 = data;

        return;
      }

      value1 = getDefaultValue();
    },
  );
```


### Buy me a coffee
Help me keep the app FREE and open for all.
Paypal me: [paypal.me/ganeshrvel](https://paypal.me/ganeshrvel "paypal.me/ganeshrvel")

### Contacts
Please feel free to contact me at ganeshrvel@outlook.com

### About

- Author: [Ganesh Rathinavel](https://www.linkedin.com/in/ganeshrvel "Ganesh Rathinavel")
- License: [MIT](https://github.com/ganeshrvel/openmtp/blob/master/LICENSE "MIT")
- Package URL: [https://pub.dev/packages/scaff](https://pub.dev/packages/scaff "https://pub.dev/packages/scaff")
- Repo URL: [https://github.com/ganeshrvel/pub-scaff](https://github.com/ganeshrvel/pub-scaff/ "https://github.com/ganeshrvel/pub-scaff")
- Contacts: ganeshrvel@outlook.com

### License
scaff | Scaffold Generator for Dart and Flutter. [MIT License](https://github.com/ganeshrvel/pub-scaff/blob/master/LICENSE "MIT License").

Copyright © 2018-Present Ganesh Rathinavel
