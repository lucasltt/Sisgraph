declare

  cursor cFID is(
    select g3e_fid from vecon_ses_ln);

  cursor cGEO(pFID number) is(
    select p.column_value as punto
      from vecon_ses_ln k, table(k.g3e_geometry.sdo_ordinates) p
     where k.g3e_fid = pFID);

  xMin number := -77.13308979;
  yMin number := 5.20575569;

  xMax number := -73.53395100;
  yMax number := 9.01148302;

  crd number := 3;

begin

  for elemento in cFid loop
    crd := 1;
  
    for geom in cGEO(elemento.g3e_fid) loop
    
      if crd = 4 then
        crd := 1;
      end if;
    
      if crd = 1 then
        --el x
        if geom.punto < xMin or geom.punto > xMax then
          dbms_output.put_line('Elemento fuera del area: ' ||
                               elemento.g3e_fid);
        end if;
      
      elsif crd = 2 then
        --el y
        if geom.punto < yMin or geom.punto > yMax then
          dbms_output.put_line('Elemento fuera del area: ' ||
                               elemento.g3e_fid);
        end if;
      elsif crd = 3 then
        --el yz
       
      end if;
    
      crd := crd + 1;
    
    end loop;
  
  end loop;

end;
