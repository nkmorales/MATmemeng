To run the script, run `rake run` from the command line. You may need to run `bundle install` first.

## Adding new data
To add new data, you need to make sure the column headers that you export from a data source match the ones in this repo. For example, let's say you want to add new data from S2 Netbox (the keycard swipe logs for Matter) to the script. You would start by looking in `lib/data_sources/s2_netbox`. That directory contains a few files, including the input and output for S2 Netbox. You will need to replace the `input.csv` file with the new one that you export from S2 Netbox. Add the new csv file to the directory and call it any name for now. Make sure that the column headers from the new file match the ones in `input.csv`. If they do match, remove `input.csv` and rename the new file to be called `input.csv`. After that, simply run the script with the process described at the top of the README.

If you're curious, each data source folder contains a `.etl` file. This contains the ruby code that determines how to transform each row from the input file into the normalized row that is written to the output file.
