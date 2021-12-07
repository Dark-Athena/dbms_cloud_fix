@$ORACLE_HOME/rdbms/admin/sqlsessstart.sql
define username='C##CLOUD$SERVICE';
alter session set current_schema=&username;

@dbms_cloud_types.spc
@DBMS_CLOUD_FIX.sql
@dbms_cloud_task.pck
@dbms_cloud_request.pck
@dbms_cloud_internal.pck
@dbms_cloud_admin_internal.pck
@dbms_cloud.pck

alter session set current_schema=sys;

@$ORACLE_HOME/rdbms/admin/sqlsessend.sql