
SET echo ON;

SPOOL GC_ENDERECOS_MULTIPLOS.log;


----------------------------------------------------------------------------------------------------------
--   PASSO 1: Criação das tabelas utilizadas pela feature. Devemos ter uma tabela para o componente GC_ENDERECOS_MULTIPLOS
----------------------------------------------------------------------------------------------------------

--   Criando tabela do componente connection

CREATE TABLE GC_ENDERECOS_MULTIPLOS
(
  G3E_ID        NUMBER(10)                      NOT NULL,
  G3E_FNO       NUMBER(5)                       NOT NULL,
  G3E_FID       NUMBER(10)                      NOT NULL,
  G3E_CNO       NUMBER(5)                       NOT NULL,
  G3E_CID       NUMBER(10)                      NOT NULL,
  LOGRADOURO    VARCHAR2(30)			NOT NULL,
  NUM_INICIAL   NUMBER(5)			NOT NULL,
  NUM_FINAL     NUMBER(5)			NOT NULL,
  LADO          VARCHAR2(50)			NOT NULL
);

  

--------------------------------------------------------------------------------------------
--   PASSO 2: Registrar os componentes criados na tabela de definição de componentes 
----------------------------------------------------------------------------------------------------------

--  Componente de Atributos
INSERT INTO G3E_COMPONENT ( G3E_CNO, G3E_USERNAME, G3E_NAME, G3E_TOOLTIP, G3E_TYPE, G3E_GEOMETRYTYPE, G3E_TABLE,
G3E_DETAIL, G3E_ALIGNMENTFIELD, G3E_DCNO, G3E_DTNO,   G3E_GEOMETRYFIELD, G3E_SUBSETATTRIBUTE, G3E_EDITDATE, G3E_SUBTYPE, G3E_LOCALECOMMENT, G3E_LRNO,
G3E_PARTITIONATTRIBUTE, G3E_LTT ) VALUES (
80, 'Componente de Endereços Múltiplos', 'GC_ENDERECOS_MULTIPLOS', 'Componente de Endereços Múltiplos', 1, null, 'GC_ENDERECOS_MULTIPLOS'
, 0, NULL, 31, NULL, NULL, NULL, SYSDATE, NULL, NULL, NULL, NULL, 1);


COMMIT;

----------------------------------------------------------------------------------------------------------
--   PASSO 3: Associar os componentes à feature correspondente
----------------------------------------------------------------------------------------------------------

-- G3E_FNO = 11800 
INSERT INTO G3E_FEATURECOMPONENT ( G3E_FCNO, G3E_FNO, G3E_CNO, G3E_REQUIRED, G3E_REPEATING, G3E_AUTOREPEAT,
 G3E_PINO, G3E_ORDINAL, G3E_INTERFACEARGUMENT, G3E_DERIVEDFROMCNO, G3E_INSERTORDINAL, G3E_DELETEORDINAL, G3E_REFRESH, G3E_ALTERNATEREQUIREDCNO, G3E_REPLACE, G3E_EDITDATE, G3E_BREAKACTION,
 G3E_COMPONENTELIMINATION, G3E_COMPONENTASSIGNMENT, G3E_COMPONENTADJUSTMENT, G3E_GEOPROXIMITYTOLERANCE, G3E_BREAKLINEARCNO, G3E_ALTERNATEGEOGRAPHIC, G3E_ALTERNATEGEOORDINAL, G3E_RINO, G3E_RIARGGROUPNO, G3E_INCLUDEINPLACEMENT,G3E_MERGEMAXDISTANCE, G3E_MERGECOMMONPRECOND, G3E_MERGEPRECOND, G3E_MERGEOCCURRENCES, G3E_MERGERINO, G3E_MERGERIARGGROUPNO, G3E_CCNO, G3E_GENERATE)
VALUES (11880, 11800, 80, 0, 1, 0, 7, 80, NULL, NULL, 80, 80, 0, NULL, 1, SYSDATE, 1, 3, 4, 3, 1, NULL, 0, 0, NULL, NULL, 1, NULL, NULL, NULL, 1, NULL, NULL, NULL, 0);
  
COMMIT;


