CREATE OR REPLACE NONEDITIONABLE PACKAGE C##CLOUD$SERVICE.dbms_cloud AUTHID CURRENT_USER AS

  -----------------------------------------------------------------------------
  --                                CONSTANTS
  -----------------------------------------------------------------------------

  -- Compression schemes supported for objects
  COMPRESS_NONE            CONSTANT DBMS_ID := NULL;
  COMPRESS_AUTO            CONSTANT DBMS_ID := 'AUTO';
  COMPRESS_DETECT          CONSTANT DBMS_ID := 'DETECT';
  COMPRESS_GZIP            CONSTANT DBMS_ID := 'GZIP';
  COMPRESS_ZLIB            CONSTANT DBMS_ID := 'ZLIB';
  COMPRESS_BZIP2           CONSTANT DBMS_ID := 'BZIP2';

  -- Datapump Compresion values
  COMPRESS_BASIC           CONSTANT DBMS_ID := 'BASIC';
  COMPRESS_LOW             CONSTANT DBMS_ID := 'LOW';
  COMPRESS_MEDIUM          CONSTANT DBMS_ID := 'MEDIUM';
  COMPRESS_HIGH            CONSTANT DBMS_ID := 'HIGH';

  --
  -- Constants for FORMAT option JSON keys in create_external_table / copy_data
  --
  -- Record parameters
  FORMAT_RECORD_DELIMITER  CONSTANT DBMS_ID := 'recorddelimiter';
  FORMAT_SKIP_HEADERS      CONSTANT DBMS_ID := 'skipheaders';
  FORMAT_CHARACTERSET      CONSTANT DBMS_ID := 'characterset';
  FORMAT_ESCAPE            CONSTANT DBMS_ID := 'escape';
  FORMAT_IGN_BLANK_LINES   CONSTANT DBMS_ID := 'ignoreblanklines';
  FORMAT_READSIZE          CONSTANT DBMS_ID := 'readsize';
  FORMAT_COMPRESSION       CONSTANT DBMS_ID := 'compression';
  FORMAT_LANGUAGE          CONSTANT DBMS_ID := 'language';
  FORMAT_TERRITORY         CONSTANT DBMS_ID := 'territory';
  FORMAT_ENDIAN            CONSTANT DBMS_ID := 'endian';


  -- Field parameters
  FORMAT_TYPE              CONSTANT DBMS_ID := 'type';
  FORMAT_FIELD_DELIMITER   CONSTANT DBMS_ID := 'delimiter';
  FORMAT_QUOTE             CONSTANT DBMS_ID := 'quote';
  FORMAT_END_QUOTE         CONSTANT DBMS_ID := 'endquote';
  FORMAT_IGN_MISSING_COLS  CONSTANT DBMS_ID := 'ignoremissingcolumns';
  FORMAT_TRUNCATE_COLUMNS  CONSTANT DBMS_ID := 'truncatecol';
  FORMAT_REMOVE_QUOTES     CONSTANT DBMS_ID := 'removequotes';
  FORMAT_BLANK_AS_NULL     CONSTANT DBMS_ID := 'blankasnull';
  FORMAT_TRIM_SPACES       CONSTANT DBMS_ID := 'trimspaces';
  FORMAT_CONVERSION_ERRORS CONSTANT DBMS_ID := 'conversionerrors';
  FORMAT_DATE              CONSTANT DBMS_ID := 'dateformat';
  FORMAT_TIMESTAMP         CONSTANT DBMS_ID := 'timestampformat';
  FORMAT_TIMESTAMP_TZ      CONSTANT DBMS_ID := 'timestamptzformat';
  FORMAT_TIMESTAMP_LTZ     CONSTANT DBMS_ID := 'timestampltzformat';
  FORMAT_NUMERIC_CHARS     CONSTANT DBMS_ID := 'numericcharacters';
  FORMAT_NUMBER_FORMAT     CONSTANT DBMS_ID := 'numberformat';
  FORMAT_ROW_SIZE          CONSTANT DBMS_ID := 'rowsize';
  FORMAT_MAX_FILE_SIZE     CONSTANT DBMS_ID := 'maxfilesize';
  FORMAT_FILE_EXTENSION    CONSTANT DBMS_ID := 'fileextension';
  FORMAT_SINGLE_FILE       CONSTANT DBMS_ID := 'singlefile';
  FORMAT_PARTITION_COLUMNS CONSTANT DBMS_ID := 'partition_columns';
  FORMAT_FILE_URI_LIST     CONSTANT DBMS_ID := 'file_uri_list';

  -- Bigdata parameters
  FORMAT_BD_PREFIX         CONSTANT DBMS_ID := 'com.oracle.bigdata.';
  FORMAT_BD_CRED_NAME      CONSTANT DBMS_ID := 'credential.name';
  FORMAT_BD_CRED_SCHEMA    CONSTANT DBMS_ID := 'credential.schema';
  FORMAT_BD_SCHEMA         CONSTANT DBMS_ID := 'schema';
  FORMAT_BD_SCHEMA_ALL     CONSTANT DBMS_ID := 'all';
  FORMAT_BD_SCHEMA_FIRST   CONSTANT DBMS_ID := 'first';
  FORMAT_BD_SCHEMA_NONE    CONSTANT DBMS_ID := 'none';
  FORMAT_BD_FILE_FORMAT    CONSTANT DBMS_ID := 'fileformat';
  FORMAT_BD_CSV_SKIP_HD    CONSTANT DBMS_ID := 'csv.skip.header';
  FORMAT_BD_FILENAME_CL    CONSTANT DBMS_ID := 'filename.columns';

  -- Datapump parameters
  FORMAT_ENCRYPTION        CONSTANT DBMS_ID := 'encryption';
  FORMAT_VERSION           CONSTANT DBMS_ID := 'version';

  -- Datapump Version values
  VERSION_COMPATIBLE       CONSTANT DBMS_ID := 'COMPATIBLE';
  VERSION_LATEST           CONSTANT DBMS_ID := 'LATEST';

  -- Reject Limit parameter
  FORMAT_REJECT_LIMIT      CONSTANT DBMS_ID := 'rejectlimit';

  -- Additional format parameters
  FORMAT_LOG_DIR           CONSTANT DBMS_ID := 'logdir';
  FORMAT_LOG_PREFIX        CONSTANT DBMS_ID := 'logprefix';
  FORMAT_LOG_RETENTION     CONSTANT DBMS_ID := 'logretention';


  -- Values for FORMAT_TYPE JSON Key
  FORMAT_TYPE_CSV                   CONSTANT DBMS_ID := 'CSV';
  FORMAT_TYPE_CSV_WITH_EMBEDDED     CONSTANT DBMS_ID := 'CSV WITH EMBEDDED';
  FORMAT_TYPE_CSV_WITHOUT_EMBEDDED  CONSTANT DBMS_ID := FORMAT_TYPE_CSV;
  FORMAT_TYPE_AVRO                  CONSTANT DBMS_ID := 'AVRO';
  FORMAT_TYPE_PARQUET               CONSTANT DBMS_ID := 'PARQUET';
  FORMAT_TYPE_ORC                   CONSTANT DBMS_ID := 'ORC';
  FORMAT_TYPE_DATAPUMP              CONSTANT DBMS_ID := 'DATAPUMP';
  FORMAT_TYPE_JSON                  CONSTANT DBMS_ID := 'JSON';
  FORMAT_TYPE_EJSON                 CONSTANT DBMS_ID := 'EJSON';
  FORMAT_TYPE_TEXT                  CONSTANT DBMS_ID := 'TXT';
  FORMAT_TYPE_XML                   CONSTANT DBMS_ID := 'XML';

  -- Values for FORMAT_CONVERSION_ERROR JSON Key
  FORMAT_CONVERR_REJECT_RECORD   CONSTANT DBMS_ID := 'REJECT_RECORD';
  FORMAT_CONVERR_STORE_NULL      CONSTANT DBMS_ID := 'STORE_NULL';

  -- Values for FORMAT_TRIM JSON Key
  FORMAT_TRIM_NOTRIM       CONSTANT DBMS_ID := 'NOTRIM';
  FORMAT_TRIM_LTRIM        CONSTANT DBMS_ID := 'LTRIM';
  FORMAT_TRIM_RTRIM        CONSTANT DBMS_ID := 'RTRIM';
  FORMAT_TRIM_LRTRIM       CONSTANT DBMS_ID := 'LRTRIM';
  FORMAT_TRIM_LDRTRIM      CONSTANT DBMS_ID := 'LDRTRIM';

  -- Special Value for FORMAT_FIELD_DELIMITER JSON Key
  FORMAT_DELIMITER_WHITESPACE       CONSTANT DBMS_ID := 'WHITESPACE';

  -- Values for FORMAT_ENDIAN JSON Key
  FORMAT_BIG_ENDIAN        CONSTANT DBMS_ID := 'BIG';
  FORMAT_LITTLE_ENDIAN     CONSTANT DBMS_ID := 'LITTLE';

  -- Values for FORMAT_ROW_SIZE JSON Key
  FORMAT_ROW_SMALL           CONSTANT DBMS_ID := 'SMALL';
  FORMAT_ROW_LARGE           CONSTANT DBMS_ID := 'LARGE';

  -- SODA parameters
  FORMAT_UNPACKARRAYS        CONSTANT DBMS_ID := 'unpackarrays';
  FORMAT_JSON_PATH           CONSTANT DBMS_ID := 'jsonpath';
  FORMAT_JSON_DOC_MAXSIZE    CONSTANT DBMS_ID := 'maxdocsize';
  FORMAT_JSON_KEYPATH        CONSTANT DBMS_ID := 'keypath';
  FORMAT_JSON_KEYASSIGNMENT  CONSTANT DBMS_ID := 'keyassignment';

  -- DBMS_CLOUD.copy_data JSON import parameters
  FORMAT_COLUMN_PATH           CONSTANT DBMS_ID := 'columnpath';

  -- List object fields
  LIST_OBJ_FIELD_NAME        CONSTANT DBMS_ID := 'name';
  LIST_OBJ_FIELD_BYTES       CONSTANT DBMS_ID := 'bytes';
  LIST_OBJ_FIELD_CHECKSUM    CONSTANT DBMS_ID := 'checksum';
  LIST_OBJ_FIELD_CREATED     CONSTANT DBMS_ID := 'created';
  LIST_OBJ_FIELD_CREATED_FMT CONSTANT DBMS_ID := 'created_fmt';
  LIST_OBJ_FIELD_LASTMOD     CONSTANT DBMS_ID := 'last_modified';
  LIST_OBJ_FIELD_LASTMOD_FMT CONSTANT DBMS_ID := 'last_modified_fmt';

  -- HTTPS Request Methods
  METHOD_GET         CONSTANT VARCHAR2(3)  := 'GET';
  METHOD_PUT         CONSTANT VARCHAR2(3)  := 'PUT';
  METHOD_HEAD        CONSTANT VARCHAR2(4)  := 'HEAD';
  METHOD_POST        CONSTANT VARCHAR2(4)  := 'POST';
  METHOD_DELETE      CONSTANT VARCHAR2(6)  := 'DELETE';
  METHOD_PATCH       CONSTANT VARCHAR2(5)  := 'PATCH';

  -- OCI Resource Principal credential
  OCI_RPST_CRED              CONSTANT DBMS_ID := '"OCI$RESOURCE_PRINCIPAL"';

  -- AWS ARN credential
  AWS_ARN_CRED               CONSTANT DBMS_ID := '"AWS$ARN"';

  -- GCP Principal Authentication credential
  GCP_PA_CRED                CONSTANT DBMS_ID := '"GCP$PA"';

  -- AWS ARN based Credential External ID types
  DATABASE_OCID            CONSTANT DBMS_ID  := 'DATABASE_OCID';
  COMPARTMENT_OCID         CONSTANT DBMS_ID  := 'COMPARTMENT_OCID';
  TENANT_OCID              CONSTANT DBMS_ID  := 'TENANT_OCID';

  -- AWS ARN based Credential maximum session duration (in Minutes)
  AWS_DEFAULT_MAX_SESSION_DURATION  CONSTANT  NUMBER := 60;
  AWS_MAXIMUM_MAX_SESSION_DURATION  CONSTANT  NUMBER := 720;
  AWS_MINIMUM_MAX_SESSION_DURATION  CONSTANT  NUMBER := 15;

  --
  -- Exceptions
  --
  EXCP_REJECT_LIMIT          CONSTANT NUMBER := -20003;
  EXCP_CRED_NOT_EXIST        CONSTANT NUMBER := -20004;
  EXCP_TABLE_NOT_EXIST       CONSTANT NUMBER := -20005;
  EXCP_UNSUPP_OBJ_STORE      CONSTANT NUMBER := -20006;
  EXCP_INVALID_SQL_NAME      CONSTANT NUMBER := -20007;
  EXCP_IDEN_TOO_LONG         CONSTANT NUMBER := -20008;
  EXCP_INVALID_FORMAT        CONSTANT NUMBER := -20009;
  EXCP_INVALID_CRED          CONSTANT NUMBER := -20010;
  EXCP_INVALID_OBJ_URI       CONSTANT NUMBER := -20011;
  EXCP_INVALID_PART_CLAUSE   CONSTANT NUMBER := -20012;
  EXCP_UNSUPP_FEATURE        CONSTANT NUMBER := -20013;
  EXCP_PART_NOT_EXIST        CONSTANT NUMBER := -20014;
  -- EXCP_unused1            CONSTANT NUMBER := -20015;
  EXCP_INVALID_TABLE_NAME    CONSTANT NUMBER := -20016;
  EXCP_INVALID_SCHEMA_NAME   CONSTANT NUMBER := -20017;
  EXCP_INVALID_DIR_NAME      CONSTANT NUMBER := -20018;
  EXCP_INVALID_FILE_NAME     CONSTANT NUMBER := -20019;
  EXCP_INVALID_CRED_ATTR     CONSTANT NUMBER := -20020;
  EXCP_TABLE_EXIST           CONSTANT NUMBER := -20021;
  EXCP_CRED_EXIST            CONSTANT NUMBER := -20022;
  EXCP_INVALID_REQ_METHOD    CONSTANT NUMBER := -20023;
  EXCP_INVALID_REQ_HEADER    CONSTANT NUMBER := -20024;
  EXCP_FILE_NOT_EXIST        CONSTANT NUMBER := -20025;
  EXCP_INVALID_RESPONSE      CONSTANT NUMBER := -20026;
  EXCP_INVALID_OPERATION     CONSTANT NUMBER := -20027;
  EXCP_INVALID_USER_NAME     CONSTANT NUMBER := -20028;
  EXCP_INVALID_CHAR_SET      CONSTANT NUMBER := -20029;
  EXCP_INVALID_ENC_KEY_ATTR  CONSTANT NUMBER := -20030;
  EXCP_RPST_ENABLED          CONSTANT NUMBER := -20031;
  EXCP_INVALID_API_RESULT_CACHE_SIZE
                             CONSTANT NUMBER := -20032;
  EXCP_INVALID_EXTERNAL_ID_TYPE
                             CONSTANT NUMBER := -20033;
  EXCP_AWS_ARN_DISABLED      CONSTANT NUMBER := -20034;
  EXCP_INVALID_MAX_SESSION_DURATION
                             CONSTANT NUMBER := -20035;
  EXCP_INVALID_CRYPTO_ENDPOINT
                             CONSTANT NUMBER := -20036;
  EXCP_MASTER_KEY_ID_NOT_EXIST
                             CONSTANT NUMBER := -20037;
  EXCP_MASTER_KEY_ID_DISABLED
                             CONSTANT NUMBER := -20038;
  EXCP_CUSTOMER_MANAGED_KEY_ERROR
                             CONSTANT NUMBER := -20039;
  EXCP_ORACLE_MANAGED_KEY_ERROR
                             CONSTANT NUMBER := -20040;
  EXCP_INVALID_CRED_PARAMS
                             CONSTANT NUMBER := -20041;
  EXCP_INVALID_API_RESULT_CACHE_SCOPE
                             CONSTANT NUMBER := -20042;

  reject_limit EXCEPTION;
  PRAGMA EXCEPTION_INIT(reject_limit, -20003);

  credential_not_exist EXCEPTION;
  PRAGMA EXCEPTION_INIT(credential_not_exist, -20004);

  table_not_exist EXCEPTION;
  PRAGMA EXCEPTION_INIT(table_not_exist, -20005);

  unsupported_obj_store EXCEPTION;
  PRAGMA EXCEPTION_INIT(unsupported_obj_store, -20006);

  invalid_sql_name EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_sql_name, -20007);

  iden_too_long EXCEPTION;
  PRAGMA EXCEPTION_INIT(iden_too_long, -20008);

  invalid_format EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_format, -20009);

  missing_credential EXCEPTION;
  PRAGMA EXCEPTION_INIT(missing_credential, -20010);

  invalid_object_uri EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_object_uri, -20011);

  invalid_partitioning_clause EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_partitioning_clause, -20012);

  unsupported_feature EXCEPTION;
  PRAGMA EXCEPTION_INIT(unsupported_feature, -20013);

  part_not_exist EXCEPTION;
  PRAGMA EXCEPTION_INIT(part_not_exist, -20014);

  invalid_table_name EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_table_name, -20016);

  invalid_schema_name EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_schema_name, -20017);

  invalid_dir_name EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_dir_name, -20018);

  invalid_file_name EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_file_name, -20019);

  invalid_cred_attribute EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_cred_attribute, -20020);

  table_exist EXCEPTION;
  PRAGMA EXCEPTION_INIT(table_exist, -20021);

  credential_exist EXCEPTION;
  PRAGMA EXCEPTION_INIT(credential_exist, -20022);

  invalid_req_method EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_req_method, -20023);

  invalid_req_header EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_req_header, -20024);

  file_not_exist EXCEPTION;
  PRAGMA EXCEPTION_INIT(file_not_exist, -20025);

  invalid_response EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_response, -20026);

  invalid_operation EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_operation, -20027);

  invalid_user_name EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_user_name, -20028);

  invalid_char_set EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_char_set, -20029);

  invalid_enc_key_attr EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_enc_key_attr, -20030);

  rpst_enabled EXCEPTION;
  PRAGMA EXCEPTION_INIT(rpst_enabled, -20031);

  invalid_api_result_cache_size EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_api_result_cache_size, -20032);

  invalid_external_id_type EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_external_id_type, -20033);

  aws_arn_disabled EXCEPTION;
  PRAGMA EXCEPTION_INIT(aws_arn_disabled, -20034);

  invalid_max_session_duration EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_max_session_duration, -20035);

  invalid_crypto_endpoint EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_crypto_endpoint, -20036);

  master_key_id_not_exist EXCEPTION;
  PRAGMA EXCEPTION_INIT(master_key_id_not_exist, -20037);

  master_key_id_disabled EXCEPTION;
  PRAGMA EXCEPTION_INIT(master_key_id_disabled, -20038);

  customer_managed_key_error EXCEPTION;
  PRAGMA EXCEPTION_INIT(customer_managed_key_error, -20039);

  oracle_managed_key_error EXCEPTION;
  PRAGMA EXCEPTION_INIT(oracle_managed_key_error, -20040);

  invalid_cred_params EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_cred_params, -20041);

  invalid_api_result_cache_scope EXCEPTION;
  PRAGMA EXCEPTION_INIT(invalid_api_result_cache_scope, -20042);

  -----------------------------------------------------------------------------
  --                     PUBLIC PROCEDURES AND FUNCTIONS
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- create_credential  - Create a Credential object to access any Object Store
  -----------------------------------------------------------------------------
  PROCEDURE create_credential(
        credential_name  IN  VARCHAR2,
        username         IN  VARCHAR2,
        password         IN  VARCHAR2 DEFAULT NULL
  );

  PROCEDURE create_credential(
        credential_name  IN  VARCHAR2,
        user_ocid        IN  VARCHAR2 DEFAULT NULL,
        tenancy_ocid     IN  VARCHAR2 DEFAULT NULL,
        private_key      IN  VARCHAR2,
        fingerprint      IN  VARCHAR2 DEFAULT NULL,
        rpst             IN  VARCHAR2 DEFAULT NULL
  );

  PROCEDURE create_credential(
        credential_name       IN  VARCHAR2,
        params                IN  CLOB DEFAULT NULL
  );
    --
    -- NAME:
    --  create_credential - Create Credential object to access any Object Store
    --
    -- DESCRIPTION:
    --   This procedure creates a credential object in the database using
    --   DBMS_CREDENTIAL package, which can then be used by DBMS_CLOUD package
    --   to authenticate with any Object Store. The credential object can be
    --   found in DBA_CREDENTIALS view.
    --
    --   For Oracle Bare Metal Cloud (BMC) Objectstore, a private key in PEM
    --   format and the User/Tenancy OCID identifiers are required arguments.
    --   See NOTES section below for more details on Oracle BMC ObjectStore.
    --
    --   For Amazon S3, the access_key should be specified as username and
    --   the secret_key should be specified as password.
    --
    --   For any SWIFT based Object store, username and password are the
    --   required arguments.
    --
    --   For Amazon Resource Name(ARN) based authentication, AWS role arn is
    --   the required argument.
    --
    -- PARAMETERS:
    --   credential_name  (IN) - Name of the Credential object to be created
    --
    --   username         (IN) - User name for the object store
    --
    --   user_ocid        (IN) - User's OCID for Oracle Bare Metal Cloud store
    --
    --   password         (IN) - Password for the object store account
    --
    --   tenancy_ocid     (IN) - Tenancy OCID for Oracle Bare Metal Cloud store
    --
    --   private_key      (IN) - RSA Private Key in PEM format for Oracle Bare
    --                           Metal Cloud store. The private key should not
    --                           be encrypted with passphrase.
    --
    --   fingerprint      (IN) - finger print of RSA Private Key
    --
    --   rpst             (IN) - Resource principal session token
    --
    --   params           (IN) - Credential parameters
    --
    -- EXAMPLE:
    --   -- 1. Swift ObjectStore
    --   BEGIN
    --       DBMS_CLOUD.create_credential(
    --           credential_name => 'BMC',
    --           username        => 'FOO',
    --           password        => 'FOOPASS'
    --       );
    --   END;
    --   /
    --
    --   -- 2. Amazon S3
    --   BEGIN
    --       DBMS_CLOUD.create_credential(
    --           credential_name => 'AWS',
    --           username        => '<access_key_value>',
    --           password        => '<secret_key_value>'
    --       );
    --   END;
    --   /
    --
    --
    -- NOTES:
    --   For Oracle Bare Metal Cloud Object Store:
    --     1. Generating a new RSA Private key in PEM format:
    --          openssl genrsa -out ~/.oraclebmc/bmcs_api_key.pem 2048
    --
    --     2. Generating a new RSA Public Key in PEM format
    --          openssl rsa -pubout -in ~/.oraclebmc/bmcs_api_key.pem
    --             -out ~/.oraclebmc/bmcs_api_key_public.pem
    --
    --     3. Generating Private Key's fingerprint
    --          openssl rsa -pubout -outform DER
    --            -in <pem_key_file_path> | openssl md5 -c
    --
    --     4. Upload your public key to Oracle Bare Metal Cloud account.
    --        Retrieve your Tenancy OCID and User OCID for the BMC account.
    --
    --     5. Pass the above information to DBMS_CLOUD.create_credential,
    --        password is not required for Oracle Bare Metal Cloud.
    --


  -----------------------------------------------------------------------------
  -- drop_credential  - Drop a Credential object to access any Object Store
  -----------------------------------------------------------------------------
  PROCEDURE drop_credential(
        credential_name  IN  VARCHAR2
  );
    --
    -- NAME:
    --  drop_credential - Drop a Credential object to access any Object Store
    --
    -- DESCRIPTION:
    --   This procedures drop a credential object in the database using
    --   DBMS_CREDENTIAL package.
    --
    --   It will enforce drop even if there are any EXTPROC alias libraries
    --   that reference the credential.
    --
    -- PARMETERS:
    --   credential_name (IN) - Name of the Credential object
    --
    -- EXAMPLE:
    --   BEGIN
    --       DBMS_CLOUD.drop_credential(
    --           credential_name => 'BMC',
    --       );
    --   END;
    --   /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- enable_credential - Enable a Credential object to access Object Store
  -----------------------------------------------------------------------------
  PROCEDURE enable_credential(
        credential_name  IN  VARCHAR2
  );
    --
    -- NAME:
    --  enable_credential - Enable a Credential object to access Object Store
    --
    -- DESCRIPTION:
    --   This procedures enables a credential object in the database using
    --   DBMS_CREDENTIAL package.
    --
    -- PARMETERS:
    --   credential_name (IN) - Name of the Credential object
    --
    -- EXAMPLE:
    --   BEGIN
    --       DBMS_CLOUD.enable_credential(
    --           credential_name => 'BMC',
    --       );
    --   END;
    --   /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- disable_credential - Disable a Credential object to access Object Store
  -----------------------------------------------------------------------------
  PROCEDURE disable_credential(
        credential_name   IN  VARCHAR2
  );
    --
    -- NAME:
    --  disable_credential - Disable a Credential object to access Object Store
    --
    -- DESCRIPTION:
    --   This procedures disables a credential object in the database using
    --   DBMS_CREDENTIAL package.
    --
    --   It will enforce disable even if there are any EXTPROC alias libraries
    --   that reference the credential.
    --
    -- PARMETERS:
    --   credential_name (IN) - Name of the Credential object
    --
    -- EXAMPLE:
    --   BEGIN
    --       DBMS_CLOUD.disable_credential(
    --           credential_name => 'BMC',
    --       );
    --   END;
    --   /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- update_credential - Update a Credential object to access Object Store
  -----------------------------------------------------------------------------
  PROCEDURE update_credential(
        credential_name  IN  VARCHAR2,
        attribute        IN  VARCHAR2,
        value            IN  VARCHAR2
  );
    --
    -- NAME:
    --  update_credential - Update a Credential object to access Object Store
    --
    -- DESCRIPTION:
    --   This procedures update a credential object in the database using
    --   DBMS_CREDENTIAL package.
    --
    --   Attribute argument can be one of the following values:
    --     1. username
    --     2. user_ocid
    --     3. tenancy_ocid
    --     4. private_key
    --     5. fingerprint
    --     6. passphrase
    --     7. password
    --
    --
    -- PARMETERS:
    --   credential_name (IN) - Name of the Credential object
    --
    --   attribute       (IN) - Attribute to update in the credential object
    --
    --   value           (IN) - Value of the credential attribute to update
    --
    -- EXAMPLE:
    --   BEGIN
    --       DBMS_CLOUD.update_credential(
    --           credential_name => 'BMC',
    --           attribute       => 'USERNAME',
    --           value           => 'FOO123'
    --       );
    --   END;
    --   /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- create_external_table - Create External Table on file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE create_external_table(
        table_name          IN  VARCHAR2,
        credential_name     IN  VARCHAR2 DEFAULT NULL,
        file_uri_list       IN  CLOB,
        column_list         IN  CLOB     DEFAULT NULL,
        field_list          IN  CLOB     DEFAULT NULL,
        format              IN  CLOB     DEFAULT NULL
  );
    --
    -- NAME:
    --   create_external_table - Create External Table on file in Object Store
    --
    -- DESCRIPTION:
    --   This procedure creates an external table to access a file existing in
    --   the Object Store.
    --
    -- PARAMETERS:
    --   table_name      (IN)  - Name of the external table
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   file_uri_list   (IN)  - URI(s) of the file(s) existing in Object Store
    --
    --   column_list     (IN)  - Column definition clause for CREATE TABLE
    --                           (optional).
    --                           The value of this argument should be same as
    --                           specifying a list of columns in creating an
    --                           external table, without the enclosing
    --                           parenthesis used for the column clause.
    --                             Eg: 'empno NUMBER, emp_name VARCHAR2(128)'
    --
    --   field_list      (IN)  - Field_list for External table (optional).
    --                           This value identifies the fields in the
    --                           external file and their datatypes.
    --
    --   format          (IN)  - Additional data formatting options (optional)
    --                           in JSON format.
    --
    -- EXAMPLE:
    --     BEGIN
    --       DBMS_CLOUD.create_external_table(
    --          table_name      => 'FOO',
    --          credential_name => 'MY_AWS_CRED_OBJECT',
    --          file_uri_list   => 'https://objectstore.com/bucket/bgfile.csv',
    --          column_list     => 'emp_no  NUMBER,  emp_name VARCHAR2(128)',
    --          format          => '{"type" : "CSV"}'
    --       );
    --     END;
    --     /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- create_external_part_table - Create External Partitioned Table on file
  --                              in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE create_external_part_table(
        table_name          IN  VARCHAR2,
        credential_name     IN  VARCHAR2 DEFAULT NULL,
        partitioning_clause IN  CLOB     DEFAULT NULL,
        file_uri_list       IN  CLOB     DEFAULT NULL,
        column_list         IN  CLOB     DEFAULT NULL,
        field_list          IN  CLOB     DEFAULT NULL,
        format              IN  CLOB     DEFAULT NULL
  );
    --
    -- NAME:
    --   create_external_part_table - Create External Partitioned Table on file
    --                                in Object Store
    --
    -- DESCRIPTION:
    --   This procedure creates an external partitioned table to access a file
    --   existing in the Object Store.
    --
    -- PARAMETERS:
    --   table_name      (IN)  - Name of the external partitioned table
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   partitioning_clause (IN) - Partitioning clause for external table
    --
    --   file_uri_list   (IN)  - URI(s) of the file(s) existing in Object Store
    --
    --   column_list     (IN)  - Column definition clause for CREATE TABLE
    --                           (optional).
    --                           The value of this argument should be same as
    --                           specifying a list of columns in creating an
    --                           external table, without the enclosing
    --                           parenthesis used for the column clause.
    --                             Eg: 'empno NUMBER, emp_name VARCHAR2(128)'
    --
    --   field_list      (IN)  - Field_list for External table (optional).
    --                           This value identifies the fields in the
    --                           external file and their datatypes.
    --
    --   format          (IN)  - Additional data formatting options (optional)
    --                           in JSON format.
    --
    -- EXAMPLE:
    --     BEGIN
    --       DBMS_CLOUD.create_external_part_table(
    --          table_name      => 'FOO',
    --          credential_name => 'MY_AWS_CRED_OBJECT',
    --          partitioning_clause  => 'partition by range (col1)
    --                         (partition p1 values less than (1000) location
    --                          (''https://objectstore.com/bucket/bgfile.csv'')
    --                         )',
    --          column_list     => 'p1  SALARY,  emp_name VARCHAR2(128)',
    --          format          => '{"type" : "CSV"}'
    --       );
    --     END;
    --     /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- sync_external_part_table - Sync External Partitioned Table on file
  --                            in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE sync_external_part_table(
        table_name          IN  VARCHAR2,
        schema_name         IN  VARCHAR2 DEFAULT NULL,
        update_columns      IN  BOOLEAN  DEFAULT FALSE
  );
    --
    -- NAME:
    --   sync_external_part_table - Sync External Partitioned Table with files
    --                              in the Object Store
    --
    -- DESCRIPTION:
    --   This procedure synchronize an external partitioned table with
    --   files in the Object Store.
    --
    -- PARAMETERS:
    --   table_name      (IN)  - Name of the external partitioned table
    --
    --   schema_name     (IN)  - Name of owning schema for the external table
    --                           (optional, by default current schema is used)
    --
    --   update_columns  (IN)  - Update existing columns or not
    --
    -- NOTES:
    --   Added for bug 33016310
    --


  -----------------------------------------------------------------------------
  -- create_hybrid_part_table - Create Hybrid Partitioned Table on file
  --                              in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE create_hybrid_part_table(
        table_name          IN  VARCHAR2,
        credential_name     IN  VARCHAR2 DEFAULT NULL,
        partitioning_clause IN  CLOB,
        column_list         IN  CLOB     DEFAULT NULL,
        field_list          IN  CLOB     DEFAULT NULL,
        format              IN  CLOB     DEFAULT NULL
  );
    --
    -- NAME:
    --   create_hybrid_part_table - Create Hybrid Partitioned Table on file
    --                                in Object Store
    --
    -- DESCRIPTION:
    --   This procedure creates an hybrid partitioned table to access a file
    --   existing in the Object Store.
    --
    -- PARAMETERS:
    --   table_name      (IN)  - Name of the hybrid table
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   partitioning_clause (IN) - Partitioning clause for hybrid table
    --
    --   column_list     (IN)  - Column definition clause for CREATE TABLE
    --                           (optional).
    --                           The value of this argument should be same as
    --                           specifying a list of columns in creating an
    --                           hybrid table, without the enclosing
    --                           parenthesis used for the column clause.
    --                             Eg: 'empno NUMBER, emp_name VARCHAR2(128)'
    --
    --   field_list      (IN)  - Field_list for hybrid table (optional).
    --                           This value identifies the fields in the
    --                           external file and their datatypes.
    --
    --   format          (IN)  - Additional data formatting options (optional)
    --                           in JSON format.
    --
    -- EXAMPLE:
    --     BEGIN
    --       DBMS_CLOUD.create_hybrid_part_table(
    --          table_name      => 'FOO',
    --          credential_name => 'MY_AWS_CRED_OBJECT',
    --          partitioning_clause  => 'partition by range (col1)
    --                         (partition p1 values less than (1000) location
    --                          (''https://objectstore.com/bucket/bgfile.csv'')
    --                         )',
    --          column_list     => 'p1  SALARY,  emp_name VARCHAR2(128)',
    --          format          => '{"type" : "CSV"}'
    --       );
    --     END;
    --     /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- validate_external_table - Validate External Table on file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE validate_external_table(
        table_name       IN  VARCHAR2,
        schema_name      IN  VARCHAR2 DEFAULT  NULL,
        rowcount         IN  NUMBER   DEFAULT  0,
        stop_on_error    IN  BOOLEAN  DEFAULT  TRUE
  );

  PROCEDURE validate_external_table(
        table_name       IN         VARCHAR2,
        operation_id     OUT NOCOPY NUMBER,
        schema_name      IN         VARCHAR2 DEFAULT  NULL,
        rowcount         IN         NUMBER   DEFAULT  0,
        stop_on_error    IN         BOOLEAN  DEFAULT  TRUE
  );
    --
    -- NAME:
    --   validate_external_table - Validate External Table on Object Store file
    --
    -- DESCRIPTION:
    --   This procedure validates the data of an external table over object
    --   file by querying the data in the external table and generating a
    --   logfile and badfile tables to review the results.
    --
    --   The operation_id can be obtained as OUT argument to view the task
    --   status in USER_LOAD_OPERATIONS view.
    --
    -- PARAMETERS:
    --   table_name      (IN)  - Name of the external table
    --
    --   operation_id    (OUT) - Operation ID in USER_LOAD_OPERATIONS view
    --
    --   schema_name     (IN)  - Name of owning schema for the external table
    --                           (optional, by default current schema is used)
    --
    --   rowcount        (IN)  - Number of rows to fetch from external table
    --                           (optional, 0 implies all rows)
    --
    --   stop_on_error   (IN)  - Stop on bad record encountered in validation
    --                           (default TRUE). If the value is FALSE, then
    --                           validation will continue to skip bad records,
    --                           until a minimum of 'rowcount' records have
    --                           been scanned.
    -- EXAMPLE:
    --     BEGIN
    --        DBMS_CLOUD.validate_external_table(
    --            table_name      => 'FOO',
    --            schema_name     => 'SCOTT',
    --            rowcount        => 100
    --        );
    --     END;
    --     /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- validate_external_part_table - Validate Partitioned External Table on
  --                                file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE validate_external_part_table(
        table_name               IN         VARCHAR2,
        partition_name           IN         VARCHAR2 DEFAULT  NULL,
        subpartition_name        IN         VARCHAR2 DEFAULT  NULL,
        schema_name              IN         VARCHAR2 DEFAULT  NULL,
        rowcount                 IN         NUMBER   DEFAULT  0,
        partition_key_validation IN         BOOLEAN  DEFAULT  FALSE,
        stop_on_error            IN         BOOLEAN  DEFAULT  TRUE
  );

  PROCEDURE validate_external_part_table(
        table_name               IN         VARCHAR2,
        operation_id             OUT NOCOPY NUMBER,
        partition_name           IN         VARCHAR2 DEFAULT  NULL,
        subpartition_name        IN         VARCHAR2 DEFAULT  NULL,
        schema_name              IN         VARCHAR2 DEFAULT  NULL,
        rowcount                 IN         NUMBER   DEFAULT  0,
        partition_key_validation IN         BOOLEAN  DEFAULT  FALSE,
        stop_on_error            IN         BOOLEAN  DEFAULT  TRUE
  );
    --
    -- NAME:
    --   validate_external_part_table - Validate Partitioned External Table on
    --                                  file in Object Store
    --
    -- DESCRIPTION:
    --   This procedure validates the data of a partitioned external table over
    --   object store file by querying the data in the external table and
    --   generating a logfile and badfile tables to review the results.
    --
    --   It can also validate a single partition or a single subpartition,
    --   to validate only a subset of object store files.
    --
    --   Finally, it can also validate that partition key in the external file
    --   data matches the partition definition for data consistency.
    --
    --   The operation_id can be obtained as OUT argument to view the task
    --   status in USER_LOAD_OPERATIONS view.
    --
    -- PARAMETERS:
    --   table_name      (IN)  - Name of the external table
    --
    --   operation_id    (OUT) - Operation ID in USER_LOAD_OPERATIONS view
    --
    --   partition_name  (IN)  - Name of the partition in external table
    --                           (optional, by default full table is validated)
    --
    --   subpartition_name (IN) - Name of the subpartition in external table
    --                            (optional, by default full table or full
    --                             partition is validated)
    --
    --   schema_name     (IN)  - Name of owning schema for the external table
    --                           (optional, by default current schema is used)
    --
    --   rowcount        (IN)  - Number of rows to fetch from external table
    --                           (optional, 0 implies all rows)
    --
    --   partition_key_validation (IN)  - Validate partition key for the
    --                                    data in Object store file
    --                                    (optional, by default false)
    --
    --   stop_on_error   (IN)  - Stop on bad record encountered in validation
    --                           (default TRUE). If the value is FALSE, then
    --                           validation will continue to skip bad records,
    --                           until a minimum of 'rowcount' records have
    --                           been scanned.
    --
    -- EXAMPLE:
    --     BEGIN
    --        DBMS_CLOUD.validate_external_part_table(
    --            table_name               => 'FOO',
    --            schema_name              => 'SCOTT',
    --            partition_name           => 'P1',
    --            subpartition_name        => 'S1',
    --            partition_key_validation => TRUE,
    --            rowcount                 => 100
    --        );
    --     END;
    --     /
    --
    -- NOTES:
    --   Added for bug 30274451.
    --   Added overloaded procedure for bug 30598903.
    --


  -----------------------------------------------------------------------------
  -- validate_hybrid_part_table - Validate Hybrid Partitioned Table on
  --                              file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE validate_hybrid_part_table(
        table_name               IN         VARCHAR2,
        partition_name           IN         VARCHAR2 DEFAULT  NULL,
        subpartition_name        IN         VARCHAR2 DEFAULT  NULL,
        schema_name              IN         VARCHAR2 DEFAULT  NULL,
        rowcount                 IN         NUMBER   DEFAULT  0,
        partition_key_validation IN         BOOLEAN  DEFAULT  FALSE,
        stop_on_error            IN         BOOLEAN  DEFAULT  TRUE
  );

  PROCEDURE validate_hybrid_part_table(
        table_name               IN         VARCHAR2,
        operation_id             OUT NOCOPY NUMBER,
        partition_name           IN         VARCHAR2 DEFAULT  NULL,
        subpartition_name        IN         VARCHAR2 DEFAULT  NULL,
        schema_name              IN         VARCHAR2 DEFAULT  NULL,
        rowcount                 IN         NUMBER   DEFAULT  0,
        partition_key_validation IN         BOOLEAN  DEFAULT  FALSE,
        stop_on_error            IN         BOOLEAN  DEFAULT  TRUE
  );
    --
    -- NAME:
    --   validate_hybrid_part_table - Validate Hybrid Partitioned Table on
    --                                file in Object Store
    --
    -- DESCRIPTION:
    --   This procedure validates the data of a hybrid partitioned table over
    --   object store file by querying the data in the external table and
    --   generating a logfile and badfile tables to review the results.
    --
    --   It can also validate only a single partition, to validate a subset of
    --   object store files.
    --
    --   Finally, it can also validate that partition key in the external file
    --   data matches the partition definition for data consistency.
    --
    --   The operation_id can be obtained as OUT argument to view the task
    --   status in USER_LOAD_OPERATIONS view.
    --
    -- PARAMETERS:
    --   table_name      (IN)  - Name of the hybrid table
    --
    --   operation_id    (OUT) - Operation ID in USER_LOAD_OPERATIONS view
    --
    --   partition_name  (IN)  - Name of the external partition in hybrid table
    --                           (optional, by default all external partitions
    --                            are validated)
    --
    --   subpartition_name (IN) - Name of the external subpartition in hybrid
    --                            table (optional, by default full table or
    --                            full partition is validated)
    --
    --   schema_name     (IN)  - Name of owning schema for the hybrid table
    --                           (optional, by default current schema is used)
    --
    --   rowcount        (IN)  - Number of rows to fetch from hybrid table
    --                           (optional, 0 implies all rows)
    --
    --   partition_key_validation (IN)  - Validate partition key for the
    --                                    data in Object store file
    --                                    (optional, by default false)
    --
    --   stop_on_error   (IN)  - Stop on bad record encountered in validation
    --                           (default TRUE). If the value is FALSE, then
    --                           validation will continue to skip bad records,
    --                           until a minimum of 'rowcount' records have
    --                           been scanned.
    --
    -- EXAMPLE:
    --     BEGIN
    --        DBMS_CLOUD.validate_hybrid_part_table(
    --            table_name               => 'FOO',
    --            schema_name              => 'SCOTT',
    --            partition_name           => 'P1',
    --            subpartition_name        => 'S1',
    --            partition_key_validation => TRUE,
    --            rowcount                 => 100
    --        );
    --     END;
    --     /
    --
    -- NOTES:
    --   Added for bug 30274451.
    --   Added overloaded procedure for bug 30598903.
    --


  -----------------------------------------------------------------------------
  -- copy_data - Copy Data from Object Store to Oracle Database
  -----------------------------------------------------------------------------
  PROCEDURE copy_data(
        table_name          IN  VARCHAR2,
        credential_name     IN  VARCHAR2 DEFAULT NULL,
        file_uri_list       IN  CLOB,
        schema_name         IN  VARCHAR2 DEFAULT NULL,
        field_list          IN  CLOB     DEFAULT NULL,
        format              IN  CLOB     DEFAULT NULL
  );

  PROCEDURE copy_data(
        table_name          IN          VARCHAR2,
        credential_name     IN          VARCHAR2 DEFAULT NULL,
        file_uri_list       IN          CLOB,
        schema_name         IN          VARCHAR2 DEFAULT NULL,
        field_list          IN          CLOB     DEFAULT NULL,
        format              IN          CLOB     DEFAULT NULL,
        operation_id        OUT NOCOPY NUMBER
  );

    --
    -- NAME:
    --   copy_data - Copy Data from the Object Store to Oracle Database
    --
    -- DESCRIPTION:
    --   This procedure is used to copy data from the Object Store to Oracle
    --   Database. It uses a temporary external table to access the file stored
    --   Object Store and then inserts the rows into the table name specified
    --   in the input argument.
    --
    --   The operation_id can be obtained as OUT argument to view the task
    --   status in USER_LOAD_OPERATIONS view.
    --
    -- PARAMETERS:
    --   table_name      (IN)  - Name of the database table
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   file_uri_list   (IN)  - URI(s) of the file(s) existing in Object Store
    --
    --   schema_name     (IN)  - Schema name owning the database table
    --                           (optional - default is current schema)
    --
    --   field_list      (IN)  - Field_list for External table (optional).
    --                           This value identifies the fields in the
    --                           external file and their datatypes.
    --
    --   format          (IN)  - Additional data formatting options (optional)
    --                           in JSON format.
    --
    --   operation_id    (OUT) - Operation ID in USER_LOAD_OPERATIONS view
    --
    --
    --
    -- EXAMPLE:
    --   BEGIN
    --     DBMS_CLOUD.copy_data(
    --         table_name      => 'EMPLOYEES',
    --         credential_name => 'MY_AWS_CRED_OBJECT',
    --         file_uri_list   => 'https://objectstore.com/bucket/bgfile.csv',
    --         format          => '{"type" : "CSV"}'
    --     );
    --   END;
    --   /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- Load Data from Object Store to Oracle SODA Collection
  -----------------------------------------------------------------------------
  PROCEDURE copy_collection(
    collection_name IN  VARCHAR2,
    credential_name IN  VARCHAR2 DEFAULT NULL,
    file_uri_list   IN  CLOB,
    format          IN  CLOB     DEFAULT NULL
  );

  PROCEDURE copy_collection(
    collection_name IN         VARCHAR2,
    credential_name IN         VARCHAR2 DEFAULT NULL,
    file_uri_list   IN         CLOB,
    format          IN         CLOB     DEFAULT NULL,
    operation_id    OUT NOCOPY NUMBER
  );
    --
    -- NAME:
    --   copy_collection - Load Data from the Object Store to Oracle
    --                     Database SODA Collection
    --
    -- DESCRIPTION:
    --   This procedure is used to load data from the Object Store to Oracle
    --   Database SODA Collection. It uses a temporary external table to
    --   access  the file stored Object Store and then inserts the rows into
    --   the collection name specified in the input argument.
    --
    --   The operation_id can be obtained as OUT argument to view the task
    --   status in USER_LOAD_OPERATIONS view.
    --
    -- PARAMETERS:
    --   collection_name (IN)  - Name of the Collection
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   file_uri_list   (IN)  - URI(s) of the file(s) existing in Object Store
    --
    --   format          (IN)  - Additional data formatting options (optional)
    --                           in JSON format.
    --
    --   operation_id    (OUT) - Operation ID in USER_LOAD_OPERATIONS view
    --
    -- EXAMPLE:
    --   BEGIN
    --     DBMS_CLOUD.copy_collection(
    --         collection_name => 'MyCollection',
    --         credential_name => 'MY_CRED',
    --         file_uri_list   => 'https://objectstore.com/bucket/myjson.json',
    --         format          => json_object('unpackarrays' value 'true')
    --     );
    --   END;
    --   /
    --
    -- NOTES:
    --   Added for bug 29377868.
    --


  -----------------------------------------------------------------------------
  -- Export Data from Oracle Database to Object Store
  -----------------------------------------------------------------------------
  PROCEDURE export_data(
    credential_name IN VARCHAR2    DEFAULT NULL,
    file_uri_list   IN CLOB,
    query           IN CLOB,
    format          IN CLOB        DEFAULT NULL
  );

  PROCEDURE export_data(
    credential_name IN         VARCHAR2    DEFAULT NULL,
    file_uri_list   IN         CLOB,
    query           IN         CLOB,
    format          IN         CLOB        DEFAULT NULL,
    operation_id    OUT NOCOPY NUMBER
  );
    --
    -- NAME:
    --   export_data - Export Data from Oracle Database to Object Store
    --
    -- DESCRIPTION:
    --   This procedure is used to export data from Oracle Database to
    --   Object store using a SQL Query clause. The results of the SQL Query
    --   are dumped into Oracle Datapump file format and directly uploaded to
    --   object store.
    --
    --   The operation_id can be obtained as OUT argument to view the task
    --   status in USER_LOAD_OPERATIONS view.
    --
    -- PARAMETERS:
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   file_uri_list   (IN)  - URI(s) of the file(s) existing in Object Store
    --
    --   query           (IN)  - SELECT query to fetch the data to export
    --
    --   format          (IN)  - Additional data formatting options (optional)
    --                           in JSON format.
    --
    --   operation_id    (OUT) - Operation ID in USER_LOAD_OPERATIONS view
    --
    -- EXAMPLE:
    --   BEGIN
    --     DBMS_CLOUD.export_data(
    --         credential_name => 'MY_CRED',
    --         file_uri_list   => 'https://objectstore.com/bucket/myjson.json',
    --         query           => 'select * from dept',
    --         format          => json_object('compression' value 'basic')
    --     );
    --   END;
    --   /
    --
    -- NOTES:
    --   Added for bug 29817501.
    --


  -----------------------------------------------------------------------------
  -- delete_operation - Delete an operation for cloud data access
  -----------------------------------------------------------------------------
  PROCEDURE delete_operation(
        id               IN NUMBER
  );
    --
    -- NAME:
    --   delete_operation - Delete an operation for cloud data access
    --
    -- DESCRIPTION:
    --   The procedure is used to delete a given cloud data access operation
    --   using the operation ID. It will also cleanup any supporting objects
    --   created for the operation (such logfile table, badfile table). The
    --   cleanup steps depend on the TYPE of operation ID.
    --
    -- PARAMETERS:
    --   id        (IN)  - Operation ID to delete
    --
    -- EXAMPLE:
    --   DECLARE
    --     id    NUMBER;
    --   BEGIN
    --     SELECT MIN(id) INTO id FROM user_load_operations;
    --     DBMS_CLOUD.delete_operation(id);
    --   END;
    --   /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- delete_all_operations - Delete all operations for cloud data access
  -----------------------------------------------------------------------------
  PROCEDURE delete_all_operations(
        type               IN VARCHAR DEFAULT NULL
  );
    --
    -- NAME:
    --   delete_all_operations - Deletes all operation for cloud data access
    --
    -- DESCRIPTION:
    --   The procedure is used to delete all cloud data access operations,
    --   optionally for a given type. It will also cleanup any supporting
    --   objects created for the operation (such logfile table, badfile table).
    --   The cleanup steps depend on the TYPE of operation ID.
    --
    -- PARAMETERS:
    --   type        (IN)  - Type of operations to delete (optional)
    --                       By default delete all operations of all types
    --
    -- EXAMPLE:
    --   BEGIN
    --     DBMS_CLOUD.delete_all_operations();
    --   END;
    --   /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- get_object - Get the contents of an object in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION get_object(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2,
        startOffset      IN  NUMBER   DEFAULT 0,
        endOffset        IN  NUMBER   DEFAULT 0,
        compression      IN  VARCHAR2 DEFAULT NULL
  ) RETURN BLOB;

  PROCEDURE get_object(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2 DEFAULT NULL,
        startOffset      IN  NUMBER   DEFAULT 0,
        endOffset        IN  NUMBER   DEFAULT 0,
        compression      IN  VARCHAR2 DEFAULT NULL
  );
    --
    -- NAME:
    --   get_object - Get the contents of an object in Cloud Store
    --
    -- DESCRIPTION:
    --   This function is used to get the contents of an object existing in
    --   Cloud Store. The object is identified using the URI and access to
    --   the Cloud Store is authenticated using the credential object name.
    --
    --   In order to support parallel reads on the same object, the start and
    --   end offset (in bytes) can be specified for partial reads on the
    --   object.
    --
    --   If the contents of the object are to be written in a local file, then
    --   a file name and directory object can be specified to write the
    --   contents to a local file. The file is downloaded from object store
    --   copied to the local file.
    --
    -- PARAMETERS:
    --   credential_name  (IN) - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   object_uri       (IN)  - URI of the object existing in Object Store
    --
    --   directory_name   (IN)  - Directory object for local file
    --
    --   file_name        (IN)  - Local file name to put to object store
    --                              (Optional, use name from object_uri)
    --
    --   startOffset      (IN)  - Starting offset (in bytes) to read contents
    --
    --   endOffset        (IN)  - End offset (in bytes) to read contents
    --
    --   compression      (IN)  - Compression scheme to uncompress the data
    --                            (only COMPRESS_AUTO supported)
    --
    -- RETURNS:
    --    None
    --
    -- EXAMPLE:
    --   DECLARE
    --     l_contents  BLOB;
    --   BEGIN
    --     l_contents := DBMS_CLOUD.get_object(
    --          credential_name => 'MY_AWS_CRED_OBJECT',
    --          object_uri      => 'https://objectstore.com/bucket/bgfile.csv',
    --     );
    --   END;
    --   /
    --
    --   BEGIN
    --     DBMS_CLOUD.get_object(
    --          credential_name => 'MY_AWS_CRED_OBJECT',
    --          object_uri      => 'https://objectstore.com/bucket/bgfile.csv',
    --          directory_name  => 'TEST_DIR',
    --          compression     => DBMS_CLOUD.COMPRESS_AUTO
    --     );
    --   END;
    --   /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- put_object - Put the contents in an object in Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE put_object(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2,
        contents         IN  BLOB,
        compression      IN  VARCHAR2 DEFAULT NULL,
        retention_days   IN  NUMBER   DEFAULT NULL
  );

  PROCEDURE put_object(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2,
        compression      IN  VARCHAR2 DEFAULT NULL,
        retention_days   IN  NUMBER   DEFAULT NULL
  );
    --
    -- NAME:
    --   put_object - Put the contents in an object in Cloud Store
    --
    -- DESCRIPTION:
    --   This procedure is used to upload the contents to an object in
    --   Cloud Store. The object is identified using the URI and access to
    --   the Cloud Store is authenticated using the credential object name.
    --
    -- PARAMETERS:
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   object_uri      (IN)  - URI of the object existing in Object Store
    --
    --   contents        (IN)  - Contents to put in the object in Cloud Store
    --
    --   directory_name  (IN)  - Directory object for local file
    --
    --   file_name       (IN)  - Local file name to put to object store
    --
    --   compression     (IN)  - Compression scheme to compress the data
    --                           (only COMPRESS_AUTO supported)
    --
    --   retention_days  (IN)  - Number of days after which to delete object
    --
    -- EXAMPLE:
    --   DECLARE
    --     l_contents  BLOB;
    --   BEGIN
    --     l_contents := EMPTY_BLOB();
    --     DBMS_CLOUD.put_object(
    --         credential_name => 'MY_AWS_CRED_OBJECT',
    --         object_uri      => 'https://objectstore.com/bucket/bgfile.csv',
    --         contents        => l_contents,
    --         compression     => DBMS_CLOUD.COMPRESS_AUTO,
    --         retention_days  => 3
    --     );
    --   END;
    --   /
    --
    --   BEGIN
    --     DBMS_CLOUD.put_object(
    --         credential_name => 'MY_AWS_CRED_OBJECT',
    --         object_uri      => 'https://objectstore.com/bucket/bgfile.csv',
    --         directory_name  => 'TEST_DIR',
    --         file_name       => 'bgfile.csv'
    --         compression     => DBMS_CLOUD.COMPRESS_AUTO
    --   END;
    --   /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- set_api_result_cache_size - Update DBMS_CLOUD REST API max cache size
  -----------------------------------------------------------------------------
  PROCEDURE set_api_result_cache_size(
        cache_size  IN NUMBER
  );
    --
    -- NAME:
    --  set_api_result_cache_size - Update DBMS_CLOUD REST API max cache size
    --
    -- DESCRIPTION:
    --   This procedures allows users to configure the maximum number for the
    --   cache table.
    --
    -- PARMETERS:
    --   cache_size (IN) - cache size input(>= 0)
    --   If input cache size is 0, the cache will be cleaned up.
    --
    -- EXAMPLE:
    --   BEGIN
    --       DBMS_CLOUD.set_api_result_cache_size(
    --           cache_size => 10
    --       );
    --   END;
    --   /
    --
    -- NOTES:
    --   Added by Bug 31659526.
    --


  -----------------------------------------------------------------------------
  -- get_api_result_cache_size - Get DBMS_CLOUD REST API max cache size
  -----------------------------------------------------------------------------
  FUNCTION get_api_result_cache_size
  RETURN NUMBER;
    --
    -- NAME:
    --  get_api_result_cache_size - Return DBMS_CLOUD REST API max cache size
    --
    -- DESCRIPTION:
    --   This function allows users to query the maximum cache size.
    --
    -- RETURNS:
    --   Maximum cache size
    --
    -- NOTES:
    --   Added by Bug 31659526.
    --


  -----------------------------------------------------------------------------
  -- get_metadata - Get the metadata for an object in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION get_metadata(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2
  ) RETURN CLOB;
    --
    -- NAME:
    --   get_metadata - Get the metadata for an object in Cloud Store
    --
    -- DESCRIPTION:
    --   This function is used to get the metadata for an object existing in
    --   Cloud Store. The object is identified using the URI and access to
    --   the Cloud Store is authenticated using the credential object name.
    --
    -- PARAMETERS:
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   object_uri      (IN)  - URI of the object existing in Object Store
    --
    -- EXAMPLE:
    --   DECLARE
    --     l_metadata  CLOB;
    --   BEGIN
    --     l_metadata :=
    --       DBMS_CLOUD.get_metadata(
    --         credential_name => 'MY_AWS_CRED_OBJECT',
    --         object_uri      => 'https://objectstore.com/bucket/bgfile.csv',
    --     );
    --   END;
    --   /
    --
    -- RETURNS:
    --   Metadata for the object in JSON format
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- list_objects - List objects at a given location in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION list_objects(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        location_uri     IN  VARCHAR2
  ) RETURN DBMS_CLOUD_TYPES.list_object_ret_tab PIPELINED PARALLEL_ENABLE;
    --
    -- NAME:
    --   list_objects - List objects at a given location in Cloud Store
    --
    -- DESCRIPTION:
    --   This function is used to list objects at a given location in the
    --   Cloud Store. The location is identified using the URI and access to
    --   the Cloud Store is authenticated using the credential object name.
    --
    -- PARAMETERS:
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   location_uri    (IN)  - URI of the given location to list objects
    --
    --
    -- RETURNS:
    --   List of URI(s) of object(s) and their sizes in bytes
    --
    -- EXAMPLE:
    --   SELECT * FROM
    --     TABLE(DBMS_CLOUD.list_objects('MY_AWS_CRED_OBJECT',
    --                           'https://objectstore.com/bucket/bgfile.csv'));
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- list_files - List files at a given directory object location
  -----------------------------------------------------------------------------
  FUNCTION list_files(
        directory_name    IN  VARCHAR2
  ) RETURN DBMS_CLOUD_TYPES.list_object_ret_tab PIPELINED PARALLEL_ENABLE;
    --
    -- NAME:
    --   list_files - List files at a given directory object location
    --
    -- DESCRIPTION:
    --   This function is used to list objects at a directory object location.
    --   It requires the invoker to have READ privilege on directory object.
    --
    -- PARAMETERS:
    --   directory_name   (IN)  - Directory name to list objects
    --
    -- RETURNS:
    --   List of files and their sizes in bytes
    --
    -- EXAMPLE:
    --   SELECT * FROM TABLE(DBMS_CLOUD.list_files('TEST_DIR'));
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- delete_object - Delete an object in Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE delete_object(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2
  );
    --
    -- NAME:
    --   delete_object - Delete an object in Cloud Store
    --
    -- DESCRIPTION:
    --   This procedure is used to delete an object in  Cloud Store.
    --   The object is identified using the URI and access to the Cloud Store
    --   is authenticated using the credential object name.
    --
    -- PARAMETERS:
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   object_uri      (IN)  - URI of the object existing in Object Store
    --
    -- EXAMPLE:
    --   BEGIN
    --     DBMS_CLOUD.delete_object(
    --         credential_name => 'MY_AWS_CRED_OBJECT',
    --         object_uri      => 'https://objectstore.com/bucket/bgfile.csv'
    --     );
    --   END;
    --   /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- delete_file - Delete a file in directory object
  -----------------------------------------------------------------------------
  PROCEDURE delete_file(
        directory_name  IN  VARCHAR2,
        file_name       IN  VARCHAR2
  );
    --
    -- NAME:
    --   delete_file - Delete a file in directory object
    --
    -- DESCRIPTION:
    --   This procedure is used to delete a file in directory object. It
    --   requires the invoker to have WRITE privilege on the directory
    --   object.
    --
    -- PARAMETERS:
    --   directory_name  (IN)  - Directory name for local file
    --
    --   file_name       (IN)  - File name for local file to delete
    --
    --
    -- EXAMPLE:
    --   BEGIN
    --     DBMS_CLOUD.delete_file(
    --         directory_name => 'TEST_DIR',
    --         file_name      => 'bgfile.csv'
    --     );
    --   END;
    --   /
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- send_request - Send HTTP request
  -----------------------------------------------------------------------------
  FUNCTION send_request(
    credential_name    IN  VARCHAR2,
    uri                IN  VARCHAR2,
    method             IN  VARCHAR2,
    headers            IN  CLOB      DEFAULT NULL,
    body               IN  BLOB      DEFAULT NULL,
    async_request_url  IN  VARCHAR2  DEFAULT NULL,
    wait_for_states    IN  DBMS_CLOUD_TYPES.wait_for_states_t
                                     DEFAULT NULL,
    timeout            IN  NUMBER    DEFAULT 0,
    cache              IN  BOOLEAN   DEFAULT FALSE,
    cache_scope        IN  VARCHAR2  DEFAULT NULL
  ) RETURN DBMS_CLOUD_TYPES.resp;
    --
    -- NAME:
    --   send_request  - Send a HTTP request
    --
    -- DESCRIPTION:
    --   This function sends an HTTP request.
    --
    -- PARAMETERS:
    --   credential_name    (IN)  -  Fully qualified credential name
    --
    --   uri                (IN)  -  Base url for the request
    --
    --   method             (IN)  -  HTTP request method
    --
    --   headers            (IN)  -  HTTP request headers
    --
    --   body               (IN)  -  Request body payload
    --
    --   async_request_url  (IN)  -  URL for work request
    --
    --   wait_for_states    (IN)  -  States till api has to wait
    --
    --   timeout            (IN)  -  Timeout in seconds
    --
    --   cache              (IN) -   flag which indicates if the request will
    --                               be cached in rest api cache table
    --
    --   cache_scope        (IN) -   scope of accessing the request result
    --
    -- RETURNS:
    --   HTTP response
    --


  -----------------------------------------------------------------------------
  -- send_request - Send HTTP request
  -----------------------------------------------------------------------------
  PROCEDURE send_request(
    credential_name    IN  VARCHAR2,
    uri                IN  VARCHAR2,
    method             IN  VARCHAR2,
    headers            IN  CLOB      DEFAULT NULL,
    body               IN  BLOB      DEFAULT NULL,
    async_request_url  IN  VARCHAR2  DEFAULT NULL,
    wait_for_states    IN  DBMS_CLOUD_TYPES.wait_for_states_t
                                     DEFAULT NULL,
    timeout            IN  NUMBER    DEFAULT 0,
    cache              IN  BOOLEAN   DEFAULT FALSE,
    cache_scope        IN  VARCHAR2  DEFAULT NULL
  );
    --
    -- NAME:
    --   send_request  - Send a HTTP request
    --
    -- DESCRIPTION:
    --   This procedure sends an HTTP request.
    --
    -- PARAMETERS:
    --   credential_name    (IN)  -  Fully qualified credential name
    --
    --   uri                (IN)  -  Base url for the request
    --
    --   method             (IN)  -  HTTP request method
    --
    --   headers            (IN)  -  HTTP request headers
    --
    --   body               (IN)  -  Request body payload
    --
    --   async_request_url  (IN)  -  URL for work request
    --
    --   wait_for_states    (IN)  -  States till api has to wait
    --
    --   timeout            (IN)  -  Timeout in seconds
    --
    --   cache              (IN) -   flag which indicates if the request should
    --                               be cached in rest api cache table
    --
    --   cache_scope        (IN) -   scope of accessing the request result
    --
    --


  -----------------------------------------------------------------------------
  -- get_response_headers - Get response headers
  -----------------------------------------------------------------------------
  FUNCTION get_response_headers(
    resp        IN  DBMS_CLOUD_TYPES.resp
  ) RETURN JSON_OBJECT_T;
    --
    -- NAME:
    --   get_response_headers - Get response headers
    --
    -- DESCRIPTION:
    --   This function returns the HTTP response headers as JSON object.
    --
    -- PARAMETERS:
    --   resp             (IN)  -  HTTP response type
    --
    -- RETURNS:
    --   HTTP response headers JSON object
    --

  -----------------------------------------------------------------------------
  -- get_response_text - Get response body as text
  -----------------------------------------------------------------------------
  FUNCTION get_response_text(
    resp        IN  DBMS_CLOUD_TYPES.resp
  ) RETURN CLOB;
    --
    -- NAME:
    --   get_response_raw - Get response body as text
    --
    -- DESCRIPTION:
    --   Get response body as text.
    --
    -- PARAMETERS:
    --   resp         (IN)  - HTTP response type
    --
    -- RETURNS:
    --   HTTP response body as text.
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- get_response_raw - Get response body as raw
  -----------------------------------------------------------------------------
  FUNCTION get_response_raw(
    resp        IN  DBMS_CLOUD_TYPES.resp
  ) RETURN BLOB;
    --
    -- NAME:
    --   get_response_raw - Get response body as raw
    --
    -- DESCRIPTION:
    --   Get response body as raw.
    --
    -- PARAMETERS:
    --   resp         (IN)  - HTTP response type
    --
    -- RETURNS:
    --   HTTP response body as raw.
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- get_response_status_code - Get response status code
  -----------------------------------------------------------------------------
  FUNCTION get_response_status_code(
    resp        IN  DBMS_CLOUD_TYPES.resp
  ) RETURN PLS_INTEGER;
    --
    -- NAME:
    --   get_response_status_code - Get response status code
    --
    -- DESCRIPTION:
    --   Get response status code.
    --
    -- PARAMETERS:
    --   resp         (IN)  - HTTP response type
    --
    -- RETURNS:
    --   HTTP response status code
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- resignal_user_error - Resignal user error from the error stack
  -----------------------------------------------------------------------------
  PROCEDURE resignal_user_error(
    log_table   IN  VARCHAR2  DEFAULT NULL
  );
    --
    -- NAME:
    --   resignal_user_error - Internal use only
    --
    -- DESCRIPTION:
    --   This is an internal procedure, not to be documented for external use.
    --
    -- PARAMETERS:
    --   Internal use only
    --
    -- NOTES:
    --   Internal use only, do not document.
    --


  -----------------------------------------------------------------------------
  -- Parallel Enable Pipeline Table Function to Export Rows
  -----------------------------------------------------------------------------
  FUNCTION export_rows_tabfunc(
    refcursor IN SYS_REFCURSOR,
    context   IN CLOB
  ) RETURN DBMS_CLOUD_TYPES.get_object_ret_tab PIPELINED
    PARALLEL_ENABLE(PARTITION refcursor BY ANY);
    --
    -- NAME:
    --   export_rows_tabfunc - Internal use only
    --
    -- DESCRIPTION:
    --  This is an internal procedure, not to be documented for external use.
    --
    -- PARAMETERS:
    --  Internal use only
    --
    -- RETURNS:
    --
    -- NOTES:
    --  Internal user only. do not document
    --

END dbms_cloud; -- End of DBMS_CLOUD Package
/
CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY C##CLOUD$SERVICE.dbms_cloud AS

  -----------------------------------------------------------------------------
  --                                 CONSTANTS
  -----------------------------------------------------------------------------

  --
  -- Maximum Length of identifier, quoted, schema qualified identifiers
  -- Please use dbms_id and dbms_quoted_id instead of varchar2(128|M_IDEN)
  -- and varchar2(130|M_QUOTED_IDEN) respectively. Both these types are
  -- available since 12c.
  --
  NEWLINE              CONSTANT   CHAR(1)      := CHR(10);
  M_IDEN               CONSTANT   PLS_INTEGER  := ORA_MAX_NAME_LEN;
  M_QUAL_IDEN          CONSTANT   PLS_INTEGER  := 2*M_IDEN+5;
  M_VCSIZ_4K           CONSTANT   PLS_INTEGER  := 4000;
  M_VCSIZ_32K          CONSTANT   PLS_INTEGER  := 32767;

  REJECT_LIMIT_MAX     CONSTANT   NUMBER       := 100000;
  DIR_NAMESPACE        CONSTANT   PLS_INTEGER  := 9;

  PRIV_READ            CONSTANT   VARCHAR2(10) := 'READ';
  PRIV_WRITE           CONSTANT   VARCHAR2(10) := 'WRITE';

  MAX_REQMETHOD_LEN    CONSTANT   PLS_INTEGER  := 10;

  TEMP_EXTTAB_PREFIX   CONSTANT   DBMS_ID      := 'COPY$';

  -- Headers
  HEADER_CONTENT_TYPE  CONSTANT   DBMS_ID      := 'Content-Type';

  -- External table driver
  EXTTAB_TYPE_LOADER   CONSTANT   DBMS_ID      := 'ORACLE_LOADER';
  EXTTAB_TYPE_BIGDATA  CONSTANT   DBMS_ID      := 'ORACLE_BIGDATA';
  EXTTAB_TYPE_DATAPUMP CONSTANT   DBMS_ID      := 'ORACLE_DATAPUMP';

  -- Parent Operation constants
  COPY_DATA_OPER       CONSTANT   DBMS_ID      := 'copy_data';
  COPY_COLLECTION_OPER CONSTANT   DBMS_ID      := 'copy_collection';
  EXPORT_DATA_OPER     CONSTANT   DBMS_ID      := 'export_data';

  -- Table type for validating external/hybrid tables
  TABTYPE_EXT          CONSTANT   PLS_INTEGER  := 0;
  TABTYPE_PET          CONSTANT   PLS_INTEGER  := 1;
  TABTYPE_HPT          CONSTANT   PLS_INTEGER  := 2;

  OCI_WORK_REQUEST_ID    CONSTANT DBMS_ID      := 'opc-work-request-id';
  OCI_WORKREQUEST_STATUS CONSTANT DBMS_ID      := 'status';
  MIN_WAIT_INTERVAL      CONSTANT NUMBER       := 4;
  MAX_WAIT_INTERVAL      CONSTANT NUMBER       := 5 * 60;
  OCI_WAIT_STATES        CONSTANT DBMS_CLOUD_TYPES.wait_for_states_t :=
                                  DBMS_CLOUD_TYPES.wait_for_states_t(
                                                  'ACTIVE', 'CANCELED',
                                                  'COMPLETED', 'DELETED',
                                                  'FAILED', 'SUCCEEDED');

  -- DEFAULT Max Size for JSON Document (10MB), make it consistent
  -- with constant FORMAT_DFLT_READSIZE
  DFLT_JSON_RECORD_SIZE CONSTANT   PLS_INTEGER  := 10000000;
  -- Upper limit of a single JSON Document Size
  MAX_JSON_RECORD_SIZE  CONSTANT   PLS_INTEGER  := 2000000000;
  -- DEFAULT FIELD DELIMITER for JSON Document
  FORMAT_DFLT_JSON_FIELD_DELIMITER DBMS_ID      := 'NEWLINE';

  FORMAT_DFLT_CSV_FIELD_DELIMITER  CONSTANT DBMS_ID := ',';

  -- Task Class
  TASK_CLASS_COPY       CONSTANT   DBMS_ID      := 'COPY';
  TASK_CLASS_VALIDATE   CONSTANT   DBMS_ID      := 'VALIDATE';
  TASK_CLASS_PUT        CONSTANT   DBMS_ID      := 'PUT';
  TASK_CLASS_EXPORT     CONSTANT   DBMS_ID      := 'EXPORT';

  -- Context for resolving credential in Dbms_Utility.Name_Resolve
  CRED_CONTEXT_NAMERSLV CONSTANT   NUMBER       := 11;

  -- Credential parameters
  PARAM_AWS_ROLE_ARN          CONSTANT   DBMS_ID      := 'aws_role_arn';
  PARAM_EXTERNAL_ID_TYPE      CONSTANT   DBMS_ID      := 'external_id_type';

  -- Credential type
  AWS_ARN                     CONSTANT   DBMS_ID      := 'AWS ARN';

  -- Local Type for storing list of format parameters during parsing
  TYPE format_key_list_t IS TABLE OF VARCHAR2(M_VCSIZ_4K) INDEX BY DBMS_ID;

  -- Local type for storing return value from the export query cursor
  TYPE convert_row_ret_t IS RECORD (
        row_info    CLOB
  );

  -- Export Rows File Size (10M)
  EXPORT_MAX_FILE_SIZE CONSTANT NUMBER := 10 * 1024 * 1024;

  -- Rows Per Fetch in the ICD callout to export JSON
  ROWS_PER_FETCH        CONSTANT NUMBER := 200;

  -- Compression ratio
  COMPRESSION_RATIO     CONSTANT NUMBER := 7;

  --
  -- Exceptions
  --
  invalid_format_key      EXCEPTION;       -- invalid format json key
  invalid_format_value    EXCEPTION;       -- invalid format json value
  duplicate_format_key    EXCEPTION;       -- duplicate format json key
  conflicting_format_key  EXCEPTION;       -- conflicting format json key

  tab_not_exist EXCEPTION;
  PRAGMA EXCEPTION_INIT(tab_not_exist, -942);

  tab_exist EXCEPTION;
  PRAGMA EXCEPTION_INIT(tab_exist, -955);


  -----------------------------------------------------------------------------
  --           FORWARD DECLARATIONS (STATIC FUNCTION/PROCEDURE DECLARATIONS)
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- generate_random_name - Generate random name string
  -----------------------------------------------------------------------------
  FUNCTION generate_random_name(
     name_length     IN PLS_INTEGER
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   generate_random_name - Generate random name string
    --
    -- DESCRIPTION:
    --   This procedure generates a random object name.
    --
    -- PARAMETERS:
    --   object_name  (IN)  - object name as hint for random name
    --
    -- NOTES:
    --
  BEGIN
    RETURN DBMS_RANDOM.string('X', name_length);
  END generate_random_name;


  -----------------------------------------------------------------------------
  --  get_current_user - Get Current User name
  -----------------------------------------------------------------------------
  FUNCTION get_current_user
  RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   get_current_user - Get Current User name
    --
    -- DESCRIPTION:
    --   This functions returns the current session user name enclosed in
    --   double quotes.
    --
    -- PARAMETERS:
    --   None
    --
    -- RETURNS:
    --   Current session user name in double quotes
    --
    -- NOTES:
    --   Added for bug 26657144.
    --
  BEGIN
    RETURN DBMS_ASSERT.enquote_name(
                SYS_CONTEXT('USERENV', 'CURRENT_USER'), FALSE);
  END get_current_user;


  -----------------------------------------------------------------------------
  --  get_current_schema - Get Current Schema name
  -----------------------------------------------------------------------------
  FUNCTION get_current_schema
  RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   get_current_schema - Get Current Schema name
    --
    -- DESCRIPTION:
    --   This functions returns the current session schema name enclosed in
    --   double quotes.
    --
    -- PARAMETERS:
    --   None
    --
    -- RETURNS:
    --   Current session schema name in double quotes
    --
    -- NOTES:
    --   Added for bug 26657144.
    --
  BEGIN
    RETURN DBMS_ASSERT.enquote_name(
                SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA'), FALSE);
  END get_current_schema;


  -----------------------------------------------------------------------------
  -- validate_schema_name - Validate Schema Name
  -----------------------------------------------------------------------------
  FUNCTION validate_schema_name(
        schema_name     IN  VARCHAR2
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   validate_schema_name - Validate schema name
    --
    -- DESCRIPTION:
    --   This function validates a schema name, and implicitly returns the
    --   current user name if input schema name is null.
    --
    -- PARAMETERS:
    --   schema_name      (IN)  - Schema name
    --
    -- RETURNS:
    --   Validate schema name
    --
    -- NOTES:
    --   Added for bug 26402344.
    --
  BEGIN
    IF schema_name IS NULL THEN
      RETURN get_current_schema();
    ELSE
      RETURN DBMS_ASSERT.enquote_name(
                DBMS_CLOUD_CORE.assert_simple_sql_name(
                    schema_name, DBMS_CLOUD_CORE.ASSERT_TYPE_SCHEMA));
    END IF;
  END validate_schema_name;


  -----------------------------------------------------------------------------
  -- validate_table_name - Validate Table Name
  -----------------------------------------------------------------------------
  FUNCTION validate_table_name(
        table_name     IN  VARCHAR2
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   validate_table_name - Validate table name
    --
    -- DESCRIPTION:
    --   This function validates a table name.
    --
    -- PARAMETERS:
    --   table_name      (IN)  - Table name
    --
    -- RETURNS:
    --   Validate table name
    --
    -- NOTES:
    --   Added for bug 29167938.
    --
  BEGIN
    RETURN DBMS_ASSERT.enquote_name(
                DBMS_CLOUD_CORE.assert_simple_sql_name(
                        table_name, DBMS_CLOUD_CORE.ASSERT_TYPE_TAB));
  END validate_table_name;


  -----------------------------------------------------------------------------
  -- check_directory_privilege - Check directory privilege
  -----------------------------------------------------------------------------
  PROCEDURE check_directory_privilege(
        directory_name  IN  VARCHAR2,
        priv            IN  VARCHAR2
  )
  IS
    --
    -- NAME:
    --   check_directory_privilege - Check Directory access privilege
    --
    -- DESCRIPTION:
    --   This procedure check access privilege of current user for a given
    --   directory.
    --
    -- PARAMETERS:
    --   directory_name   (IN)  - Directory name to check access privilege
    --                            (case sensitive name)
    --
    --   priv             (IN)  - Privilege to check (PRIV_READ or PRIV_WRITE)
    --
    -- NOTES:
    --   Added for bug 26402344.
    --
  BEGIN
    -- Bug 29593659: Do not honor CREATE ANY DIRECTORY privilege to prevent
    -- access to Oracle Supplied directory objects.
    if (sys_context('userenv','current_userid') <> 0 and
        dbms_priv_capture.ses_has_obj_priv(priv, 'SYS', directory_name,
                                           DIR_NAMESPACE) = false) then
      raise_application_error(-20000,
                'Directory object ' || directory_name || ' does not exist');
    end if;
  END check_directory_privilege;


  -----------------------------------------------------------------------------
  -- validate_directory_name - Validate Directory Name
  -----------------------------------------------------------------------------
  FUNCTION validate_directory_name(
        directory_name  IN  VARCHAR2,
        privilege       IN  VARCHAR2
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   validate_directory_name  - Validate directory name
    --
    -- DESCRIPTION:
    --   This function validates the directory name and checks privilege for
    --   accessing the directory.
    --
    -- PARAMETERS:
    --   directory_name   (IN)  - Directory name to validate
    --
    --   privilege        (IN)  - Privilege to check (PRIV_READ or PRIV_WRITE)
    --
    -- RETURNS:
    --   Validated directory name
    --
    -- NOTES:
    --   Added for bug 27256532.
    --
    l_directory_name    DBMS_ID;
  BEGIN

    --
    -- Bug 27809980: Check for null directory name
    --
    -- Bug 27462297: Trim the whitespaces before checking for NULL.
    -- CHR(0), CHR(34), CHR(39) and likes will be rejected by Simple_SQL_Name
    --
    IF TRIM(directory_name) IS NULL THEN
      raise_application_error(EXCP_INVALID_DIR_NAME, 'Missing directory name');
    END IF;

    -- UTL_FILE and Privilege check requires name without quotes
    --
    -- Handle any parsing related exceptions here, otherwise ORA-20000 raised
    -- by check_directory_privilege via raise_application_error will be masked
    --
    l_directory_name := DBMS_CLOUD_CORE.unquote_name(
                           DBMS_CLOUD_CORE.assert_simple_sql_name(
                              directory_name, DBMS_CLOUD_CORE.ASSERT_TYPE_DIR));

    --
    -- Check directory privilege for reading
    --
    check_directory_privilege(l_directory_name, privilege);

    RETURN l_directory_name;
  END validate_directory_name;


  -----------------------------------------------------------------------------
  -- validate_request_method - Validate request method
  -----------------------------------------------------------------------------
  FUNCTION validate_request_method(
     method            IN  VARCHAR2
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   validate_request_method  - Validate request method
    --
    -- DESCRIPTION:
    --   This function validates the request method and returns the method.
    --
    -- PARAMETERS:
    --   method   (IN)    - request method
    --
    -- RETURNS:
    --   Request method
    --
    -- NOTES:
    --   Added for bug 30262394
    --
    l_method    DBMS_ID;
  BEGIN
    IF LENGTH(method) > MAX_REQMETHOD_LEN THEN
      raise_application_error(EXCP_INVALID_REQ_METHOD,
                'Request method is too long');
    END IF;

    l_method := UPPER(TRIM(method));
    -- Bug 33060243: support PATCH method for REST APIs
    IF l_method NOT IN (METHOD_GET, METHOD_PUT, METHOD_HEAD,
                        METHOD_POST, METHOD_DELETE, METHOD_PATCH)
    THEN
      raise_application_error(EXCP_INVALID_REQ_METHOD,
                'Invalid request method - ' || method);
    END IF;

    RETURN method;

  END validate_request_method;


  -----------------------------------------------------------------------------
  -- parse_json_parameters - validate
  -----------------------------------------------------------------------------
  FUNCTION parse_json_parameters(
     params            IN  CLOB
  ) RETURN JSON_OBJECT_T
  IS
    --
    -- NAME:
    --   parse_json_parameters  - Parse JSON parameters
    --
    -- DESCRIPTION:
    --   This function parses the JSON object.
    --
    -- PARAMETERS:
    --   params   (IN)    - JSON parameters
    --
    -- RETURNS:
    --   Return a JSON object.
    --
    -- NOTES:
    --   Added for bug 30507383
    --

    l_params_obj        JSON_OBJECT_T;
  BEGIN

    -- If input is null, then create empty JSON
    IF params IS NULL THEN
      RETURN JSON_OBJECT_T('{}');
    -- Else, parse the input as valid JSON
    ELSE
      l_params_obj := JSON_OBJECT_T.parse(params);
      RETURN l_params_obj;
    END IF;

 END parse_json_parameters;


  -----------------------------------------------------------------------------
  -- validate_response - Validate response
  -----------------------------------------------------------------------------
  PROCEDURE validate_response(
     resp            IN  DBMS_CLOUD_TYPES.resp
  )
  IS
    --
    -- NAME:
    --   validate_response  - Validate response
    --
    -- DESCRIPTION:
    --   This function validates the HTTP response is valid and initialized.
    --
    -- PARAMETERS:
    --   resp    (IN)    - HTTP response
    --
    -- NOTES:
    --   Added for bug 30507383
    --
  BEGIN

    IF resp.init IS NULL OR resp.init != TRUE THEN
      raise_application_error(EXCP_INVALID_RESPONSE,
              'Invalid response');
    END IF;

  END validate_response;


  -----------------------------------------------------------------------------
  -- get_external_table_type - Get type of external table
  -----------------------------------------------------------------------------
  FUNCTION get_external_table_type(
        schema_name        IN  VARCHAR2,
        table_name         IN  VARCHAR2
  )  RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   get_external_table_type - Get type of external table
    --
    -- DESCRIPTION:
    --   This function is used to obtain the type of external table.
    --
    -- PARAMETERS:
    --   schema_name       (IN)  - Schema name owning the table
    --
    --   table_name        (IN)  - Table name to check access privilege
    --
    -- RETURNS:
    --   Type of external table as a string.
    --
    -- NOTES:
    --   The input schema and table name should be enquoted.
    --
    l_exttab_type   DBMS_ID;
    l_table_name   DBMS_ID;
    l_schema_name  DBMS_ID;
    l_stmt         VARCHAR2(M_VCSIZ_4K);
  BEGIN

    l_table_name  := DBMS_CLOUD_CORE.unquote_name(table_name);
    l_schema_name := DBMS_CLOUD_CORE.unquote_name(schema_name);

    --
    -- Get the type of external table
    -- (Bug 27774240)
    --
    SELECT type_name INTO l_exttab_type FROM SYS.ALL_EXTERNAL_TABLES
        WHERE owner = l_schema_name AND table_name = l_table_name;

    RETURN l_exttab_type;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- Bug 27427602: If not an external table, then replace with custom error
      raise_application_error(-20000,
                'Missing or invalid external table ' || l_table_name);
  END get_external_table_type;


  -----------------------------------------------------------------------------
  -- get_db_version - Get db version
  -----------------------------------------------------------------------------
  FUNCTION get_db_version
  RETURN NUMBER
  IS
    l_version  NUMBER;
  BEGIN

    EXECUTE IMMEDIATE 'BEGIN ' ||
                      '  :l_version := DBMS_DB_VERSION.version; ' ||
                      'END; ' USING OUT l_version;
    RETURN l_version;
  END get_db_version;


  -----------------------------------------------------------------------------
  -- check_table_privilege - Check Table access privilege
  -----------------------------------------------------------------------------
  PROCEDURE check_table_privilege(
        schema_name        IN  VARCHAR2,
        table_name         IN  VARCHAR2,
        partition_name     IN  VARCHAR2    DEFAULT NULL,
        subpartition_name  IN  VARCHAR2    DEFAULT NULL,
        table_type         IN  PLS_INTEGER DEFAULT TABTYPE_EXT
  )
  IS
    --
    -- NAME:
    --   check_table_privilege - Check Table access privilege
    --
    -- DESCRIPTION:
    --   This procedure check access privilege for a given table and schema.
    --
    -- PARAMETERS:
    --   schema_name       (IN)  - Schema name owning the table
    --
    --   table_name        (IN)  - Table name to check access privilege
    --
    --   partition_name    (IN)  - External Partition name
    --
    --   subpartition_name (IN)  - External Subpartition name
    --
    --   table_type        (IN)  - Type of table (external/hybrid/partitioned)
    --
    -- NOTES:
    --   The input schema and table name should be enquoted.
    --
    l_sqlstmt           VARCHAR2(M_VCSIZ_4K);
    l_cnt               NUMBER;
    l_schema_name       DBMS_ID;
    l_table_name        DBMS_ID;
    l_partition_name    DBMS_ID;
    l_subpartition_name DBMS_ID;
    l_invalid_pet       EXCEPTION;
    l_invalid_hpt       EXCEPTION;
    l_invalid_part      EXCEPTION;
    l_invalid_subpart   EXCEPTION;
    l_cur               INTEGER;
    l_nrows             INTEGER;
  BEGIN

    -- Bug 26521015: Do a dummy select to see if the table can be accessed.
    -- If successful, then the SQL should return 0 rows.
    -- If failed, then resignal error

    --
    -- Privilege check
    --
    l_sqlstmt := 'SELECT COUNT(*) FROM ' ||
                        schema_name || '.' || table_name || ' WHERE 1=2';
    EXECUTE IMMEDIATE l_sqlstmt INTO l_cnt;
    DBMS_CLOUD_CORE.assert(l_cnt = 0, 'check_object_access',
                           'non-zero count - ' || l_cnt);


    --
    -- Table Type checks
    --
    -- Bug 30654272: Validate partition and subpartition name based on the
    -- table type.
    --

    -- Get the unquoted object names to query dictionary views
    l_schema_name := DBMS_CLOUD_CORE.unquote_name(schema_name);
    l_table_name  := DBMS_CLOUD_CORE.unquote_name(table_name);
    IF partition_name IS NOT NULL THEN
      l_partition_name := DBMS_CLOUD_CORE.unquote_name(partition_name);
    END IF;
    IF subpartition_name IS NOT NULL THEN
      l_subpartition_name := DBMS_CLOUD_CORE.unquote_name(subpartition_name);
    END IF;

    -- Partition or Subpartition cannot be specified for regular external table
    IF table_type = TABTYPE_EXT THEN
      IF partition_name IS NOT NULL THEN
        RAISE l_invalid_part;
      ELSIF subpartition_name IS NOT NULL THEN
        RAISE l_invalid_subpart;
      END IF;

    ELSE

      -- Check if table is partitioned external table and match with table_type
      l_sqlstmt :=  'SELECT COUNT(*) FROM SYS.ALL_TABLES       ' ||
                    '  WHERE owner= :1 AND table_name= :2 AND  ' ||
                    '        external=''YES''';
      EXECUTE IMMEDIATE l_sqlstmt INTO l_cnt USING l_schema_name,
                                                   l_table_name;
      IF l_cnt = 0 AND table_type = TABTYPE_PET THEN
        RAISE l_invalid_pet;
      ELSIF l_cnt > 0 AND table_type = TABTYPE_HPT THEN
        RAISE l_invalid_hpt;
      END IF;

      -- Validate Hybrid Partitioned Table
      -- Bug 30654272: Empty partitions do not show in ALL_XTERNAL_LOC_* views,
      -- so use dictionary tables to validate partition/subpartition name.
      IF table_type = TABTYPE_HPT THEN
        -- Currently, hybrid partition tables do not support subpartitions
        IF subpartition_name IS NOT NULL THEN
          RAISE l_invalid_subpart;
        END IF;

        -- Validation partition name
        IF partition_name IS NOT NULL THEN
          BEGIN
            -- Execute as SYS user to query dictionary tables
            l_cur   := SYS.DBMS_SYS_SQL.open_cursor;
            SYS.DBMS_SYS_SQL.parse_as_user(l_cur,
                'SELECT COUNT(*) FROM sys.dba_objects o, sys.tabpart$ t
                    WHERE o.object_id = t.obj# AND
                          o.owner = :oname AND
                          o.object_name = :tname AND
                          o.subobject_name = :pname AND
                          bitand(t.flags, 4294967296) = 4294967296',
                DBMS_SQL.NATIVE, 0);
            SYS.DBMS_SYS_SQL.bind_variable(l_cur, 'oname', l_schema_name);
            SYS.DBMS_SYS_SQL.bind_variable(l_cur, 'tname', l_table_name);
            SYS.DBMS_SYS_SQL.bind_variable(l_cur, 'pname', l_partition_name);
            SYS.DBMS_SYS_SQL.define_column(l_cur, 1, l_cnt);
            l_nrows := SYS.DBMS_SYS_SQL.execute_and_fetch(l_cur);
            IF l_nrows > 0 THEN
              SYS.DBMS_SYS_SQL.column_value(l_cur, 1, l_cnt);
            END IF;
            SYS.DBMS_SYS_SQL.close_cursor(l_cur);
          EXCEPTION
            WHEN OTHERS THEN
              SYS.DBMS_SYS_SQL.close_cursor(l_cur);
              RAISE;
          END;
          IF l_cnt = 0 THEN
            RAISE l_invalid_part;
          END IF;
        END IF;

      --
      -- Validate Partitioned External Table
      --
      ELSIF table_type = TABTYPE_PET THEN

        --
        -- 1. Subpartition validation
        -- Bug 30529152: support for validating external location subpartition
        -- NOTE: The subpartition may be validated individually or along with
        -- the partition name.
        --
        IF l_subpartition_name IS NOT NULL THEN

          -- Bug 32074822: Qualify object reference with schema
          l_sqlstmt := 'SELECT COUNT(*) FROM SYS.ALL_TAB_SUBPARTITIONS ' ||
                            'WHERE table_owner=:1 AND table_name=:2 AND ' ||
                            'subpartition_name=:3';
          IF l_partition_name IS NOT NULL THEN
            l_sqlstmt := l_sqlstmt || ' AND partition_name=:4';
            EXECUTE IMMEDIATE l_sqlstmt INTO l_cnt
                    USING l_schema_name, l_table_name, l_subpartition_name,
                          l_partition_name;
          ELSE
            EXECUTE IMMEDIATE l_sqlstmt INTO l_cnt
                    USING l_schema_name, l_table_name, l_subpartition_name;
          END IF;

          IF l_cnt = 0 THEN
            RAISE l_invalid_subpart;
          END IF;

        -- 1. Partition Validation
        -- Bug 30274451: If partition name is specified, then verify that it is
        -- a valid external location partition.
        --
        ELSIF l_partition_name IS NOT NULL THEN

          -- Bug 32074822: Qualify object reference with schema
          l_sqlstmt := 'SELECT COUNT(*) FROM SYS.ALL_TAB_PARTITIONS ' ||
                            'WHERE table_owner=:1 AND table_name=:2 AND ' ||
                            'partition_name=:3';
          EXECUTE IMMEDIATE l_sqlstmt INTO l_cnt
                  USING l_schema_name, l_table_name, l_partition_name;
          IF l_cnt = 0 THEN
            RAISE l_invalid_part;
          END IF;

        END IF;

      --
      -- Invalid Table Type passed in
      --
      ELSE

        DBMS_CLOUD_CORE.assert(FALSE, 'check_table_privilege',
                               'Invalid table type - ' || table_type);
      END IF;

    END IF;
  EXCEPTION
    WHEN tab_not_exist THEN
      raise_application_error(EXCP_TABLE_NOT_EXIST,
          'Table ' || schema_name || '.' || table_name || ' does not exist');
    WHEN l_invalid_part THEN
      raise_application_error(EXCP_PART_NOT_EXIST,
          'External partition ' || partition_name || ' does not exist');
    WHEN l_invalid_subpart THEN
      IF partition_name IS NULL THEN
        raise_application_error(EXCP_PART_NOT_EXIST,
           'External subpartition ' || subpartition_name || ' does not exist');
      ELSE
        raise_application_error(EXCP_PART_NOT_EXIST,
            'External subpartition ' || subpartition_name ||
            ' does not exist in external partition ' || partition_name);
      END IF;
    WHEN l_invalid_pet THEN
      raise_application_error(EXCP_PART_NOT_EXIST,
          'Table ' || schema_name || '.' || table_name ||
          ' is not a partitioned external table');
    WHEN l_invalid_hpt THEN
      raise_application_error(EXCP_PART_NOT_EXIST,
         'Table ' || schema_name || '.' || table_name ||
          ' is not a hybrid partitioned table');
  END check_table_privilege;


  -----------------------------------------------------------------------------
  -- validate_credential_name - Validate credential name
  -----------------------------------------------------------------------------
  FUNCTION validate_credential_name(
        credential_name  IN  VARCHAR2,
        os_ext_table     IN  BOOLEAN  DEFAULT FALSE,
        base_cred_owner  OUT VARCHAR2,
        base_cred_name   OUT VARCHAR2
  )  RETURN VARCHAR2
    --
    -- NAME:
    --   validate_credential_name - Validate credential name
    --
    -- DESCRIPTION:
    --   This function validates the credential name to be used for creation
    --   of external table and other operations like {get|put|delete}_object
    --   or database link creation, that makes use of credentials to access
    --   the object store URI or authenticate to the database.
    --
    --   If the credential exists as a public/private synonym, it also tries
    --   to resolve it using current user' privilege domain and populates the
    --   base credential owner and name pointed to by the synonym.
    --
    -- PARAMETERS:
    --   credential_name  (IN)   - Credential name
    --
    --   os_ext_table     (IN)   - External table for accessing local files
    --
    --   base_cred_owner  (OUT)  - Owner for credential pointed to by synonym
    --
    --   base_cred_name   (OUT)  - Name of credential pointed to by synonym
    --
    -- RETURNS:
    --   Returns the validated credential name. If the user does not possess
    --   EXECUTE privilege on the credential object (for synonym case), it
    --   will return appropriate error to the caller.
    --
    -- NOTES:
    --   Added by Bug 32516731.
    --
  IS
    l_credential_name  DBMS_QUOTED_ID;
    l_part1            DBMS_ID;
    l_part2            DBMS_ID;
    l_part3            DBMS_ID;
    l_dblink           DBMS_ID;
    l_part1_type       NUMBER;
    l_obj_number       NUMBER;
    l_current_user     DBMS_QUOTED_ID := get_current_user();
    l_current_schema   DBMS_QUOTED_ID := get_current_schema();
    l_change_curschema BOOLEAN        := FALSE;
  BEGIN

    -- Nothing to validate for OS external table, so NULL is allowed.
    -- Also, allow NULL credential for pre-auth URLs
    IF os_ext_table OR credential_name IS NULL THEN
      RETURN NULL;
    END IF;

    -- Check if credential is a simple SQL name to raise error early
    l_credential_name := DBMS_CLOUD_CORE.assert_simple_sql_name(
                           credential_name, DBMS_CLOUD_CORE.ASSERT_TYPE_CRED);

    --
    -- Resolve the base credential owner/name for the synonym including check
    -- for EXECUTE privilege on the underlying credential, if base credential
    -- is owned by a different user.
    --
    -- It can generate following errors during the course of synonym resolve
    --  ORA-20005 : DBMS_UTILITY.name_resolve does not support credentials
    --  ORA-4047  : Synonym points to a non-credential but valid object
    --  ORA-6564  : Insufficient (ALTER) or no privileges on credential object
    --  ORA-931   : Parse error when keywords like PUBLIC provided as input
    --
    -- Name_Resolve attempts to resolve the credential object in the context
    -- of current_schema. Some of the DBMS_CLOUD APIs like export_data does
    -- not honour current_schema setting for credentials, but does honour it
    -- for other database objects, e.g, table name referred in the SQL query.
    -- So to retain the existing behavior, we switch the current_schema back
    -- to current_user, do a name_resolve and then reset the current_schema
    -- back to its original value.
    --
    IF l_current_user <> l_current_schema THEN
      EXECUTE IMMEDIATE 'alter session set current_schema = ' ||
                         l_current_user;
      l_change_curschema := TRUE;
    END IF;

    -- Force resolving the credential in the context of current user
    DBMS_UTILITY.name_resolve(l_credential_name, CRED_CONTEXT_NAMERSLV,
                              l_part1, l_part2, l_part3, l_dblink,
                              l_part1_type, l_obj_number);

    -- Bug 32909158: do not allow remote credential
    IF l_dblink IS NOT NULL THEN
      raise_application_error(EXCP_CRED_NOT_EXIST,
          'Credential ' || DBMS_CLOUD_CORE.get_qualified_name(
           l_credential_name, l_current_user) || ' does not exist');
    END IF;

    -- Reset the current_schema back to its original value
    IF l_change_curschema THEN
      EXECUTE IMMEDIATE 'alter session set current_schema = ' ||
                         l_current_schema;
      l_change_curschema := FALSE;
    END IF;

    -- Pass the base credential owner and name after resolving the credential
    -- For non-synonym case, it will be current_user and credential name
    -- For public/private synonym, it will be base credential owner/name
    base_cred_owner := DBMS_ASSERT.enquote_name(l_part1, FALSE);
    base_cred_name  := DBMS_ASSERT.enquote_name(l_part2, FALSE);

    -- Bug 32516731: Return the enquoted name, so that c1, C1, "C1" are all
    -- treated the same by underlying access driver.
    -- Till Bug 32559105 is fixed and consumed by ADB-S, return the credential
    -- name as it is without enclosing it within double quotes.
    RETURN l_credential_name;

  EXCEPTION
    WHEN OTHERS THEN
      -- Reset the current_schema back to its original value
      IF l_change_curschema THEN
        EXECUTE IMMEDIATE 'alter session set current_schema = ' ||
                           l_current_schema;
      END IF;

      -- DBMS_UTILITY does not support credentials, resort to old behaviour
      IF SQLCODE = -20005 THEN
        RETURN l_credential_name;

      -- 6564 : Object does not exist or user does not have EXECUTE privilege
      -- 4047 : Object exists but is not a scheduler credential
      -- 980  : Synonym exists but the original credential does not exist.
      ELSIF SQLCODE IN (-6564, -4047, -980) THEN
        raise_application_error(EXCP_CRED_NOT_EXIST,
          'Credential ' || DBMS_CLOUD_CORE.get_qualified_name(
           l_credential_name, l_current_user) || ' does not exist');

      -- Some unknown error from Name_Resolve, resignal
      ELSE
        RAISE;
      END IF;

  END validate_credential_name;


  -----------------------------------------------------------------------------
  -- check_create_credential_privilege - Check credential creation privilege
  -----------------------------------------------------------------------------
  PROCEDURE check_create_credential_privilege(
        credential_name        IN  VARCHAR2,
        credential_type        IN  VARCHAR2
  )
  IS
    --
    -- NAME:
    --   check_create_credential_privilege - Check credential creation
    --                                       privilege
    --
    -- DESCRIPTION:
    --   This procedure check if current user can create specified kind of
    --   credential.
    --
    -- PARAMETERS:
    --   credential_name   (IN)  - Credential name
    --
    --   credential_type   (IN)  - Credential Type
    --
    -- NOTES:
    --   Added by Bug 32437837.
    --
    l_credential_name  DBMS_QUOTED_ID;
    l_base_credowner   DBMS_QUOTED_ID;
    l_base_credname    DBMS_QUOTED_ID;
  BEGIN

    l_credential_name := validate_credential_name(
                             credential_name, FALSE,
                             l_base_credowner, l_base_credname);

    -- Bug 32909423: If the credential name was a synonym, ensure that it is
    -- pointing to the same credential name in ADMIN schema
    -- Eg: Synonym for AWS$ARN must point to base object ADMIN.AWS$ARN
    IF l_base_credowner != '"ADMIN"' OR
       l_base_credname != credential_name
    THEN
      raise_application_error(-20034, credential_type ||
                              ' is not enabled for user ' ||
                              get_current_user());
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      -- Bug 32818219: Raise proper errors when ORA-980 is seen.
      IF SQLCODE IN (-20004, -980) THEN
        raise_application_error(-20034, credential_type ||
                                ' is not enabled for user ' ||
                                get_current_user());
      ELSE
        resignal_user_error;
        RAISE;
      END IF;

  END check_create_credential_privilege;


  -----------------------------------------------------------------------------
  -- create_external_table_int - Create External Table Helper procedure
  -----------------------------------------------------------------------------
  PROCEDURE create_external_table_int(
        table_name          IN  VARCHAR2,
        credential_name     IN  VARCHAR2 DEFAULT NULL,
        file_uri_list       IN  CLOB     DEFAULT NULL,
        partitioning_clause IN  CLOB     DEFAULT NULL,
        column_list         IN  CLOB     DEFAULT NULL,
        base_table          IN  VARCHAR2 DEFAULT NULL,
        base_table_schema   IN  VARCHAR2 DEFAULT NULL,
        field_list          IN  CLOB     DEFAULT NULL,
        format              IN  CLOB     DEFAULT NULL,
        log_dir             IN  VARCHAR2 DEFAULT NULL,
        log_file_prefix     IN  VARCHAR2 DEFAULT NULL,
        os_ext_table        IN  BOOLEAN  DEFAULT FALSE,
        parent_operation    IN  VARCHAR2 DEFAULT NULL,
        part_table          IN  BOOLEAN  DEFAULT FALSE,
        hybrid_table        IN  BOOLEAN  DEFAULT FALSE,
        export_query        IN  CLOB     DEFAULT NULL
  )
  IS
    --
    -- NAME:
    -- create_external_table_int - Create External Table Helper procedure
    --
    -- DESCRIPTION:
    --   This helper routine calls DBMS_CLOUD_INTERNAL.GET_CREATE_EXTTAB_TEXT
    --   function to validate various inputs and gets the CREATE EXTERNAL
    --   TABLE DDL statement and executes using Current_User privileges to
    --   create the external table in Current_User schema.
    --
    -- PARAMETERS:
    --   table_name        (IN) - Name of the external table
    --
    --   credential_name   (IN) - Credential object name to authenticate with
    --                           with Object Store.
    --   file_uri_list     (IN) - URI(s) of the file existing in Object Store
    --
    --   partitioning_clause (IN) - Partitioning clause for external table
    --
    --   column_list       (IN) - Column definition clause for CREATE TABLE.
    --
    --   base_table        (IN) - Base table to use for deriving the column
    --                            list for the external table.
    --
    --   base_table_schema (IN) - Schema name owning the 'base_table'
    --
    --   field_list        (IN) - Field_list for External table (optional).
    --
    --   format            (IN) - Additional data formatting options (optional)
    --
    --   log_dir           (IN) - Default directory
    --
    --   log_file_prefix   (IN) - Prefix for log/bad file name
    --
    --   os_ext_table      (IN) - External table for accessing local files
    --
    --   parent_operation  (IN) - Parent operation
    --
    --   part_table        (IN) - Partitioned external table (optional)
    --
    --   hybrid_table      (IN) - Hybrid partitioned table (optional)
    --
    --   export_query      (IN) - Select query for exporting data
    --
    l_exttable_ddlstmt CLOB;
    l_bypass_value     NUMBER;
    l_credential_name  DBMS_QUOTED_ID;
    l_base_credowner   DBMS_QUOTED_ID;
    l_base_credname    DBMS_QUOTED_ID;
  BEGIN

    -- Bug 30246921: Hybrid table is only supported 19c or higher release
    IF hybrid_table = TRUE AND get_db_version() < 19 THEN
      raise_application_error(EXCP_UNSUPP_FEATURE,
                'Feature not supported in current database version');
    END IF;

    -- Bug 32516731: Validate the credential including resolving the synonym
    l_credential_name := validate_credential_name(
                           credential_name => credential_name,
                           os_ext_table    => os_ext_table,
                           base_cred_owner => l_base_credowner,
                           base_cred_name  => l_base_credname);

    l_exttable_ddlstmt := DBMS_CLOUD_INTERNAL.get_create_exttab_text(
                            invoker_schema      => get_current_user(),
                            table_name          => table_name,
                            credential_name     => l_credential_name,
                            file_uri_list       => file_uri_list,
                            partitioning_clause => partitioning_clause,
                            column_list         => column_list,
                            base_table          => base_table,
                            base_table_schema   => base_table_schema,
                            field_list          => field_list,
                            format              => format,
                            log_dir             => log_dir,
                            log_file_prefix     => log_file_prefix,
                            os_ext_table        => os_ext_table,
                            parent_operation    => parent_operation,
                            part_table          => part_table,
                            hybrid_table        => hybrid_table,
                            export_query        => export_query,
                            bypass_value        => l_bypass_value,
                            base_cred_owner     => l_base_credowner,
                            base_cred_name      => l_base_credname
                          );

    -- Execute the create external table statement
    --
    -- RTI 21728130: GET_CREATE_EXTTAB_TEXT extracts column related attributes
    -- from data-dictionary,which could be arbitrary SQL expressions and can't
    -- be validated using Dbms_Assert APIs. Post bug 27462297, CREATE TABLE is
    -- done as Current_User, so it is okay to use NOOP to make lrgZSQI happy.
    --
    EXECUTE IMMEDIATE DBMS_ASSERT.noop(l_exttable_ddlstmt);

    -- Clear bypass of external table ddl
    DBMS_CLOUD_INTERNAL.clear_bypass(l_bypass_value);

  EXCEPTION
    WHEN tab_exist THEN
      -- Bug 32810138: Clear bypass of external table ddl on exception
      DBMS_CLOUD_INTERNAL.clear_bypass(l_bypass_value);

      raise_application_error(EXCP_TABLE_EXIST,
          'Table ' || get_current_user() || '.' ||
           DBMS_ASSERT.enquote_name(table_name) || ' already exists');
    WHEN OTHERS THEN
      -- Bug 32810138: Clear bypass of external table ddl on exception
      DBMS_CLOUD_INTERNAL.clear_bypass(l_bypass_value);
      RAISE;
  END create_external_table_int;


  -----------------------------------------------------------------------------
  -- create_log_external_table - Create external table for log records
  -----------------------------------------------------------------------------
  PROCEDURE create_log_external_table(
        log_file_prefix  IN      VARCHAR2,
        task_id          IN      NUMBER,
        exttab_type      IN      VARCHAR2,
        payload          IN  OUT JSON_OBJECT_T
  )
  IS
    --
    -- NAME:
    --   create_log_external_table - Create external table for log records
    --
    -- DESCRIPTION:
    --   This is a helper procedure to create external table for logfile
    --   and badfile records generated by external table on object store files.
    --
    -- PARAMETERS:
    --   log_file_prefix  (IN)       - Log file prefix
    --
    --   task_id          (IN)       - ID for the existing task
    --
    --   exttab_type       (IN)       - Type of external table
    --
    --   payload          (IN/OUT)   - Custom task payload
    --
    -- NOTES:
    --
    l_format       DBMS_ID;
    l_field_list   DBMS_ID;
    l_schema_name  DBMS_QUOTED_ID;
    l_logfile_tab  DBMS_ID;
    l_badfile_tab  DBMS_ID;
  BEGIN

    -- Initialize locals
    -- Column should be CLOB to support large bad records
    -- Bug 29809711: use newline as record delimiter for log external tables
    l_schema_name := get_current_user();
    l_field_list  := '"RECORD" CHAR(100000)';
    l_format      := JSON_OBJECT(FORMAT_RECORD_DELIMITER value 'NEWLINE',
                                 FORMAT_FIELD_DELIMITER value 'NEWLINE',
                                 FORMAT_IGN_MISSING_COLS value 'true',
                                 FORMAT_REJECT_LIMIT value 'UNLIMITED');

    -- Update the task payload before creating the tables for recovery
    l_logfile_tab := log_file_prefix || '_LOG';
    l_badfile_tab := log_file_prefix || '_BAD';
    payload.put('LogfileTable', l_logfile_tab);
    payload.put('LogfilePrefix', log_file_prefix);
    payload.put('LogfileDir', DBMS_CLOUD_CORE.DEFAULT_LOG_DIR);
    IF exttab_type != EXTTAB_TYPE_DATAPUMP THEN
      payload.put('BadfileTable', l_badfile_tab);
    END IF;
    DBMS_CLOUD_TASK.update_task(
        id      => task_id,
        userid  => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
        status  => DBMS_CLOUD_TASK.TASK_STATUS_RUNNING,
        payload => payload.to_clob
    );

    -- Logfile external table
    -- Bug 29254622: use varchar2 in logfile table for faster read in sqlplus
    create_external_table_int(
        table_name      => l_logfile_tab,
        file_uri_list   => log_file_prefix || '_*.log',
        column_list     => 'RECORD VARCHAR2(4000)',
        field_list      => l_field_list,
        format          => l_format,
  log_dir         => DBMS_CLOUD_CORE.DEFAULT_LOG_DIR,
        os_ext_table    => TRUE
    );

    -- Bug 27448788: If there are no log records, then logfile is not
    -- created. This will cause an error when selecting from logfile external
    -- table. Write an empty log file to avoid the error.
    DBMS_CLOUD_INTERNAL.write_file(
        invoker_schema  => l_schema_name,
        directory_name  => DBMS_CLOUD_CORE.DEFAULT_LOG_DIR,
        file_name       => log_file_prefix || '_dflt.log',
        contents        => NULL
    );

    -- Bug 27774240: Datapump external table does not support badfile
    IF exttab_type != EXTTAB_TYPE_DATAPUMP THEN

      -- Badfile external table
      create_external_table_int(
        table_name      => l_badfile_tab,
        file_uri_list   => log_file_prefix || '_*.bad',
        column_list     => 'RECORD CLOB',
        field_list      => l_field_list,
        format          => l_format,
        log_dir         => DBMS_CLOUD_CORE.DEFAULT_LOG_DIR,
  os_ext_table    => TRUE
      );

      -- Bug 26571485: If there are no bad records, then badfile is not
      -- created. This will cause an error when selecting from badfile external
      -- table. Write an empty bad file to avoid the error.
      DBMS_CLOUD_INTERNAL.write_file(
        invoker_schema  => l_schema_name,
        directory_name  => DBMS_CLOUD_CORE.DEFAULT_LOG_DIR,
        file_name       => log_file_prefix || '_dflt.bad',
        contents        => NULL
      );

    END IF;

  END create_log_external_table;


  -----------------------------------------------------------------------------
  -- resignal_user_error - Resignal user error from the error stack
  -----------------------------------------------------------------------------
  PROCEDURE resignal_user_error(
    log_table   IN  VARCHAR2  DEFAULT NULL
  )
  IS
    --
    -- NAME:
    --   resignal_user_error - Resignal user error from the error stack
    --
    -- DESCRIPTION:
    --   This is a helper procedure to cleanup the errorstack and remove any
    --   generic error messages. Eventually, the top user error is resignalled.
    --
    -- PARAMETERS:
    --   log_table   (IN)  - Log file table name for reject limit error
    --
    -- NOTES:
    --   Added for bug 29167938.
    --
    l_errstr     VARCHAR2(M_VCSIZ_4K);
    l_errno      NUMBER;
    l_newline    NUMBER;
  BEGIN
    -- Get current error stack
    l_errstr := DBMS_UTILITY.format_error_stack;

    -- Find the top user error ignoring generic error messages
    -- Bug 33210508: skip ORA-29400 error
    l_errstr := REGEXP_REPLACE(l_errstr, 'ORA-29913:.*' || CHR(10), '');
    l_errstr := REGEXP_REPLACE(l_errstr, 'ORA-29400:.*' || CHR(10), '');
    l_errstr := REGEXP_REPLACE(l_errstr, 'ORA-06512:.*' || CHR(10), '');
    l_errstr := REGEXP_REPLACE(l_errstr, 'ORA-12801:.*' || CHR(10), '');
    l_errstr := REGEXP_REPLACE(l_errstr, 'ORA-00604:.*' || CHR(10), '');
    l_errstr := REGEXP_REPLACE(l_errstr, 'ORA-17502:.*' || CHR(10), '');

    -- Special Handling for reject limit error
    IF INSTR(l_errstr, 'ORA-30653') > 0 THEN
      raise_application_error(EXCP_REJECT_LIMIT,
                'Reject limit reached, query table ' ||
                DBMS_ASSERT.enquote_name(get_current_user()) || '.' ||
                DBMS_ASSERT.enquote_name(log_table) ||
                ' for error details');
    ELSIF INSTR(l_errstr, 'KUP-11004') > 0 THEN
      raise_application_error(-20000,
                'Invalid format parameter: Bad value for version');
    ELSIF INSTR(l_errstr, 'ORA-31641') > 0 THEN
      raise_application_error(-20000,
                SUBSTR(l_errstr,
                       INSTR(l_errstr, 'ORA-') + LENGTH('ORA-20000: '),
                       INSTR(l_errstr, CHR(10)) - LENGTH('ORA-20000: ') - 1) ||
                '. Please check the credential or if file already exists.');
    END IF;

    -- Resignal the underlying user error, if found
    l_errno := TO_NUMBER(SUBSTR(l_errstr,
                    INSTR(l_errstr, 'ORA-') + LENGTH('ORA-'), 5));
    IF l_errno IS NOT NULL AND l_errno >= 20000 AND l_errno < 21000 THEN
      raise_application_error(-l_errno,
          SUBSTR(l_errstr,
                 INSTR(l_errstr, 'ORA-') + LENGTH('ORA-20000: ')));
    END IF;

    -- Resignal ORA-20000 following with the underlying error message
    raise_application_error(-20000, l_errstr);

  END resignal_user_error;


  -----------------------------------------------------------------------------
  -- validate_external_table_int - Validate External Table Helper procedure
  -----------------------------------------------------------------------------
  PROCEDURE validate_external_table_int(
        table_name               IN         VARCHAR2,
        operation_id             OUT NOCOPY NUMBER,
        partition_name           IN         VARCHAR2     DEFAULT  NULL,
        subpartition_name        IN         VARCHAR2     DEFAULT  NULL,
        schema_name              IN         VARCHAR2     DEFAULT  NULL,
        rowcount                 IN         NUMBER       DEFAULT  0,
        partition_key_validation IN         BOOLEAN      DEFAULT  FALSE,
        stop_on_error            IN         BOOLEAN      DEFAULT  TRUE,
        table_type               IN         PLS_INTEGER  DEFAULT  TABTYPE_EXT
  )
  IS
    --
    -- NAME:
    --   validate_external_table_int - Validate External Table Helper procedure
    --
    -- DESCRIPTION:
    --   This procedure validates the data of a external table over
    --   object store file by querying the data in the external table and
    --   generating a logfile and badfile tables to review the results.
    --
    --   It can also validate only a single partition, to validate a subset of
    --   object store files.
    --
    --   Finally, it can also validate that partition key in the external file
    --   data matches the partition definition for data consistency.
    --
    --   The operation_id can be obtained as OUT argument to view the task
    --   status in USER_LOAD_OPERATIONS view.
    --
    -- PARAMETERS:
    --   table_name      (IN)  - Name of the external table
    --
    --   operation_id    (OUT) - Operation ID in USER_LOAD_OPERATIONS view
    --
    --   partition_name  (IN)  - Name of the partition in external table
    --                           (optional, by default full table is validated)
    --
    --   subpartition_name  (IN)  - Name of the partition in external table
    --                           (optional, by default full table is validated)
    --
    --   schema_name     (IN)  - Name of owning schema for the external table
    --                           (optional, by default current schema is used)
    --
    --   rowcount        (IN)  - Number of rows to fetch from external table
    --                           (optional, 0 implies all rows)
    --
    --   partition_key_validation (IN)  - Validate partition key for the
    --                                    data in Object store file
    --                                    (optional, by default false)
    --
    --   stop_on_error   (IN)  - Stop on bad record encountered in validation
    --                           (default TRUE). If the value is FALSE, then
    --                           validation will continue to skip bad records,
    --                           until a minimum of 'rowcount' records have
    --                           been scanned.
    --
    --   table_type      (IN)  - Type of table (external/hybrid/partitioned)
    --
    -- NOTES:
    --   Added for bug 30274451.
    --
    l_sqlstmt           VARCHAR2(M_VCSIZ_4K);
    l_prefixstmt        VARCHAR2(M_VCSIZ_4K);
    l_badfile_clause    VARCHAR2(M_VCSIZ_4K);
    l_table_name        DBMS_QUOTED_ID;
    l_schema_name       DBMS_QUOTED_ID;
    l_partition_name    DBMS_QUOTED_ID;
    l_subpartition_name DBMS_QUOTED_ID;
    l_log_file_prefix   DBMS_ID;
    l_rowcount          NUMBER;
    l_payload           JSON_OBJECT_T;
    l_reject_limit      DBMS_ID := '0';
    l_status            PLS_INTEGER := DBMS_CLOUD_TASK.TASK_STATUS_COMPLETED;
    l_exttab_type       DBMS_ID;
  BEGIN

    --
    -- Validate input
    --
    -- Initialize operation id
    operation_id := NULL;
    -- Bug 26940179: enquote table name
    l_table_name      := validate_table_name(table_name);
    -- Bug 26515920: enquote the schema name
    l_schema_name     := validate_schema_name(schema_name);
    -- Bug 30274451: validate partition name
    IF partition_name IS NOT NULL THEN
      l_partition_name  := validate_table_name(partition_name);
    END IF;
    IF subpartition_name IS NOT NULL THEN
      l_subpartition_name  := validate_table_name(subpartition_name);
    END IF;

    -- Bug 26636185: Validate rowcount
    IF DBMS_CLOUD_CORE.whole_number(rowcount) = FALSE THEN
      raise_application_error(-20000,
        'Invalid rowcount: ' || NVL(TO_CHAR(rowcount), 'NULL'));
    END IF;

    --
    -- Bug 27428594: Determine the value of reject limit
    -- If stop_on_error=TRUE, then reject limit is 0
    -- If stop_on_error=FALSE, then reject limit is the rowcount if rowcount is
    --   specified, otherwise it is unlimited.
    --
    -- Note:
    --  1. rowcount=0 is all rows, but reject limit 0 means stop at first err
    --
    IF stop_on_error = FALSE THEN
      IF rowcount > 0 THEN
        IF rowcount > REJECT_LIMIT_MAX THEN
          l_reject_limit := TO_CHAR(REJECT_LIMIT_MAX);
        ELSE
          l_reject_limit := TO_CHAR(rowcount);
        END IF;
      ELSE
        l_reject_limit := 'UNLIMITED';
      END IF;
    END IF;

    --
    -- Check table access privilege
    --
    check_table_privilege(schema_name       => l_schema_name,
                          table_name        => l_table_name,
                          partition_name    => l_partition_name,
                          subpartition_name => l_subpartition_name,
                          table_type        => table_type);

    --
    -- Get the type of external table
    --
    l_exttab_type := get_external_table_type(schema_name => l_schema_name,
                                             table_name  => l_table_name);

    -- Create a task with payload information about the load operation
    l_payload := JSON_OBJECT_T('{}');
    l_payload.put('TableName', DBMS_CLOUD_CORE.unquote_name(l_table_name));
    l_payload.put('OwnerName', DBMS_CLOUD_CORE.unquote_name(l_schema_name));
    IF l_partition_name IS NOT NULL THEN
      l_payload.put('PartitionName',
                    DBMS_CLOUD_CORE.unquote_name(l_partition_name));
    END IF;
    IF l_subpartition_name IS NOT NULL THEN
      l_payload.put('SubpartitionName',
                    DBMS_CLOUD_CORE.unquote_name(l_subpartition_name));
    END IF;
    operation_id := DBMS_CLOUD_TASK.create_task(
                        class_name => TASK_CLASS_VALIDATE,
                        userid     => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
                        status     => DBMS_CLOUD_TASK.TASK_STATUS_CREATED,
                        payload    => l_payload.to_clob
                    );

    -- Initialize the log file prefix using the task id
    l_log_file_prefix := DBMS_CLOUD_CORE.VALIDATE_LOG_PREFIX || operation_id;

    -- Create external tables for logfile and badfile
    create_log_external_table(log_file_prefix => l_log_file_prefix,
                              task_id         => operation_id,
                              exttab_type     => l_exttab_type,
                              payload         => l_payload);

    -- Bug 30299289: Set directory of logfile and badfile to be default logdir
    l_prefixstmt := 'SELECT COUNT(*) FROM ' ||
                        l_schema_name || '.' || l_table_name || ' ';

    -- Bug 30274451: support for partition external table
    -- Bug 30529152: support for subpartition validation
    IF l_subpartition_name IS NOT NULL THEN
      l_prefixstmt := l_prefixstmt || 'SUBPARTITION(' || l_subpartition_name ||
                         ') ';
    ELSIF l_partition_name IS NOT NULL THEN
      l_prefixstmt := l_prefixstmt || 'PARTITION(' || l_partition_name || ') ';
    END IF;

    -- Bug 27774240: Datapump external table does not support badfile
    -- Bug 32795716: Disable discard file
    IF l_exttab_type != EXTTAB_TYPE_DATAPUMP THEN
      l_badfile_clause := 'NODISCARDFILE BADFILE ' ||
                          DBMS_CLOUD_CORE.DEFAULT_LOG_DIR || ':' ||
                          DBMS_ASSERT.enquote_literal(l_log_file_prefix ||
                          '_%p.bad');
    END IF;
    l_sqlstmt := l_prefixstmt ||
       'EXTERNAL MODIFY ' ||
       '(ACCESS PARAMETERS ' ||
        '(LOGFILE ' || DBMS_CLOUD_CORE.DEFAULT_LOG_DIR || ':' ||
          DBMS_ASSERT.enquote_literal(l_log_file_prefix || '_%p.log') || ' ' ||
          l_badfile_clause || ') ' ||
       'REJECT LIMIT ' || l_reject_limit || ') ';

    IF rowcount > 0 THEN
      -- Add ROWNUM predicate if rowcount is passed in
      -- Bug 26940179: use bind variable to prevent sql injection
      l_sqlstmt := l_sqlstmt || 'WHERE rownum <= :1';
      EXECUTE IMMEDIATE l_sqlstmt INTO l_rowcount USING rowcount;
    ELSE
      EXECUTE IMMEDIATE l_sqlstmt INTO l_rowcount;
    END IF;

    -- Save the number of rows loaded in the task payload
    l_payload.put('RowsLoaded', l_rowcount);

    --
    -- Bug 30274451: support for partition key validation
    --
    IF partition_key_validation = TRUE THEN
      l_sqlstmt := l_prefixstmt ||
                        'WHERE ORA_PARTITION_VALIDATION(rowid) = 0 ' ||
                        'FETCH FIRST 1 ROWS ONLY';
      EXECUTE IMMEDIATE l_sqlstmt INTO l_rowcount;

      IF l_rowcount > 0 THEN
        l_payload.put('PartitionKeyValidation',
                      DBMS_CLOUD_TASK.TASK_STATUS_FAILED);
        -- task failed
        l_status := DBMS_CLOUD_TASK.TASK_STATUS_FAILED;
      ELSE
        -- task failed
        l_payload.put('PartitionKeyValidation',
                      DBMS_CLOUD_TASK.TASK_STATUS_COMPLETED);
      END IF;
    ELSE
      -- task completed
      l_status := DBMS_CLOUD_TASK.TASK_STATUS_COMPLETED;
    END IF;

    -- Mark the task as COMPLETED
    DBMS_CLOUD_TASK.update_task(
      id      => operation_id,
      userid  => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
      status  => l_status,
      payload => l_payload.to_clob
    );

  EXCEPTION
    WHEN OTHERS THEN
      -- Mark the task as FAILED
      IF operation_id IS NOT NULL THEN
        DBMS_CLOUD_TASK.update_task(
          id      => operation_id,
          userid  => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
          status  => DBMS_CLOUD_TASK.TASK_STATUS_FAILED,
          payload => l_payload.to_clob
        );
      END IF;

      -- Bug 29167938: Resignal the relevant error in the errorstack stack
      -- to avoid generic error from external table access driver
      IF l_payload IS NOT NULL THEN
        resignal_user_error(l_payload.get_string('LogfileTable'));
      ELSE
        resignal_user_error();
      END IF;

      RAISE;
  END validate_external_table_int;


  -----------------------------------------------------------------------------
  -- parse_format_parameters - Parse Format Parameters for external table
  -----------------------------------------------------------------------------
  FUNCTION parse_format_parameters(
        format   IN  CLOB
  ) RETURN JSON_OBJECT_T
  IS
    --
    -- NAME:
    --   parse_format_parameters - Parse Format Parameters for external table
    --
    -- DESCRIPTION:
    --   This function parses the format parameters and returns a JSON Object
    --   with the key value pairs.
    --
    -- PARAMETERS:
    --   format  (IN) - Format parameters json as a clob
    --
    -- RETURNS:
    --   JSON Object representing the format parameters
    --
    -- NOTES:
    --
    l_format_obj   JSON_OBJECT_T;
  BEGIN

    IF format IS NULL THEN
      -- If null format, then create empty JSON object
      l_format_obj := JSON_OBJECT_T.parse('{}');
    ELSE
      -- Parse the format as a JSON document. If not JSON, then parse will
      -- signal an error
      l_format_obj := JSON_OBJECT_T.parse(format);
    END IF;

    RETURN l_format_obj;

  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(EXCP_INVALID_FORMAT,
                'Format argument is not a valid JSON');
  END parse_format_parameters;


  -----------------------------------------------------------------------------
  -- get_json_number - Get JSON Number value for a key
  -----------------------------------------------------------------------------
  FUNCTION get_json_number(
    obj        IN  JSON_OBJECT_T,
    key        IN  VARCHAR2
  ) RETURN NUMBER
  IS
    --
    -- NAME:
    --   get_json_number - Get JSON Number value for a key
    --
    -- DESCRIPTION:
    --   This procedure is a helper function to get the number value for a key
    --   in the JSON object.
    --
    -- PARAMETERS:
    --   obj        (IN)  - JSON object
    --
    --   key        (IN)  - Key to lookup in the JSON object
    --
    --
    -- RETURNS:
    --   Number value for the key.
    --
    -- NOTES:
    --
    l_num  NUMBER;
    l_obj  JSON_OBJECT_T := obj;
  BEGIN

    -- By default any problems when calling object.get_number() result in a
    -- return value of NULL. Alter this behavior to raise all errors.
    l_obj.on_error(1);
    l_num := l_obj.get_number(key);
    l_obj.on_error(0);

    RETURN l_num;

  EXCEPTION
    WHEN OTHERS THEN
      -- Restore the error behavior
      l_obj.on_error(0);

      --  Raise the proper error when a data type conversion error happens.
      IF SQLCODE = -40566 THEN
        RAISE invalid_format_value;
      -- Ignore the error when logretention does not exist in the json object.
      -- Bug 32870012: handle 40571 as this is the error thrown in RDBMS MAIN
      -- when key is not found in the JSON object
      ELSIF SQLCODE IN (-40565, -40571) THEN
        RETURN NULL;
      END IF;
      RAISE;
  END get_json_number;


  -----------------------------------------------------------------------------
  -- get_json_string - Get JSON String value for a key
  -----------------------------------------------------------------------------
  FUNCTION get_json_string(
    obj        IN  JSON_OBJECT_T,
    key        IN  VARCHAR2,
    trim_value IN  BOOLEAN DEFAULT TRUE
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   get_json_string - Get JSON String value for a key
    --
    -- DESCRIPTION:
    --   This procedure is a helper function to get the string value for a key
    --   in the JSON object.
    --
    -- PARAMETERS:
    --   obj        (IN)  - JSON object
    --
    --   key        (IN)  - Key to lookup in the JSON object
    --
    --   trim_value (IN)  - Trim the value (default TRUE)
    --
    -- RETURNS:
    --   String value for the key.
    --
    -- NOTES:
    --
  BEGIN

    -- Bug 30287584: Validate the value length
    IF trim_value THEN
      IF LENGTH(TRIM(obj.get_string(key))) > M_IDEN THEN
        RAISE invalid_format_value;
      END IF;

      RETURN TRIM(obj.get_string(key));
    ELSE
      IF LENGTH(obj.get_string(key)) > M_IDEN THEN
        RAISE invalid_format_value;
      END IF;

      RETURN obj.get_string(key);
    END IF;

  END get_json_string;


  -----------------------------------------------------------------------------
  -- get_json_boolean - Get JSON Boolean value for a key
  -----------------------------------------------------------------------------
  FUNCTION get_json_boolean(
    obj    IN  JSON_OBJECT_T,
    key    IN  VARCHAR2
  ) RETURN BOOLEAN
  IS
    --
    -- NAME:
    --   get_json_boolean - Get JSON Boolean value for a key
    --
    -- DESCRIPTION:
    --   This procedure is a helper function to get the boolean value for a
    --   key in the JSON object.
    --
    -- PARAMETERS:
    --   obj     (IN)   - JSON object
    --
    --   key     (IN)   - Key to lookup in the JSON object
    --
    -- RETURNS:
    --   Boolean value for the key
    --
    -- NOTES:
    --
  BEGIN
    -- Bug 25928012: Boolean keys should only support TRUE/FALSE/NULL values.
    -- NULL value is same as FALSE.
    CASE UPPER(NVL(get_json_string(obj, key), 'FALSE'))
      WHEN 'TRUE' THEN
        RETURN TRUE;
      WHEN 'FALSE' THEN
        RETURN FALSE;
      ELSE
        RAISE invalid_format_value;
    END CASE;
  END get_json_boolean;


  -----------------------------------------------------------------------------
  -- get_log_file_prefix  - Get Log File Prefix
  -----------------------------------------------------------------------------
  FUNCTION get_log_file_prefix(
        format          IN  JSON_OBJECT_T,
        operation_id    IN  NUMBER,
        default_prefix  IN  VARCHAR2
  ) RETURN VARCHAR2
  IS
    --
    -- get_log_file_prefix  - Get Log File Prefix
    --
    -- DESCRIPTION:
    --   This is a helper function to return the log file prefix.
    --
    -- PARAMETERS:
    --   format          (IN) - formatting options in JSON
    --
    --   operation_id    (IN) - Operation ID in USER_LOAD_OPERATIONS view
    --
    --   default_prefix  (IN) - Default log file prefix
    --
    -- NOTES:
    --   Added for bug 32645221.
    --
    l_log_file_prefix      DBMS_ID;
  BEGIN
    --
    -- Bug 32645221: Support custom log prefix
    -- Logfile prefix format is:
    --    [<customprefix>|<default_prefix>]$<operation_id>
    --
    l_log_file_prefix := get_json_string(format, FORMAT_LOG_PREFIX);
    IF l_log_file_prefix IS NULL THEN
      l_log_file_prefix := default_prefix || operation_id;
    ELSE
      l_log_file_prefix := l_log_file_prefix || '$' || operation_id;
    END IF;

    RETURN l_log_file_prefix;

  END get_log_file_prefix;


  -----------------------------------------------------------------------------
  -- copy_task_end - Cleanup for Copy Data
  -----------------------------------------------------------------------------
  PROCEDURE copy_task_end(
        temp_table_name     IN          DBMS_ID,
        parent_operation    IN          VARCHAR2 DEFAULT NULL,
        operation_id        IN          NUMBER,
        payload             IN          JSON_OBJECT_T,
        status              IN          NUMBER DEFAULT NULL,
        error_code          IN          NUMBER
  )
  IS
    --
    -- NAME:
    --   copy_task_end - Cleanup for Copy Data
    --
    -- DESCRIPTION:
    --   This is a helper procedure to perform cleanup and ends the Copy task.
    --
    -- PARAMETERS:
    --   temp_table_name  (IN)  - Name of the temporary external table
    --
    --   parent_operation (IN)  - Parent operation type
    --
    --   operation_id     (IN)  - Operation ID in USER_LOAD_OPERATIONS view
    --
    --   payload          (IN)  - Custom task payload
    --
    --   status           (IN)  - Task status
    --
    --   error_code       (IN)  - Error code
    --
    -- NOTES:
    --   Added for bug 29377868.
    --
  BEGIN

    -- Drop the temporary external table
    IF error_code = 0 OR error_code != -955 THEN
      DBMS_CLOUD_INTERNAL.drop_external_table(
        invoker_schema   => get_current_user(),
        table_name       => temp_table_name,
        parent_operation => parent_operation
      );
    END IF;

    -- Mark the task as COMPLETED
    DBMS_CLOUD_TASK.update_task(
      id      => operation_id,
      userid  => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
      status  => status,
      payload => payload.to_clob
    );

  END copy_task_end;


  -----------------------------------------------------------------------------
  -- copy_task_begin - Setup Task for Copy Data from Object Store to Oracle
  --                   Database
  -----------------------------------------------------------------------------
  PROCEDURE copy_task_begin(
        temp_table_name     IN          DBMS_ID,
        credential_name     IN          VARCHAR2 DEFAULT NULL,
        file_uri_list       IN          CLOB,
        column_list         IN          CLOB     DEFAULT NULL,
        base_table_name     IN          VARCHAR2 DEFAULT NULL,
        base_table_schema   IN          VARCHAR2 DEFAULT NULL,
        field_list          IN          CLOB     DEFAULT NULL,
        format              IN          CLOB     DEFAULT NULL,
        parent_operation    IN          VARCHAR2 DEFAULT NULL,
        export_query        IN          CLOB     DEFAULT NULL,
        operation_id        OUT NOCOPY  NUMBER,
        payload             OUT         JSON_OBJECT_T
  )
  IS
    --
    -- NAME:
    --   copy_task_begin - Setup Task for Copy Data
    --
    -- DESCRIPTION:
    --   This is a helper procedure to perform setup Copy Task.
    --
    -- PARAMETERS:
    --   temp_table_name   (IN) - Name of the temporary external table
    --
    --   credential_name   (IN) - Credential object name to authenticate with
    --                            with Object Store.
    --
    --   file_uri_list     (IN) - URI(s) of the files existing in Object Store
    --
    --   column_list       (IN) - Column definition clause for CREATE TABLE
    --                            (optional).
    --                            The value of this argument should be same as
    --                            specifying a list of columns in creating an
    --                            external table, without the enclosing
    --                            parenthesis used for the column clause.
    --                              Eg: 'empno NUMBER, emp_name VARCHAR2(128)'
    --
    --   base_table        (IN) - Base table to use for deriving the column
    --                            list for the external table.
    --
    --   base_table_schema (IN) - Schema name owning the 'base_table'
    --
    --   field_list        (IN) - Field_list for External table (optional).
    --                            This value identifies the fields in the
    --                            external file and their datatypes.
    --
    --   format            (IN) - Additional data formatting options (optional)
    --                            in JSON format.
    --
    --   parent_operation  (IN) - Parent operation type
    --
    --   export_query      (IN) - Select query for exporting data
    --
    --   operation_id      (IN) - Operation ID in USER_LOAD_OPERATIONS view
    --
    --   payload           (IN) - Custom task payload
    --
    -- NOTES:
    --   Added for bug 29377868.
    --
    l_log_file_prefix      DBMS_ID;
    l_exttab_type          DBMS_ID;
    l_format_obj           JSON_OBJECT_T;
    l_logretention         NUMBER;
    l_cleanup_interval     INTERVAL DAY(5) TO SECOND;
    l_class_name           DBMS_ID;
  BEGIN

    -- Create a task with payload information about the load operation
    payload := JSON_OBJECT_T('{}');
    IF base_table_name IS NOT NULL THEN
      payload.put('TableName',DBMS_CLOUD_CORE.unquote_name(base_table_name));
    END IF;
    IF base_table_schema IS NOT NULL THEN
      payload.put('OwnerName',DBMS_CLOUD_CORE.unquote_name(base_table_schema));
    END IF;
    payload.put('FileUriList', SUBSTR(file_uri_list, 0, M_VCSIZ_4K));
    payload.put('TempExtTable', temp_table_name);
    IF credential_name IS NOT NULL THEN
      payload.put('CredentialName',
                  DBMS_CLOUD_CORE.unquote_name(credential_name));
    END IF;

    -- Bug 30020689: Support retention days for copy_data.
    BEGIN
      l_format_obj := parse_format_parameters(format => format);
      l_logretention := get_json_number(l_format_obj, FORMAT_LOG_RETENTION);
      IF l_logretention IS NOT NULL THEN
        -- Validate log retention to be a whole number.
        IF DBMS_CLOUD_CORE.whole_number(l_logretention) = FALSE THEN
          RAISE invalid_format_value;
        END IF;
        l_cleanup_interval := NUMTODSINTERVAL(l_logretention, 'day');
      END IF;
    EXCEPTION
      WHEN invalid_format_value THEN
        raise_application_error(-20000,
              'Invalid format parameter: Bad value for logretention');
    END;

    -- Use export task class for export_data
    IF export_query IS NOT NULL THEN
      l_class_name := TASK_CLASS_EXPORT;
    ELSE
      l_class_name := TASK_CLASS_COPY;
    END IF;

    -- Bug 30020689: Support retention days for copy_data.
    -- Bug 33272495: Incorporate dbms_cloud_task.create_task2(). This function
    -- allows cleanup interval precision up to 5 digits.
    operation_id := DBMS_CLOUD_TASK.create_task2(
                        class_name => l_class_name,
                        userid     => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
                        status     => DBMS_CLOUD_TASK.TASK_STATUS_CREATED,
                        payload    => payload.to_clob,
                        cleanup_interval => TO_CHAR(l_cleanup_interval));

    -- Initialize the log file prefix using the task id
    l_log_file_prefix := get_log_file_prefix(
                              format         => l_format_obj,
                              operation_id   => operation_id,
                              default_prefix => DBMS_CLOUD_CORE.COPY_LOG_PREFIX
                         );

    BEGIN
      -- Bug 29817501: For export data, the log tables need to be created
      -- before creating the external table, because data export is part of
      -- creating the external table.
      IF parent_operation = EXPORT_DATA_OPER THEN
        create_log_external_table(log_file_prefix => l_log_file_prefix,
                                  task_id         => operation_id,
                                  exttab_type     => EXTTAB_TYPE_DATAPUMP,
                                  payload         => payload);
      END IF;

      -- Create a temporary external table to access the object
      -- Bug 26474359: pass base_table_schema as the schema name for table
      create_external_table_int(
          table_name          => temp_table_name,
          credential_name     => credential_name,
          file_uri_list       => file_uri_list,
          column_list         => column_list,
          base_table          => base_table_name,
          base_table_schema   => base_table_schema,
          field_list          => field_list,
          format              => format,
          log_dir             => DBMS_CLOUD_CORE.DEFAULT_LOG_DIR,
          log_file_prefix     => l_log_file_prefix,
          parent_operation    => parent_operation,
          export_query        => export_query
      );

      -- Create external tables for logfile and badfile, except for export
      IF parent_operation != EXPORT_DATA_OPER THEN
        l_exttab_type := get_external_table_type(
                            schema_name => get_current_user(),
                            table_name  => temp_table_name
                        );
        create_log_external_table(log_file_prefix => l_log_file_prefix,
                                  task_id         => operation_id,
                                  exttab_type     => l_exttab_type,
                                  payload         => payload);
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        -- clean up and mark the task as FAILED
        copy_task_end(
          temp_table_name     => temp_table_name,
          parent_operation    => parent_operation,
          operation_id        => operation_id,
          payload             => payload,
          status              => DBMS_CLOUD_TASK.TASK_STATUS_FAILED,
          error_code          => SQLCODE
        );

        RAISE;
    END;

  END copy_task_begin;


  -----------------------------------------------------------------------------
  -- is_soda_default_collection - Check if it is a default SODA collection
  -----------------------------------------------------------------------------
  FUNCTION is_soda_default_collection(
        collection_name  IN  VARCHAR2
  ) RETURN BOOLEAN
  IS
    --
    -- NAME: is_soda_default_collection - Check it is a SODA default
    --       collection
    --
    --
    -- DESCRIPTION:
    --   This is a helper function to check if it a default SODA collection
    --
    -- PARAMETERS:
    --   collection_name  (IN)   - collection name
    --
    -- NOTES: Added for Bug 31964335
    --
    l_stmt                 VARCHAR2(M_VCSIZ_4K);
    l_result               BOOLEAN;
  BEGIN
    l_stmt := 'BEGIN :1 := DBMS_SODA_ADMIN.IS_DEFAULT_ADB_COLLECTION(:2);'
                || ' END;';

    EXECUTE IMMEDIATE l_stmt USING OUT l_result, IN collection_name;

    RETURN l_result;

  EXCEPTION
    -- Fall back to original SODA API implementation
    WHEN OTHERS THEN
      RETURN FALSE;

  END is_soda_default_collection;


  -----------------------------------------------------------------------------
  -- copy_collection_dflt - Load data into a default SODA collection
  -----------------------------------------------------------------------------
  FUNCTION copy_collection_dflt(
    table_name  IN VARCHAR2,
    schema_name IN VARCHAR2,
    ext_tab     IN varchar2,
    format      IN JSON_OBJECT_T
  ) RETURN NUMBER
  IS
    --
    -- NAME: copy_collection_dflt - Load default collection internal function
    --
    --
    -- DESCRIPTION:
    --   This is a helper function to load data into a default SODA collection
    --   from external table
    --
    -- PARAMETERS:
    --   table_name  (IN)     - table name
    --   ext_tab     (IN)     - external table name
    --   schema_name (IN)     - Schema name
    --   format      (IN)     - Additional data formatting options
    --                          in JSON format.
    --
    -- NOTES: Added for Bug 31964335
    --
    l_stmt                 VARCHAR2(M_VCSIZ_4K);
    l_path                 VARCHAR2(M_VCSIZ_4K);
    l_ejson                DBMS_ID;
    l_nrows                INTEGER;
    l_keypath              VARCHAR2(M_VCSIZ_4K);
    l_keyjtabcol           VARCHAR2(M_VCSIZ_4K);
    l_keycol               DBMS_ID;
    l_extend               VARCHAR2(M_VCSIZ_4K);
  BEGIN

    l_path    := TRIM(format.get_string(FORMAT_JSON_PATH));
    l_ejson   := UPPER(NVL(TRIM(format.get_string(FORMAT_TYPE)), 'JSON'));
    l_keypath := TRIM(format.get_string('keypath'));

    IF l_ejson = FORMAT_TYPE_EJSON THEN
      l_extend := ' extended),';
    ELSE
      l_extend := '), ';
    END IF;

    IF UPPER(NVL(TRIM(format.get_string(FORMAT_UNPACKARRAYS)),'FALSE'))
         = 'TRUE' OR format.get_boolean(FORMAT_UNPACKARRAYS) = TRUE THEN
      -- Unpack array
      -- Bug 32284693: Check for keypath
      IF LENGTH(l_keypath) > 0 THEN
        l_keycol := 'v.keyid';
        l_keyjtabcol := ',keyid varchar2(255) path ''' || l_keypath || '''';
      ELSE
        l_keycol := 'sys_guid()';
        l_keyjtabcol := '';
      END IF;
      -- Insert into the local table specified
      -- Use hints for Append and Enabling Parallel DML
      l_stmt := 'INSERT /*+ append enable_parallel_dml */ INTO ' ||
                     schema_name || '.' || table_name || ' SELECT ' ||
                     l_keycol || ', sys_extract_utc(systimestamp),
                     sys_extract_utc(systimestamp), sys_guid(),';
      l_stmt := l_stmt || ' v.obj ';


      l_stmt := l_stmt ||
                ' from ' || schema_name || '.' || ext_tab;

      IF LENGTH(l_path) > 0 THEN
          l_stmt := l_stmt ||
                    ', json_table(oson(json_document returning blob '
                    || l_extend || '''' || l_path || '[*]''' ||
                    ' columns obj blob format json path ''$''' ||
                    l_keyjtabcol || ') v';
      ELSE
        l_stmt := l_stmt ||
                    ', json_table(oson(json_document returning blob '
                    || l_extend || '''$[*]''' ||
                    ' columns obj blob format json path ''$''' ||
                    l_keyjtabcol || ') v';
      END IF;
    ELSE
      -- Insert a single document in the collection
      IF LENGTH(l_keypath) > 0 THEN
        l_keycol := 'json_value(oson(json_document returning blob ' ||
                     l_extend || '''' || l_keypath ||
                         ''' returning varchar2)';
      ELSE
        l_keycol := 'sys_guid()';
      END IF;
      -- Insert into the local table specified
      -- Use hints for Append and Enabling Parallel DML
      l_stmt := 'INSERT /*+ append enable_parallel_dml */ INTO ' ||
                     schema_name || '.' || table_name || ' SELECT ' ||
                     l_keycol || ', sys_extract_utc(systimestamp),
                     sys_extract_utc(systimestamp), sys_guid(),';
      IF LENGTH(l_path) > 0 THEN
        l_stmt := l_stmt || ' oson(json_query(json_document,''' || l_path ||
                  ''') returning blob';
      ELSE
        l_stmt := l_stmt || ' oson(json_document returning blob';
      END IF;

      IF l_ejson = FORMAT_TYPE_EJSON THEN
        l_stmt := l_stmt || ' extended ';
      END IF;

      l_stmt := l_stmt || ' )' ||
                ' from ' || schema_name || '.' || ext_tab;
    END IF;

    EXECUTE IMMEDIATE l_stmt;

    l_nrows := SQL%ROWCOUNT;

    COMMIT;

    RETURN l_nrows;

  EXCEPTION
    WHEN OTHERS THEN

    -- Bug 31873416 and 32030258, Just raise, let the caller raise the
    -- correct error message
    RAISE;

  END copy_collection_dflt;


  -----------------------------------------------------------------------------
  -- copy_collection_int - Load data into a SODA collection
  -----------------------------------------------------------------------------
  FUNCTION copy_collection_int(
    collection_name   IN VARCHAR2,
    schema_name       IN VARCHAR2,
    ext_tab           IN VARCHAR2,
    format            IN JSON_OBJECT_T
  ) RETURN NUMBER
  IS
    --
    -- NAME: copy_collection_int - Load collection internal function
    --
    --
    -- DESCRIPTION:
    --   This is a helper function to load data into a SODA collection from
    --   external table
    --
    -- PARAMETERS:
    --   collName  (IN)      - collection name
    --   ext_tab   (IN)      - external table name
    --
    -- NOTES:
    --
    l_selstmt               VARCHAR2(M_VCSIZ_4K);
    l_sqlstmt               VARCHAR2(M_VCSIZ_32K);
    l_nrows                 INTEGER;
    l_path                  VARCHAR2(M_VCSIZ_4K);
    l_ejson                 DBMS_ID;
    l_unpackarray           BOOLEAN;
  BEGIN

    l_path  := TRIM(format.get_string(FORMAT_JSON_PATH));
    l_ejson := UPPER(NVL(TRIM(format.get_string(FORMAT_TYPE)), 'JSON'));
    IF LENGTH(l_path) > 0 THEN
      l_selstmt := 'select oson(json_query(json_document,''' || l_path ||
                   ''' returning blob null on error) returning blob ';
      IF l_ejson = FORMAT_TYPE_EJSON THEN
        l_selstmt := l_selstmt || ' extended ';
      END IF;
      l_selstmt := l_selstmt || ' )' ||
                ' from ' || schema_name || '.' || ext_tab;

    ELSE
      l_selstmt := 'select oson(json_document returning blob ';
      IF l_ejson = FORMAT_TYPE_EJSON THEN
        l_selstmt := l_selstmt || ' extended ';
      END IF;
      l_selstmt := l_selstmt || ' ) from ' ||
                schema_name || '.' || ext_tab;
    END IF;

    IF UPPER(NVL(TRIM(format.get_string(FORMAT_UNPACKARRAYS)),'FALSE'))
           = 'TRUE' OR format.get_boolean(FORMAT_UNPACKARRAYS) = TRUE THEN
      l_unpackarray := TRUE;
    ELSE
      l_unpackarray := FALSE;
    END IF;


    l_sqlstmt :=
      'DECLARE                                                         ' ||
      '  l_collection            SODA_COLLECTION_T;                    ' ||
      '  l_document              SODA_DOCUMENT_T;                      ' ||
      '  l_doc_content           BLOB;                                 ' ||
      '  l_cnum                  INTEGER;                              ' ||
      '  l_array_idx             INTEGER;                              ' ||
      '  l_json_elem             JSON_ELEMENT_T;                       ' ||
      '  l_json_array            JSON_Array_T;                         ' ||
      '  l_loop_elem             JSON_ELEMENT_T;                       ' ||
      '  l_array_size            INTEGER;                              ' ||
      '  l_status                INTEGER;                              ' ||
      '  l_nrows                 INTEGER;                              ' ||
      'BEGIN                                                           ' ||
      '  l_cnum := DBMS_SQL.open_cursor;                               ' ||
      '  l_collection := DBMS_SODA.open_collection(:1);                ' ||
      '  DBMS_SQL.parse(l_cnum, :2, DBMS_SQL.NATIVE);                  ' ||
      '  l_nrows := DBMS_SQL.execute(l_cnum);                          ' ||
      '  DBMS_SQL.DEFINE_COLUMN(l_cnum,1,l_doc_content);               ' ||
      '  l_nrows := 0;                                                 ' ||
      '  WHILE DBMS_SQL.FETCH_ROWS(l_cnum) > 0 LOOP                    ' ||
      '    DBMS_SQL.COLUMN_VALUE(l_cnum,1,l_doc_content);              ' ||
      '    IF LENGTH(l_doc_content) > 0 THEN                           ' ||
      '      IF :3 = TRUE THEN                                         ' ||
      '        l_json_elem := JSON_ELEMENT_T.parse(l_doc_content);     ' ||
      '        IF l_json_elem.Is_Array() THEN                          ' ||
      '          l_json_array := JSON_Array_T(l_json_elem);            ' ||
      '          l_array_size := l_json_elem.get_size();               ' ||
      '          l_array_idx := 0;                                     ' ||
      '          WHILE l_array_idx < l_array_size LOOP                 ' ||
      '            l_loop_elem := l_json_array.get(l_array_idx);       ' ||
      '            l_document := SODA_DOCUMENT_T(b_content =>          ' ||
      '                              l_loop_elem.to_blob);             ' ||
      '            l_status := l_collection.insert_one(l_document);    ' ||
      '            l_nrows := l_nrows + 1;                             ' ||
      '            l_array_idx := l_array_idx + 1;                     ' ||
      '          END LOOP;                                             ' ||
      '        ELSE                                                    ' ||
      '          l_document := SODA_DOCUMENT_T(b_content =>            ' ||
      '                           l_json_elem.to_blob);                ' ||
      '          l_status := l_collection.insert_one(l_document);      ' ||
      '          l_nrows := l_nrows + 1;                               ' ||
      '        END IF;                                                 ' ||
      '      ELSE                                                      ' ||
      '        l_json_elem := JSON_ELEMENT_T.parse(l_doc_content);     ' ||
      '        l_document  := SODA_DOCUMENT_T(b_content =>             ' ||
      '                             l_json_elem.to_blob);              ' ||
      '        l_status := l_collection.insert_one(l_document);        ' ||
      '        l_nrows := l_nrows + 1;                                 ' ||
      '      END IF;                                                   ' ||
      '    END IF;                                                     ' ||
      '  END LOOP;                                                     ' ||
      '  DBMS_SQL.close_cursor(l_cnum);                                ' ||
      '  :4 := l_nrows;                                                ' ||
      'EXCEPTION                                                       ' ||
      '  WHEN OTHERS THEN                                              ' ||
      '    DBMS_SQL.close_cursor(l_cnum);                              ' ||
      '    RAISE;                                                      ' ||
      'END;';


    EXECUTE IMMEDIATE l_sqlstmt USING IN collection_name, IN l_selstmt,
                      IN l_unpackarray, OUT l_nrows;
    -- commit the transaction
    COMMIT;
    RETURN l_nrows;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;

  END copy_collection_int;


  -----------------------------------------------------------------------------
  -- validate_collection_format - Validate format parameter for copy_collection
  -----------------------------------------------------------------------------
  PROCEDURE validate_collection_format(
    parent_operation IN     VARCHAR2,
    format           IN OUT JSON_OBJECT_T,
    field_list          OUT VARCHAR2,
    column_path_array   OUT JSON_ARRAY_T
  )
  IS
    --
    -- NAME:
    --   validate_collection_format - Validate format parameter for
    --                                copy_collection
    --
    -- DESCRIPTION:
    --   This procedure validates the format parameters for copy_collection.
    --
    -- PARAMETERS:
    --   parent_operation     (IN)      - Parent operation type
    --   format               (IN OUT)  - Format parameters JSON object
    --   field_list           (OUT)     - field list for external table on
    --                                    top of JSON document
    --   column_path_array    (OUT)     - column json path expressions
    --
    -- NOTES:
    --   Added for bug 29377868.
    --
    l_format_keys   JSON_KEY_LIST;
    l_maxsize_str   DBMS_ID;
    l_maxsize       NUMBER;
    l_rec_delimiter DBMS_ID;
    l_columnpath    CLOB;
    l_keypath       DBMS_ID;
    l_keyassign     DBMS_ID;
  BEGIN

    l_format_keys := format.get_keys;

    IF l_format_keys IS NOT NULL THEN

      CASE parent_operation

        WHEN COPY_COLLECTION_OPER THEN

          --
          -- Loop over all the Keys
          --
          FOR i IN 1..l_format_keys.COUNT  LOOP
            IF LOWER(l_format_keys(i)) NOT IN (
                   FORMAT_RECORD_DELIMITER,
                   FORMAT_IGN_BLANK_LINES,
                   FORMAT_CHARACTERSET,
                   FORMAT_REJECT_LIMIT,
                   FORMAT_COMPRESSION,
                   FORMAT_UNPACKARRAYS,
                   FORMAT_JSON_PATH,
                   FORMAT_JSON_DOC_MAXSIZE,
                   FORMAT_TYPE,
                   'keypath',
                   'keyassignment') THEN
              raise_application_error(-20000,
                  'Invalid format parameter: Unrecognized parameter ' ||
                  l_format_keys(i));
            END IF;
          END LOOP;

        WHEN COPY_DATA_OPER THEN

          --
          -- Loop over all the Keys
          --
          -- Bug 33298916: We do not support unpackarrays and jsonpath
          --               (path to the collection in the json document)
          --               currently in DBMS_CLOUD.copy_data when importing
          --               JSON.
          --               columnpath is a JSON array consisting of json path
          --               expressions that correspond to the fields that need
          --               to be extracted from the JSON records.
          FOR i IN 1..l_format_keys.COUNT  LOOP
            IF LOWER(l_format_keys(i)) NOT IN (
                   FORMAT_RECORD_DELIMITER,
                   FORMAT_IGN_BLANK_LINES,
                   FORMAT_CHARACTERSET,
                   FORMAT_REJECT_LIMIT,
                   FORMAT_COMPRESSION,
                   'columnpath',
                   FORMAT_JSON_DOC_MAXSIZE,
                   FORMAT_TYPE) THEN
              raise_application_error(-20000,
                  'Invalid format parameter: Unrecognized parameter ' ||
                  l_format_keys(i));
            END IF;
          END LOOP;

      END CASE;

    END IF;

    l_rec_delimiter := TRIM(format.get_string(FORMAT_RECORD_DELIMITER));
    IF LENGTH(l_rec_delimiter) > 0 THEN
      -- Set the field delimiter same as the record delimiter
      format.put(FORMAT_FIELD_DELIMITER, l_rec_delimiter);
    ELSE
      -- Set the default field delimiter for JSON
      format.put(FORMAT_FIELD_DELIMITER, FORMAT_DFLT_JSON_FIELD_DELIMITER);
    END IF;

    -- Bug 31337493: Get max document size to use in field_list for external
    -- table
    IF LENGTH(TRIM(format.get_string(FORMAT_JSON_DOC_MAXSIZE))) > M_IDEN
    THEN
      raise_application_error(-20000,
                              'Invalid format parameter: Bad value for '
                              || FORMAT_JSON_DOC_MAXSIZE);
    END IF;
    IF LENGTH(TRIM(format.get_string(FORMAT_JSON_PATH))) > M_VCSIZ_4K THEN
      raise_application_error(-20000,
        'Invalid format parameter: Bad value for ' || FORMAT_JSON_PATH);
    END IF;
    IF UPPER(TRIM(format.get_string(FORMAT_UNPACKARRAYS))) NOT IN
         ('TRUE', 'FALSE')  THEN
      raise_application_error(-20000,
        'Invalid format parameter: Bad value for ' || FORMAT_UNPACKARRAYS);
    END IF;

    --Bug 32284693: Verify keypath and keyassignment parameters
    IF UPPER(TRIM(format.get_string('keyassignment'))) NOT IN
         ('CLIENT', 'UUID', 'EMBEDDED_OID')  THEN
      raise_application_error(-20000,
        'Invalid format parameter: Bad value for ' ||
        'keyassignment');
    END IF;

    l_keyassign :=
      UPPER(NVL(TRIM(format.get_string('keyassignment')),'UUID'));
    l_keypath := TRIM(format.get_string('keypath'));

    IF LENGTH(l_keypath) > M_VCSIZ_4K THEN
      raise_application_error(-20000,
        'Invalid format parameter: Bad value for ' || 'keypath');
    END IF;

    IF LENGTH(l_keypath) > 0 AND l_keyassign ='UUID' THEN
      raise_application_error(-20000,
        'Invalid format parameter: Bad value for ' || 'keyassignment');
    END IF;

    IF (l_keyassign = 'CLIENT' OR l_keyassign = 'EMBEDDED_OID') AND
       (l_keypath IS NULL OR LENGTH(l_keypath) = 0)
    THEN
      raise_application_error(-20000,
        'Invalid format parameter: Bad value for ' || 'keypath');
    END IF;

    l_maxsize_str := TRIM(format.get_string(FORMAT_JSON_DOC_MAXSIZE));

    IF LENGTH(l_maxsize_str) > 0 THEN
      l_maxsize := TO_NUMBER(l_maxsize_str DEFAULT -1 ON CONVERSION
                             ERROR);
      IF DBMS_CLOUD_CORE.whole_number(l_maxsize) = FALSE  OR
         l_maxsize > MAX_JSON_RECORD_SIZE THEN
        raise_application_error(-20000,
          'Invalid format parameter: Bad value for '
               || FORMAT_JSON_DOC_MAXSIZE);
      END IF;

      -- Bug 32073554: When max doc size is larger than default read size
      -- We need to set the READSIZE make it consistent with Max doc size
      IF l_maxsize > DFLT_JSON_RECORD_SIZE THEN
        format.put(FORMAT_READSIZE, l_maxsize_str);
      END IF;

      field_list := 'JSON_DOCUMENT CHAR(' || l_maxsize_str || ')';
    ELSE
      field_list := 'JSON_DOCUMENT CHAR(' || DFLT_JSON_RECORD_SIZE || ')';
    END IF;

    IF parent_operation = COPY_DATA_OPER THEN
      -- Bug 33298916: columnpath takes in a json array consisting of json
      -- path expression for each column.
      l_columnpath := TRIM(format.get_clob('columnpath'));
      BEGIN
        column_path_array := JSON_ARRAY_T.parse(l_columnpath);
      EXCEPTION
        WHEN OTHERS THEN
          -- Exception raised during parsing of the CLOB as a JSON array
          raise_application_error(-20000,
            'Invalid format parameter: Bad value for ' ||
            'columnpath');
      END;
    END IF;

  END validate_collection_format;


  -----------------------------------------------------------------------------
  -- get_workrequest_url - Get work request url
  -----------------------------------------------------------------------------
  FUNCTION get_workrequest_url(
        workrequest_url       IN  VARCHAR2,
        opc_work_request_id   IN  VARCHAR2
  ) RETURN VARCHAR2
  IS
    l_workrequest_url  VARCHAR2(M_VCSIZ_4K);
  BEGIN

    l_workrequest_url := workrequest_url;

    IF SUBSTR(l_workrequest_url, -1, 1) != '/' THEN
      l_workrequest_url := l_workrequest_url || '/';
    END IF;

    l_workrequest_url := l_workrequest_url || opc_work_request_id;

    RETURN l_workrequest_url;
  END;


  -----------------------------------------------------------------------------
  -- get_sync_workrequest_response - Get synchronous workrequest response
  -----------------------------------------------------------------------------
  FUNCTION get_sync_workrequest_response(
        credential_name   IN  VARCHAR2,
        status_url        IN  VARCHAR2,
        workrequest_id    IN  VARCHAR2,
        wait_for_states   IN  DBMS_CLOUD_TYPES.wait_for_states_t,
        timeout           IN  NUMBER
  ) RETURN DBMS_CLOUD_TYPES.resp
  IS
    l_resp              DBMS_CLOUD_TYPES.resp;
    l_resp_json         JSON_OBJECT_T;
    l_status            VARCHAR2(M_VCSIZ_4K);
    l_count             NUMBER := 1;
    l_sleep_time        NUMBER := MIN_WAIT_INTERVAL;
    l_elapsed_time      NUMBER := 0;
    l_wait_for_states   DBMS_CLOUD_TYPES.wait_for_states_t;
    l_valid_count       NUMBER := 0;
  BEGIN

    -- Convert input states to UPPER
    l_wait_for_states := DBMS_CLOUD_TYPES.wait_for_states_t();

    IF wait_for_states IS NOT NULL THEN
      FOR i in wait_for_states.FIRST .. wait_for_states.LAST
      LOOP
        IF NOT UPPER(wait_for_states(i)) MEMBER OF oci_wait_states THEN
          raise_application_error(-20000, 'Invalid value for wait_for_' ||
            'states. Valid values are - ACTIVE, CANCELED, COMPLETED, '  ||
            'DELETED, FAILED, SUCCEEDED');
        END IF;
        l_wait_for_states.extend;
        l_wait_for_states(l_wait_for_states.LAST) := UPPER(wait_for_states(i));
      END LOOP;
    ELSE
      FOR i in oci_wait_states.FIRST .. oci_wait_states.LAST
      LOOP
        l_wait_for_states.extend;
        l_wait_for_states(l_wait_for_states.LAST) := UPPER(oci_wait_states(i));
      END LOOP;
    END IF;

    LOOP
      -- Send request to get status
      l_resp := send_request(credential_name => credential_name,
                             uri             => status_url,
                             method          => METHOD_GET
                );
      l_resp_json := JSON_OBJECT_T(get_response_text(l_resp));
      l_status := UPPER(l_resp_json.get_string(OCI_WORKREQUEST_STATUS));

      EXIT WHEN l_status MEMBER OF l_wait_for_states;

      DBMS_SESSION.sleep(l_sleep_time);

      -- Check for timeout if specified
      IF timeout > 0 THEN
        l_elapsed_time := l_elapsed_time + l_sleep_time;
        IF l_elapsed_time > timeout THEN
          raise_application_error(-20000,
                'Operation exceeded timeout. Please check work request ' ||
                'id ' || workrequest_id);
        END IF;
      END IF;

      l_sleep_time := l_sleep_time * 2;
      IF l_sleep_time >= MAX_WAIT_INTERVAL THEN
        l_sleep_time := MIN_WAIT_INTERVAL;
      END IF;

    END LOOP;

    RETURN l_resp;
  END;


  -----------------------------------------------------------------------------
  -- check_reserved_cred_name - Check if credentials use reserved names
  -----------------------------------------------------------------------------
  FUNCTION check_reserved_cred_name(
        credential_name  IN  VARCHAR2
  ) RETURN BOOLEAN
  IS
    --
    -- NAME:
    --   check_reserved_cred_name - Check if the credential name is reserved
    --
    -- DESCRIPTION:
    --   This procedure checks if the credntial name is reserved.
    --
    -- PARAMETERS:
    --   credential_name    (IN)  - Credential name
    --
    -- NOTES:
    --   Added for bug 32011671.
    --
    l_credential_name   CLOB;
  BEGIN
    -- Bug 32306175: AWS ARN credential also cannot be modified by users.
    -- Bug 32925655: Trim whitespaces in credential name because enquote_name
    -- does not trim whitespaces and use INSTR
    -- Bug 33071156: GCP Principal Authentication credential cannot be modified
    -- by users.
    l_credential_name := DBMS_ASSERT.enquote_name(TRIM(credential_name));
    IF INSTR(l_credential_name, OCI_RPST_CRED) > 0 OR
       INSTR(l_credential_name, AWS_ARN_CRED) > 0 OR
       INSTR(l_credential_name, '"GCP$PA"') > 0
    THEN
      RETURN TRUE;
    END IF;

    RETURN FALSE;
  END;


  -----------------------------------------------------------------------------
  -- get_qualified_body_text - Validate and get qualified text body for cache
  -----------------------------------------------------------------------------
  FUNCTION get_qualified_body_text(
        headers JSON_OBJECT_T,
        body    BLOB
  ) RETURN CLOB
  IS
  BEGIN
    IF body IS NULL OR DBMS_LOB.getlength(body) = 0 THEN
      RETURN NULL;
    END IF;

    IF (NOT headers.has(HEADER_CONTENT_TYPE) OR
        INSTR(LOWER(headers.get_string(HEADER_CONTENT_TYPE)), 'xml') > 0 OR
        INSTR(LOWER(headers.get_string(HEADER_CONTENT_TYPE)), 'json') > 0 OR
        INSTR(LOWER(headers.get_string(HEADER_CONTENT_TYPE)), 'text') > 0)
        AND  DBMS_LOB.getlength(body) < M_VCSIZ_32K THEN
      -- Get response body as text
      RETURN TO_CLOB(body);
    END IF;

    RETURN NULL;

  END get_qualified_body_text;


  -----------------------------------------------------------------------------
  -- construct_insert_stmt_json - Construct Insert Stmt JSON
  -----------------------------------------------------------------------------
  FUNCTION construct_insert_stmt_json(
        source_table_name   IN          VARCHAR2,
        table_name          IN          VARCHAR2,
        schema_name         IN          VARCHAR2,
        column_path_array   IN          JSON_ARRAY_T,
        validation_select   OUT         CLOB
  ) RETURN CLOB
  IS
    --
    -- NAME:
    --   construct_insert_stmt_json - Construct Insert Statement for Copy Data
    --
    -- DESCRIPTION:
    --   This procedure describes the columns of the specified table and
    --   constructs the JSON_TABLE columns clause. The columns clause is then
    --   used to construct the final INSERT statement to do the actual work
    --   to copy the data from the source table on top of JSON documents.
    --
    -- PARAMETERS:
    --   source_table_name (IN)  - Source external table
    --
    --   table_name        (IN)  - Name of the database table
    --
    --   schema_name       (IN)  - Schema name owning the database table
    --
    --   column_path_array (IN)  - JSON paths of the columns
    --
    --   validation_select (OUT) - Select statement to validate JSON paths
    --
    --  RETURNS:
    --    Returns constructed insert statement
    --
    -- NOTES:
    --
    l_cur             INTEGER;
    l_ncols           INTEGER;
    l_desc            DBMS_SQL.desc_tab2;
    l_col_desc        VARCHAR2(M_VCSIZ_4K);
    l_vcol_desc       VARCHAR2(M_VCSIZ_4K);
    l_tmp_query       VARCHAR2(M_VCSIZ_4K);
    l_col_clause      CLOB;
    l_vcol_clause     CLOB;
    l_where_clause    CLOB;
    l_insert_stmt     CLOB;
    l_validation_sel  CLOB;
    TYPE json_columns_t IS TABLE OF DBMS_QUOTED_ID;
    l_json_columns    json_columns_t := json_columns_t();
  BEGIN

    -- Parse a dummy query on the base table so that we describe the columns
    -- to form the JSON_TABLE columns clause
    l_tmp_query := 'SELECT * FROM ' || schema_name || '.' || table_name ||
                     ' WHERE 1=2';
    l_cur := DBMS_SQL.open_cursor;
    DBMS_SQL.parse(l_cur, l_tmp_query, DBMS_SQL.native);
    DBMS_SQL.describe_columns2(l_cur, l_ncols, l_desc);
    DBMS_SQL.close_cursor(l_cur);

    -- Check if table column count match with that of the JSON path count
    IF l_ncols != column_path_array.get_size THEN
      raise_application_error(-20000,
             'Table column count does not match JSON path count');
    END IF;

    -- Bug 33298916: Get the JSON columns of the table from all_json_columns
    EXECUTE IMMEDIATE 'SELECT column_name FROM sys.all_json_columns ' ||
                      '  WHERE table_name=:1 AND owner=:2'
      BULK COLLECT INTO l_json_columns USING
        DBMS_CLOUD_CORE.unquote_name(table_name),
        DBMS_CLOUD_CORE.unquote_name(schema_name);

    -- Loop over the columns and construct the JSON_TABLE column clause
    FOR i in 1..l_ncols LOOP
      l_col_desc := l_desc(i).col_name || ' ' ||
      CASE l_desc(i).col_type
        WHEN 1 THEN
          'VARCHAR2(' || l_desc(i).col_max_len || ')'
        WHEN 2 THEN
          'NUMBER'
        WHEN 8 THEN
          'LONG'
        WHEN 9 THEN
          'VARCHAR(' || l_desc(i).col_max_len || ')'
        WHEN 12 THEN
          'DATE'
        WHEN 23 THEN
          'RAW(' || l_desc(i).col_max_len || ')'
        WHEN 69 THEN
          'ROWID'
        WHEN 96 THEN
          'CHAR(' || l_desc(i).col_max_len || ')'
        WHEN 100 THEN
          'BINARY_FLOAT'
        WHEN 101 THEN
          'BINARY_DOUBLE'
        -- Bug 33137492: Use FORMAT JSON for CLOB/BLOB
        WHEN 112 THEN
          'CLOB'
        WHEN 113 THEN
          'BLOB'
        WHEN 114 THEN
          'BFILE'
        WHEN 115 THEN
          'CFILE'
        WHEN 119 THEN
          'JSON'
        WHEN 178 THEN
          'TIME'
        WHEN 179 THEN
          'TIME WITH TIME ZONE'
        WHEN 180 THEN
          'TIMESTAMP'
        WHEN 181 THEN
          'TIMESTAMP WITH TIME ZONE'
        WHEN 231 THEN
          'TIMESTAMP WITH LOCAL TIME ZONE'
        WHEN 182 THEN
          'INTERVAL YEAR TO MONTH'
        WHEN 183 THEN
          'INTERVAL DAY TO SECOND'
        ELSE
          'ERROR'
      END;

      IF l_col_desc = l_desc(i).col_name || ' ERROR' THEN
        -- Raise an error for an unsupported column datatype
        raise_application_error(-20000, l_desc(i).col_name ||
          ' column in the table is not supported for JSON import');
      END IF;

      -- Bug 33298916: Add FORMAT JSON for JSON columns
      IF l_desc(i).col_name MEMBER OF l_json_columns THEN
        l_col_desc := l_col_desc || ' FORMAT JSON';
      END IF;

      IF LENGTH(l_col_clause) > 0 THEN
        l_col_clause := l_col_clause || ',';
      END IF;
      l_col_clause := l_col_clause || l_col_desc || ' path ''' ||
                      column_path_array.get_string(i-1) || '''';

      -- Construct the json_table columns clause for the json path
      -- validation select query
      IF LENGTH(l_vcol_clause) > 0 THEN
        l_vcol_clause := l_vcol_clause || ',';
      END IF;
      l_vcol_desc   := l_desc(i).col_name || ' NUMBER EXISTS ';
      l_vcol_clause := l_vcol_clause || l_vcol_desc || ' path ''' ||
                       column_path_array.get_string(i-1) || ''' ERROR ON ERROR';

      -- Construct the where clause for the json path validation
      -- select query
      IF LENGTH(l_where_clause) > 0 THEN
        l_where_clause := l_where_clause || ' and ';
      END IF;
      l_where_clause := l_where_clause || l_desc(i).col_name || '=1';

    END LOOP;

    -- Construct the select statement
    l_insert_stmt :=
      ' SELECT M.* FROM ' || source_table_name || ' p,' ||
      '   JSON_TABLE(p.json_document,' ||
      '              ''$'' columns (' || l_col_clause || ')) M';

    -- Construct the select to validate json path expressions
    l_validation_sel :=
        ' SELECT COUNT(1) FROM ' ||
        '   (SELECT M.* FROM ' || source_table_name || ' p,' ||
        '      JSON_TABLE(p.json_document, ''$'' ERROR ON ERROR ' ||
        '        columns (' || l_vcol_clause || ')) M ' ||
        '    WHERE ROWNUM < 2) ' ||
        ' WHERE ' || l_where_clause;

    validation_select := l_validation_sel;

    RETURN l_insert_stmt;

  END construct_insert_stmt_json;


  -----------------------------------------------------------------------------
  -- construct_insert_stmt - Construct Insert Stmt to Copy Data From Ext Table
  -----------------------------------------------------------------------------
  FUNCTION construct_insert_stmt(
        format_type         IN          VARCHAR2,
        source_table_name   IN          VARCHAR2,
        table_name          IN          VARCHAR2,
        schema_name         IN          VARCHAR2,
        column_path_array   IN          JSON_ARRAY_T,
        validation_select   OUT         CLOB
  ) RETURN CLOB
  IS
    --
    -- NAME:
    --   construct_insert_stmt - Construct Insert Statement for Copy Data
    --
    -- DESCRIPTION:
    --   This procedure constructs the insert statement to copy data from
    --   external table into the base table provided by the user.
    --
    -- PARAMETERS:
    --   format_type       (IN)  - Format type
    --
    --   source_table_name (IN)  - Source external table
    --
    --   table_name        (IN)  - Name of the database table
    --
    --   schema_name       (IN)  - Schema name owning the database table
    --
    --   column_path_array (IN)  - JSON paths of the columns
    --
    --   validation_select (OUT) - Select statement to validate JSON paths
    --
    --  RETURNS:
    --    Returns constructed insert statement
    --
    -- NOTES:
    --
    l_insert_stmt      CLOB;
    l_json_insert_stmt CLOB;
  BEGIN

    -- Use hints for Append and Enabling Parallel DML
    l_insert_stmt := 'INSERT /*+ append enable_parallel_dml */ INTO ' ||
                       schema_name || '.' || table_name;

    IF format_type = FORMAT_TYPE_JSON THEN

      -- Construct the insert statement for json format type
      l_json_insert_stmt := construct_insert_stmt_json(
                              source_table_name => source_table_name,
                              schema_name       => schema_name,
                              table_name        => table_name,
                              column_path_array => column_path_array,
                              validation_select => validation_select
                            );

      l_insert_stmt := l_insert_stmt || l_json_insert_stmt;

    ELSE

      -- Construct the insert statement for other format types
      l_insert_stmt := l_insert_stmt ||
        ' SELECT * FROM ' || source_table_name;

    END IF;

    RETURN l_insert_stmt;

  END construct_insert_stmt;


  -----------------------------------------------------------------------------
  -- Export Data Transform Query
  -----------------------------------------------------------------------------
  PROCEDURE export_data_xform_query(
    format_type     IN     VARCHAR2,
    row_size        IN     VARCHAR2,
    field_delimiter IN     VARCHAR2,
    trim_spaces     IN     VARCHAR2,
    quote           IN     VARCHAR2,
    end_quote       IN     VARCHAR2,
    escape          IN     BOOLEAN,
    query           IN OUT CLOB
  )
  IS
    --
    -- NAME:
    --   export_data_xform_query - Export Data Transform Query
    --
    -- DESCRIPTION:
    --   This procedure transforms the query if necessary.
    --   For JSON format type, it checks if the row produced by the query is
    --   in JSON format. If it is not, then the query is transformed to use
    --   JSON_OBJECT SQL function to produce rows in JSON format
    --
    -- PARAMETERS:
    --  format_type      (IN)     - format type eg: JSON, CSV, TXT, XML
    --
    --  row_size         (IN)     - row size eg: SMALL(VARCHAR2) or LARGE(CLOB)
    --
    --  field_delimiter  (IN)     - field delimiter for csv
    --
    --  quote            (IN)     - quote character for CSV
    --
    --  end_quote        (IN)     - end quote for CSV
    --
    --  escape           (IN)     - escape for CSV
    --
    --  query            (IN OUT) - SELECT query to fetch the data to export
    --
    -- RETURNS:
    --
    -- NOTES:
    --   Added by bug 32317812.
    --
    TYPE col_tab IS TABLE OF DBMS_ID;
    l_col_arr   col_tab;
    l_col_arr2  col_tab;
    l_query     CLOB;
    l_tmp_row   CLOB;
    l_xform     BOOLEAN := FALSE;
    l_json_obj  JSON_OBJECT_T;
    l_xml_obj   XMLTYPE;
    l_cur       INTEGER;
    l_res       INTEGER;
    l_ncols     INTEGER;
    l_desc      DBMS_SQL.desc_tab2;
    l_col_list  CLOB;
    l_field_sep DBMS_ID;
    l_trim_spec DBMS_ID;
    l_col_spec  VARCHAR2(M_VCSIZ_4K);
  BEGIN

    l_query := query;

    -- Find if the specified query produces a single column result
    BEGIN
      l_cur := DBMS_SQL.open_cursor;
      DBMS_SQL.parse(l_cur, l_query, DBMS_SQL.native);
      DBMS_SQL.describe_columns2(l_cur, l_ncols, l_desc);
      IF l_ncols != 1 THEN
        -- The query produces more than one column and hence the row
        -- cannot be in required export format.
        -- Transform the query to match the export format
        l_xform := TRUE;
      ELSE
        BEGIN
          DBMS_SQL.define_column(l_cur, 1, l_tmp_row);
          l_res := DBMS_SQL.execute(l_cur);
          IF DBMS_SQL.fetch_rows(l_cur) > 0 THEN
            -- Fetch one row and check if the row is in required export format
            DBMS_SQL.column_value(l_cur, 1, l_tmp_row);
            CASE format_type
              WHEN FORMAT_TYPE_JSON THEN
                l_json_obj := JSON_OBJECT_T.parse(l_tmp_row);
              WHEN FORMAT_TYPE_XML THEN
                l_xml_obj := XMLTYPE(l_tmp_row);
              WHEN FORMAT_TYPE_CSV THEN
                -- always transform csv data
                l_xform := TRUE;
              ELSE
                NULL;
            END CASE;
          END IF;
        EXCEPTION
          WHEN OTHERS THEN
            -- Exception raised during fetching the row into a CLOB variable
            -- or during parsing the fetched CLOB as a JSON object.
            -- Transform the query
            l_xform := TRUE;
        END;
      END IF;
      DBMS_SQL.close_cursor(l_cur);
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_SQL.close_cursor(l_cur);
    END;

    -- Transform the query if needed
    IF l_xform THEN

      --
      -- Check for duplicate column names
      --
      l_col_arr := col_tab();
      l_col_arr.EXTEND(l_ncols);
      FOR i IN 1..l_ncols LOOP
        -- Save the column name in associated array
        l_col_arr(i) := l_desc(i).col_name;
      END LOOP;
      l_col_arr2 := l_col_arr MULTISET INTERSECT DISTINCT l_col_arr;
      IF l_ncols != l_col_arr2.COUNT THEN
        -- Duplicate name found, print the list of duplicate column names
        l_res := l_col_arr2.FIRST;
        WHILE l_res IS NOT NULL LOOP
          l_col_list := l_col_list ||
                        DBMS_ASSERT.enquote_name(l_col_arr2(l_res)) || ', ';
          l_res := l_col_arr2.NEXT(l_res);
        END LOOP;
        raise_application_error(-20000,
                'Query contains duplicate column name - ' ||
                RTRIM(l_col_list, ','));
      END IF;

      CASE format_type
        -- JSON
        WHEN FORMAT_TYPE_JSON THEN
          IF row_size = 'SMALL' THEN
            l_query := 'SELECT JSON_OBJECT(* RETURNING VARCHAR2(32767)) ';
          ELSE
              l_query := 'SELECT JSON_OBJECT(* RETURNING CLOB) ';
          END IF;

        -- XML
        WHEN FORMAT_TYPE_XML THEN
          -- Create a csv list of double quoted column names
          FOR i IN 1..l_ncols LOOP
            l_col_list := l_col_list ||
                          DBMS_ASSERT.enquote_name(l_desc(i).col_name) || ',';
          END LOOP;
          --l_query := 'SELECT XMLELEMENT("RECORD", XMLFOREST(' || RTRIM(l_col_list, ',') || ')) ';
          l_query := 'SELECT XMLELEMENT("RECORD", XMLFOREST(' || RTRIM(l_col_list, ',') || ')).getclobval() '; --BY DarkAthena 20211207

        -- CSV
        WHEN FORMAT_TYPE_CSV THEN
          l_field_sep := ' || ''' || field_delimiter || ''' || ';

          -- Trim Spaces specification
          IF trim_spaces IS NOT NULL THEN
            CASE trim_spaces
              WHEN FORMAT_TRIM_LTRIM THEN
                l_trim_spec := 'LTRIM(';
              WHEN FORMAT_TRIM_RTRIM THEN
                l_trim_spec := 'RTRIM(';
              ELSE
                l_trim_spec := 'TRIM(';
            END CASE;
          END IF;

          FOR i IN 1..l_ncols LOOP
            -- Enquote column name
            l_col_spec := DBMS_ASSERT.enquote_name(l_desc(i).col_name);

            -- Add special formatting for string column
            IF l_desc(i).col_type IN
               (1,8,9,12,69,96,112,178,180,181,182,183,231)
            THEN
              -- Add Trim clause
              IF l_trim_spec IS NOT NULL THEN
                l_col_spec := l_trim_spec || l_col_spec || ')';
              END IF;

              IF quote IS NOT NULL THEN
                -- Add Escape
                --  * REPLACE(col, '\', '\\')
                --  * REPLACE(..., 'quote', '\quote')
                --  * REPLACE(..., 'endquote', '\endquote')
                IF escape IS NOT NULL THEN
                  l_col_spec := 'REPLACE(REPLACE(' || l_col_spec ||
                                ', ''\'', ''\\''), ''' || quote ||
                                ''', ''\' || quote || ''')';
                  IF end_quote IS NOT NULL THEN
                    l_col_spec := 'REPLACE(' || l_col_spec || ', ''' ||
                                  end_quote || ''', ''\' || end_quote || ''')';
                  END IF;
                END IF;

                -- Add Quote and End Quote
                l_col_spec := '''' || quote || ''' || ' || l_col_spec ||
                              ' || ''' || NVL(end_quote, quote) || '''';
              END IF;
            END IF;

            -- Add Field Delimiter at the end
            IF LENGTH(l_col_list) > 0 THEN
              l_col_list := l_col_list || l_field_sep || l_col_spec;
            ELSE
              l_col_list := l_col_spec;
            END IF;
          END LOOP;

          -- Construct the query, trim off field delimiter at the end
          l_query := 'SELECT ' || l_col_list || ' ';

        -- Other text formats
        ELSE
          -- Generic text formats do not support transforming the query
          raise_application_error(-20000,
                 'Query should contain only one column for ' || format_type ||
                 ' export');
      END CASE;

      -- Add the FROM clause
      l_query := l_query || 'FROM (' || query || ')';

    END IF;

    query := l_query;

  END export_data_xform_query;


  -----------------------------------------------------------------------------
  -- Get Export Data Format parameters
  -----------------------------------------------------------------------------
  PROCEDURE export_data_get_parameters(
    format           IN      JSON_OBJECT_T,
    format_type      OUT     VARCHAR2,
    file_base_uri    IN  OUT VARCHAR2,
    file_extension   OUT     VARCHAR2,
    compression      OUT     VARCHAR2,
    row_size         OUT     VARCHAR2,
    record_delimiter OUT     VARCHAR2,
    max_file_size    OUT     NUMBER,
    field_delimiter  OUT     VARCHAR2,
    trim_spaces      OUT     VARCHAR2,
    quote            OUT     VARCHAR2,
    end_quote        OUT     VARCHAR2,
    escape           OUT     BOOLEAN
  )
  IS
    --
    -- NAME:
    --   get_export_data_parameters - Get Export Data Format Parameters
    --
    -- DESCRIPTION:
    --   This procedure gets various format parameters from the formatting
    --   options passed in by the caller.
    --
    -- PARAMETERS:
    --  format           (IN)      - formatting options in JSON
    --
    --  format_type      (OUT)     - format type eg: JSON, CSV
    --
    --  file_base_uri    (IN OUT)  - file URI prefix
    --
    --  file_extension   (OUT)     - file extension based on format type
    --
    --  compression      (OUT)     - compression type e.g GZIP, AUTO
    --
    --  row_size         (OUT)     - row size e.g SMALL, LARGE
    --
    --  record_delimiter (OUT)     - record delimiter e.g NEWLINE
    --
    --  max_file_size    (OUT)     - max file size
    --
    --  field_delimiter  (OUT)     - field delimiter for CSV
    --
    --  quote            (OUT)     - quote character for CSV
    --
    --  end_quote        (OUT)     - end quote for CSV
    --
    --  escape           (OUT)     - escape for CSV
    --
    -- RETURNS:
    --
    -- NOTES:
    --   Added by bug 32317812.
    --
    l_format_obj        JSON_OBJECT_T;
    l_format_keys       JSON_KEY_LIST;
    l_format_key_list   format_key_list_t;
    l_key               DBMS_ID;
    l_key_lower         DBMS_ID;
    l_file_ext          DBMS_ID;
    l_compress_ext      DBMS_ID;
    l_format_type_int   DBMS_ID;

    --
    -- check_conflicting_key - Helper function to check conflicting param key
    --
    PROCEDURE check_conflicting_key(format_type IN VARCHAR2)
    IS
    BEGIN
      IF l_format_type_int IS NOT NULL AND
         l_format_type_int != format_type
      THEN
        RAISE conflicting_format_key;
      END IF;
      l_format_type_int := format_type;
    END check_conflicting_key;

  BEGIN

    -- Parse the format parameters JSON
    l_format_obj  := format;
    l_format_keys := l_format_obj.get_keys;

    -- If empty format JSON, then do not access the parameters
    IF l_format_keys IS NOT NULL THEN

      --
      -- Loop over all the Keys
      --
      FOR i IN 1..l_format_keys.COUNT  LOOP

        -- Validate the key length
        IF LENGTH(TRIM(l_format_keys(i))) > M_IDEN THEN
          RAISE invalid_format_key;
        END IF;

        -- Get current key and also store lower case key for comparison
        l_key       := TRIM(l_format_keys(i));
        l_key_lower := LOWER(l_key);

        -- Check for duplicate key
        IF l_format_key_list.EXISTS(l_key_lower) THEN
          RAISE duplicate_format_key;
        END IF;
        l_format_key_list(l_key_lower) := l_key;

        -- Process the key
        CASE l_key_lower

        -- TYPE (type)
        WHEN DBMS_CLOUD.FORMAT_TYPE THEN
          format_type := UPPER(get_json_string(l_format_obj, l_key));
          IF format_type NOT IN (FORMAT_TYPE_JSON,
                                 FORMAT_TYPE_TEXT,
                                 FORMAT_TYPE_CSV,
                                 FORMAT_TYPE_XML)
          THEN
            RAISE invalid_format_value;
          END IF;

          -- Check conflicting format parameter
          check_conflicting_key(format_type);

        -- COMPRESSION (compression)
        WHEN FORMAT_COMPRESSION THEN
          compression := UPPER(get_json_string(l_format_obj, l_key));
          IF compression IS NOT NULL THEN
            IF compression NOT IN (COMPRESS_AUTO, COMPRESS_GZIP)
            THEN
              RAISE invalid_format_value;
            END IF;

            l_compress_ext := '.gz';
          END IF;

        -- RECORD DELIMITER
        WHEN FORMAT_RECORD_DELIMITER THEN
          -- Allow record delimiter to be specified for export data
          record_delimiter := NVL(get_json_string(l_format_obj, l_key, FALSE),
                                  NEWLINE);

        -- ROWSIZE (rowsize)
        WHEN FORMAT_ROW_SIZE THEN
          row_size := NVL(UPPER(get_json_string(l_format_obj, l_key)),
                          FORMAT_ROW_LARGE);
          IF row_size NOT IN (FORMAT_ROW_SMALL, FORMAT_ROW_LARGE) THEN
            RAISE invalid_format_value;
          END IF;


        -- FILE_EXTENTION (fileextension)
        WHEN 'fileextension' THEN
          l_file_ext := get_json_string(l_format_obj, l_key);

        WHEN 'maxfilesize' THEN
          max_file_size := get_json_number(l_format_obj, l_key);
          IF max_file_size < EXPORT_MAX_FILE_SIZE THEN
            raise_application_error(-20000,
                'Max file size is too low for export - ' || max_file_size);
          END IF;

        -- DELIMITER (delimiter) - defaults to ','
        WHEN FORMAT_FIELD_DELIMITER THEN

          field_delimiter := get_json_string(l_format_obj, l_key);
          -- Handle WHITESPACE as field delimiter
          IF field_delimiter IS NOT NULL THEN
            -- Only allowed for CSV
            check_conflicting_key(FORMAT_TYPE_CSV);
            IF UPPER(field_delimiter) = FORMAT_DELIMITER_WHITESPACE THEN
              field_delimiter := ' ';
            END IF;
          END IF;

        -- TRIM_SPACES (trimspaces)
        WHEN FORMAT_TRIM_SPACES THEN
          trim_spaces := UPPER(get_json_string(l_format_obj, l_key));
          IF trim_spaces IS NOT NULL THEN
            -- Only allowed for CSV
            check_conflicting_key(FORMAT_TYPE_CSV);
            IF trim_spaces NOT IN (FORMAT_TRIM_RTRIM,
                                   FORMAT_TRIM_LTRIM,
                                   FORMAT_TRIM_NOTRIM,
                                   FORMAT_TRIM_LRTRIM)
            THEN
              RAISE invalid_format_value;
            END IF;
            -- Treat NOTRIM as null value
            IF trim_spaces = FORMAT_TRIM_NOTRIM THEN
              trim_spaces := NULL;
            END IF;
          END IF;

        -- QUOTE (quote)
        WHEN FORMAT_QUOTE THEN
          quote := get_json_string(l_format_obj, l_key);
          IF quote IS NOT NULL THEN
            -- Only allowed for CSV
            check_conflicting_key(FORMAT_TYPE_CSV);
            IF LENGTH(quote) > 1 THEN
              RAISE invalid_format_value;
            END IF;
          END IF;

        -- END QUOTE (endquote)
        WHEN FORMAT_END_QUOTE THEN
          end_quote := get_json_string(l_format_obj, l_key);
          IF end_quote IS NOT NULL THEN
            -- Only allowed for CSV
            check_conflicting_key(FORMAT_TYPE_CSV);
            IF LENGTH(end_quote) > 1 THEN
              RAISE invalid_format_value;
            END IF;
          END IF;

        -- ESCAPE (escape)
        WHEN FORMAT_ESCAPE THEN
          escape := get_json_boolean(l_format_obj, l_key);
          IF escape THEN
            -- Only allowed for CSV
            check_conflicting_key(FORMAT_TYPE_CSV);
          END IF;

        -- DEFAULT Case
        ELSE
          RAISE invalid_format_key;

        END CASE;

      END LOOP;

    END IF;


    --
    -- Validations
    --
    -- End quote is only allowed with quote
    IF quote IS NULL AND end_quote IS NOT NULL THEN
      raise_application_error(-20000,
          'Invalid format parameter: ' || FORMAT_END_QUOTE ||
          ' specified without' || FORMAT_QUOTE);
    END IF;

    --
    -- Add default values
    --
    -- If file extension is not specified, then use file type as extention
    IF l_file_ext IS NULL OR LOWER(l_file_ext) != 'none' THEN

      file_extension := l_file_ext;
      -- For TEXT format, do not use default file extension
      IF file_extension IS NULL AND format_type != FORMAT_TYPE_TEXT THEN
        file_extension := LOWER(format_type);
      END IF;

      -- Check if extension begins with a dot (.)
      IF SUBSTR(file_extension, 1, 1) != '.' THEN
        file_extension := '.' || file_extension;
      END IF;

      -- Add extension for compressed files
      IF l_compress_ext IS NOT NULL AND
         (file_extension IS NULL OR SUBSTR(file_extension, -3) != '.gz')
      THEN
        file_extension := file_extension || '.gz';
      END IF;
    END IF;

    -- Default max file size
    IF max_file_size IS NULL THEN
      max_file_size := EXPORT_MAX_FILE_SIZE;
    END IF;

    -- Default record delimiter
    IF record_delimiter IS NULL THEN
      record_delimiter := NEWLINE;
    END IF;

    -- Default field delimiter
    IF field_delimiter IS NULL THEN
      field_delimiter := FORMAT_DFLT_CSV_FIELD_DELIMITER;
    END IF;

  EXCEPTION
    WHEN invalid_format_key THEN
      raise_application_error(-20000,
             'Invalid format parameter: Unrecognized parameter ' || l_key);

    WHEN invalid_format_value THEN
      raise_application_error(-20000,
             'Invalid format parameter: Bad value for ' || l_key);

    WHEN duplicate_format_key THEN
      raise_application_error(-20000,
             'Invalid format parameter: Duplicate parameter ' || l_key);

    WHEN conflicting_format_key THEN
      raise_application_error(-20000,
             'Conflicting format parameter for ' ||
             NVL(l_format_type_int, format_type) || ' format - ' || l_key);
  END export_data_get_parameters;


  -----------------------------------------------------------------------------
  -- Export Data from Parallel Enable Pipelined Table Function
  -----------------------------------------------------------------------------
  PROCEDURE export_data_text(
    credential_name IN         VARCHAR2 DEFAULT NULL,
    file_uri_list   IN         CLOB,
    query           IN         CLOB,
    format          IN         JSON_OBJECT_T,
    payload         IN OUT     JSON_OBJECT_T,
    operation_id    OUT NOCOPY NUMBER
  )
  IS
    -- export_data_text - Export Data In Text formats
    --
    -- DESCRIPTION:
    --   This procedure is used to export data from Oracle Database using
    --   parallel enable pipelined table function to the object store
    --
    -- PARAMETERS:
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   file_uri_list   (IN)  - URI(s) of the file(s) existing in Object Store
    --
    --   query           (IN)  - SELECT query to fetch the data to export
    --
    --   format          (IN)  - Additional data formatting options (optional)
    --                           in JSON format.
    --
    --   payload         (IN OUT) - Custom task payload
    --
    --   operation_id    (OUT) - Operation ID in USER_LOAD_OPERATIONS view
    --
    l_query             CLOB;
    l_tab_query         CLOB;
    l_rowcount          NUMBER;
    l_context           JSON_OBJECT_T;
    l_format_type       DBMS_ID;
    l_file_ext          DBMS_ID;
    l_compression       DBMS_ID;
    l_row_size          DBMS_ID;
    l_record_delimiter  DBMS_ID;
    l_field_delimiter   DBMS_ID;
    l_trim_spaces       DBMS_ID;
    l_quote             DBMS_ID;
    l_end_quote         DBMS_ID;
    l_escape            BOOLEAN;
    l_max_file_size     NUMBER;
    l_file_uri          VARCHAR2(M_VCSIZ_4K);
    l_credential_name   DBMS_QUOTED_ID;
    l_base_credowner    DBMS_QUOTED_ID;
    l_base_credname     DBMS_QUOTED_ID;
    l_string_list       SYS.ODCIVARCHAR2LIST;
  BEGIN

    l_file_uri := file_uri_list;
    l_query    := query;

    -- Bug 33126100: Check for null file_uri_list
    IF file_uri_list IS NULL THEN
      raise_application_error(EXCP_INVALID_OBJ_URI,
          'Missing file uri list');
    END IF;

    -- Bug 33126140: process file_uri_list and make sure that only one
    -- file uri is provided.
    l_string_list  := DBMS_CLOUD_INTERNAL.convert_comma_str2strlist(
                        p_comma_string => file_uri_list,
                        p_item_string  => 'Uri',
                        p_max_length   => M_VCSIZ_4K);

    IF l_string_list.COUNT > 1 THEN
      raise_application_error(-20000,
          'Multiple files cannot be provided when exporting data in ' ||
          'JSON format');
    END IF;

    -- Bug 32516731: Validate the credential including resolving the synonym
    l_credential_name := validate_credential_name(
                               credential_name => credential_name,
                               base_cred_owner => l_base_credowner,
                               base_cred_name  => l_base_credname
                         );

    -- Get export data parameters
    export_data_get_parameters(format           => format,
                               format_type      => l_format_type,
                               file_base_uri    => l_file_uri,
                               file_extension   => l_file_ext,
                               compression      => l_compression,
                               row_size         => l_row_size,
                               record_delimiter => l_record_delimiter,
                               max_file_size    => l_max_file_size,
                               field_delimiter  => l_field_delimiter,
                               trim_spaces      => l_trim_spaces,
                               quote            => l_quote,
                               end_quote        => l_end_quote,
                               escape           => l_escape
    );

    -- Transform the query if needed
    export_data_xform_query(format_type     => l_format_type,
                            row_size        => l_row_size,
                            field_delimiter => l_field_delimiter,
                            trim_spaces     => l_trim_spaces,
                            quote           => l_quote,
                            end_quote       => l_end_quote,
                            escape          => l_escape,
                            query           => l_query);

    -- Create a task with payload information about the load operation
    payload := JSON_OBJECT_T('{}');
    payload.put('FileUriList', SUBSTR(file_uri_list, 0, M_VCSIZ_4K));
    IF credential_name IS NOT NULL THEN
      payload.put('CredentialName',
                  DBMS_CLOUD_CORE.unquote_name(credential_name));
    END IF;
    operation_id := DBMS_CLOUD_TASK.create_task(
                        class_name => TASK_CLASS_EXPORT,
                        userid     => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
                        status     => DBMS_CLOUD_TASK.TASK_STATUS_RUNNING,
                        payload    => payload.to_clob);

    l_context := JSON_OBJECT_T.parse('{}');
    l_context.put('invoker_schema', NVL(l_base_credowner, get_current_user()));
    l_context.put('credential_name', NVL(l_base_credname,  l_credential_name));
    l_context.put('file_uri', l_file_uri);
    l_context.put('fileextension', l_file_ext);
    l_context.put('maxfilesize', l_max_file_size);
    l_context.put(FORMAT_COMPRESSION, l_compression);
    l_context.put(FORMAT_RECORD_DELIMITER, l_record_delimiter);


    -- Execute the parallel enable pipeline table function to produce JSON
    -- rows in parallel
    l_tab_query := 'SELECT COUNT(*) FROM TABLE(' ||
      'DBMS_CLOUD.export_rows_tabfunc(CURSOR(' || l_query || '), :1))';

    BEGIN
      EXECUTE IMMEDIATE l_tab_query INTO l_rowcount
        USING l_context.to_string;
    EXCEPTION
      -- The table function doesn't pipe any rows back. Supress no_data_found
      WHEN NO_DATA_FOUND THEN NULL;
    END;

    -- Save the number of rows exported in the task payload
    IF l_rowcount IS NOT NULL THEN
      payload.put('RowsLoaded', l_rowcount);
    END IF;

    -- Mark the task as COMPLETED
    DBMS_CLOUD_TASK.update_task(
        id      => operation_id,
        userid  => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
        status  => DBMS_CLOUD_TASK.TASK_STATUS_COMPLETED,
        payload => payload.to_clob
    );

  EXCEPTION
    WHEN OTHERS THEN
      -- Mark the task as COMPLETED
      IF operation_id IS NOT NULL THEN
        DBMS_CLOUD_TASK.update_task(
            id      => operation_id,
            userid  => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
            status  => DBMS_CLOUD_TASK.TASK_STATUS_FAILED,
            payload => payload.to_clob
        );
      END IF;
      RAISE;
  END export_data_text;


  -----------------------------------------------------------------------------
  -- Export Data from Oracle Database to Object Store using Oracle Loader
  -----------------------------------------------------------------------------
  PROCEDURE export_data_datapump(
    credential_name IN         VARCHAR2 DEFAULT NULL,
    file_uri_list   IN         CLOB,
    query           IN         CLOB,
    format          IN         CLOB,
    payload         IN OUT     JSON_OBJECT_T,
    operation_id    OUT NOCOPY NUMBER
  )
  IS
    -- export_data_datapump - Export Data In Datapump format
    --
    -- DESCRIPTION:
    --   This procedure is used to export data from Oracle Database using
    --   Oracle Loader in Datapump format
    --
    -- PARAMETERS:
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           be created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   file_uri_list   (IN)  - URI(s) of the file(s) existing in Object Store
    --
    --   query           (IN)  - SELECT query to fetch the data to export
    --
    --   format          (IN)  - Additional data formatting options (optional)
    --                           in JSON format.
    --
    --   operation_id    (OUT) - Operation ID in USER_LOAD_OPERATIONS view
    --
    --   payload      (IN OUT) - Custom task payload
    --
    -- Declare locals
    l_temp_table_name      DBMS_ID;
    TEMP_EXTTAB_SUFFIX_LEN CONSTANT PLS_INTEGER := 20;
  BEGIN

    --  Create a temporary table name for the export external table
    l_temp_table_name := TEMP_EXTTAB_PREFIX ||
                         generate_random_name(TEMP_EXTTAB_SUFFIX_LEN);

    -- Setup a task and create external table with the export query.
    -- Creation of the external table will also export the data to object store
    copy_task_begin(
        temp_table_name     => l_temp_table_name,
        credential_name     => credential_name,
        file_uri_list       => file_uri_list,
        format              => format,
        parent_operation    => EXPORT_DATA_OPER,
        export_query        => query,
        operation_id        => operation_id,
        payload             => payload
    );

    -- Clean up and mark the task as COMPLETED
    copy_task_end(
      temp_table_name     => l_temp_table_name,
      parent_operation    => EXPORT_DATA_OPER,
      operation_id        => operation_id,
      payload             => payload,
      status              => DBMS_CLOUD_TASK.TASK_STATUS_COMPLETED,
      error_code          => 0
    );

  END export_data_datapump;


  -----------------------------------------------------------------------------
  -- ICD call to fetch the rows from refcursor and upload to object store
  -----------------------------------------------------------------------------
  PROCEDURE export_rows_icd(
    ref_cursor        IN SYS_REFCURSOR,
    credential_name   IN VARCHAR2,
    invoker_schema    IN VARCHAR2,
    file_uri          IN VARCHAR2,
    compression       IN VARCHAR2,
    record_delimiter  IN VARCHAR2,
    file_extension    IN VARCHAR2,
    max_buffer_len    IN NUMBER,
    rows_per_fetch    IN NUMBER,
    compression_ratio IN NUMBER
  )
  IS
    --
    -- NAME:
    --   export_rows_icd - Export Rows ICD
    --
    -- DESCRIPTION:
    --   This procedure calls an ICD that accepts ref cursor as an input,
    --   fetches the rows from it to construct a fixed size chunk in PGA
    --   buffer and then uploads the chunk to the object store
    --
    -- PARAMETERS:
    --   ref_cursor        (IN)  - ref cursor from which to fetch the rows from
    --
    --   credential_name   (IN)  - Credential object name to authenticate with
    --                             Object Store. The credential object must be
    --                             created using DBMS_CLOUD.CREATE_CREDENTIAL.
    --
    --   invoker_schema    (IN)  - Invoker schema
    --
    --   file_uri          (IN)  - file uri specified by the user
    --
    --   compression       (IN)  - compression scheme
    --
    --   record_delimiter  (IN)  - record delimiter
    --
    --   file_extension    (IN)  - file extension
    --
    --   max_buffer_len    (IN)  - maximum size of the PGA buffer (chunk size)
    --
    --   rows_per_fetch    (IN)  - rows per fetch (batchsize)
    --
    --   compression_ratio (IN)  - compression ratio
    --
    LANGUAGE C
    LIBRARY sys.dbms_pdb_lib
    NAME "kpdbocExportRows" WITH CONTEXT
    PARAMETERS (CONTEXT,
                ref_cursor        OCIREFCURSOR,
                credential_name   OCISTRING, credential_name  INDICATOR SB2,
                invoker_schema    OCISTRING, invoker_schema   INDICATOR SB2,
                file_uri          OCISTRING, file_uri         INDICATOR SB2,
                compression       OCISTRING, compression      INDICATOR SB2,
                record_delimiter  OCISTRING, record_delimiter INDICATOR SB2,
                file_extension    OCISTRING, file_extension   INDICATOR SB2,
                max_buffer_len    OCINUMBER, rows_per_fetch   OCINUMBER,
                compression_ratio OCINUMBER);


  -----------------------------------------------------------------------------
  -- log_export_op - Log Export Operation
  -----------------------------------------------------------------------------
  PROCEDURE log_export_op(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        file_uri_list    IN  CLOB,
        format_type      IN  VARCHAR2
  )
  IS
    --
    -- NAME:
    --   log_export_op - Log Export Operation
    --
    -- DESCRIPTION:
    --   This procedure logs information related to export_data
    --   operation.
    --
    -- PARAMETERS:
    --   invoker_schema  (IN) - invoker schema name
    --   credential_name (IN) - credential name
    --   file_uri_list   (IN) - List of file uris to export data to
    --   format_type     (IN) - format type to export data (e.g DATAPUMP, JSON)
    --
    -- NOTES:
    --
    l_log_json_obj       JSON_OBJECT_T;
  BEGIN

    -- Initialize logging variables
    l_log_json_obj  := JSON_OBJECT_T('{}');
    l_log_json_obj.put('operation', 'export_data');
    l_log_json_obj.put('invoker_schema', invoker_schema);
    l_log_json_obj.put('credential_name', NVL(credential_name, ''));
    l_log_json_obj.put('file_uri_list', SUBSTR(file_uri_list, 0, M_VCSIZ_4K));
    l_log_json_obj.put('format_type', format_type);
    DBMS_CLOUD_INTERNAL.log_common(l_log_json_obj);
    DBMS_CLOUD_INTERNAL.log_msg(l_log_json_obj.to_clob());

  END log_export_op;


  -----------------------------------------------------------------------------
  --                   PUBLIC FUNCTION/PROCEDURE DEFINITIONS
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- create_credential  - Create a Credential object to access any Object Store
  -----------------------------------------------------------------------------
  PROCEDURE create_credential(
        credential_name  IN  VARCHAR2,
        username         IN  VARCHAR2,
        password         IN  VARCHAR2   DEFAULT NULL
  )
  IS
  BEGIN

    -- Bug 32011671: Resource principal credential cannot be modified by users
    IF check_reserved_cred_name(credential_name) THEN
      raise_application_error(EXCP_INVALID_CRED,
          'Credential name is reserved.');
    END IF;

    DBMS_CLOUD_INTERNAL.create_credential(
        credential_name => credential_name,
        username        => username,
        password        => password,
        invoker_schema  => get_current_user()
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END create_credential;


  -----------------------------------------------------------------------------
  -- create_credential  - Create a Credential object to access BMC Object Store
  -----------------------------------------------------------------------------
  PROCEDURE create_credential(
        credential_name  IN  VARCHAR2,
        user_ocid        IN  VARCHAR2 DEFAULT NULL,
        tenancy_ocid     IN  VARCHAR2 DEFAULT NULL,
        private_key      IN  VARCHAR2,
        fingerprint      IN  VARCHAR2 DEFAULT NULL,
        rpst             IN  VARCHAR2 DEFAULT NULL
  )
  IS
  BEGIN

    -- Bug 32011671: Resource principal credential cannot be modified by users
    IF check_reserved_cred_name(credential_name) THEN
      raise_application_error(EXCP_INVALID_CRED,
          'Credential name is reserved.');
    END IF;

    DBMS_CLOUD_INTERNAL.create_credential(
        credential_name => credential_name,
        user_ocid       => user_ocid,
        tenancy_ocid    => tenancy_ocid,
        private_key     => private_key,
        fingerprint     => fingerprint,
        passphrase      => NULL,
        rpst            => rpst,
        invoker_schema  => get_current_user()
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END create_credential;


  -----------------------------------------------------------------------------
  -- create_credential - Create a Credential object using credential parameters
  -----------------------------------------------------------------------------
  PROCEDURE create_credential(
        credential_name       IN  VARCHAR2,
        params                IN  CLOB DEFAULT NULL
  )
  IS
    l_params_obj        JSON_OBJECT_T;
  BEGIN

    IF check_reserved_cred_name(credential_name) THEN
      raise_application_error(EXCP_INVALID_CRED,
          'Credential name is reserved.');
    END IF;

    BEGIN
      l_params_obj := parse_json_parameters(params);

    EXCEPTION
      WHEN OTHERS THEN
        -- Raise any parsing errors
        raise_application_error(-20041,
                'Params argument is not a valid JSON');
    END;

    IF l_params_obj IS NOT NULL AND
       l_params_obj.get_string(PARAM_AWS_ROLE_ARN) IS NOT NULL AND
       LENGTH(TRIM(l_params_obj.get_string(PARAM_AWS_ROLE_ARN))) > 0 THEN

      -- Check whether AWS ARN is enabled for the current user.
      check_create_credential_privilege(credential_name => AWS_ARN_CRED,
                                        credential_type => AWS_ARN);

      DBMS_CLOUD_INTERNAL.create_credential(
          invoker_schema  => get_current_user(),
          credential_name => credential_name,
          params          => params
      );
    ELSE
      raise_application_error(-20041,
                'Missing aws_role_arn in signature params');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END create_credential;


  -----------------------------------------------------------------------------
  -- drop_credential  - Drop a Credential object to access any Object Store
  -----------------------------------------------------------------------------
  PROCEDURE drop_credential(
        credential_name  IN  VARCHAR2
  )
  IS
  BEGIN

    -- Bug 32011671: Resource principal credential cannot be modified by users
    IF check_reserved_cred_name(credential_name) THEN
      raise_application_error(EXCP_INVALID_CRED,
          'Reserved credential cannot be dropped.');
    END IF;

    DBMS_CLOUD_INTERNAL.drop_credential(
        invoker_schema  => get_current_user(),
        credential_name => credential_name
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END drop_credential;


  -----------------------------------------------------------------------------
  -- enable_credential - Enable a Credential object to access any Object Store
  -----------------------------------------------------------------------------
  PROCEDURE enable_credential(
        credential_name  IN  VARCHAR2
  )
  IS
  BEGIN

    -- Bug 32011671: Resource principal credential cannot be modified by users
    IF check_reserved_cred_name(credential_name) THEN
      raise_application_error(EXCP_INVALID_CRED,
          'Reserved credential cannot be altered.');
    END IF;

    DBMS_CLOUD_INTERNAL.enable_credential(
        invoker_schema  => get_current_user(),
        credential_name => credential_name
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END enable_credential;


  -----------------------------------------------------------------------------
  -- disable_credential - Disable a Credential object to access Object Store
  -----------------------------------------------------------------------------
  PROCEDURE disable_credential(
        credential_name  IN  VARCHAR2
  )
  IS
  BEGIN

    -- Bug 32011671: Resource principal credential cannot be modified by users
    IF check_reserved_cred_name(credential_name) THEN
      raise_application_error(EXCP_INVALID_CRED,
          'Reserved credential cannot be altered.');
    END IF;

    DBMS_CLOUD_INTERNAL.disable_credential(
        invoker_schema  => get_current_user(),
        credential_name => credential_name
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END disable_credential;


  -----------------------------------------------------------------------------
  -- update_credential - Update a Credential object to access Object Store
  -----------------------------------------------------------------------------
  PROCEDURE update_credential(
        credential_name  IN  VARCHAR2,
        attribute        IN  VARCHAR2,
        value            IN  VARCHAR2
  )
  IS
    l_attribute    DBMS_ID;
  BEGIN

    -- Bug 32011671: Resource principal credential cannot be modified by users
    IF check_reserved_cred_name(credential_name) THEN
      raise_application_error(EXCP_INVALID_CRED,
          'Reserved credential cannot be altered.');
    END IF;

    -- Bug 32957766: Check whether AWS ARN is enabled for the current user if
    -- it is an aws arn attribute.
    l_attribute := LOWER(TRIM(attribute));
    IF l_attribute = PARAM_AWS_ROLE_ARN OR
       l_attribute = PARAM_EXTERNAL_ID_TYPE THEN
      check_create_credential_privilege(credential_name => AWS_ARN_CRED,
                                        credential_type => AWS_ARN);
    END IF;

    DBMS_CLOUD_INTERNAL.update_credential(
        invoker_schema  => get_current_user(),
        credential_name => credential_name,
        attribute       => attribute,
        value           => value
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END update_credential;


  -----------------------------------------------------------------------------
  -- create_external_table - Create External Table for a file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE create_external_table(
        table_name          IN  VARCHAR2,
        credential_name     IN  VARCHAR2 DEFAULT NULL,
        file_uri_list       IN  CLOB,
        column_list         IN  CLOB     DEFAULT NULL,
        field_list          IN  CLOB     DEFAULT NULL,
        format              IN  CLOB     DEFAULT NULL
  )
  IS
  BEGIN

    create_external_table_int(
        table_name          => table_name,
        credential_name     => credential_name,
        file_uri_list       => file_uri_list,
        column_list         => column_list,
        field_list          => field_list,
        format              => format,
        log_dir             => DBMS_CLOUD_CORE.DEFAULT_LOG_DIR
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END create_external_table;


  -----------------------------------------------------------------------------
  -- create_external_part_table - Create External Partitioned Table on file
  --                              in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE create_external_part_table(
        table_name          IN  VARCHAR2,
        credential_name     IN  VARCHAR2 DEFAULT NULL,
        partitioning_clause IN  CLOB,
        column_list         IN  CLOB     DEFAULT NULL,
        field_list          IN  CLOB     DEFAULT NULL,
        format              IN  CLOB     DEFAULT NULL
  )
  IS
  BEGIN

    create_external_table_int(
        table_name          => table_name,
        credential_name     => credential_name,
        partitioning_clause => partitioning_clause,
        column_list         => column_list,
        field_list          => field_list,
        format              => format,
        part_table          => TRUE,
        log_dir             => DBMS_CLOUD_CORE.DEFAULT_LOG_DIR
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END create_external_part_table;


  ------------------------------------------------------------------------------
  -- create_external_part_table - Create External Partitioned Table on file
  --                              in Object Store (overloaded version)
  ------------------------------------------------------------------------------
  PROCEDURE create_external_part_table(
        table_name          IN  VARCHAR2,
        credential_name     IN  VARCHAR2 DEFAULT NULL,
        partitioning_clause IN  CLOB     DEFAULT NULL,
        file_uri_list       IN  CLOB     DEFAULT NULL,
        column_list         IN  CLOB     DEFAULT NULL,
        field_list          IN  CLOB     DEFAULT NULL,
        format              IN  CLOB     DEFAULT NULL
  )
  IS
  BEGIN

    create_external_table_int(
        table_name          => table_name,
        credential_name     => credential_name,
        partitioning_clause => partitioning_clause,
        file_uri_list       => file_uri_list,
        column_list         => column_list,
        field_list          => field_list,
        format              => format,
        part_table          => TRUE,
        log_dir             => DBMS_CLOUD_CORE.DEFAULT_LOG_DIR
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END create_external_part_table;


  -----------------------------------------------------------------------------
  -- sync_external_part_table - Sync External Partitioned Table on file
  --                            in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE sync_external_part_table(
        table_name          IN  VARCHAR2,
        schema_name         IN  VARCHAR2 DEFAULT NULL,
        update_columns      IN  BOOLEAN  DEFAULT FALSE
  )
  IS
    -- Use autonomous transaction
    PRAGMA AUTONOMOUS_TRANSACTION;

    -- Declare locals
    NEWLINE                 CONSTANT CHAR(1) := CHR(10);
    COMMA                   CONSTANT CHAR(1) := ',';
    SINGLE_QUOTE            CONSTANT CHAR(1) := '''';
    DOUBLE_QUOTE            CONSTANT CHAR(1) := '"';
    DOT_SIGN                CONSTANT CHAR(1) := '.';
    UNDERSCORE_SIGN         CONSTANT CHAR(1) := '_';
    l_schema_name           DBMS_QUOTED_ID;
    l_schema_name_unquoted  DBMS_QUOTED_ID;
    l_table_name            DBMS_QUOTED_ID;
    l_table_name_unquoted   DBMS_QUOTED_ID;
    l_table_name_qualified  VARCHAR2(M_QUAL_IDEN);
    l_credential_name       DBMS_QUOTED_ID;
    l_credential_schema     DBMS_QUOTED_ID;
    l_column_list           CLOB;
    l_column_list_old       CLOB;
    l_tmpstr                CLOB;
    l_tmpstr2               CLOB;
    l_file_uri              CLOB;
    l_file_uri_list         CLOB;
    l_file                  CLOB;
    l_file_type             CLOB;
    l_format                CLOB;
    l_partition_array       JSON_ARRAY_T := NULL;
    l_column_array          JSON_ARRAY_T;
    l_p_columns_array       JSON_ARRAY_T;
    l_format_obj            JSON_OBJECT_T;
    l_partitioning_clause   CLOB;
    l_sqlstmt               CLOB;
    l_cnt_old               NUMBER;
    l_cnt_new               NUMBER;
    l_date_timestamp        BOOLEAN;
    l_out_of_sync           BOOLEAN;
    l_prefix                DBMS_ID;
    l_file_columns          DBMS_ID;
    l_cred_schema           DBMS_ID;
    l_cred_name             DBMS_ID;

  BEGIN

    --
    -- Validate input and check privilege
    --
    l_table_name  := validate_table_name(table_name);
    l_schema_name := validate_schema_name(schema_name);
    check_table_privilege(schema_name => l_schema_name,
                          table_name  => l_table_name);
    l_table_name_unquoted := DBMS_CLOUD_CORE.unquote_name(l_table_name);
    l_schema_name_unquoted := DBMS_CLOUD_CORE.unquote_name(l_schema_name);
    l_table_name_qualified := DBMS_CLOUD_CORE.get_qualified_name(l_table_name,
      l_schema_name);

    --
    -- 1. Get access parameters from all_external_tables
    --
    l_sqlstmt :=
     'SELECT access_parameters
      FROM SYS.ALL_EXTERNAL_TABLES
      WHERE owner = :1
      AND table_name = :2';
    EXECUTE IMMEDIATE l_sqlstmt INTO l_tmpstr USING l_schema_name_unquoted,
      l_table_name_unquoted;

    IF INSTR(l_tmpstr, FORMAT_BD_PREFIX) = 0 THEN
      l_prefix := NULL;
      l_file_columns := REPLACE(FORMAT_BD_FILENAME_CL, DOT_SIGN,
        UNDERSCORE_SIGN);
      l_cred_schema := REPLACE(FORMAT_BD_CRED_SCHEMA, DOT_SIGN,
        UNDERSCORE_SIGN);
      l_cred_name := REPLACE(FORMAT_BD_CRED_NAME, DOT_SIGN, UNDERSCORE_SIGN);
    ELSE
      l_prefix := FORMAT_BD_PREFIX;
      l_file_columns := FORMAT_BD_FILENAME_CL;
      l_cred_schema := FORMAT_BD_CRED_SCHEMA;
      l_cred_name := FORMAT_BD_CRED_NAME;
    END IF;

    --
    -- 2. Retrieve com.oracle.bigdata.file_uri_list from access parameter
    --
    l_file_uri_list := REGEXP_SUBSTR(l_tmpstr,
      l_prefix || FORMAT_FILE_URI_LIST || '=".*"');
    IF l_file_uri_list IS NULL THEN
      raise_application_error(EXCP_INVALID_OBJ_URI,
          'Missing file uri list');
    END IF;

    --
    -- 3. Retrieve file_uri_list from com.oracle.bigdata.file_uri_list.
    --
    IF l_prefix is NOT NULL THEN
      l_cnt_old := LENGTH(l_prefix) + LENGTH(FORMAT_FILE_URI_LIST) + 2;
    ELSE
      l_cnt_old := LENGTH(FORMAT_FILE_URI_LIST) + 2;
    END IF;
    l_cnt_new := LENGTH(l_file_uri_list) - l_cnt_old;
    l_file_uri_list := SUBSTR(l_file_uri_list, l_cnt_old, l_cnt_new);
    l_file_uri_list := TRIM(DOUBLE_QUOTE FROM l_file_uri_list);

    --
    -- 4. Retrieve file and file type from file_uri.
    --
    l_file_uri := TRIM(REGEXP_SUBSTR(l_file_uri_list, '[^,]+', 1, 1));
    l_file := REGEXP_SUBSTR(l_file_uri, '[^\/]+$');
    l_file_type := REGEXP_SUBSTR(l_file, '[^\.]\w+$');

    --
    -- 5. Retrieve partition columns from access parameter
    --
    l_tmpstr2 := REGEXP_SUBSTR(l_tmpstr,
      l_prefix || l_file_columns || '=.*');
    l_tmpstr2 := TRIM(REGEXP_SUBSTR(l_tmpstr2, '[^=]+$'));
    IF l_prefix is NULL THEN
      l_tmpstr2 := REPLACE(l_tmpstr2, DOUBLE_QUOTE);
      l_tmpstr2 := REPLACE(l_tmpstr2, SINGLE_QUOTE, DOUBLE_QUOTE);
    END IF;

    -- process comma delimited string
    l_p_columns_array := JSON_ARRAY_T(l_tmpstr2);
    l_format := '{"type":"' || l_file_type || '","partition_columns":' ||
      LOWER(l_tmpstr2) || '}';
    l_format_obj := parse_format_parameters(format => l_format);

    --
    -- 6. Retrieve credential name and schema from the access parameter
    --
    l_tmpstr2 := REGEXP_SUBSTR(l_tmpstr,
      l_prefix || l_cred_name || '=.*');
    l_credential_name := TRIM(REGEXP_SUBSTR(l_tmpstr2, '[^=]+$'));
    l_tmpstr2 := REGEXP_SUBSTR(l_tmpstr,
      l_prefix || l_cred_schema || '=.*');
    l_credential_schema := TRIM(REGEXP_SUBSTR(l_tmpstr2, '[^=]+$'));

    --
    -- 7. Generate a column list and a json array from the column list.
    --
    l_tmpstr := NULL;
    l_sqlstmt :=
     'BEGIN
      FOR rec IN
      (
        SELECT column_name, data_type||''(''||data_length||'')'' datatype
        FROM SYS.ALL_TAB_COLUMNS
        WHERE owner = :1
        AND table_name = :2
      )
      LOOP
        :3 := :3 || DBMS_ASSERT.enquote_name(rec.column_name, FALSE) || '' '' ||
                    DBMS_ASSERT.enquote_name(rec.datatype, FALSE) || '','';
      END LOOP;
      END;';
    EXECUTE IMMEDIATE l_sqlstmt USING IN l_schema_name_unquoted,
                                      IN l_table_name_unquoted,
                                      IN OUT l_tmpstr;
    l_column_list := LOWER(RTRIM(l_tmpstr, COMMA));
    l_column_array := JSON_ARRAY_T('[' || REPLACE(l_column_list, '" "', ' ') ||
      ']');
    l_column_list_old := REPLACE(l_column_list, DOUBLE_QUOTE);

    --
    -- 8. Call generate_partitioning_clause to generate a partitioning clause.
    --
    l_partitioning_clause :=
    DBMS_CLOUD_INTERNAL.generate_partitioning_clause(
        invoker_schema      => l_credential_schema,
        credential_name     => l_credential_name,
        table_name          => l_table_name_unquoted,
        file_uri_list       => l_file_uri_list,
        column_list         => l_column_list,
        format_obj          => l_format_obj,
        partition_array     => l_partition_array,
        update_columns      => update_columns
    );
    l_column_list := REPLACE(l_column_list, DOUBLE_QUOTE);

    -- compare two comma delimited strings
    l_out_of_sync := FALSE;
    l_cnt_old := REGEXP_COUNT(l_column_list_old, COMMA);
    l_cnt_new := REGEXP_COUNT(l_column_list, COMMA);

    IF l_cnt_old <> l_cnt_new THEN
      l_out_of_sync := TRUE;
    END IF;

    IF NOT l_out_of_sync THEN
      FOR i IN 1..l_cnt_old+1 LOOP
        l_tmpstr := REGEXP_SUBSTR(l_column_list_old,'[^,]+',1,i);
        IF INSTR(l_column_list, l_tmpstr) = 0 THEN
          l_out_of_sync := TRUE;
          EXIT;
        END IF;
      END LOOP;
    END IF;

    IF update_columns AND l_out_of_sync THEN
      raise_application_error(-20000,
        'External partitioned table columns are out of sync' || NEWLINE ||
        'Old schema: ' || l_column_list_old || NEWLINE ||
        'New schema: ' || l_column_list || NEWLINE);
    END IF;

    --
    -- 9. make up a dummy partition P0 and add it into the table so that
    --    we can wipe out all the existing partitions in one DDL.
    --    We need to check every partition column's datatype to determine
    --    an appropriate 'fake' partition column value.
    --
    l_tmpstr := 'PARTITION P0 VALUES ((';

    -- the outerloop scan through all partition columns
    FOR i IN 0..l_p_columns_array.get_size-1 LOOP
      l_tmpstr2 := l_p_columns_array.get_String(i);
      l_date_timestamp := FALSE;
      -- the innerloop scan through all columns' datatypes
      FOR j IN 0..l_column_array.get_size-1 LOOP
        l_format := l_column_array.get_String(j);
        -- only data and timestamp datatypes need a special dummy date value
        -- all other partition datatypes can be coerced internally
        IF INSTR(l_format, LOWER(l_tmpstr2)) > 0 AND
           (INSTR(l_format, 'date') > 0 OR
            INSTR(l_format, 'timestamp') > 0) THEN
          l_date_timestamp := TRUE;
          EXIT;
        END IF;
      END LOOP;
      IF l_date_timestamp THEN
        l_tmpstr := l_tmpstr || 'TO_DATE(''20210101'',''yyyymmdd'')' || COMMA;
      ELSE
        l_tmpstr := l_tmpstr || SINGLE_QUOTE || '01' || SINGLE_QUOTE || COMMA;
      END IF;
    END LOOP;
    l_tmpstr := RTRIM(l_tmpstr, COMMA) || ')) LOCATION (''dummy'')';

    -- Bug 33366037: Dynamic SQLs formed using l_tmpstr will be executed by
    --               the current user, so it is okay to use DBMS_ASSERT.noop()
    --               as there is no other DBMS_ASSERT API using which we can
    --               validate l_tmpstr.
    l_sqlstmt := 'ALTER TABLE ' || l_table_name_qualified || ' ADD ' ||
      DBMS_ASSERT.noop(l_tmpstr);
    EXECUTE IMMEDIATE l_sqlstmt;

    -- prepare a sqlstmt to drop partitions in a single ALTER TABLE DDL
    l_sqlstmt :=
     'SELECT LISTAGG(partition_name, '','')
      WITHIN GROUP (ORDER BY partition_name)
      FROM SYS.ALL_TAB_PARTITIONS
      WHERE table_owner = :1
      AND table_name = :2
      AND partition_name <> ''P0''';
    EXECUTE IMMEDIATE l_sqlstmt INTO l_tmpstr USING l_schema_name_unquoted,
      l_table_name_unquoted;

    -- check if l_tmpstr is null because LISTAGG doesn't raise any exception
    -- for no_data_found
    IF l_tmpstr IS NOT NULL THEN
      l_sqlstmt := 'ALTER TABLE ' || l_table_name_qualified ||
        ' DROP PARTITION ' || DBMS_ASSERT.noop(l_tmpstr);
      EXECUTE IMMEDIATE l_sqlstmt;
    END IF;

    --
    -- 10. Use the new partitioining clause generated above to create partions
    --     in one sigle ALTER TABLE DDL.
    --     Lastly, drop the dummy partition P0.
    --
    l_sqlstmt := 'ALTER TABLE ' || l_table_name_qualified || ' ADD ';
    FOR rec in 0..l_partition_array.get_size-1 LOOP
      l_tmpstr := RTRIM(RTRIM(l_partition_array.get_String(rec), NEWLINE),
        COMMA);
      l_sqlstmt := l_sqlstmt || DBMS_ASSERT.noop(l_tmpstr) || COMMA;
    END LOOP;
    l_sqlstmt := RTRIM(l_sqlstmt, COMMA);
    EXECUTE IMMEDIATE l_sqlstmt;

    -- finally, drop the dummy partition P0
    l_sqlstmt := 'ALTER TABLE ' || l_table_name_qualified ||
      ' DROP PARTITION P0';
    EXECUTE IMMEDIATE l_sqlstmt;

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END sync_external_part_table;


  -----------------------------------------------------------------------------
  -- create_hybrid_part_table - Create Hybrid Partitioned Table on file
  --                              in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE create_hybrid_part_table(
        table_name          IN  VARCHAR2,
        credential_name     IN  VARCHAR2 DEFAULT NULL,
        partitioning_clause IN  CLOB,
        column_list         IN  CLOB     DEFAULT NULL,
        field_list          IN  CLOB     DEFAULT NULL,
        format              IN  CLOB     DEFAULT NULL
  )
  IS
  BEGIN

    create_external_table_int(
        table_name          => table_name,
        credential_name     => credential_name,
        partitioning_clause => partitioning_clause,
        column_list         => column_list,
        field_list          => field_list,
        format              => format,
        hybrid_table        => TRUE,
        log_dir             => DBMS_CLOUD_CORE.DEFAULT_LOG_DIR
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END create_hybrid_part_table;


  -----------------------------------------------------------------------------
  -- validate_external_table - Validate External Table on file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE validate_external_table(
        table_name       IN         VARCHAR2,
        operation_id     OUT NOCOPY NUMBER,
        schema_name      IN         VARCHAR2 DEFAULT  NULL,
        rowcount         IN         NUMBER   DEFAULT  0,
        stop_on_error    IN         BOOLEAN  DEFAULT  TRUE
  )
  IS
  BEGIN
    validate_external_table_int(table_name    => table_name,
                                operation_id  => operation_id,
                                schema_name   => schema_name,
                                rowcount      => rowcount,
                                stop_on_error => stop_on_error,
                                table_type    => TABTYPE_EXT
    );
  END validate_external_table;


  -----------------------------------------------------------------------------
  -- validate_external_table - Validate External Table on file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE validate_external_table(
        table_name       IN  VARCHAR2,
        schema_name      IN  VARCHAR2 DEFAULT  NULL,
        rowcount         IN  NUMBER   DEFAULT  0,
        stop_on_error    IN  BOOLEAN  DEFAULT  TRUE
  )
  IS
    l_operation_id   NUMBER;  -- unused
  BEGIN
    validate_external_table_int(table_name    => table_name,
                                operation_id  => l_operation_id,
                                schema_name   => schema_name,
                                rowcount      => rowcount,
                                stop_on_error => stop_on_error,
                                table_type    => TABTYPE_EXT
    );
  END validate_external_table;


  -----------------------------------------------------------------------------
  -- validate_external_part_table - Validate Partitioned External Table on
  --                                file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE validate_external_part_table(
        table_name               IN         VARCHAR2,
        operation_id             OUT NOCOPY NUMBER,
        partition_name           IN         VARCHAR2 DEFAULT  NULL,
        subpartition_name        IN         VARCHAR2 DEFAULT  NULL,
        schema_name              IN         VARCHAR2 DEFAULT  NULL,
        rowcount                 IN         NUMBER   DEFAULT  0,
        partition_key_validation IN         BOOLEAN  DEFAULT  FALSE,
        stop_on_error            IN         BOOLEAN  DEFAULT  TRUE
  )
  IS
  BEGIN
    validate_external_table_int(
        table_name               => table_name,
        operation_id             => operation_id,
        partition_name           => partition_name,
        subpartition_name        => subpartition_name,
        schema_name              => schema_name,
        rowcount                 => rowcount,
        partition_key_validation => partition_key_validation,
        stop_on_error            => stop_on_error,
        table_type               => TABTYPE_PET
    );
  END validate_external_part_table;


  -----------------------------------------------------------------------------
  -- validate_external_part_table - Validate Partitioned External Table on
  --                                file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE validate_external_part_table(
        table_name               IN         VARCHAR2,
        partition_name           IN         VARCHAR2 DEFAULT  NULL,
        subpartition_name        IN         VARCHAR2 DEFAULT  NULL,
        schema_name              IN         VARCHAR2 DEFAULT  NULL,
        rowcount                 IN         NUMBER   DEFAULT  0,
        partition_key_validation IN         BOOLEAN  DEFAULT  FALSE,
        stop_on_error            IN         BOOLEAN  DEFAULT  TRUE
  )
  IS
    l_operation_id   NUMBER;  -- unused
  BEGIN
    validate_external_table_int(
        table_name               => table_name,
        operation_id             => l_operation_id,
        partition_name           => partition_name,
        subpartition_name        => subpartition_name,
        schema_name              => schema_name,
        rowcount                 => rowcount,
        partition_key_validation => partition_key_validation,
        stop_on_error            => stop_on_error,
        table_type               => TABTYPE_PET
    );
  END validate_external_part_table;


  -----------------------------------------------------------------------------
  -- validate_hybrid_part_table - Validate Hybrid Partitioned Table on
  --                              file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE validate_hybrid_part_table(
        table_name               IN         VARCHAR2,
        operation_id             OUT NOCOPY NUMBER,
        partition_name           IN         VARCHAR2 DEFAULT  NULL,
        subpartition_name        IN         VARCHAR2 DEFAULT  NULL,
        schema_name              IN         VARCHAR2 DEFAULT  NULL,
        rowcount                 IN         NUMBER   DEFAULT  0,
        partition_key_validation IN         BOOLEAN  DEFAULT  FALSE,
        stop_on_error            IN         BOOLEAN  DEFAULT  TRUE
  )
  IS
  BEGIN
    validate_external_table_int(
        table_name               => table_name,
        operation_id             => operation_id,
        partition_name           => partition_name,
        subpartition_name        => subpartition_name,
        schema_name              => schema_name,
        rowcount                 => rowcount,
        partition_key_validation => partition_key_validation,
        stop_on_error            => stop_on_error,
        table_type               => TABTYPE_HPT
    );
  END validate_hybrid_part_table;


  -----------------------------------------------------------------------------
  -- validate_hybrid_part_table - Validate Hybrid Partitioned Table on
  --                              file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE validate_hybrid_part_table(
        table_name               IN         VARCHAR2,
        partition_name           IN         VARCHAR2 DEFAULT  NULL,
        subpartition_name        IN         VARCHAR2 DEFAULT  NULL,
        schema_name              IN         VARCHAR2 DEFAULT  NULL,
        rowcount                 IN         NUMBER   DEFAULT  0,
        partition_key_validation IN         BOOLEAN  DEFAULT  FALSE,
        stop_on_error            IN         BOOLEAN  DEFAULT  TRUE
  )
  IS
    l_operation_id   NUMBER;  -- unused
  BEGIN
    validate_external_table_int(
        table_name               => table_name,
        operation_id             => l_operation_id,
        partition_name           => partition_name,
        subpartition_name        => subpartition_name,
        schema_name              => schema_name,
        rowcount                 => rowcount,
        partition_key_validation => partition_key_validation,
        stop_on_error            => stop_on_error,
        table_type               => TABTYPE_HPT
    );
  END validate_hybrid_part_table;


  -----------------------------------------------------------------------------
  -- copy_data - Copy Data from Object Store to Oracle Database
  -----------------------------------------------------------------------------
  PROCEDURE copy_data(
        table_name          IN          VARCHAR2,
        credential_name     IN          VARCHAR2 DEFAULT NULL,
        file_uri_list       IN          CLOB,
        schema_name         IN          VARCHAR2 DEFAULT NULL,
        field_list          IN          CLOB     DEFAULT NULL,
        format              IN          CLOB     DEFAULT NULL,
        operation_id        OUT NOCOPY  NUMBER
  )
  IS
    -- Use autonomous transaction
    PRAGMA AUTONOMOUS_TRANSACTION;

    -- Declare locals
    l_sqlstmt              CLOB;
    l_table_name           DBMS_QUOTED_ID;
    l_schema_name          DBMS_QUOTED_ID;
    l_temp_table_name      DBMS_ID;
    TEMP_EXTTAB_SUFFIX_LEN CONSTANT PLS_INTEGER := 20;
    l_payload              JSON_OBJECT_T;
    l_format_obj           JSON_OBJECT_T;
    l_type                 DBMS_ID;
    l_column_list          DBMS_ID;
    l_field_list           CLOB;
    l_column_path_array    JSON_ARRAY_T;
    l_validation_select    CLOB;
    l_valid_jsonpath       NUMBER;
  BEGIN

    --
    -- Validate input
    --
    -- Bug 26940179: enquote table name
    l_table_name  := validate_table_name(table_name);
    l_schema_name := validate_schema_name(schema_name);

    --
    -- Check table privilege
    --
    check_table_privilege(schema_name => l_schema_name,
                          table_name  => l_table_name);

    l_temp_table_name := TEMP_EXTTAB_PREFIX ||
                         generate_random_name(TEMP_EXTTAB_SUFFIX_LEN);
    l_field_list      := field_list;

    -- Parse the format parameters JSON
    l_format_obj := parse_format_parameters(format => format);
    l_type := UPPER(get_json_string(l_format_obj, FORMAT_TYPE));

    IF l_type = FORMAT_TYPE_JSON THEN
      -- Validate format for external table on json document
      validate_collection_format(COPY_DATA_OPER, l_format_obj, l_field_list,
                                 l_column_path_array);

      l_column_list := 'JSON_DOCUMENT CLOB';
    END IF;

    -- Construct the insert statement
    l_sqlstmt := construct_insert_stmt(
                   format_type       => l_type,
                   source_table_name => l_temp_table_name,
                   schema_name       => l_schema_name,
                   table_name        => l_table_name,
                   column_path_array => l_column_path_array,
                   validation_select => l_validation_select
                 );

    -- Setup a task and create external table
    copy_task_begin(
        temp_table_name     => l_temp_table_name,
        credential_name     => credential_name,
        file_uri_list       => file_uri_list,
        base_table_name     => l_table_name,
        base_table_schema   => l_schema_name,
        column_list         => l_column_list,
        field_list          => l_field_list,
        format              => format,
        parent_operation    => COPY_DATA_OPER,
        operation_id        => operation_id,
        payload             => l_payload
    );

    BEGIN

      IF l_type = FORMAT_TYPE_JSON THEN
        -- Bug 33100064: Execute the select statement to validate the json
        --               path expressions
        BEGIN
          EXECUTE IMMEDIATE l_validation_select INTO l_valid_jsonpath;

          IF l_valid_jsonpath = 0 THEN
            raise_application_error(-20000,
                                    'columnpath does not evaluate to valid ' ||
                                    'json document in the external file');
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NULL;
        END;
      END IF;

      EXECUTE IMMEDIATE l_sqlstmt;

      -- Save the number of rows loaded in the task payload
      l_payload.put('RowsLoaded', SQL%ROWCOUNT);

      COMMIT;

    EXCEPTION
      WHEN OTHERS THEN
        -- clean up and mark the task as FAILED
        copy_task_end(
          temp_table_name     => l_temp_table_name,
          parent_operation    => COPY_DATA_OPER,
          operation_id        => operation_id,
          payload             => l_payload,
          status              => DBMS_CLOUD_TASK.TASK_STATUS_FAILED,
          error_code          => SQLCODE
        );

        RAISE;
    END;

    -- clean up and mark the task as COMPLETED
    copy_task_end(
      temp_table_name     => l_temp_table_name,
      parent_operation    => COPY_DATA_OPER,
      operation_id        => operation_id,
      payload             => l_payload,
      status              => DBMS_CLOUD_TASK.TASK_STATUS_COMPLETED,
      error_code          => 0
    );

  EXCEPTION
    WHEN OTHERS THEN
      -- Bug 29167938: Resignal the relevant error in the errorstack stack
      -- to avoid generic error from external table access driver
      IF l_payload IS NOT NULL THEN
        resignal_user_error(l_payload.get_string('LogfileTable'));
      ELSE
        resignal_user_error();
      END IF;

      RAISE;
  END copy_data;


  -----------------------------------------------------------------------------
  -- copy_data - Copy Data from Object Store to Oracle Database
  -----------------------------------------------------------------------------
  PROCEDURE copy_data(
        table_name          IN  VARCHAR2,
        credential_name     IN  VARCHAR2 DEFAULT NULL,
        file_uri_list       IN  CLOB,
        schema_name         IN  VARCHAR2 DEFAULT NULL,
        field_list          IN  CLOB     DEFAULT NULL,
        format              IN  CLOB     DEFAULT NULL
  )
  IS
    l_operation_id   NUMBER;
  BEGIN
    copy_data(table_name          => table_name,
              credential_name     => credential_name,
              file_uri_list       => file_uri_list,
              schema_name         => schema_name,
              field_list          => field_list,
              format              => format,
              operation_id        => l_operation_id
    );
  END copy_data;


  -----------------------------------------------------------------------------
  -- copy_collection - Load Data from Object Store to Oracle SODA Collection
  -----------------------------------------------------------------------------
  PROCEDURE copy_collection(
    collection_name IN         VARCHAR2,
    credential_name IN         VARCHAR2 DEFAULT NULL,
    file_uri_list   IN         CLOB,
    format          IN         CLOB     DEFAULT NULL,
    operation_id    OUT NOCOPY NUMBER
  )
  IS
    -- Use autonomous transaction
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_sqlstmt              VARCHAR2(M_VCSIZ_4K);
    l_collection_name      DBMS_QUOTED_ID;
    l_temp_table_name      DBMS_ID;
    l_tablename            DBMS_ID;
    TEMP_EXTTAB_SUFFIX_LEN CONSTANT PLS_INTEGER := 20;
    l_soda_column_list     CONSTANT VARCHAR2(M_IDEN) := 'JSON_DOCUMENT CLOB';
    l_soda_field_list      DBMS_ID;
    l_nrows                NUMBER;
    l_payload              JSON_OBJECT_T;
    l_operation_id         NUMBER;
    l_schema_name          DBMS_QUOTED_ID;
    l_log_file_prefix      DBMS_ID;
    l_format               JSON_OBJECT_T;
    l_dflt_coll            BOOLEAN;
    l_stmt                 VARCHAR2(M_VCSIZ_4K);
    l_column_path_arary    JSON_ARRAY_T;
  BEGIN

    l_format         := JSON_OBJECT_T(NVL(format,'{}'));

    -- validate format
    validate_collection_format(COPY_COLLECTION_OPER, l_format,
                               l_soda_field_list, l_column_path_arary);

    l_collection_name  := collection_name;
    l_schema_name      := get_current_user();
    l_temp_table_name  := TEMP_EXTTAB_PREFIX ||
                         generate_random_name(TEMP_EXTTAB_SUFFIX_LEN);

    -- Bug 32450303 : Use bind variable for collection name
    -- open or create the SODA collection
    -- Bug 32441566: Use Dynamic SQL and remove dependency on SODA Objects
    l_dflt_coll := FALSE;
    l_stmt := 'DECLARE                                                    ' ||
              '  l_collection SODA_COLLECTION_T;                          ' ||
              'BEGIN                                                      ' ||
              '  l_collection := DBMS_SODA.open_collection(:1);           ' ||
              '  IF l_collection IS NULL THEN                             ' ||
              '    l_collection := DBMS_SODA.create_collection(:1);       ' ||
              '    :2 := TRUE;                                            ' ||
              '  END IF;                                                  ' ||
              '  :3 := DBMS_ASSERT.enquote_name(JSON_VALUE(               ' ||
              '       l_collection.get_Metadata, ''$.tableName''), FALSE);' ||
              'END;';
    EXECUTE IMMEDIATE l_stmt USING IN l_collection_name, OUT l_dflt_coll,
                                   OUT l_tablename;
    IF l_dflt_coll = FALSE THEN
      -- Existing Collection, check if it is default collection
      l_dflt_coll :=
           is_soda_default_collection(l_collection_name);
    END IF;

    copy_task_begin(
        temp_table_name     => l_temp_table_name,
        credential_name     => credential_name,
        file_uri_list       => file_uri_list,
        base_table_name     => l_tablename,
        base_table_schema   => l_schema_name,
        column_list         => l_soda_column_list,
        field_list          => l_soda_field_list,
        format              => l_format.to_clob,
        parent_operation    => COPY_COLLECTION_OPER,
        operation_id        => l_operation_id,
        payload             => l_payload
    );

    BEGIN

      IF l_dflt_coll = TRUE THEN
        -- Bug 31964335: optimize load for default collection
        l_nrows := copy_collection_dflt(
                     table_name  => l_tablename,
                     schema_name => l_schema_name,
                     ext_tab     => l_temp_table_name,
                     format      => l_format);
      ELSE
        l_nrows := copy_collection_int(
                     collection_name   => l_collection_name,
                     schema_name       => l_schema_name,
                     ext_tab           => l_temp_table_name,
                     format            => l_format);
      END IF;

      -- Save the number of rows loaded in the task payload
      l_payload.put('RowsLoaded', l_nrows);

    EXCEPTION
      WHEN OTHERS THEN
        -- clean up and mark the task as FAILED
        copy_task_end(
          temp_table_name     => l_temp_table_name,
          parent_operation    => COPY_COLLECTION_OPER,
          operation_id        => l_operation_id,
          payload             => l_payload,
          status              => DBMS_CLOUD_TASK.TASK_STATUS_FAILED,
          error_code          => SQLCODE
        );

        RAISE;
    END;

    -- clean up and mark the task as COMPLETED
    copy_task_end(
      temp_table_name     => l_temp_table_name,
      parent_operation    => COPY_COLLECTION_OPER,
      operation_id        => l_operation_id,
      payload             => l_payload,
      status              => DBMS_CLOUD_TASK.TASK_STATUS_COMPLETED,
      error_code          => 0
    );


  EXCEPTION
    WHEN OTHERS THEN
      -- Bug 29167938: Resignal the relevant error in the errorstack stack
      -- to avoid generic error from external table access driver
      IF l_payload IS NOT NULL THEN
        resignal_user_error(l_payload.get_string('LogfileTable'));
      ELSE
        resignal_user_error();
      END IF;

      RAISE;
  END copy_collection;


  -----------------------------------------------------------------------------
  -- copy_collection - Load Data from Object Store to Oracle SODA Collection
  -----------------------------------------------------------------------------
  PROCEDURE copy_collection(
    collection_name IN  VARCHAR2,
    credential_name IN  VARCHAR2 DEFAULT NULL,
    file_uri_list   IN  CLOB,
    format          IN  CLOB     DEFAULT NULL
  )
  IS
    l_operation_id   NUMBER;
  BEGIN
    copy_collection(collection_name => collection_name,
                    credential_name => credential_name,
                    file_uri_list   => file_uri_list,
                    format          => format,
                    operation_id    => l_operation_id
    );
  END copy_collection;


  -----------------------------------------------------------------------------
  -- Parallel Enable Pipeline Table Function to Export Rows
  -----------------------------------------------------------------------------
  /*FUNCTION export_rows_tabfunc(
    refcursor IN SYS_REFCURSOR,
    context   IN CLOB
  ) RETURN DBMS_CLOUD_TYPES.get_object_ret_tab PIPELINED
    PARALLEL_ENABLE(PARTITION refcursor BY ANY)
  IS
    --
    -- NAME:
    --   export_rows_tabfunc - Export Rows Table Function
    --
    -- DESCRIPTION:
    --   This function is a parallel enable pipelined table function that
    --   loops over the rows from the export query cursor and uploads the
    --   rows to the object store
    --
    -- PARAMETERS:
    --  refcursor        (IN)  - Cursor of query to fetch the data to export
    --
    --  context          (IN)  - Context in JSON format
    --                           It has the below fields
    --
    -- RETURNS:
    --
    -- NOTES:
    --   Added by bug 32317812.
    --
    l_credential_name   DBMS_QUOTED_ID;
    l_invoker_schema    DBMS_QUOTED_ID;
    l_file_uri          VARCHAR2(M_VCSIZ_4K);
    l_file_extension    DBMS_ID;
    l_compression       DBMS_ID;
    l_record_delimiter  DBMS_ID;
    l_max_file_size     NUMBER;
    l_context           JSON_OBJECT_T;
    l_stmt              VARCHAR2(M_VCSIZ_4K);
    l_status            BOOLEAN;
  BEGIN

    -- Get all the arguments from the context
    l_context := JSON_OBJECT_T.parse(context);
    l_invoker_schema   := l_context.get_string('invoker_schema');
    l_credential_name  := l_context.get_string('credential_name');
    l_file_uri         := l_context.get_string('file_uri');
    l_file_extension   := l_context.get_string('fileextension');
    l_compression      := l_context.get_string(FORMAT_COMPRESSION);
    l_record_delimiter := l_context.get_string(FORMAT_RECORD_DELIMITER);
    l_max_file_size    := l_context.get_number('maxfilesize');

    -- Call the ICD to do all the work
    export_rows_icd(ref_cursor        => refcursor,
                    credential_name   => l_credential_name,
                    invoker_schema    => l_invoker_schema,
                    file_uri          => l_file_uri,
                    compression       => l_compression,
                    record_delimiter  => l_record_delimiter,
                    file_extension    => l_file_extension,
                    max_buffer_len    => l_max_file_size,
                    rows_per_fetch    => ROWS_PER_FETCH,
                    compression_ratio => COMPRESSION_RATIO);

    RETURN;

  END export_rows_tabfunc;
  */ --BY DarkAthena 20211207
  
  FUNCTION export_rows_tabfunc(refcursor IN SYS_REFCURSOR, context IN CLOB)
    RETURN DBMS_CLOUD_TYPES.get_object_ret_tab
    PIPELINED
    PARALLEL_ENABLE(PARTITION refcursor BY ANY) IS
  -- Author  : DarkAthena (darkathena@qq.com)                
  -- Created : 2021/12/07 14:54:29
  /*
  Copyright DarkAthena(darkathena@qq.com)
  
     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at
  
         http://www.apache.org/licenses/LICENSE-2.0
  
     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
  */
    l_credential_name  DBMS_QUOTED_ID;
    l_invoker_schema   DBMS_QUOTED_ID;
    l_file_uri         VARCHAR2(M_VCSIZ_4K);
    l_file_extension   DBMS_ID;
    l_compression      DBMS_ID;
    l_record_delimiter DBMS_ID;
    l_max_file_size    NUMBER;
    l_context          JSON_OBJECT_T;
    l_stmt             VARCHAR2(M_VCSIZ_4K);
    l_status           BOOLEAN;

    function refcursor_to_BLOB(p_sql           in SYS_REFCURSOR,
                               p_REC_DELIMITER varchar2 default chr(13) ||
                                                                chr(10))
      return Blob as
      l_ctx            dbms_xmlgen.ctxhandle;
      l_num_rows       pls_integer;
      l_xml            xmltype;
      l_transform      xmltype;
      l_xml_stylesheet varchar2(4000);
      l_REC_DELIMITER  varchar2(500);
      --
      v_file_Blob    BLOB;
      v_file_size    INTEGER := dbms_lob.lobmaxsize;
      v_dest_offset  INTEGER := 1;
      v_src_offset   INTEGER := 1;
      v_blob_csid    NUMBER := dbms_lob.default_csid;
      v_lang_context NUMBER := dbms_lob.default_lang_ctx;
      v_warning      INTEGER;
      v_length       NUMBER;
    begin
      l_REC_DELIMITER  := replace(p_REC_DELIMITER,
                                  chr(10),
                                  '<xsl:text>&#xa;</xsl:text>');
      l_REC_DELIMITER  := replace(l_REC_DELIMITER,
                                  chr(13),
                                  '<xsl:text>&#xd;</xsl:text>');
      l_xml_stylesheet := q'^<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="ROW/*">
  <xsl:apply-templates />:1
  </xsl:template>
  </xsl:stylesheet>^';
      l_xml_stylesheet := replace(l_xml_stylesheet, ':1', l_REC_DELIMITER);
      l_ctx            := dbms_xmlgen.newcontext(p_sql);
      dbms_xmlgen.setnullhandling(l_ctx, dbms_xmlgen.empty_tag);
      l_xml      := dbms_xmlgen.getxmltype(l_ctx, dbms_xmlgen.none);
      l_num_rows := dbms_xmlgen.getnumrowsprocessed(l_ctx);
      dbms_xmlgen.closecontext(l_ctx);
      if l_num_rows > 0 then
        l_transform := l_xml.transform(xmltype(l_xml_stylesheet));
      end if;
      
      dbms_lob.createtemporary(v_file_Blob, TRUE);
      dbms_lob.converttoBlob(v_file_Blob,
                             dbms_xmlgen.convert(l_transform.getclobval(),
                                                 dbms_xmlgen.entity_decode),
                             v_file_size,
                             v_dest_offset,
                             v_src_offset,
                             v_blob_csid,
                             v_lang_context,
                             v_warning);
      return v_file_Blob;
    exception
      when others then
        raise;
    end;

  begin
    -- Get all the arguments from the context
    l_context := JSON_OBJECT_T.parse(context);
    -- l_invoker_schema   := l_context.get_string('invoker_schema');
    l_credential_name := l_context.get_string('credential_name');
    l_file_uri        := l_context.get_string('file_uri');
    l_file_extension   := l_context.get_string('fileextension');
    DBMS_OUTPUT.put_line(l_file_extension);
    
    l_compression      := l_context.get_string(FORMAT_COMPRESSION);
    l_record_delimiter := l_context.get_string(FORMAT_RECORD_DELIMITER);
    -- l_max_file_size    := l_context.get_number('maxfilesize');
 
    dbms_cloud.put_object(credential_name => l_credential_name,
                          object_uri      => l_file_uri||l_file_extension,
                          contents        => refcursor_to_BLOB(refcursor,
                                                               l_record_delimiter),
                          compression =>l_compression );
    RETURN;
  end export_rows_tabfunc;
  -----------------------------------------------------------------------------
  -- Export Data from Oracle Database to Object Store
  -----------------------------------------------------------------------------
  PROCEDURE export_data(
    credential_name IN         VARCHAR2 DEFAULT NULL,
    file_uri_list   IN         CLOB,
    query           IN         CLOB,
    format          IN         CLOB     DEFAULT NULL,
    operation_id    OUT NOCOPY NUMBER
  )
  IS
    -- Declare locals
    l_format_obj           JSON_OBJECT_T;
    l_type                 DBMS_ID;
    l_payload              JSON_OBJECT_T;
  BEGIN

    -- Validate input
    IF query IS NULL THEN
      raise_application_error(-20000, 'Missing export query');
    END IF;

    -- Parse the format parameters JSON
    l_format_obj := parse_format_parameters(format => format);
    BEGIN
      l_type := UPPER(get_json_string(l_format_obj, FORMAT_TYPE));
    EXCEPTION
      WHEN invalid_format_value THEN
        raise_application_error(-20000,
           'Invalid format parameter: Bad value for ' || FORMAT_TYPE);
    END;

    --
    -- Log export data operation
    --
    log_export_op(invoker_schema  => get_current_user(),
                  credential_name => credential_name,
                  file_uri_list   => SUBSTR(file_uri_list, 1, M_VCSIZ_4K),
                  format_type     => l_type);

    CASE l_type
      -- Datapump
      WHEN FORMAT_TYPE_DATAPUMP THEN
        export_data_datapump(credential_name => credential_name,
                             file_uri_list   => file_uri_list,
                             query           => query,
                             format          => format,
                             payload         => l_payload,
                             operation_id    => operation_id);
      -- Text based formats
      ELSE
        export_data_text(credential_name => credential_name,
                         file_uri_list   => file_uri_list,
                         query           => query,
                         format          => l_format_obj,
                         payload         => l_payload,
                         operation_id    => operation_id);
    END CASE;

  EXCEPTION
    WHEN OTHERS THEN
      -- Bug 29167938: Resignal the relevant error in the errorstack stack
      -- to avoid generic error from external table access driver
      IF l_payload IS NOT NULL THEN
        resignal_user_error(l_payload.get_string('LogfileTable'));
      ELSE
        resignal_user_error();
      END IF;

      RAISE;
  END export_data;


  -----------------------------------------------------------------------------
  -- Export Data from Oracle Database to Object Store
  -----------------------------------------------------------------------------
  PROCEDURE export_data(
    credential_name IN  VARCHAR2 DEFAULT NULL,
    file_uri_list   IN  CLOB,
    query           IN  CLOB,
    format          IN  CLOB     DEFAULT NULL
  )
  IS
    l_operation_id   NUMBER;
  BEGIN
    export_data(credential_name => credential_name,
                file_uri_list   => file_uri_list,
                query           => query,
                format          => format,
                operation_id    => l_operation_id
    );
  END export_data;


  -----------------------------------------------------------------------------
  -- delete_operation - Delete an operation for cloud data access
  -----------------------------------------------------------------------------
  PROCEDURE delete_operation(
        id               IN NUMBER
  )
  IS
  BEGIN

    -- Delete the cloud data access operation
    DBMS_CLOUD_TASK.delete_task(
        id        => id,
        userid    => SYS_CONTEXT('USERENV', 'CURRENT_USERID')
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END delete_operation;


  -----------------------------------------------------------------------------
  -- delete_all_operations - Delete all operations for cloud data access
  -----------------------------------------------------------------------------
  PROCEDURE delete_all_operations(
        type               IN VARCHAR DEFAULT NULL
  )
  IS
    l_userid   NUMBER := SYS_CONTEXT('USERENV', 'CURRENT_USERID');
  BEGIN

    -- Delete all the operations
    IF type IS NULL THEN
      -- Bug 32761637: By default, only delete all COPY and VALIDATE tasks
      DBMS_CLOUD_TASK.delete_all_tasks(
          class_name => TASK_CLASS_COPY,
          userid     => l_userid
      );
      DBMS_CLOUD_TASK.delete_all_tasks(
          class_name => TASK_CLASS_VALIDATE,
          userid     => l_userid
      );
    ELSE
      -- Delete all the operations of specified type
      DBMS_CLOUD_TASK.delete_all_tasks(
          class_name => type,
          userid     => l_userid
      );
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END delete_all_operations;


  -----------------------------------------------------------------------------
  -- get_object - Get the contents of an object in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION get_object(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2,
        startOffset      IN  NUMBER   DEFAULT 0,
        endOffset        IN  NUMBER   DEFAULT 0,
        compression      IN  VARCHAR2 DEFAULT NULL
  ) RETURN BLOB
  IS
    l_credential_name  DBMS_QUOTED_ID;
    l_base_credowner   DBMS_QUOTED_ID;
    l_base_credname    DBMS_QUOTED_ID;
  BEGIN

    -- Bug 32516731: Validate the credential including resolving the synonym
    l_credential_name := validate_credential_name(
                           credential_name => credential_name,
                           base_cred_owner => l_base_credowner,
                           base_cred_name  => l_base_credname);

    RETURN DBMS_CLOUD_INTERNAL.get_object(
                invoker_schema  => NVL(l_base_credowner, get_current_user()),
                credential_name => NVL(l_base_credname,  l_credential_name),
                object_uri      => object_uri,
                startOffset     => startOffset,
                endOffset       => endOffset,
                compression     => compression
           );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END get_object;


  -----------------------------------------------------------------------------
  -- get_object - Get the contents of an object in Cloud Store to local file
  -----------------------------------------------------------------------------
  PROCEDURE get_object(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2 DEFAULT NULL,
        startOffset      IN  NUMBER   DEFAULT 0,
        endOffset        IN  NUMBER   DEFAULT 0,
        compression      IN  VARCHAR2 DEFAULT NULL
  )
  IS
    l_directory_name    DBMS_ID;
    l_credential_name   DBMS_QUOTED_ID;
    l_base_credowner    DBMS_QUOTED_ID;
    l_base_credname     DBMS_QUOTED_ID;
  BEGIN

    --
    -- Validate input
    --
    l_directory_name := validate_directory_name(directory_name, PRIV_WRITE);

    -- Bug 32516731: Validate the credential including resolving the synonym
    l_credential_name := validate_credential_name(
                           credential_name => credential_name,
                           base_cred_owner => l_base_credowner,
                           base_cred_name  => l_base_credname);

    --
    -- Download the file from object store to local file
    --
    DBMS_CLOUD_INTERNAL.get_object(
        invoker_schema   => NVL(l_base_credowner, get_current_user()),
        credential_name  => NVL(l_base_credname,  l_credential_name),
        object_uri       => object_uri,
        directory_name   => l_directory_name,
        file_name        => file_name,
        startOffset      => startOffset,
        endOffset        => endOffset,
        compression      => compression
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END get_object;


  -----------------------------------------------------------------------------
  -- put_object - Put the contents in an object in Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE put_object(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2,
        contents         IN  BLOB,
        compression      IN  VARCHAR2 DEFAULT NULL,
        retention_days   IN  NUMBER   DEFAULT NULL
  )
  IS
    l_credential_name  DBMS_QUOTED_ID;
    l_base_credowner   DBMS_QUOTED_ID;
    l_base_credname    DBMS_QUOTED_ID;
    l_operation_id     NUMBER;
    l_payload          JSON_OBJECT_T;
  BEGIN

    -- Bug 32516731: Validate the credential including resolving the synonym
    l_credential_name := validate_credential_name(
                           credential_name => credential_name,
                           base_cred_owner => l_base_credowner,
                           base_cred_name  => l_base_credname);

    -- Bug 32761637: Support retention days for object
    IF retention_days IS NOT NULL THEN

      -- Validate the expiration days to be whole number
      IF DBMS_CLOUD_CORE.whole_number(retention_days) = FALSE THEN
        raise_application_error(-20000,
            'Invalid expiration days: ' ||
            NVL(TO_CHAR(retention_days), 'NULL'));
      END IF;

      -- Create a task with payload information about the load operation
      l_payload := JSON_OBJECT_T('{}');
      l_payload.put('FileUriList', SUBSTR(object_uri, 0, M_VCSIZ_4K));
      l_payload.put('CredentialName',
                    DBMS_CLOUD_CORE.unquote_name(l_credential_name));

      -- Create a task
      l_operation_id := DBMS_CLOUD_TASK.create_task(
                  class_name       => TASK_CLASS_PUT,
                  userid           => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
                  status           => DBMS_CLOUD_TASK.TASK_STATUS_RUNNING,
                  payload          => l_payload.to_clob,
                  cleanup_interval => NUMTODSINTERVAL(retention_days, 'day'));
    END IF;

    DBMS_CLOUD_INTERNAL.put_object(
        invoker_schema  => NVL(l_base_credowner, get_current_user()),
        credential_name => NVL(l_base_credname,  l_credential_name),
        object_uri      => object_uri,
        contents        => contents,
        compression     => compression
    );

    IF l_operation_id IS NOT NULL THEN
      -- Mark the task as COMPLETED
      DBMS_CLOUD_TASK.update_task(
          id      => l_operation_id,
          userid  => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
          status  => DBMS_CLOUD_TASK.TASK_STATUS_COMPLETED,
          payload => l_payload.to_clob
      );
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      IF l_operation_id IS NOT NULL THEN
        -- Mark the task as FAILED
        DBMS_CLOUD_TASK.update_task(
            id      => l_operation_id,
            userid  => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
            status  => DBMS_CLOUD_TASK.TASK_STATUS_FAILED,
            payload => l_payload.to_clob
        );
      END IF;

      resignal_user_error();
      RAISE;
  END put_object;


  -----------------------------------------------------------------------------
  -- put_object - Put the contents in an object in Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE put_object(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2,
        contents         IN  BLOB,
        compression      IN  VARCHAR2 DEFAULT NULL
  )
  IS
  BEGIN
    put_object(credential_name => credential_name,
               object_uri      => object_uri,
               contents        => contents,
               compression     => compression,
               retention_days  => NULL
    );
  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END put_object;


  -----------------------------------------------------------------------------
  -- put_object - Put the contents of local file in an object Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE put_object(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2,
        compression      IN  VARCHAR2 DEFAULT NULL,
        retention_days   IN  NUMBER   DEFAULT NULL
  )
  IS
    l_credential_name  DBMS_QUOTED_ID;
    l_base_credowner   DBMS_QUOTED_ID;
    l_base_credname    DBMS_QUOTED_ID;
    l_operation_id     NUMBER;
    l_payload          JSON_OBJECT_T;
  BEGIN

    -- Bug 32516731: Validate the credential including resolving the synonym
    l_credential_name := validate_credential_name(
                           credential_name => credential_name,
                           base_cred_owner => l_base_credowner,
                           base_cred_name  => l_base_credname);

    IF retention_days IS NOT NULL THEN

      -- Validate the expiration days to be whole number
      IF DBMS_CLOUD_CORE.whole_number(retention_days) = FALSE THEN
        raise_application_error(-20000,
            'Invalid expiration days: ' ||
            NVL(TO_CHAR(retention_days), 'NULL'));
      END IF;

      -- Create a task with payload information about the load operation
      l_payload := JSON_OBJECT_T('{}');
      l_payload.put('FileUriList', SUBSTR(object_uri, 0, M_VCSIZ_4K));
      l_payload.put('CredentialName',
                    DBMS_CLOUD_CORE.unquote_name(l_credential_name));

      -- Create a task
      l_operation_id := DBMS_CLOUD_TASK.create_task(
                  class_name       => TASK_CLASS_PUT,
                  userid           => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
                  status           => DBMS_CLOUD_TASK.TASK_STATUS_RUNNING,
                  payload          => l_payload.to_clob,
                  cleanup_interval => NUMTODSINTERVAL(retention_days, 'day'));
    END IF;

    --
    -- Upload the local file to object storex
    --
    DBMS_CLOUD_INTERNAL.put_object(
        invoker_schema   => NVL(l_base_credowner, get_current_user()),
        credential_name  => NVL(l_base_credname,  l_credential_name),
        object_uri       => object_uri,
        directory_name   => validate_directory_name(directory_name, PRIV_READ),
        file_name        => file_name,
        compression      => compression
    );

    IF l_operation_id IS NOT NULL THEN
      -- Mark the task as COMPLETED
      DBMS_CLOUD_TASK.update_task(
          id      => l_operation_id,
          userid  => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
          status  => DBMS_CLOUD_TASK.TASK_STATUS_COMPLETED,
          payload => l_payload.to_clob
      );
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      IF l_operation_id IS NOT NULL THEN
        -- Mark the task as FAILED
        DBMS_CLOUD_TASK.update_task(
            id      => l_operation_id,
            userid  => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
            status  => DBMS_CLOUD_TASK.TASK_STATUS_FAILED,
            payload => l_payload.to_clob
        );
      END IF;

      resignal_user_error();
      RAISE;
  END put_object;


  -----------------------------------------------------------------------------
  -- put_object - Put the contents of local file in an object Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE put_object(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2,
        compression      IN  VARCHAR2 DEFAULT NULL
  )
  IS
  BEGIN
    put_object(credential_name => credential_name,
               object_uri      => object_uri,
               directory_name  => directory_name,
               file_name       => file_name,
               compression     => compression,
               retention_days  => NULL
    );
  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END put_object;


  -----------------------------------------------------------------------------
  -- get_metadata - Get the metadata for an object in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION get_metadata(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2
  ) RETURN CLOB
  IS
    l_credential_name  DBMS_QUOTED_ID;
    l_base_credowner   DBMS_QUOTED_ID;
    l_base_credname    DBMS_QUOTED_ID;
  BEGIN

    -- Bug 32516731: Validate the credential including resolving the synonym
    l_credential_name := validate_credential_name(
                           credential_name => credential_name,
                           base_cred_owner => l_base_credowner,
                           base_cred_name  => l_base_credname);

    RETURN DBMS_CLOUD_INTERNAL.get_metadata(
                invoker_schema  => NVL(l_base_credowner, get_current_user()),
                credential_name => NVL(l_base_credname,  l_credential_name),
                object_uri      => object_uri,
                external        => TRUE
           );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END get_metadata;


  -----------------------------------------------------------------------------
  -- list_objects - List objects at a given location in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION list_objects(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        location_uri     IN  VARCHAR2
  ) RETURN DBMS_CLOUD_TYPES.list_object_ret_tab PIPELINED PARALLEL_ENABLE
  IS
    l_data             CLOB;
    l_object           JSON_OBJECT_T;
    l_object_list      JSON_ARRAY_T;
    l_record           DBMS_CLOUD_TYPES.list_object_ret_t;
    l_list_fields      DBMS_CLOUD_TYPES.list_object_fields_t;
    l_filter_path      VARCHAR2(M_VCSIZ_4K);
    l_filter_path_len  PLS_INTEGER;
    l_resume_obj       VARCHAR2(2*M_IDEN) := NULL;
    l_nextmarker       VARCHAR2(M_VCSIZ_4K) := NULL;
    l_credential_name  DBMS_QUOTED_ID;
    l_base_credowner   DBMS_QUOTED_ID;
    l_base_credname    DBMS_QUOTED_ID;
  BEGIN

    -- Bug 32516731: Validate the credential including resolving the synonym
    l_credential_name := validate_credential_name(
                           credential_name => credential_name,
                           base_cred_owner => l_base_credowner,
                           base_cred_name  => l_base_credname);

    -- Get the list of objects as a JSON CLOB
    --
    -- Bug 27752606: call DBMS_CLOUD_INTERNAL.list_objects repeatedly varying
    -- the resume_obj parameter until no objects are returned
    --
    -- Bug 26817803: Due to COMMON_SCHEMA_ACCESS lockdown, a query on
    -- DBMS_CLOUD_INTERNAL.list_objects table function cannot be done here.
    -- Instead, get the JSON and process it here itself to generate the rows.
    --
    LOOP
       l_data := DBMS_CLOUD_INTERNAL.list_objects(
                           invoker_schema  => NVL(l_base_credowner,
                                                  get_current_user()),
                           credential_name => NVL(l_base_credname,
                                                  l_credential_name),
                           location_uri    => location_uri,
                           resume_obj      => l_resume_obj,
                           filter_path     => l_filter_path,
                           list_fields     => l_list_fields,
                           nextmarker      => l_nextmarker
                 );
       l_filter_path_len := NVL(LENGTH(l_filter_path)+1, 1);

       -- Generate metadata as JSON
       l_object_list := JSON_OBJECT_T(l_data).get_Array('object_list');

       EXIT WHEN l_object_list.get_size = 0;

       FOR i in 0 .. l_object_list.get_size - 1  LOOP
         l_object             := JSON_OBJECT_T(l_object_list.get(i));
         l_record.bytes       :=
                    l_object.get_Number(l_list_fields(LIST_OBJ_FIELD_BYTES));
         l_record.object_name :=
                    l_object.get_String(l_list_fields(LIST_OBJ_FIELD_NAME));
         l_record.checksum :=
                    l_object.get_String(l_list_fields(LIST_OBJ_FIELD_CHECKSUM));
         -- Bug 31021116: Ignore conversion errors for timestamp
         l_record.created :=
             TO_TIMESTAMP_TZ(
                 l_object.get_String(l_list_fields(LIST_OBJ_FIELD_CREATED))
                 DEFAULT NULL ON CONVERSION ERROR,
                 l_list_fields(LIST_OBJ_FIELD_CREATED_FMT)
             );
         l_record.last_modified :=
             TO_TIMESTAMP_TZ(
                 l_object.get_String(l_list_fields(LIST_OBJ_FIELD_LASTMOD))
                 DEFAULT NULL ON CONVERSION ERROR,
                 l_list_fields(LIST_OBJ_FIELD_LASTMOD_FMT)
             );

         -- Bug 27043758: Remove file path prefix from the object name
         -- The filter path length for a folder has to be at least 2, including
         -- the terminating '/' character.
         --
         -- Bug 29638227: Amazon S3 can list folders as a list item, but they
         -- are not useful for data loading as they are not files. So exclude
         -- any objects with terminating '/' character.
         IF l_filter_path_len > 1 THEN
            IF LENGTH(l_record.object_name) < l_filter_path_len OR
               INSTR(l_record.object_name, l_filter_path) != 1 OR
               SUBSTR(l_record.object_name, -1) = '/' THEN
               CONTINUE;
            END IF;
            l_record.object_name :=
                            SUBSTR(l_record.object_name,l_filter_path_len);
         END IF;

         PIPE ROW (l_record);
       END LOOP;

       -- If the length of objects returned in first request is very small,
       -- then no paging is expected and we can exit the loop.
       EXIT WHEN l_resume_obj IS NULL AND
                 l_object_list.get_size < DBMS_CLOUD_INTERNAL.LIST_OBJECTS_MIN;

      -- Get the name of last object in array and use it as "resume object" for
      -- BMC Swift or Amazon S3
       l_object := JSON_OBJECT_T(l_object_list.get(l_object_list.get_size-1));
       l_resume_obj := l_object.get_String('name');
    END LOOP;

    RETURN;

  EXCEPTION
    WHEN NO_DATA_NEEDED THEN
      RETURN;

    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END list_objects;


  -----------------------------------------------------------------------------
  -- list_files - List files at a given directory object location
  -----------------------------------------------------------------------------
  FUNCTION list_files(
        directory_name   IN  VARCHAR2
  ) RETURN DBMS_CLOUD_TYPES.list_object_ret_tab PIPELINED PARALLEL_ENABLE
  IS
    l_directory_name   DBMS_ID;
    l_data             CLOB;
    l_object           JSON_OBJECT_T;
    l_object_list      JSON_ARRAY_T;
    l_record           DBMS_CLOUD_TYPES.list_object_ret_t;
  BEGIN

    --
    -- Validate input
    --
    l_directory_name := validate_directory_name(directory_name, PRIV_READ);

    --
    -- List the local directory
    --
    l_data := DBMS_CLOUD_INTERNAL.list_files(
                 invoker_schema   => get_current_user(),
                 directory_name   => l_directory_name,
                 file_name_filter => NULL
              );

    -- Generate metadata as JSON
    l_object_list := JSON_OBJECT_T(l_data).get_Array('object_list');

    -- Bug 28538910: Include created and last_modified timestamp for files
    FOR i in 0 .. l_object_list.get_size - 1  LOOP
      l_object                := JSON_OBJECT_T(l_object_list.get(i));
      l_record.bytes          := l_object.get_Number('bytes');
      l_record.object_name    := l_object.get_String('name');
      l_record.created        := l_object.get_String('created');
      l_record.last_modified  := l_object.get_String('last_modified');

      PIPE ROW (l_record);
    END LOOP;

  EXCEPTION
    WHEN NO_DATA_NEEDED THEN
      RETURN;

    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END list_files;


  -----------------------------------------------------------------------------
  -- delete_object - Delete an object in Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE delete_object(
        credential_name  IN  VARCHAR2 DEFAULT NULL,
        object_uri       IN  VARCHAR2
  )
  IS
    l_credential_name  DBMS_QUOTED_ID;
    l_base_credowner   DBMS_QUOTED_ID;
    l_base_credname    DBMS_QUOTED_ID;
  BEGIN

    -- Bug 32516731: Validate the credential including resolving the synonym
    l_credential_name := validate_credential_name(
                           credential_name => credential_name,
                           base_cred_owner => l_base_credowner,
                           base_cred_name  => l_base_credname);

    DBMS_CLOUD_INTERNAL.delete_object(
        invoker_schema  => NVL(l_base_credowner, get_current_user()),
        credential_name => NVL(l_base_credname,  l_credential_name),
        object_uri      => object_uri
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END delete_object;


  -----------------------------------------------------------------------------
  -- delete_file - Delete a file in directory object
  -----------------------------------------------------------------------------
  PROCEDURE delete_file(
        directory_name  IN  VARCHAR2,
        file_name       IN  VARCHAR2
  )
  IS
  BEGIN

    --
    -- Delete the local file
    --
    DBMS_CLOUD_INTERNAL.delete_file(
        invoker_schema  => get_current_user(),
        directory_name  => validate_directory_name(directory_name, PRIV_WRITE),
        file_name       => file_name
    );

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END delete_file;


  -----------------------------------------------------------------------------
  -- send_request - Send HTTP request
  -----------------------------------------------------------------------------
  FUNCTION send_request(
    credential_name    IN  VARCHAR2,
    uri                IN  VARCHAR2,
    method             IN  VARCHAR2,
    headers            IN  CLOB      DEFAULT NULL,
    body               IN  BLOB      DEFAULT NULL,
    async_request_url  IN  VARCHAR2  DEFAULT NULL,
    wait_for_states    IN  DBMS_CLOUD_TYPES.wait_for_states_t
                                     DEFAULT NULL,
    timeout            IN  NUMBER    DEFAULT 0,
    cache              IN  BOOLEAN   DEFAULT FALSE,
    cache_scope        IN  VARCHAR2  DEFAULT NULL
  ) RETURN DBMS_CLOUD_TYPES.resp
  IS
    l_req                  DBMS_CLOUD_REQUEST.request_context_t;
    l_resp                 DBMS_CLOUD_TYPES.resp;
    l_http_resp            UTL_HTTP.resp;
    l_header_name          VARCHAR2(M_VCSIZ_4K);
    l_header_value         VARCHAR2(M_VCSIZ_4K);
    l_buffer               RAW(M_VCSIZ_4K);
    l_path                 VARCHAR2(M_VCSIZ_4K);
    l_query_params_obj     JSON_OBJECT_T;
    l_cloud_store_type     PLS_INTEGER;
    l_use_bucket_uri       BOOLEAN      := FALSE;
    l_amount               PLS_INTEGER  := M_VCSIZ_4K;
    l_opc_work_request_id  VARCHAR2(M_VCSIZ_4K);
    l_workrequest_url      VARCHAR2(M_VCSIZ_4K);
    l_credential_name      DBMS_QUOTED_ID;
    l_base_credowner       DBMS_QUOTED_ID;
    l_base_credname        DBMS_QUOTED_ID;
    l_headers_obj          JSON_OBJECT_T;
  BEGIN

    -- Bug 32516731: Validate the credential including resolving the synonym
    l_credential_name := validate_credential_name(
                           credential_name => credential_name,
                           base_cred_owner => l_base_credowner,
                           base_cred_name  => l_base_credname);

    -- Begin a request
    l_req := DBMS_CLOUD_REQUEST.init_request(
                 invoker_schema  => NVL(l_base_credowner, get_current_user()),
                 credential_name => NVL(l_base_credname,  l_credential_name),
                 base_uri        => uri,
                 method          => validate_request_method(method)
             );

    l_cloud_store_type := DBMS_CLOUD_REQUEST.get_cloud_store_type(l_req);
    CASE l_cloud_store_type
      -- Oracle BMC
      WHEN DBMS_CLOUD_REQUEST.CSTYPE_ORACLE_BMC THEN
        -- Bug 33111350: Disallow auth endpoints for OCI
        IF INSTR(TRIM(l_req(DBMS_CLOUD_REQUEST.REQUEST_CTX_HOSTNAME)),
                 'auth.') = 1
        THEN
          raise_application_error(EXCP_UNSUPP_OBJ_STORE,
               'Unsupported URI - ' || uri);
        END IF;

      -- Microsoft Azure
      WHEN DBMS_CLOUD_REQUEST.CSTYPE_MS_AZURE_BLOB THEN
        -- Bug 30788470: Microsoft Azure requires query string to be explicitly
        -- hashed in the authorization signature. The path and query params
        -- should be separately passed in the request.
        --
        IF INSTR(uri, '?') > 0 THEN
          -- Use bucket URI for the request
          l_use_bucket_uri := TRUE;

          -- Set the URI path as the rest of the URI after the host name
          l_path := SUBSTR(uri, INSTR(uri, '?')+1);

          -- Get the query string parameters and convert to JSON object of
          -- params ?a=b'&'c=d => {"a": "b", "c":"d"}
          l_query_params_obj := JSON_OBJECT_T('{}');
          FOR rec IN
          (  SELECT REGEXP_SUBSTR(l_path, '[^' || '&' || ']+', 1, level) param
             FROM sys.dual
             CONNECT BY REGEXP_SUBSTR(l_path, '[^' || '&' || ']+', 1, level)
                        IS NOT NULL
          )
          LOOP
            IF INSTR(rec.param, '=') > 0 THEN
              l_query_params_obj.put(
                  SUBSTR(rec.param, 1, INSTR(rec.param, '=')-1),
                  SUBSTR(rec.param, INSTR(rec.param, '=')+1)
              );
            END IF;
          END LOOP;

        END IF;

      ELSE
        NULL;
    END CASE;

    -- Parse request headers
    BEGIN
      l_headers_obj := parse_json_parameters(headers);
    EXCEPTION
      WHEN OTHERS THEN
        -- Raise any parsing errors
        raise_application_error(EXCP_INVALID_REQ_HEADER,
                'Invalid request headers - ' || headers);
    END;

    -- Send request
    l_http_resp := DBMS_CLOUD_REQUEST.send_request(
                       context        => l_req,
                       path           => NULLIF('?' || l_path, '?'),
                       params         => l_query_params_obj,
                       headers        => l_headers_obj,
                       body           => body,
                       use_bucket_uri => l_use_bucket_uri
                   );

    -- Response status code
    l_resp.status_code := l_http_resp.status_code;

    -- Response body
    DBMS_LOB.createtemporary(l_resp.body, FALSE, DBMS_LOB.CALL);
    BEGIN
      LOOP
        UTL_HTTP.read_raw(l_http_resp, l_buffer, l_amount);
        DBMS_LOB.writeappend(l_resp.body, UTL_RAW.length(l_buffer), l_buffer);
      END LOOP;
    EXCEPTION
      WHEN UTL_HTTP.end_of_body THEN
        -- End of response is expected exception
        NULL;
    END;

    -- Response headers
    -- Bug 30603348: get response header after response body to handle
    -- additional trailer headers for chunked transfer encoding format.
    l_resp.headers := JSON_OBJECT_T('{}');
    FOR l_hidx IN 1..UTL_HTTP.get_header_count(l_http_resp) LOOP
      UTL_HTTP.get_header(l_http_resp, l_hidx, l_header_name, l_header_value);
      l_resp.headers.put(l_header_name, l_header_value);
    END LOOP;

    -- Bug 30577789: Response initialized
    l_resp.init := TRUE;

    -- End request
    DBMS_CLOUD_REQUEST.end_request(l_http_resp);

    -- Synchronous case
    IF async_request_url IS NOT NULL THEN

      IF l_cloud_store_type = DBMS_CLOUD_REQUEST.CSTYPE_ORACLE_BMC THEN

        -- Get the opc_work_request_id
        l_opc_work_request_id := l_resp.headers.get_string(
                                                OCI_WORK_REQUEST_ID);

        -- Get the url to query workrequest status
        l_workrequest_url := get_workrequest_url(
                                 workrequest_url     => async_request_url,
                                 opc_work_request_id => l_opc_work_request_id
                             );

        -- Get the synchronous response
        l_resp := get_sync_workrequest_response(
                           credential_name => credential_name,
                           status_url      => l_workrequest_url,
                           workrequest_id  => l_opc_work_request_id,
                           wait_for_states => wait_for_states,
                           timeout         => timeout
                  );

        RETURN l_resp;

      ELSE
        raise_application_error(-20000,
               'Synchronous wait operation not supported for ' ||
               async_request_url);

      END IF;

    END IF;

    -- Bug 31659526: Cache DBMS_CLOUD REST API results.
    -- If the request/response body is not bigger than 32k bytes and it is in
    -- text format(JSON/XML/TEXT), the request/response body raw data will be
    -- stored.
    IF cache = TRUE THEN
      DBMS_CLOUD_INTERNAL.cache_rest_api_results(
           username             => SYS_CONTEXT('USERENV', 'CURRENT_USER'),
           request_uri          => uri,
           timestamp            => CURRENT_TIMESTAMP AT TIME ZONE 'UTC',
           request_method       => method,
           request_headers      => headers,
           request_body_text    => get_qualified_body_text(
                                   l_headers_obj, body),
           response_status_code => get_response_status_code(l_resp),
           response_headers     => get_response_headers(l_resp).TO_CLOB,
           response_body_text   => get_qualified_body_text(
                                   l_resp.headers, get_response_raw(l_resp)),
           cache_scope          => cache_scope
      );
    END IF;
    RETURN l_resp;

  EXCEPTION
    WHEN OTHERS THEN
      -- End request on exception
      DBMS_CLOUD_REQUEST.end_request(l_http_resp);
      resignal_user_error();
      RAISE;
  END send_request;


  -----------------------------------------------------------------------------
  -- send_request - Send HTTP request
  -----------------------------------------------------------------------------
  PROCEDURE send_request(
    credential_name    IN  VARCHAR2,
    uri                IN  VARCHAR2,
    method             IN  VARCHAR2,
    headers            IN  CLOB      DEFAULT NULL,
    body               IN  BLOB      DEFAULT NULL,
    async_request_url  IN  VARCHAR2  DEFAULT NULL,
    wait_for_states    IN  DBMS_CLOUD_TYPES.wait_for_states_t
                                     DEFAULT NULL,
    timeout            IN  NUMBER    DEFAULT 0,
    cache              IN  BOOLEAN   DEFAULT FALSE,
    cache_scope        IN  VARCHAR2  DEFAULT NULL
  )
  IS
    l_resp                 DBMS_CLOUD_TYPES.resp;
  BEGIN
    l_resp := send_request(credential_name   => credential_name,
                           uri               => uri,
                           method            => method,
                           headers           => headers,
                           body              => body,
                           async_request_url => async_request_url,
                           wait_for_states   => wait_for_states,
                           timeout           => timeout,
                           cache             => cache,
                           cache_scope       => cache_scope
              );

  END send_request;


  -----------------------------------------------------------------------------
  -- set_api_result_cache_size - Update DBMS_CLOUD REST API max cache size
  -----------------------------------------------------------------------------
  PROCEDURE set_api_result_cache_size(
        cache_size  IN NUMBER
  ) IS
  BEGIN
    DBMS_CLOUD_INTERNAL.set_api_result_cache_size(cache_size);

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END set_api_result_cache_size;


  -----------------------------------------------------------------------------
  -- get_api_result_cache_size - Get DBMS_CLOUD REST API max cache size
  -----------------------------------------------------------------------------
  FUNCTION get_api_result_cache_size
  RETURN NUMBER
  IS
  BEGIN
    RETURN DBMS_CLOUD_INTERNAL.get_api_result_cache_size;

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END get_api_result_cache_size;


  -----------------------------------------------------------------------------
  -- get_response_headers - Get response headers
  -----------------------------------------------------------------------------
  FUNCTION get_response_headers(
    resp        IN  DBMS_CLOUD_TYPES.resp
  ) RETURN JSON_OBJECT_T
  IS
  BEGIN

    -- Validate response
    validate_response(resp);

    -- Return response headers as JSON object
    RETURN resp.headers;

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END get_response_headers;


  -----------------------------------------------------------------------------
  -- get_response_text - Get response body as text
  -----------------------------------------------------------------------------
  FUNCTION get_response_text(
    resp        IN  DBMS_CLOUD_TYPES.resp
  ) RETURN CLOB
  IS
  BEGIN

    RETURN TO_CLOB(get_response_raw(resp));

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END get_response_text;


  -----------------------------------------------------------------------------
  -- get_response_raw - Get response body as raw
  -----------------------------------------------------------------------------
  FUNCTION get_response_raw(
    resp        IN  DBMS_CLOUD_TYPES.resp
  ) RETURN BLOB
  IS
  BEGIN

    -- Validate response
    validate_response(resp);

    RETURN resp.body;

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END get_response_raw;


  -----------------------------------------------------------------------------
  -- get_response_status_code - Get response status code
  -----------------------------------------------------------------------------
  FUNCTION get_response_status_code(
    resp        IN  DBMS_CLOUD_TYPES.resp
  ) RETURN PLS_INTEGER
  IS
  BEGIN

    -- Validate response
    validate_response(resp);

    RETURN resp.status_code;

  EXCEPTION
    WHEN OTHERS THEN
      resignal_user_error();
      RAISE;
  END get_response_status_code;


END dbms_cloud; -- End of DBMS_CLOUD Package Body
/
