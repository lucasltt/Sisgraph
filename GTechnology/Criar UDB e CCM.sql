SET SERVEROUTPUT ON SIZE UNLIMITED
ACCEPT ca PROMPT 'Insira la ruta de la carpeta MAPFILES: '
ACCEPT cn PROMPT 'Insira el nombre de la configuración: '
ACCEPT al PROMPT 'Insira el alias: '


DECLARE
    CURSOR cs_mapfile IS
    SELECT DISTINCT(REPLACE(f.G3E_USERNAME, ' ', '')) as G3E_USERNAME , f.G3E_FNO
    FROM G3E_FEATURE f
    JOIN G3E_COMPONENTVIEWDEFINITION c
    ON f.G3E_FNO = c.G3E_FNO
    ORDER BY f.G3E_FNO;
    
    CURSOR cs_view (v_fno NUMBER)IS
    SELECT G3E_VIEW, G3E_FNO
    FROM G3E_COMPONENTVIEWDEFINITION
    WHERE G3E_FNO = v_fno;

    ca VARCHAR2(100);

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('--------------------');
    DBMS_OUTPUT.PUT_LINE('Archivo UDB');
    DBMS_OUTPUT.PUT_LINE('---------------------');
    
    DBMS_OUTPUT.PUT_LINE('MAPFILESIZE=0');
    DBMS_OUTPUT.PUT_LINE('PUBLISHTYPE=1');
    
    FOR r_m IN cs_mapfile LOOP
     
     DBMS_OUTPUT.PUT_LINE('MAPFILE=' || '&ca\DATA\' || '' || r_m.G3E_USERNAME || '.ddc');
     
        FOR r_v IN cs_view(r_m.G3E_FNO) LOOP
            DBMS_OUTPUT.PUT_LINE('VIEWS=' || r_v.G3E_VIEW);
                    
        END LOOP;
  
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--------------------');
    DBMS_OUTPUT.PUT_LINE('--------------------');
    DBMS_OUTPUT.PUT_LINE('Archivo CCM');
    DBMS_OUTPUT.PUT_LINE('---------------------');
    
    
    DBMS_OUTPUT.PUT_LINE('CONFIGURATION_NAME=' || '&cn' || ';');
    DBMS_OUTPUT.PUT_LINE('ALIAS=' || '&al' || ';');

    FOR r_m IN cs_mapfile LOOP

     DBMS_OUTPUT.PUT_LINE('MAPFILE=' || '&ca\DATA\' || '' || r_m.G3E_USERNAME || '.ddc;');
     
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('MAPFILE=&ca' || '\metadata\FeatureComponentMetadata.DDC;');
    DBMS_OUTPUT.PUT_LINE('MAPFILE=&ca' || '\metadata\LegendMetadata.DDC;');
    DBMS_OUTPUT.PUT_LINE('MAPFILE=&ca' || '\metadata\DialogAttributeMetadata.DDC;');
    DBMS_OUTPUT.PUT_LINE('MAPFILE=&ca' || '\metadata\RelationshipMetadata.DDC;');
    DBMS_OUTPUT.PUT_LINE('MAPFILE=&ca' || '\metadata\PlacementMetadata.DDC;');
    DBMS_OUTPUT.PUT_LINE('MAPFILE=&ca' || '\metadata\AnalysisIntegrationMetadata.DDC;');
    
    DBMS_OUTPUT.PUT_LINE('---------------------');
    
END;
/      
