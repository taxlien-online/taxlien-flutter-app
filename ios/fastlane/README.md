fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios release

```sh
[bundle exec] fastlane ios release
```

Build and upload a new release to App Store

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Build and upload a new beta release to TestFlight

### ios build

```sh
[bundle exec] fastlane ios build
```

Build app for local testing

### ios metadata

```sh
[bundle exec] fastlane ios metadata
```

Update app metadata

### ios download_metadata

```sh
[bundle exec] fastlane ios download_metadata
```

Download existing metadata and screenshots from App Store

### ios submit

```sh
[bundle exec] fastlane ios submit
```

Submit app for review

### ios release_auto

```sh
[bundle exec] fastlane ios release_auto
```

Release app automatically after approval

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
