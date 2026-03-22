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
      expect(described_class.parse_relative('1 month ago', relative_to: Date.new(2026, 3, 31))).to eq(Date.new(2026, 2, 28))
    end

    it 'raises for unparseable expressions' do
      expect { described_class.parse_relative('sometime', relative_to: reference) }.to raise_error(described_class::Error)
    end
  end
end
