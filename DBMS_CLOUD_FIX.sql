alter table C##CLOUD$SERVICE.DBMS_CLOUD_TASK$ add cleanup_interval INTERVAL DAY (5) TO SECOND (6);

create or replace view c##cloud$service.dbms_cloud_tasks as
select ID#, SID, SERIAL#, USER#, CLASS#, START_TS, UPDATE_TS, STATUS#, PAYLOAD$,cleanup_interval
from dbms_cloud_task$;

insert into C##CLOUD$SERVICE.dbms_cloud_task_class ( USER#, NAME, CLEANUP_CALLBACK, CLEANUP_INTERVAL, STATUS)
values ( 108, 'EXPORT', 'DBMS_CLOUD_INTERNAL.DELETE_LOAD_OPERATION', '+00002 00:00:00.000000', 1);
commit;