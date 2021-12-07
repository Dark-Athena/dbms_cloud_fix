CREATE OR REPLACE NONEDITIONABLE PACKAGE C##CLOUD$SERVICE.dbms_cloud_admin_internal
AS

  -----------------------------------------------------------------------------
  --                                CONSTANTS
  -----------------------------------------------------------------------------

  -- Code for Database Vault related operations
  DV_CONFIGURE                    CONSTANT   NUMBER    := 1;
  DV_ENABLE                       CONSTANT   NUMBER    := 2;
  DV_DISABLE                      CONSTANT   NUMBER    := 3;
  DV_ENABLE_USERMGMT              CONSTANT   NUMBER    := 4;
  DV_DISABLE_USERMGMT             CONSTANT   NUMBER    := 5;

  -----------------------------------------------------------------------------
  --                     PUBLIC PROCEDURES AND FUNCTIONS
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- enable_app_cont - Enable Application Continuity for a service
  -----------------------------------------------------------------------------
  PROCEDURE enable_app_cont(
        service_name  IN  VARCHAR2
  );
    --
    -- NAME:
    --  enable_app_cont  - Enable Application Continuity for a service
    --
    -- DESCRIPTION:
    --   This procedure enables application continuity for a given database
    --   service name.
    --
    -- PARAMETERS:
    --   service_name    (IN) - Database service name
    --
    -- NOTES:
    --   Added for bug 28809994.
    --


  -----------------------------------------------------------------------------
  -- disable_app_cont - Disable Application Continuity for a service
  -----------------------------------------------------------------------------
  PROCEDURE disable_app_cont(
        service_name  IN  VARCHAR2
  );
    --
    -- NAME:
    --  disable_app_cont  - Disable Application Continuity for a service
    --
    -- DESCRIPTION:
    --   This procedure disables application continuity for a given database
    --   service name.
    --
    -- PARAMETERS:
    --   service_name    (IN) - Database service name
    --
    -- NOTES:
    --   Added for bug 28809994.
    --


  -----------------------------------------------------------------------------
  -- change_character_set - Change database character set
  -----------------------------------------------------------------------------
  PROCEDURE change_character_set(
        name            IN  VARCHAR2,
        force           IN  BOOLEAN  DEFAULT FALSE
  );
    -- NAME:
    --   change_character_set - Change database character set
    --
    -- DESCRIPTION:
    --   This procedure changes the database character set in a pluggable
    --   database, provided there are no user objects created yet. It does not
    --   intend to convert user data.
    --
    -- PARAMETERS:
    --   name      (IN) - Name of the desired database character set
    --
    --   force     (IN) - Force change of character set
    --
    -- NOTES:
    --   Added for bug 30539027.
    --


  -----------------------------------------------------------------------------
  -- change_national_character_set - Change national character set
  -----------------------------------------------------------------------------
  PROCEDURE change_national_character_set(
        name            IN  VARCHAR2,
        force           IN  BOOLEAN  DEFAULT FALSE
  );
    -- NAME:
    --   change_national_character_set - Change national character set
    --
    -- DESCRIPTION:
    --   This procedure changes the national character set in a pluggable
    --   database, provided there are no user objects created yet. It does not
    --   intend to convert user data.
    --
    -- PARAMETERS:
    --   name      (IN) - Name of the desired national character set
    --
    --   force     (IN) - Force change of character set
    --
    -- NOTES:
    --   Added for bug 30539027.
    --


  -----------------------------------------------------------------------------
  -- dv_prechecks - Helper routine doing various prechecks for DV related APIs
  -----------------------------------------------------------------------------
  PROCEDURE dv_prechecks(
        opcode           IN  NUMBER
  );
    --
    -- NAME:
    --   dv_prechecks - Prechecks for DV Configure and Enable/Disable
    --
    -- DESCRIPTION:
    --   This procedure check whether DV is installed inside the PDB and
    --   and PDB is open in READ WRITE mode to configure/enable DV. Also
    --   check is made to ensure that it is not run in CDB$Root container.
    --
    -- PARAMETERS:
    --   opcode     (IN) - Opcode for DV operation (CONFIGURE/ENABLE etc.)
    --
    -- NOTES:
    --   Added for bug 29662123. It used to exist in dbms_cloud_admin but
    --   moved to dbms_cloud_core as part of bug 30298039.
    --


  -----------------------------------------------------------------------------
  -- get_apex_schema - Helper routine to get Apex schema name
  -----------------------------------------------------------------------------
  FUNCTION get_apex_schema
  RETURN VARCHAR2;
    --
    -- NAME:
    --   get_apex_schema - Get Apex schema if Apex is installed inside the PDB
    --
    -- DESCRIPTION:
    --   DBA_REGISTRY is NOT granted to DV_ADMIN or DV_OWNER role. This helper
    --   routine check whether Apex is installed inside the PDB and retrieves
    --   the Apex schema name. The schema gets used to setup various DV realm
    --   authorizations to get Apex working in a DV enabled PDB, when the same
    --   is configured via {enable|disable}_usermgmt_database_vault APIs.
    --
    -- PARAMETERS:
    --   NONE
    --
    -- RETURNS:
    --   Apex schema name, if Apex is installed, NULL otherwise
    --
    -- NOTES:
    --   Added for bug 30568387.
    --


  -----------------------------------------------------------------------------
  -- dv_change_audit - Helper routine to enable/disable DV audit policies
  -----------------------------------------------------------------------------
  PROCEDURE dv_change_audit(
        enable     IN BOOLEAN DEFAULT FALSE
  );
    --
    -- NAME:
    --   dv_change_audit - Enable/Disable DV unified audit policies
    --
    -- DESCRIPTION:
    --   This helper routine enables/disables DV related unified audit
    --   policies. It gets called at the time of DV enable/disable and helps
    --   DV_OWNER role turn on/off audit policies without needing AUDIT_ADMIN
    --   role, which does not get granted to DV_OWNER out-of-box.
    --
    -- PARAMETERS:
    --   enable  (IN) - whether to enable or disable audit policies
    --
    -- NOTES:
    --   Added for bug 30568387.
    --


  -----------------------------------------------------------------------------
  -- rotate_encryption_key - Rotate encryption key
  -----------------------------------------------------------------------------
  PROCEDURE rotate_encryption_key(
    enc_key              IN VARCHAR2,
    vault_key_details    IN VARCHAR2,
    key_id               IN VARCHAR2 DEFAULT NULL
  );
    --
    -- NAME:
    --  rotate_encryption_key - Rotate encryption key
    --
    -- DESCRIPTION:
    --   This procedure sets the encryption key to the value passed.
    --
    -- PARAMETERS:
    --   enc_key           (IN) - Encryption key
    --
    --   vault_key_details (IN) - Vault key details
    --
    --   key_id            (IN) - Key id
    --

  -----------------------------------------------------------------------------
  -- Run a dynamic sql statement (DBMS_SQL.parse or DBMS_SYS_SQL.parse_as_user)
  -----------------------------------------------------------------------------
  PROCEDURE run_stmt(
        stmt        IN  VARCHAR2,
        userid      IN  NUMBER  DEFAULT NULL,
        parse_only  IN  BOOLEAN DEFAULT FALSE
  )
  ACCESSIBLE BY (PACKAGE DBMS_CLOUD_INTERNAL, PACKAGE DBMS_CLOUD_MACADM);
    --
    -- NAME:
    --   run_stmt  - Run a dynamic sql statement
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure to run a dynamic sql statement
    --   using DBMS_SQL (or DBMS_SYS_SQL).
    --
    -- PARAMETERS:
    --   stmt        (IN) - sql statement to execute
    --   userid      (IN) - user id to execute the statement
    --   parse_only  (IN) - parse only, no execution (Default FALSE)
    --
    -- NOTES:
    --   Added for bug 30539027, externalized as part of Bug 31402412
    --


  -----------------------------------------------------------------------------
  -- get_encryption_key_info - Get information on encryption Key
  -----------------------------------------------------------------------------
  FUNCTION get_encryption_key_info
  RETURN JSON_OBJECT_T;
    --
    -- NAME:
    --   get_encryption_key_info - Get information on encryption Key
    --
    -- DESCRIPTION:
    --   This function returns details of encryption Key.
    --
    -- PARAMETERS:
    --   None
    --
    -- RETURNS:
    --   Information on encryption Key.
    --
    --


  -----------------------------------------------------------------------------
  -- enable_external_authentication - Enable external authentication to DB
  -----------------------------------------------------------------------------
  PROCEDURE enable_external_authentication(
        type    IN  VARCHAR2,
        force   IN  BOOLEAN  DEFAULT FALSE
  );
    --
    -- NAME:
    --   enable_external_authentication - Enable external authentication to DB
    --
    -- DESCRIPTION:
    --   This procedure enables users to use external authentication schemes to
    --   logon to the database.
    --
    -- PARAMETERS:
    --   type    (IN)  - Type of external authentication
    --
    --   force   (IN)  - Override existing external authentication
    --
    -- EXAMPLE:
    --   BEGIN
    --     DBMS_CLOUD_ADMIN_INTERNAL.enable_external_authentication(
    --         type  => 'OCI_IAM',
    --         force => TRUE
    --     );
    --   END;
    --   /
    --
    -- NOTES:
    --   Added for bug 33157035.
    --


  -----------------------------------------------------------------------------
  -- disable_external_authentication - Disable external authentication to DB
  -----------------------------------------------------------------------------
  PROCEDURE disable_external_authentication;
    --
    -- NAME:
    --  disable_external_authentication - Disable external authentication to DB
    --
    -- DESCRIPTION:
    --   This procedure enables users to use external authentication schemes to
    --   logon to the database.
    --
    -- PARAMETERS:
    --   None.
    --
    -- EXAMPLE:
    --   BEGIN
    --     DBMS_CLOUD_ADMIN_INTERNAL.disable_external_authentication;
    --   END;
    --   /
    --
    -- NOTES:
    --   Added for bug 33157035.
    --


  -----------------------------------------------------------------------------
  -- get_reverse_link_address - Get Reverse Link Address
  -----------------------------------------------------------------------------
  FUNCTION get_reverse_link_address(
        private_ip IN VARCHAR2
  ) RETURN VARCHAR2;
    --
    -- NAME:
    --   get_reverse_link_address - Get Reverse Link Address
    --
    -- DESCRIPTION:
    --   This function returns the reverse link address for connecting to a
    --   private ip address using reverse link feature.
    --
    -- PARAMETERS:
    --   private_ip (IN)  - Private IP address
    --
    -- NOTES:
    --   Added for bug 33382030.
    --


