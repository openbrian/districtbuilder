CREATE OR REPLACE FUNCTION kluster(
    k integer,
    tab text,
    col text,
    iter integer)
  RETURNS integer AS
$BODY$
declare
    q text;
    upd text;
    i integer;
    kid integer;
    geom_init text;
    pt_x text;
    pt_y text;
begin
    execute 'delete from ' || tab || '_points';
    execute 'delete from ' || tab || '_kluster_points';
    execute 'delete from ' || tab || '_klustering';
    
    -- Identify the cluster.
    q
    := ' insert into ' || tab || '_klustering (k)'
    || ' values (' || k || ')'
    || ' returning id';
    execute q into kid;

    -- Create k random cluster points.
    q
    := ' insert into ' || tab || '_kluster_points (kid, geom)'
    || ' select ' || kid || ', ' || col
    || ' from ' || tab
    || ' order by random()'
    || ' limit ' || k
    || ' returning id';
    execute q;

    upd
    := ' insert into ' || tab || '_points (geom, kp_id)'
--    || ' select geom, nn(geom, 1::real, 2::real, 8, ''' || tab || '_kluster_points''::text, ''id''::text, ''geom''::text )'
    || ' select geom'
    || '      , ('
    || '        select kp.id'
    || '        from ' || tab || '_kluster_points kp'
    || '        order by t.geom <-> kp.geom'
    || '        limit 1'
    || '        )'
    || ' from ' || tab || ' t'
    ;

    -- settle the clusters
    -- TODO: Replace iteration based loop with delta based loop.
    i := 0;
    while i < iter loop
        raise notice 'k % iteration %', k, i;

        -- unassign points from clusters
        delete from people_points;

        -- assign points to clutsers
        execute upd;

        -- update the cluster points
        update people_kluster_points
        set geom = sub.av, num = sub.num
        from
            (
            select kp_id
                 , st_setsrid( st_makepoint( avg(st_x(pts.geom)), avg(st_y(pts.geom)) ), 4269 ) as av
                 , count(kp_id) as num
            from people_points pts
            group by pts.kp_id
            ) as sub
        where id = sub.kp_id;

        i := i + 1;
    end loop;
    return 1;
end
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
