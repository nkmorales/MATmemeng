require_relative "test_helper"

class FilterMatchingRowsTest < Minitest::Test
  def setup
    @companies = Company.create_from_file("partners.yml")
  end

  def test_match_envoy
    matcher = FilterMatchingRows.new(
      @companies,
      columns_with_values: { your_company: :possible_account_names,
                             your_email_address: :domains }
    )

    matching_row_both = {
      your_company: "Abbvie",
      your_email_address: "example@abbvie.com"
    }

    matching_row_company = {
      your_company: "Abbvie",
      your_email_address: "example@gmail.com"
    }

    matching_row_email = {
      your_company: "Sturdy",
      your_email_address: "example@abbvie.com"
    }

    non_matching_row = {
      your_company: "McDonalds",
      your_email_address: "example@mcdonalds.com"
    }


    assert_equal(matching_row_both, matcher.process(matching_row_both))
    assert_equal(matching_row_company, matcher.process(matching_row_company))
    assert_equal(matching_row_email, matcher.process(matching_row_email))
    assert_nil(matcher.process(non_matching_row))
  end

  def test_match_event_campaigns
    matcher = FilterMatchingRows.new(
      @companies,
      columns_with_values: { event_host: :possible_account_names }
    )

    matching_row = {
      event_host: "Abbvie"
    }

    non_matching_row = {
      event_host: "McDonalds"
    }

    assert_equal(matching_row, matcher.process(matching_row))
    assert_nil(matcher.process(non_matching_row))
  end

  def test_match_google_calendar
    companies = Company.create_from_file("partners.yml")
    matcher = FilterMatchingRows.new(
      @companies,
      columns_with_values: {
        title: :possible_account_names,
        all_attendees: :domains
      }
    )

    matching_row_both = {
      title: "Abbvie",
      all_attendees: "example@abbvie.com"
    }

    matching_row_company = {
      title: "Abbvie",
      all_attendees: "example@gmail.com"
    }

    matching_row_email = {
      title: "Sturdy",
      all_attendees: "example@abbvie.com"
    }

    non_matching_row = {
      title: "McDonalds",
      all_attendees: "example@mcdonalds.com"
    }


    assert_equal(matching_row_both, matcher.process(matching_row_both))
    assert_equal(matching_row_company, matcher.process(matching_row_company))
    assert_equal(matching_row_email, matcher.process(matching_row_email))
    assert_nil(matcher.process(non_matching_row))
  end
end
