/*

aptitude install postgis-doc postgresql-9.3-postgis-2.1
createdb -p 5433 districtbuilder
psql -p 5433 districtbuilder
create extension postgis;
create role brian with login;

psql -p 5433 districtbuilder -1 -f districtbuilder/bin/ddl.sql

*/


drop table if exists people;

create table people
	( lon numeric not null
	, lat numeric not null
--	, quadkey text not null
	, geom geometry (POINT)
	);
