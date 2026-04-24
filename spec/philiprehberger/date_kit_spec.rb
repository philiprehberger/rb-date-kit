# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::DateKit do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be_nil
  end

  describe '.business_days_between' do
    it 'counts business days between two weekdays' do
      monday = Date.new(2026, 3, 16)
      friday = Date.new(2026, 3, 20)
      expect(described_class.business_days_between(monday, friday)).to eq(3)
    end

    it 'skips weekends' do
      friday = Date.new(2026, 3, 20)
      next_monday = Date.new(2026, 3, 23)
      expect(described_class.business_days_between(friday, next_monday)).to eq(0)
    end

    it 'counts a full work week' do
      monday = Date.new(2026, 3, 16)
      next_monday = Date.new(2026, 3, 23)
      expect(described_class.business_days_between(monday, next_monday)).to eq(4)
    end

    it 'returns 0 for same date' do
      date = Date.new(2026, 3, 16)
      expect(described_class.business_days_between(date, date)).to eq(0)
    end

    it 'returns 0 when finish is before start' do
      expect(described_class.business_days_between(Date.new(2026, 3, 20), Date.new(2026, 3, 16))).to eq(0)
    end
  end

  describe '.add_business_days' do
    it 'adds business days forward' do
      monday = Date.new(2026, 3, 16)
      expect(described_class.add_business_days(monday, 5)).to eq(Date.new(2026, 3, 23))
    end

    it 'skips weekends when adding' do
      friday = Date.new(2026, 3, 20)
      expect(described_class.add_business_days(friday, 1)).to eq(Date.new(2026, 3, 23))
    end

    it 'subtracts business days backward' do
      monday = Date.new(2026, 3, 23)
      expect(described_class.add_business_days(monday, -1)).to eq(Date.new(2026, 3, 20))
    end

    it 'skips holidays' do
      monday = Date.new(2026, 3, 16)
      holidays = [Date.new(2026, 3, 17)]
      expect(described_class.add_business_days(monday, 1, holidays: holidays)).to eq(Date.new(2026, 3, 18))
    end

    it 'returns the same date for 0 days' do
      date = Date.new(2026, 3, 16)
      expect(described_class.add_business_days(date, 0)).to eq(date)
    end
  end

  describe '.beginning_of_quarter' do
    it 'returns Jan 1 for Q1' do
      expect(described_class.beginning_of_quarter(Date.new(2026, 2, 15))).to eq(Date.new(2026, 1, 1))
    end

    it 'returns Apr 1 for Q2' do
      expect(described_class.beginning_of_quarter(Date.new(2026, 5, 10))).to eq(Date.new(2026, 4, 1))
    end

    it 'returns Jul 1 for Q3' do
      expect(described_class.beginning_of_quarter(Date.new(2026, 9, 30))).to eq(Date.new(2026, 7, 1))
    end

    it 'returns Oct 1 for Q4' do
      expect(described_class.beginning_of_quarter(Date.new(2026, 12, 25))).to eq(Date.new(2026, 10, 1))
    end
  end

  describe '.end_of_quarter' do
    it 'returns Mar 31 for Q1' do
      expect(described_class.end_of_quarter(Date.new(2026, 1, 15))).to eq(Date.new(2026, 3, 31))
    end

    it 'returns Jun 30 for Q2' do
      expect(described_class.end_of_quarter(Date.new(2026, 5, 10))).to eq(Date.new(2026, 6, 30))
    end

    it 'returns Sep 30 for Q3' do
      expect(described_class.end_of_quarter(Date.new(2026, 8, 1))).to eq(Date.new(2026, 9, 30))
    end

    it 'returns Dec 31 for Q4' do
      expect(described_class.end_of_quarter(Date.new(2026, 11, 1))).to eq(Date.new(2026, 12, 31))
    end
  end

  describe '.weekend?' do
    it 'returns true for Saturday' do
      expect(described_class.weekend?(Date.new(2026, 3, 21))).to be true
    end

    it 'returns true for Sunday' do
      expect(described_class.weekend?(Date.new(2026, 3, 22))).to be true
    end

    it 'returns false for Monday' do
      expect(described_class.weekend?(Date.new(2026, 3, 16))).to be false
    end

    it 'returns false for Friday' do
      expect(described_class.weekend?(Date.new(2026, 3, 20))).to be false
    end
  end

  describe '.next_business_day' do
    it 'returns the next weekday from a weekday' do
      wednesday = Date.new(2026, 3, 18)
      expect(described_class.next_business_day(wednesday)).to eq(Date.new(2026, 3, 19))
    end

    it 'skips to Monday from Friday' do
      friday = Date.new(2026, 3, 20)
      expect(described_class.next_business_day(friday)).to eq(Date.new(2026, 3, 23))
    end

    it 'skips to Monday from Saturday' do
      saturday = Date.new(2026, 3, 21)
      expect(described_class.next_business_day(saturday)).to eq(Date.new(2026, 3, 23))
    end

    it 'skips holidays' do
      wednesday = Date.new(2026, 3, 18)
      holidays = [Date.new(2026, 3, 19)]
      expect(described_class.next_business_day(wednesday, holidays: holidays)).to eq(Date.new(2026, 3, 20))
    end

    it 'skips consecutive holidays' do
      wednesday = Date.new(2026, 3, 18)
      holidays = [Date.new(2026, 3, 19), Date.new(2026, 3, 20)]
      expect(described_class.next_business_day(wednesday, holidays: holidays)).to eq(Date.new(2026, 3, 23))
    end

    it 'skips holiday on weekend (no effect)' do
      friday = Date.new(2026, 3, 20)
      holidays = [Date.new(2026, 3, 21)] # Saturday holiday
      expect(described_class.next_business_day(friday, holidays: holidays)).to eq(Date.new(2026, 3, 23))
    end

    it 'accepts string input' do
      expect(described_class.next_business_day('2026-03-18')).to eq(Date.new(2026, 3, 19))
    end

    it 'accepts Time input' do
      expect(described_class.next_business_day(Time.new(2026, 3, 18))).to eq(Date.new(2026, 3, 19))
    end
  end

  describe '.prev_business_day' do
    it 'returns the previous weekday from a weekday' do
      wednesday = Date.new(2026, 3, 18)
      expect(described_class.prev_business_day(wednesday)).to eq(Date.new(2026, 3, 17))
    end

    it 'skips to Friday from Monday' do
      monday = Date.new(2026, 3, 23)
      expect(described_class.prev_business_day(monday)).to eq(Date.new(2026, 3, 20))
    end

    it 'skips to Friday from Sunday' do
      sunday = Date.new(2026, 3, 22)
      expect(described_class.prev_business_day(sunday)).to eq(Date.new(2026, 3, 20))
    end

    it 'skips holidays' do
      wednesday = Date.new(2026, 3, 18)
      holidays = [Date.new(2026, 3, 17)]
      expect(described_class.prev_business_day(wednesday, holidays: holidays)).to eq(Date.new(2026, 3, 16))
    end

    it 'skips consecutive holidays' do
      wednesday = Date.new(2026, 3, 18)
      holidays = [Date.new(2026, 3, 16), Date.new(2026, 3, 17)]
      expect(described_class.prev_business_day(wednesday, holidays: holidays)).to eq(Date.new(2026, 3, 13))
    end

    it 'accepts string input' do
      expect(described_class.prev_business_day('2026-03-18')).to eq(Date.new(2026, 3, 17))
    end
  end

  describe '.business_days_in_range' do
    it 'returns business days in a normal range' do
      result = described_class.business_days_in_range(Date.new(2026, 3, 16), Date.new(2026, 3, 20))
      expect(result).to eq([
                             Date.new(2026, 3, 16),
                             Date.new(2026, 3, 17),
                             Date.new(2026, 3, 18),
                             Date.new(2026, 3, 19),
                             Date.new(2026, 3, 20)
                           ])
    end

    it 'skips weekends' do
      result = described_class.business_days_in_range(Date.new(2026, 3, 19), Date.new(2026, 3, 24))
      expect(result).to eq([
                             Date.new(2026, 3, 19),
                             Date.new(2026, 3, 20),
                             Date.new(2026, 3, 23),
                             Date.new(2026, 3, 24)
                           ])
    end

    it 'skips holidays' do
      holidays = [Date.new(2026, 3, 18)]
      result = described_class.business_days_in_range(Date.new(2026, 3, 16), Date.new(2026, 3, 20), holidays: holidays)
      expect(result).to eq([
                             Date.new(2026, 3, 16),
                             Date.new(2026, 3, 17),
                             Date.new(2026, 3, 19),
                             Date.new(2026, 3, 20)
                           ])
    end

    it 'returns empty array when start is after finish' do
      expect(described_class.business_days_in_range(Date.new(2026, 3, 20), Date.new(2026, 3, 16))).to eq([])
    end

    it 'returns empty array when range is only weekends' do
      expect(described_class.business_days_in_range(Date.new(2026, 3, 21), Date.new(2026, 3, 22))).to eq([])
    end

    it 'accepts string inputs' do
      result = described_class.business_days_in_range('2026-03-16', '2026-03-17')
      expect(result).to eq([Date.new(2026, 3, 16), Date.new(2026, 3, 17)])
    end
  end

  describe '.each_business_day' do
    it 'yields each business day to the block' do
      days = []
      described_class.each_business_day(Date.new(2026, 3, 16), Date.new(2026, 3, 18)) { |d| days << d }
      expect(days).to eq([Date.new(2026, 3, 16), Date.new(2026, 3, 17), Date.new(2026, 3, 18)])
    end

    it 'returns an Enumerator when no block is given' do
      result = described_class.each_business_day(Date.new(2026, 3, 16), Date.new(2026, 3, 18))
      expect(result).to be_a(Enumerator)
      expect(result.to_a).to eq([Date.new(2026, 3, 16), Date.new(2026, 3, 17), Date.new(2026, 3, 18)])
    end

    it 'skips holidays' do
      holidays = [Date.new(2026, 3, 17)]
      days = described_class.each_business_day(Date.new(2026, 3, 16), Date.new(2026, 3, 18),
                                               holidays: holidays).to_a
      expect(days).to eq([Date.new(2026, 3, 16), Date.new(2026, 3, 18)])
    end
  end

  describe '.quarter' do
    it 'returns 1 for January' do
      expect(described_class.quarter(Date.new(2026, 1, 15))).to eq(1)
    end

    it 'returns 1 for March' do
      expect(described_class.quarter(Date.new(2026, 3, 31))).to eq(1)
    end

    it 'returns 2 for April' do
      expect(described_class.quarter(Date.new(2026, 4, 1))).to eq(2)
    end

    it 'returns 2 for June' do
      expect(described_class.quarter(Date.new(2026, 6, 30))).to eq(2)
    end

    it 'returns 3 for July' do
      expect(described_class.quarter(Date.new(2026, 7, 1))).to eq(3)
    end

    it 'returns 3 for September' do
      expect(described_class.quarter(Date.new(2026, 9, 30))).to eq(3)
    end

    it 'returns 4 for October' do
      expect(described_class.quarter(Date.new(2026, 10, 1))).to eq(4)
    end

    it 'returns 4 for December' do
      expect(described_class.quarter(Date.new(2026, 12, 31))).to eq(4)
    end

    it 'accepts string input' do
      expect(described_class.quarter('2026-05-15')).to eq(2)
    end

    it 'accepts Time input' do
      expect(described_class.quarter(Time.new(2026, 8, 10))).to eq(3)
    end
  end

  describe '.business_day?' do
    it 'returns true for a weekday' do
      expect(described_class.business_day?(Date.new(2026, 3, 18))).to be true
    end

    it 'returns false for a weekend' do
      expect(described_class.business_day?(Date.new(2026, 3, 21))).to be false
    end

    it 'returns false for a holiday' do
      holidays = [Date.new(2026, 3, 18)]
      expect(described_class.business_day?(Date.new(2026, 3, 18), holidays: holidays)).to be false
    end

    it 'accepts string input' do
      expect(described_class.business_day?('2026-03-18')).to be true
    end
  end

  describe '.last_business_day_of_month' do
    it 'returns the last weekday of the month' do
      # March 2026: March 31 is a Tuesday
      expect(described_class.last_business_day_of_month(Date.new(2026, 3, 1))).to eq(Date.new(2026, 3, 31))
    end

    it 'skips weekend at month end' do
      # May 2026: May 31 is Sunday, May 30 is Saturday -> May 29 (Friday)
      expect(described_class.last_business_day_of_month(Date.new(2026, 5, 15))).to eq(Date.new(2026, 5, 29))
    end

    it 'skips holidays at month end' do
      holidays = [Date.new(2026, 3, 31), Date.new(2026, 3, 30)]
      expect(described_class.last_business_day_of_month(Date.new(2026, 3, 1), holidays: holidays))
        .to eq(Date.new(2026, 3, 27))
    end
  end

  describe '.first_business_day_of_month' do
    it 'skips weekend at month start' do
      # March 2026: March 1 is Sunday -> first business day is March 2 (Monday)
      expect(described_class.first_business_day_of_month(Date.new(2026, 3, 15))).to eq(Date.new(2026, 3, 2))
    end

    it 'skips two-day weekend at month start' do
      # August 2026: Aug 1 is Saturday, Aug 2 is Sunday -> first business day is Aug 3 (Monday)
      expect(described_class.first_business_day_of_month(Date.new(2026, 8, 15))).to eq(Date.new(2026, 8, 3))
    end

    it 'returns day 1 when month starts on a weekday' do
      # April 2026: April 1 is Wednesday -> itself is the first business day
      expect(described_class.first_business_day_of_month(Date.new(2026, 4, 15))).to eq(Date.new(2026, 4, 1))
    end

    it 'skips holidays at the start of the month' do
      holidays = [Date.new(2026, 4, 1), Date.new(2026, 4, 2)]
      # Wed/Thu are holidays, Friday April 3 is the first business day
      expect(described_class.first_business_day_of_month(Date.new(2026, 4, 15), holidays: holidays))
        .to eq(Date.new(2026, 4, 3))
    end

    it 'accepts string input' do
      expect(described_class.first_business_day_of_month('2026-08-15')).to eq(Date.new(2026, 8, 3))
    end
  end

  describe '.business_days_in_month' do
    it 'returns all weekdays in March 2026' do
      days = described_class.business_days_in_month(Date.new(2026, 3, 15))
      expect(days.first).to eq(Date.new(2026, 3, 2))
      expect(days.last).to eq(Date.new(2026, 3, 31))
      expect(days.size).to eq(22)
    end

    it 'excludes holidays' do
      holidays = [Date.new(2026, 3, 16)]
      days = described_class.business_days_in_month(Date.new(2026, 3, 15), holidays: holidays)
      expect(days).not_to include(Date.new(2026, 3, 16))
      expect(days.size).to eq(21)
    end
  end

  describe '.nth_business_day_of_month' do
    it 'returns the first business day' do
      # March 2026: March 1 is Sunday, so first business day is March 2
      expect(described_class.nth_business_day_of_month(Date.new(2026, 3, 15), 1)).to eq(Date.new(2026, 3, 2))
    end

    it 'returns the fifth business day' do
      expect(described_class.nth_business_day_of_month(Date.new(2026, 3, 15), 5)).to eq(Date.new(2026, 3, 6))
    end

    it 'accounts for holidays when selecting the nth day' do
      holidays = [Date.new(2026, 3, 2)]
      expect(described_class.nth_business_day_of_month(Date.new(2026, 3, 15), 1, holidays: holidays))
        .to eq(Date.new(2026, 3, 3))
    end

    it 'raises when n exceeds available business days' do
      expect do
        described_class.nth_business_day_of_month(Date.new(2026, 3, 15), 99)
      end.to raise_error(described_class::Error, /only \d+ business days/)
    end

    it 'raises for non-positive n' do
      expect do
        described_class.nth_business_day_of_month(Date.new(2026, 3, 15), 0)
      end.to raise_error(described_class::Error, /positive integer/)
    end
  end

  describe '.parse_relative' do
    let(:reference) { Date.new(2026, 3, 22) }

    it 'parses "today"' do
      expect(described_class.parse_relative('today', relative_to: reference)).to eq(reference)
    end

    it 'parses "yesterday"' do
      expect(described_class.parse_relative('yesterday', relative_to: reference)).to eq(Date.new(2026, 3, 21))
    end

    it 'parses "tomorrow"' do
      expect(described_class.parse_relative('tomorrow', relative_to: reference)).to eq(Date.new(2026, 3, 23))
    end

    it 'parses "3 days ago"' do
      expect(described_class.parse_relative('3 days ago', relative_to: reference)).to eq(Date.new(2026, 3, 19))
    end

    it 'parses "in 5 days"' do
      expect(described_class.parse_relative('in 5 days', relative_to: reference)).to eq(Date.new(2026, 3, 27))
    end

    it 'parses "2 weeks ago"' do
      expect(described_class.parse_relative('2 weeks ago', relative_to: reference)).to eq(Date.new(2026, 3, 8))
    end

    it 'parses "in 1 week"' do
      expect(described_class.parse_relative('in 1 week', relative_to: reference)).to eq(Date.new(2026, 3, 29))
    end

    it 'parses "1 month ago"' do
      expect(described_class.parse_relative('1 month ago', relative_to: reference)).to eq(Date.new(2026, 2, 22))
    end

    it 'parses "in 2 months"' do
      expect(described_class.parse_relative('in 2 months', relative_to: reference)).to eq(Date.new(2026, 5, 22))
    end

    it 'parses "next month"' do
      expect(described_class.parse_relative('next month', relative_to: reference)).to eq(Date.new(2026, 4, 22))
    end

    it 'parses "last month"' do
      expect(described_class.parse_relative('last month', relative_to: reference)).to eq(Date.new(2026, 2, 22))
    end

    it 'parses "next week"' do
      expect(described_class.parse_relative('next week', relative_to: reference)).to eq(Date.new(2026, 3, 29))
    end

    it 'parses "last week"' do
      expect(described_class.parse_relative('last week', relative_to: reference)).to eq(Date.new(2026, 3, 15))
    end

    it 'parses "1 year ago"' do
      expect(described_class.parse_relative('1 year ago', relative_to: reference)).to eq(Date.new(2025, 3, 22))
    end

    it 'parses "next year"' do
      expect(described_class.parse_relative('next year', relative_to: reference)).to eq(Date.new(2027, 3, 22))
    end

    it 'handles month overflow for day clamping' do
      # March 31 minus 1 month should be Feb 28 (not Feb 31)
      expect(described_class.parse_relative('1 month ago',
                                            relative_to: Date.new(2026, 3, 31))).to eq(Date.new(2026, 2, 28))
    end

    it 'raises for unparseable expressions' do
      expect do
        described_class.parse_relative('sometime', relative_to: reference)
      end.to raise_error(described_class::Error)
    end
  end
end
