# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
  Pliny::Sidekiq::JobLogger to use as Sidekiq job logger `config.options[:job_logger]`

## 0.2.2

### Fixed

- A bug that prevented counts from being tracked

## 0.2.1

### Fixed
- A bug that prevented the server logging middleware from being initialized
  through chain.add.

## 0.2.0

### Changed
- Pliny `0.18.0` or greater is now required.
- Metrics reporting for job and queue counts now use the `Pliny::Metrics` API.

### Removed
- Options for `Pliny::Sidekiq::Middleware::Server::Log` are no longer
  supported, including `metric_prefix`.
