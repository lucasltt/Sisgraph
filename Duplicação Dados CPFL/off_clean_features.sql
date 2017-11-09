create or replace procedure OFF_CLEAN_FEATURES is

  cursor dataTables is
    select c.g3e_table
      from g3e_component c
     where c.g3e_detail = 0
     group by c.g3e_table;

begin

  -- desabilitar triggers
  for dTable in dataTables loop
    begin
      execute immediate 'alter table B$' || dTable.g3e_table ||
                        ' disable all triggers';
    
      execute immediate 'delete from B$' || dTable.g3e_table ||
                        ' where g3e_fid in ( select g3e_fid_new from off_fid_map)';
      commit;
      
      execute immediate 'alter table B$' || dTable.g3e_table ||
                        ' enable all triggers';
    
    exception
      when others then
        continue;
    end;
  end loop;


end OFF_CLEAN_FEATURES;