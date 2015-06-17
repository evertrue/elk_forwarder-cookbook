# Change Log for elk_forwarder
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]
### Added

### Changed

### Removed

## [2.0.0] - 2015-06-16
### Changed
- Breaking: All Configuration to just be through attributes, no LWRP unfortunately
- Breaking: The `['config']['files']` attribute has been changed from an array to a hash
- Added a mocking mode for running tests

### Removed
- The `logstash_forwarder_log` LWRP as it was causing problematic race conditions

## [1.0.0] - 2015-04-27
### Added
- Initial Release

[unreleased]: https://github.com/evertrue/elk_forwarder-cookbook/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/evertrue/elk_forwarder-cookbook/tree/v1.0.0
