EXECUTE MG3ElanguageSubTableUtils.SynchronizeSubTables;
EXECUTE MG3EOTCreateOptimizedTables;
EXECUTE MG3ECreateOptableViews;

EXECUTE ComponentQuery.Generate;
COMMIT;

EXECUTE ComponentViewQuery.Generate;
COMMIT;

execute gc_compileinvalidobjects;
commit;

execute GeometryQuery.Generate;
commit;