END dbms_cloud_admin_internal; -- End of DBMS_CLOUD_ADMIN_INTERNAL Package
/
CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY C##CLOUD$SERVICE.dbms_cloud_admin_internal
AS

  -----------------------------------------------------------------------------
  --                                CONSTANTS
  -----------------------------------------------------------------------------

  M_IDEN       CONSTANT    NUMBER      := ORA_MAX_NAME_LEN;
  M_VCSIZ_4K   CONSTANT    PLS_INTEGER := 4000;
  -- Maximum length of cloud store URI
  MAX_URI_LEN  CONSTANT    PLS_INTEGER := M_VCSIZ_4K;
  -- Maximum length of service name
  M_SVC_LEN    CONSTANT    PLS_INTEGER := M_VCSIZ_4K;
  -- SYS user id
  KSYS         CONSTANT    PLS_INTEGER := 0;

  -- Service parameters default values
  FAILOVER_DELAY_DEFAULT            CONSTANT NUMBER := 5;
  FAILOVER_RETRIES_DEFAULT          CONSTANT NUMBER := 30;
  DRAIN_TIMEOUT_DEFAULT             CONSTANT NUMBER := 300;
  REPLAY_INITIATION_TIMEOUT_DEFAULT CONSTANT NUMBER := 300;

  -- Character set type
  CHAR_SET_TYPE_DB         CONSTANT PLS_INTEGER := 1;
  CHAR_SET_TYPE_NCHAR      CONSTANT PLS_INTEGER := 2;
  CHAR_SET_TYPE_DB_STR     CONSTANT DBMS_ID     := NULL;
  CHAR_SET_TYPE_NCHAR_STR  CONSTANT DBMS_ID     := 'NATIONAL ';

  -- Character set form
  SQLCS_IMPLICIT           CONSTANT PLS_INTEGER := 1;
  SQLCS_NCHAR              CONSTANT PLS_INTEGER := 2;

  -- Character set wait interval before for retry
  CHAR_SET_RETRY_WAIT      CONSTANT PLS_INTEGER := 5;

  -- Login mode for v$instance
  LOGINS_ALLOWED           CONSTANT DBMS_ID     := 'ALLOWED';

  -- External Auth Identity parameter names
  EXTAUTH_PARAM_LDAP       CONSTANT DBMS_ID     := 'ldap_directory_access';
  EXTAUTH_PARAM_IDENTITY   CONSTANT DBMS_ID     := 'identity_provider_type';

  -- Broker endpoints
  RPST_ENDPOINT               CONSTANT   DBMS_ID := 'resource_principal';
  REVERSE_LINK_ENDPOINT       CONSTANT   DBMS_ID :=
                               'private_endpoints/reverse_connection_nat_ips/';

  ----------------------------
  -- Exceptions
  ----------------------------
  EXCP_SVC_INVALID         CONSTANT NUMBER := -20001;
  EXCP_SVC_NOT_EXIST       CONSTANT NUMBER := -20002;
  EXCP_DFLT_SVC            CONSTANT NUMBER := -20003;



  -----------------------------------------------------------------------------
  --           FORWARD DECLARATIONS (STATIC FUNCTION/PROCEDURE DECLARATIONS)
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- validate_service_name  - Validate a service name
  -----------------------------------------------------------------------------
  FUNCTION validate_service_name(
    service_name      IN VARCHAR2
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   validate_service_name  - Validate a service name
    --
    -- DESCRIPTION:
    --   This procedure validates the service name.
    --
    -- PARAMETERS:
    --   service_name    (IN) - service name
    --
    -- RETURNS:
    --   The sanitized service name
    --
    -- NOTES:
    --
    l_service_name   VARCHAR2(M_SVC_LEN);
  BEGIN
    -- Check null service
    IF service_name IS NULL THEN
      raise_application_error(EXCP_SVC_INVALID,
                'Missing service name');
    -- Check long identifier
    ELSIF LENGTH(TRIM(service_name)) > M_SVC_LEN THEN
      raise_application_error(DBMS_CLOUD.EXCP_IDEN_TOO_LONG,
                'Service name is too long');
    END IF;

    -- Trim the service name
    l_service_name := TRIM(service_name);

    -- Check default service
    IF LOWER(service_name) = LOWER(SYS_CONTEXT('USERENV', 'CON_NAME')) THEN
      -- Application Continuity cannot be enabled on database default service
      raise_application_error(EXCP_DFLT_SVC,
       'Application continuity cannot be enabled on database default service');
    END IF;

    RETURN l_service_name;
  END validate_service_name;


  -----------------------------------------------------------------------------
  -- modify_service - Modify database service
  -----------------------------------------------------------------------------
  PROCEDURE modify_service(
    service_name      IN  VARCHAR2,
    service_params    IN  DBMS_SERVICE.svc_parameter_array
  )
  IS
    --
    -- NAME:
    --   modify_service  - Modify database service
    --
    -- DESCRIPTION:
    --   This procedure modifies a database service using the given parameters.
    --
    -- PARAMETERS:
    --   service_name    (IN) - service name
    --   service_params  (IN) - parameters to update for service
    --
    -- NOTES:
    --
    l_service_name   VARCHAR2(M_SVC_LEN);
  BEGIN

    --  Validate the service name
    l_service_name := validate_service_name(service_name);

    -- Modify the service
    DBMS_SERVICE.modify_service(l_service_name, service_params);

  EXCEPTION
    WHEN DBMS_SERVICE.SERVICE_DOES_NOT_EXIST THEN
      raise_application_error(EXCP_SVC_NOT_EXIST,
                'Service ' || service_name || ' does not exist');
  END modify_service;


  -----------------------------------------------------------------------------
  -- Run a dynamic sql statement
  -----------------------------------------------------------------------------
  PROCEDURE run_stmt(
        stmt        IN  VARCHAR2,
        userid      IN  NUMBER  DEFAULT NULL,
        parse_only  IN  BOOLEAN DEFAULT FALSE
  )
  ACCESSIBLE BY (PACKAGE DBMS_CLOUD_INTERNAL, PACKAGE DBMS_CLOUD_MACADM)
  IS
    --
    -- NAME:
    --   run_stmt  - Run a dynamic sql statement
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure to run a dynamic sql statement
    --   using DBMS_SQL (or DBMS_SYS_SQL).
    --
    -- PARAMETERS:
    --   stmt        (IN) - sql statement to execute
    --   userid      (IN) - user id to execute the statement
    --   parse_only  (IN) - parse only, no execution (Default FALSE)
    --
    -- NOTES:
    --   Added for bug 30539027.
    --
    l_cur             INTEGER;
    l_dummy           INTEGER;
    l_uselogonroles   BOOLEAN := FALSE;
  BEGIN

    -- Open cursor
    l_cur   := DBMS_SQL.open_cursor();

    -- Parse cursor
    IF userid IS NULL THEN
      DBMS_SQL.parse(
              c             => l_cur,
              statement     => stmt,
              language_flag => DBMS_SQL.NATIVE
      );
    ELSE
      IF userid = KSYS THEN
        l_uselogonroles := TRUE;
      END IF;
      SYS.DBMS_SYS_SQL.parse_as_user(
              c             => l_cur,
              statement     => stmt,
              language_flag => DBMS_SQL.NATIVE,
              userid        => userid,
              uselogonroles => l_uselogonroles
      );
    END IF;

    -- Execute cursor
    IF parse_only = FALSE THEN
      l_dummy := DBMS_SQL.execute(c => l_cur);
    END IF;

    -- Close cursor
    DBMS_SQL.close_cursor(c => l_cur);

  EXCEPTION
    WHEN OTHERS THEN
      -- Close cursor on error
      IF DBMS_SQL.is_open(c => l_cur) THEN
        DBMS_SQL.close_cursor(c => l_cur);
      END IF;
      RAISE;
  END run_stmt;


  -----------------------------------------------------------------------------
  -- get_current_charset - Get current character set
  -----------------------------------------------------------------------------
  FUNCTION get_current_charset(
        type    IN   PLS_INTEGER
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   get_current_charset - Get current character set
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure to obtain the current character
    --   set of the database.
    --
    -- PARAMETERS:
    --   type        (IN) - type of character set
    --
    -- NOTES:
    --   Added for bug 30539027.
    --
    l_property_name   DBMS_ID;
    l_property_value  VARCHAR2(M_VCSIZ_4K);
  BEGIN
    -- Determine the property name based on type of character set
    CASE type
      WHEN CHAR_SET_TYPE_NCHAR THEN
        l_property_name := 'NLS_NCHAR_CHARACTERSET';
      WHEN CHAR_SET_TYPE_DB THEN
        l_property_name := 'NLS_CHARACTERSET';
      ELSE
        DBMS_CLOUD_CORE.assert(FALSE, 'get_current_charset',
            'Invalid character set type - ' || type);
    END CASE;

    DBMS_CLOUD_CORE.get_db_property(l_property_name, l_property_value);

    RETURN l_property_value;

  END get_current_charset;


  -----------------------------------------------------------------------------
  -- get_charset_type_str - Get character set type as string
  -----------------------------------------------------------------------------
  FUNCTION get_charset_type_str(
        type    IN   PLS_INTEGER
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   get_charset_type_str - Get character set type as string
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure to get string representation for
    --   character set type id.
    --
    -- PARAMETERS:
    --   type        (IN) - type of character set
    --
    -- NOTES:
    --   Added for bug 30767970.
    --
  BEGIN
    CASE type
      WHEN CHAR_SET_TYPE_DB THEN
        RETURN NULL;
      WHEN CHAR_SET_TYPE_NCHAR THEN
        RETURN 'NATIONAL ';
      ELSE
        DBMS_CLOUD_CORE.assert(FALSE, 'get_charset_type_str',
            'Invalid character set type - ' || type);
    END CASE;
  END get_charset_type_str;


  -----------------------------------------------------------------------------
  -- change_charset_prechecks - Change database character set Prechecks
  -----------------------------------------------------------------------------
  FUNCTION change_charset_prechecks(
        name    IN  VARCHAR2,
        type    IN  PLS_INTEGER,
        force   IN  BOOLEAN
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   change_charset_prechecks - Change character set prechecks
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure to perform prechecks for
    --   change database or national character set.
    --
    -- PARAMETERS:
    --   name        (IN) - name of character set
    --   type        (IN) - type of character set
    --
    -- NOTES:
    --   Added for bug 30539027.
    --
    l_name                     DBMS_ID;
    l_name_unq                 DBMS_ID;
    l_property_value           VARCHAR2(4000);
    l_cnt                      NUMBER;
    CHAR_SET_AL32UTF8 CONSTANT DBMS_ID := 'AL32UTF8';
    l_stmt                     VARCHAR2(M_VCSIZ_4K);
  BEGIN

    -- 0. Character set conversion only supported for 19c or higher
    -- (Bug 31525205)
    IF dbms_db_version.version < 19 THEN
      raise_application_error(DBMS_CLOUD.EXCP_UNSUPP_FEATURE,
                'Feature not supported in current database version');
    END IF;

    -- 1. Capability enabled
    l_stmt := 'BEGIN DBMS_CLOUD_CAPABILITY.check_capability( ' ||
              '  DBMS_CLOUD_CAPABILITY.CHANGE_CHAR_SET);     ' ||
              'END; ';

    EXECUTE IMMEDIATE l_stmt;

    -- Bug 31741305: Disable character set conversion for AJD PDB
    IF SYS_CONTEXT('USERENV', 'CLOUD_SERVICE') = 'JDCS' THEN
      l_stmt := 'BEGIN                                              ' ||
                ' raise_application_error(                          ' ||
                '   DBMS_CLOUD_CAPABILITY.EXCP_DISABLED_CAPABILTY,  ' ||
                '   DBMS_CLOUD_CAPABILITY.CHANGE_CHAR_SET ||        ' ||
                '   ''capability is not enabled'');                 ' ||
                'END; ';
      EXECUTE IMMEDIATE l_stmt;
    END IF;

    -- 2. Validate character set name
    l_name := UPPER(TRIM(
                  DBMS_CLOUD_CORE.assert_simple_sql_name(
                      name, DBMS_CLOUD_CORE.ASSERT_TYPE_CS)));
    l_name_unq := DBMS_CLOUD_CORE.unquote_name(l_name);

    -- 3. Character set conversion is only allowed in a PDB
    IF SYS_CONTEXT('USERENV', 'CON_ID') <= 2 THEN
      SYS.DBMS_SYS_ERROR.raise_system_error(-65046);
    END IF;

    IF force = FALSE THEN
      -- 4. Character set cannot be same as current character set
      l_property_value := get_current_charset(type);
      IF l_property_value = l_name_unq THEN
        raise_application_error(DBMS_CLOUD.EXCP_INVALID_CHAR_SET,
          'Current ' || LOWER(get_charset_type_str(type)) ||
          'character set is already ' || l_property_value);
      END IF;

      -- 5. Source or target db character set has to be AL32UTF8 (Bug 30767970)
      IF type = CHAR_SET_TYPE_DB AND
         l_property_value != CHAR_SET_AL32UTF8 AND
         l_name_unq != CHAR_SET_AL32UTF8
      THEN
        raise_application_error(DBMS_CLOUD.EXCP_INVALID_CHAR_SET,
          'Source or target character set should be ' || CHAR_SET_AL32UTF8);
      END IF;

      -- 6. There should not be any new local users in the database
      -- (Bug 30767970)
      SELECT COUNT(*) INTO l_cnt FROM all_users
          WHERE oracle_maintained = 'N' AND
                common = 'NO' AND
                CAST(created AS TIMESTAMP) >
                        (SELECT CAST(creation_time AS TIMESTAMP) FROM v$pdbs);
      IF l_cnt > 0 THEN
        raise_application_error(DBMS_CLOUD.EXCP_INVALID_CHAR_SET,
          'Additional local users exist in the database. Drop local ' ||
          'users created after provisioning the database and retry the ' ||
          'operation.');
      END IF;

      -- 7. There should not be any local roles in the database
      -- (Bug 30767970)
      SELECT COUNT(*) INTO l_cnt FROM dba_roles
          WHERE oracle_maintained = 'N' AND
                common = 'NO';
      IF l_cnt > 0 THEN
        raise_application_error(DBMS_CLOUD.EXCP_INVALID_CHAR_SET,
          'Local roles exist in the database. Drop local roles and retry ' ||
          'the operation.');
      END IF;

      -- 8.1 There should not be any user objects (Bug 30767970)
      SELECT COUNT(*) INTO l_cnt FROM dba_objects o, all_users u
            WHERE o.owner = u.username AND
                  o.oracle_maintained = 'N' AND
                  u.oracle_maintained = 'N';
      IF l_cnt = 0 THEN
        -- 8.2 There should not be any user data (Bug 30767970)
        --     Exclude Oracle-supplied users (Bug 32588710)
        SELECT COUNT(*) INTO l_cnt FROM dba_extents e, all_users u
          WHERE e.tablespace_name LIKE 'DATA%' AND
                e.owner = u.username AND
                u.oracle_maintained = 'N';
      END IF;
      IF l_cnt > 0 THEN
        raise_application_error(DBMS_CLOUD.EXCP_INVALID_CHAR_SET,
          'User objects exist in the database. Drop the objects and retry ' ||
          'the operation.');
      END IF;
    END IF;

    RETURN l_name;

  END change_charset_prechecks;


  -----------------------------------------------------------------------------
  -- kill_sessions - Kill sessions
  -----------------------------------------------------------------------------
  PROCEDURE kill_sessions
  IS
    --
    -- NAME:
    --   kill_sessions - Kill sessions
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure to kill sessions.
    --
    -- PARAMETERS:
    --   None.
    --
    -- NOTES:
    --   Added for bug 30539027.
    --
    l_sid          NUMBER;
    l_serial#      NUMBER;
    l_sess_killed  BOOLEAN := FALSE;
  BEGIN

    -- Get current session ID to ignore current session
    DBMS_CLOUD_CORE.get_current_sessionid(l_sid, l_serial#);

    -- Kill sessions in the database, except current one
    FOR sess IN
    (
        SELECT sid, serial#, inst_id FROM gv$session
          WHERE sid != l_sid AND serial# != l_serial# AND
                status NOT IN ('KILLED', 'SNIPED')
    )
    LOOP
      BEGIN
        EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ' ||
                  DBMS_ASSERT.enquote_literal(sess.sid || ',' ||
                                              sess.serial# || ',@' ||
                                              sess.inst_id) ||
                  ' IMMEDIATE';
        l_sess_killed := TRUE;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;

    -- Sleep for some time to allow killed sessions to exit.
    IF l_sess_killed = TRUE THEN
      EXECUTE IMMEDIATE 'BEGIN DBMS_SESSION.sleep(:1); END;'
        USING CHAR_SET_RETRY_WAIT;
    END IF;

  END kill_sessions;


  -----------------------------------------------------------------------------
  -- change_charset_postprocess - Post process for character set
  -----------------------------------------------------------------------------
  PROCEDURE change_charset_postprocess(
        type    IN  PLS_INTEGER
  )
  IS
    --
    -- NAME:
    --   change_charset_postprocess
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure for post process actions after
    --   character set change. It invalidates TYPES and recompiles them to
    --   ensure that character set is updated in type metadata.
    --
    -- PARAMETERS:
    --   type        (IN) - type of character set
    --
    -- NOTES:
    --   Added for bug 30539027.
    --

    -- Determine the character set form based on character set type
    l_csform CONSTANT  PLS_INTEGER :=
        CASE type
          WHEN CHAR_SET_TYPE_NCHAR THEN SQLCS_NCHAR
          ELSE SQLCS_IMPLICIT
        END;

    l_sql    CONSTANT  VARCHAR2(M_VCSIZ_4K) :=
 'DECLARE
    -- Use autonomous tranaction
    PRAGMA AUTONOMOUS_TRANSACTION;

    l_invalid_status CONSTANT PLS_INTEGER := 6;
    l_type#          CONSTANT PLS_INTEGER := 13;
    l_csform         CONSTANT PLS_INTEGER := ' || l_csform || ';
  BEGIN
    -- Invalidate all the direct and indirect dependent objects of
    -- Oracle supplied TYPES
    UPDATE sys.obj$ SET status = l_invalid_status
    WHERE type# = l_type# AND
          status NOT IN (4,5,6) AND subname IS NULL AND
          EXISTS(SELECT 1
                 FROM sys.attribute$
                 WHERE bitand(properties, 4096) = 4096 AND
                       toid=obj$.oid$ AND
                       charsetform = l_csform) AND
          NOT EXISTS (SELECT 1
                      FROM sys.type$
                      WHERE bitand(properties, 16) = 16 AND
                            toid = obj$.oid$);

    FOR typ_cur IN
    (
       SELECT obj#
       FROM sys.obj$
       WHERE type# = l_type# AND
             status = l_invalid_status AND
             subname IS NULL AND
             EXISTS(SELECT 1
                    FROM sys.attribute$
                    WHERE bitand(properties, 4096) = 4096 AND
                          toid=obj$.oid$ AND
                          charsetform = l_csform) AND
             NOT EXISTS (SELECT 1
                         FROM sys.type$
                         WHERE bitand(properties, 16) = 16 AND
                               toid = obj$.oid$)
    )
    LOOP
      FOR dep_cur in
      (
         SELECT d_obj#
         FROM sys.dependency$
         CONNECT BY NOCYCLE
         PRIOR d_obj# = p_obj#
         START WITH p_obj# = typ_cur.obj#
      )
      LOOP
        UPDATE sys.obj$
      SET status = l_invalid_status
      WHERE obj# = dep_cur.d_obj# AND
                  status NOT IN (4,5,6) AND
            type# IN (7, 8, 9, 11, 12, 13, 14, 22, 32, 33, 87);
      END LOOP;
    END LOOP;

    COMMIT;
  END;';

    l_recomp_sql    CONSTANT  VARCHAR2(M_VCSIZ_4K) :=
 'BEGIN
    -- Recompile the invalidated objects
    UTL_RECOMP.recomp_serial;
  EXCEPTION
    WHEN OTHERS THEN
      -- Ignore errors, objects would later recompile on access.
      NULL;
  END;';

  BEGIN
    -- Invalidate types and their dependents
    -- Execute the statement as SYS
    run_stmt(
        stmt   => l_sql,
        userid => KSYS
    );

    -- Flush shared pool 3 times to ensure objects are purged from SGA
    -- Flush shared pool has to be done without DBMS_SYS_SQL to bypass lockdown
    FOR i IN 1..3 LOOP
      EXECUTE IMMEDIATE 'ALTER SYSTEM FLUSH SHARED_POOL';
    END LOOP;

    -- Bug 32284675: Flush result cache
    EXECUTE IMMEDIATE 'BEGIN DBMS_RESULT_CACHE.flush; END;';

    -- Recompile the invalidated objects
    -- Execute the statement as SYS
    run_stmt(
        stmt   => l_recomp_sql,
        userid => KSYS
    );

  END change_charset_postprocess;


  -----------------------------------------------------------------------------
  -- change_character_set_int - Change character set internal
  -----------------------------------------------------------------------------
  PROCEDURE change_character_set_int(
        name            IN  VARCHAR2,
        type            IN  PLS_INTEGER DEFAULT CHAR_SET_TYPE_DB,
        force           IN  BOOLEAN     DEFAULT FALSE
  )
  IS
    --
    -- NAME:
    --   change_character_set_int - Change character set internal
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure to change database or national
    --   character set.
    --
    -- PARAMETERS:
    --   name        (IN) - name of character set
    --   type        (IN) - type of character set
    --
    -- NOTES:
    --   Added for bug 30539027.
    --
    l_name         DBMS_ID;
    l_sql          VARCHAR2(M_VCSIZ_4K);
    l_cur          INTEGER;
    l_type_str     DBMS_ID;
    l_retry_count  PLS_INTEGER := 0;
    l_max_retry    PLS_INTEGER := 10;    -- 10 attempts to change character set
    l_restricted   DBMS_ID;
  BEGIN

    --
    -- Pre-checks for character set conversion
    --
    l_name     := change_charset_prechecks(name, type, force);
    l_type_str := get_charset_type_str(type);

    --
    -- Enable restricted session mode
    -- Bug 31886989: Check if restricted session mode is not enabled
    --
    EXECUTE IMMEDIATE 'SELECT logins FROM v$instance' INTO l_restricted;
    IF l_restricted = LOGINS_ALLOWED THEN
      EXECUTE IMMEDIATE 'ALTER SYSTEM ENABLE RESTRICTED SESSION';
    END IF;

    -- Bug 30763573: Force internal convert for character set conversion
    -- to handle converting LOB columns in APEX schema.
    BEGIN
      EXECUTE IMMEDIATE 'ALTER SESSION SET "_pdb_char_set_intconv" = TRUE';
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;


    l_sql := 'ALTER PLUGGABLE DATABASE ' ||
                l_type_str || 'CHARACTER SET ' ||
                'INTERNAL_USE INTERNAL_CONVERT ' || l_name;

    --
    -- Change the character set
    --
    LOOP
      -- Kill active sessions before attempting to change character set.
      -- This avoids ORA-12721 and system state dump in the PDB.
      kill_sessions();

      BEGIN
        -- Character set sql has to be executed as SYS
        run_stmt(
            stmt       => l_sql,
            userid     => KSYS,
            parse_only => TRUE
        );

        -- Exit loop if character set change successful
        EXIT;

      EXCEPTION
        WHEN OTHERS THEN
          IF SQLCODE IN (-12715, -12714, -12706, -12744) THEN
            -- Character set is invalid
            raise_application_error(DBMS_CLOUD.EXCP_INVALID_CHAR_SET,
                 'Invalid ' || LOWER(l_type_str) ||
           'character set name - ' || name);
          ELSIF SQLCODE = -12721 THEN
            -- Active sessions found, kill them and retry character set change.
            l_retry_count := l_retry_count + 1;

            -- If max retry is reached, then raise error.
            IF l_retry_count > l_max_retry THEN
              raise_application_error(DBMS_CLOUD.EXCP_INVALID_CHAR_SET,
                  'Active sessions exist in the PDB. Disconnect the ' ||
                  'sessions and retry the operation.');
            END IF;

            -- Wait before retry
            EXECUTE IMMEDIATE 'BEGIN DBMS_SESSION.sleep(:1 * :2); END;'
              USING CHAR_SET_RETRY_WAIT, l_retry_count;

          ELSIF SQLCODE = -2290 OR
                (SQLCODE = -604 AND
                 INSTR(DBMS_UTILITY.format_error_stack, 'ORA-02290') > 0) THEN
            -- This is a very corner case scenario where ORA-2290 is signaled
            -- for MODELALG$ table, due to a previous failure in character set
            -- conversion. The workaround fix is to complete a character set
            -- conversion in the current database character set, and then
            -- proceed with conversion to the new database character set.
            --
            -- Bug 30796514: Validate the value retrieved from dictionary for
            -- Injection. Character set is expected to be a Simple SQL Name.
            --
            run_stmt(
                stmt       => 'ALTER PLUGGABLE DATABASE ' || l_type_str ||
                              'CHARACTER SET INTERNAL_USE ' ||
                              'INTERNAL_CONVERT ' ||
                               DBMS_CLOUD_CORE.assert_simple_sql_name(
                                get_current_charset(type),
                                DBMS_CLOUD_CORE.ASSERT_TYPE_CS),
                userid     => KSYS,
                parse_only => TRUE
            );
          ELSE
            -- Resignal error
            RAISE;
          END IF;
      END;
    END LOOP;


    --
    -- Post process steps
    --
    change_charset_postprocess(type);


    -- Reset session state to clear cached PL/SQL state
    EXECUTE IMMEDIATE ' BEGIN '  ||
    '   DBMS_SESSION.modify_package_state(DBMS_SESSION.REINITIALIZE); ' ||
    ' END;';

    --
    -- Disable restricted session
    --
    IF l_restricted = LOGINS_ALLOWED THEN
      EXECUTE IMMEDIATE 'ALTER SYSTEM DISABLE RESTRICTED SESSION';
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      -- Bug 30763573: Always clear force internal convert parameter
      BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET "_pdb_char_set_intconv" = FALSE';
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;

      -- Always disable restricted session
      BEGIN
        IF l_restricted = LOGINS_ALLOWED THEN
          EXECUTE IMMEDIATE 'ALTER SYSTEM DISABLE RESTRICTED SESSION';
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
      RAISE;
  END change_character_set_int;


  -----------------------------------------------------------------------------
  --   get_external_auth_type - Get external authentication type
  -----------------------------------------------------------------------------
  FUNCTION get_external_auth_type(
    auth_param     IN  VARCHAR2 DEFAULT EXTAUTH_PARAM_IDENTITY
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   get_external_auth_type - Get external authentication type
    --
    -- DESCRIPTION:
    --   This is helper function to get the current external auth type.
    --
    -- PARAMETERS:
    --   None
    --
    -- NOTES:
    --   Added for bug 33157035.
    --
    l_value  VARCHAR2(M_VCSIZ_4K);
  BEGIN

    EXECUTE IMMEDIATE 'SELECT DECODE(UPPER(TRIM(value)), ''NONE'', NULL, ' ||
                      'value) FROM v$parameter WHERE name = :1'
            INTO l_value USING auth_param;
    RETURN l_value;

  EXCEPTION
    WHEN no_data_found THEN
      RETURN NULL;
  END get_external_auth_type;


  -----------------------------------------------------------------------------
  -- set_external_auth_type - Set external authentication type
  -----------------------------------------------------------------------------
  PROCEDURE set_external_auth_type(
        type     IN  VARCHAR2 DEFAULT NULL,
        region   IN  VARCHAR2 DEFAULT NULL,
        domain   IN  VARCHAR2 DEFAULT NULL

  )
  IS
    --
    -- NAME:
    --   set_external_auth_type - Set external authentication type
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure to set external authentication
    --   type.
    --
    -- PARAMETERS:
    --   type     (IN)   - external authentication type (optional)
    --
    --   region   (IN)   - region (optional)
    --
    --   domain   (IN)   - url domain (optional)
    --
    -- NOTES:
    --   Added for bug 33157035.
    --
    l_obj   JSON_OBJECT_T;
  BEGIN
    IF type IS NULL THEN
      -- Reset external authentication type
      EXECUTE IMMEDIATE 'ALTER SYSTEM RESET identity_provider_type SCOPE=BOTH';
      EXECUTE IMMEDIATE 'ALTER SYSTEM RESET identity_provider_config ' ||
                        'SCOPE=BOTH';

    ELSE
      -- Bug 33387897: Set identity provider parameters for enabling external
      -- authentication, instead of using dsi.ora
      l_obj := JSON_OBJECT_T('{}');
      l_obj.put('realmDomainComponent', domain);
      l_obj.put('regionIdentifier', region);
      l_obj.put('authServiceEndpoint',
                'https://auth.' || region || '.' || domain);
      l_obj.put('identityEndpoint',
                'https://identity.' || region || '.' || domain);

      -- Set external authentication type
      EXECUTE IMMEDIATE 'ALTER SYSTEM SET identity_provider_type = oci_iam';
      EXECUTE IMMEDIATE 'ALTER SYSTEM SET identity_provider_config = ''' ||
                        l_obj.to_clob || '''';
    END IF;
  END set_external_auth_type;



  -----------------------------------------------------------------------------
  --                     PUBLIC PROCEDURES AND FUNCTIONS
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- enable_app_cont - Enable Application Continuity for a service
  -----------------------------------------------------------------------------
  PROCEDURE enable_app_cont(
        service_name  IN  VARCHAR2
  )
  IS
    l_params         DBMS_SERVICE.svc_parameter_array;
  BEGIN

    -- Set the service attributes
    l_params('FAILOVER_TYPE')    := DBMS_SERVICE.FAILOVER_TYPE_TRANSACTION;
    l_params('FAILOVER_RESTORE') := DBMS_SERVICE.FAILOVER_RESTORE_BASIC;
    l_params('FAILOVER_DELAY')   := FAILOVER_DELAY_DEFAULT;
    l_params('FAILOVER_RETRIES') := FAILOVER_RETRIES_DEFAULT;
    l_params('DRAIN_TIMEOUT')    := DRAIN_TIMEOUT_DEFAULT;
    l_params('COMMIT_OUTCOME')   := 'true';
    l_params('STOP_OPTION')      := DBMS_SERVICE.STOP_OPTION_IMMEDIATE;
    l_params('REPLAY_INITIATION_TIMEOUT') := REPLAY_INITIATION_TIMEOUT_DEFAULT;

    -- Modify the service
    modify_service(service_name, l_params);

  END enable_app_cont;


  -----------------------------------------------------------------------------
  -- disable_app_cont - Disable Application Continuity for a service
  -----------------------------------------------------------------------------
  PROCEDURE disable_app_cont(
        service_name  IN  VARCHAR2
  )
  IS
    l_params         DBMS_SERVICE.svc_parameter_array;
  BEGIN

    -- Reset the service attributes
    l_params('FAILOVER_TYPE')    := DBMS_SERVICE.FAILOVER_TYPE_NONE;
    l_params('FAILOVER_RESTORE') := DBMS_SERVICE.FAILOVER_RESTORE_NONE;
    l_params('FAILOVER_DELAY')   := NULL;
    l_params('FAILOVER_RETRIES') := NULL;
    l_params('DRAIN_TIMEOUT')    := 0;
    l_params('COMMIT_OUTCOME')   := 'false';
    l_params('STOP_OPTION')      := DBMS_SERVICE.STOP_OPTION_NONE;
    l_params('REPLAY_INITIATION_TIMEOUT') := NULL;

    -- Modify the service
    modify_service(service_name, l_params);

  END disable_app_cont;


  -----------------------------------------------------------------------------
  -- change_character_set - Change database character set
  -----------------------------------------------------------------------------
  PROCEDURE change_character_set(
        name            IN  VARCHAR2,
        force           IN  BOOLEAN  DEFAULT FALSE
  )
  IS
  BEGIN

    -- Change database character set
    change_character_set_int(name  => name,
                             type  => CHAR_SET_TYPE_DB,
                             force => force);

  END change_character_set;


  -----------------------------------------------------------------------------
  -- change_national_character_set - Change national character set
  -----------------------------------------------------------------------------
  PROCEDURE change_national_character_set(
        name            IN  VARCHAR2,
        force           IN  BOOLEAN  DEFAULT FALSE
  )
  IS
  BEGIN

    -- Change national character set
    change_character_set_int(name  => name,
                             type  => CHAR_SET_TYPE_NCHAR,
                             force => force);

  END change_national_character_set;


  -----------------------------------------------------------------------------
  -- dv_prechecks - Helper routine doing various prechecks for DV related APIs
  -----------------------------------------------------------------------------
  PROCEDURE dv_prechecks(
        opcode           IN  NUMBER
  )
  IS
    l_dv_install  NUMBER;
    l_open_mode   DBMS_ID;
    l_restricted  VARCHAR2(3);
    l_dv_status   DBMS_ID;
  BEGIN
    -- We must be connected to an ADW PDB
    IF sys_context('userenv', 'con_id') < 2 THEN
      raise_application_error(-20000,
        'Operation cannot be performed outside a pluggable database');
    END IF;

    -- DV must be installed inside the PDB before it can be configured.
    SELECT count(1) INTO l_dv_install FROM dba_registry WHERE
      comp_id = 'DV' AND status = 'VALID';
    IF l_dv_install = 0 THEN
      raise_application_error(-20000,
          'Database Vault is not installed in the database');
    END IF;

    -- PDB should be open in READ WRITE mode for DV to be configured/enabled.
    -- Bug 30568387: PDB should NOT be in restricted mode either.
    SELECT open_mode, restricted INTO l_open_mode, l_restricted FROM v$pdbs;

    IF l_open_mode != 'READ WRITE' THEN
      raise_application_error(-20000,
          'Database is not open in READ WRITE mode');
    END IF;

    IF l_restricted = 'YES' THEN
      raise_application_error(-20000,
          'Database can not be open in RESTRICTED mode');
    END IF;

    -- Bug 30796514: {En|Dis}able_usermgmt_database_vault can only be called
    -- if DV is already configured.
    -- Bug 30952976: Switch to dynamic SQL to avoid failing this package
    -- creation in CTRL-1, where DV may not be installed.
    IF opcode IN (DV_ENABLE_USERMGMT, DV_DISABLE_USERMGMT) THEN
      EXECUTE IMMEDIATE 'SELECT status FROM dba_dv_status WHERE ' ||
                        ' name = ''DV_CONFIGURE_STATUS''' INTO l_dv_status;
      IF l_dv_status = 'FALSE' THEN
        raise_application_error(-20000,
          'Database Vault is not configured in the database');
      END IF;
    END IF;

  END dv_prechecks;


  -----------------------------------------------------------------------------
  -- get_apex_schema - Helper routine to get Apex schema name
  -----------------------------------------------------------------------------
  FUNCTION get_apex_schema
  RETURN VARCHAR2
  IS
    l_apex_install NUMBER;
    l_apex_schema  DBMS_ID;
  BEGIN
    -- Check for Apex install from registry$
    SELECT count(*), max(schema) INTO l_apex_install, l_apex_schema
      FROM sys.dba_registry WHERE comp_id='APEX' AND status='VALID';

    IF l_apex_install = 0 THEN
      RETURN NULL;
    ELSE
      RETURN l_apex_schema;
    END IF;

  END get_apex_schema;


  -----------------------------------------------------------------------------
  -- dv_enable_audit - Helper routine to enable various DV audit policies
  -----------------------------------------------------------------------------
  PROCEDURE dv_enable_audit(
        audit_polname   IN VARCHAR2
  )
  IS
    --
    -- NAME:
    --   dv_enable_audit - Enable DV Audit policies
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure to enable audit policies
    --   for enabling Data Vault. We exempt C##CLOUD$SERVICE from these
    --   audit policies, but if the customer has already enabled this
    --   audit policy, either for a white list of users or exempted
    --   certain users, we need to handle that, otherwise AUDIT DDL may
    --   hit ORA-46350 error.
    --
    --
    -- PARAMETERS:
    --   audit_polname        (IN) - name of DV unified audit policy
    --
    -- NOTES:
    --   Added for bug 30568387.
    --
    l_audpol_enable NUMBER         := 0;
    l_clouduser     DBMS_ID        := SYS_CONTEXT('USERENV','CURRENT_USER');
    l_enq_clouduser DBMS_QUOTED_ID := DBMS_ASSERT.enquote_name(l_clouduser,
                                                               FALSE);
    l_user_except   CLOB;
    l_cldusr_except BOOLEAN        := FALSE;
  BEGIN
    -- If the audit policy is NOT enabled, enable it.
    SELECT count(1) INTO l_audpol_enable FROM audit_unified_enabled_policies
      WHERE policy_name=audit_polname;

    -- Bug 30796514: Enclose the cloud user schema within double quotes as
    -- value returned from SYS_CONTEXT can be without enclosing quotes.
    IF l_audpol_enable = 0 THEN
      EXECUTE IMMEDIATE 'audit policy ' || audit_polname || ' except ' ||
                         l_enq_clouduser;
    ELSE
      FOR rec IN (SELECT enabled_option, entity_name FROM
                    audit_unified_enabled_policies WHERE
                    policy_name = audit_polname AND entity_type = 'USER')
      LOOP
        -- Nothing to do, if customer is using BY USER clause or cloud user
        -- schema is already part of EXCEPT USER list.
        IF (rec.enabled_option = 'BY USER' OR
            (rec.enabled_option = 'EXCEPT USER' AND
             rec.entity_name = l_clouduser)) THEN
          l_user_except := null;
          exit;
        ELSE
          -- Cloud user is NOT part of EXCEPT USER list, need to add it and
          -- preserve the original EXCEPT USER list.
          IF l_user_except IS NULL THEN
            l_user_except := DBMS_ASSERT.enquote_name(rec.entity_name, FALSE);
          ELSE
            l_user_except := l_user_except || ',' ||
                             DBMS_ASSERT.enquote_name(rec.entity_name, FALSE);
          END IF;
          -- Remember whether cloud service user is part of exception list so
          -- that we can add it in, if needed.
          IF (rec.entity_name = l_clouduser) THEN
            l_cldusr_except := TRUE;
          END IF;
        END IF;
      END LOOP;

      IF (l_user_except IS NOT NULL) THEN
        IF NOT l_cldusr_except THEN
          l_user_except := l_user_except || ',' || l_enq_clouduser;
        END IF;
        EXECUTE IMMEDIATE 'audit policy ' || audit_polname || ' except ' ||
                           l_user_except;
      END IF;

    END IF;
  END dv_enable_audit;


  -----------------------------------------------------------------------------
  -- dv_change_audit - Helper routine {en|dis}abling various DV audit policies
  -----------------------------------------------------------------------------
  PROCEDURE dv_change_audit(
        enable          IN  BOOLEAN DEFAULT FALSE
  )
  IS
  BEGIN
    IF enable = TRUE THEN
      -- Enable auditing for all actions done against DVSYS|DVF schema
      dv_enable_audit('ORA_DV_AUDPOL');

      -- Enable auditing for default realms/command rules violations
      dv_enable_audit('ORA_DV_AUDPOL2');

      -- Enable auditing for users with DV_PATCH_ADMIN role grant
      EXECUTE IMMEDIATE 'begin ' ||
                        '  DVSYS.DBMS_MACADM.ENABLE_DV_PATCH_ADMIN_AUDIT; ' ||
                        'end;';
    ELSE
      -- Disable auditing for all actions done against DVSYS|DVF schema
      EXECUTE IMMEDIATE 'noaudit policy ORA_DV_AUDPOL';

      -- Disable auditing for default realms/command rules violations
      EXECUTE IMMEDIATE 'noaudit policy ORA_DV_AUDPOL2';

      -- Disable auditing for users with DV_PATCH_ADMIN role grant
      EXECUTE IMMEDIATE 'begin ' ||
                        '  DVSYS.DBMS_MACADM.DISABLE_DV_PATCH_ADMIN_AUDIT; ' ||
                        'end;';
    END IF;

  END dv_change_audit;


  -----------------------------------------------------------------------------
  -- rotate_encryption_key - Rotate encryption key
  -----------------------------------------------------------------------------
  PROCEDURE rotate_encryption_key(
    enc_key                IN VARCHAR2,
    vault_key_details      IN VARCHAR2,
    key_id                 IN VARCHAR2 DEFAULT NULL
  )
  IS
  PRAGMA AUTONOMOUS_TRANSACTION;
    l_stmt                  VARCHAR2(M_VCSIZ_4K);
    l_key_type              VARCHAR2(128);
    l_key_id                VARCHAR2(128);
    l_vault_key_details_t   JSON_OBJECT_T := JSON_OBJECT_T();
    l_vault_key_details_str VARCHAR2(M_VCSIZ_4K);
  BEGIN

    -- Jira ADBS-20905. New signature for KMS rotate key
    IF key_id IS NULL THEN
      IF vault_key_details IS NULL THEN
        l_stmt := 'ADMINISTER KEY MANAGEMENT SET ENCRYPTION KEY ' ||
                  'FORCE KEYSTORE IDENTIFIED BY EXTERNAL STORE WITH BACKUP ';
      ELSE
        l_stmt := 'ADMINISTER KEY MANAGEMENT SET ENCRYPTION KEY ' ||
                   NULLIF(DBMS_ASSERT.enquote_literal(enc_key), '''''') ||
                   ' USING TAG ' ||
                   DBMS_ASSERT.enquote_literal(vault_key_details) ||
                   ' FORCE KEYSTORE IDENTIFIED BY EXTERNAL STORE WITH BACKUP ';
      END IF;
      l_key_type := 'CUSTOMER_MANAGED_KEY';
    ELSE
        l_stmt := 'ADMINISTER KEY MANAGEMENT USE KEY ' ||
                  DBMS_ASSERT.enquote_literal(key_id) ||
                  ' FORCE KEYSTORE IDENTIFIED BY EXTERNAL STORE WITH BACKUP ';
        l_key_type := 'ORACLE_MANAGED_KEY';
        l_vault_key_details_t.put('key_id', key_id);
    END IF;

    -- Set the encryption key
    EXECUTE IMMEDIATE l_stmt;

    -- Add latest v$encryption_keys.key_id to l_vault_key_details_t
    -- for Customer Managed Key case
    IF vault_key_details IS NOT NULL THEN
      l_vault_key_details_t := JSON_OBJECT_T(vault_key_details);
      BEGIN
        l_stmt := 'SELECT key_id from v$encryption_keys where ' ||
                  'activation_time = (select max(activation_time) ' ||
                  'from v$encryption_keys)';
        EXECUTE IMMEDIATE l_stmt INTO l_key_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL;
      END;
      l_vault_key_details_t.put('key_id', l_key_id);
    END IF;
    l_vault_key_details_str := l_vault_key_details_t.to_string();

    l_stmt := 'INSERT INTO ENC_KEY_INFO VALUES ' ||
                  '(sysdate, ''' || l_key_type || ''', ''' ||
                   l_vault_key_details_str|| ''')';
    EXECUTE IMMEDIATE l_stmt;

    COMMIT;

  END rotate_encryption_key;


  -----------------------------------------------------------------------------
  --  get_encryption_key_info - Get information on encryption Key
  -----------------------------------------------------------------------------
  FUNCTION get_encryption_key_info
  RETURN JSON_OBJECT_T
  IS
    l_stmt        VARCHAR2(M_VCSIZ_4K);
    l_key_type    VARCHAR2(M_VCSIZ_4K);
    l_tag         VARCHAR2(M_VCSIZ_4K);
    l_tag_t       JSON_OBJECT_T;
    l_key_info_t  JSON_OBJECT_T;
    cur           INTEGER;
    execres       INTEGER;
  BEGIN
    l_stmt := 'select key_type, key_info from enc_key_info where ' ||
              'activation_time = (select max(activation_time) from ' ||
              'enc_key_info)';

    BEGIN
      EXECUTE IMMEDIATE l_stmt INTO l_key_type, l_tag;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;

    l_key_info_t := JSON_OBJECT_T();
    IF l_key_type is NULL OR l_key_type = 'ORACLE_MANAGED_KEY' THEN
      l_key_info_t.put('Key Type', 'Oracle Managed Key');
    ELSE
      l_key_info_t.put('Key Type', 'Customer Managed Key');
      l_tag_t := JSON_OBJECT_T(l_tag);
      l_key_info_t.put('Master Key Id', l_tag_t.get_string('master_key_id'));
    END IF;

    RETURN l_key_info_t;

  EXCEPTION
    WHEN OTHERS THEN
      IF DBMS_SQL.is_open(cur) THEN
        DBMS_SQL.close_cursor(cur);
      END IF;
    RAISE;

  END get_encryption_key_info;


  -----------------------------------------------------------------------------
  -- enable_external_authentication - Enable external authentication to DB
  -----------------------------------------------------------------------------
  PROCEDURE enable_external_authentication(
        type    IN  VARCHAR2,
        force   IN  BOOLEAN  DEFAULT FALSE
  )
  IS
    l_type     VARCHAR2(M_VCSIZ_4K);
    l_contents CLOB;
    l_region   DBMS_ID;
    l_domain   DBMS_ID;
  BEGIN

    -- Validation for external authentication type
    -- Bug 33387897: check for both identity auth parameters to detect if
    -- LDAP or IAM is enabled
    l_type := NVL(get_external_auth_type(EXTAUTH_PARAM_IDENTITY),
                  get_external_auth_type(EXTAUTH_PARAM_LDAP));
    IF l_type IS NOT NULL THEN
      IF l_type = type THEN
        IF force THEN
          -- Nothing to do
          RETURN;
        ELSE
          raise_application_error(-20004,
              'External authentication ' || l_type || ' is already enabled.');
        END IF;
      END IF;

      -- Check for overwriting external authentication
      IF NOT force THEN
        raise_application_error(-20004,
          'External authentication ' || l_type || ' is already enabled. ' ||
          CHR(10) || 'Use force argument to override external authentication.');
      END IF;
    END IF;

    -- 1.1 Determine the current region
    BEGIN
      EXECUTE IMMEDIATE 'SELECT JSON_VALUE(cloud_identity, ''$.REGION'') ' ||
                        'FROM v$pdbs WHERE con_id = :1'
              INTO l_region USING SYS_CONTEXT('USERENV', 'CON_ID');
    EXCEPTION
      WHEN no_data_found THEN
        NULL;
    END;
    IF l_region IS NULL THEN
      raise_application_error(-20004,
          'Unable to identify external authentication endpoints.');
    END IF;

    -- 1.2 Determine the current domain
    l_domain := NVL(DBMS_CLOUD_CAPABILITY.get_config_param('_domain_name'),
                    'oraclecloud.com');

    -- 2. Set external authentication type
    set_external_auth_type(type   => type,
                           region => l_region,
                           domain => l_domain
    );

  END enable_external_authentication;


  -----------------------------------------------------------------------------
  -- disable_external_authentication - Disable external authentication to DB
  -----------------------------------------------------------------------------
  PROCEDURE disable_external_authentication
  IS
  BEGIN

    -- Validation for external authentication type
    IF get_external_auth_type(EXTAUTH_PARAM_IDENTITY) IS NULL THEN
      raise_application_error(-20004,
          'IAM External authentication is not enabled.');
    END IF;

    -- Clear external authentication type
    set_external_auth_type;

  END disable_external_authentication;


  -----------------------------------------------------------------------------
  -- get_reverse_link_address - Get Reverse Link Address
  -----------------------------------------------------------------------------
  FUNCTION get_reverse_link_address(
        private_ip IN VARCHAR2
  ) RETURN VARCHAR2
  IS
    l_ctx                 DBMS_CLOUD_REQUEST.request_context_t;
    l_rsp                 UTL_HTTP.resp;
    l_private_ip          DBMS_ID;
    l_credential_name     DBMS_QUOTED_ID;
    l_endpoint            VARCHAR2(MAX_URI_LEN);
    l_cloud_identity      CLOB;
    l_cloud_identity_json JSON_OBJECT_T;
    l_buffer_raw          RAW(M_VCSIZ_4K);
    l_data                CLOB;
    l_address             VARCHAR2(M_VCSIZ_4K);
  BEGIN
    -- Check for IP address length
    IF LENGTH(TRIM(private_ip)) > M_IDEN THEN
      raise_application_error(DBMS_CLOUD.EXCP_IDEN_TOO_LONG,
             'IP address is too long');
    END IF;

    -- Trim the IP address
    l_private_ip := TRIM(private_ip);

    -- IP address cannot be empty
    IF l_private_ip IS NULL THEN
      raise_application_error(-20000, 'Missing IP address');
    END IF;

    -- Validate the Private IP for URL injection
    IF NOT REGEXP_LIKE(l_private_ip, '^([[:digit:]]+\.){3}[[:digit:]]+') THEN
      raise_application_error(-20000, 'Invalid IP address - ' || l_private_ip);
    END IF;

    -- Get the token endpoint and credential
    l_endpoint        := REPLACE(DBMS_CLOUD_CAPABILITY.get_config_param(
                                   '_rpst_endpoint'),
                                 RPST_ENDPOINT,
                                 REVERSE_LINK_ENDPOINT);
    l_credential_name := DBMS_CLOUD_CAPABILITY.get_config_param(
                              '_rpst_credential');
    EXECUTE IMMEDIATE 'SELECT cloud_identity FROM v$pdbs'
        INTO l_cloud_identity;

    IF l_endpoint IS NOT NULL AND
       l_credential_name IS NOT NULL AND
       l_cloud_identity IS NOT NULL
    THEN
      -- Add tenant and database ocid in the endpoint
      l_cloud_identity_json := JSON_OBJECT_T.parse(l_cloud_identity);
      l_endpoint := REPLACE(l_endpoint, '<tenant_ocid>',
                            l_cloud_identity_json.get_string('TENANT_OCID'));
      l_endpoint := REPLACE(l_endpoint, '<database_name>',
                            l_cloud_identity_json.get_string('DATABASE_NAME'));

      -- Initialize Request
      l_ctx := DBMS_CLOUD_REQUEST.init_request(
                    invoker_schema  => 'C##CLOUD$SERVICE',
                    credential_name => l_credential_name,
                    base_uri        => l_endpoint,
                    method          => DBMS_CLOUD.METHOD_GET,
                    operation       => 'broker'
               );
      l_rsp := DBMS_CLOUD_REQUEST.send_request(context => l_ctx,
                                               path    => l_private_ip);

      -- Loop to get the entire response
      BEGIN
        LOOP
          UTL_HTTP.read_raw(l_rsp, l_buffer_raw, M_VCSIZ_4K);
          l_data := l_data || UTL_RAW.cast_to_varchar2(l_buffer_raw);
        END LOOP;

        DBMS_CLOUD_REQUEST.end_request(l_rsp);

      EXCEPTION
        WHEN UTL_HTTP.end_of_body THEN
          DBMS_CLOUD_REQUEST.end_request(l_rsp);
      END;

      -- Get the reverse link IP from the response payload
      l_address := JSON_OBJECT_T.parse(NVL(l_data, '{}')).
                        get_string('reverse_connection_nat_ip');

    END IF;

    -- Check if we found an address
    IF l_address IS NULL THEN
      raise_application_error(-20000,
          'Unable to obtain reverse link address - ' || SQLCODE);
    END IF;

    -- Return the reverse link address
    RETURN l_address;

  EXCEPTION
    WHEN OTHERS THEN
      -- End the response to avoid leaking HTTP connection
      DBMS_CLOUD_REQUEST.end_request(l_rsp);

      raise_application_error(-20000,
          'Unable to obtain reverse link address - ORA' || SQLCODE);
  END get_reverse_link_address;


END dbms_cloud_admin_internal; -- End of DBMS_CLOUD_ADMIN_INTERNAL Package
/
