require_relative "test_helper"

class MatchS2NetboxTest < Minitest::Test
  def test_match_envoy
    companies = Company.create_from_file("partners.yml")
    matcher = MatchS2Netbox.new(companies)
    matching_row = {
      company_name_udf: "Abbvie",
      datetime: "2/7/17 15:45"
    }

    non_matching_row = {
      company_name_udf: "McDonalds",
      datetime: "2/7/17 13:05"
    }

    matching_duplicate = {
      company_name_udf: "Abbvie",
      datetime: "2/7/17 21:12"
    }

    assert_equal(matching_row, matcher.process(matching_row))
    assert_nil(matcher.process(non_matching_row))
    assert_nil(matcher.process(matching_duplicate))
  end
end
