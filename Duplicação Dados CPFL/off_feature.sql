create or replace procedure OFF_FEATURE(pG3E_FNO number) is

  cursor featureComponent(cG3E_FNO number) is
    select min(c.g3e_cno) g3e_cno, c.g3e_table
      from g3e_component c
     where c.g3e_cno in
           (select fc.g3e_cno
              from g3e_featurecomponent fc
             where g3e_fno = cG3e_FNO
               and g3e_cno != 31 -- common_n
               and not exists
             (select g3e_supportcno
                      from g3e_relationship
                     where g3e_supportcno = fc.g3e_cno))
       and c.g3e_detail = 0
     group by c.g3e_table
     order by g3e_cno;

  new_fid  number;
  new_id   number;
  vCount   number;
  vHasGeom number;
  vGeomOld sdo_geometry;
  vGeomNew sdo_geometry;
  vColumns varchar2(900);
  vGTCols  varchar2(150);
  sqlError varchar2(100);

begin

  execute immediate 'truncate table off_log';

  for cCommon in (select g3e_fid
                    from b$common_n
                   where g3e_fno = pG3E_FNO
                  minus
                  select g3e_fid_old
                    from off_fid_map
                   where g3e_fno = pG3E_FNO) loop
    -- gerar novo FID
    new_fid := g3e_fid_seq.nextval;
  
    -- para cada tabela verificar
    for cComponent in featureComponent(pG3E_FNO) loop
      vGTCols  := 'G3E_FID, G3E_ID, ';
      vHasGeom := 0;
    
      --   se o FID existe
      execute immediate 'select count(1) from b$' || cComponent.G3e_Table ||
                        ' where g3e_fid = ' || cCommon.g3e_fid
        into vCount;
    
      if vCount = 0 then
        continue;
      end if;
    
      /*
        --   se a SEQUENCIA para G3E_ID da tabela existe
        execute immediate ' select count(1) from all_sequences where sequence_name = ''' ||
                          cComponent.g3e_table || '_SEQ'''
          into vCount;
      
        if vCount = 0 then
          insert into off_Log
          values
            (pG3E_FNO,
             cCommon.g3e_fid,
             new_fid,
             'A sequencia ' || cComponent.g3e_table || '_SEQ' ||
             ' não foi encontrada para tabela ' || cComponent.G3e_Table);
          commit;
          continue;
        end if;
      */
      select count(1)
        into vHasGeom
        from all_tab_columns
       where column_name = 'G3E_GEOMETRY'
         and table_name = 'B$' || cComponent.g3e_table;
    
      --   se tem GEOMETRIA
      if vHasGeom = 1 then
        execute immediate 'select count(1) from b$' || cComponent.g3e_table ||
                          ' where g3e_fid = ' || cCommon.g3e_fid
          into vCount;
      
        if vCount > 1 then
          insert into off_Log
          values
            (pG3E_FNO,
             cCommon.g3e_fid,
             new_fid,
             'Mais de um FID na tabela b$' || cComponent.g3e_table);
          commit;
        end if;
      
        execute immediate 'select g3e_geometry from b$' ||
                          cComponent.g3e_table || ' where g3e_fid = ' ||
                          cCommon.g3e_fid || ' and rownum = 1'
          into vGeomOld;
      
        if vGeomOld is null then
          insert into off_Log
          values
            (pG3E_FNO,
             cCommon.g3e_fid,
             new_fid,
             'Geometria nula em b$' || cComponent.g3e_table ||
             ' para o FID ' || cCommon.g3e_fid);
          commit;
        
          vGeomNew := vGeomOld;
        else
        
          vGeomNew := SDO_UTIL.AffineTransforms(geometry    => vGeomOld,
                                                translation => 'TRUE',
                                                tx          => 0.0,
                                                ty          => 32000000,
                                                tz          => 0.0,
                                                scaling     => 'FALSE',
                                                psc1        => NULL,
                                                sx          => 0.0,
                                                sy          => 0.0,
                                                sz          => 0.0,
                                                rotation    => 'FALSE',
                                                p1          => NULL,
                                                angle       => 0.0,
                                                dir         => -1,
                                                line1       => NULL,
                                                shearing    => 'FALSE',
                                                shxy        => 0.0,
                                                shyx        => 0.0,
                                                shxz        => 0.0,
                                                shzx        => 0.0,
                                                shyz        => 0.0,
                                                shzy        => 0.0,
                                                reflection  => 'FALSE',
                                                pref        => NULL,
                                                lineR       => NULL,
                                                dirR        => -1,
                                                planeR      => 'FALSE',
                                                n           => NULL,
                                                bigD        => NULL);
        end if;
      
      end if;
    
      --   pegar todas colunas da tabela
      select listagg(column_name, ',') within group(order by column_name)
        into vColumns
        from all_tab_columns
       where table_name = 'B$' || cComponent.g3e_table
         and column_name not in ('G3E_ID', 'G3E_FID', 'G3E_GEOMETRY')
       order by column_name asc;
    
      --  pergar a proxima sequencia da tabels
      execute immediate 'select ' || cComponent.g3e_table ||
                        '_SEQ.NEXTVAL from dual'
        into new_id;
    
      --  inserir no componente
      begin
      
        execute immediate 'insert into B$' || cComponent.g3e_table || '(' ||
                          vGTCols || vColumns || ') select ' || new_fid || ', ' ||
                          new_id || ', ' || vColumns || ' from B$' ||
                          cComponent.g3e_table || ' where g3e_fid = ' ||
                          cCommon.g3e_fid;
        commit;
      
        if vHasGeom = 1 and vGeomNew is not null then
        
          execute immediate 'update B$' || cComponent.g3e_table ||
                            ' set g3e_geometry =  sdo_util.from_gmlgeometry(''' ||
                            sdo_util.to_gmlgeometry(vGeomNew) ||
                            ''') where g3e_fid = ' || new_fid;
          commit;
        
        end if;
      
      exception
        when others then
          sqlError := substr(SQLERRM, 1, 100);
          insert into off_Log
          values
            (pG3E_FNO,
             cCommon.g3e_fid,
             new_fid,
             'Erro em B$' || cComponent.g3e_table || ' - ' || sqlError);
          commit;
      end;
    
    end loop;
  
    --inserir na commom_n
    begin
      select listagg(column_name, ',') within group(order by column_name)
        into vColumns
        from all_tab_columns
       where table_name = 'B$COMMON_N'
         and column_name not in ('G3E_ID', 'G3E_FID', 'G3E_GEOMETRY')
       order by column_name asc;
    
      execute immediate 'insert into B$COMMON_N(' || vGTCols || vColumns ||
                        ') select ' || new_fid || ', ' ||
                        common_n_seq.nextval || ', ' || vColumns ||
                        ' from B$COMMON_N where g3e_fid = ' ||
                        cCommon.g3e_fid;
      commit;
    exception
      when others then
        sqlError := substr(SQLERRM, 1, 100);
        insert into off_Log
        values
          (pG3E_FNO,
           cCommon.g3e_fid,
           new_fid,
           'Erro em B$COMMON_N - ' || sqlError);
        commit;
    end;
  
    --inserir no de-para
    insert into off_fid_map values (pG3E_FNO, cCommon.g3e_fid, new_fid);
    commit;
  end loop;

end OFF_FEATURE;