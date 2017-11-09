create or replace procedure OFF_FEATURE_313 is

  --transform

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

  -- desabilitar triggers;

  execute immediate 'alter table B$SWITCH_N disable all triggers';
  execute immediate 'alter table B$SWITCH_PT disable all triggers';
  execute immediate 'alter table B$SWITCH_LB disable all triggers';
  execute immediate 'alter table B$COMMON_N disable all triggers';

  for cCommon in (select g3e_fid
                    from b$common_n
                   where g3e_fno = 313
                  minus
                  select g3e_fid_old from off_fid_map where g3e_fno = 313) loop
    -- gerar novo FID
    new_fid := g3e_fid_seq.nextval;
  
    begin
    
      insert into B$SWITCH_N
        (G3E_FID,
         G3E_ID,
         ANALYSIS_TYPE,
         ATUACAO,
         BAY_NUMBER,
         CIRCUIT2,
         G3E_CID,
         G3E_CNO,
         G3E_FNO,
         LOAD_BREAK,
         LTT_DATE,
         LTT_ID,
         LTT_STATUS,
         LTT_TID,
         MANUFACTURER,
         POSITION_NUMBER,
         RATING,
         SUB_TYPE,
         SWITCH_NUMBER,
         SWITCH_OPERATOR,
         SWITCH_TYPE,
         VOLTAGE_KV)
        select new_fid,
               SWITCH_N_SEQ.NEXTVAL,
               ANALYSIS_TYPE,
               ATUACAO,
               BAY_NUMBER,
               CIRCUIT2,
               G3E_CID,
               G3E_CNO,
               G3E_FNO,
               LOAD_BREAK,
               LTT_DATE,
               LTT_ID,
               LTT_STATUS,
               LTT_TID,
               MANUFACTURER,
               POSITION_NUMBER,
               RATING,
               SUB_TYPE,
               SWITCH_NUMBER,
               SWITCH_OPERATOR,
               SWITCH_TYPE,
               VOLTAGE_KV
          from B$SWITCH_N
         where g3e_fid = cCommon.g3e_fid;
      commit;
    exception
      when others then
        continue;
    end;
  
    begin
    
      insert into B$COMMON_N
        (G3E_FID,
         G3E_ID,
         ABANDON_DATE,
         ASSEMBLYOWNER_ID,
         CONJUNTO_ELETRICO,
         G3E_CID,
         G3E_CNO,
         G3E_FNO,
         GPS_X_COORD,
         GPS_Y_COORD,
         INSTALL_DATE,
         JOB_MODIFY_DATE,
         JOB_MODIFY_NAME,
         JOB_PLACE_DATE,
         JOB_PLACE_NAME,
         LOCATION,
         LTT_DATE,
         LTT_ID,
         LTT_STATUS,
         LTT_TID,
         MUNICIPIO,
         OWNER1_ID,
         OWNER2_ID,
         OWNER_CASING_ID,
         OWNER_ID,
         OWNER_RECT_ID,
         STATE,
         URBANO_RURAL)
        select new_fid,
               COMMON_N_SEQ.NEXTVAL,
               ABANDON_DATE,
               ASSEMBLYOWNER_ID,
               CONJUNTO_ELETRICO,
               G3E_CID,
               G3E_CNO,
               G3E_FNO,
               GPS_X_COORD,
               GPS_Y_COORD,
               INSTALL_DATE,
               JOB_MODIFY_DATE,
               JOB_MODIFY_NAME,
               JOB_PLACE_DATE,
               JOB_PLACE_NAME,
               LOCATION,
               LTT_DATE,
               LTT_ID,
               LTT_STATUS,
               LTT_TID,
               MUNICIPIO,
               OWNER1_ID,
               OWNER2_ID,
               OWNER_CASING_ID,
               OWNER_ID,
               OWNER_RECT_ID,
               STATE,
               URBANO_RURAL
          from B$COMMON_N
         where g3e_fid = cCommon.g3e_fid;
      commit;
    exception
      when others then
        continue;
    end;
  
    begin
    
      select g3e_geometry
        into vGeomOld
        from B$SWITCH_LB
       where g3e_fid = cCommon.g3e_fid
         and rownum = 1;
      commit;
    
      if vGeomOld is null then
        insert into off_Log
        values
          (313,
           cCommon.g3e_fid,
           new_fid,
           'Geometria nula em B$SWITCH_LB para o FID ' || cCommon.g3e_fid);
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
    
      insert into B$SWITCH_LB
        (G3E_FID,
         G3E_ID,
         G3E_GEOMETRY,
         G3E_ALIGNMENT,
         G3E_CID,
         G3E_CNO,
         G3E_FNO,
         LTT_DATE,
         LTT_ID,
         LTT_STATUS,
         LTT_TID)
        select new_fid,
               SWITCH_LB_SEQ.NEXTVAL,
               vGeomNew,
               G3E_ALIGNMENT,
               G3E_CID,
               G3E_CNO,
               G3E_FNO,
               LTT_DATE,
               LTT_ID,
               LTT_STATUS,
               LTT_TID
          from B$SWITCH_LB
         where g3e_fid = cCommon.g3e_fid;
      commit;
    exception
      when others then
        continue;
    end;
  
    begin
    
      select g3e_geometry
        into vGeomOld
        from B$SWITCH_PT
       where g3e_fid = cCommon.g3e_fid
         and rownum = 1;
      commit;
    
      if vGeomOld is null then
        insert into off_Log
        values
          (313,
           cCommon.g3e_fid,
           new_fid,
           'Geometria nula em B$SWITCH_PT para o FID ' || cCommon.g3e_fid);
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
    
      insert into B$SWITCH_PT
        (G3E_FID,
         G3E_ID,
         G3E_GEOMETRY,
         G3E_ALIGNMENT,
         G3E_CID,
         G3E_CNO,
         G3E_FNO,
         LTT_DATE,
         LTT_ID,
         LTT_STATUS,
         LTT_TID)
        select new_fid,
               SWITCH_PT_SEQ.NEXTVAL,
               vGeomNew,
               G3E_ALIGNMENT,
               G3E_CID,
               G3E_CNO,
               G3E_FNO,
               LTT_DATE,
               LTT_ID,
               LTT_STATUS,
               LTT_TID
          from B$SWITCH_PT
         where g3e_fid = cCommon.g3e_fid;
      commit;
    exception
      when others then
        continue;
    end;
  
    --inserir no de-para
    insert into off_fid_map values (313, cCommon.g3e_fid, new_fid);
    commit;
  end loop;

end;
