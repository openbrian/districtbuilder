#!/bin/bash

cd ../data/
for f in *.db
do 
	echo $f
	sqlite3 -csv $f "select x,y from people" > $f.csv
done

