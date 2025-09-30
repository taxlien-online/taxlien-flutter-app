fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android release

```sh
[bundle exec] fastlane android release
```

Build and upload a new release to Google Play Store

### android beta

```sh
[bundle exec] fastlane android beta
```

Build and upload a new beta release to Google Play Store

### android alpha

```sh
[bundle exec] fastlane android alpha
```

Build and upload a new alpha release to Google Play Store

### android build

```sh
[bundle exec] fastlane android build
```

Build app for local testing

### android metadata

```sh
[bundle exec] fastlane android metadata
```

Update app metadata

### android download_metadata

```sh
[bundle exec] fastlane android download_metadata
```

Download existing metadata and screenshots from Google Play Store

### android promote_alpha_to_beta

```sh
[bundle exec] fastlane android promote_alpha_to_beta
```

Promote alpha to beta

### android promote_beta_to_production

```sh
[bundle exec] fastlane android promote_beta_to_production
```

Promote beta to production

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
