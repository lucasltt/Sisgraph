create or replace procedure OFF_CLEAN_FEATURE(pG3E_FNO in number) is

  cursor dataTables(cG3E_FNO number) is
    select c.g3e_table
      from g3e_component c
     where c.g3e_detail = 0
       and g3e_cno in (select g3e_cno
                         from g3e_featurecomponent
                        where g3e_fno = cG3E_FNO)
     group by c.g3e_table;

begin

  -- desabilitar triggers
  for dTable in dataTables(pG3E_FNO) loop
    begin
      execute immediate 'alter table B$' || dTable.g3e_table ||
                        ' disable all triggers';
    
      execute immediate 'delete from B$' || dTable.g3e_table ||
                        ' where g3e_fid in ( select g3e_fid_new from off_fid_map) and g3e_fno = ' ||
                        pG3E_FNO;
      commit;
    
      execute immediate 'alter table B$' || dTable.g3e_table ||
                        ' enable all triggers';
    
    exception
      when others then
        continue;
    end;
  end loop;

  --delete from off_fid_map where g3e_fno = pG3E_FNO;
  --commit;

end OFF_CLEAN_FEATURE;