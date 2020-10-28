require "csv"

def csv_headers
  %w(
    standardized_account_name
    company
    possible_account_identifier
    person
    email
    capture_date
    engagement_bucket
    data_capture_type
    data_source
    data
  )
end

files = Dir.glob("./**/output*.csv")
file_contents = files.map { |f| CSV.read(f) }

record_count = 0

csv_string = CSV.generate do |csv|
  csv << csv_headers
  file_contents.each do |file|
    file.shift                  # remove the headers of each file
    file.each do |row|
      record_count += 1
      csv << row
    end
  end
end

File.open("main_output.csv", "w") { |f| f << csv_string }
puts "#{record_count} records in main_output.csv."
