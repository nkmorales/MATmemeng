require "csv"

class CsvSource
  attr_reader :input_file

  def initialize(input_file)
    @input_file = "lib/data_sources/#{input_file}"
  end

  def each
    CSV.open(input_file, headers: true, header_converters: :symbol,:encoding => 'ISO-8859-1') do |csv|
      csv.each do |row|
        yield(row.to_hash)
      end
    end
  end
end

class CsvDestination
  attr_reader :output_file

  def initialize(output_file)
    @output_file = "lib/data_sources/#{output_file}"
  end

  def write(row)
    @csv ||= CSV.open(output_file, 'w')
    unless @headers_written
      @headers_written = true
      @csv << row.keys
    end
    @csv << row.values
  end

  def close
    begin
      @csv.close
    rescue StandardError
      puts output_file
      puts "Couldn't write file. Mostly likely, there were no matching rows."
    end
  end
end

class SanitizeRow
  def process(row)
    row.each { |key, value| value.strip! && value.tr("\"", "") if value && !value.is_a?(Hash) }
    row
  end
end

class FilterMatchingRows
  attr_reader :companies, :columns_with_values, :memory

  def initialize(companies, columns_with_values:)
    @companies = companies
    @columns_with_values = columns_with_values
    @memory = {}
  end

  def process(row)
    return nil if memory[row.except(:possible_account_identifier).to_s]
    memory[row.to_s] = true

    if companies.any? do |company|
      columns_with_values.any? do |column, value|
        if company.matches?(row, column: column, values: company.send(value))
          row[:matched_company_name] = company.matched_company_name(row, column: :column)
          row[:standardized_account_name] = company.standardized_account_name
        end
      end
    end
    end || row[:possible_account_identifier] = columns_with_values.map do |column, value|
      row[column]
    end.join(", ")

    row
  end
end

class FormatDate
  attr_reader :column

  def initialize(column:)
    @column = column
  end

  def process(row)
    return row if row[column].nil?

    date_format = "%m-%d-%Y"

    begin
      row[column] = DateTime.parse(row[column]).strftime(date_format)
    rescue => e
      sanitized_date_string = /^\d{1,}\/\d{1,}\/\d{2,4}/.match(row[column]).to_s

      year = sanitized_date_string.split("/").last
      if year
        year_format = year.length > 2 ? "%Y" : "%y"
      else
        year_format = "%y"
        # puts "Expected year for:"
        # puts row.inspect
        # puts column.inspect
        # puts e.message
      end


      begin
        row[column] = DateTime.strptime(sanitized_date_string, "%m/%d/#{year_format}")
          .strftime(date_format)
      rescue
        print sanitized_date_string
      end
    end

    row if row[column].split("-").last == "2019"
  end
end


def post_process_record_count(data_source)
  count = 0
  transform do |row|
    count += 1
    row
  end

  post_process do
    puts " "
    puts data_source
    puts "=" * data_source.length
    puts "#{count} rows"
    puts " "
  end
end

class Hash
  def except!(*keys)
    keys.each { |key| delete(key) }
    self
  end

  def except(*keys)
    dup.except!(*keys)
  end
end