---------------------------------------------------------------------------------------------------------
--   PASSO 3: Definir os atributos da component
----------------------------------------------------------------------------------------------------------
INSERT INTO G3E_ATTRIBUTE ( G3E_ANO, G3E_CNO, G3E_VNO, G3E_FIELD, G3E_USERNAME, G3E_FORMAT,G3E_PRECISION, G3E_DOMAINTABLE, G3E_DOMAINFIELD, G3E_REQUIRED, G3E_FINO, G3E_FUNCTIONALORDINAL, G3E_FUNCTIONALTYPE, G3E_INTERFACEARGUMENT, G3E_TOOLTIP, G3E_FOREIGNKEYTABLE, G3E_FOREIGNKEYFIELD, G3E_HYPERTEXT,  G3E_PNO, G3E_COPY, G3E_EXCLUDEFROMEDIT, G3E_DATATYPE, G3E_ADDITIONALREFFIELDS, G3E_IMPORTFIELD, G3E_EXCLUDEFROMREPLACE, G3E_EDITDATE, G3E_WIDTHINTWIPS, G3E_CATALOGCOPYVALUE, G3E_LOCALECOMMENT, G3E_BREAKCOPY, G3E_COPYATTRIBUTE, G3E_WRAPTEXT, G3E_MERGEEXPRESSION, G3E_RINO, G3E_RIARGGROUPNO, G3E_UNIQUE, G3E_COMPRELATIVEANO, G3E_FUNCTIONALVALIDATION, G3E_ROLE,
G3E_FKQRINO, G3E_FKQARGGROUPNO, G3E_DESCRIPTION ) VALUES ( 
8001, 80, NULL, 'LOGRADOURO', 'Logradouro', null, NULL, NULL, NULL , 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 10, NULL, NULL, 0, SYSDATE, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, NULL, 0, NULL , 1, 'EVERYONE', NULL, NULL, NULL); 

COMMIT;

INSERT INTO G3E_ATTRIBUTE ( G3E_ANO, G3E_CNO, G3E_VNO, G3E_FIELD, G3E_USERNAME, G3E_FORMAT,G3E_PRECISION, G3E_DOMAINTABLE, G3E_DOMAINFIELD, G3E_REQUIRED, G3E_FINO, G3E_FUNCTIONALORDINAL, G3E_FUNCTIONALTYPE, G3E_INTERFACEARGUMENT, G3E_TOOLTIP, G3E_FOREIGNKEYTABLE, G3E_FOREIGNKEYFIELD, G3E_HYPERTEXT,  G3E_PNO, G3E_COPY, G3E_EXCLUDEFROMEDIT, G3E_DATATYPE, G3E_ADDITIONALREFFIELDS, G3E_IMPORTFIELD, G3E_EXCLUDEFROMREPLACE, G3E_EDITDATE, G3E_WIDTHINTWIPS, G3E_CATALOGCOPYVALUE, G3E_LOCALECOMMENT, G3E_BREAKCOPY, G3E_COPYATTRIBUTE, G3E_WRAPTEXT, G3E_MERGEEXPRESSION, G3E_RINO, G3E_RIARGGROUPNO, G3E_UNIQUE, G3E_COMPRELATIVEANO, G3E_FUNCTIONALVALIDATION, G3E_ROLE,
G3E_FKQRINO, G3E_FKQARGGROUPNO, G3E_DESCRIPTION ) VALUES ( 
8002, 80, NULL, 'NUM_INICIAL', 'Número Inicial', 'General Number', NULL, NULL, NULL , 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 4, NULL, NULL, 0, SYSDATE, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, NULL, 0, NULL , 1, 'EVERYONE', NULL, NULL, NULL); 

COMMIT;

