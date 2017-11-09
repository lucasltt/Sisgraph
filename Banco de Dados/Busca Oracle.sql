declare
  reg number;
begin
  for c in (select TABLE_NAME, COLUMN_NAME
              from all_tab_columns
             where owner = 'CEMIG'
               AND TABLE_NAME LIKE 'G3E_%'
               AND DATA_TYPE = 'VARCHAR2') loop
  execute immediate 'select count(1) from ' || c.table_name || ' where ' ||
                      c.column_name || ' like ''%GC_LOCALIDADE_T%'''
       into reg;
    if reg > 0 then
      dbms_output.put_line('Tabela: ' || c.table_name || ', Coluna: ' ||
                           c.column_name);
    end if;
  end loop;

end;