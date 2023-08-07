require 'rails_helper'

RSpec.describe HolidayHelper, type: :helper do
  describe '#upcoming_us_holidays' do
    it 'returns upcoming US holidays' do
      holidays_data = [
        { 'date' => '2023-08-15', 'name' => 'Holiday 1' },
        { 'date' => '2023-08-16', 'name' => 'Holiday 2' },
        { 'date' => '2023-08-17', 'name' => 'Holiday 3' },
        { 'date' => '2023-08-18', 'name' => 'Holiday 4' },
        { 'date' => '2023-08-19', 'name' => 'Holiday 5' },
        { 'date' => '2023-08-20', 'name' => 'Holiday 6' },
        { 'date' => '2023-08-21', 'name' => 'Holiday 7' },
        { 'date' => '2023-08-22', 'name' => 'Holiday 8' },
      ]

      allow_any_instance_of(described_class).to receive(:fetch_upcoming_holidays).and_return(holidays_data)

      result = helper.upcoming_us_holidays

      expect(result).to eq(holidays_data.first(3))
    end

    it 'returns specified number of upcoming US holidays' do
      holidays_data = [
        { 'date' => '2023-08-15', 'name' => 'Holiday 1' },
        { 'date' => '2023-08-16', 'name' => 'Holiday 2' }
      ]

      allow_any_instance_of(described_class).to receive(:fetch_upcoming_holidays).and_return(holidays_data)

      result = helper.upcoming_us_holidays(1)

      expect(result).to eq([holidays_data.first])
    end
  end
end
