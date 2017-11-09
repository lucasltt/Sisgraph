create or replace procedure OFF_FEATURES is

  cursor dataTables is
    select c.g3e_table
      from g3e_component c
     where c.g3e_detail = 0
     group by c.g3e_table;

  cursor dataFNO is
    select c.g3e_fno
      from B$COMMON_N c
     group by c.g3e_fno;

begin
  -- limpar tabela de de-para
  off_clean_features;
  execute immediate 'truncate table off_fid_map';

  -- desabilitar triggers
  for dTable in dataTables loop
    begin
      execute immediate 'alter table B$' || dTable.g3e_table ||
                        ' disable all triggers';
    exception
      when others then
        continue;
    end;
  end loop;

  --duplicar
  for dFNO in dataFNO loop
    OFF_FEATURE(dFNO.g3e_fno);
  end loop;

  -- habilitar triggers
  for dTable in dataTables loop
    begin
      execute immediate 'alter table B$' || dTable.g3e_table ||
                        ' enable all triggers';
    exception
      when others then
        continue;
    end;
  end loop;

end OFF_FEATURES;