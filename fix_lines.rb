# This script fixes CSV files that were saved as one line

number_of_fields = 9

data = IO.read(ARGV.first)

fields = data.split(',')

fields.each_with_index do |field, index|
  print field
  if (index + 1) % number_of_fields == 0
    print "\n"
  else
    print ","
  end
end
print "\n"
