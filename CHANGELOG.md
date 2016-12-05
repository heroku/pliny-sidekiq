# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added

### Changed
- Pliny `0.18.0` or greater is now required.
- Metrics reporting for job queue counts now use the `Pliny::Metrics` API.

### Removed
- the `metrics-prefix` option is no longer supported for
  `Pliny::Sidekiq::Middleware::Server::Log`.
