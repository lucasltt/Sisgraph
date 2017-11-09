select 
   * 
from (
   select 
      owner, 
      segment_name, 
      bytes/1024/1024 meg 
   from 
      dba_segments 
   where
      segment_type = 'TABLE'
      and owner = 'CEMIG' and (bytes/1024/1024) > 10
   order by 
      bytes/1024/1024 desc) 