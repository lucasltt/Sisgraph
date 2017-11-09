create or replace procedure OFF_FEATURE_CONN is

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
  execute immediate 'alter table B$CONNECTIVITY_N disable all triggers';

  for cCommon in (select * from off_fid_map) loop
    -- gerar novo FID
  
    begin
      insert into B$CONNECTIVITY_N
        (G3E_FID,
         G3E_ID,
         ACTUAL_STATUS,
         CIRCUIT1,
         CIRCUIT2,
         G3E_CID,
         G3E_CNO,
         G3E_FNO,
         LENGTH,
         LOCATION,
         LTT_DATE,
         LTT_ID,
         LTT_STATUS,
         LTT_TID,
         NODE1_ID,
         NODE2_ID,
         NORMAL_STATUS,
         NUM_CAMPO,
         ORIENTATION,
         PHASE,
         STATE,
         SYSTEM_VOLTAGE,
         TRONCO_RAMAL,
         USER_LENGTH)
        select cCommon.g3e_fid_new,
               CONNECTIVITY_N_SEQ.NEXTVAL,
               ACTUAL_STATUS,
               CIRCUIT1,
               CIRCUIT2,
               G3E_CID,
               G3E_CNO,
               G3E_FNO,
               LENGTH,
               LOCATION,
               LTT_DATE,
               LTT_ID,
               LTT_STATUS,
               LTT_TID,
               decode(NODE1_ID, 0, 0, NODE1_ID + 800000) node2,
               decode(NODE2_ID, 0, 0, NODE2_ID + 800000) node2,
               NORMAL_STATUS,
               NUM_CAMPO,
               ORIENTATION,
               PHASE,
               STATE,
               SYSTEM_VOLTAGE,
               TRONCO_RAMAL,
               USER_LENGTH
          from B$CONNECTIVITY_N
         where g3e_fid = cCommon.g3e_fid_old;
      commit;
    exception
      when others then
        continue;
    end;
  
  end loop;

end;
