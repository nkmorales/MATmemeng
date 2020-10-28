require "yaml"

class Company
  def self.create_from_file(filename)
    partners = YAML.load_file(filename)

    partners.values.map do |partner|
      Company.new(partner)
    end
  end

  attr_reader :standardized_account_name
  attr_reader :possible_account_names
  attr_reader :domains

  def initialize(attributes)
    @standardized_account_name = attributes["standardized_account_name"]
    @possible_account_names = attributes["possible_account_names"]
    @domains = attributes["domains"]
  end

  def matches?(row, column:, values:)
    return false unless row

    row[column] && values.any? do |value|
      return false if row[column] == ""
      row[column].include?(value)
    end
  end

  def matched_company_name(row, column:)
    possible_account_names.find do |name|
      /#{name}/.match(column).to_s
    end
  end
end

