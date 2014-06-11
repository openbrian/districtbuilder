DistrictBuilder
======

Combining Brendan Martin-Anderson's US Census Dotmap with a k-means clustering algorithm to generate voting districts for any US state, in an effort to eliminate gerrymandering.

the process
-----------

Populate a spatial PostgreSQL database with dots for each person, ideally interlopated across blocks.  Run k-means on those dots to generate the districts.

US Census data is available down to the level of the "census block" – in cities these often correlate to city blocks, but elsewhere they may be delineated by other features. (More reading: http://en.wikipedia.org/wiki/Census_block)


requirements
------------

> Using the VM, which automatically installs everything except Processing:
> - VirtualBox (<https://www.virtualbox.org/>)
> - Vagrant (<http://www.vagrantup.com/>)

For the manual method:
- PostgreSQL
- PostGIS
- pl/pgsql
- Python 2.7
- Sqlite3
- The Python GDAL bindings (<http://pypi.python.org/pypi/GDAL/>)
- Other libraries depending on your machine's configuration.

setup
-----

Install the applications required above, depending on your method of choice.

    $ createdb citizens
    $ psql citizens;

    citizens=> create extension postgis;


Clone this repo in the directory of your choice:

    git clone git://github.com/meetar/dotmap.git
A directory called "dotmap" will be created.

> **For the VM way:**  
> Go to the dotmap directory and start the VM:
> 
>     cd dotmap
>     vagrant up
> ...that takes a few minutes on my machine. Then:
> 
> Connect to the VM with ssh, either with an app like PuTTY or through the command line:
> 
>     ssh vagrant@127.0.0.1 -p 2222
>     password: vagrant
>     
> Then change to the shared directory in the VM, which is the same as your local project directory:
> 
>     cd /vagrant
> There you should see the files from this repo.

**For the manual method:**  

I'm doing this the manual way and will document it as i go.


instructions
------------

A preferences file "bin/states" contains a list of the states and their associated numbers, according to the US Census zipfiles. By default, only Alabama is uncommented - uncomment any others you'd like to include in your map. Uncommenting all the states will cause makedots.py to download and process about 17gb of files and could take many hours.

Then, go to the binaries dir and run makedots.py:

    cd bin
    python makedots.py

This will ask your permission to do a few things, in sequence:
 - Download and process the data for each state listed in "states", making a lot of .db files
 - Run 'bash makecsv.sh' to extract all the data from the .db files into a lot of .csv files
 - Run 'bash bashsort.sh' to sort all the .csv files and combine them into "people.csv"

Lastly, /index.html will display the tiles using Google JavaScript mapping API! You can watch the tiles fill in as they finish rendering if you zoom in and out.

> When you're done with your virtual machine, be sure to turn it off by running `vagrant destroy`, the same way you ran `vagrant up`.

<http://twitter.com/openbrian>
<brian@derocher.org>
