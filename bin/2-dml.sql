\qecho import data
\copy people (lon, lat) from data/people_738406.csv csv
--\copy people (lon, lat, quadkey) from data/h.csv csv


\qecho build geometry
update people set geom = st_makepoint( lon, lat );
 