INSERT INTO G3E_ATTRIBUTE ( G3E_ANO, G3E_CNO, G3E_VNO, G3E_FIELD, G3E_USERNAME, G3E_FORMAT,G3E_PRECISION, G3E_DOMAINTABLE, G3E_DOMAINFIELD, G3E_REQUIRED, G3E_FINO, G3E_FUNCTIONALORDINAL, G3E_FUNCTIONALTYPE, G3E_INTERFACEARGUMENT, G3E_TOOLTIP, G3E_FOREIGNKEYTABLE, G3E_FOREIGNKEYFIELD, G3E_HYPERTEXT,  G3E_PNO, G3E_COPY, G3E_EXCLUDEFROMEDIT, G3E_DATATYPE, G3E_ADDITIONALREFFIELDS, G3E_IMPORTFIELD, G3E_EXCLUDEFROMREPLACE, G3E_EDITDATE, G3E_WIDTHINTWIPS, G3E_CATALOGCOPYVALUE, G3E_LOCALECOMMENT, G3E_BREAKCOPY, G3E_COPYATTRIBUTE, G3E_WRAPTEXT, G3E_MERGEEXPRESSION, G3E_RINO, G3E_RIARGGROUPNO, G3E_UNIQUE, G3E_COMPRELATIVEANO, G3E_FUNCTIONALVALIDATION, G3E_ROLE,
G3E_FKQRINO, G3E_FKQARGGROUPNO, G3E_DESCRIPTION ) VALUES ( 
8003, 80, NULL, 'NUM_FINAL', 'Número Final', 'General Number', NULL, NULL, NULL , 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 4, NULL, NULL, 0, SYSDATE, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, NULL, 0, NULL , 1, 'EVERYONE', NULL, NULL, NULL); 

COMMIT;

INSERT INTO G3E_ATTRIBUTE ( G3E_ANO, G3E_CNO, G3E_VNO, G3E_FIELD, G3E_USERNAME, G3E_FORMAT,G3E_PRECISION, G3E_DOMAINTABLE, G3E_DOMAINFIELD, G3E_REQUIRED, G3E_FINO, G3E_FUNCTIONALORDINAL, G3E_FUNCTIONALTYPE, G3E_INTERFACEARGUMENT, G3E_TOOLTIP, G3E_FOREIGNKEYTABLE, G3E_FOREIGNKEYFIELD, G3E_HYPERTEXT,  G3E_PNO, G3E_COPY, G3E_EXCLUDEFROMEDIT, G3E_DATATYPE, G3E_ADDITIONALREFFIELDS, G3E_IMPORTFIELD, G3E_EXCLUDEFROMREPLACE, G3E_EDITDATE, G3E_WIDTHINTWIPS, G3E_CATALOGCOPYVALUE, G3E_LOCALECOMMENT, G3E_BREAKCOPY, G3E_COPYATTRIBUTE, G3E_WRAPTEXT, G3E_MERGEEXPRESSION, G3E_RINO, G3E_RIARGGROUPNO, G3E_UNIQUE, G3E_COMPRELATIVEANO, G3E_FUNCTIONALVALIDATION, G3E_ROLE,
G3E_FKQRINO, G3E_FKQARGGROUPNO, G3E_DESCRIPTION ) VALUES ( 
8004, 80, NULL, 'LADO', 'Lado', null, NULL, NULL, NULL , 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 10, NULL, NULL, 0, SYSDATE, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, NULL, 0, NULL , 1, 'EVERYONE', NULL, NULL, NULL); 

COMMIT;



----------------------------------------------------------------------------------------------------------
--   PASSO 4: Executar scripts de criação das tabelas e views otimizadas
----------------------------------------------------------------------------------------------------------
execute MG3ElanguageSubTableUtils.SynchronizeSubTables;
execute MG3EOTCreateOptimizedTables;
execute MG3ECreateOptableViews;


----------------------------------------------------------------------------------------------------------
--   PASSO 5: Executar scripts de instalação da tabela. Cria as tabelas B$ e as triggers LTT, juntamente
-- com as tabelas _TMP
----------------------------------------------------------------------------------------------------------

execute gc_compileinvalidobjects;
update G3E_GENERALPARAMETER set G3E_VALUE='1' where G3E_NAME='IgnoreSubsettingForLTT';
update G3E_GENERALPARAMETER_OPTABLE set G3E_VALUE='1' where G3E_NAME='IgnoreSubsettingForLTT';

execute G3EOneTable.InstallOneTable('GC_ENDERECOS_MULTIPLOS');

