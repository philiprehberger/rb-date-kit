# frozen_string_literal: true

require 'date'
require_relative 'date_kit/version'

module Philiprehberger
  module DateKit
    class Error < StandardError; end

    # Count business days (Mon-Fri) between two dates, exclusive of both endpoints
    #
    # @param start_date [Date] the start date
    # @param finish_date [Date] the end date
    # @return [Integer] number of business days between the dates
    def self.business_days_between(start_date, finish_date)
      start_date = coerce_date(start_date)
      finish_date = coerce_date(finish_date)

      return 0 if start_date >= finish_date

      count = 0
      current = start_date + 1
      while current < finish_date
        count += 1 unless weekend?(current)
        current += 1
      end
      count
    end

    # Add business days to a date, skipping weekends and holidays
    #
    # @param date [Date] the starting date
    # @param days [Integer] number of business days to add
    # @param holidays [Array<Date>] optional list of holiday dates to skip
    # @return [Date] the resulting date
    def self.add_business_days(date, days, holidays: [])
      date = coerce_date(date)
      holidays = holidays.map { |h| coerce_date(h) }

      raise Error, 'days must be an integer' unless days.is_a?(Integer)

      direction = days.positive? ? 1 : -1
      remaining = days.abs
      current = date

      while remaining.positive?
        current += direction
        next if weekend?(current) || holidays.include?(current)

        remaining -= 1
      end

      current
    end

    # Return the first day of the quarter containing the given date
    #
    # @param date [Date] the input date
    # @return [Date] the first day of the quarter
    def self.beginning_of_quarter(date)
      date = coerce_date(date)
      quarter_month = (((date.month - 1) / 3) * 3) + 1
      Date.new(date.year, quarter_month, 1)
    end

    # Return the last day of the quarter containing the given date
    #
    # @param date [Date] the input date
    # @return [Date] the last day of the quarter
    def self.end_of_quarter(date)
      date = coerce_date(date)
      quarter_month = (((date.month - 1) / 3) * 3) + 3
      Date.new(date.year, quarter_month, -1)
    end

    # Check if a date falls on a weekend (Saturday or Sunday)
    #
    # @param date [Date] the date to check
    # @return [Boolean]
    def self.weekend?(date)
      date = coerce_date(date)
      date.saturday? || date.sunday?
    end

    # Parse a relative date expression into a Date
    #
    # @param str [String] the expression (e.g., "2 weeks ago", "next month", "yesterday")
    # @param relative_to [Date] the reference date (defaults to today)
    # @return [Date] the parsed date
    # @raise [Error] if the expression cannot be parsed
    def self.parse_relative(str, relative_to: Date.today)
      relative_to = coerce_date(relative_to)
      normalized = str.to_s.strip.downcase

      case normalized
      when 'today'
        relative_to
      when 'yesterday'
        relative_to - 1
      when 'tomorrow'
        relative_to + 1
      when /\A(\d+)\s+days?\s+ago\z/
        relative_to - ::Regexp.last_match(1).to_i
      when /\Ain\s+(\d+)\s+days?\z/
        relative_to + ::Regexp.last_match(1).to_i
      when /\A(\d+)\s+weeks?\s+ago\z/
        relative_to - (::Regexp.last_match(1).to_i * 7)
      when /\Ain\s+(\d+)\s+weeks?\z/
        relative_to + (::Regexp.last_match(1).to_i * 7)
      when /\A(\d+)\s+months?\s+ago\z/
        months_ago(relative_to, ::Regexp.last_match(1).to_i)
      when /\Ain\s+(\d+)\s+months?\z/
        months_ahead(relative_to, ::Regexp.last_match(1).to_i)
      when /\A(\d+)\s+years?\s+ago\z/
        years_ago(relative_to, ::Regexp.last_match(1).to_i)
      when /\Ain\s+(\d+)\s+years?\z/
        years_ahead(relative_to, ::Regexp.last_match(1).to_i)
      when 'last week'
        relative_to - 7
      when 'next week'
        relative_to + 7
      when 'last month'
        months_ago(relative_to, 1)
      when 'next month'
        months_ahead(relative_to, 1)
      when 'last year'
        years_ago(relative_to, 1)
      when 'next year'
        years_ahead(relative_to, 1)
      else
        raise Error, "cannot parse relative date: #{str}"
      end
    end

    # @api private
    def self.months_ago(date, n)
      target_month = date.month - n
      target_year = date.year
      while target_month < 1
        target_month += 12
        target_year -= 1
      end
      day = [date.day, days_in_month(target_year, target_month)].min
      Date.new(target_year, target_month, day)
    end

    # @api private
    def self.months_ahead(date, n)
      target_month = date.month + n
      target_year = date.year
      while target_month > 12
        target_month -= 12
        target_year += 1
      end
      day = [date.day, days_in_month(target_year, target_month)].min
      Date.new(target_year, target_month, day)
    end

    # @api private
    def self.years_ago(date, n)
      target_year = date.year - n
      day = [date.day, days_in_month(target_year, date.month)].min
      Date.new(target_year, date.month, day)
    end

    # @api private
    def self.years_ahead(date, n)
      target_year = date.year + n
      day = [date.day, days_in_month(target_year, date.month)].min
      Date.new(target_year, date.month, day)
    end

    # @api private
    def self.days_in_month(year, month)
      Date.new(year, month, -1).day
    end

    # @api private
    def self.coerce_date(value)
      case value
      when Date then value
      when Time then value.to_date
      when String then Date.parse(value)
      else
        raise Error, "cannot coerce #{value.class} to Date"
      end
    end

    private_class_method :months_ago, :months_ahead, :years_ago, :years_ahead, :days_in_month, :coerce_date
  end
end
