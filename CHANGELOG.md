# Change Log for elk_forwarder
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]
### Added

### Changed

### Removed

## [3.0.2] - 2015-11-05
### Fixed
- Build path to be in file_cache_path

## [3.0.1] - 2015-08-07
### Fixed
- Fix certificate miscommunication

## [3.0.0] - 2015-08-07
### Changed
- Massive refactoring (much of attribute names changed)
- Change test environment name from `_default` to `dev`
- Stop testing on Ubuntu 12.04 

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
