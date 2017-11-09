create or replace function OFF_ESTIMATE_DELTA(eixo in VARCHAR2)
  return number is
  deltaMX number;
  deltaMY number;
  deltaX  number;
  deltaY  number;

  cursor cGeomTables is
    select g3e_table
      from g3e_component
     where g3e_detail = 0
       and g3e_geometryfield = 'G3E_GEOMETRY';
begin
  deltaMX := 0;
  deltaMY := 0;

  for cGeomTable in cGeomTables loop

    deltaX := 0;
    deltaY := 0;
    dbms_output.put_line(cGeomTable.G3e_Table);

    begin
      execute immediate 'select (max(l.x) - min(l.x)) deltaX, (max(l.y) - min(l.y)) deltaY
      from B$' || cGeomTable.g3e_table || ' k,
           table(sdo_util.GetVertices(sdo_geom.sdo_mbr(k.g3e_geometry))) l'
        into deltaX, deltaY;
    exception
      when others then
        continue;
    end;

    if deltaX > deltaMX then
      deltaMX := deltaX;
    end if;

    if deltaY > deltaMY then
      deltaMY := deltaY;
    end if;

  end loop;

  if eixo = 'X' then
    return deltaMX;
  else
    return deltaMY;
  end if;

end OFF_ESTIMATE_DELTA;