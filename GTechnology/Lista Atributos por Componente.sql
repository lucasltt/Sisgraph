select x.campo,
       x.atributo,
       x.tipo,
       x.amplitude,
       x.requerido,
       x.lista,
       x.g3e_valuefield,
       x.usado from
(select x.campo,
       x.atributo,
       x.tipo,
       x.amplitude,
       x.requerido,
       p.g3e_table AS lista,
       p.g3e_valuefield,
       'Sí' as Usado
  from (select a.g3e_field as campo,
               a.g3e_username as atributo,
               data_type as tipo,
               data_length as amplitude,
               decode(a.g3e_required, 1, 'Sí', 'No') as requerido,
               nvl(ta.g3e_pno, a.g3e_pno) g3e_pno
          from g3e_feature          f,
               g3e_featurecomponent fc,
               g3e_component        c,
               g3e_attribute        a,
               g3e_tabattribute     ta,
               g3e_dialog           d,
               all_tab_columns      ac
         where f.g3e_fno = fc.g3e_fno
           and f.g3e_username = '&Feature_Username'
           and c.g3e_table = '&Tabla_Componente'
           and fc.g3e_cno = c.g3e_cno
           and a.g3e_cno = c.g3e_cno
           and a.g3e_field not like 'G3E%'
           and a.g3e_ano = ta.g3e_ano
           and ta.g3e_dtno = d.g3e_dtno
           and d.g3e_fno = f.g3e_fno
           and d.g3e_type = 'Edit'
           and upper(c.g3e_table) = ac.table_name
           and upper(a.g3e_field) = ac.column_name) x,
       g3e_picklist p
 where x.g3e_pno = p.g3e_pno(+)

UNION ALL

select x.campo,
       x.atributo,
       x.tipo,
       x.amplitude,
       x.requerido,
       p.g3e_table AS lista,
       p.g3e_valuefield,
       'No' as Usado
  from (select a.g3e_field as campo,
               a.g3e_username as atributo,
               data_type as tipo,
               data_length as amplitude,
               decode(a.g3e_required, 1, 'Sí', 'No') as requerido,
               a.g3e_pno g3e_pno
          from g3e_component c, g3e_attribute a, all_tab_columns ac
         where c.g3e_table = '&Tabla_Componente'
           and a.g3e_cno = c.g3e_cno
           and a.g3e_field not like 'G3E%'
           and upper(c.g3e_table) = ac.table_name
           and upper(a.g3e_field) = ac.column_name) x,
       g3e_picklist p
 where x.g3e_pno = p.g3e_pno(+)
   and x.campo not in
       (select a.g3e_field as campo
          from g3e_feature          f,
               g3e_featurecomponent fc,
               g3e_component        c,
               g3e_attribute        a,
               g3e_tabattribute     ta,
               g3e_dialog           d,
               all_tab_columns      ac
         where f.g3e_fno = fc.g3e_fno
           and f.g3e_username = '&Feature_Username'
           and c.g3e_table = '&Tabla_Componente'
           and fc.g3e_cno = c.g3e_cno
           and a.g3e_cno = c.g3e_cno
           and a.g3e_field not like 'G3E%'
           and a.g3e_ano = ta.g3e_ano
           and ta.g3e_dtno = d.g3e_dtno
           and d.g3e_fno = f.g3e_fno
           and d.g3e_type = 'Edit'
           and upper(c.g3e_table) = ac.table_name
           and upper(a.g3e_field) = ac.column_name)

union all

select column_name                 as campo,
       null                        as atributo,
       data_type                   as tipo,
       data_length                 as amplitude,
       null                        as requerido,
       null                        as lista,
       null                        as g3e_valuefield,
       'No(no hay atributo creado)'
  FROM all_tab_columns
 WHERE TABLE_NAME = '&Tabla_Componente'
   AND COLUMN_NAME NOT LIKE 'G3E%'
   AND COLUMN_NAME NOT IN
       (select a.g3e_field as campo
          from g3e_feature          f,
               g3e_featurecomponent fc,
               g3e_component        c,
               g3e_attribute        a,
               g3e_tabattribute     ta,
               g3e_dialog           d,
               all_tab_columns      ac
         where f.g3e_fno = fc.g3e_fno
           and f.g3e_username = '&Feature_Username'
           and c.g3e_table = '&Tabla_Componente'
           and fc.g3e_cno = c.g3e_cno
           and a.g3e_cno = c.g3e_cno
           and a.g3e_field not like 'G3E%'
           and a.g3e_ano = ta.g3e_ano
           and ta.g3e_dtno = d.g3e_dtno
           and d.g3e_fno = f.g3e_fno
           and d.g3e_type = 'Edit'
           and upper(c.g3e_table) = ac.table_name
           and upper(a.g3e_field) = ac.column_name
        UNION ALL
        select a.g3e_field as campo
          from g3e_component c, g3e_attribute a, all_tab_columns ac
         where c.g3e_table = '&Tabla_Componente'
           and a.g3e_cno = c.g3e_cno
           and a.g3e_field not like 'G3E%'
           and upper(c.g3e_table) = ac.table_name
           and upper(a.g3e_field) = ac.column_name
           and a.g3e_field not in
               (select a.g3e_field as campo
                  from g3e_feature          f,
                       g3e_featurecomponent fc,
                       g3e_component        c,
                       g3e_attribute        a,
                       g3e_tabattribute     ta,
                       g3e_dialog           d,
                       all_tab_columns      ac
                 where f.g3e_fno = fc.g3e_fno
                   and f.g3e_username = '&Feature_Username'
                   and c.g3e_table = '&Tabla_Componente'
                   and fc.g3e_cno = c.g3e_cno
                   and a.g3e_cno = c.g3e_cno
                   and a.g3e_field not like 'G3E%'
                   and a.g3e_ano = ta.g3e_ano
                   and ta.g3e_dtno = d.g3e_dtno
                   and d.g3e_fno = f.g3e_fno
                   and d.g3e_type = 'Edit'
                   and upper(c.g3e_table) = ac.table_name
                   and upper(a.g3e_field) = ac.column_name)))x
                   order by DECODE(USADO, 'Sí', 1, 'No' , 2, 'No(no hay atributo creado)', 3), 
                            CAMPO ASC
