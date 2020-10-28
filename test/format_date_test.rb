require_relative "test_helper"

class FormatDateTest < Minitest::Test
  def test_date_formatting
    formatter = FormatDate.new(column: :date)
    date_strings = [
      "Jan 31, 2019 at 7:00 PM",
      "1/26/2017 5:30 PM",
      "1/1/2017",
      "01/13/2017 5:00pm",
      "2/28/17 23:53",
      "2017-01-03 15:00:17"
    ]

    rows = date_strings.map { |date_string| { date: date_string } }

    result = rows.map do |row|
      formatter.process(row)
    end

    assert_equal(
      ["01-31-2019", "01-26-2017", "01-01-2017", "01-13-2017", "02-28-2017", "01-03-2017"],
      result.flat_map(&:values)
    )
  end
end
