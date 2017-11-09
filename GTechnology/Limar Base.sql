DECLARE

BEGIN
  FOR C IN (SELECT TABELA
              FROM (select 'B$' || g3e_table as tabela
                      from g3e_component
                    union all
                    select g3e_table as tabela
                      from g3e_component) A
             INNER JOIN all_all_tables B
                ON A.TABELA = B.table_name
             WHERE B.owner = 'CEMIG') LOOP
  
    BEGIN
      EXECUTE IMMEDIATE 'ALTER TABLE ' || C.TABELA ||
                        ' DISABLE ALL TRIGGERS';
      EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || C.TABELA;
      EXECUTE IMMEDIATE 'ALTER TABLE ' || C.TABELA ||
                        ' ENABLE ALL TRIGGERS';
    
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('EERO EM ' || C.TABELA);
    END;
  
  END LOOP;

  G3E_MANAGEMODLOG.ResetToDatabase;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE LTT_IDENTIFIERS';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE MODIFICATIONLOG';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE PENDINGEDITS';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE LTT_UNDO_LOG';
  EXECUTE IMMEDIATE 'DELETE FROM G3E_JOB';
  EXECUTE IMMEDIATE 'DELETE FROM TRACELOG';
  EXECUTE IMMEDIATE 'DELETE FROM TRACEID';
  EXECUTE IMMEDIATE 'DELETE FROM TRACERESULT';
  COMMIT;
  G3E_MANAGEMODLOG.ResetToDatabase;
  COMMIT;

END;