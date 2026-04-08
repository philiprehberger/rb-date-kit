# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2026-04-09

### Added
- `business_day?` predicate for weekend and holiday-aware checks
- `last_business_day_of_month` for end-of-month business day lookups
- `business_days_in_month` returning all business days within a month
- `nth_business_day_of_month` for ordinal business day selection within a month

## [0.2.0] - 2026-04-03

### Added
- `next_business_day` and `prev_business_day` helpers
- `business_days_in_range` for listing business days in a date range
- `each_business_day` iterator with Enumerator support
- `quarter` method returning quarter number (1-4)

## [0.1.5] - 2026-03-31

### Added
- Add GitHub issue templates, dependabot config, and PR template

## [0.1.4] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.1.3] - 2026-03-26

### Fixed
- Add Sponsor badge to README
- Fix license section link format

## [0.1.2] - 2026-03-24

### Fixed
- Fix stray character in CHANGELOG formatting

## [0.1.1] - 2026-03-22

### Changed
- Update rubocop configuration for Windows compatibility

## [0.1.0] - 2026-03-22

### Added

- Initial release
- Business day counting between two dates
- Business day arithmetic with holiday support
- Quarter boundary calculation (beginning and end)
- Weekend detection
- Natural language relative date parsing ("2 weeks ago", "next month", "yesterday")
