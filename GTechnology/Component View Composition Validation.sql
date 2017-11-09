declare
  --Cursor para listar quais views estão definidas na g3e_componentviewcomposition
  --mas não estão definidas no código da propria view.
  cursor g3eMinusOracle(c_G3E_VNO g3e_componentviewdefinition.g3e_vno%type) is(
    select c.g3e_table as table_rel
      from g3e_componentviewcomposition cvc
     inner join g3e_component c
        on c.g3e_cno = cvc.g3e_cno
     where cvc.g3e_vno = c_G3E_VNO
    minus
    select ud.referenced_name as table_rel
      from g3e_componentviewdefinition cvd
     inner join user_dependencies ud
        on ud.name = cvd.g3e_view
     where cvd.g3e_vno = c_G3E_VNO
       and ud.referenced_type = 'VIEW');

  --Cursor para listar quais views estão definidas no proprio codigo da view
  --mas não estão definidas na tabela g3e_componentviewcomposition.
  cursor oraMinusG3e(c_G3E_VNO g3e_componentviewdefinition.g3e_vno% type) is(
    select ud.referenced_name as table_rel, cvd.g3e_fno as g3e_fno
      from g3e_componentviewdefinition cvd
     inner join user_dependencies ud
        on ud.name = cvd.g3e_view
     where cvd.g3e_vno = c_G3E_VNO
       and ud.referenced_type = 'VIEW'
     group by ud.referenced_name, cvd.g3e_fno, cvd.g3e_cno)
    minus
    select c.g3e_table as table_rel, cvc.g3e_fno as g3e_fno
      from g3e_componentviewcomposition cvc
     inner join g3e_component c
        on c.g3e_cno = cvc.g3e_cno
     where cvc.g3e_vno = c_G3E_VNO;
  countCVC number(2); --Contagem de dependencias pela g3e_componentviewcomposition (-) dependencias de views pelo proprio código da view
  countVDF number(2); --Contagem de dependencias de views pelo proprio codigo da view (-) dependencias pela g3e_componentviewcomposition
  g3eCNO   g3e_featurecomps_optable.g3e_cno%type;

  type array_t is table of varchar2(200);
  oraMinusG3eFix array_t := array_t();
  g3eMinusOraFix array_t := array_t();
begin
  for c in (select g3e_vno, g3e_view from g3e_componentviewdefinition) loop
    dbms_output.put_line('VIEW: ' || c.g3e_view || ', VNO: ' || c.g3e_vno);
    countCVC := 0;
    countVDF := 0;
  
    for d in g3eMinusOracle(c.g3e_vno) loop
      if countCVC = 0 then
        dbms_output.put_line('Views defined in g3e_componentviewcomposition definition, but not in the view code:');
      end if;
      dbms_output.put_line(chr(9) || '- ' || d.table_rel);
    
      g3eMinusOraFix.extend();
      g3eMinusOraFix(g3eMinusOraFix.LAST) := 'delete from g3e_componentviewcomposition where g3e_vno = ' ||
                                             c.g3e_vno ||
                                             ' and g3e_cno = (select g3e_cno from g3e_component where ' ||
                                             ' g3e_table = ''' ||
                                             d.table_rel || ''');';
    
      countCVC := countCVC + 1;
    end loop;
  
    for e in oraMinusG3e(c.g3e_vno) loop
      if countVDF = 0 then
        dbms_output.put_line('Views defined in the view code, but not on g3e_componentviewcomposition:');
      end if;
      dbms_output.put_line(chr(9) || '- ' || e.table_rel);
    
      execute immediate '
            select g3e_cno
              from g3e_featurecomps_optable
             where g3e_table = ''' ||
                        trim(leading 'V' from e.table_rel) || '''
                and g3e_fno = ' || e.g3e_fno
        into g3eCNO;
      oraMinusG3eFix.extend();
      oraMinusG3eFix(oraMinusG3eFix.LAST) := 'insert into g3e_componentviewcomposition values(' ||
                                             to_char(c.g3e_vno) ||
                                             substr(to_char(g3eCNO), -2, 2) || ', ' ||
                                             c.g3e_vno || ', ' || g3eCNO ||
                                             ', null, sysdate, ' ||
                                             e.g3e_fno || ');';
      countVDF := countVDF + 1;
    end loop;
  
  end loop;

  if oraMinusG3eFix.Count > 0 then
    for i in oraMinusG3eFix.FIRST .. oraMinusG3eFix.LAST loop
      dbms_output.put_line(oraMinusG3eFix(i));
    end loop;
  end if;

  if g3eMinusOraFix.Count > 0 then
    for i in g3eMinusOraFix.FIRST .. g3eMinusOraFix.LAST loop
      dbms_output.put_line(g3eMinusOraFix(i));
    end loop;
  end if;
end;
