# philiprehberger-date_kit

[![Tests](https://github.com/philiprehberger/rb-date-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-date-kit/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-date_kit.svg)](https://rubygems.org/gems/philiprehberger-date_kit)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-date-kit)](https://github.com/philiprehberger/rb-date-kit/commits/main)

Date utilities for business days, relative expressions, and period calculations

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-date_kit"
```

Or install directly:

```bash
gem install philiprehberger-date_kit
```

## Usage

```ruby
require "philiprehberger/date_kit"

Philiprehberger::DateKit.business_days_between(Date.new(2026, 3, 16), Date.new(2026, 3, 23))
# => 4
```

### Adding Business Days

```ruby
Philiprehberger::DateKit.add_business_days(Date.new(2026, 3, 20), 3)
# => 2026-03-25 (skips weekend)

holidays = [Date.new(2026, 3, 23)]
Philiprehberger::DateKit.add_business_days(Date.new(2026, 3, 20), 1, holidays: holidays)
# => 2026-03-24 (skips weekend and holiday)
```

### Next / Previous Business Day

```ruby
Philiprehberger::DateKit.next_business_day(Date.new(2026, 3, 20))
# => 2026-03-23 (skips weekend)

Philiprehberger::DateKit.prev_business_day(Date.new(2026, 3, 23))
# => 2026-03-20 (skips weekend)

holidays = [Date.new(2026, 3, 23)]
Philiprehberger::DateKit.next_business_day(Date.new(2026, 3, 20), holidays: holidays)
# => 2026-03-24 (skips weekend and holiday)
```

### Business Days in Range

```ruby
Philiprehberger::DateKit.business_days_in_range(Date.new(2026, 3, 16), Date.new(2026, 3, 20))
# => [2026-03-16, 2026-03-17, 2026-03-18, 2026-03-19, 2026-03-20]

Philiprehberger::DateKit.each_business_day(Date.new(2026, 3, 16), Date.new(2026, 3, 20)) do |date|
  puts date
end

# Without a block, returns an Enumerator
enum = Philiprehberger::DateKit.each_business_day(Date.new(2026, 3, 16), Date.new(2026, 3, 20))
enum.map { |d| d.strftime('%A') }
```

### Quarter Boundaries

```ruby
Philiprehberger::DateKit.quarter(Date.new(2026, 5, 15))
# => 2

Philiprehberger::DateKit.beginning_of_quarter(Date.new(2026, 5, 15))
# => 2026-04-01

Philiprehberger::DateKit.end_of_quarter(Date.new(2026, 5, 15))
# => 2026-06-30
```

### Relative Date Parsing

```ruby
Philiprehberger::DateKit.parse_relative('2 weeks ago')
Philiprehberger::DateKit.parse_relative('next month')
Philiprehberger::DateKit.parse_relative('yesterday')
Philiprehberger::DateKit.parse_relative('in 3 days')
```

### Weekend Detection

```ruby
Philiprehberger::DateKit.weekend?(Date.new(2026, 3, 21)) # => true (Saturday)
Philiprehberger::DateKit.weekend?(Date.new(2026, 3, 20)) # => false (Friday)
```

## API

| Method | Description |
|--------|-------------|
| `.business_days_between(start, finish)` | Count business days between two dates |
| `.add_business_days(date, n, holidays:)` | Add business days, skipping weekends and holidays |
| `.next_business_day(date, holidays:)` | Return the next business day after the given date |
| `.prev_business_day(date, holidays:)` | Return the previous business day before the given date |
| `.business_days_in_range(start, finish, holidays:)` | Return array of business days in a date range |
| `.each_business_day(start, finish, holidays:, &block)` | Iterate business days with Enumerator support |
| `.quarter(date)` | Return the quarter number (1-4) for the given date |
| `.beginning_of_quarter(date)` | Return the first day of the quarter |
| `.end_of_quarter(date)` | Return the last day of the quarter |
| `.weekend?(date)` | Check if a date falls on a weekend |
| `.parse_relative(str, relative_to:)` | Parse a relative date expression |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-date-kit)

🐛 [Report issues](https://github.com/philiprehberger/rb-date-kit/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-date-kit/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)
