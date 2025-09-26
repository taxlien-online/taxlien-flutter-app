fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### build_all

```sh
[bundle exec] fastlane build_all
```

Build both iOS and Android apps

### release_all

```sh
[bundle exec] fastlane release_all
```

Release both iOS and Android apps

### beta_all

```sh
[bundle exec] fastlane beta_all
```

Beta release for both platforms

### clean_all

```sh
[bundle exec] fastlane clean_all
```

Clean all build artifacts

### test_all

```sh
[bundle exec] fastlane test_all
```

Run all tests

### gen_l10n

```sh
[bundle exec] fastlane gen_l10n
```

Generate localization files

### doctor

```sh
[bundle exec] fastlane doctor
```

Check Flutter doctor

----


## iOS

### ios release

```sh
[bundle exec] fastlane ios release
```

Build and upload iOS app to App Store

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Build and upload iOS app to TestFlight

### ios build

```sh
[bundle exec] fastlane ios build
```

Build iOS app for local testing

----


## Android

### android release

```sh
[bundle exec] fastlane android release
```

Build and upload Android app to Google Play Store

### android beta

```sh
[bundle exec] fastlane android beta
```

Build and upload Android app to Google Play Store Beta

### android alpha

```sh
[bundle exec] fastlane android alpha
```

Build and upload Android app to Google Play Store Alpha

### android build

```sh
[bundle exec] fastlane android build
```

Build Android app for local testing

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