update G3E_GENERALPARAMETER set G3E_VALUE='0' where G3E_NAME='IgnoreSubsettingForLTT';
update G3E_GENERALPARAMETER_OPTABLE set G3E_VALUE='0' where G3E_NAME='IgnoreSubsettingForLTT';

COMMIT;

execute LTT_Role.Create_Public_Synonym;
execute LTT_Role.Create_Component_View_Synonym;
execute LTT_Role.Grant_Privs_To_Role;

----------------------------------------------------------------------------------------------------------
--   PASSO 6: Inserindo na TabAttribute
----------------------------------------------------------------------------------------------------------

--NAO EH NECESSARIO A DIALOG TAB PARA PLACEMENT
--INSERT INTO G3E_DIALOGTAB VALUES(8001, 'Endereços Múltiplos', 'H', SYSDATE, NULL, NULL, NULL);
INSERT INTO G3E_DIALOGTAB VALUES(8002, 'Endereços Múltiplos', 'H', SYSDATE, NULL, NULL, NULL);
INSERT INTO G3E_DIALOGTAB VALUES(8003, 'Endereços Múltiplos', 'H', SYSDATE, NULL, NULL, NULL);
COMMIT;

--INSERT INTO G3E_DIALOG VALUES(1180180, 11801, 'Placement', 11800, 80, null, 8001, SYSDATE);
INSERT INTO G3E_DIALOG VALUES(1180280, 11802, 'Edit', 11800, 80, null, 8002, SYSDATE);
INSERT INTO G3E_DIALOG VALUES(1180380, 11803, 'Review', 11800, 80, null, 8003, SYSDATE);

COMMIT;

--INSERT INTO G3E_TABATTRIBUTE VALUES(800101, 8001, 1, NULL, 0, NULL, 0, 8001, NULL, NULL, SYSDATE, 0, 0, NULL,NULL);
--INSERT INTO G3E_TABATTRIBUTE VALUES(800102, 8002, 2, NULL, 0, NULL, 0, 8001, NULL, NULL, SYSDATE, 0, 0, NULL,NULL);
--INSERT INTO G3E_TABATTRIBUTE VALUES(800103, 8003, 3, NULL, 0, NULL, 0, 8001, NULL, NULL, SYSDATE, 0, 0, NULL,NULL);
--INSERT INTO G3E_TABATTRIBUTE VALUES(800104, 8004, 4, NULL, 0, NULL, 0, 8001, NULL, NULL, SYSDATE, 0, 0, NULL,NULL);

INSERT INTO G3E_TABATTRIBUTE VALUES(800201, 8001, 1, NULL, 0, NULL, 0, 8002, NULL, NULL, SYSDATE, 0, 0, NULL,NULL);
INSERT INTO G3E_TABATTRIBUTE VALUES(800202, 8002, 2, NULL, 0, NULL, 0, 8002, NULL, NULL, SYSDATE, 0, 0, NULL,NULL);
INSERT INTO G3E_TABATTRIBUTE VALUES(800203, 8003, 3, NULL, 0, NULL, 0, 8002, NULL, NULL, SYSDATE, 0, 0, NULL,NULL);
INSERT INTO G3E_TABATTRIBUTE VALUES(800204, 8004, 4, NULL, 0, NULL, 0, 8002, NULL, NULL, SYSDATE, 0, 0, NULL,NULL);

INSERT INTO G3E_TABATTRIBUTE VALUES(800301, 8001, 1, NULL, 1, NULL, 0, 8003, NULL, NULL, SYSDATE, 0, 0, NULL,NULL);
INSERT INTO G3E_TABATTRIBUTE VALUES(800302, 8002, 2, NULL, 1, NULL, 0, 8003, NULL, NULL, SYSDATE, 0, 0, NULL,NULL);
INSERT INTO G3E_TABATTRIBUTE VALUES(800303, 8003, 3, NULL, 1, NULL, 0, 8003, NULL, NULL, SYSDATE, 0, 0, NULL,NULL);
INSERT INTO G3E_TABATTRIBUTE VALUES(800304, 8004, 4, NULL, 1, NULL, 0, 8003, NULL, NULL, SYSDATE, 0, 0, NULL,NULL);

COMMIT;


SPOOL OFF;
