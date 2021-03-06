DistrictBuilder
======

Combining Brendan Martin-Anderson's US Census Dotmap with a k-means clustering algorithm to generate voting districts for any US state, in an effort to eliminate gerrymandering.

the process
-----------

Populate a spatial PostgreSQL database with dots for each person, ideally interlopated across blocks.  Run k-means on those dots to generate the districts.

US Census data is available down to the level of the "census block" – in cities these often correlate to city blocks, but elsewhere they may be delineated by other features. (More reading: http://en.wikipedia.org/wiki/Census_block)


requirements
------------

- PostgreSQL
- PostGIS
- pl/pgsql
- Python 3
- Sqlite3
- The Python GDAL bindings (<http://pypi.python.org/pypi/GDAL/>)

setup
-----

Install the applications required above, depending on your method of choice.

    $ createdb citizens
    $ psql citizens;

    citizens=> create extension postgis;


Clone this repo in the directory of your choice:

    git clone git://github.com/openbrian/districtbuilder.git

A directory called "districtbuilder" will be created.

virtualenv
==========

Install virtualenv at the OS level (apt-get, homebrew, etc).

mkdir myproject
cd myproject
virtualenv -p /usr/bin/python3 venv
source venv/bin/activate

dependencies
============

sudo apt-get update
sudo apt-get install libgdal-dev
export CPLUS_INCLUDE_PATH=/usr/include/gdal
export C_INCLUDE_PATH=/usr/include/gdal
pip install gdal

See https://gis.stackexchange.com/questions/28966/python-gdal-package-missing-header-file-when-installing-via-pip

instructions
------------

A preferences file "bin/states" contains a list of the states and their associated numbers, according to the US Census zipfiles. By default, only Virginia is uncommented - uncomment any others you'd like to include in your map. Uncommenting all the states will cause makedots.py to download and process about 17gb of files and could take many hours.

Then, go to the binaries dir and run makedots.py:

    cd bin
    python makedots.py

This will ask your permission to do a few things, in sequence:
 - Download and process the data for each state listed in "states", making a lot of .db files
 - Run 'bash makecsv.sh' to extract all the data from the .db files into a lot of .csv files
 - Run 'bash bashsort.sh' to sort all the .csv files and combine them into "people.csv"

Lastly, /index.html will display the tiles using Google JavaScript mapping API! You can watch the tiles fill in as they finish rendering if you zoom in and out.

<http://twitter.com/openbrian>
<brian@derocher.org>
