
drop table EAM_ACTIVOS_RETIRADOS;
create table EAM_ACTIVOS_RETIRADOS
(
  circuito      VARCHAR2(50),
  g3e_fid       NUMBER(10),
  g3e_fno       NUMBER(10),
  activo_nombre VARCHAR2(50),
  ubicacion     VARCHAR2(100),
  nivel         NUMBER,
  fid_padre     NUMBER,
  activo        NUMBER,
  ordem         NUMBER
);

--Tabla de ubicaciones retiradas
drop table EAM_UBICACION_RETIRADOS;
CREATE TABLE EAM_UBICACION_RETIRADOS
(
  CIRCUITO          VARCHAR2(50 BYTE),
  G3E_FID           NUMBER(10),
  G3E_FNO           NUMBER(5),
  CODIGO            VARCHAR2(100 BYTE),
  UBICACION         VARCHAR2(100 BYTE),
  NIVEL             NUMBER,
  NIVEL_SUPERIOR    VARCHAR2(100 BYTE),
  CODIGO_UBICACION  VARCHAR2(30 BYTE),
  DESCRIPCION       VARCHAR2(100 BYTE)
);



--CREACION DE TABLAS DE RESPALDO DE TAXONOMIA
drop table EAM_ACTIVOS_BK;
CREATE TABLE EAM_ACTIVOS_BK
(
  CIRCUITO       VARCHAR2(50 BYTE),
  G3E_FID        NUMBER(10),
  G3E_FNO        NUMBER(10),
  ACTIVO_NOMBRE  VARCHAR2(50 BYTE),
  UBICACION      VARCHAR2(100 BYTE),
  NIVEL          NUMBER,
  FID_PADRE      NUMBER,
  ACTIVO         NUMBER,
  ORDEM          NUMBER
);

drop table EAM_ACTIVOS_RETIRADOS_BK;
CREATE TABLE EAM_ACTIVOS_RETIRADOS_BK
(
  CIRCUITO       VARCHAR2(50 BYTE),
  G3E_FID        NUMBER(10),
  G3E_FNO        NUMBER(10),
  ACTIVO_NOMBRE  VARCHAR2(50 BYTE),
  UBICACION      VARCHAR2(100 BYTE),
  NIVEL          NUMBER,
  FID_PADRE      NUMBER,
  ACTIVO         NUMBER,
  ORDEM          NUMBER
);

drop table EAM_UBICACION_BK;
CREATE TABLE EAM_UBICACION_BK
(
  CIRCUITO          VARCHAR2(50 BYTE),
  G3E_FID           NUMBER(10),
  G3E_FNO           NUMBER(5),
  CODIGO            VARCHAR2(100 BYTE),
  UBICACION         VARCHAR2(100 BYTE),
  NIVEL             NUMBER,
  NIVEL_SUPERIOR    VARCHAR2(100 BYTE),
  CODIGO_UBICACION  VARCHAR2(30 BYTE),
  DESCRIPCION       VARCHAR2(100 BYTE)
);

drop table EAM_UBICACION_RETIRADOS_BK;
CREATE TABLE EAM_UBICACION_RETIRADOS_BK
(
  CIRCUITO          VARCHAR2(50 BYTE),
  G3E_FID           NUMBER(10),
  G3E_FNO           NUMBER(5),
  CODIGO            VARCHAR2(100 BYTE),
  UBICACION         VARCHAR2(100 BYTE),
  NIVEL             NUMBER,
  NIVEL_SUPERIOR    VARCHAR2(100 BYTE),
  CODIGO_UBICACION  VARCHAR2(30 BYTE),
  DESCRIPCION       VARCHAR2(100 BYTE)
);

drop table EAM_CIRCUITOS_BK;
CREATE TABLE EAM_CIRCUITOS_BK
(
  CIRCUITO          VARCHAR2(50 BYTE),
  STATUS            VARCHAR2(150 BYTE),
  AVANCE            VARCHAR2(50 BYTE),
  TIEMPO            VARCHAR2(50 BYTE),
  GRUPO             NUMBER(2) DEFAULT 0,
  FECHA_CONCLUSION  DATE
);

drop table EAM_ERRORS_BK;
CREATE TABLE EAM_ERRORS_BK
(
  CIRCUITO     VARCHAR2(50 BYTE),
  G3E_FID      NUMBER(10),
  G3E_FNO      NUMBER(10),
  FECHA        DATE,
  DESCRIPCION  VARCHAR2(300 BYTE)
);



create index idx_activos_fid_cir on eam_activos(circuito, g3e_fid);



--Creacion de 10 jobs para ejecutar taxonomia de circuitos
begin
  for cont in 1 .. 10 LOOP
    sys.dbms_scheduler.create_job(job_name        => 'GENERGIA.EAM_TAX_CIRCUITOS_G' ||
                                                     to_char(cont) ||
                                                     '_JOB',
                                  job_type        => 'PLSQL_BLOCK',
                                  job_action      => 'BEGIN EAM_EPM.EAM_FLUJO_CIRS(' ||
                                                     to_char(cont) ||
                                                     '); END;',
                                  start_date      => to_date('14-09-2014 00:00:00',
                                                             'dd-mm-yyyy hh24:mi:ss'),
                                  repeat_interval => 'FREQ=DAILY;BYDAY=MON,TUE,WED,THU,FRI;BYHOUR=11;BYMINUTE=0;BYSECOND=0',
                                  end_date        => to_date(null),
                                  job_class       => 'DEFAULT_JOB_CLASS',
                                  enabled         => false,
                                  auto_drop       => false,
                                  comments        => 'Job de Taxonomia EAM  de Circuitos - Grupo' ||
                                                     to_char(cont));
  end loop;
end;
/
