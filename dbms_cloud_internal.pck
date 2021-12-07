CREATE OR REPLACE NONEDITIONABLE PACKAGE C##CLOUD$SERVICE.dbms_cloud_internal AS

  ----------------------------
  -- Constants
  ----------------------------
  M_IDEN           CONSTANT   PLS_INTEGER := 128;
  M_PRIV_KEY       CONSTANT   PLS_INTEGER := 2000;
  M_VCSIZ_4K       CONSTANT   PLS_INTEGER := 4000;
  M_QUAL_IDEN      CONSTANT   PLS_INTEGER := 2*M_IDEN+5;

  -- Minimum number of objects in 1 page to optimize repeat lookup for
  -- list_objects with small results
  LIST_OBJECTS_MIN CONSTANT   PLS_INTEGER := 1000;


  ----------------------------
  --  PROCEDURES AND FUNCTIONS
  ----------------------------

  -----------------------------------------------------------------------------
  -- create_credential - Create a Credential object to access any Object Store
  -----------------------------------------------------------------------------
  PROCEDURE create_credential(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        username         IN  VARCHAR2,
        password         IN  VARCHAR2   DEFAULT NULL
  );

  PROCEDURE create_credential(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        user_ocid        IN  VARCHAR2   DEFAULT NULL,
        tenancy_ocid     IN  VARCHAR2   DEFAULT NULL,
        private_key      IN  VARCHAR2,
        fingerprint      IN  VARCHAR2   DEFAULT NULL,
        passphrase       IN  VARCHAR2   DEFAULT NULL,
        rpst             IN  VARCHAR2   DEFAULT NULL
  );

  PROCEDURE create_credential(
        invoker_schema        IN  VARCHAR2,
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
    --   invoker_schema   (IN) - Invoking schema for the procedure
    --
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
    --   passphrase       (IN) - passphrase used to generate the RSA Private
    --                           Key
    --
    --   rpst             (IN) - Resource principal session token
    --
    --
    -- NOTES:
    --   Credential name should not be schema qualified, because credential
    --   can only be created in the schema of the invoking user.
    --
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
  -- drop_credential - Drop a Credential object to access any Object Store
  -----------------------------------------------------------------------------
  PROCEDURE drop_credential(
        invoker_schema   IN  VARCHAR2,
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
    --   invoker_schema  (IN) - Invoking schema for the procedure
    --
    --   credential_name (IN) - Name of the Credential object
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- enable_credential - Enable a Credential object to access Object Store
  -----------------------------------------------------------------------------
  PROCEDURE enable_credential(
        invoker_schema   IN  VARCHAR2,
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
    --   invoker_schema  (IN) - Invoking schema for the procedure
    --
    --   credential_name (IN) - Name of the Credential object
    --
    -- NOTES:
    --
  -----------------------------------------------------------------------------
  -- disable_credential - Disable a Credential object to access Object Store
  -----------------------------------------------------------------------------
  PROCEDURE disable_credential(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2
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
    --   invoker_schema  (IN) - Invoking schema for the procedure
    --
    --   credential_name (IN) - Name of the Credential object
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- update_rpst_credential - Update RPST Credential object
  -----------------------------------------------------------------------------
  PROCEDURE update_rpst_credential(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        rpst             IN  VARCHAR2,
        private_key      IN  VARCHAR2
  );
    --
    -- NAME:
    --  update_rpst_credential - Update a RPST Credential object
    --
    -- DESCRIPTION:
    --   This procedure updates a RPST credential object in the database using
    --   DBMS_CREDENTIAL package.
    --
    --
    -- PARMETERS:
    --   invoker_schema  (IN) - Invoking schema for the procedure
    --
    --   credential_name (IN) - Name of the Credential object
    --
    --   rpst            (IN) - Resource principal session token to update
    --
    --   private_key     (IN) - Private Key for RPST token to update
    --
    -- NOTES:
    --   Added for bug 32119371.
    --


  -----------------------------------------------------------------------------
  -- update_credential - Update a Credential object to access Object Store
  -----------------------------------------------------------------------------
  PROCEDURE update_credential(
        invoker_schema   IN  VARCHAR2,
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
    --     8. rpst
    --
    --
    -- PARMETERS:
    --   invoker_schema  (IN) - Invoking schema for the procedure
    --
    --   credential_name (IN) - Name of the Credential object
    --
    --   attribute       (IN) - Attribute to update in the credential object
    --
    --   value           (IN) - Value of the credential attribute to update
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- clear_bypass - Clear bypass for external table ddl
  -----------------------------------------------------------------------------
  PROCEDURE clear_bypass(
    bypass_value  IN  NUMBER
  );
    --
    -- NAME:
    --  clear_bypass - Clear bypass for external table ddl
    --
    -- DESCRIPTION:
    --   This procedure clears the bypass for external table ddl.
    --
    -- PARMETERS:
    --   bypass_value  (IN)  - original saved bypass value
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- get_create_exttab_text - Get text of Create External Table on file in
  --                          Object Store
  -----------------------------------------------------------------------------
  FUNCTION get_create_exttab_text(
        invoker_schema      IN  VARCHAR2,
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
        export_query        IN  CLOB     DEFAULT NULL,
        bypass_value        OUT NUMBER,
        base_cred_owner     IN  VARCHAR2 DEFAULT NULL,
        base_cred_name      IN  VARCHAR2 DEFAULT NULL
  ) return CLOB;
    --
    -- NAME:
    --   get_create_exttab_text - Get text of Create External Table on file in
    --                            Object Store
    --
    -- DESCRIPTION:
    --   This procedure creates an external table to access a file existing in
    --   the Object Store.
    --
    -- PARAMETERS:
    --   invoker_schema  (IN)  - Invoking schema for the procedure
    --
    --   table_name      (IN)  - Name of the external table
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           have been created using DBMS_CLOUD.
    --
    --   file_uri_list   (IN)  - URI(s) of the file(s) existing in Object Store
    --
    --   partitioning_clause (IN) - Partitioning clause for external table
    --
    --   column_list     (IN)  - Column definition clause for CREATE TABLE.
    --                           The value of this argument should be same as
    --                           specifying a list of columns in creating an
    --                           external table, without the enclosing
    --                           parenthesis used for the column clause.
    --                             Eg: 'empno NUMBER, emp_name VARCHAR2(128)'
    --
    --   base_table      (IN)  - Base table to use for deriving the column
    --                           list for the external table.
    --
    --   base_table_schema (IN)  - Schema name owning the 'base_table'
    --
    --   field_list      (IN)  - Field_list for External table (optional).
    --                           This value identifies the fields in the
    --                           external file and their datatypes.
    --
    --   format          (IN)  - Additional data formatting options (optional)
    --
    --   log_dir         (IN) - Logging directory object for external table
    --
    --   log_file_prefix (IN) - Prefix for log/bad file name
    --
    --   os_ext_table    (IN) - External table for accessing local files
    --
    --   parent_operation (IN) - parent operation
    --
    --   part_table       (IN) - partitioned external table (optional)
    --
    --   hybrid_table     (IN) - hybrid partitioned table (optional)
    --
    --   export_query     (IN) - Select query for exporting data
    --
    --   bypass_value    (OUT) - Saved bypass clause value
    --
    --   base_cred_owner  (IN) - Owner for credential pointed to by synonym
    --
    --   base_cred_name   (IN) - Name of credential pointed to by synonym
    --
    --
    -- RETURNS:
    --   Clob containing the create external table DDL statement to be execute
    --   inside Dbms_Cloud code(Invoker Rights) using Current_User privileges.
    --
    -- NOTES:
    --   Either column_list or base_table argument must be specified to derive
    --   the column clause for creating the table.
    --
    --   For non-synonym case, base credential owner/name will be current user
    --   and credential name respectively. If DBMS_UTILITY.name_resolve does
    --   not support credentials, both these fields will be passed in as NULL.
    --


  -----------------------------------------------------------------------------
  -- drop_external_table - Drop External Table for file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE drop_external_table(
        invoker_schema   IN  VARCHAR2,
        table_name       IN  VARCHAR2,
        parent_operation IN  VARCHAR2 DEFAULT NULL
  );
    --
    -- NAME:
    --   drop_external_table - Drop External Table for file in Object Store
    --
    -- DESCRIPTION:
    --   This procedure drops the specified external table.
    --
    -- PARAMETERS:
    --   invoker_schema   (IN)  - Invoking schema for the procedure
    --
    --   table_name       (IN)  - name of the external table
    --
    --   parent_operation (IN) - parent operation
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- delete_load_operation - Delete a data load operation
  -----------------------------------------------------------------------------
  PROCEDURE delete_load_operation(
        id                IN  NUMBER,
        username          IN  VARCHAR2,
        payload           IN  CLOB,
        retval            OUT NUMBER
  );
    --
    -- NAME:
    --   delete_load_operation - Delete a data load operation
    --
    -- DESCRIPTION:
    --   This procedure deletes a data load operation and the corresponding
    --   cleanup for the operation. The operation ID and the user issuing the
    --   operation are used for the cleanup. The payload has information about
    --   the load operation.
    --
    -- PARAMETERS:
    --   id                (IN)  - ID for the load operation
    --
    --   username          (IN)  - User name for the load operation
    --
    --   payload           (IN)  - Payload for the operation
    --
    --   retval            (IN)  - Return code for the delete operation
    --
    -- NOTES:
    --   The load operation task was created in DBMS_CLOUD package, but the
    --   delete happens in DBMS_CLOUD_INTERNAL for security reasons.
    --


  -----------------------------------------------------------------------------
  -- delete_put_operation - Delete a put object operation
  -----------------------------------------------------------------------------
  PROCEDURE delete_put_operation(
        id                IN  NUMBER,
        username          IN  VARCHAR2,
        payload           IN  CLOB,
        retval            OUT NUMBER
  );
    --
    -- NAME:
    --   delete_put_operation - Delete a put object operation
    --
    -- DESCRIPTION:
    --   This procedure deletes a put object operation and the corresponding
    --   cleanup for the operation. The operation ID and the user issuing the
    --   operation are used for the cleanup. The payload has information about
    --   the put operation.
    --
    -- PARAMETERS:
    --   id                (IN)  - ID for the load operation
    --
    --   username          (IN)  - User name for the load operation
    --
    --   payload           (IN)  - Payload for the operation
    --
    --   retval            (IN)  - Return code for the delete operation
    --
    -- NOTES:
    --   The put operation task was created in DBMS_CLOUD package, but the
    --   delete happens in DBMS_CLOUD_INTERNAL for security reasons.
    --
    --   Added for bug 32698906.
    --


  -----------------------------------------------------------------------------
  -- get_object - Get the contents of an object in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION get_object(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        object_uri       IN  VARCHAR2,
        startOffset      IN  NUMBER   DEFAULT 0,
        endOffset        IN  NUMBER   DEFAULT 0,
        compression      IN  VARCHAR2 DEFAULT NULL
  ) RETURN BLOB;

  PROCEDURE get_object(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
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
    --   in parallel and copied to the local file.
    --
    -- PARAMETERS:
    --   invoker_schema  (IN)  - Invoking schema for the procedure
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           have been created using DBMS_CLOUD.
    --
    --   object_uri      (IN)  - URI of the object existing in Object Store
    --
    --   directory_name  (IN)  - Directory object for local file
    --
    --   file_name       (IN)  - Local file name to put to object store
    --
    --   startOffset     (IN)  - starting offset (in bytes) to read contents
    --
    --   endOffset       (IN)  - end offset (in bytes) to read contents
    --
    --   compression     (IN)  - compression scheme to uncompress the data
    --
    -- RETURNS:
    --   If write to directory object is requested, nothing is returned.
    --   Otherwise contents of the object in Object store are returned as Blob.
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- get_object_tabfunc - Get contents of object in Cloud Store using Raw ptr
  -----------------------------------------------------------------------------
  FUNCTION get_object_tabfunc(
        arguments_ptr    IN  RAW,
        contents_ptr     IN  RAW
  ) RETURN DBMS_CLOUD_TYPES.get_object_ret_tab PIPELINED;
    --
    -- NAME:
    --   get_object_tabfunc - Get contents of object in Cloud Store
    --                        using Raw ptr
    --
    -- DESCRIPTION:
    --   This function is used to get the contents of an object existing in
    --   Cloud Store. The function works as a pipelined table function. The
    --   input arguments can be passed in through the arguments pointer and
    --   output contents are copied in the contents pointer.
    --
    -- PARAMETERS:
    --   arguments_ptr   (IN)  - RAW pointer to pass the input arguments
    --
    --   contents_ptr    (IN)  - RAW pointer to store the object contents
    --
    --
    -- RETURNS:
    --   Table function returns a row with 1 column having value 1 always in
    --   infinite loop. The caller can stop the cursor to end the execution.
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- put_object - Put the contents in an object in Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE put_object(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        object_uri       IN  VARCHAR2,
        contents         IN  BLOB,
        compression      IN  VARCHAR2 DEFAULT NULL
  );

  PROCEDURE put_object(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        object_uri       IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2,
        compression      IN  VARCHAR2 DEFAULT NULL
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
    --   invoker_schema  (IN)  - Invoking schema for the procedure
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           have been created using DBMS_CLOUD.
    --
    --   object_uri      (IN)  - URI of the object existing in Object Store
    --
    --   contents        (IN)  - contents to put in the object in Cloud Store
    --
    --   directory_name  (IN)  - Directory object for local file
    --
    --   file_name       (IN)  - Local file name to put to object store
    --
    --   compression     (IN)  - compression scheme to compress the data
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- put_object_tabfunc - Put contents to Cloud Store using Raw ptr
  -----------------------------------------------------------------------------
  FUNCTION put_object_tabfunc(
        arguments_ptr    IN  RAW,
        contents_ptr     IN  RAW
  ) RETURN DBMS_CLOUD_TYPES.get_object_ret_tab PIPELINED;
    --
    -- NAME:
    --   put_object_tabfunc - Put contents to Cloud Store using Raw ptr
    --
    -- DESCRIPTION:
    --   This function is used to put the contents from a PIHT raw ptr to
    --   cloud store. The input arguments can be passed in through the
    --   arguments pointer and the contents to be uploaded are passed in
    --   via the contents pointer.
    --
    -- PARAMETERS:
    --   arguments_ptr   (IN)  - RAW pointer to pass the input arguments
    --
    --   contents_ptr    (IN)  - RAW pointer to upload to cloud store
    --
    --
    -- RETURNS:
    --   Table function returns a row with 1 column having value 1 always in
    --   infinite loop. The caller can stop the cursor to end the execution.
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- get_metadata - Get the metadata for an object in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION get_metadata(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        object_uri       IN  VARCHAR2,
        external         IN  BOOLEAN   DEFAULT FALSE
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
    --   invoker_schema  (IN)  - Invoking schema for the procedure
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           have been created using DBMS_CLOUD.
    --
    --   object_uri      (IN)  - URI of the object existing in Object Store
    --
    --   external        (IN)  - External customer initiated request
    --                           (default FALSE)
    --
    -- RETURNS:
    --   Metadata for the object in Cloud Store
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- list_objects - List objects at a given location in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION list_objects(
        invoker_schema   IN     VARCHAR2,
        credential_name  IN     VARCHAR2,
        location_uri     IN     VARCHAR2,
        resume_obj       IN     VARCHAR2,
        filter_path      OUT    VARCHAR2,
        list_fields      OUT    DBMS_CLOUD_TYPES.list_object_fields_t,
        nextmarker       IN OUT VARCHAR2
  ) RETURN CLOB;
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
    --   invoker_schema    (IN)  - Invoking schema for the procedure
    --
    --   credential_name   (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           have been created using DBMS_CLOUD.
    --
    --   location_uri      (IN)  - URI of the given location to list objects
    --
    --   resume_obj        (IN)  - if not NULL, then start with returning the
    --                             objectname AFTER the one indicated by
    --                             resume_obj (relative to location_uri);
    --                             if NULL, start with returning the first
    --                             object at the location indicated by
    --                             location_uri
    --
    --
    --   filter_path       (OUT) - Filter path to apply on the object names
    --
    --   list_fields       (OUT) - The field names in the list_objects response
    --
    --    nextmarker    (IN OUT) - The marker parameter on the URI for the
    --                             subsequent Azure request if the list results
    --                             are not complete
    --
    -- RETURNS:
    --   List of URI(s) of object(s) at given location in JSON format
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- list_objects - List objects at a given location in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION list_objects(
        invoker_schema   IN     VARCHAR2,
        credential_name  IN     VARCHAR2,
        location_uri     IN     VARCHAR2,
        resume_obj       IN     VARCHAR2,
        filter_path      OUT    VARCHAR2,
        list_fields      OUT    DBMS_CLOUD_TYPES.list_object_fields_t
  ) RETURN CLOB;
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
    --   invoker_schema    (IN)  - Invoking schema for the procedure
    --
    --   credential_name   (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           have been created using DBMS_CLOUD.
    --
    --   location_uri      (IN)  - URI of the given location to list objects
    --
    --   resume_obj        (IN)  - if not NULL, then start with returning the
    --                             objectname AFTER the one indicated by
    --                             resume_obj (relative to location_uri);
    --                             if NULL, start with returning the first
    --                             object at the location indicated by
    --                             location_uri
    --
    --
    --   filter_path       (OUT) - Filter path to apply on the object names
    --
    --   list_fields       (OUT) - The field names in the list_objects response
    --
    -- RETURNS:
    --   List of URI(s) of object(s) at given location in JSON format
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- list_files - List files at a given directory object location
  -----------------------------------------------------------------------------
  FUNCTION list_files(
        invoker_schema   IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name_filter IN  VARCHAR2
  ) RETURN CLOB;
    --
    -- NAME:
    --   list_files - List files at a given directory object location
    --
    -- DESCRIPTION:
    --   This function is used to list objects at a directory object location.
    --   It requires the invoker to have READ privilege on directory object.
    --
    -- PARAMETERS:
    --   invoker_schema    (IN)  - Invoking schema for the procedure
    --
    --   directory_name    (IN)  - directory object name
    --
    -- RETURNS:
    --   List of files and their sizes in bytes in JSON format
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- list_objects_tabfunc - List objects at a given location in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION list_objects_tabfunc(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        location_uri     IN  VARCHAR2
  ) RETURN DBMS_CLOUD_TYPES.list_object_ret_tab PIPELINED;
    --
    -- NAME:
    --   list_objects - List objects at a given location in Cloud Store table
    --                  function
    --
    -- DESCRIPTION:
    --   This table function is used to list objects at a given location in the
    --   Cloud Store. The location is identified using the URI and access to
    --   the Cloud Store is authenticated using the credential object name.
    --
    -- PARAMETERS:
    --   invoker_schema  (IN)  - Invoking schema for the procedure
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           have been created using DBMS_CLOUD.
    --
    --   location_uri    (IN)  - URI of the given location to list objects
    --
    -- RETURNS:
    --   List of URI(s) of object(s) at given location
    --
    -- NOTES:
    --

  -----------------------------------------------------------------------------
  -- delete_object - Delete an object in Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE delete_object(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
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
    --   invoker_schema  (IN)  - Invoking schema for the procedure
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           have been created using DBMS_CLOUD.
    --
    --   object_uri      (IN)  - URI of the object existing in Object Store
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- generate_partitioning_clause - Generate partitioning clause for CloudSQL
  -----------------------------------------------------------------------------
  FUNCTION generate_partitioning_clause(
        invoker_schema      IN     VARCHAR2,
        credential_name     IN     VARCHAR2,
        table_name          IN     VARCHAR2,
        file_uri_list       IN     CLOB,
        column_list         IN OUT CLOB,
        format_obj          IN     JSON_OBJECT_T,
        partition_array     OUT    JSON_ARRAY_T,
        update_columns      IN     BOOLEAN
  ) RETURN CLOB;
    --
    -- NAME:
    --  generate_partitioning_clause - Generate partitioning clause for CloudSQL
    --
    -- DESCRIPTION:
    --   This function generates a partitioning clause for CloudSQL external
    --   table and returns a partitioning clause string and a partition array
    --
    -- PARAMETERS:
    --   invoker_schema     (IN)     - Invoking schema for the procedure
    --
    --   credential_name    (IN)     - a credential name
    --
    --   table_name         (IN)     - external table name
    --
    --   file_uri_list      (IN)     - file_uri_list
    --
    --   column_list        (IN OUT) - XT table column names and datatypes
    --
    --   format_obj         (IN)     - partition file type and column names
    --
    --   partition_array    (OUT)    - partition locations in a json array to
    --                                 be used by sync_external_part_table
    --
    --   update_columns     (IN)     - check if table columns are out of sync
    --
    -- NOTES: Added for Bug 33016310
    --


  -----------------------------------------------------------------------------
  -- write_file  - Write contents to a local file
  -----------------------------------------------------------------------------
  PROCEDURE write_file(
        invoker_schema     IN  VARCHAR2,
        directory_name     IN  VARCHAR2,
        file_name          IN  VARCHAR2,
        contents           IN  BLOB
  );
    --
    -- NAME:
    --   write_file  - Write contents to a local file
    --
    -- DESCRIPTION:
    --   This procedure is used to write the given data in a local file.
    --
    -- PARAMETERS:
    --   invoker_schema  (IN)  - Invoking schema for the procedure
    --
    --   directory_name  (IN)  - directory object name
    --
    --   file_name       (IN)  - name to local file
    --
    --   contents        (IN)  - contents to write in local file
    --
    -- NOTES:
    --   Added for bug 26402344.
    --


  -----------------------------------------------------------------------------
  -- read_file  - Read contents of a local file
  -----------------------------------------------------------------------------
  FUNCTION read_file(
        invoker_schema   IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2
  ) RETURN BLOB;
    --
    -- NAME:
    --   read_file  - Read contents of a local file
    --
    -- DESCRIPTION:
    --   This procedure is used to read the contents of a local file.
    --
    -- PARAMETERS:
    --   invoker_schema  (IN)  - Invoking schema for the procedure
    --
    --   directory_name  (IN)  - directory object name
    --
    --   file_name       (IN)  - name to local file
    --
    -- RETURNS:
    --   Contents of local file.
    --
    -- NOTES:
    --   Added for bug 26402344.
    --


  -----------------------------------------------------------------------------
  -- delete_file - Delete a file in given directory object location
  -----------------------------------------------------------------------------
  PROCEDURE delete_file(
        invoker_schema    in  VARCHAR2,
        directory_name    IN  VARCHAR2,
        file_name         IN  VARCHAR2
  );
    --
    -- NAME:
    --   delete_file - Delete a file in given directory object location
    --
    -- DESCRIPTION:
    --   This is a helper function to delete a file in a given directory object
    --   location using UTL_FILE. Any exceptions are ignored.
    --
    -- PARAMETERS:
    --   directory_name  (IN)   - Directory object name
    --
    --   file_name       (IN)   - File name to delete
    --
    -- NOTES:
    --   Added for bug 26146301.
    --


  -----------------------------------------------------------------------------
  -- convert_comma_str2qstr - convert command separted string to quoted string
  -----------------------------------------------------------------------------
  FUNCTION convert_comma_str2strlist(
    p_comma_string IN CLOB,
    p_item_string  IN VARCHAR2,
    p_max_length   IN NUMBER
  ) RETURN SYS.ODCIVARCHAR2LIST;
    --
    -- NAME:
    --  convert_comma_str2strlist - convert a string list into string list
    --
    -- DESCRIPTION:
    --   This procedure takes a comma separated list of unquoted string and
    --   convert them into string list.
    --
    -- PARAMETERS:
    --   p_comma_string (IN) - comma separted unquoted string
    --   p_item_string  (IN) - module string name to display in error message
    --   p_max_length   (IN) - maximum length of string allowed
    --
    -- RETURNS:
    --   string list


  -----------------------------------------------------------------------------
  -- cache_rest_api_results - Cache REST API results
  -----------------------------------------------------------------------------
  PROCEDURE cache_rest_api_results(
        username             IN VARCHAR2,
        request_uri          IN VARCHAR2,
        timestamp            IN TIMESTAMP WITH TIME ZONE,
        request_method       IN VARCHAR2,
        request_headers      IN CLOB,
        request_body_text    IN CLOB,
        response_status_code IN NUMBER,
        response_headers     IN CLOB,
        response_body_text   IN CLOB,
        cache_scope          IN VARCHAR2 DEFAULT NULL
  );
    --
    -- NAME:
    --  cache_rest_api_results - Cache REST API results
    --
    -- DESCRIPTION:
    --   This procedures allows users to insert rest api results into the cache
    --   table.
    --
    -- PARMETERS:
    --   username              (IN)  - name of the user who inserts the row
    --   request_uri           (IN)  - request uri
    --   timestamp             (IN)  - cache timestamp
    --   request_method        (IN)  - request method
    --   request_headers       (IN)  - request headers
    --   request_body_text     (IN)  - request body in CLOB
    --   response_status_code  (IN)  - response status code
    --   response_headers      (IN)  - response headers
    --   response_body_text    (IN)  - response body in CLOB
    --   cache_scope           (IN)  - scope of accessing the request result
    --
    -- NOTES:
    --   Added by Bug 31659526.
    --


  -----------------------------------------------------------------------------
  -- set_api_result_cache_size - Update REST API max cache size
  -----------------------------------------------------------------------------
  PROCEDURE set_api_result_cache_size(
        cache_size  IN NUMBER
  );
    --
    -- NAME:
    --  set_api_result_cache_size - Update REST API max cache size
    --
    -- DESCRIPTION:
    --   This procedures allows users to configure the maximum number for the
    --   cache table.
    --
    -- PARMETERS:
    --   cache_size (IN) - cache size input
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
  -- get_api_result_cache_size - Get REST API max cache size
  -----------------------------------------------------------------------------
  FUNCTION get_api_result_cache_size
  RETURN NUMBER;
    --
    -- NAME:
    --  get_api_result_cache_size - Return REST API max cache size
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
  -- check_capability_status - Check capability status
  -----------------------------------------------------------------------------
  FUNCTION check_capability_status(
        capability   IN   VARCHAR2
  ) RETURN BOOLEAN;
    --
    -- NAME:
    --   check_capability_status - Check capability status
    --
    -- DESCRIPTION:
    --   This function checks if the specified capability is enabled or not.
    --
    -- RETURNS:
    --   TRUE  - if capability is enabled
    --   FALSE - if capability is disabled
    --
    -- NOTES:
    --   Added by Bug 32870021.


  -----------------------------------------------------------------------------
  -- log_msg - Log a message
  -----------------------------------------------------------------------------
  PROCEDURE log_msg(
        log_info   CLOB
  );
    --
    -- NAME:
    --   log_msg - Log a message
    --
    -- DESCRIPTION:
    --   This procedure issues the logging sql to record the given log message.
    --
    -- PARAMETERS:
    --   log_info        (IN) - log message
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- log_common - Log a common message. [ Currently the client IP. ]
  -----------------------------------------------------------------------------
  PROCEDURE log_common(
        l_log_json_obj   IN OUT JSON_OBJECT_T
  );
    --
    -- NAME:
    --   log_common - Logger for a common attribute
    --
    -- DESCRIPTION:
    --   This procedure logs a common attribute across several
    --   entry points of DBMS_CLOUD. Currently, it logs the
    --   client IP attribute of the invoking connecction.
    --
    -- PARAMETERS:
    --   l_log_json_obj        (IN OUT) - An existing json object that
    --                                    would be populated with the
    --                                    attribute to be logged.
    --
    -- NOTES: None
    --


  -----------------------------------------------------------------------------
  -- log_credential_op - Log Credential Operation
  -----------------------------------------------------------------------------
  PROCEDURE log_credential_op(
        operation        IN  VARCHAR2,
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        username         IN  VARCHAR2 DEFAULT NULL
  );
    --
    -- NAME:
    --   log_credential_op - Log credential operation
    --
    -- DESCRIPTION:
    --   This procedure logs information related to credential operation
    --
    -- PARAMETERS:
    --   operation       (IN) - type of credential operation
    --   invoker_schema  (IN) - invoker schema name
    --   credential_name (IN) - credential name
    --   username        (IN) - username
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- log_object_op - Log Object Operation
  -----------------------------------------------------------------------------
  PROCEDURE log_object_op(
        operation        IN  VARCHAR2,
        invoker_schema   IN  VARCHAR2,
        request_uri      IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        username         IN  VARCHAR2
  );
    --
    -- NAME:
    --   log_object_op - Log Object Operation
    --
    -- DESCRIPTION:
    --   This procedure logs information related to (GET/PUT/DELETE) object
    --   operation.
    --
    -- PARAMETERS:
    --   operation       (IN) - type of object operation
    --   invoker_schema  (IN) - invoker schema name
    --   request_uri     (IN) - request URI
    --   credential_name (IN) - credential name
    --   username        (IN) - username
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- log_exttab_op - Log External Table Operation
  -----------------------------------------------------------------------------
  PROCEDURE log_exttab_op(
        operation         IN  VARCHAR2,
        invoker_schema    IN  VARCHAR2,
        table_name        IN  VARCHAR2,
        base_table_name   IN  VARCHAR2 DEFAULT NULL,
        base_table_schema IN  VARCHAR2 DEFAULT NULL,
        credential_name   IN  VARCHAR2 DEFAULT NULL,
        parent_operation  IN  VARCHAR2 DEFAULT NULL
  );
    --
    -- NAME:
    --   log_exttab_op - Log External Table Operation
    --
    -- DESCRIPTION:
    --   This procedure logs information related to external table operation.
    --
    -- PARAMETERS:
    --   operation         (IN) - type of external table operation
    --   invoker_schema    (IN) - invoker schema name
    --   table_name        (IN) - external table name
    --   base_table_name   (IN) - base table name
    --   base_table_schema (IN) - base table schema
    --   credential_name   (IN) - credential name
    --   parent_operation  (IN) - parent operation
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- log_file_op - Log File Operation
  -----------------------------------------------------------------------------
  PROCEDURE log_file_op(
        operation        IN  VARCHAR2,
        invoker_schema   IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2
  );
    --
    -- NAME:
    --   log_file_op - Log File Operation
    --
    -- DESCRIPTION:
    --   This procedure logs information related to (GET/PUT/DELETE) file
    --   operations.
    --
    -- PARAMETERS:
    --   operation       (IN) - type of object operation
    --   invoker_schema  (IN) - invoker schema name
    --   directory_name  (IN) - directory_name
    --   file_name       (IN) - file name
    --
    -- NOTES:
    --


END dbms_cloud_internal; -- End of DBMS_CLOUD_INTERNAL Package
/
CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY C##CLOUD$SERVICE.dbms_cloud_internal AS

  -----------------------------------------------------------------------------
  --                      STATIC FUNCTIONS/PROCEDURES
  -----------------------------------------------------------------------------

  ----------------------------
  -- Constants
  ----------------------------
  NEWLINE                  CONSTANT CHAR(1)     := CHR(10);
  M_VCSIZ_32K              CONSTANT PLS_INTEGER := 32767;
  -- Maximum length of cloud store URI
  MAX_URI_LEN              CONSTANT PLS_INTEGER := M_VCSIZ_4K;
  -- Maximum length of username/password associated with credential object
  M_USERNAME_PASSWORD_LEN  CONSTANT PLS_INTEGER := 24000;
  -- Maximum length of key in credential
  M_KEY_LEN                CONSTANT PLS_INTEGER := 24000;
  -- Maximum length of resource principal token
  M_RPST_LEN               CONSTANT PLS_INTEGER := M_KEY_LEN - M_PRIV_KEY - 32;
  -- Maximum length of AWS ARN
  M_AWS_ROLE_ARN           CONSTANT PLS_INTEGER := 2048;
  -- Maximum length of file name
  M_FILE_LEN               CONSTANT PLS_INTEGER := 512;
  -- Maximum chunks in dynamic large object (26^6)
  MAX_DLO_CHUNKS           CONSTANT INTEGER     := POWER(26, 6);

  -- Private Constants for format option JSON keys in
  --   create_external_table / copy_data
  FORMAT_LOGFILE           CONSTANT DBMS_ID := 'logfile';
  FORMAT_BADFILE           CONSTANT DBMS_ID := 'badfile';
  FORMAT_DISCARDFILE       CONSTANT DBMS_ID := 'discardfile';

  -- Default Values of Format Options
  FORMAT_DFLT_RECORD_DELIMITER CONSTANT DBMS_ID := 'DETECTED NEWLINE';
  FORMAT_DFLT_READSIZE         CONSTANT DBMS_ID := '10000000';  --10MB
  FORMAT_DFLT_FIELD_DELIMITER  CONSTANT DBMS_ID := '|';
  FORMAT_DFLT_TRIM_SPACES      CONSTANT DBMS_ID :=
                                                 DBMS_CLOUD.FORMAT_TRIM_NOTRIM;

  -- cached valued of _cloudsql_offload_enabled parameter
  CACHED_OFFLOAD_ENABLED      BOOLEAN := NULL;

  -- bigdata format options
  FORMAT_BD_SKIP_HEADER       CONSTANT DBMS_ID := 'csv.skip.header';
  FORMAT_BD_COMPRESSION       CONSTANT DBMS_ID := 'compressiontype';
  FORMAT_BD_CSV_DELIM         CONSTANT DBMS_ID :=
                              'csv.rowformat.fields.terminator';
  FORMAT_BD_ESCAPED_BY        CONSTANT DBMS_ID :=
                              'csv.rowformat.fields.escapedby';
  FORMAT_BD_QUOTE_CHAR        CONSTANT DBMS_ID :=
                              'csv.rowformat.quotecharacter';
  FORMAT_BD_TYPE_TEXT         CONSTANT DBMS_ID := 'textfile';
  FORMAT_BD_FIELDS            CONSTANT DBMS_ID := 'fields';
  FORMAT_REJECT_NULL          CONSTANT DBMS_ID := 'reject_record';
  FORMAT_REJECT_STORE         CONSTANT DBMS_ID := 'store_null';

  -- Default values for bidata access parameters
  FORMAT_DFLTBD_CSV_ESCAPE_CHR        CONSTANT VARCHAR2(M_IDEN) := '\\';
  FORMAT_DFLTBD_NO_QUOTE_CHR          CONSTANT VARCHAR2(M_IDEN) := '\0';

  --
  -- HTTP GET Response Cache
  --
  CACHED_RESPONSE_RSP               UTL_HTTP.resp;
  CACHED_RESPONSE_URI               CLOB;
  CACHED_RESPONSE_ENDOFFSET         NUMBER  := 0;
  CACHED_RESPONSE_MAXOFFSET         NUMBER  := 0;
  MAX_RANGE_OFFSET         CONSTANT NUMBER  := 128*1024*1024;-- 128MB Range GET
  RESPONSE_CACHING_ENABLED CONSTANT BOOLEAN := TRUE;

  -- JSON Response Query string
  QS_JSON_RESPONSE         CONSTANT DBMS_ID := 'format=json';
  -- Microsoft Azure List Blobs Query String
  QS_MS_AZURE_LIST         CONSTANT DBMS_ID := 'restype=container' ||
                                               CHR(38)|| 'comp=list';
  -- BMC Swift and Amazon S3 Query Strings
  -- * Marker allows one to "restart" a scan from a certain point (actually at
  --     a point just after what the "marker" specifies). The referenced marker
  --     must be "escaped" via UTL_URL.ESCAPE()
  -- * Prefix allows to restrict the scan results to a given prefix path
  QS_MARKER                CONSTANT DBMS_ID := 'marker';
  QS_PREFIX                CONSTANT DBMS_ID := 'prefix';

  -- Oracle BMC Object Store
  QS_ORCL_BMC_LIST         CONSTANT DBMS_ID :=
                               'fields=name,size,md5,timeCreated,timeModified';
  QS_ORCL_BMC_NEXT_START   CONSTANT DBMS_ID := 'start';

  MS_BLOCK_BLOB            CONSTANT DBMS_ID := 'BlockBlob';

  -- Headers
  HEADER_BLOB_TYPE_MS      CONSTANT DBMS_ID := 'x-ms-blob-type';
  HEADER_CONTENT_LENGTH    CONSTANT DBMS_ID := 'Content-Length';
  HEADER_OBJECT_MANIFEST   CONSTANT DBMS_ID := 'X-Object-Manifest';
  HEADER_META_OBJ_MANIFEST CONSTANT DBMS_ID :=
                                             'X-Object-Meta-X-Object-Manifest';
  HEADER_ACCEPT            CONSTANT DBMS_ID := 'Accept';

  GITHUB_ACCEPT_RAW        CONSTANT DBMS_ID :=
                                          'application/vnd.github.v3.raw+json';

  -- Database Properties
  PROPERTY_PATH_PREFIX     CONSTANT DBMS_ID := 'PATH_PREFIX';


  -- Credential operations
  OPER_CREATE_CRED         CONSTANT DBMS_ID := 'create_credential';
  OPER_CRT_NATIVE_CRED     CONSTANT DBMS_ID := 'create_credential_native';
  OPER_UPDATE_CRED         CONSTANT DBMS_ID := 'update_credential';
  OPER_ENABLE_CRED         CONSTANT DBMS_ID := 'enable_credential';
  OPER_DISABLE_CRED        CONSTANT DBMS_ID := 'disable_credential';
  OPER_DROP_CRED           CONSTANT DBMS_ID := 'drop_credential';

  -- Credential attributes
  CREDATTR_USERNAME           CONSTANT DBMS_ID := 'username';
  CREDATTR_PASSWORD           CONSTANT DBMS_ID := 'password';
  CREDATTR_USEROCID           CONSTANT DBMS_ID := 'user_ocid';
  CREDATTR_KEY                CONSTANT DBMS_ID := 'key';
  CREDATTR_TENANCYOCID        CONSTANT DBMS_ID := 'tenancy_ocid';
  CREDATTR_PRIVATEKEY         CONSTANT DBMS_ID := 'private_key';
  CREDATTR_FINGERPRINT        CONSTANT DBMS_ID := 'fingerprint';
  CREDATTR_PASSPHRASE         CONSTANT DBMS_ID := 'passphrase';
  CREDATTR_RPST               CONSTANT DBMS_ID := 'rpst';
  CREDATTR_AWSROLEARN         CONSTANT DBMS_ID := 'aws_role_arn';
  CREDATTR_EXTERNALIDTYPE     CONSTANT DBMS_ID := 'external_id_type';
  CREDATTR_GCPPA              CONSTANT DBMS_ID := 'gcp_pa';

  -- Object operations
  OPER_GET_OBJECT          CONSTANT DBMS_ID := 'get_object';
  OPER_PUT_OBJECT          CONSTANT DBMS_ID := 'put_object';
  OPER_DEL_OBJECT          CONSTANT DBMS_ID := 'delete_object';

  -- File operations
  OPER_READ_FILE           CONSTANT DBMS_ID := 'read_file';
  OPER_WRITE_FILE          CONSTANT DBMS_ID := 'write_file';
  OPER_DEL_FILE            CONSTANT DBMS_ID := 'delete_file';

  -- External table operations
  OPER_CREATE_EXT          CONSTANT DBMS_ID := 'create_external_table';
  OPER_DROP_EXT            CONSTANT DBMS_ID := 'drop_external_table';

  -- External table driver
  EXTTAB_TYPE_LOADER       CONSTANT DBMS_ID  := 'ORACLE_LOADER';
  EXTTAB_TYPE_BIGDATA      CONSTANT DBMS_ID  := 'ORACLE_BIGDATA';
  EXTTAB_TYPE_DATAPUMP     CONSTANT DBMS_ID  := 'ORACLE_DATAPUMP';

  -- Local Type for storing list of format parameters during parsing
  TYPE format_key_list_t IS TABLE OF VARCHAR2(M_VCSIZ_4K) INDEX BY DBMS_ID;

  -- Lockdown DDL clauses default value
  PDB_LOCKDOWN_DDL_CLAUSES CONSTANT NUMBER   := 581626;

  -- SYS user id
  KSYS                     CONSTANT PLS_INTEGER := 0;

  -- Cache variables for list_files
  FS_STORE_NAME            VARCHAR2(M_VCSIZ_4K) := NULL;
  FS_STORE_TYPE            VARCHAR2(M_VCSIZ_4K) := NULL;
  DBFS_TBL_NAME            VARCHAR2(128) := NULL;

  -- REST API Cache
  CACHE_CAPACITY           NUMBER := 10;
  CACHE_MAX_SIZE           CONSTANT NUMBER  := 10000;
  CACHE_SCOPE_PRIVATE      CONSTANT DBMS_ID := 'PRIVATE';
  CACHE_SCOPE_PUBLIC       CONSTANT DBMS_ID := 'PUBLIC';
  CACHE_SCOPE_PRIVATE_ID   CONSTANT NUMBER  := 0;
  CACHE_SCOPE_PUBLIC_ID    CONSTANT NUMBER  := 1;

  -- Passwordless Authentication Credential
  AWS_ARN                  CONSTANT DBMS_ID := 'AWS ARN';
  AWS_DEFAULT_REGION       CONSTANT DBMS_ID := 'us-east-1';
  GCP_PA                   CONSTANT DBMS_ID := 'GCP PA';

  -- Credential parameters
  PARAM_AWS_ROLE_ARN       CONSTANT   DBMS_ID  := 'aws_role_arn';
  PARAM_EXTERNAL_ID_TYPE   CONSTANT   DBMS_ID  := 'external_id_type';
  PARAM_GCP_PA             CONSTANT   DBMS_ID  := 'gcp_pa';


  ----------------------------
  -- Exceptions
  ----------------------------
  invalid_format_key      EXCEPTION;       -- invalid format json key
  invalid_format_value    EXCEPTION;       -- invalid format json value
  duplicate_format_key    EXCEPTION;       -- duplicate format json key

  cred_not_exist EXCEPTION;
  PRAGMA EXCEPTION_INIT(cred_not_exist, -27476);

  cred_exist EXCEPTION;
  PRAGMA EXCEPTION_INIT(cred_exist, -27477);

  cred_disabled EXCEPTION;
  PRAGMA EXCEPTION_INIT(cred_disabled, -27496);

  uri_object_not_found EXCEPTION;
  PRAGMA EXCEPTION_INIT(uri_object_not_found, -20404);

  cred_attr_not_found EXCEPTION;
  PRAGMA EXCEPTION_INIT(cred_attr_not_found, -27469);


  -----------------------------------------------------------------------------
  -- validate_compression_scheme - Validate compression scheme
  -----------------------------------------------------------------------------
  FUNCTION validate_compression_scheme(
    scheme     IN  VARCHAR2
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   validate_compression_scheme - Validate compression scheme
    --
    -- DESCRIPTION:
    --   This procedure validates the compression scheme.
    --
    -- PARAMETERS:
    --   scheme   (IN)  - Compression scheme
    --
    -- RETURNS:
    --   Validated compression scheme
    --
    -- NOTES:
    --
    l_scheme   DBMS_ID;
    l_error    BOOLEAN;
  BEGIN

    IF scheme IS NOT NULL THEN
      IF LENGTH(TRIM(scheme)) != LENGTH(DBMS_CLOUD.COMPRESS_GZIP) THEN
        l_error := TRUE;
      ELSE
        l_scheme := UPPER(TRIM(scheme));
        -- Only AUTO and GZIP is supported
        IF l_scheme != DBMS_CLOUD.COMPRESS_AUTO AND
           l_scheme != DBMS_CLOUD.COMPRESS_GZIP THEN
          l_error := TRUE;
        END IF;
      END IF;
    END IF;

    IF l_error THEN
      raise_application_error(-20000, 'Invalid compression type ' || scheme);
    END IF;

    RETURN l_scheme;

  END validate_compression_scheme;


  -----------------------------------------------------------------------------
  -- validate_bfile  - Validate BFILE locator
  -----------------------------------------------------------------------------
  PROCEDURE validate_bfile(
     bfile      IN  BFILE,
     file_name  IN  VARCHAR2
  )
  IS
    --
    -- NAME:
    --   validate_bfile - Validate BFILE locator
    --
    -- DESCRIPTION:
    --   This procedure is a helper function to validate bfile locator.
    --
    -- PARAMETERS:
    --   bfile      (IN)  - BFILE locator
    --
    --   file_name  (IN)  - file name
    --
    -- NOTES:
    --   Added for bug 30536171.
    --
  BEGIN
    RETURN;
    -- Bug 30536171: Validate bfile points to an existing file
    IF DBMS_LOB.fileexists(bfile) = 0 THEN
      RAISE DBMS_LOB.NOEXIST_DIRECTORY;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      raise_application_error(DBMS_CLOUD.EXCP_FILE_NOT_EXIST,
          'File does not exist - ' || file_name);
  END validate_bfile;


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
 -- enquote_string - Enquote a string value for format parameter
 -----------------------------------------------------------------------------
  FUNCTION enquote_string(
        str              IN  VARCHAR2
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   enquote_string  -  Enquote a string value for format parameter
    --
    -- DESCRIPTION:
    --   This function enquotes a string using single or double quotes,
    --   depending on whether the input string contains double or single
    --   quote.
    --   The default is to use single quotes. If the string contains single
    --   quote already, then it will be enquoted using double quotes.
    --
    --   DBMS_ASSERT.enquote_name is not used for double quoting, because it
    --   checks for matching pair of quote characters and that is not valid
    --   restriction for format json parameters.
    --
    -- PARAMETERS:
    --   str         (IN)   - string type
    --
    -- RETURNS:
    --   Returns the enquoted string
    --
    -- NOTES:
    --   Added for Bug 30290502.
    --
    l_single  INTEGER;
    l_double  INTEGER;
    l_str     DBMS_ID;
  BEGIN
    -- Bug 28210649: allow hex value for delimiter starting with 'X'.
    -- For Hex values, it is assumed that the given value is already
    -- correctly quoted with a prefix of 'X', so do not enquote string.
    -- Eg: X''22'' or 0X'22'
    --
    -- If the string is already quoted with single quotes or double quotes,
    -- then nothing to do for enquoting.
    l_str := UPPER(TRIM(str));
    IF ((SUBSTR(l_str, 1, 1) = 'X' OR
         SUBSTR(l_str, 1, 2) = '0X') AND
        INSTR(l_str, '''', 2, 2) > 2) OR
       (LENGTH(l_str) >= 2 AND
        ((SUBSTR(l_str, 1, 1) = '''' AND SUBSTR(l_str, -1, 1) = '''') OR
         (SUBSTR(l_str, 1, 1) = '"' AND SUBSTR(l_str, -1, 1) = '"')))
    THEN
      RETURN str;
    END IF;

    l_single := INSTR(str, '''');
    l_double := INSTR(str, '"');

    -- Only single quotes in string, then use double quotes
    IF l_single > 0 AND l_double = 0 THEN
      RETURN '"' || str || '"';
    -- Double quote in string, then use single quotes
    -- Bug 28210649: If string has single and double quotes both, then use
    -- single quotes by escaping the existing single quotes in enquote_literal.
    ELSE
      RETURN DBMS_ASSERT.enquote_literal(REPLACE(str, '''', ''''''));
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      RAISE invalid_format_value;
  END enquote_string;


  -----------------------------------------------------------------------------
  -- validate_file_name - Validate file name
  -----------------------------------------------------------------------------
  FUNCTION validate_file_name(
        file_name        IN  VARCHAR2
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   validate_file_name - Validate file name
    --
    -- DESCRIPTION:
    --   This function validates the file name.
    --
    -- PARAMETERS:
    --   file_name       (IN)   - file name
    --
    -- RETURNS:
    --   File name
    --
    -- NOTES:
    --   Added for bug 27447846.
    l_file_name   VARCHAR2(M_FILE_LEN);
  BEGIN

    -- Check for long file name
    IF LENGTH(file_name) > M_FILE_LEN THEN
      raise_application_error(DBMS_CLOUD.EXCP_IDEN_TOO_LONG,
                'File name is too long');
    END IF;

    -- Bug 27447846: File name cannot be a path with slash.
    IF INSTR(file_name, '/') > 0 THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_FILE_NAME,
                'Invalid file name - ' || file_name);
    END IF;

    -- Bug 27821017: Trim whitespaces in file name
    l_file_name := TRIM(file_name);

    -- Bug 30477292: Check for empty file name
    IF l_file_name IS NULL THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_FILE_NAME,
                'Missing file name');
    END IF;

    RETURN l_file_name;

  END validate_file_name;


  -----------------------------------------------------------------------------
  -- validate_ext_credential_name - Validate credential name for external table
  -----------------------------------------------------------------------------
  FUNCTION validate_ext_credential_name(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        os_ext_table     IN  BOOLEAN  DEFAULT FALSE,
        base_cred_owner  IN  VARCHAR2 DEFAULT NULL,
        base_cred_name   IN  VARCHAR2 DEFAULT NULL
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   validate_ext_credential_name - Validate credential for external table
    --
    -- DESCRIPTION:
    --   This function validates the credential name to be used for creation
    --    of external table.
    --
    -- PARAMETERS:
    --   credential_name  (IN)   - credential name
    --
    --   os_ext_table     (IN)   - External table for accessing local files
    --
    --   base_cred_owner  (IN)   - Owner for credential pointed to by synonym
    --
    --   base_cred_name   (IN)   - Name of credential pointed to by synonym
    --
    -- RETURNS:
    --   Returns the validated credential name
    --
    l_credential_name  DBMS_QUOTED_ID;
    l_owner_name       DBMS_QUOTED_ID;
    l_unq_cred_name    DBMS_QUOTED_ID;
    l_dummy            NUMBER;
    l_stmt             VARCHAR2(M_VCSIZ_4K);
  BEGIN

    -- Nothing to validate for OS external table
    -- Bug 28924601: allow NULL credential for pre-auth URLs
    IF os_ext_table OR credential_name IS NULL THEN
      RETURN NULL;
    END IF;

    -- Bug 29167938: Check if credential exists to raise error early
    -- Bug 32516731: If the credential is provided as a synonym, the caller
    -- must have provided with owner/name of the credential, pointed to by
    -- the synonym. So we need to verify the existence of base credential
    -- instead of the synonym.
    l_credential_name := DBMS_CLOUD_CORE.assert_simple_sql_name(
                           credential_name, DBMS_CLOUD_CORE.ASSERT_TYPE_CRED);
    l_owner_name := DBMS_CLOUD_CORE.unquote_name(NVL(base_cred_owner,
                                                     invoker_schema));
    l_unq_cred_name := DBMS_CLOUD_CORE.unquote_name(NVL(base_cred_name,
                                                        credential_name));

    BEGIN
      l_stmt := 'SELECT 1 FROM dba_credentials ' ||
                '  WHERE owner = :1 AND credential_name = :2';
      EXECUTE IMMEDIATE l_stmt INTO l_dummy USING l_owner_name, l_unq_cred_name;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        raise_application_error(DBMS_CLOUD.EXCP_CRED_NOT_EXIST,
          'Credential ' ||
          DBMS_CLOUD_CORE.get_qualified_name(
             l_credential_name, l_owner_name, DBMS_CLOUD_CORE.ASSERT_TYPE_CRED)
          || ' does not exist');
    END;

    -- Bug 30979937: do not enquote credential name with single quotes, it
    -- should be done when adding the credential name to external table sql.
    RETURN l_credential_name;

  END validate_ext_credential_name;


  -----------------------------------------------------------------------------
  -- validate_credential_attribute - Validate Credential Attribute
  -----------------------------------------------------------------------------
  PROCEDURE validate_credential_attribute(
        attribute     IN VARCHAR2,
        value         IN VARCHAR2
  )
  IS
    --
    -- NAME:
    --   validate_credential_attribute - Validate credential attribute
    --
    -- DESCRIPTION:
    --   This procedure validates various attributes of a credential.
    --
    -- PARAMETERS:
    --   attribute      (IN)  - Attribute to validate in the credential object
    --
    --   value      (IN/OUT)  - Attribute value
    --
    -- Attributes can be any of the following:
    --
    --   user_ocid      (IN)  - User OCID
    --
    --   tenancy_ocid   (IN)  - Tenancy OCID for Oracle Bare Metal Cloud store
    --
    --   private_key    (IN)  - RSA Private Key in PEM format for Oracle Bare
    --                           Metal Cloud store. The private key should not
    --                           be encrypted with passphrase.
    --
    --   fingerprint    (IN)  - finger print of RSA Private Key
    --
    --   passphrase     (IN)  - passphrase used to generate the RSA Private Key
    --
    -- RETURNS:
    --
    -- NOTES:
    --   Added for bug 29905394.
    --
    l_max_len    INTEGER;
    l_value_num  NUMBER;
  BEGIN

    IF value IS NULL THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_CRED_ATTR,
        'Missing credential attribute - ' || attribute);
    END IF;

   IF attribute IN (CREDATTR_USEROCID, CREDATTR_TENANCYOCID,
                     CREDATTR_FINGERPRINT, CREDATTR_EXTERNALIDTYPE,
                     CREDATTR_GCPPA)
    THEN
      l_max_len := M_IDEN;
    ELSIF attribute IN (CREDATTR_USERNAME, CREDATTR_PASSWORD) THEN
      -- Limit username/password attribute to 24K characters
      l_max_len := M_USERNAME_PASSWORD_LEN;
    ELSIF attribute = CREDATTR_PRIVATEKEY THEN
      -- Limit private_key attribute to 2000 characters
      l_max_len := M_PRIV_KEY;
    ELSIF attribute = CREDATTR_RPST THEN
      -- Limit rpst attribute to 21968 characters
      l_max_len := M_RPST_LEN;
    ELSIF attribute = CREDATTR_AWSROLEARN THEN
      -- Limit arn attribute to 2048 characters
      l_max_len := M_AWS_ROLE_ARN;
    END IF;

    IF LENGTH(value) > l_max_len THEN
      raise_application_error(DBMS_CLOUD.EXCP_IDEN_TOO_LONG,
         attribute || ' exceeds maximum length (' || l_max_len || ')');
    END IF;

    -- Validate the external id type input
    IF attribute = CREDATTR_EXTERNALIDTYPE AND
       UPPER(TRIM(value)) NOT IN ('DATABASE_OCID',
                                  'COMPARTMENT_OCID',
                                  'TENANT_OCID') THEN
      raise_application_error(-20033,
                              'Invalid external id type - ' || value);
    END IF;

  END validate_credential_attribute;


  -----------------------------------------------------------------------------
  -- sanitize_private_key - Sanize private key
  -----------------------------------------------------------------------------
  FUNCTION sanitize_private_key(
     key              IN  VARCHAR2
  ) RETURN VARCHAR2
  IS
    --
    -- NAME:
    --   sanitize_private_key - Sanitize private key
    --
    -- DESCRIPTION:
    --   This procedure sanitizes the private key value.
    --
    -- PARAMETERS:
    --   key           (IN)  - Private key string
    --
    -- RETURNS:
    --   Sanitized private key value.
    --
    -- NOTES:
    --   Added for bug 30536271.
    --
    l_private_key   VARCHAR2(M_PRIV_KEY);
  BEGIN
    -- Bug 30536271: add extra checks for private key value.
    -- Remove anchor lines beginning with hyphens.
    -- Remove all new line, including \n and CHR(10) characters
    -- Bug 32235203: Fix regex pattern for matching one pair of hyphens
    IF INSTR(key, CHR(10)) > 0 OR
       INSTR(key, CHR(32)) > 0 OR
       INSTR(key, '-----') > 0
    THEN
      l_private_key := REPLACE(
                         REPLACE(REGEXP_REPLACE(key, '-----.*?-----'),
                                 CHR(10)), '\n');
      -- Bug 32921034: Check private key is not null after sanitizing it
      IF l_private_key IS NULL THEN
        raise_application_error(DBMS_CLOUD.EXCP_INVALID_CRED_ATTR,
              'Missing credential attribute - ' || CREDATTR_PRIVATEKEY);
      END IF;

      RETURN l_private_key;

    ELSE
      RETURN key;
    END IF;
  END sanitize_private_key;


  -----------------------------------------------------------------------------
  -- parse_file_uri - Parse file uri list
  -----------------------------------------------------------------------------
  PROCEDURE parse_file_uri(
        file_uri_list IN OUT NOCOPY CLOB,
        os_ext_table  IN            BOOLEAN  DEFAULT FALSE
  )
  IS
    --
    -- NAME:
    --   parse_file_uri - Parse file uri list
    --
    -- DESCRIPTION:
    --   This procedure parses a comma separated list of file uri locations and
    --   generates a comma separated list of quoted file uri's
    --
    -- PARAMETERS:
    --   file_uri_list  (IN/OUT) - File uri list
    --   os_ext_table   (IN)     - Does file uri list consist of OS files ?
    --
    -- NOTES:
    --
    l_file_uri_list  CLOB;
    l_string_list    SYS.ODCIVARCHAR2LIST;
  BEGIN
    l_string_list  := convert_comma_str2strlist(
      p_comma_string => file_uri_list,
      p_item_string  => 'Uri',
      p_max_length   => MAX_URI_LEN);

    FOR i IN 1..l_string_list.COUNT
    LOOP
      -- Bug 27093538: Get qualified URI if the URI doesn't point to OS file
      IF os_ext_table = FALSE THEN
        l_string_list (i) :=
          DBMS_CLOUD_CORE.get_qualified_uri(l_string_list (i));
      END IF;
      IF LENGTH(l_file_uri_list) > 0 THEN
        l_file_uri_list := l_file_uri_list || ',';
      END IF;
      l_file_uri_list := l_file_uri_list || '''' || l_string_list (i) || '''';
    END LOOP;

    -- Bug 30246921: Check for null location
    IF l_file_uri_list IS NULL THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OBJ_URI,
          'Missing file uri list');
    END IF;

    -- Return the quoted comma separated list of file uri's
    file_uri_list := l_file_uri_list;
  END parse_file_uri;


  -----------------------------------------------------------------------------
  -- validate_partitioning_clause - Validate partitioning clause
  -----------------------------------------------------------------------------
  FUNCTION validate_partitioning_clause(
    partitioning_clause   IN  CLOB,
    hybrid_table          IN  BOOLEAN DEFAULT FALSE
  ) RETURN CLOB
  IS
    --
    -- NAME:
    --  validate_partitioning_clause - Validate partitioning clause
    --
    -- DESCRIPTION:
    --   This function validates the partitioning clause for external table
    --   and returns the validated string
    --
    -- PARAMETERS:
    --   partitioning_clause  (IN)     - Partitioning clause as CLOB
    --
    -- NOTES:
    --   Added for bug 30246921.
    --
    l_partitioning_clause   CLOB;
  BEGIN
    l_partitioning_clause := LOWER(TRIM(partitioning_clause));

    -- Check if partitioning clause is empty
    -- We cannot parse the full partitioning clause in PL/SQL, but we can
    -- check for certain keywords necessary for object store partition.
    -- This is not a security check, just simple sanity checks to catch a
    -- potential bad partitioning clause.
    IF (l_partitioning_clause IS NULL OR
        LENGTH(l_partitioning_clause) = 0 OR
        INSTR(l_partitioning_clause, 'partition') != 1 OR
        INSTR(l_partitioning_clause, 'https') = 0 OR
        INSTR(l_partitioning_clause, 'location') = 0)
    THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_PART_CLAUSE,
                'Missing or invalid partitioning clause');
    END IF;

    RETURN TRIM(partitioning_clause);

  END validate_partitioning_clause;


  -----------------------------------------------------------------------------
  -- cloudsql_offload_enabled
  -----------------------------------------------------------------------------
  FUNCTION cloudsql_offload_enabled
  RETURN BOOLEAN
  IS
    --
    -- NAME:
    --  cloudsql_offload_enabled: Check if cloudsql offload is enabled
    --
    -- DESCRIPTION:
    --  return boolean based on param_value of row having param_name of
    --       '_cloudsql_offload_enabled' in  DBMS_CLOUD_CONFIG_PARAM$
    --
    -- RETURNS:
    --   TRUE if offload is enabled, FALSE otherwise
    --
    -- NOTES:
    --
    l_stmt            DBMS_ID;
    l_offload_enabled DBMS_ID := 'FALSE';
  BEGIN
    IF CACHED_OFFLOAD_ENABLED IS NOT NULL THEN
      RETURN CACHED_OFFLOAD_ENABLED;
    END IF;

    CACHED_OFFLOAD_ENABLED := FALSE;

    BEGIN
      l_stmt := 'SELECT upper(param_value) FROM DBMS_CLOUD_CONFIG_PARAM$ ' ||
                'WHERE param_name=''_cloudsql_offload_enabled''';
      EXECUTE IMMEDIATE l_stmt INTO l_offload_enabled;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    IF l_offload_enabled = 'TRUE' THEN
      CACHED_OFFLOAD_ENABLED := TRUE;
    END IF;

    RETURN CACHED_OFFLOAD_ENABLED;
  END cloudsql_offload_enabled;


  -----------------------------------------------------------------------------
  -- use_bigdata_driver - Determines if bigdata driver should be used
  -----------------------------------------------------------------------------
  FUNCTION use_bigdata_driver(
    format_obj      IN  JSON_OBJECT_T,
    base_table      IN  VARCHAR2,
    file_uri_list   IN  CLOB
  ) RETURN BOOLEAN
  IS
    --
    -- NAME:
    --   use_bigdata_driver - Use bigdata driver
    --
    -- DESCRIPTION:
    --   This function determines which one of bigdata driver or oracle loader
    -- should be used.
    --
    -- PARAMETERS:
    --   format_obj      (IN)  - Format parameters json as a clob
    --
    --   base_table      (IN)  - Determines if copy_table
    --
    --   file_uri_list   (IN)  - List of remote objects
    --
    -- RETURNS:
    --   TRUE if bigdata driver, FALSE otherwise
    --
    -- NOTES:
    --
    l_format_obj        JSON_OBJECT_T;
    l_format_keys       JSON_KEY_LIST;
    l_key               DBMS_ID;
    l_key_lower         DBMS_ID;
    l_str               DBMS_ID;
    l_format_type       DBMS_ID;
    l_loader_param      BOOLEAN := FALSE;
  BEGIN

    l_format_obj     := format_obj;
    l_format_keys    := l_format_obj.get_keys;
    l_format_type    := UPPER(get_json_string(l_format_obj,
                              DBMS_CLOUD.FORMAT_TYPE));

    -- First check the type. parquet, orc and avro goes directly to bigdata
    IF l_format_type IN (DBMS_CLOUD.FORMAT_TYPE_AVRO,
                         DBMS_CLOUD.FORMAT_TYPE_PARQUET,
                         DBMS_CLOUD.FORMAT_TYPE_ORC) THEN
      RETURN TRUE;
    END IF;

    -- any type not in the above list, csv or csv without embedded should go
    -- automatically to oracle loader
    IF l_format_type IS NOT NULL AND
       l_format_type NOT IN (DBMS_CLOUD.FORMAT_TYPE_CSV,
                             DBMS_CLOUD.FORMAT_TYPE_CSV_WITHOUT_EMBEDDED) THEN
      RETURN FALSE;
    END IF;

    -- Copy data should be back to loader
    IF TRIM(base_table) IS NOT NULL THEN
      RETURN FALSE;
    END IF;

    -- If empty format JSON, then do not access the parameters
    IF l_format_keys IS NOT NULL THEN

      -- Loop over all the keys and return upon finding the first unsupported
      FOR i IN 1..l_format_keys.COUNT  LOOP

        -- Get current key and also store lower case key for comparison
        l_key       := TRIM(l_format_keys(i));
        l_key_lower := LOWER(l_key);

        -- Process the key
        CASE l_key_lower

        WHEN 'enable_offload' THEN
          -- Bug 33080744: Check if this has to be offloaded
          -- The allowed values are true/false (false by default)
          -- If present it overrides everything.
          RETURN get_json_boolean(l_format_obj, l_key);

        -- only ignoremissingcolumns:true is accepted in bigdata driver
        WHEN DBMS_CLOUD.FORMAT_IGN_MISSING_COLS THEN
          IF NOT get_json_boolean(l_format_obj, l_key) THEN
            l_loader_param := TRUE;
          END IF;

        -- characterset:utf-8 is accepted in bigdata driver
        WHEN DBMS_CLOUD.FORMAT_CHARACTERSET THEN
          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NULL OR LOWER(l_str) NOT IN ('utf-8', 'utf8') THEN
            l_loader_param := TRUE;
          END IF;

        ELSE
          IF l_key_lower IN ( DBMS_CLOUD.FORMAT_TYPE,
                              DBMS_CLOUD.FORMAT_BLANK_AS_NULL,
                              DBMS_CLOUD.FORMAT_COMPRESSION,
                              DBMS_CLOUD.FORMAT_CONVERSION_ERRORS,
                              DBMS_CLOUD.FORMAT_DATE,
                              DBMS_CLOUD.FORMAT_FIELD_DELIMITER,
                              DBMS_CLOUD.FORMAT_ESCAPE,
                              DBMS_CLOUD.FORMAT_IGN_BLANK_LINES,
                              DBMS_CLOUD.FORMAT_QUOTE,
                              DBMS_CLOUD.FORMAT_REMOVE_QUOTES,
                              DBMS_CLOUD.FORMAT_SKIP_HEADERS,
                              DBMS_CLOUD.FORMAT_TIMESTAMP,
                              DBMS_CLOUD.FORMAT_TIMESTAMP_LTZ,
                              DBMS_CLOUD.FORMAT_TIMESTAMP_TZ,
                              DBMS_CLOUD.FORMAT_TRIM_SPACES,
                              DBMS_CLOUD.FORMAT_TRUNCATE_COLUMNS,
                              DBMS_CLOUD.FORMAT_REJECT_LIMIT,
                              DBMS_CLOUD.FORMAT_IGN_MISSING_COLS,
                              DBMS_CLOUD.FORMAT_CHARACTERSET,
                              DBMS_CLOUD.FORMAT_RECORD_DELIMITER,
                              DBMS_CLOUD.FORMAT_LOG_DIR,
                              DBMS_CLOUD.FORMAT_LOG_PREFIX,
                              DBMS_CLOUD.FORMAT_LOG_RETENTION,
                              'enable_offload') THEN
            CONTINUE;
          ELSE
            l_loader_param := TRUE;
          END IF;

        END CASE;

      END LOOP;

    END IF;

    IF NOT cloudsql_offload_enabled() OR l_loader_param THEN
       RETURN FALSE;
    END IF;

    -- If we got this far we passed all validations and we should use bd
    RETURN TRUE;

  EXCEPTION
    WHEN invalid_format_value THEN
      raise_application_error(-20000,
             'Invalid format parameter: Bad value for ' || l_key);
  END use_bigdata_driver;


  -----------------------------------------------------------------------------
  -- add_default_bd_access_parameters - Add Default ACCESS PARAMETERS for
  --                                    Oracle Big Data Driver
  -----------------------------------------------------------------------------
  PROCEDURE add_default_bd_access_parameters(
        format_obj          IN      JSON_OBJECT_T,
        key_list            IN      format_key_list_t,
        prefix              IN      VARCHAR2,
        access_parameters   IN OUT  CLOB
  )
  IS
    --
    -- NAME:
    --   add_default_bd_access_parameters - add default ACCESS PARAMETERS
    --                                     for Oracle Big Data Driver
    --
    -- DESCRIPTION:
    --   This function adds the default ACCESS PARAMETERS for external table.
    --
    -- PARAMETERS:
    --   format_obj          (IN)     - Format parameters json as a clob
    --
    --   key_list            (IN)     - Array of keys in the format json
    --
    --   prefix              (IN)     - Default prefix for the parameters
    --
    --   access_patameters   (IN/OUT) - PARAMETERS for external table
    --
    -- NOTES:
    --
    l_format_type         DBMS_ID;
  BEGIN

    l_format_type := UPPER(format_obj.get_string(DBMS_CLOUD.FORMAT_TYPE));

    IF ((NOT key_list.EXISTS(DBMS_CLOUD.FORMAT_TYPE)) OR
       get_json_string(format_obj, key_list(DBMS_CLOUD.FORMAT_TYPE)) IS NULL)
    THEN
      -- default field delimiter set to '|'
      IF (NOT key_list.EXISTS(DBMS_CLOUD.FORMAT_FIELD_DELIMITER)) THEN
        access_parameters := access_parameters || NEWLINE ||
        prefix || FORMAT_BD_CSV_DELIM || '=' ||
        DBMS_ASSERT.enquote_literal(FORMAT_DFLT_FIELD_DELIMITER);
      END IF;

    END IF;

    -- trimspaces defaulted to FORMAT_TRIM_NOTRIM
    IF (NOT key_list.EXISTS(DBMS_CLOUD.FORMAT_TRIM_SPACES)) THEN
      access_parameters := access_parameters || NEWLINE ||
        prefix || DBMS_CLOUD.FORMAT_TRIM_SPACES || '=' ||
        LOWER(FORMAT_DFLT_TRIM_SPACES);
    END IF;

  END add_default_bd_access_parameters;


  -----------------------------------------------------------------------------
  -- add_default_access_parameters - Add Default ACCESS PARAMETERS for Oracle
  --                                    Loader
  -----------------------------------------------------------------------------
  PROCEDURE add_default_access_parameters(
        format_obj          IN      JSON_OBJECT_T,
        key_list            IN      format_key_list_t,
        dflt_diag_file      IN      VARCHAR2,
  os_ext_table        IN      BOOLEAN,
        record_parameters   IN OUT  CLOB,
        field_parameters    IN OUT  CLOB
  )
  IS
    --
    -- NAME:
    --   add_default_access_parameters - add default ACCESS PARAMETERS
    --                                     for Oracle Loader
    --
    -- DESCRIPTION:
    --   This function adds the default ACCESS PARAMETERS for external table.
    --
    -- PARAMETERS:
    --   format_obj          (IN)     - Format parameters json as a clob
    --
    --   key_list            (IN)     - Array of keys in the format json
    --
    --   dflt_diag_file      (IN)     - Default diag file prefix
    --
    --   os_ext_table        (IN)     - OS external table
    --
    --   record_parameters   (IN/OUT) - RECORD PARAMETERS for external table
    --
    --   field_parameters    (IN/OUT) - FIELD  PARAMETERS for external table
    --
    -- NOTES:
    --
    l_str      VARCHAR2(M_VCSIZ_4K);
  BEGIN

    -- Default RECORD DELIMITER
    IF (NOT key_list.EXISTS(DBMS_CLOUD.FORMAT_RECORD_DELIMITER)) THEN
      record_parameters := record_parameters || 'DELIMITED BY ' ||
                                    FORMAT_DFLT_RECORD_DELIMITER || ' ';
    END IF;

    -- Default LOGFILE
    IF (NOT key_list.EXISTS(FORMAT_LOGFILE)) THEN
      IF dflt_diag_file IS NULL THEN
        l_str := 'NOLOGFILE';
      ELSE
        l_str := 'LOGFILE ' ||
                 DBMS_ASSERT.enquote_literal(dflt_diag_file || '_%p.log');
      END IF;
      record_parameters := record_parameters || l_str || ' ';
    END IF;

    -- Default BADFILE
    IF (NOT key_list.EXISTS(FORMAT_BADFILE)) THEN
      IF dflt_diag_file IS NULL THEN
        l_str := 'NOBADFILE';
      ELSE
        l_str := 'BADFILE ' ||
                 DBMS_ASSERT.enquote_literal(dflt_diag_file || '_%p.bad');
      END IF;
      record_parameters := record_parameters || l_str || ' ';
    END IF;

    -- Default DISCARDFILE
    IF (NOT key_list.EXISTS(FORMAT_DISCARDFILE)) THEN
      record_parameters := record_parameters || 'NODISCARDFILE ';
    END IF;

    -- Default READSIZE
    -- Bug 29254622: Do not use default readsize for OS external table
    IF (os_ext_table = FALSE AND
  NOT key_list.EXISTS(DBMS_CLOUD.FORMAT_READSIZE)) THEN
      record_parameters := record_parameters || 'READSIZE=' ||
                                    FORMAT_DFLT_READSIZE || ' ';
    END IF;

    -- Default FIELD DELIMITER
    IF ((NOT key_list.EXISTS(DBMS_CLOUD.FORMAT_FIELD_DELIMITER))
        AND
        ((NOT key_list.EXISTS(DBMS_CLOUD.FORMAT_TYPE)) OR
        get_json_string(format_obj, key_list(DBMS_CLOUD.FORMAT_TYPE)) IS NULL))
    THEN
      -- Add field delimiter clause at the beginning of field parameters
      field_parameters := 'TERMINATED BY ' ||
             DBMS_ASSERT.enquote_literal(FORMAT_DFLT_FIELD_DELIMITER) || ' ' ||
             field_parameters || ' ';
    END IF;

    -- Default TRIM SPACES
    IF (NOT key_list.EXISTS(DBMS_CLOUD.FORMAT_TRIM_SPACES)) THEN
      field_parameters := field_parameters || FORMAT_DFLT_TRIM_SPACES || ' ';
    END IF;

  END add_default_access_parameters;


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
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_FORMAT,
                'Format argument is not a valid JSON');
  END parse_format_parameters;


  -----------------------------------------------------------------------------
  -- gen_partition_access_parameters - generate partition access parameters
  -----------------------------------------------------------------------------
  FUNCTION gen_partition_access_parameters(
        credential_schema   IN     VARCHAR2,
        credential_name     IN     VARCHAR2,
        partition_columns   IN     JSON_ARRAY_T,
        prefix              IN     DBMS_ID,
        file_uri_list       IN     CLOB,
        access_parameters   IN     CLOB
  ) RETURN CLOB
  IS
    --
    -- NAME:
    --  gen_partition_access_parameters - Generate partition access parameters
    --
    -- DESCRIPTION:
    --   This function appends additional access parameters to the existing
    --   access parameter string
    --
    -- PARAMETERS:
    --   credential_schema  (IN)     - credential schema name
    --   credential_name    (IN)     - credential name
    --   partition_columns  (IN)     - partitioning columns
    --   prefix             (IN)     - prefix coming from the caller
    --   file_uri_list      (IN)     - file_uri_list
    --   access_parameters  (IN)     - CLOB representing the ACCESS PARAMETERS
    --                                 lause for Bigdata driver
    -- NOTES:
    --   Added for bug 33016310.
    --
    COMMA               CONSTANT CHAR(1) := ',';
    DOUBLE_QUOTE        CONSTANT CHAR(1) := '"';
    SINGLE_QUOTE        CONSTANT CHAR(1) := '''';
    DOT_SIGN            CONSTANT CHAR(1) := '.';
    UNDERSCORE_SIGN     CONSTANT CHAR(1) := '_';
    l_partition_columns JSON_ARRAY_T;
    l_partition_cols    JSON_ARRAY_T;
    l_access_parameters CLOB;
    l_tmpstr            CLOB;
    l_file_columns      DBMS_ID;
    l_cred_schema       DBMS_ID;
    l_cred_name         DBMS_ID;

  BEGIN

    l_partition_cols := partition_columns;
    l_access_parameters:= access_parameters;

    -- generate partition columns string from partition_columns array
    IF prefix IS NULL THEN
      l_tmpstr := REPLACE(l_partition_cols.stringify, DOUBLE_QUOTE,
        SINGLE_QUOTE);
      l_tmpstr := DBMS_ASSERT.enquote_name(l_tmpstr, FALSE);
      l_file_columns := REPLACE(DBMS_CLOUD.FORMAT_BD_FILENAME_CL, DOT_SIGN,
        UNDERSCORE_SIGN);
      l_cred_schema := REPLACE(DBMS_CLOUD.FORMAT_BD_CRED_SCHEMA, DOT_SIGN,
        UNDERSCORE_SIGN);
      l_cred_name := REPLACE(DBMS_CLOUD.FORMAT_BD_CRED_NAME, DOT_SIGN,
        UNDERSCORE_SIGN);
    ELSE
      l_tmpstr := l_partition_cols.stringify;
      l_file_columns := DBMS_CLOUD.FORMAT_BD_FILENAME_CL;
      l_cred_schema := DBMS_CLOUD.FORMAT_BD_CRED_SCHEMA;
      l_cred_name := DBMS_CLOUD.FORMAT_BD_CRED_NAME;
    END IF;

    -- appends partition_columns access parameter
    l_access_parameters := l_access_parameters || NEWLINE || prefix ||
      l_file_columns || '=' || l_tmpstr || ' ';

    -- appends file_uri_list access parameter
    l_tmpstr := DOUBLE_QUOTE || file_uri_list || DOUBLE_QUOTE;
    l_access_parameters := l_access_parameters || NEWLINE || prefix ||
      DBMS_CLOUD.FORMAT_FILE_URI_LIST || '=' || l_tmpstr || ' ';

    -- appends credential.schema access parameter
    l_access_parameters := l_access_parameters || NEWLINE || prefix ||
      l_cred_schema || '=' || credential_schema || ' ';

    -- appends credential.name access parameter
    l_access_parameters := l_access_parameters || NEWLINE || prefix ||
      l_cred_name || '=' || credential_name || ' ';

    RETURN l_access_parameters;

  END gen_partition_access_parameters;


  -----------------------------------------------------------------------------
  -- get_bigdata_access_parameters - Get ACCESS PARAMETERS for Bigdata driver
  -----------------------------------------------------------------------------
  PROCEDURE get_bigdata_access_parameters(
        format_obj          IN  JSON_OBJECT_T,
        credential_schema   IN  VARCHAR2,
        credential_name     IN  VARCHAR2,
        file_uri_list       IN  CLOB,
        field_list          IN  CLOB,
        access_parameters   OUT CLOB,
        reject_limit_clause OUT VARCHAR2,
        schema_strategy     OUT VARCHAR2,
        part_in_file_uri    IN  BOOLEAN
  )
  IS
    --
    -- NAME:
    --  get_bigdata_access_parameters - Get ACCESS PARAMETERS for Bigdata drv
    --
    -- DESCRIPTION:
    --   This function parses the format parameters JSON and generates the
    --   ACCESS PARAMETERS clause for Bigdata driver
    --
    -- PARAMETERS:
    --   format_obj          (IN)  - Format parameters JSON as a clob
    --
    --   credential_schema   (IN)  - Credential schema name
    --
    --   credential_name     (IN)  - Credential name
    --
    --   dflt_diag_file      (IN)  - Default value for diag file name prefix
    --
    --   file_uri_list       (IN)  - Saved in com.oracle.bigdata.file_uri_list
    --
    --   field_list          (IN)  - Field_list for External table (optional).
    --                               This value identifies the fields in the
    --                               external file.
    --   access_parameters   (OUT) - CLOB representing the ACCESS PARAMETERS
    --                               clause for Bigdata driver
    --
    --   reject_limit_clause (OUT) - REJECT LIMIT clause
    --
    --   schema_strategy     (OUT) - The column schema strategy
    --
    -- NOTES:
    --
    l_format_obj        JSON_OBJECT_T;
    l_format_keys       JSON_KEY_LIST;
    l_format_key_list   format_key_list_t;
    l_key               DBMS_ID;
    l_key_lower         DBMS_ID;
    l_str               DBMS_ID;
    l_prefix            DBMS_ID;
    l_format_type       DBMS_ID;
    l_partition_columns JSON_ARRAY_T := NULL;
  BEGIN

    l_prefix := DBMS_CLOUD.FORMAT_BD_PREFIX;
    l_format_obj     := format_obj;
    l_format_keys    := l_format_obj.get_keys;

    l_format_type := UPPER(l_format_obj.get_string(DBMS_CLOUD.FORMAT_TYPE));

    IF l_format_type IS NOT NULL AND
       l_format_type NOT IN (DBMS_CLOUD.FORMAT_TYPE_AVRO,
                             DBMS_CLOUD.FORMAT_TYPE_PARQUET,
                             DBMS_CLOUD.FORMAT_TYPE_ORC,
                             DBMS_CLOUD.FORMAT_TYPE_CSV) THEN
      raise invalid_format_value;
    END IF;

    -- Enh#33016310: get partition_columns
    IF part_in_file_uri THEN
      IF l_format_obj.get_type(DBMS_CLOUD.FORMAT_PARTITION_COLUMNS) = 'ARRAY'
      THEN
        l_partition_columns :=
        TREAT(l_format_obj.get(DBMS_CLOUD.FORMAT_PARTITION_COLUMNS) AS
              JSON_ARRAY_T);
      END IF;
    END IF;

    -- basic parameters for bigdata driver.
    IF credential_name IS NOT NULL AND NOT part_in_file_uri THEN
      access_parameters := l_prefix || DBMS_CLOUD.FORMAT_BD_CRED_NAME ||
          '=' || credential_name;
    END IF;

    access_parameters := access_parameters || NEWLINE ||
        l_prefix || DBMS_CLOUD.FORMAT_BD_FILE_FORMAT || '=';

    -- IF we are dealing with a CSV then we send filetype as textfile
    IF l_format_type IS NULL OR
       l_format_type = DBMS_CLOUD.FORMAT_TYPE_CSV THEN
      IF l_partition_columns IS NULL THEN
        access_parameters := access_parameters || FORMAT_BD_TYPE_TEXT;
      ELSE
        access_parameters := access_parameters || LOWER(l_format_type);
      END IF;
    ELSE
      access_parameters := access_parameters || LOWER(l_format_type);
    END IF;

    -- If empty format JSON, then do not access the parameters
    IF l_format_keys IS NOT NULL THEN

      --
      -- Loop over all the Keys
      --
      FOR i IN 1..l_format_keys.COUNT  LOOP

        -- Get current key and also store lower case key for comparison
        l_key       := TRIM(l_format_keys(i));
        l_key_lower := LOWER(l_key);

        -- Validate the key length
        IF LENGTH(l_key) > M_IDEN THEN
          RAISE invalid_format_key;
        END IF;

        -- Check for duplicate Key
        IF l_format_key_list.EXISTS(l_key_lower) THEN
          RAISE duplicate_format_key;
        END IF;
        l_format_key_list(l_key_lower) := l_key;

        IF l_format_type IS NULL OR
           l_format_type = DBMS_CLOUD.FORMAT_TYPE_CSV THEN

          -- Process the key
          CASE l_key_lower

          -- TYPE
          WHEN DBMS_CLOUD.FORMAT_TYPE THEN
            -- Type was validated already let it pass
            CONTINUE;

          -- blankasnull: true/false
          WHEN DBMS_CLOUD.FORMAT_BLANK_AS_NULL THEN
            l_str := get_json_string(l_format_obj, l_key);

            IF l_str IS NOT NULL THEN
              l_str := LOWER(l_str);
              IF  l_str <> 'true' AND l_str <> 'false' THEN
                RAISE invalid_format_value;
              END IF;
              access_parameters := access_parameters || NEWLINE
                  || l_prefix || DBMS_CLOUD.FORMAT_BLANK_AS_NULL
                  || '=' || l_str;
            END IF;

          -- compression: auto|gzip|zlib|bzip2
          WHEN DBMS_CLOUD.FORMAT_COMPRESSION THEN
            l_str := UPPER(get_json_string(l_format_obj, l_key));
            IF l_str IS NOT NULL THEN
              IF l_str NOT IN (DBMS_CLOUD.COMPRESS_AUTO,
                               DBMS_CLOUD.COMPRESS_GZIP,
                               DBMS_CLOUD.COMPRESS_ZLIB,
                               DBMS_CLOUD.COMPRESS_BZIP2)
              THEN
                RAISE invalid_format_value;
              END IF;

              -- if it is auto we pass detect
              IF l_str = DBMS_CLOUD.COMPRESS_AUTO THEN
                l_str := DBMS_CLOUD.COMPRESS_DETECT;
              END IF;

              access_parameters := access_parameters || NEWLINE ||
                  l_prefix || FORMAT_BD_COMPRESSION || '=' ||
                  LOWER(l_str);
            END IF;

          -- conversionerrors: reject_record | store_null
          WHEN DBMS_CLOUD.FORMAT_CONVERSION_ERRORS THEN
            l_str := LOWER(get_json_string(l_format_obj, l_key));
            IF l_str IS NOT NULL THEN
              IF l_str NOT IN (FORMAT_REJECT_NULL,
                               FORMAT_REJECT_STORE)
              THEN
                RAISE invalid_format_value;
              END IF;
              access_parameters := access_parameters || NEWLINE ||
                  l_prefix || DBMS_CLOUD.FORMAT_CONVERSION_ERRORS || '=' ||
                  l_str;
            END IF;

          -- dateformat: AUTO or date format
          WHEN DBMS_CLOUD.FORMAT_DATE THEN
            l_str := get_json_string(l_format_obj, l_key);
            IF l_str IS NOT NULL THEN
              access_parameters := access_parameters || NEWLINE ||
                  l_prefix || DBMS_CLOUD.FORMAT_DATE || '=' ||
                  DBMS_ASSERT.enquote_literal(l_str);
            END IF;

          -- delimiter: defaults to '|'
          WHEN DBMS_CLOUD.FORMAT_FIELD_DELIMITER THEN
            l_str := get_json_string(l_format_obj, l_key, FALSE);

            IF l_str IS NOT NULL THEN
              IF UPPER(TRIM(l_str)) = DBMS_CLOUD.FORMAT_DELIMITER_WHITESPACE
              THEN
                l_str := DBMS_CLOUD.FORMAT_DELIMITER_WHITESPACE;
              ELSE
                l_str := enquote_string(l_str);
              END IF;

              access_parameters := access_parameters || NEWLINE ||
              l_prefix || FORMAT_BD_CSV_DELIM || '=' || l_str;
            END IF;

          -- escape: '\' will be used if true
          WHEN DBMS_CLOUD.FORMAT_ESCAPE THEN
            IF get_json_boolean(l_format_obj, l_key) THEN
              access_parameters := access_parameters || NEWLINE ||
                  l_prefix || FORMAT_BD_ESCAPED_BY || '=' ||
                  DBMS_ASSERT.enquote_literal(FORMAT_DFLTBD_CSV_ESCAPE_CHR);
            END IF;

          -- ignoreblanklines true/false
          WHEN DBMS_CLOUD.FORMAT_IGN_BLANK_LINES THEN
            l_str := get_json_string(l_format_obj, l_key);

            IF l_str IS NOT NULL THEN
              l_str := LOWER(l_str);
              IF  l_str <> 'true' AND l_str <> 'false'  THEN
                RAISE invalid_format_value;
              END IF;
              access_parameters := access_parameters || NEWLINE
                  || l_prefix || DBMS_CLOUD.FORMAT_IGN_BLANK_LINES
                  || '=' || l_str;
            END IF;

          -- quote com.oracle.bigdata.csv.rowformat.quotecharacter
          WHEN DBMS_CLOUD.FORMAT_QUOTE THEN
            l_str := get_json_string(l_format_obj, l_key);
            IF l_str IS NULL THEN
              l_str := FORMAT_DFLTBD_NO_QUOTE_CHR;
            END IF;

            access_parameters := access_parameters || NEWLINE ||
              l_prefix || FORMAT_BD_QUOTE_CHAR || '=' ||
              enquote_string(l_str);

          -- removequotes: true/false
          WHEN DBMS_CLOUD.FORMAT_REMOVE_QUOTES THEN
            l_str := get_json_string(l_format_obj, l_key);
            l_str := LOWER(l_str);
            IF  l_str <> 'true' AND l_str <> 'false'  THEN
              RAISE invalid_format_value;
            END IF;
            access_parameters := access_parameters || NEWLINE ||
                  l_prefix || DBMS_CLOUD.FORMAT_REMOVE_QUOTES ||
                  '=' || l_str;

          -- skipheaders, 0 if not specified 1 if specified without a value
          WHEN DBMS_CLOUD.FORMAT_SKIP_HEADERS THEN
            l_str := get_json_string(l_format_obj, l_key);
            access_parameters := access_parameters || NEWLINE ||
                l_prefix || FORMAT_BD_SKIP_HEADER || '=' ||
                NVL(l_str, '1');

          -- timestampformat: auto or timestamp format
          WHEN DBMS_CLOUD.FORMAT_TIMESTAMP THEN
            l_str := get_json_string(l_format_obj, l_key);
            IF l_str IS NOT NULL THEN
              access_parameters := access_parameters || NEWLINE ||
                  l_prefix || DBMS_CLOUD.FORMAT_TIMESTAMP || '=' ||
                  DBMS_ASSERT.enquote_literal(l_str);
            END IF;

          -- timestampltzformat: auto or timestamp with local tz format
          WHEN DBMS_CLOUD.FORMAT_TIMESTAMP_LTZ THEN
            l_str := get_json_string(l_format_obj, l_key);
            IF l_str IS NOT NULL THEN
              access_parameters := access_parameters || NEWLINE ||
                  l_prefix || DBMS_CLOUD.FORMAT_TIMESTAMP_LTZ || '=' ||
                  DBMS_ASSERT.enquote_literal(l_str);
            END IF;

          -- timestamptzformat: auto or timestamp with tz format
          WHEN DBMS_CLOUD.FORMAT_TIMESTAMP_TZ THEN
            l_str := get_json_string(l_format_obj, l_key);
            IF l_str IS NOT NULL THEN
              access_parameters := access_parameters || NEWLINE ||
                  l_prefix || DBMS_CLOUD.FORMAT_TIMESTAMP_TZ || '=' ||
                  DBMS_ASSERT.enquote_literal(l_str);
            END IF;

          -- trimspaces
          -- rtrim| ltrim| notrim| lrtrim| ldrtrim
          WHEN DBMS_CLOUD.FORMAT_TRIM_SPACES THEN
            l_str := UPPER(get_json_string(l_format_obj, l_key));
            IF l_str IS NOT NULL AND
               l_str NOT IN (DBMS_CLOUD.FORMAT_TRIM_RTRIM,
                             DBMS_CLOUD.FORMAT_TRIM_LTRIM,
                             DBMS_CLOUD.FORMAT_TRIM_NOTRIM,
                             DBMS_CLOUD.FORMAT_TRIM_LRTRIM,
                             DBMS_CLOUD.FORMAT_TRIM_LDRTRIM)
            THEN
              RAISE invalid_format_value;
            END IF;
            access_parameters := access_parameters || NEWLINE ||
                l_prefix || DBMS_CLOUD.FORMAT_TRIM_SPACES || '=' ||
                LOWER(NVL(l_str, FORMAT_DFLT_TRIM_SPACES));

          -- truncatecol: true/false
          WHEN DBMS_CLOUD.FORMAT_TRUNCATE_COLUMNS THEN
            l_str := get_json_string(l_format_obj, l_key);
            l_str := LOWER(l_str);
            IF  l_str <> 'true' AND l_str <> 'false' THEN
              RAISE invalid_format_value;
            END IF;
            access_parameters := access_parameters || NEWLINE ||
                  l_prefix || DBMS_CLOUD.FORMAT_TRUNCATE_COLUMNS ||
                  '=' || l_str;

          -- recorddelimiter
          -- accept the parameter but don't send anything to the driver
          WHEN DBMS_CLOUD.FORMAT_RECORD_DELIMITER THEN
            CONTINUE;

          -- ignoremissingcolumns
          -- accept the parameter but don't send anything to the driver
          WHEN DBMS_CLOUD.FORMAT_IGN_MISSING_COLS THEN
            CONTINUE;

          -- characterset
          WHEN DBMS_CLOUD.FORMAT_CHARACTERSET THEN
            l_str := get_json_string(l_format_obj, l_key);
            l_str := LOWER(l_str);
            access_parameters := access_parameters || NEWLINE ||
                  l_prefix || DBMS_CLOUD.FORMAT_CHARACTERSET ||
                  '=' || l_str;

          -- REJECT LIMIT (reject limit)
          WHEN DBMS_CLOUD.FORMAT_REJECT_LIMIT THEN
            l_str := get_json_string(l_format_obj, l_key);
            IF l_str IS NOT NULL THEN
              reject_limit_clause := 'REJECT LIMIT ' || l_str || ' ';
            END IF;

          -- Log Directory object (logdir)
          WHEN DBMS_CLOUD.FORMAT_LOG_DIR THEN
            NULL;

          -- Log retention (logretention)
          WHEN DBMS_CLOUD.FORMAT_LOG_RETENTION THEN
            NULL;

          -- Log prefix (logprefix)
          WHEN DBMS_CLOUD.FORMAT_LOG_PREFIX THEN
            NULL;

          -- Enable cell offloading (enable_offload)
          WHEN 'enable_offload' THEN
            NULL;

          -- Enh#33016310: partition_columns is a legit format key
          WHEN DBMS_CLOUD.FORMAT_PARTITION_COLUMNS THEN
            IF part_in_file_uri THEN
              access_parameters := gen_partition_access_parameters(
                                     credential_schema => credential_schema,
                                     credential_name   => credential_name,
                                     partition_columns => l_partition_columns,
                                     prefix            => l_prefix,
                                     file_uri_list     => file_uri_list,
                                     access_parameters => access_parameters
                                   );
            END IF;

          ELSE -- CASE ELSE
            RAISE invalid_format_key;

          END CASE;

        ELSIF l_format_type IN (DBMS_CLOUD.FORMAT_TYPE_AVRO,
                                DBMS_CLOUD.FORMAT_TYPE_PARQUET,
                                DBMS_CLOUD.FORMAT_TYPE_ORC) THEN

          CASE l_key_lower

          -- TYPE
          WHEN DBMS_CLOUD.FORMAT_TYPE THEN
            -- Type was validated already let it pass
            CONTINUE;

          -- SCHEMA (schema strategy)
          WHEN DBMS_CLOUD.FORMAT_BD_SCHEMA THEN

            schema_strategy := LOWER(get_json_string(l_format_obj, l_key));

            -- valid options are 'none', 'first' and 'all'
            IF schema_strategy IS NOT NULL AND
               schema_strategy NOT IN (DBMS_CLOUD.FORMAT_BD_SCHEMA_NONE,
                                       DBMS_CLOUD.FORMAT_BD_SCHEMA_FIRST,
                                       DBMS_CLOUD.FORMAT_BD_SCHEMA_ALL)
            THEN
              RAISE invalid_format_value;
            END IF;

          -- REJECT LIMIT (reject limit)
          WHEN DBMS_CLOUD.FORMAT_REJECT_LIMIT THEN
            l_str := get_json_string(l_format_obj, l_key);
            IF l_str IS NOT NULL THEN
              reject_limit_clause := 'REJECT LIMIT ' || l_str || ' ';
            END IF;

          -- Log Directory object (logdir)
          WHEN DBMS_CLOUD.FORMAT_LOG_DIR THEN
            NULL;

          -- Log retention (logretention)
          WHEN DBMS_CLOUD.FORMAT_LOG_RETENTION THEN
            NULL;

          -- Log prefix (logprefix)
          WHEN DBMS_CLOUD.FORMAT_LOG_PREFIX THEN
            NULL;

          -- Enh#33016310: partition_columns is a legit format key
          WHEN DBMS_CLOUD.FORMAT_PARTITION_COLUMNS THEN
            IF part_in_file_uri THEN
              access_parameters := gen_partition_access_parameters(
                                     credential_schema => credential_schema,
                                     credential_name   => credential_name,
                                     partition_columns => l_partition_columns,
                                     prefix            => l_prefix,
                                     file_uri_list     => file_uri_list,
                                     access_parameters => access_parameters
                                   );
            END IF;

          ELSE -- CASE ELSE
            RAISE invalid_format_key;

          END CASE;

        END IF;

      END LOOP;

    END IF;

    -- Process FIELD_LIST
    IF field_list IS NOT NULL THEN
      access_parameters := access_parameters || NEWLINE ||
                           l_prefix || FORMAT_BD_FIELDS || '=' ||
                           '( ' || field_list || ' )';
    END IF;

    -- DEFAULT value for schema
    -- Bug 29038654: schema defaults to "FIRST"
    IF schema_strategy IS NULL THEN
      schema_strategy := DBMS_CLOUD.FORMAT_BD_SCHEMA_FIRST;
    END IF;

    add_default_bd_access_parameters(
          format_obj        => l_format_obj,
          key_list          => l_format_key_list,
          prefix            => l_prefix,
          access_parameters => access_parameters
    );

    -- DEFAULT value for reject limit
    IF (NOT l_format_key_list.EXISTS(DBMS_CLOUD.FORMAT_REJECT_LIMIT)) THEN
      IF l_format_type IN (DBMS_CLOUD.FORMAT_TYPE_AVRO,
                           DBMS_CLOUD.FORMAT_TYPE_PARQUET,
                           DBMS_CLOUD.FORMAT_TYPE_ORC) THEN
        reject_limit_clause := 'REJECT LIMIT UNLIMITED';
      ELSE
        reject_limit_clause := 'REJECT LIMIT 0';
      END IF;
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

    WHEN OTHERS THEN
      RAISE;
  END get_bigdata_access_parameters;


  -----------------------------------------------------------------------------
  -- get_datapump_access_parameters - Get ACCESS PARAMETERS for Datapump driver
  -----------------------------------------------------------------------------
  PROCEDURE get_datapump_access_parameters(
        format_obj          IN  JSON_OBJECT_T,
        credential_name     IN  VARCHAR2,
        dflt_diag_file      IN  VARCHAR2,
        export_query        IN  CLOB,
        access_parameters   OUT CLOB,
        reject_limit_clause OUT VARCHAR2,
        schema_strategy     OUT VARCHAR2
  )
  IS
    --
    -- NAME:
    --  get_datapump_access_parameters - Get ACCESS PARAMETERS for Datapump drv
    --
    -- DESCRIPTION:
    --   This function parses the format parameters JSON and generates the
    --   ACCESS PARAMETERS clause for Datapump driver.
    --
    -- PARAMETERS:
    --   format_obj          (IN)  - Format parameters JSON as a clob
    --
    --   credential_name     (IN)  - Credential name
    --
    --   dflt_diag_file      (IN)  - Default value for diag file name prefix
    --
    --   export_query        (IN)  - Select query for exporting data
    --
    --   access_parameters   (OUT) - CLOB representing the ACCESS PARAMETERS
    --                               clause for Datapump driver
    --
    --   reject_limit_clause (OUT) - REJECT LIMIT clause
    --
    --   schema_strategy     (OUT) - The column schema strategy
    --
    -- NOTES:
    --
    l_format_obj        JSON_OBJECT_T;
    l_format_keys       JSON_KEY_LIST;
    l_format_key_list   format_key_list_t;
    l_key               DBMS_ID;
    l_key_lower         DBMS_ID;
    l_str               DBMS_ID;
    l_dummy             NUMBER;
  BEGIN

    l_format_obj     := format_obj;
    l_format_keys    := l_format_obj.get_keys;
    schema_strategy  := NULL;

    -- If empty format JSON, then do not access the parameters
    IF l_format_keys IS NOT NULL THEN

      --
      -- Loop over all the Keys
      --
      FOR i IN 1..l_format_keys.COUNT  LOOP

        -- Get current key and also store lower case key for comparison
        l_key       := TRIM(l_format_keys(i));
        l_key_lower := LOWER(l_key);

        -- Validate the key length
        IF LENGTH(l_key) > M_IDEN THEN
          RAISE invalid_format_key;
        END IF;

        -- Check for duplicate key
        IF l_format_key_list.EXISTS(l_key_lower) THEN
          RAISE duplicate_format_key;
        END IF;
        l_format_key_list(l_key_lower) := l_key;


        -- Process the key
        CASE l_key_lower

        -- TYPE (type)
        WHEN DBMS_CLOUD.FORMAT_TYPE THEN
          l_str := UPPER(get_json_string(l_format_obj, l_key));
          DBMS_CLOUD_CORE.assert(l_str = DBMS_CLOUD.FORMAT_TYPE_DATAPUMP,
                                 'get_datapump_access_parameters',
                                 'Invalid format type - ' || l_str);

        -- ENCRYPTION (encryption)
        -- WHEN DBMS_CLOUD.FORMAT_ENCRYPTION THEN

        --  IF get_json_boolean(l_format_obj, l_key) THEN
        --    access_parameters := access_parameters || 'ENCRYPTION ENABLED ';
        --  END IF;

        -- COMPRESSION (compression)
        WHEN DBMS_CLOUD.FORMAT_COMPRESSION THEN
          -- Only allowed for exporting data
          IF export_query IS NULL THEN
            RAISE invalid_format_key;
          END IF;

          l_str := UPPER(get_json_string(l_format_obj, l_key));
          IF l_str IS NOT NULL THEN
            -- Validate the value for compression
            IF l_str NOT IN (DBMS_CLOUD.COMPRESS_BASIC,
                             DBMS_CLOUD.COMPRESS_LOW,
                             DBMS_CLOUD.COMPRESS_MEDIUM,
                             DBMS_CLOUD.COMPRESS_HIGH)
            THEN
              RAISE invalid_format_value;
            END IF;

            access_parameters := access_parameters ||
                                       'COMPRESSION ENABLED ' ||
                                       UPPER(l_str) || ' ';
          END IF;

        -- VERSION (version)
        WHEN DBMS_CLOUD.FORMAT_VERSION THEN
          -- Only allowed for exporting data
          IF export_query IS NULL THEN
            RAISE invalid_format_key;
          END IF;

          l_str := UPPER(get_json_string(l_format_obj, l_key));
          IF l_str IS NOT NULL THEN
            -- Version should be COMPATIBLE, LATEST or an Oracle release number
            IF l_str IN (DBMS_CLOUD.VERSION_COMPATIBLE,
                         DBMS_CLOUD.VERSION_LATEST) THEN
              access_parameters := access_parameters || 'VERSION ' ||
                                        l_str ||' ';
            ELSE
              BEGIN
                -- Oracle release number should contain digits or period (.)
                -- Bug 31208792: Disallow spaces, +/- in Oracle release number
                l_dummy := TO_NUMBER(TRANSLATE(l_str, '.0123456789',
                                               RPAD('1', 11, '1')));
                IF REGEXP_COUNT(l_str, '\.') > 4 THEN
                  RAISE invalid_format_value;
                END IF;

              EXCEPTION
                WHEN value_error THEN
                  RAISE invalid_format_value;
              END;

              access_parameters := access_parameters || 'VERSION ' ||
                                   DBMS_ASSERT.enquote_literal(l_str) || ' ';
            END IF;
          END IF;

        -- SCHEMA
        WHEN DBMS_CLOUD.FORMAT_BD_SCHEMA THEN
          schema_strategy := LOWER(get_json_string(l_format_obj, l_key));

          -- valid options are 'none', 'first' and 'all'
          IF schema_strategy IS NOT NULL AND
             schema_strategy NOT IN (DBMS_CLOUD.FORMAT_BD_SCHEMA_NONE,
                                     DBMS_CLOUD.FORMAT_BD_SCHEMA_FIRST,
                                     DBMS_CLOUD.FORMAT_BD_SCHEMA_ALL)
          THEN
            RAISE invalid_format_value;
          END IF;

        -- REJECT LIMIT (reject limit)
        WHEN DBMS_CLOUD.FORMAT_REJECT_LIMIT THEN
          -- Only allowed for importing data
          IF export_query IS NOT NULL THEN
            RAISE invalid_format_key;
          END IF;

          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NOT NULL THEN
            reject_limit_clause := 'REJECT LIMIT ' || l_str || ' ';
          END IF;

        -- Log Directory object (logdir)
        WHEN DBMS_CLOUD.FORMAT_LOG_DIR THEN
          NULL;

        -- Log retention (logretention)
        WHEN DBMS_CLOUD.FORMAT_LOG_RETENTION THEN
          NULL;

        -- Log prefix (logprefix)
        WHEN DBMS_CLOUD.FORMAT_LOG_PREFIX THEN
          NULL;

        -- DEFAULT Case
        ELSE
          RAISE invalid_format_key;

        END CASE;

      END LOOP;

    END IF;


    -- Add CREDENTIAL parameter
    -- Bug 30979937: enquote name as datapump external table expects
    -- case sensitive name.
    IF credential_name IS NOT NULL THEN
      access_parameters := access_parameters || 'CREDENTIAL ' ||
                           DBMS_ASSERT.enquote_name(credential_name) || ' ';
    END IF;

    -- Default LOGFILE
    IF (NOT l_format_key_list.EXISTS(FORMAT_LOGFILE)) THEN
      IF dflt_diag_file IS NULL THEN
        l_str := 'NOLOGFILE';
      ELSE
        l_str := 'LOGFILE ' ||
                 DBMS_ASSERT.enquote_literal(dflt_diag_file || '_%p.log');
      END IF;
      access_parameters := access_parameters || l_str || ' ';
    END IF;

    -- DEFAULT value for schema
    IF schema_strategy IS NULL THEN
      schema_strategy := DBMS_CLOUD.FORMAT_BD_SCHEMA_FIRST;
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

    WHEN OTHERS THEN
      RAISE;
  END get_datapump_access_parameters;


  -----------------------------------------------------------------------------
  -- get_access_parameters  - Get ACCESS PARAMETERS clause for Oracle Loader
  -----------------------------------------------------------------------------
  PROCEDURE get_access_parameters(
        format_obj          IN  JSON_OBJECT_T,
        credential_schema   IN  VARCHAR2,
        credential_name     IN  VARCHAR2,
        file_uri_list       IN  CLOB,
        field_list          IN  CLOB,
        dflt_diag_file      IN  VARCHAR2,
        os_ext_table        IN  BOOLEAN,
        access_parameters   OUT CLOB,
        reject_limit_clause OUT VARCHAR2,
        part_in_file_uri    BOOLEAN
  )
  IS
    --
    -- NAME:
    --   get_access_parameters - Get ACCESS PARAMETERS clause for Oracle Loader
    --
    -- DESCRIPTION:
    --   This function parses the format parameters JSON and generates the
    --   ACCESS PARAMETERS clause for Oracle Loader.
    --
    -- PARAMETERS:
    --   format_obj          (IN)  - Format parameters json as a clob
    --
    --   credential_schema   (IN)  - Credential schema name
    --
    --   credential_name     (IN)  - Credential name
    --
    --   file_uri_list       (IN)  - File URI list
    --
    --   dflt_diag_file      (IN)  - Default value for diag file name prefix
    --
    --   os_ext_table        (IN)  - OS external table
    --
    --   access_parameters   (OUT) - CLOB representing the ACCESS PARAMETERS
    --                               clause for Oracle Loader
    --
    --   reject_limit_clause (OUT) - REJECT LIMIT clause
    --
    --   part_in_file_uri    (IN)  - Partitioning columns in file uri
    --
    -- NOTES:
    --
    l_format_obj        JSON_OBJECT_T;
    l_format_keys       JSON_KEY_LIST;
    l_format_key_list   format_key_list_t;
    l_record_parameters CLOB;
    l_field_parameters  CLOB;
    l_field_delim_cls   CLOB;
    l_quote_cls         CLOB;
    l_key               DBMS_ID;
    l_key_lower         DBMS_ID;
    l_str               DBMS_ID;
    l_prefix            DBMS_ID;
    l_partition_columns JSON_ARRAY_T := NULL;
  BEGIN

    l_format_obj     := format_obj;
    l_format_keys    := l_format_obj.get_keys;

    -- Enh#33016310: get partition_columns
    IF part_in_file_uri THEN
      l_prefix := DBMS_CLOUD.FORMAT_BD_PREFIX;
      IF l_format_obj.get_type(DBMS_CLOUD.FORMAT_PARTITION_COLUMNS) = 'ARRAY'
      THEN
        l_partition_columns :=
        TREAT(l_format_obj.get(DBMS_CLOUD.FORMAT_PARTITION_COLUMNS) AS
              JSON_ARRAY_T);
      END IF;
    END IF;

    -- If empty format JSON, then do not access the parameters
    IF l_format_keys IS NOT NULL THEN

      --
      -- Loop over all the Keys
      --
      FOR i IN 1..l_format_keys.COUNT  LOOP

        -- Get current key and also store lower case key for comparison
        l_key       := TRIM(l_format_keys(i));
        l_key_lower := LOWER(l_key);

        -- Validate the key length
        IF LENGTH(l_key) > M_IDEN THEN
          RAISE invalid_format_key;
        END IF;

        -- Check for duplicate key
        IF l_format_key_list.EXISTS(l_key_lower) THEN
          RAISE duplicate_format_key;
        END IF;
        l_format_key_list(l_key_lower) := l_key;


        -- Process the key
        CASE l_key_lower

        --
        -- RECORD FORMAT INFO clause
        --

        -- RECORD DELIMITER (delimited by)
        WHEN DBMS_CLOUD.FORMAT_RECORD_DELIMITER THEN
          l_str := get_json_string(l_format_obj, l_key, FALSE);
          IF l_str IS NOT NULL THEN
            l_record_parameters := l_record_parameters || 'DELIMITED BY ' ||
                                         l_str || ' ';
          END IF;

        -- CHARACTERSET
        WHEN DBMS_CLOUD.FORMAT_CHARACTERSET THEN
          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NOT NULL THEN
            l_record_parameters := l_record_parameters || 'CHARACTERSET ' ||
                                       l_str || ' ';
          END IF;

        -- SKIP HEADERS (ignore_header)
        WHEN DBMS_CLOUD.FORMAT_SKIP_HEADERS THEN
          l_str := get_json_string(l_format_obj, l_key);
          l_record_parameters := l_record_parameters || 'IGNORE_HEADER=' ||
                                        NVL(l_str, '1') || ' ';

        -- ESCAPE (escape)
        WHEN DBMS_CLOUD.FORMAT_ESCAPE THEN
          IF get_json_boolean(l_format_obj, l_key) THEN
            l_record_parameters := l_record_parameters || 'ESCAPE ';
          END IF;

        -- IGNORE BLANK LINES (ignore_blank_lines)
        WHEN DBMS_CLOUD.FORMAT_IGN_BLANK_LINES THEN
          IF get_json_boolean(l_format_obj, l_key) THEN
            l_record_parameters := l_record_parameters ||
                                        'IGNORE_BLANK_LINES ';
          END IF;

        -- READSIZE (readsize)
        WHEN DBMS_CLOUD.FORMAT_READSIZE THEN
          l_str := get_json_string(l_format_obj, l_key);
          l_record_parameters := l_record_parameters || 'READSIZE=' ||
                                       NVL(l_str, FORMAT_DFLT_READSIZE) || ' ';

        -- COMPRESSION (compression)
        WHEN DBMS_CLOUD.FORMAT_COMPRESSION THEN
          l_str := UPPER(get_json_string(l_format_obj, l_key));
          IF l_str IS NOT NULL THEN
            -- Validate the value for compression
            IF l_str NOT IN (DBMS_CLOUD.COMPRESS_AUTO,
                             DBMS_CLOUD.COMPRESS_GZIP,
                             DBMS_CLOUD.COMPRESS_ZLIB,
                             DBMS_CLOUD.COMPRESS_BZIP2)
            THEN
              RAISE invalid_format_value;
            END IF;

            -- Bug 26201095: AUTO should mapped to DETECT
            IF l_str = DBMS_CLOUD.COMPRESS_AUTO THEN
              l_str := 'DETECT';
            END IF;

            l_record_parameters := l_record_parameters || 'COMPRESSION ' ||
                                        l_str || ' ';
          END IF;

        -- LANGUAGE (language)
        WHEN DBMS_CLOUD.FORMAT_LANGUAGE THEN
          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NOT NULL THEN
            l_record_parameters := l_record_parameters || 'LANGUAGE ' ||
                                       l_str || ' ';
          END IF;

        -- TERRITORY (territory)
        WHEN DBMS_CLOUD.FORMAT_TERRITORY THEN
          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NOT NULL THEN
            l_record_parameters := l_record_parameters || 'TERRITORY ' ||
                                       l_str || ' ';
          END IF;

        -- ENDIAN (endian)
        WHEN DBMS_CLOUD.FORMAT_ENDIAN THEN
          l_str := UPPER(get_json_string(l_format_obj, l_key));
          IF l_str IS NOT NULL THEN
            -- Validate the value of endian
            IF l_str NOT IN (DBMS_CLOUD.FORMAT_BIG_ENDIAN,
                             DBMS_CLOUD.FORMAT_LITTLE_ENDIAN)
            THEN
              RAISE invalid_format_value;
            END IF;

            l_record_parameters := l_record_parameters || 'DATA IS ' ||
                                       l_str || ' ENDIAN ';
          END IF;


        --
        -- FIELD DEFINITIONS clause
        --

        -- TYPE (csv with embedded)
        WHEN DBMS_CLOUD.FORMAT_TYPE THEN
          l_str := UPPER(get_json_string(l_format_obj, l_key));
          IF l_str IS NOT NULL AND
             l_str NOT IN (DBMS_CLOUD.FORMAT_TYPE_JSON,
                           DBMS_CLOUD.FORMAT_TYPE_EJSON)
          THEN
            -- Validate the value for type
            IF l_str NOT IN (DBMS_CLOUD.FORMAT_TYPE_CSV,
                             DBMS_CLOUD.FORMAT_TYPE_CSV_WITH_EMBEDDED)
            THEN
              RAISE invalid_format_value;
            END IF;

            -- Bug 26338156: CSV should be mapped to 'CSV WITHOUT EMBEDDED'
            IF l_str = DBMS_CLOUD.FORMAT_TYPE_CSV THEN
              l_str := 'CSV WITHOUT EMBEDDED';
            END IF;

            l_field_parameters := l_field_parameters || l_str || ' ';
          END IF;

        -- FIELD DELIMETER (terminated by)
        WHEN DBMS_CLOUD.FORMAT_FIELD_DELIMITER THEN
          l_str := get_json_string(l_format_obj, l_key, FALSE);
          IF l_str IS NOT NULL THEN
            -- Bug 28002819: Treat WHITESPACE as a special keyword in delimiter
            IF UPPER(TRIM(l_str)) = DBMS_CLOUD.FORMAT_DELIMITER_WHITESPACE THEN
              l_str := DBMS_CLOUD.FORMAT_DELIMITER_WHITESPACE;
            ELSE
              -- Bug 28210649: use enquote string for properly handling quotes
              l_str := enquote_string(l_str);
            END IF;

            l_field_delim_cls := 'TERMINATED BY ' || l_str;
          END IF;

        -- QUOTE (optionally enclosed by)
        WHEN DBMS_CLOUD.FORMAT_QUOTE THEN
          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NOT NULL THEN
            -- Bug 28211042: use enquote string for properly handling quotes
            l_quote_cls := 'OPTIONALLY ENCLOSED BY ' ||
                           enquote_string(l_str) ||
                           l_quote_cls;
          END IF;

        WHEN DBMS_CLOUD.FORMAT_END_QUOTE THEN
          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NOT NULL THEN
            -- Bug 28211042: use enquote string for properly handling quotes
            l_quote_cls := l_quote_cls || ' AND ' ||
                           enquote_string(l_str);
          END IF;

        -- IGNORE MISSING COLUMNS (missing field values are null)
        WHEN DBMS_CLOUD.FORMAT_IGN_MISSING_COLS THEN
          IF get_json_boolean(l_format_obj, l_key) THEN
            l_field_parameters := l_field_parameters ||
                                        'MISSING FIELD VALUES ARE NULL ';
          END IF;

        -- TRUNCATE COLUMNS (truncate_columns)
        WHEN DBMS_CLOUD.FORMAT_TRUNCATE_COLUMNS THEN
          IF get_json_boolean(l_format_obj, l_key) THEN
            l_field_parameters := l_field_parameters || 'TRUNCATE_COLUMNS ';
          END IF;

        -- REMOVE QUOTES (remote_quotes)
        WHEN DBMS_CLOUD.FORMAT_REMOVE_QUOTES THEN
          IF get_json_boolean(l_format_obj, l_key) THEN
            l_field_parameters := l_field_parameters || 'REMOVE_QUOTES ';
          END IF;

        -- BLANK AS NULL (nullif blanks)
        WHEN DBMS_CLOUD.FORMAT_BLANK_AS_NULL THEN
          IF get_json_boolean(l_format_obj, l_key) THEN
            l_field_parameters := l_field_parameters || 'NULLIF=BLANKS ';
          END IF;

        -- TRIM SPACES (trim_spec)
        WHEN DBMS_CLOUD.FORMAT_TRIM_SPACES THEN
          l_str := UPPER(get_json_string(l_format_obj, l_key));
          -- Bug 25923294: validate the value of trim_spec
          IF l_str IS NOT NULL AND
             l_str NOT IN (DBMS_CLOUD.FORMAT_TRIM_NOTRIM,
                           DBMS_CLOUD.FORMAT_TRIM_LTRIM,
                           DBMS_CLOUD.FORMAT_TRIM_RTRIM,
                           DBMS_CLOUD.FORMAT_TRIM_LRTRIM,
                           DBMS_CLOUD.FORMAT_TRIM_LDRTRIM)
          THEN
            RAISE invalid_format_value;
          END IF;
          l_field_parameters := l_field_parameters ||
                                    NVL(l_str, FORMAT_DFLT_TRIM_SPACES) || ' ';

        -- DATE FORMAT (data_format date mask)
        WHEN DBMS_CLOUD.FORMAT_DATE THEN
          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NOT NULL THEN
            l_field_parameters := l_field_parameters ||
                                     'DATE_FORMAT DATE MASK ' ||
                                     DBMS_ASSERT.enquote_literal(l_str) || ' ';
          END IF;

        -- TIMESTAMP FORMAT (data_format timestamp mask)
        WHEN DBMS_CLOUD.FORMAT_TIMESTAMP THEN
          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NOT NULL THEN
            l_field_parameters := l_field_parameters ||
                                     'DATE_FORMAT TIMESTAMP MASK ' ||
                                     DBMS_ASSERT.enquote_literal(l_str) || ' ';
          END IF;

        -- TIMESTAMP WITH TIME ZONE FORMAT(data_format timestamp with timezone)
        WHEN DBMS_CLOUD.FORMAT_TIMESTAMP_TZ THEN
          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NOT NULL THEN
            l_field_parameters := l_field_parameters ||
                                     'DATE_FORMAT TIMESTAMP WITH TIME ZONE ' ||
                                     DBMS_ASSERT.enquote_literal(l_str) || ' ';
          END IF;

        -- TIMESTAMP WITH LOCAL TIME ZONE FORMAT
        --    (data_format timestamp with local time zone)
        WHEN DBMS_CLOUD.FORMAT_TIMESTAMP_LTZ THEN
          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NOT NULL THEN
            l_field_parameters := l_field_parameters ||
                               'DATE_FORMAT TIMESTAMP WITH LOCAL TIME ZONE ' ||
                               DBMS_ASSERT.enquote_literal(l_str) || ' ';
          END IF;

        -- CONVERSION ERRORS (convert_error)
        WHEN DBMS_CLOUD.FORMAT_CONVERSION_ERRORS THEN
          l_str := UPPER(get_json_string(l_format_obj, l_key));
          IF l_str IS NOT NULL THEN
            IF l_str NOT IN (DBMS_CLOUD.FORMAT_CONVERR_REJECT_RECORD,
                             DBMS_CLOUD.FORMAT_CONVERR_STORE_NULL)
            THEN
              RAISE invalid_format_value;
            END IF;
            l_field_parameters := l_field_parameters ||
                                        'CONVERT_ERROR ' || l_str || ' ';
          END IF;

        -- NUMERIC CHARACTERS (numeric_characters)
        WHEN DBMS_CLOUD.FORMAT_NUMERIC_CHARS THEN
          -- Bug 30291055: Do not trim whitespaces
          l_str := get_json_string(l_format_obj, l_key, FALSE);
          IF l_str IS NOT NULL THEN
            -- The value should be only 2 characters.
            -- The characters cannot be any numeric character or any of +,-,>,<
            IF LENGTH(l_str) > 2 OR
               REGEXP_INSTR(l_str, '.*[-+<>0-9].*') > 0
            THEN
              RAISE invalid_format_value;
            END IF;

            -- Bug 30290502: The value can have single quote, so use double
            -- quotes to enquote the value
            l_field_parameters := l_field_parameters ||
                                       'NUMERIC_CHARACTERS ' ||
                                       enquote_string(l_str) || ' ';
          END IF;

        -- NUMBER FORMAT (number_format)
        WHEN DBMS_CLOUD.FORMAT_NUMBER_FORMAT THEN
          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NOT NULL THEN
            l_field_parameters := l_field_parameters ||
                                     'NUMBER_FORMAT ' ||
                                     DBMS_ASSERT.enquote_literal(l_str) || ' ';
          END IF;

        -- REJECT LIMIT (reject limit)
        WHEN DBMS_CLOUD.FORMAT_REJECT_LIMIT THEN
          l_str := get_json_string(l_format_obj, l_key);
          IF l_str IS NOT NULL THEN
            reject_limit_clause := 'REJECT LIMIT ' || l_str || ' ';
          END IF;

        -- UNPACKARRAYS (unpackarrays)
        WHEN DBMS_CLOUD.FORMAT_UNPACKARRAYS THEN
          l_str := get_json_string(l_format_obj, l_key);

        -- JSONPATH (jsonpath)
        WHEN DBMS_CLOUD.FORMAT_JSON_PATH THEN
          NULL;

        -- DOCMAXSIZE (docmaxsize)
        WHEN DBMS_CLOUD.FORMAT_JSON_DOC_MAXSIZE THEN
          NULL;

        -- KEYPATH (keypath)
        WHEN 'keypath' THEN
          NULL;

        -- KEYASSIGNMENT (keyassignment)
        WHEN 'keyassignment' THEN
          NULL;

        -- Log Directory object (logdir)
        WHEN DBMS_CLOUD.FORMAT_LOG_DIR THEN
          NULL;

        -- Log retention (logretention)
        WHEN DBMS_CLOUD.FORMAT_LOG_RETENTION THEN
          NULL;

        -- Log prefix (logprefix)
        WHEN DBMS_CLOUD.FORMAT_LOG_PREFIX THEN
          NULL;

        -- Enable cell offloading (enable_offload)
        WHEN 'enable_offload' THEN
          NULL;

        -- Enh#33016310: partition_columns is a legit format key
        WHEN DBMS_CLOUD.FORMAT_PARTITION_COLUMNS THEN
          IF part_in_file_uri THEN
            access_parameters := gen_partition_access_parameters(
                                   credential_schema => credential_schema,
                                   credential_name   => credential_name,
                                   partition_columns => l_partition_columns,
                                   prefix            => NULL,
                                   file_uri_list     => file_uri_list,
                                   access_parameters => access_parameters
                                 );
          END IF;

        -- Column path (columnpath) for importing JSON using COPY_DATA
        WHEN 'columnpath' THEN
          NULL;

        -- DEFAULT Case
        ELSE
          RAISE invalid_format_key;

        END CASE;

      END LOOP;

    END IF;

    -- Bug 28002537: Check that END_QUOTE can only be specified if QUOTE is
    -- specified
    IF (l_quote_cls IS NOT NULL AND
        (NOT l_format_key_list.EXISTS(DBMS_CLOUD.FORMAT_QUOTE)))
    THEN
      raise_application_error(-20000,
  'Invalid format parameter: ' || DBMS_CLOUD.FORMAT_END_QUOTE ||
        ' specified without ' || DBMS_CLOUD.FORMAT_QUOTE);
    END IF;


    --
    -- Bug 26812654: TERMINATED BY and OPTIONALLY ENCLOSED BY should be
    -- specified together in the field list parameters. So process them after
    -- all other parameters.
    --
    -- Process QUOTE clause first
    IF l_quote_cls IS NOT NULL THEN
      l_field_parameters := l_quote_cls || ' ' ||
                            l_field_parameters || ' ';
    END IF;
    -- Process FIELD DELIMITER clause
    IF l_field_delim_cls IS NOT NULL THEN
      l_field_parameters := l_field_delim_cls || ' ' ||
                            l_field_parameters || ' ';
    END IF;


    -- Process DEFAULT values for certain ACCESS PARAMETERS
    add_default_access_parameters(
          format_obj        => l_format_obj,
          key_list          => l_format_key_list,
          dflt_diag_file    => dflt_diag_file,
    os_ext_table      => os_ext_table,
          record_parameters => l_record_parameters,
          field_parameters  => l_field_parameters
    );

    -- Add CREDENTIAL parameter
    IF credential_name IS NOT NULL THEN
      l_record_parameters := l_record_parameters || 'CREDENTIAL ' ||
                          DBMS_ASSERT.enquote_literal(credential_name) || ' ';
    END IF;

    -- Add the FIELD_LIST
    IF field_list IS NOT NULL AND NOT part_in_file_uri THEN
      l_field_parameters := l_field_parameters || '( ' || field_list || ' )';
    END IF;


    --
    -- Return the ACCESS PARAMETERS string
    --
    IF part_in_file_uri THEN
      access_parameters := '    RECORDS ' || l_record_parameters ||
                           access_parameters || ' ' || NEWLINE ||
                           '    FIELDS '  || l_field_parameters;
    ELSE
      access_parameters := '    RECORDS ' || l_record_parameters || NEWLINE ||
                           '    FIELDS '  || l_field_parameters;
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

    WHEN OTHERS THEN
      RAISE;
  END get_access_parameters;


  -----------------------------------------------------------------------------
  -- discover_column_clause  - Discover the column list from the file URIs
  -----------------------------------------------------------------------------
  FUNCTION discover_column_clause(
    credential_schema IN  VARCHAR2,
    credential_name   IN  VARCHAR2,
    file_uri_list     IN  CLOB,
    schema_strategy   IN  VARCHAR2,
    exttab_type       IN  VARCHAR2,
    error_msg         OUT VARCHAR2
  )  RETURN CLOB
  IS
    --
    -- NAME:
    --  discover_column_clause - Discovers column list from files URIs
    --
    -- DESCRIPTION:
    --  Verify the setting of "schema" definition.
    --
    --  If the value is "all" or "first" then the columns must be get
    --  from the parquet files.
    --
    --  The other possible value is "none" and when it is set, then
    --  we use the columns defined by the user.
    --
    -- PARAMETERS:
    --
    -- NOTES:
    --
    l_column_clause     CLOB;
    l_return_code       BINARY_INTEGER := 0;
    l_stmt              VARCHAR2(M_VCSIZ_4K);
  BEGIN

    DBMS_LOB.createtemporary(l_column_clause, FALSE, DBMS_LOB.CALL);

    -- Discover column list when schema strategy is not 'none'
    l_stmt :=  'BEGIN                                             ' ||
               '   SYS.KUBSD$DESC_INT.KUBSDESC(                   ' ||
               '            file_uri_list      => :1 ,            ' ||
               '            credential_name    => NVL(:2, '''') , ' ||
               '            credential_schema  => :3 ,            ' ||
               '            type               => :4 ,            ' ||
               '            action             => :5 ,            ' ||
               '            delimiter          => '','',          ' ||
               '            maxvarchar         => NULL,           ' ||
               '            retcode            => :6 ,            ' ||
               '            doc                => :7 );           ' ||
               'END;';
    BEGIN
      EXECUTE IMMEDIATE l_stmt USING IN '[' || file_uri_list || ']',
                                     IN credential_name,
                                     IN credential_schema,
                                     IN LOWER(exttab_type),
                                     IN schema_strategy,
                                     IN OUT l_return_code,
                                     IN OUT l_column_clause;
    EXCEPTION
      WHEN OTHERS THEN
        l_return_code := SQLCODE;
        error_msg     := SQLERRM;
    END;

    -- Check if column discovery succeeded
    IF l_return_code = 0 AND l_column_clause IS NOT NULL THEN
      l_column_clause := '(' || l_column_clause || ')';
    ELSE
      l_column_clause := '';
    END IF;

    RETURN l_column_clause;

  END discover_column_clause;


  -----------------------------------------------------------------------------
  -- get_column_clause - Get column clause for external table
  -----------------------------------------------------------------------------
  FUNCTION get_column_clause(
        credential_schema IN  VARCHAR2,
        credential_name   IN  VARCHAR2,
        file_uri_list     IN  CLOB,
        base_table        IN  VARCHAR2,
        base_table_schema IN  VARCHAR2,
        column_list       IN  CLOB,
        schema_strategy   IN  VARCHAR2,
        exttab_type       IN  VARCHAR2
  )  RETURN CLOB
  IS
    --
    -- NAME:
    --   get_column_clause  - Get column list clause for external table
    --
    -- DESCRIPTION:
    --   This functions derives the column clause for external table either
    --      - using the column list specified, or
    --      - using the base table specified
    --   (in that specific order).
    --
    -- PARAMETERS:
    --  credential_schema  (IN)   - Credential schema name
    --
    --  credential_name    (IN)   - Credential name
    --
    --  file_uri_list      (IN)   - File uri list for discovering columns
    --
    --  base_table         (IN)   - Base table name
    --
    --  base_table_schema  (IN)   - Base table schema name
    --
    --  column_list        (IN)   - Input column list for the external table
    --
    --  schema_strategy    (IN)   - the value of "schema" form the "format"
    --                              json configuration.
    --
    --  exttab_type        (IN)   - External table type
    --
    -- NOTES:
    --   Added for bug 26114248.
    --
    l_column_clause  CLOB;                         -- column list to return out
    l_stmt           CLOB;
    l_error_msg      VARCHAR2(M_VCSIZ_4K); -- error message for discover column
  BEGIN

    -- Use column_list specified to create the column clause
    IF column_list IS NOT NULL THEN
      RETURN '( ' || column_list || ' )';
    END IF;

    -- Discover column clause if schema strategy is set
    -- Bug 32509025: enable column discovery for datapump
    IF schema_strategy IS NOT NULL AND
       schema_strategy != DBMS_CLOUD.FORMAT_BD_SCHEMA_NONE THEN

      l_column_clause := discover_column_clause(
                               credential_schema => credential_schema,
                               credential_name   => credential_name,
                               file_uri_list     => file_uri_list,
                               schema_strategy   => schema_strategy,
                               exttab_type       => exttab_type,
                               error_msg         => l_error_msg
                         );
    END IF;

    -- Use base table name to derive the column clause using DBMS_METADATA
    -- Bug 32494285: Use COLLIST in DBMS_METADATA for column clause
    IF l_column_clause IS NULL AND base_table IS NOT NULL THEN
      l_stmt := 'DECLARE ' ||
                ' cur     PLS_INTEGER; ' ||  -- handle for DBMS_METADATA
                ' tcur    PLS_INTEGER; ' ||  -- handle for DBMS_METADATA
                'BEGIN ' ||
                ' cur := DBMS_METADATA.open(''COLLIST''); ' ||
                ' DBMS_METADATA.set_filter(cur, ''SCHEMA'', ' ||
                '                          :base_table_schema); ' ||
                ' DBMS_METADATA.set_filter(cur, ''NAME'', :base_table); ' ||
                ' tcur := DBMS_METADATA.add_transform(cur, ''DDL''); ' ||
                  -- Get the table definition ddl
                ' :l_column_clause := DBMS_METADATA.FETCH_CLOB(cur); ' ||
                  -- Bug 26584401: close the metadata cursor
                ' DBMS_METADATA.close(cur); ' ||
                  -- Bug 32923663: add exception handler ensuring no cursor leak
                'EXCEPTION ' ||
                '  WHEN OTHERS THEN ' ||
                '    DBMS_METADATA.close(cur); ' ||
                '    RAISE; ' ||
                'END;';
      BEGIN
        EXECUTE IMMEDIATE l_stmt USING IN base_table_schema,
                                       IN base_table,
                                       IN OUT l_column_clause;
      EXCEPTION
        WHEN OTHERS THEN
          IF SQLCODE != -3001 THEN
            RAISE;
          END IF;

          -- If COLLIST feature is not available, then fallback to TABLE option
          l_stmt := 'DECLARE ' ||
                ' cur     PLS_INTEGER; ' ||  -- handle for DBMS_METADATA
                ' tcur    PLS_INTEGER; ' ||  -- handle for DBMS_METADATA
                'BEGIN ' ||
                ' cur := DBMS_METADATA.open(''TABLE''); ' ||
                ' DBMS_METADATA.set_filter(cur, ''SCHEMA'', ' ||
                '                          :base_table_schema); ' ||
                ' DBMS_METADATA.set_filter(cur, ''NAME'', :base_table); ' ||
                ' tcur := DBMS_METADATA.add_transform(cur, ''DDL''); ' ||
                  -- Skip segment and paritioning information in metadata
                ' DBMS_METADATA.set_transform_param(' ||
                '   tcur, ''SEGMENT_ATTRIBUTES'', false);' ||
                ' DBMS_METADATA.set_transform_param(' ||
                '   tcur, ''PARTITIONING'', false);' ||
                  -- Bug 26353660: skip all constraints on the base table
                ' DBMS_METADATA.set_transform_param(' ||
                '   tcur, ''CONSTRAINTS'', false);' ||
                ' DBMS_METADATA.set_transform_param(' ||
                '   tcur, ''REF_CONSTRAINTS'', false);' ||
                ' DBMS_METADATA.set_transform_param(' ||
                '   tcur, ''COLLATION_CLAUSE'', ''NEVER'');' ||
                  -- Get the table definition ddl
                ' :l_column_clause := DBMS_METADATA.FETCH_CLOB(cur); ' ||
                  -- Bug 26584401: close the metadata cursor
                ' DBMS_METADATA.close(cur); ' ||
                  -- Bug 32923663: add exception handler ensuring no cursor leak
                'EXCEPTION ' ||
                '  WHEN OTHERS THEN ' ||
                '    DBMS_METADATA.close(cur); ' ||
                '    RAISE; ' ||
                'END;';

          EXECUTE IMMEDIATE l_stmt USING IN base_table_schema,
                                       IN base_table,
                                       IN OUT l_column_clause;
      END;

      -- Bug 32494285: raise error if column clause is not obtained
      IF l_column_clause IS NULL THEN
        raise_application_error(-20000,
            'Object ' || DBMS_ASSERT.enquote_name(base_table) ||
            ' of type TABLE not found in schema ' ||
            DBMS_ASSERT.enquote_name(base_table_schema));
      END IF;

    END IF;

    -- We must have a column list now, otherwise raise error
    IF l_column_clause IS NULL THEN
      IF l_error_msg IS NULL THEN
        raise_application_error(-20000, 'Missing column list');
      ELSE
        -- Print error message for discovering columns
        raise_application_error(-20000,
            'Failed to generate column list ' || NEWLINE || l_error_msg);
      END IF;
    END IF;

    -- Return the column list clause for the external table
    RETURN l_column_clause;

  END get_column_clause;


  -----------------------------------------------------------------------------
  -- compress_data - Compress a BLOB of data
  -----------------------------------------------------------------------------
  FUNCTION compress_data(
        data       IN  BLOB,
        scheme     IN  VARCHAR2
  ) RETURN BLOB
  IS
    --
    -- NAME:
    --   compress_data - Compress a BLOB of data
    --
    -- DESCRIPTION:
    --   This function compresses the input data using the compression
    --   scheme specified and returns the compressed data as output.
    --
    -- PARAMETERS:
    --   data          (IN)   - Data to compress
    --
    --   scheme        (IN)   - Compression scheme to be used
    --
    -- NOTES:
    --   Added for bug 25995527.
    --
    l_compressed_data   BLOB;
    l_stmt              CLOB;
  BEGIN

    CASE
      -- GZIP or AUTO compression
      WHEN scheme = DBMS_CLOUD.COMPRESS_AUTO OR
           scheme = DBMS_CLOUD.COMPRESS_GZIP THEN
        IF data IS NOT NULL THEN
          l_stmt := 'BEGIN                                    ' ||
                    '  :1 := UTL_COMPRESS.lz_compress(:2, 8); ' ||
                    'END;';
          EXECUTE IMMEDIATE l_stmt USING OUT l_compressed_data, IN data;
        END IF;

      -- No compression scheme specified
      WHEN scheme IS NULL THEN
        l_compressed_data := data;

      -- Invalid compression scheme
      ELSE
        DBMS_CLOUD_CORE.assert(FALSE, 'compress_data',
                               'Invalid compression type ' || scheme);
    END CASE;

   -- Return the compressed data
   RETURN l_compressed_data;

  END compress_data;


  -----------------------------------------------------------------------------
  -- uncompress_data - Uncompress a BLOB of data
  -----------------------------------------------------------------------------
  FUNCTION uncompress_data(
        data       IN  BLOB,
        scheme     IN  VARCHAR2
  ) RETURN BLOB
  IS
    --
    -- NAME:
    --   uncompress_data - Uncompress a BLOB of data
    --
    -- DESCRIPTION:
    --   This function uncompresses the input data using the compression
    --   scheme specified and returns the uncompressed data as output.
    --
    -- PARAMETERS:
    --   data          (IN)   - Data to uncompress
    --
    --   scheme        (IN)   - Compression scheme to be used
    --
    -- NOTES:
    --   Added for bug 25995527.
    --
    l_uncompressed_data   BLOB;
    l_stmt                CLOB;
  BEGIN

    CASE
      -- GZIP or AUTO compression
      WHEN scheme = DBMS_CLOUD.COMPRESS_AUTO OR
           scheme = DBMS_CLOUD.COMPRESS_GZIP THEN
        IF data IS NOT NULL THEN
          l_stmt := 'BEGIN                                    ' ||
                    '  :1 := UTL_COMPRESS.lz_uncompress(:2);  ' ||
                    'END;';
          EXECUTE IMMEDIATE l_stmt USING OUT l_uncompressed_data, IN data;
        END IF;

      -- No compression scheme specified
      WHEN scheme IS NULL THEN
        l_uncompressed_data := data;

      -- Invalid compression scheme
      ELSE
        DBMS_CLOUD_CORE.assert(FALSE, 'uncompress_data',
                               'Invalid compression type ' || scheme);
    END CASE;

    -- Return the uncompressed data
    RETURN l_uncompressed_data;

  END uncompress_data;


  -----------------------------------------------------------------------------
  -- delete_external_table_log_files - Delete External Table Log files
  -----------------------------------------------------------------------------
  PROCEDURE delete_external_table_log_files(
    invoker_schema        IN  VARCHAR2,
    logfile_dir           IN  VARCHAR2,
    logfile_prefix       IN  VARCHAR2
  )
  IS
    --
    -- NAME:
    --   delete_external_table_log_files - Delete External Table Log files
    --
    -- DESCRIPTION:
    --   This is a helper function to delete the log files and bad files for
    --   a given external table. It gets all the files in the log file
    --   directory using list_files and then deletes all the files that have
    --   the prefix logfile_prefix. Additionally, it also deletes the default
    --   bad file created (see bug 26571485).
    --
    -- PARAMETERS:
    --   invoker_schema  (IN) - Invoking schema for the procedure
    --
    --   logfile_dir     (IN) - Directory object where logfiles are existing
    --
    --   logfile_prefix  (IN) - Common Prefix name for log files and bad files
    --
    -- NOTES:
    --   Added for bug 26146301.
    --
  BEGIN

    --
    -- Get the list of log files and bad files from the log file external table
    --
    -- Bug 27896377: Use list_files to delete log files
    -- Bug 30034712: If we failed to delete any file, continue
    FOR l_file_record IN
      (SELECT object_name
         FROM DBMS_CLOUD.list_files(directory_name => logfile_dir)
         WHERE object_name like logfile_prefix || '_%.log' OR
               object_name like logfile_prefix || '_%.bad')
    LOOP
      BEGIN
        DBMS_CLOUD_INTERNAL.delete_file(
            invoker_schema => invoker_schema,
            directory_name => logfile_dir,
            file_name      => l_file_record.object_name
        );
       EXCEPTION WHEN OTHERS THEN
         NULL;
       END;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      -- Ignore any errors.
      NULL;
  END delete_external_table_log_files;

  -----------------------------------------------------------------------------
  -- send_range_get_request - Send Range GET request
  -----------------------------------------------------------------------------
  FUNCTION send_range_get_request(
        context       IN  OUT DBMS_CLOUD_REQUEST.request_context_t,
        startOffset   IN      NUMBER,
        endOffset     IN      NUMBER
  ) RETURN UTL_HTTP.resp
  IS
    l_rsp              UTL_HTTP.resp;
    l_headers          JSON_OBJECT_T := JSON_OBJECT_T('{}');
  BEGIN

    -- Add Range Header if there is a valid end offset
    IF (endOffset - startOffset) > 0 THEN
      l_headers.put(DBMS_CLOUD_REQUEST.HEADER_RANGE,
                    'bytes=' || startOffset || '-' || endOffset);
    END IF;

    -- Bug 32681442: For Github, set the header for raw data to be returned
    IF DBMS_CLOUD_REQUEST.get_cloud_store_type(context) = 8 THEN
      l_headers.put(HEADER_ACCEPT, GITHUB_ACCEPT_RAW);
    END IF;

    --
    -- Send the request
    --
    l_rsp := DBMS_CLOUD_REQUEST.send_request(
               context   => context,
               headers   => l_headers
             );

    RETURN l_rsp;

  END send_range_get_request;


  -----------------------------------------------------------------------------
  -- get_credential_info - Get Information for credential object
  -----------------------------------------------------------------------------
  PROCEDURE get_credential_info(
     credential_name       IN   VARCHAR2,
     username              OUT  VARCHAR2,
     password              OUT  VARCHAR2,
     key                   OUT  VARCHAR2
  )
  IS
    --
    -- NAME:
    --   get_credential_info - Get info for credential object
    --
    -- DESCRIPTION:
    --   This procedure obtains the username and password from the given
    --   credential object.
    --
    -- PARAMETERS:
    --   credential_name    (IN)   - Name of the credential object
    --
    --   username           (OUT)  - Username in the credential object
    --
    --   password           (OUT)  - Password in the credential object
    --
    --   key                (OUT)  - Key attributes in the credential object
    --
    -- NOTES:
    --   Added for bug 25787046.
    --
    --   Bug 32457354: Username/Password can now be upto 24K bytes long.
    --   It is important to ensure that the caller of get_credential_info
    --   allocate sufficient length for these OUT variables. At present,
    --   kpdbGetCredInfo does not raise any error when the OUT variable is
    --   not long enough to store the OUT values and returns NULL for such
    --   attributes. Ideally, this should raise an error (ORA-16612), but
    --   doing so would require the C callout to be updated with additional
    --   arguments for max length of these attributes. Further, this callout
    --   is only used internally by DBMS_CLOUD code. So we are fine as long
    --   as the usage notes for this API clearly mentions this.
    --
    LANGUAGE C
    LIBRARY sys.dbms_pdb_lib
    NAME "kpdbGetCredInfo" WITH CONTEXT
    PARAMETERS (CONTEXT,
                credential_name  OCISTRING, credential_name  INDICATOR SB2,
                username         OCISTRING, username         INDICATOR SB2,
                password         OCISTRING, password         INDICATOR SB2,
                key              OCISTRING, key              INDICATOR SB2);


  -----------------------------------------------------------------------------
  -- get_args_from_raw_ptr - Get function arguments from RAW pointer
  -----------------------------------------------------------------------------
  PROCEDURE get_args_from_raw_ptr(
        arguments_ptr    IN  RAW,
        invoker_schema   IN  OUT NOCOPY VARCHAR2,
        credential_name  IN  OUT NOCOPY VARCHAR2,
        object_uri       IN  OUT NOCOPY VARCHAR2,
        startOffset      OUT NUMBER,
        endOffset        OUT NUMBER
  )
  IS
    --
    -- NAME:
    --   get_args_from_raw_ptr - Get function arguments from RAW pointer
    --
    -- DESCRIPTION:
    --   This procedure copies the data to the given raw buffer pointer.
    --
    -- PARAMETERS:
    --   arguments_ptr    (IN)   - raw buffer pointer to copy the data
    --
    -- NOTES:
    --
    LANGUAGE C
    LIBRARY sys.dbms_pdb_lib
    NAME "kpdbocGetObjectArgs" WITH CONTEXT
    PARAMETERS (CONTEXT,
                arguments_ptr    OCIRAW,    arguments_ptr    INDICATOR SB2,
                invoker_schema   OCISTRING, invoker_schema   INDICATOR SB2,
                credential_name  OCISTRING, credential_name  INDICATOR SB2,
                object_uri       OCISTRING, object_uri       INDICATOR SB2,
                startOffset      OCINUMBER,
                endOffset        OCINUMBER);


  -----------------------------------------------------------------------------
  -- put_object_args_from_raw_ptr - Get function arguments from RAW pointer
  -----------------------------------------------------------------------------
  PROCEDURE put_object_args_from_raw_ptr(
        arguments_ptr    IN  RAW,
        invoker_schema   IN  OUT NOCOPY VARCHAR2,
        credential_name  IN  OUT NOCOPY VARCHAR2,
        base_uri         IN  OUT NOCOPY VARCHAR2,
        file_name        IN  OUT NOCOPY VARCHAR2,
        contents_len         OUT NUMBER
  )
  IS
    --
    -- NAME:
    --   put_object_args_from_raw_ptr - Get put_object_int arguments from
    --                                  RAW pointer
    --
    -- DESCRIPTION:
    --   This procedure gets the arguments to put_object_int procedure from
    --   a raw pointer
    --
    -- PARAMETERS:
    --   arguments_ptr    (IN)     - raw pointer to get the arguments
    --   invoker_schema   (IN OUT) - invoker schema
    --   credential_name  (IN OUT) - credential name
    --   base_uri         (IN OUT) - base object store uri
    --   file_name        (IN OUT) - file name in the bucket
    --   contents_len     (OUT)    - length of the content to be uploaded
    --
    -- NOTES:
    --
    LANGUAGE C
    LIBRARY sys.dbms_pdb_lib
    NAME "kpdbocPutObjectArgs" WITH CONTEXT
    PARAMETERS (CONTEXT,
                arguments_ptr    OCIRAW,    arguments_ptr    INDICATOR SB2,
                invoker_schema   OCISTRING, invoker_schema   INDICATOR SB2,
                credential_name  OCISTRING, credential_name  INDICATOR SB2,
                base_uri         OCISTRING, base_uri         INDICATOR SB2,
                file_name        OCISTRING, file_name        INDICATOR SB2,
                contents_len     OCINUMBER);


  -----------------------------------------------------------------------------
  -- log_msg - Log a message
  -----------------------------------------------------------------------------
  PROCEDURE log_msg(
        log_info   CLOB
  )
  IS
    --
    -- NAME:
    --   log_msg - Log a message
    --
    -- DESCRIPTION:
    --   This procedure issues the logging sql to record the given log message.
    --
    -- PARAMETERS:
    --   log_info        (IN) - log message
    --
    -- NOTES:
    --
    l_stmt     VARCHAR2(M_VCSIZ_4K);
  BEGIN

    l_stmt := '
      DECLARE
        l_log_prev_client VARCHAR2(128);
      BEGIN
        l_log_prev_client := CLOUD_LOGGER.get_client;

        CLOUD_LOGGER.set_client(''DBMS_CLOUD'');

        -- Log the JSON object as a clob in the cloud_logger table
        CLOUD_LOGGER.info(:log_info);
        CLOUD_LOGGER.set_client(l_log_prev_client);
      EXCEPTION
        WHEN OTHERS THEN
          CLOUD_LOGGER.set_client(l_log_prev_client);
      END;';

    EXECUTE IMMEDIATE l_stmt USING log_info;

  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;


  -----------------------------------------------------------------------------
  -- log_common - Log a common message. [ Currently the client IP. ]
  -----------------------------------------------------------------------------
  PROCEDURE log_common(
        l_log_json_obj   IN OUT JSON_OBJECT_T
  )
  IS
    --
    -- NAME:
    --   log_common - Logger for a common attribute
    --
    -- DESCRIPTION:
    --   This procedure logs a common attribute across several
    --   entry points of DBMS_CLOUD. Currently, it logs the
    --   client IP attribute of the invoking connecction.
    --
    -- PARAMETERS:
    --   l_log_json_obj        (IN OUT) - An existing json object that
    --                                    would be populated with the
    --                                    attribute to be logged.
    --
    -- NOTES: None
    --
  BEGIN

    l_log_json_obj.put('client_ip', SYS_CONTEXT('USERENV', 'IP_ADDRESS'));

  END;


  -----------------------------------------------------------------------------
  -- log_credential_op - Log Credential Operation
  -----------------------------------------------------------------------------
  PROCEDURE log_credential_op(
        operation        IN  VARCHAR2,
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        username         IN  VARCHAR2 DEFAULT NULL
  )
  IS
    --
    -- NAME:
    --   log_credential_op - Log credential operation
    --
    -- DESCRIPTION:
    --   This procedure logs information related to credential operation
    --
    -- PARAMETERS:
    --   operation       (IN) - type of credential operation
    --   invoker_schema  (IN) - invoker schema name
    --   credential_name (IN) - credential name
    --   username        (IN) - username
    --
    -- NOTES:
    --
    l_log_json_obj       JSON_OBJECT_T;
  BEGIN

    -- Initialize logging variables
    l_log_json_obj  := JSON_OBJECT_T('{}');
    l_log_json_obj.put('operation', operation);
    l_log_json_obj.put('invoker_schema', invoker_schema);
    l_log_json_obj.put('credential_name', credential_name);
    l_log_json_obj.put('username', username);
    log_common(l_log_json_obj);
    log_msg(l_log_json_obj.to_clob());

  END log_credential_op;


  -----------------------------------------------------------------------------
  -- log_object_op - Log Object Operation
  -----------------------------------------------------------------------------
  PROCEDURE log_object_op(
        operation        IN  VARCHAR2,
        invoker_schema   IN  VARCHAR2,
        request_uri      IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        username         IN  VARCHAR2
  )
  IS
    --
    -- NAME:
    --   log_object_op - Log Object Operation
    --
    -- DESCRIPTION:
    --   This procedure logs information related to (GET/PUT/DELETE) object
    --   operation.
    --
    -- PARAMETERS:
    --   operation       (IN) - type of object operation
    --   invoker_schema  (IN) - invoker schema name
    --   request_uri     (IN) - request URI
    --   credential_name (IN) - credential name
    --   username        (IN) - username
    --
    -- NOTES:
    --
    l_log_json_obj       JSON_OBJECT_T;
  BEGIN

    -- Initialize logging variables
    l_log_json_obj  := JSON_OBJECT_T('{}');
    l_log_json_obj.put('operation', operation);
    l_log_json_obj.put('invoker_schema', invoker_schema);
    l_log_json_obj.put('request_uri', request_uri);
    l_log_json_obj.put('credential_name', NVL(credential_name, ''));
    l_log_json_obj.put('username', username);
    log_common(l_log_json_obj);
    log_msg(l_log_json_obj.to_clob());

  END log_object_op;


  -----------------------------------------------------------------------------
  -- log_exttab_op - Log External Table Operation
  -----------------------------------------------------------------------------
  PROCEDURE log_exttab_op(
        operation         IN  VARCHAR2,
        invoker_schema    IN  VARCHAR2,
        table_name        IN  VARCHAR2,
        base_table_name   IN  VARCHAR2 DEFAULT NULL,
        base_table_schema IN  VARCHAR2 DEFAULT NULL,
        credential_name   IN  VARCHAR2 DEFAULT NULL,
        parent_operation  IN  VARCHAR2 DEFAULT NULL
  )
  IS
    --
    -- NAME:
    --   log_exttab_op - Log External Table Operation
    --
    -- DESCRIPTION:
    --   This procedure logs information related to external table operation.
    --
    -- PARAMETERS:
    --   operation         (IN) - type of external table operation
    --   invoker_schema    (IN) - invoker schema name
    --   table_name        (IN) - external table name
    --   base_table_name   (IN) - base table name
    --   base_table_schema (IN) - base table schema
    --   credential_name   (IN) - credential name
    --   parent_operation  (IN) - parent operation
    --
    -- NOTES:
    --
    l_log_json_obj       JSON_OBJECT_T;
  BEGIN

    -- Initialize logging variables
    l_log_json_obj  := JSON_OBJECT_T('{}');
    l_log_json_obj.put('operation', operation);
    l_log_json_obj.put('invoker_schema', invoker_schema);
    l_log_json_obj.put('table_name', table_name);
    l_log_json_obj.put('base_table_name', base_table_name);
    l_log_json_obj.put('base_table_schema', base_table_schema);
    l_log_json_obj.put('credential_name', credential_name);
    l_log_json_obj.put('parent_operation', parent_operation);
    log_common(l_log_json_obj);
    log_msg(l_log_json_obj.to_clob());

  END log_exttab_op;


  -----------------------------------------------------------------------------
  -- log_file_op - Log File Operation
  -----------------------------------------------------------------------------
  PROCEDURE log_file_op(
        operation        IN  VARCHAR2,
        invoker_schema   IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2
  )
  IS
    --
    -- NAME:
    --   log_file_op - Log File Operation
    --
    -- DESCRIPTION:
    --   This procedure logs information related to (GET/PUT/DELETE) file
    --   operations.
    --
    -- PARAMETERS:
    --   operation       (IN) - type of object operation
    --   invoker_schema  (IN) - invoker schema name
    --   directory_name  (IN) - directory_name
    --   file_name       (IN) - file name
    --
    -- NOTES:
    --
    l_log_json_obj       JSON_OBJECT_T;
  BEGIN

    -- Initialize logging variables
    l_log_json_obj  := JSON_OBJECT_T('{}');
    l_log_json_obj.put('operation', operation);
    l_log_json_obj.put('invoker_schema', invoker_schema);
    l_log_json_obj.put('directory_name', directory_name);
    l_log_json_obj.put('file_name', file_name);
    log_common(l_log_json_obj);
    log_msg(l_log_json_obj.to_clob());

  END log_file_op;


  -----------------------------------------------------------------------------
  -- get_http_header - Get HTTP Header by name from HTTP response
  -----------------------------------------------------------------------------
  PROCEDURE get_http_header(
        rsp         IN OUT NOCOPY UTL_HTTP.resp,
        name        IN            VARCHAR2,
        value       OUT    NOCOPY VARCHAR2,
        occurrence  IN            PLS_INTEGER   DEFAULT 1
  )
  IS
  BEGIN
    UTL_HTTP.get_header_by_name(rsp, name, value, occurrence);
  EXCEPTION
    WHEN UTL_HTTP.header_not_found THEN
      value := NULL;
  END get_http_header;


  -----------------------------------------------------------------------------
  -- get_object_int - Get the contents of an object in Cloud Store Internal
  -----------------------------------------------------------------------------
  PROCEDURE get_object_int(
        invoker_schema   IN            VARCHAR2,
        credential_name  IN            VARCHAR2,
        object_uri       IN            VARCHAR2,
        object_contents  IN OUT NOCOPY BLOB,
        directory_name   IN            VARCHAR2 DEFAULT NULL,
        file_name        IN            VARCHAR2 DEFAULT NULL,
        startOffset      IN            NUMBER   DEFAULT 0,
        endOffset        IN            NUMBER   DEFAULT 0,
        compression      IN            VARCHAR2 DEFAULT NULL,
        blob_output      IN            BOOLEAN  DEFAULT TRUE
  )
  IS
    --
    -- NAME:
    --   get_object_int - Get the contents of an object in Cloud Store
    --
    -- DESCRIPTION:
    --   This intenral procedure is used to get the contents of an object
    --   existing in Cloud Store. The object is identified using the URI and
    --   access to the Cloud Store is authenticated using the credential
    --   object name. The contents of the object are copied into a pre-created
    --   BLOB and/or can be written to a local file in given directory object.
    --
    -- PARAMETERS:
    --   invoker_schema  (IN)  - Invoking schema for the procedure
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           have been created using DBMS_CLOUD.
    --
    --   object_uri      (IN)  - URI of the object existing in Object Store
    --
    --   object_contents (IN OUT) - BLOB pre-created to store object contents
    --
    --   directory_name  (IN)  - Directory object for local file
    --
    --   file_name       (IN)  - Local file name to put to object store
    --
    --   startOffset     (IN)  - starting offset (in bytes) to read contents
    --
    --   endOffset       (IN)  - end offset (in bytes) to read contents
    --
    --   compression     (IN)  - compression scheme to uncompress the data
    --
    --
    -- NOTES:
    --   The input argument object_contents should be a BLOB that is already
    --   created by the caller. This procedure will only write into the
    --   pre-created BLOB.
    --
    l_compression      DBMS_ID;
    l_file_name        VARCHAR2(M_FILE_LEN);
    l_ctx              DBMS_CLOUD_REQUEST.request_context_t;
    l_rsp              UTL_HTTP.resp;
    l_buffer           RAW(M_VCSIZ_32K);
    l_file             UTL_FILE.file_type;
    l_amount           PLS_INTEGER := M_VCSIZ_32K;
  BEGIN
    -- Compute the byte range
    IF NOT DBMS_CLOUD_CORE.whole_number(startOffset) OR -- validate startOffset
       NOT DBMS_CLOUD_CORE.whole_number(endOffset) OR     -- validate endOffset
       startOffset > endOffset OR                     -- start greater than end
       (startOffset > 0 AND startOffset = endOffset)            -- start == end
    THEN
      raise_application_error(-20000, 'Invalid startOffset or endOffset');
    END IF;

    -- Validate input
    l_compression     := validate_compression_scheme(compression);

    -- Bug 30801034: Compression is not allowed with start or end offsets
    IF l_compression IS NOT NULL AND (startOffset > 0 OR endOffset > 0) THEN
      raise_application_error(-20000,
          'Compression cannot be used with startOffset or endOffset');
    END IF;


    --
    -- Initialize Request
    --
    l_ctx := DBMS_CLOUD_REQUEST.init_request(
               invoker_schema  => invoker_schema,
               credential_name => credential_name,
               base_uri        => object_uri,
               method          => DBMS_CLOUD.METHOD_GET
             );

    -- Bug 29788482: get_object is only allowed on files, not buckets
    IF DBMS_CLOUD_REQUEST.get_uri_file_path(l_ctx) IS NULL THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OBJ_URI,
          'Invalid object uri - ' || object_uri);
    END IF;

    BEGIN

      --
      -- Log the object operation
      --
      log_object_op(operation => OPER_GET_OBJECT,
                   invoker_schema => invoker_schema,
                   request_uri => object_uri,
                   credential_name => credential_name,
                   username => l_ctx(DBMS_CLOUD_REQUEST.REQUEST_CTX_USERNAME));

      --
      -- Send the request
      --
      l_rsp := send_range_get_request(
                     context     => l_ctx,
                     startOffset => startOffset,
                     endOffset   => endOffset
               );

      --
      -- Initialize file handle, if object contents to be written to local file
      --
      IF directory_name IS NOT NULL THEN
        -- Bug 27447846: validate file name
        IF TRIM(file_name) IS NULL THEN
          -- Get file name from object uri if not specified in input
          l_file_name := validate_file_name(
                             SUBSTR(object_uri, INSTR(object_uri, '/', -1)+1));
        ELSE
          l_file_name := validate_file_name(file_name);
        END IF ;

        -- Open the file handle only if compression method not specified
        IF compression IS NULL THEN
          l_file := UTL_FILE.FOPEN(directory_name, l_file_name, 'wb',l_amount);
        END IF;
      END IF;

      -- Initialize the BLOB
      DBMS_LOB.createtemporary(object_contents, FALSE, DBMS_LOB.CALL);


      --
      -- Read the response
      --
      LOOP
        UTL_HTTP.read_raw(l_rsp, l_buffer, l_amount);

        -- Write contents to BLOB
        IF blob_output OR l_compression IS NOT NULL THEN
          DBMS_LOB.writeappend(object_contents, UTL_RAW.length(l_buffer),
                               l_buffer);
        -- Write contents to file
        ELSIF directory_name IS NOT NULL THEN
          UTL_FILE.put_raw(l_file, l_buffer, TRUE);   -- auto-flush after write
        END IF;
      END LOOP;

      DBMS_CLOUD_REQUEST.end_request(l_rsp);
      UTL_FILE.fclose(l_file);

    EXCEPTION
      -- End of response body
      WHEN UTL_HTTP.end_of_body THEN
        DBMS_CLOUD_REQUEST.end_request(l_rsp);
        UTL_FILE.fclose(l_file);
    END;

    -- Bug 25995527: Uncompress the data if compression method specified
    IF l_compression IS NOT NULL THEN
      object_contents := uncompress_data(object_contents, l_compression);

      -- Bug 29586364: For compressed file, write contents to file
      -- after reading the entire file
      IF directory_name IS NOT NULL THEN
        write_file(invoker_schema => invoker_schema,
                   directory_name => directory_name,
                   file_name      => l_file_name,
                   contents       => object_contents);
      END IF;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      -- End the response to avoid leaking HTTP connection
      DBMS_CLOUD_REQUEST.end_request(l_rsp);
      -- Close the file handle, if opened earlier
      UTL_FILE.fclose(l_file);
      RAISE;
  END get_object_int;


  -----------------------------------------------------------------------------
  -- put_object_int - Put the contents in an object in Cloud Store Internal
  -----------------------------------------------------------------------------
  PROCEDURE put_object_int(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        object_uri       IN  VARCHAR2,
        contents         IN  BLOB,
        directory_name   IN  VARCHAR2 DEFAULT NULL,
        file_name        IN  VARCHAR2 DEFAULT NULL,
        compression      IN  VARCHAR2 DEFAULT NULL,
        bfile_locator    IN  BFILE    DEFAULT NULL,
        contents_ptr     IN  RAW      DEFAULT NULL,
        contents_len     IN  NUMBER   DEFAULT NULL
  )
  IS
    l_compression      DBMS_ID;
    l_ctx              DBMS_CLOUD_REQUEST.request_context_t;
    l_rsp              UTL_HTTP.resp;
    l_contents         BLOB;
    l_headers          JSON_OBJECT_T;
    l_path             VARCHAR2(M_VCSIZ_4K);
  BEGIN

    -- Validate input
    l_compression := validate_compression_scheme(compression);

    -- Bug 25819268: Treat NULL content as an empty blob
    -- Bug 32870021: If contents ptr is NOT NULL, then pass the body as NULL
    -- to send_request
    IF contents_ptr IS NOT NULL THEN
      l_contents := NULL;
    ELSIF contents IS NULL AND bfile_locator IS NULL THEN
      l_contents := EMPTY_BLOB();
    ELSIF bfile_locator IS NULL THEN
      l_contents := contents;

      -- Bug 25995527: compress the contents if compression method specified
      l_contents := compress_data(l_contents, l_compression);
    ELSE
      -- BFILE locator is not null. Assert that compression is NULL
      DBMS_CLOUD_CORE.assert(l_compression IS NULL, 'put_object',
                             'compression and bfile locator cannot be ' ||
                             'passed together');
    END IF;

    -- Initialize Request
    l_ctx := DBMS_CLOUD_REQUEST.init_request(
               invoker_schema  => invoker_schema,
               credential_name => credential_name,
               base_uri        => object_uri,
               method          => DBMS_CLOUD.METHOD_PUT
             );

    -- Bug 30998372: put_object is only allowed on files, not buckets.
    -- If the file name is given, then append it to the URI, otherwise error.
    -- If the URI ends with a '/', then ensure that there is a file name.
    IF DBMS_CLOUD_REQUEST.get_uri_file_path(l_ctx) IS NULL OR
       SUBSTR(object_uri, -1) = '/'
    THEN
      IF file_name IS NULL THEN
        raise_application_error(DBMS_CLOUD.EXCP_INVALID_OBJ_URI,
            'Invalid object uri - ' || object_uri);
      END IF;

      IF SUBSTR(object_uri, -1) != '/' THEN
        l_path := '/';
      END IF;
      l_path := l_path || file_name;
    END IF;


    --
    -- Log the object operation
    --
    log_object_op(operation => OPER_PUT_OBJECT,
                  invoker_schema => invoker_schema,
                  request_uri => object_uri,
                  credential_name => credential_name,
                  username => l_ctx(DBMS_CLOUD_REQUEST.REQUEST_CTX_USERNAME));

    -- Set the blob type for PUT request
    IF DBMS_CLOUD_REQUEST.get_cloud_store_type(l_ctx) =
          DBMS_CLOUD_REQUEST.CSTYPE_MS_AZURE_BLOB
    THEN
      l_headers := JSON_OBJECT_T('{}');
      l_headers.put(HEADER_BLOB_TYPE_MS, MS_BLOCK_BLOB);
    END IF;

    -- Send the request
    l_rsp := DBMS_CLOUD_REQUEST.send_request(
               context        => l_ctx,
               body           => l_contents,
               headers        => l_headers,
               path           => l_path,
               bfile_locator  => bfile_locator,
               contents_ptr   => contents_ptr,
               contents_len   => contents_len
             );

    DBMS_CLOUD_REQUEST.end_request(l_rsp);

    -- Verify the response code
    -- Amazon S3 sends HTTP 200 status code, so that is also acceptable
    IF l_rsp.status_code != UTL_HTTP.HTTP_CREATED AND
       l_rsp.status_code != UTL_HTTP.HTTP_OK THEN
      raise_application_error(-20000,
        'Error ' || l_rsp.status_code || ' on uploading object - ' ||
        object_uri);
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      -- End the response to avoid leaking HTTP connection
      DBMS_CLOUD_REQUEST.end_request(l_rsp);
      RAISE;
  END put_object_int;


  -----------------------------------------------------------------------------
  -- delete_object_int - Delete an object in Object store Internal
  -----------------------------------------------------------------------------
  PROCEDURE delete_object_int(
        context          IN OUT NOCOPY DBMS_CLOUD_REQUEST.request_context_t,
        invoker_schema   IN            VARCHAR2,
        credential_name  IN            VARCHAR2,
        object_uri       IN            VARCHAR2,
        chunk_name       IN            VARCHAR2   DEFAULT NULL
  )
  IS
    --
    -- NAME:
    --   delete_object_int - Delete an object in Object store Internal
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure to delete a given object in
    --   cloud store. It reuses the input cloud request context to avoid
    --   reparsing the URI. If a chunk name is passed, it will be used as
    --   URI path in DBMS_CLOUD_REQUEST.send_request() to reuse the existing
    --   request context.
    --
    -- PARAMETERS:
    --   context         (IN)  - request context
    --
    --   invoker_schema  (IN)  - Invoking schema for the procedure
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           have been created using DBMS_CLOUD.
    --
    --   object_uri      (IN)  - URI of the object existing in Object Store
    --
    --   chunk_name      (IN)  - Chunk name of large object to delete
    --
    -- NOTES:
    --   Added for bug 31166211.
    --
    l_rsp              UTL_HTTP.resp;
  BEGIN
    --
    -- Log the object operation
    --
    log_object_op(
         operation       => OPER_DEL_OBJECT,
         invoker_schema  => invoker_schema,
         request_uri     => object_uri || chunk_name,
         credential_name => credential_name,
         username        => context(DBMS_CLOUD_REQUEST.REQUEST_CTX_USERNAME));

    -- Send the request
    l_rsp := DBMS_CLOUD_REQUEST.send_request(
                context => context,
                path  => chunk_name
             );

    DBMS_CLOUD_REQUEST.end_request(l_rsp);

  EXCEPTION
    WHEN OTHERS THEN
      -- End the response to avoid leaking HTTP connection
      DBMS_CLOUD_REQUEST.end_request(l_rsp);
      RAISE;
  END delete_object_int;


  -----------------------------------------------------------------------------
  -- delete_object_chunks - Delete chunks of a large object in Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE delete_object_chunks(
        context          IN OUT NOCOPY DBMS_CLOUD_REQUEST.request_context_t,
        invoker_schema   IN            VARCHAR2,
        credential_name  IN            VARCHAR2,
        object_uri       IN            VARCHAR2
  )
  IS
    --
    -- NAME:
    --   delete_object_chunks - Delete chunks of a large object in Cloud Store
    --
    -- DESCRIPTION:
    --   This procedure deletes chunks of a Dynamic large object file.
    --   Currently, OCI Swift API does not support automation deletion of
    --   chunks when deleting the manifest of primary object. So this procedure
    --   generates all possible chunk names and deletes them one by one.
    --
    -- PARAMETERS:
    --   context         (IN)  - request context
    --
    --   invoker_schema  (IN)  - Invoking schema for the procedure
    --
    --   credential_name (IN)  - Credential object name to authenticate with
    --                           with Object Store. The credential object must
    --                           have been created using DBMS_CLOUD.
    --
    --   object_uri      (IN)  - URI of the object existing in Object Store
    --
    -- NOTES:
    --   Added for bug 31166211.
    --
    l_rsp                   UTL_HTTP.resp;
    l_manifest_header       VARCHAR2(M_VCSIZ_4K);
    l_chunk_suffix          VARCHAR2(6);
    l_chunk_name            VARCHAR2(6);
    l_level                 INTEGER;
    l_subfolder_chunk_name  BOOLEAN := TRUE;
  BEGIN

    -- Check if the object is a dynamic large object using a HEAD request
    -- We reuse the existing request context for DELETE request and change
    -- the method to HEAD. This is an optimization to avoid reparsing the URI.
    context(DBMS_CLOUD_REQUEST.REQUEST_CTX_METHOD) := DBMS_CLOUD.METHOD_HEAD;
    BEGIN
      l_rsp := DBMS_CLOUD_REQUEST.send_request(context => context);
      get_http_header(l_rsp, HEADER_OBJECT_MANIFEST, l_manifest_header);
      IF l_manifest_header IS NULL THEN
        get_http_header(l_rsp, HEADER_META_OBJ_MANIFEST, l_manifest_header);
      END IF;
      DBMS_CLOUD_REQUEST.end_request(l_rsp);
      context(DBMS_CLOUD_REQUEST.REQUEST_CTX_METHOD) :=
                                                      DBMS_CLOUD.METHOD_DELETE;
    EXCEPTION
      WHEN OTHERS THEN
        context(DBMS_CLOUD_REQUEST.REQUEST_CTX_METHOD) :=
                                                      DBMS_CLOUD.METHOD_DELETE;
        DBMS_CLOUD_REQUEST.end_request(l_rsp);
        RAISE;
    END;

    -- If manifest header is not found, then return
    IF l_manifest_header IS NULL THEN
      RETURN;
    END IF;

    -- Bug 33032544: Chunk names of dynamic large object could be existing in
    -- any one of two supported name formats. Earlier the chunk name format
    -- was "_<chunkname>", and later chunk names have subfolder format
    -- "_segments/<chunkname>". The logic below will detect the name pattern
    -- from the manifest header, and use that same name format for deleting
    -- all the chunks.
    IF SUBSTR(l_manifest_header, -1) = '_' THEN
      l_subfolder_chunk_name := FALSE;
    END IF;

    -- Generate all possible chunk names and delete each chunk until we get
    -- object does not exist error. Max chunks is 26^6.
    FOR i IN 0..MAX_DLO_CHUNKS-1 LOOP
      l_level := FLOOR(LOG(26, i+1));
      l_chunk_suffix := CHR(ASCII('a') + i / POWER(26, l_level));
      FOR j IN 1..l_level LOOP
        l_chunk_suffix := l_chunk_suffix ||
                          CHR(ASCII('a') + MOD(i / POWER(26, j-1), 26));

      END LOOP;
      -- Prefix the chunk suffix with 'a'.
      l_chunk_name := LPAD(l_chunk_suffix, 6, 'a');

      IF l_subfolder_chunk_name THEN
        -- Delete chunk with subfolder name format
        delete_object_int(
              context         => context,
              invoker_schema  => invoker_schema,
              credential_name => credential_name,
              object_uri      => object_uri,
              chunk_name      => '_segments/' || l_chunk_name
        );
      ELSE
        -- Delete the chunk with underscore name format
        delete_object_int(
            context         => context,
            invoker_schema  => invoker_schema,
            credential_name => credential_name,
            object_uri      => object_uri,
            chunk_name      => '_' || l_chunk_name
        );
      END IF;

    END LOOP;

  EXCEPTION
    WHEN uri_object_not_found THEN
      -- Ignore chunk not found error and exit the function
      NULL;
  END delete_object_chunks;


  -----------------------------------------------------------------------------
  -- set_bypass - Set bypass for external table ddl
  -----------------------------------------------------------------------------
  FUNCTION set_bypass
  RETURN NUMBER
  IS
    --
    -- NAME:
    --  set_bypass - Set bypass for external table ddl
    --
    -- DESCRIPTION:
    --   This function sets the bypass for external table ddl.
    --
    -- PARMETERS:
    --   None
    --
    -- RETURNS:
    --   The original bypass parameter value
    -- NOTES:
    --
    l_retval  NUMBER;
    l_cstype  DBMS_ID;
  BEGIN
    l_cstype := SYS_CONTEXT('USERENV', 'CLOUD_SERVICE');

    -- Enable external table ddl for specific cloud service type
    IF l_cstype IS NOT NULL AND UPPER(l_cstype) != 'PAAS' AND
       BITAND(PDB_LOCKDOWN_DDL_CLAUSES, 16) = 16
    THEN
      BEGIN
        DBMS_CLOUD_ADMIN_INTERNAL.run_stmt(
             'ALTER SESSION SET "_pdb_lockdown_ddl_clauses" = ' ||
              TO_CHAR(BITAND(PDB_LOCKDOWN_DDL_CLAUSES, -17)), KSYS);
      EXCEPTION
        WHEN OTHERS THEN
          RETURN NULL;
      END;
      l_retval := PDB_LOCKDOWN_DDL_CLAUSES;
    END IF;

    RETURN l_retval;

  END set_bypass;


  -----------------------------------------------------------------------------
  -- create_credential_int - Helper function to create a Credential object
  -----------------------------------------------------------------------------
  PROCEDURE create_credential_int(
        credential_name  IN  VARCHAR2,
        username         IN  VARCHAR2,
        password         IN  VARCHAR2,
        comments         IN  VARCHAR2,
        key              IN  VARCHAR2 DEFAULT NULL
  )
  IS
    --
    -- NAME:
    --   create_credential_int - Helper function to create a Credential object
    --
    -- DESCRIPTION:
    --
    --   If the credential owner is protected with DV realm, the invoking user
    --   for DBMS_CREDENTIAL API needs to be authorized to the realm before he
    --   or she can operate against the realm protected schema.
    --
    --   DBMS_ISCHED.CREATE_CLOUD_INTERNAL API calls the underlying scheduler
    --   ICD with SYS as invoker. So customer needs to add SYS user to the DV
    --   realm for CREATE_CREDENTIAL API to go through successfully. However,
    --   other credential related APIs like {UPDATE|ENABLE|DISABLE|DROP}, we
    --   need to authorize C##CLOUD$SERVICE to the DV realm. Having both SYS
    --   and C##CLOUD$SERVICE affects user experience. So we are doing the
    --   direct call to DBMS_CREDENTIAL API for creation as well.
    --
    -- PARAMETERS:
    --   credential_name (IN)  - Schema qualified credential object name
    --
    --   username        (IN)  - User name for the credential object
    --
    --   password        (IN)  - Password for the credential object
    --
    --   comments        (IN)  - Comments for the credential object
    --
    --   key             (IN)  - Private key for the credential object
    --
    -- NOTES:
    --   Added as part of Bug 32635835.
    --
    l_stmt             VARCHAR2(M_VCSIZ_4K);
  BEGIN

    -- Directly call DBMS_CREDENTIAL API to create the credential.
    -- It will save us from adding SYS user to the DV realm, should the
    -- credential owner be realm protected.
    l_stmt :=  'BEGIN ' ||
               '  SYS.DBMS_CREDENTIAL.create_credential( ' ||
                '    credential_name => :1, ' ||
                '    username        => :2, ' ||
                '    password        => :3, ' ||
                '    comments        => :4, ' ||
                '    key             => :5 ' ||
                '  ); ' ||
                'END;';

    EXECUTE IMMEDIATE l_stmt USING IN credential_name,
                                   IN username,
                                   IN password,
                                   IN comments,
                                   IN key;

    -- Set the cloud attribute for the credential. Not having this credential
    -- as DBMS_CLOUD created credentials in dictionary would mean {exp|imp}ort
    -- of such credentials may not work as expected.
    l_stmt :=  'BEGIN ' ||
               '  SYS.DBMS_SCHEDULER.set_attribute( ' ||
                '    name      => :1, ' ||
                '    attribute => :2, ' ||
                '    value     => :3  ' ||
                '  ); ' ||
                'END;';

    BEGIN
      EXECUTE IMMEDIATE l_stmt USING IN credential_name,
                                     IN 'IS_CLOUD_CREDENTIAL',
                                     IN TRUE;
    EXCEPTION
      WHEN cred_attr_not_found THEN
        -- This can happen if IS_CLOUD_CREDENTIAL attribute is not supported
        NULL;
    END;

 END create_credential_int;


  -----------------------------------------------------------------------------
  -- is_number - Helper function to test a string value numeric or not.
  -----------------------------------------------------------------------------
  FUNCTION is_number (
    p_string IN VARCHAR2
  ) RETURN BOOLEAN
  IS
    --
    -- NAME:
    --   is_number - test a string value numeric or not
    --
    -- DESCRIPTION:
    --
    -- This function returns TRUE if the value is numeric and
    -- returns FALSE if the value is NOT numeric.
    --
    -- PARAMETERS:
    --   p_string        (IN)  - A string value
    --
    -- NOTES:
    --   Added as part of Bug 33016310.
    --
     l_new_num NUMBER;
  BEGIN
     l_new_num := TO_NUMBER(p_string);
     RETURN TRUE;
  EXCEPTION
    WHEN VALUE_ERROR THEN
      RETURN FALSE;
  END is_number;


  -----------------------------------------------------------------------------
  -- wildcard_filter - Helper function to test filename and filename expression
  -----------------------------------------------------------------------------
  FUNCTION wildcard_filter (
    fx     IN VARCHAR2,
    fn     IN VARCHAR2
  ) RETURN BOOLEAN
  IS
    --
    -- NAME:
    --   wildcard_filter - test filename and filename expression
    --
    -- DESCRIPTION:
    --
    -- This function takes 2 arguments a wildcard file name expression (fx)
    -- and a file name (fn).
    -- It returns TRUE if fn is matched by in fx, FALSE otherwise.
    -- fx can only contain wildcards * and ? Which may occur more then once.
    --
    -- NOTE: It does't do escaping now.
    --       i.e in case fn contains wildcards it could just match them
    --       literally which would be easy to do if that is what escaping means.
    --
    -- PARAMETERS:
    --   fx              (IN)  - A file name expression
    --   fn              (IN)  - A file name
    --
    -- NOTES:
    --   Added as part of Bug 33016310.
    --
    curfx      BINARY_INTEGER;
    curfn      BINARY_INTEGER;
    lenfx      BINARY_INTEGER;
    lenfn      BINARY_INTEGER;
    slen       BINARY_INTEGER;
    inspos     BINARY_INTEGER;
    maxpos     BINARY_INTEGER;
    i          BINARY_INTEGER;
    j          BINARY_INTEGER;
    ts         VARCHAR2(255);

  BEGIN
    curfx := 1;
    curfn := 1;
    lenfx := LENGTH(fx);
    lenfn := LENGTH(fn);
    i := 0;
    WHILE curfx <= lenfx and i < 1000 LOOP
      i := 1 +1;

      CASE SUBSTR(fx, curfx, 1)
      WHEN '*' THEN
      -- determine instr to find which is the part between the two meta
      -- characters
        slen := 1;

        WHILE SUBSTR(fx, curfx + slen, 1) <> '*'
              AND SUBSTR(fx, curfx + slen, 1) <> '?'
              AND curfx + slen <= lenfx
        LOOP
          slen := slen + 1;
        END LOOP;

        slen := slen - 1;

        IF slen = 0 THEN
          curfx := curfx + 1;

          IF curfx > lenfx THEN
            -- there is a * at the end of the fx
            -- which means fn matches fx
            RETURN TRUE;
          END IF;
          CONTINUE;
        END IF;

        -- the string we need to find is SUBSTR(fx,curfx+1, slen)
        --  greedy match  is required
        maxpos := curfn;
        j := 0;
        ts := SUBSTR(fx, curfx + 1 , slen);
        WHILE j < 10
        LOOP
          j := j + 1;
          inspos := Instr(fn, ts, maxpos+1);

          IF inspos > maxpos  THEN
            maxpos := inspos;
          ELSIF inspos IS NULL OR inspos = 0 THEN
            j := j + 5;
            EXIT;
          END IF;
        END LOOP;

        IF maxpos = curfn THEN
          RETURN FALSE;
        END IF;

        curfn := maxpos + slen;
        curfx := curfx + slen+1;

      WHEN '?' THEN
        curfx := curfx + 1;
        curfn := curfn + 1;
      ELSE
        IF SUBSTR(fx, curfx, 1) <> SUBSTR(fn, curfn, 1) THEN
          RETURN FALSE;
        ELSE
          curfx := curfx + 1;
          curfn := curfn + 1;
          CONTINUE;
        END IF;
      END CASE;
    END LOOP;

    RETURN curfn > lenfn;

  END wildcard_filter;


  -----------------------------------------------------------------------------
  -- generate_partitioning_clause - Generate partitioning clause for CloudSQL
  -----------------------------------------------------------------------------
  FUNCTION generate_partitioning_clause(
        invoker_schema      IN     VARCHAR2,
        credential_name     IN     VARCHAR2,
        table_name          IN     VARCHAR2,
        file_uri_list       IN     CLOB,
        column_list         IN OUT CLOB,
        format_obj          IN     JSON_OBJECT_T,
        partition_array     OUT    JSON_ARRAY_T,
        update_columns      IN     BOOLEAN
  ) RETURN CLOB
  IS
    --
    -- NAME:
    --  generate_partitioning_clause - Generate partitioning clause for CloudSQL
    --
    -- DESCRIPTION:
    --   This function generates a partitioning clause for CloudSQL external
    --   table and returns a partitioning clause string and a partition array
    --
    -- PARAMETERS:
    --   invoker_schema     (IN)     - Invoking schema for the procedure
    --   credential_name    (IN)     - a credential name
    --   table_name         (IN)     - external table name
    --   file_uri_list      (IN)     - file_uri_list
    --   column_list        (IN OUT) - XT table column names and datatypes
    --   format_obj         (IN)     - partition file type and column names
    --   partition_array    (OUT)    - partition locations in a json array to
    --                                 be used by sync_external_part_table
    --   update_columns     (IN)     - check if table columns are out of sync
    -- NOTES:
    --
    --
    COMMA                        CONSTANT CHAR(1) := ',';
    SINGLE_QUOTE                 CONSTANT CHAR(1) := '''';
    DOUBLE_QUOTE                 CONSTANT CHAR(1) := '"';
    WHITESPACE                   CONSTANT CHAR(1) := ' ';
    SLASH                        CONSTANT CHAR(1) := '/';
    EQUAL_SIGN                   CONSTANT CHAR(1) := '=';
    LEFT_BRACKET                 CONSTANT CHAR(1) := '{';
    RIGHT_BRACKET                CONSTANT CHAR(1) := '}';
    LEFT_ROUND_BRACKET           CONSTANT CHAR(1) := '(';
    RIGHT_ROUND_BRACKET          CONSTANT CHAR(1) := ')';
    l_sqlstmt                    CLOB;
    l_column                     CLOB;
    l_column_list                CLOB;
    l_column_list_new            CLOB;
    l_column_list_object         JSON_OBJECT_T;
    l_format_object              JSON_OBJECT_T;
    l_column_count               NUMBER;
    l_file_uri_list              CLOB;
    l_file_uri                   CLOB;
    l_first_file_uri             CLOB;
    l_file_uri_head              CLOB;
    l_file_uri_tail              CLOB;
    l_type                       CLOB;
    l_partition_format           CLOB;
    l_partition_string           CLOB;
    l_partition_previous         CLOB;
    l_partition_location         CLOB;
    l_partition_clause           CLOB;
    l_partition_file             CLOB;
    l_partition_file_orig        CLOB;
    l_partition_name             CLOB;
    l_partition_value            CLOB;
    l_p_columns_array            JSON_ARRAY_T;
    l_p_columns_array_size       NUMBER;
    l_partition_count            NUMBER;
    l_p_counter                  NUMBER;
    l_tmpcount                   NUMBER;
    l_tmpcount2                  NUMBER;
    l_tmpstr                     CLOB;
    l_tmpstr2                    CLOB;
    l_datatype                   CLOB;
    l_value_str                  CLOB;
    l_pfile_array                JSON_ARRAY_T;
    l_partition_array            JSON_ARRAY_T;
    l_wildcarding                BOOLEAN;

  BEGIN

    l_partition_array := JSON_ARRAY_T('[]');

    --------------------------------------------------------------------------
    --
    -- 1. process file_uri_list and format_obj JSON object, which contains
    --    xt table file type and partitioning column names.
    --
    --------------------------------------------------------------------------

    l_file_uri_list := file_uri_list;
    l_format_object := format_obj;
    l_type := l_format_object.get_string('type');

    l_p_columns_array :=
      TREAT(l_format_object.get('partition_columns') AS JSON_ARRAY_T);
    l_partition_string := NULL;
    l_p_columns_array_size := l_p_columns_array.get_size;

    FOR i IN 0..l_p_columns_array_size-1 LOOP
      l_tmpstr := l_p_columns_array.get_String(i);
      l_partition_string := l_partition_string || l_tmpstr || COMMA;
    END LOOP;
    l_partition_string := RTRIM(l_partition_string, COMMA);

    l_partition_previous := NULL;

    --------------------------------------------------------------------------
    --
    -- 2. process file_uri_list which can be in these two formats:
    --
    --    a. A comma separated list of all the individual object store files
    --       that are part of the XT. No wildcarding is allowed!
    --    b. A single URI with wildcard(s) and the wildcard(s) can only be
    --       after the last / (i.e. slash).
    --
    --------------------------------------------------------------------------

    l_pfile_array := JSON_ARRAY_T('[]');
    l_tmpstr := REPLACE(l_file_uri_list, '\*');
    l_tmpcount := REGEXP_COUNT(l_tmpstr, COMMA);
    l_tmpcount2 := REGEXP_COUNT(l_tmpstr, '\*');

    IF l_tmpcount > 0 THEN
      l_wildcarding := FALSE;
    ELSIF l_tmpcount = 0 AND l_tmpcount2 = 0 THEN
      l_wildcarding := FALSE;
    ELSE
      l_wildcarding := TRUE;
    END IF;

    --
    -- generate l_pfile_array
    --
    IF NOT l_wildcarding THEN

      --  A comma separated list of all the individual object store files
      --  that are part of the XT. No wildcarding!
      IF l_tmpcount2 > 0 THEN
        raise_application_error(DBMS_CLOUD.EXCP_INVALID_OBJ_URI,
          'Wildcarding is not allowed in comma separated file_uri_list - ' ||
          file_uri_list);
      END IF;

      FOR i IN 1..l_tmpcount+1 LOOP
        l_file_uri := TRIM(REGEXP_SUBSTR(l_file_uri_list, '[^,]+', 1, i));
        l_pfile_array.append(l_file_uri);
      END LOOP;

      -- 33467221: Validate the list of object store files one by one
      FOR j IN 0..l_pfile_array.get_size-1 LOOP
        l_file_uri := UTL_URL.unescape(l_pfile_array.get_String(j));

        l_tmpstr := DBMS_CLOUD_INTERNAL.get_metadata(
                    invoker_schema => invoker_schema,
                    credential_name => credential_name,
                    object_uri => l_file_uri);
      END LOOP;
      l_file_uri_tail := '*.' || l_type;

    ELSE

      --  A single URI with wildcard(s) and the wildcard(s) can only be after
      --  the last / (i.e. slash)
      l_file_uri := l_file_uri_list;
      l_file_uri_tail := REGEXP_SUBSTR(l_file_uri, '[^\/]+$');
      l_file_uri_head := SUBSTR(l_file_uri, 1,
        LENGTH(l_file_uri)-LENGTH(l_file_uri_tail));
      l_file_uri_tail := SUBSTR(l_file_uri_tail, INSTR(l_file_uri_tail, '*'));

      FOR l_file_record IN
      (
        SELECT object_name
        FROM list_objects_tabfunc(invoker_schema => invoker_schema,
                          credential_name => credential_name,
                          location_uri => l_file_uri_head)
        ORDER BY object_name
      )
      LOOP  -- loop for l_file_record
        l_tmpstr2 := l_file_uri_head ||
          UTL_URL.unescape(l_file_record.object_name);
        IF wildcard_filter(l_file_uri, l_tmpstr2) THEN
          l_pfile_array.append(l_tmpstr2);
        END IF;
      END LOOP;  -- loop for l_file_record

    END IF;

    IF l_pfile_array.get_size = 0 THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OBJ_URI,
          'No files found matching the query uri list - ' || file_uri_list);
    END IF;

    --------------------------------------------------------------------------
    --
    -- 3. process column_list which contains xt column names and datatypes
    --    and generate l_column_list_object (a JSON object).
    --    Always refer to l_column_list_object for the XT columns' datatypes.
    --
    --------------------------------------------------------------------------

    l_column_list := NULL;
    l_column_list_new := NULL;
    --
    -- Call get_column_clause if there is no Hive metadata and the file
    -- is in parquet format.
    --
    IF (column_list IS NULL OR update_columns) AND l_type = 'parquet' THEN
      l_partition_file := UTL_URL.unescape(l_pfile_array.get_String(0));
      l_first_file_uri := DOUBLE_QUOTE || l_partition_file || DOUBLE_QUOTE;
      l_column_list_new := get_column_clause(
                           credential_schema => invoker_schema,
                           credential_name   => credential_name,
                           file_uri_list     => l_first_file_uri,
                           base_table        => NULL,
                           base_table_schema => NULL,
                           column_list       => NULL,
                           schema_strategy   =>
                             DBMS_CLOUD.FORMAT_BD_SCHEMA_FIRST,
                           exttab_type       => l_type);
      l_column_list_new := REPLACE(l_column_list_new, NEWLINE);
      l_column_list_new := REPLACE(l_column_list_new, ' BYTE');
      l_column_list_new := REPLACE(l_column_list_new, DOUBLE_QUOTE);
      l_column_list_new :=
        TRIM(LOWER(SUBSTR(l_column_list_new, 2, LENGTH(l_column_list_new)-2)));

      IF column_list IS NOT NULL AND update_columns THEN
        -- both l_column_list and l_column_list_new NOT NULL
        l_column_list := column_list;
      ELSE
        column_list := l_column_list_new;
        l_column_list := NULL;
      END IF;
    ELSE
      l_column_list := column_list;
      l_column_list_new := NULL;
    END IF;

    IF l_column_list IS NULL AND l_column_list_new IS NULL THEN
      raise_application_error(-20000, 'Missing column list');
    END IF;
    l_column_list := REPLACE(l_column_list, DOUBLE_QUOTE);

    -- return the new column_list to the caller
    IF update_columns AND NOT l_column_list = l_column_list_new THEN
      l_column_list := l_column_list_new;
      column_list := l_column_list_new;
    END IF;

    -- generate a column list object
    l_column_count := REGEXP_COUNT(l_column_list, COMMA);
    IF l_column_list IS NOT NULL THEN
      l_tmpstr2 := LEFT_BRACKET;
      FOR i IN 1..l_column_count+1 LOOP
        l_tmpstr := REGEXP_SUBSTR(l_column_list, '[^,]+', 1, i);
        l_column := DBMS_ASSERT.enquote_name(REGEXP_SUBSTR(l_tmpstr,
          '[^ ]+', 1, 1), FALSE);
        l_datatype := DBMS_ASSERT.enquote_name(REGEXP_SUBSTR(l_tmpstr,
          '[^ ]+', 1, 2), FALSE);
        l_tmpstr2 := l_tmpstr2 || TRIM(l_column) || ':' || TRIM(l_datatype) ||
          COMMA;
      END LOOP;
      l_tmpstr2 := RTRIM(l_tmpstr2, COMMA) || RIGHT_BRACKET;
      l_tmpstr2 := REPLACE(l_tmpstr2, NEWLINE);
      l_column_list_object := JSON_OBJECT_T.parse(l_tmpstr2);
    END IF;

    l_p_counter := 1;
    l_partition_clause := NEWLINE || 'PARTITION BY LIST (' ||
      l_partition_string || RIGHT_ROUND_BRACKET;
    l_partition_clause := l_partition_clause || NEWLINE ||
      LEFT_ROUND_BRACKET || NEWLINE;

    --------------------------------------------------------------------------
    -- 4. Go through the partition files (i.e. query result of list_objects)
    --    and generate a patitioning spec.
    --
    --    We need parse files in a loop and generate the partitions
    --    e.g.
    --    INPUT : country=USA/year=2020/month=01/file1.csv
    --    OUTPUT: PARTITION P1 VALUES (('USA',2020,'01'))
    --            LOCATION('<uri_parent>/country=USA/year=2020/month=01/*.csv')
    --------------------------------------------------------------------------

    FOR k IN 0..l_pfile_array.get_size-1 LOOP
      -- l_partition_file looks like 'country=MEX/year=2020/month=01/file1.csv'
      l_partition_file := UTL_URL.unescape(l_pfile_array.get_String(k));
      l_partition_count := REGEXP_COUNT(l_partition_file, SLASH);

      -- sanity check: skip if l_partition_count < l_p_columns_array_size
      IF l_partition_count < l_p_columns_array_size THEN
        CONTINUE;
      END IF;

      l_partition_name := NULL;
      l_partition_value := 'PARTITION P' || l_p_counter ||
        ' VALUES ' || LEFT_ROUND_BRACKET || LEFT_ROUND_BRACKET;

      --
      -- 4.1. work on a partition file for its partition values and location
      -- e.g.
      -- When l_partition_count = 3, legit l_partition_file can be
      --
      --   1. country=USA/year=20/month=01/file1.csv (l_partition_count = 3)
      --   2. .../country=USA/year=20/month=01/file1.csv (l_partition_count > 3)
      --
      -- therefore, we need to test l_partition_file
      --
      -- e.g.
      -- SQL>  select regexp_substr(
      --               'country=USA/year=2021/month=12/file3.csv',
      --               '(\/[^/]+){4}$') from dual;
      -- NULL
      --
      -- SQL>  select regexp_substr(
      --               'xxx/yyy/zzz/country=USA/year=2021/month=12/file3.csv',
      --               '(\/[^/]+){4}$') from dual;
      -- /country=USA/year=2021/month=12/file3.csv
      --

      --
      -- Pre-process the partition file if it has more partitions than expected
      --
      IF l_partition_count > l_p_columns_array_size THEN
        l_tmpcount := l_p_columns_array_size + 1;
        l_tmpstr := '(\/[^/]+){' || l_tmpcount || '}$';
        l_tmpstr := REGEXP_SUBSTR(l_partition_file, l_tmpstr);
        l_partition_file_orig := l_partition_file;
        l_partition_file := REGEXP_REPLACE(l_tmpstr, '^\/', '');
      END IF;

      FOR j IN 1..l_p_columns_array_size LOOP

        l_tmpstr := REGEXP_SUBSTR(l_partition_file, '[^/]+', 1, j);
        l_partition_name := l_partition_name || l_tmpstr || SLASH;

        -- Check if the partition (e.g. country=USA or USA) has a = sign
        l_tmpcount := REGEXP_COUNT(l_tmpstr, EQUAL_SIGN);

        IF NOT l_tmpcount = 0 THEN
          -- If there is a = sign, then parse the column name and value
          l_value_str := REGEXP_SUBSTR(l_tmpstr, '[^=]+', 1, 2);
        ELSE
          -- If there is no = sign
          l_value_str := l_tmpstr;
        END IF;

        --
        -- 4.2. Work on partition values
        --
        l_tmpstr :=
          l_column_list_object.get_string(l_p_columns_array.get_String(j-1));
        l_datatype := REGEXP_SUBSTR(l_tmpstr, '[^(]+', 1, 1);

        IF NOT j = l_p_columns_array_size THEN
          l_tmpstr2 := COMMA;
        ELSE
          l_tmpstr2 := RIGHT_ROUND_BRACKET || RIGHT_ROUND_BRACKET || WHITESPACE;
        END IF;

        CASE
          WHEN UPPER(l_datatype) IN
            ('NUMBER', 'INTEGER', 'PLS_INTEGER', 'BINARY_INTEGER') THEN
            IF IS_NUMBER(l_value_str) THEN
              l_tmpcount := TO_NUMBER(l_value_str);
              l_partition_value := l_partition_value || l_value_str ||
                l_tmpstr2;
            ELSE
              raise_application_error(DBMS_CLOUD.EXCP_INVALID_OBJ_URI,
                  'Invalid partitioning column in - ' || l_partition_file_orig);
            END IF;
          WHEN UPPER(l_datatype) IN ('DATE') THEN
            -- user must use default format NLS_DATE_FORMAT
            l_tmpstr := 'TO_DATE' || LEFT_ROUND_BRACKET || SINGLE_QUOTE ||
              l_value_str || SINGLE_QUOTE || RIGHT_ROUND_BRACKET;
            l_partition_value := l_partition_value || l_tmpstr || l_tmpstr2;
          WHEN UPPER(l_datatype) IN ('TIMESTAMP') THEN
            -- user must use default format NLS_TIMESTAMP_FORMAT
            l_tmpstr := 'TO_TIMESTAMP' || LEFT_ROUND_BRACKET || SINGLE_QUOTE ||
              l_value_str || SINGLE_QUOTE || RIGHT_ROUND_BRACKET;
            l_partition_value := l_partition_value || l_tmpstr || l_tmpstr2;
          ELSE
            l_partition_value := l_partition_value || SINGLE_QUOTE ||
              l_value_str || SINGLE_QUOTE || l_tmpstr2;
        END CASE;

      END LOOP;

      IF l_partition_name = l_partition_previous THEN
        CONTINUE;
      END IF;

      IF l_partition_count > l_p_columns_array_size THEN
        l_tmpstr2 := SUBSTR(l_partition_file_orig, 1,
          LENGTH(l_partition_file_orig)-LENGTH(l_partition_file));
        l_partition_location := 'LOCATION(''' ||
          l_tmpstr2 || l_partition_name || l_file_uri_tail || '''),' ||
          NEWLINE;
      ELSE
        l_partition_location := 'LOCATION(''' ||
          l_partition_name || l_file_uri_tail || '''),' || NEWLINE;
      END IF;
      l_p_counter := l_p_counter + 1;
      l_partition_previous := l_partition_name;
      l_partition_array.append(l_partition_value || l_partition_location);
    END LOOP;

    IF l_partition_array.get_size = 0 THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OBJ_URI,
          'Nothing matched query uri list - ' || file_uri_list);
    END IF;

    FOR k IN 0..l_partition_array.get_size-1 LOOP
      l_tmpstr := l_partition_array.get_String(k);
      l_partition_clause := l_partition_clause || l_tmpstr;
    END LOOP;
    l_partition_clause := RTRIM(l_partition_clause, COMMA || NEWLINE);

    l_partition_clause := l_partition_clause || NEWLINE || RIGHT_ROUND_BRACKET;
    partition_array := l_partition_array;

    RETURN TRIM(l_partition_clause);

  EXCEPTION
    WHEN VALUE_ERROR THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OBJ_URI,
         'Invalid partitioning column in - ' || l_partition_file_orig);

  END generate_partitioning_clause;


  -----------------------------------------------------------------------------
  -- validate_aws_external_id - Validate the existence of aws external id
  -----------------------------------------------------------------------------
  PROCEDURE validate_aws_external_id(
        aws_role_arn  IN  VARCHAR2
  )
  IS
    --
    -- NAME:
    --   validate_aws_external_id - Validate the existence of the external id
    --
    -- DESCRIPTION:
    --   This function sends an assume role request with a null value as the
    --   external id. If no external id is set in user's aws console, the
    --   request will succeed. If so, raise an error to remind users to set the
    --   external id in the aws console as setting external id is essential for
    --   the securty of AWS ARN authentication.
    --
    -- PARAMETERS:
    --   aws_role_arn (IN)  - AWS role Amazon Resource Name
    --
    -- NOTES:
    --   Added as part of Bug 32857944.
    --
  BEGIN
    DBMS_CLOUD_REQUEST.assume_role(aws_role_arn     => aws_role_arn,
                                   region           => AWS_DEFAULT_REGION,
                                   external_id_type => NULL);
  EXCEPTION
    WHEN OTHERS THEN
      -- If external id is set, the assume role operation will fail with a null
      -- external id. Ignore the error as it is expected.
      IF SQLCODE != -20403 THEN
        RAISE;
      END IF;
  END validate_aws_external_id;


 -----------------------------------------------------------------------------
 --                    PUBLIC PROCEDURE/FUNCTION DEFINITIONS
 -----------------------------------------------------------------------------

 -----------------------------------------------------------------------------
 -- create_credential - Create a Credential object to access any Object Store
 -----------------------------------------------------------------------------
 PROCEDURE create_credential(
       invoker_schema   IN  VARCHAR2,
       credential_name  IN  VARCHAR2,
       username         IN  VARCHAR2,
       password         IN  VARCHAR2   DEFAULT NULL
 )
 IS
   l_credential_name  VARCHAR2(M_QUAL_IDEN);
   l_comments         DBMS_ID;
   l_stmt             VARCHAR2(M_VCSIZ_4K);
  BEGIN

     -- Initialize locals
     l_credential_name := DBMS_CLOUD_CORE.get_qualified_name(
                                object_name => credential_name,
                                schema_name => invoker_schema,
                                type => DBMS_CLOUD_CORE.ASSERT_TYPE_CRED);

     -- Bug 30536011: Validate credential username and password
     validate_credential_attribute(CREDATTR_USERNAME, username);
     validate_credential_attribute(CREDATTR_PASSWORD, password);

     --
     -- Log the credential operation
     --
     log_credential_op(operation       => OPER_CREATE_CRED,
                       invoker_schema  => invoker_schema,
                       credential_name => l_credential_name,
                       username        => username);

     l_comments := '{"comments":"Created via DBMS_CLOUD.create_credential"}';

     --
     -- Create the credential object
     -- Bug 32011671: create cloud credential for import/export of credentials
     --
     -- Bug 32635835: Call internal create_credential API
     create_credential_int(credential_name => l_credential_name,
                           username        => username,
                           password        => password,
                           comments        => l_comments);

  EXCEPTION
    WHEN cred_exist THEN
      raise_application_error(DBMS_CLOUD.EXCP_CRED_EXIST,
          'Credential ' || l_credential_name || ' already exists');
  END create_credential;


  -----------------------------------------------------------------------------
  -- create_credential - Create a Key based Credential object
  -----------------------------------------------------------------------------
  PROCEDURE create_credential(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        user_ocid        IN  VARCHAR2   DEFAULT NULL,
        tenancy_ocid     IN  VARCHAR2   DEFAULT NULL,
        private_key      IN  VARCHAR2,
        fingerprint      IN  VARCHAR2   DEFAULT NULL,
        passphrase       IN  VARCHAR2   DEFAULT NULL,
        rpst             IN  VARCHAR2   DEFAULT NULL
  )
  IS
    l_key              JSON_ELEMENT_T;
    l_key_obj          JSON_OBJECT_T;
    l_credential_name  VARCHAR2(M_QUAL_IDEN);
    l_comments         DBMS_ID;
    l_username         DBMS_ID;
    l_stmt             VARCHAR2(M_VCSIZ_4K);
  BEGIN

     -- Bug 29353148: do not allow oci native credential to be created if the
     -- corresponding capability is disabled
     l_stmt := 'BEGIN                                    ' ||
               ' DBMS_CLOUD_CAPABILITY.check_capability( ' ||
               '   ''OCI NATIVE CREDENTIAL'');           ' ||
               'END;';
     EXECUTE IMMEDIATE l_stmt;
     -- Initialize locals
     l_credential_name := DBMS_CLOUD_CORE.get_qualified_name(
                                object_name => credential_name,
                                schema_name => invoker_schema,
                                type => DBMS_CLOUD_CORE.ASSERT_TYPE_CRED);

     -- Create a new JSON document for the credential object
     l_key      := JSON_ELEMENT_T.parse('{}');
     l_key_obj  := treat(l_key AS JSON_OBJECT_T);

     -- Bug 29905394: Validate credential key attributes
     -- Setup the key with credential attributes
     IF rpst IS NULL THEN
       validate_credential_attribute(CREDATTR_USEROCID, user_ocid);
       validate_credential_attribute(CREDATTR_TENANCYOCID, tenancy_ocid);
       validate_credential_attribute(CREDATTR_FINGERPRINT, fingerprint);
       l_key_obj.put(CREDATTR_TENANCYOCID, tenancy_ocid);
       l_key_obj.put(CREDATTR_FINGERPRINT, fingerprint);
       l_username := user_ocid;
       l_comments := '{"comments":"Created native credential via ' ||
                     'DBMS_CLOUD.create_credential"}';
     ELSE
       validate_credential_attribute(CREDATTR_RPST, rpst);
       -- If RPST is given, then only private key argument is required.
       IF user_ocid IS NOT NULL OR
          tenancy_ocid IS NOT NULL OR
          fingerprint IS NOT NULL
       THEN
         raise_application_error(DBMS_CLOUD.EXCP_INVALID_CRED_ATTR,
           'tenancy_ocid, user_ocid or fingerprint cannot be specified' ||
           ' with resource principal session token');
       END IF;
       l_key_obj.put(CREDATTR_RPST, rpst);
       --  Bug 32011671: set rpst credential user as invoker schema
       l_username := DBMS_CLOUD_CORE.unquote_name(invoker_schema);
       l_comments := '{"comments":"Created resource principal credential ' ||
                     'via DBMS_CLOUD.create_credential"}';
     END IF;
     validate_credential_attribute(CREDATTR_PRIVATEKEY, private_key);
     l_key_obj.put(CREDATTR_PRIVATEKEY,  sanitize_private_key(private_key));


     --
     -- Log the credential operation
     --
     log_credential_op(operation       => OPER_CRT_NATIVE_CRED,
                       invoker_schema  => invoker_schema,
                       credential_name => l_credential_name,
                       username        => l_username);

     --
     -- Create the credential object
     --
     -- When using RPST, user_ocid is not required. However, credential object
     -- requires a username. So we will use special constant as username.
     --
     -- Bug 32011671: create cloud credential for import/export of credentials
     --
     -- Bug 32635835: Call internal create_credential API
     create_credential_int(credential_name => l_credential_name,
                           username        => l_username,
                           password        => passphrase,
                           comments        => l_comments,
                           key             => l_key_obj.to_string);

  END create_credential;


  -----------------------------------------------------------------------------
  -- create_credential - Create a Credential object using credential parameters
  -----------------------------------------------------------------------------
  PROCEDURE create_credential(
        invoker_schema    IN  VARCHAR2,
        credential_name   IN  VARCHAR2,
        params_obj        IN  JSON_OBJECT_T,
        auth_type         IN  VARCHAR2
  )
  IS
    l_credential_name       VARCHAR2(M_QUAL_IDEN);
    l_params_keys           JSON_KEY_LIST;
    l_comments              DBMS_ID;
    l_key                   JSON_ELEMENT_T;
    l_key_obj               JSON_OBJECT_T;
    l_username              VARCHAR2(M_IDEN);
    l_stmt                  VARCHAR2(M_VCSIZ_4K);
    l_aws_role_arn          VARCHAR2(M_AWS_ROLE_ARN);
    l_external_id_type      VARCHAR2(M_IDEN);
  BEGIN
    -- Initialize locals
    l_credential_name := DBMS_CLOUD_CORE.get_qualified_name(
                               object_name => credential_name,
                               schema_name => invoker_schema,
                               type => DBMS_CLOUD_CORE.ASSERT_TYPE_CRED);

    -- Create a new JSON document for the credential object
    l_key      := JSON_ELEMENT_T.parse('{}');
    l_key_obj  := treat(l_key AS JSON_OBJECT_T);

    CASE auth_type
      WHEN AWS_ARN THEN
        l_aws_role_arn := TRIM(params_obj.get_string(PARAM_AWS_ROLE_ARN));

        -- Validate credential aws_role_arn
        validate_credential_attribute(CREDATTR_AWSROLEARN, l_aws_role_arn);

        -- Bug 32857944: Validate if external id is set in the role's trust
        -- relationship.
        validate_aws_external_id(l_aws_role_arn);

        -- Validate input parameters.
        l_params_keys := params_obj.get_keys;

        FOR i IN 1..l_params_keys.COUNT  LOOP
          CASE LOWER(TRIM(l_params_keys(i)))
            WHEN PARAM_AWS_ROLE_ARN THEN
              NULL;
            WHEN PARAM_EXTERNAL_ID_TYPE THEN
              NULL;
            ELSE
              raise_application_error(-20041,
                'Invalid parameter for creating credential - ' ||
                l_params_keys(i));
          END CASE;
        END LOOP;

        -- Store the full ARN of the AWS IAM role in the key object.
        l_key_obj.put(CREDATTR_AWSROLEARN, l_aws_role_arn);
        l_username := SUBSTR(l_aws_role_arn, 1, M_IDEN);

        l_external_id_type := TRIM(params_obj.get_string(
                                     PARAM_EXTERNAL_ID_TYPE));
        IF l_external_id_type IS NOT NULL AND
           LENGTH(TRIM(l_external_id_type)) != 0
        THEN
          validate_credential_attribute(CREDATTR_EXTERNALIDTYPE,
                                        l_external_id_type);
          -- Store the external id in the key object.
          l_key_obj.put(CREDATTR_EXTERNALIDTYPE, l_external_id_type);
        END IF;

        l_comments := '{"comments":"Created ARN based credential via' ||
                      'DBMS_CLOUD.create_credential"}';

      WHEN GCP_PA THEN
        -- Validate credential gcp_pa
        validate_credential_attribute(CREDATTR_GCPPA, gcp_pa);

        -- Store the gcp_pa attribute in the key object.
        l_key_obj.put(CREDATTR_GCPPA, gcp_pa);
        l_username := 'GCP$PA';

        l_comments := '{"comments":"Created GCP PA based credential via' ||
                      'DBMS_CLOUD.create_credential"}';
    END CASE;

    BEGIN
      --
      -- Log the credential operation
      --
      log_credential_op(operation       => OPER_CREATE_CRED,
                        invoker_schema  => invoker_schema,
                        credential_name => l_credential_name,
                        username        => l_username);

      --
      -- Create the credential object
      --
      --
      -- Bug 32635835: Call internal create_credential API
      create_credential_int(credential_name => l_credential_name,
                            username        => l_username,
                            password        => NULL,
                            comments        => l_comments,
                            key             => l_key_obj.to_string);
    EXCEPTION
      WHEN cred_exist THEN
        raise_application_error(DBMS_CLOUD.EXCP_CRED_EXIST,
            'Credential ' || l_credential_name || ' already exists');
    END;
  END create_credential;


  -----------------------------------------------------------------------------
  -- create_credential - Create a Credential object using credential parameters
  -----------------------------------------------------------------------------
  PROCEDURE create_credential(
        invoker_schema    IN  VARCHAR2,
        credential_name   IN  VARCHAR2,
        params            IN  CLOB DEFAULT NULL
  )
  IS
    l_params_obj     JSON_OBJECT_T;
  BEGIN
    l_params_obj := parse_json_parameters(params);

    IF l_params_obj IS NOT NULL AND
       l_params_obj.get_string(PARAM_AWS_ROLE_ARN) IS NOT NULL AND
       LENGTH(TRIM(l_params_obj.get_string(PARAM_AWS_ROLE_ARN))) > 0 THEN
      create_credential(
          invoker_schema  => invoker_schema,
          credential_name => credential_name,
          params_obj      => l_params_obj,
          auth_type       => AWS_ARN
      );

    ELSIF l_params_obj IS NOT NULL AND
          l_params_obj.get_string(PARAM_GCP_PA) IS NOT NULL AND
          LENGTH(TRIM(l_params_obj.get_string(PARAM_GCP_PA))) > 0 THEN
      create_credential(
          invoker_schema  => invoker_schema,
          credential_name => credential_name,
          params_obj      => l_params_obj,
          auth_type       => GCP_PA
      );
    END IF;

  END create_credential;


  -----------------------------------------------------------------------------
  -- drop_credential  - Drop a Credential object to access any Object Store
  -----------------------------------------------------------------------------
  PROCEDURE drop_credential(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2
  )
  IS
    l_credential_name   VARCHAR2(M_QUAL_IDEN);
    l_stmt              VARCHAR2(M_VCSIZ_4K);
  BEGIN

    -- Initialize locals
    l_credential_name := DBMS_CLOUD_CORE.get_qualified_name(
                                object_name => credential_name,
                                schema_name => invoker_schema,
                                type => DBMS_CLOUD_CORE.ASSERT_TYPE_CRED);

    --
    -- Log the credential operation
    --
    log_credential_op(operation       => OPER_DROP_CRED,
                      invoker_schema  => invoker_schema,
                      credential_name => l_credential_name);

    --
    -- Drop the credential object
    --
    l_stmt := 'BEGIN                                                       ' ||
              '  DBMS_CREDENTIAL.drop_credential(credential_name => :1 ,   ' ||
              '                                  force           => TRUE); ' ||
              'END;';

    EXECUTE IMMEDIATE l_stmt using IN l_credential_name;

  EXCEPTION
    WHEN cred_not_exist THEN
      raise_application_error(DBMS_CLOUD.EXCP_CRED_NOT_EXIST,
         'Credential ' || l_credential_name || ' does not exist');
  END drop_credential;


  -----------------------------------------------------------------------------
  -- enable_credential  - Enable a Credential object to access any Object Store
  -----------------------------------------------------------------------------
  PROCEDURE enable_credential(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2
  )
  IS
    l_credential_name   VARCHAR2(M_QUAL_IDEN);
    l_stmt              VARCHAR2(M_VCSIZ_4K);
  BEGIN

    -- Initialize locals
    l_credential_name := DBMS_CLOUD_CORE.get_qualified_name(
                                object_name => credential_name,
                                schema_name => invoker_schema,
                                type => DBMS_CLOUD_CORE.ASSERT_TYPE_CRED);

    --
    -- Log the credential operation
    --
    log_credential_op(operation       => OPER_ENABLE_CRED,
                      invoker_schema  => invoker_schema,
                      credential_name => l_credential_name);

    --
    -- Enable the credential object
    --
    l_stmt := 'BEGIN                                                       ' ||
              '  DBMS_CREDENTIAL.enable_credential(credential_name => :1 );' ||
              'END;';

    EXECUTE IMMEDIATE l_stmt using IN l_credential_name;

  EXCEPTION
    WHEN cred_not_exist THEN
      raise_application_error(DBMS_CLOUD.EXCP_CRED_NOT_EXIST,
         'Credential ' || l_credential_name || ' does not exist');
  END enable_credential;


  -----------------------------------------------------------------------------
  -- disable_credential - Disable a Credential object to access Object Store
  -----------------------------------------------------------------------------
  PROCEDURE disable_credential(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2
  )
  IS
    l_credential_name   VARCHAR2(M_QUAL_IDEN);
    l_stmt              VARCHAR2(M_VCSIZ_4K);
  BEGIN

    -- Initialize locals
    l_credential_name := DBMS_CLOUD_CORE.get_qualified_name(
                                object_name => credential_name,
                                schema_name => invoker_schema,
                                type => DBMS_CLOUD_CORE.ASSERT_TYPE_CRED);
    --
    -- Log the credential operation
    --
    log_credential_op(operation       => OPER_DISABLE_CRED,
                      invoker_schema  => invoker_schema,
                      credential_name => l_credential_name);
    --
    -- Disable the credential object
    --
    l_stmt := 'BEGIN                                                         '||
              '  DBMS_CREDENTIAL.disable_credential(credential_name => :1 ,  '||
              '                                     force           => TRUE);'||
              'END;';

    EXECUTE IMMEDIATE l_stmt using IN l_credential_name;

  EXCEPTION
    WHEN cred_not_exist THEN
      raise_application_error(DBMS_CLOUD.EXCP_CRED_NOT_EXIST,
         'Credential ' || l_credential_name || ' does not exist');
  END disable_credential;


  -----------------------------------------------------------------------------
  -- update_rpst_credential - Update RPST Credential object
  -----------------------------------------------------------------------------
  PROCEDURE update_rpst_credential(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        rpst             IN  VARCHAR2,
        private_key      IN  VARCHAR2
  )
  IS
    l_credential_name   VARCHAR2(M_QUAL_IDEN);
    l_username          VARCHAR2(M_USERNAME_PASSWORD_LEN);
    l_password          VARCHAR2(M_USERNAME_PASSWORD_LEN);
    l_key               VARCHAR2(M_KEY_LEN);
    l_key_obj           JSON_OBJECT_T;
    l_stmt              VARCHAR2(M_VCSIZ_4K);
  BEGIN

    -- Initialize locals
    l_credential_name := DBMS_CLOUD_CORE.get_qualified_name(
                                object_name => credential_name,
                                schema_name => invoker_schema,
                                type => DBMS_CLOUD_CORE.ASSERT_TYPE_CRED);

    -- Validate inputs
    validate_credential_attribute(CREDATTR_RPST, rpst);
    validate_credential_attribute(CREDATTR_PRIVATEKEY, private_key);

    -- Read the current key attribute from the credential
    -- First get the KEY from credential, and then update the JSON attributes
    -- in the KEY.
    BEGIN
      get_credential_info(credential_name => l_credential_name,
                          username        => l_username,      -- unused
                          password        => l_password,      -- unused
                          key             => l_key            -- KEY attribute
        );
    EXCEPTION
      WHEN cred_disabled THEN
        NULL;
      WHEN OTHERS THEN
        RAISE;
    END;

    -- Bug 29353148: Do not allow KEY based authentication attributes to be
    -- updated if KEY is NULL
    IF l_key IS NULL OR JSON_OBJECT_T(l_key).get_keys IS NULL THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_CRED_ATTR,
        'key based authentication attributes can only be updated in a ' ||
        'credential with already a key associated with it');
    END IF;

    -- Parse the existing KEY JSON
    l_key_obj := JSON_OBJECT_T.parse(l_key);

    -- Update the rpst and private key attributes in the KEY JSON
    -- Bug 30536271: Sanitize value of private key
    l_key_obj.put(CREDATTR_PRIVATEKEY, sanitize_private_key(private_key));
    l_key_obj.put(CREDATTR_RPST, rpst);

    --
    -- Update the KEY attribute in credential object
    --
    l_stmt := 'BEGIN                                                       ' ||
              '  DBMS_CREDENTIAL.update_credential(credential_name => :1 , ' ||
              '                                    attribute       => :2 , ' ||
              '                                    value           => :3); ' ||
              'END;';

    EXECUTE IMMEDIATE l_stmt using IN l_credential_name,
                                   IN CREDATTR_KEY,
                                   IN l_key_obj.to_string;

  EXCEPTION
    WHEN cred_not_exist THEN
      raise_application_error(DBMS_CLOUD.EXCP_CRED_NOT_EXIST,
         'Credential ' || l_credential_name || ' does not exist');
  END update_rpst_credential;


  -----------------------------------------------------------------------------
  -- update_credential - Update a Credential object to access Object Store
  -----------------------------------------------------------------------------
  PROCEDURE update_credential(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        attribute        IN  VARCHAR2,
        value            IN  VARCHAR2
  )
  IS
    l_credential_name   VARCHAR2(M_QUAL_IDEN);
    l_attribute         DBMS_ID;
    l_value             VARCHAR2(M_KEY_LEN);
    l_username          VARCHAR2(M_USERNAME_PASSWORD_LEN);
    l_password          VARCHAR2(M_USERNAME_PASSWORD_LEN);
    l_key               VARCHAR2(M_KEY_LEN);
    l_key_obj           JSON_OBJECT_T;
    l_stmt              VARCHAR2(M_VCSIZ_4K);
  BEGIN

    -- Initialize locals
    l_attribute       := LOWER(attribute);
    l_credential_name := DBMS_CLOUD_CORE.get_qualified_name(
                                object_name => credential_name,
                                schema_name => invoker_schema,
                                type => DBMS_CLOUD_CORE.ASSERT_TYPE_CRED);

    -- Validate credential attribute
    validate_credential_attribute(l_attribute, value);

    l_value           := value;

    -- If the attribute is part of KEY attribute, then first get the KEY
    -- from credential, and then update the JSON attribute in the KEY.
    -- Bug 29905950: remove passphrase. Add it back here when we support it
    IF l_attribute IN
      (CREDATTR_USEROCID, CREDATTR_TENANCYOCID, CREDATTR_PRIVATEKEY,
       CREDATTR_FINGERPRINT, CREDATTR_RPST)
    THEN

      -- Bug 29353148: do not allow oci native credential update if the
      -- corresponding capability is disabled
      l_stmt := 'BEGIN                                     ' ||
                ' DBMS_CLOUD_CAPABILITY.check_capability(  ' ||
                '   ''OCI NATIVE CREDENTIAL'');            ' ||
                'END;';
      EXECUTE IMMEDIATE l_stmt;

      BEGIN
        get_credential_info(credential_name => l_credential_name,
                            username        => l_username,     -- unused
                            password        => l_password,     -- unused
                            key             => l_key    -- KEY attribute
        );
      EXCEPTION
        WHEN cred_disabled THEN
          NULL;
        WHEN OTHERS THEN
          RAISE;
      END;

      -- Bug 29353148: Do not allow KEY based authentication attributes to be
      -- updated if KEY is NULL
      -- Bug 32437837: Raise error if ARN credentials try to update non-aws arn
      -- key/value pairs.
      IF l_key IS NULL OR JSON_OBJECT_T(l_key).get_keys IS NULL OR
         JSON_OBJECT_T(l_key).get_string(CREDATTR_AWSROLEARN) IS NOT NULL
      THEN
        raise_application_error(DBMS_CLOUD.EXCP_INVALID_CRED_ATTR,
                                l_attribute ||
                                ' can only be updated in private key' ||
                                ' based credentials');
      END IF;

      IF l_attribute = CREDATTR_USEROCID THEN
        l_attribute := CREDATTR_USERNAME;
      ELSIF l_attribute = CREDATTR_PASSPHRASE THEN
        l_attribute := CREDATTR_PASSWORD;
      ELSE
        -- Parse the existing KEY JSON
        l_key_obj := JSON_OBJECT_T.parse(l_key);

        -- Update the attribute in the KEY JSON
        -- Bug 30536271: Sanitize value of private key
        IF l_attribute = CREDATTR_PRIVATEKEY THEN
          l_key_obj.put(l_attribute, sanitize_private_key(value));
        ELSE
          l_key_obj.put(l_attribute, value);
        END IF;

        -- Change the attribute and value to be passed to dbms_credential
        l_attribute := CREDATTR_KEY;
        l_value     := l_key_obj.to_string;
      END IF;

    ELSIF l_attribute IN (CREDATTR_USERNAME, CREDATTR_PASSWORD) THEN

      -- Get the credential info to check if KEY is already part of it
      BEGIN
        get_credential_info(credential_name => l_credential_name,
                            username        => l_username,     -- unused
                            password        => l_password,     -- unused
                            key             => l_key    -- KEY attribute
        );
      EXCEPTION
        WHEN cred_disabled THEN
          NULL;
        WHEN OTHERS THEN
          RAISE;
      END;

      -- Bug 29353148: If KEY is not an empty JSON, then the credential cannot
      -- be updated with password
      IF l_key IS NOT NULL AND
         JSON_OBJECT_T(l_key).get_keys IS NOT NULL THEN
        raise_application_error(DBMS_CLOUD.EXCP_INVALID_CRED_ATTR,
          'password cannot be updated in a credential with' ||
          ' an associated key');
      END IF;

    ELSIF l_attribute IN (CREDATTR_AWSROLEARN, CREDATTR_EXTERNALIDTYPE) THEN

      -- Get the credential info to check if KEY is already part of it
      BEGIN
        get_credential_info(credential_name => l_credential_name,
                            username        => l_username,     -- unused
                            password        => l_password,     -- unused
                            key             => l_key    -- KEY attribute
        );
      EXCEPTION
        WHEN cred_disabled THEN
          NULL;
        WHEN OTHERS THEN
          RAISE;
      END;

      -- Bug 32437837: Raise error if non-AWS ARN credentials try to update
      -- aws arn key-value pairs.
      IF l_key IS NULL OR
         JSON_OBJECT_T(l_key).get_keys IS NULL OR
         JSON_OBJECT_T(l_key).get_string(CREDATTR_PRIVATEKEY) IS NOT NULL
      THEN
        raise_application_error(DBMS_CLOUD.EXCP_INVALID_CRED_ATTR,
          l_attribute || ' can only be updated in aws arn based credentials');
      END IF;

      IF l_attribute = CREDATTR_AWSROLEARN THEN
        -- Bug 32857944: Validate if external id is set in the role's trust
        -- relationship.
        validate_aws_external_id(l_value);

        l_attribute := CREDATTR_USERNAME;

        --
        -- Log the credential operation
        --
        log_credential_op(operation       => OPER_UPDATE_CRED,
                          invoker_schema  => invoker_schema,
                          credential_name => l_credential_name,
                          username        => l_username);

        --
        -- Update the username attribute in credential object
        --
        l_stmt :=
              'BEGIN                                                       ' ||
              '  DBMS_CREDENTIAL.update_credential(credential_name => :1 , ' ||
              '                                    attribute       => :2 , ' ||
              '                                    value           => :3); ' ||
              'END;';

        -- As the maximum length of aws role arn can be 2048, truncate it and
        -- update it in the username column.
        EXECUTE IMMEDIATE l_stmt using IN l_credential_name,
                                       IN l_attribute,
                                       IN SUBSTR(l_value, 1, M_IDEN);

        -- Change the attribute name back to update it in the KEY JSON.
        l_attribute := CREDATTR_AWSROLEARN;
      END IF;

      -- Parse the existing KEY JSON
      l_key_obj := JSON_OBJECT_T.parse(l_key);

      -- Update the attribute in the KEY JSON
      l_key_obj.put(l_attribute, value);

      -- Change the attribute and value to be passed to dbms_credential
      l_attribute := CREDATTR_KEY;
      l_value     := l_key_obj.to_string;

    ELSE
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_CRED_ATTR,
        'Invalid credential attribute - ' || attribute);
    END IF;

    --
    -- Log the credential operation
    --
    log_credential_op(operation       => OPER_UPDATE_CRED,
                      invoker_schema  => invoker_schema,
                      credential_name => l_credential_name,
                      username        => l_username);

    --
    -- Update the attribute in credential object
    --
    l_stmt := 'BEGIN                                                       ' ||
              '  DBMS_CREDENTIAL.update_credential(credential_name => :1 , ' ||
              '                                    attribute       => :2 , ' ||
              '                                    value           => :3); ' ||
              'END;';

    EXECUTE IMMEDIATE l_stmt using IN l_credential_name,
                                   IN l_attribute,
                                   IN l_value;

    -- Clear the credential cache in current session
    DBMS_CLOUD_REQUEST.clear_cache;

  EXCEPTION
    WHEN cred_not_exist THEN
      raise_application_error(DBMS_CLOUD.EXCP_CRED_NOT_EXIST,
         'Credential ' || l_credential_name || ' does not exist');
  END update_credential;


  -----------------------------------------------------------------------------
  -- clear_bypass - Clear bypass for external table ddl
  -----------------------------------------------------------------------------
  PROCEDURE clear_bypass(
    bypass_value  IN  NUMBER
  )
  IS
  BEGIN
    -- Restore the bypass value, only if the bypass was modified earlier
    IF bypass_value IS NOT NULL THEN
      DBMS_CLOUD_ADMIN_INTERNAL.run_stmt(
     'ALTER SESSION SET "_pdb_lockdown_ddl_clauses" = ' || bypass_value,
           KSYS);
    END IF;
  END clear_bypass;


  -----------------------------------------------------------------------------
  -- get_create_exttab_text - Get text of Create External Table on file in
  --                          Object Store
  -----------------------------------------------------------------------------
  FUNCTION get_create_exttab_text(
        invoker_schema      IN  VARCHAR2,
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
        export_query        IN  CLOB     DEFAULT NULL,
        bypass_value        OUT NUMBER,
        base_cred_owner     IN  VARCHAR2 DEFAULT NULL,
        base_cred_name      IN  VARCHAR2 DEFAULT NULL
  ) RETURN CLOB
  IS
    -- Private variables and constants
    l_sqlstmt             CLOB;
    l_extclause           CLOB;
    l_table_name          VARCHAR2(M_QUAL_IDEN);
    l_credential_name     VARCHAR2(M_QUAL_IDEN);
    l_base_table          DBMS_QUOTED_ID;
    l_base_table_schema   DBMS_QUOTED_ID;
    l_file_uri_list       CLOB;
    l_access_parameters   CLOB;
    l_column_clause       CLOB;
    l_column_list         CLOB;
    l_format_obj          JSON_OBJECT_T;
    l_reject_limit_clause DBMS_ID;
    l_str                 DBMS_ID;
    l_log_dir             DBMS_ID;
    l_external_type       DBMS_ID;
    l_type                DBMS_ID;
    l_schema_strategy     DBMS_ID;
    l_partitioning_clause CLOB;
    l_exttype_clause      DBMS_ID;
    l_part_in_file_uri    BOOLEAN := FALSE;
    l_p_array             JSON_ARRAY_T := NULL;
  BEGIN

    -- Initialize locals
    l_table_name      := DBMS_CLOUD_CORE.get_qualified_name(
                                object_name => table_name,
                                schema_name => invoker_schema,
                                type => DBMS_CLOUD_CORE.ASSERT_TYPE_TAB);
    l_column_list := column_list;

    -- Bug 32516731: Pass the base credential owner/name to verify existence
    l_credential_name := validate_ext_credential_name(
                                invoker_schema, credential_name, os_ext_table,
                                base_cred_owner, base_cred_name);

    l_file_uri_list   := file_uri_list;
    IF log_dir IS NOT NULL THEN
      l_log_dir       := DBMS_CLOUD_CORE.assert_simple_sql_name(
                                log_dir, DBMS_CLOUD_CORE.ASSERT_TYPE_DIR);
    END IF;

    -- Bug 26940179: base_table and base_table_schema should be validated for
    -- sql injection
    IF base_table IS NOT NULL THEN
      l_base_table :=  DBMS_CLOUD_CORE.unquote_name(base_table);
    END IF;

    IF base_table_schema IS NULL THEN
      l_base_table_schema := invoker_schema;
    ELSE
      l_base_table_schema := base_table_schema;
    END IF;
    l_base_table_schema := DBMS_CLOUD_CORE.unquote_name(l_base_table_schema);

    -- Parse the format parameters JSON
    l_format_obj := parse_format_parameters(format => format);

    -- Enh#33016310: work on the partition_columns
    IF (partitioning_clause IS NULL OR LENGTH(partitioning_clause) = 0) AND
       file_uri_list IS NOT NULL AND part_table = TRUE THEN
      l_part_in_file_uri := TRUE;
      -- generate partitioning_clause using the columns
      l_partitioning_clause :=
        generate_partitioning_clause(invoker_schema, l_credential_name,
          l_table_name, l_file_uri_list, l_column_list, l_format_obj,
          l_p_array, FALSE);
    ELSE
      -- Validate partitioning clause
      IF part_table = TRUE OR hybrid_table = TRUE THEN
        l_partitioning_clause := validate_partitioning_clause(
                                 partitioning_clause => partitioning_clause,
                                 hybrid_table        => hybrid_table);
      ELSE
        -- Parse the file uri list to generate a comma separate list of quoted
        -- file uri's
        parse_file_uri(file_uri_list => l_file_uri_list,
                       os_ext_table  => os_ext_table);
      END IF;
    END IF;

    -- Only log create external table operation for non-OS tables
    IF os_ext_table = FALSE THEN
      --
      -- Log external table operation
      --
      log_exttab_op(operation         => OPER_CREATE_EXT,
                    invoker_schema    => invoker_schema,
                    table_name        => l_table_name,
                    base_table_name   => l_base_table,
                    base_table_schema => l_base_table_schema,
                    credential_name   => l_credential_name,
                    parent_operation  => parent_operation);
    END IF;

    --
    -- Type of external table
    --
    l_type := UPPER(TRIM(get_json_string(l_format_obj,
                                         DBMS_CLOUD.FORMAT_TYPE)));
    CASE

      -- Datapump Driver
      WHEN l_type = DBMS_CLOUD.FORMAT_TYPE_DATAPUMP THEN

        l_external_type := EXTTAB_TYPE_DATAPUMP;

        -- ACCESS PARAMETERS and REJECT LIMIT clause
        get_datapump_access_parameters(
              format_obj          => l_format_obj,
              credential_name     => l_credential_name,
              dflt_diag_file      => log_file_prefix,
              export_query        => export_query,
              access_parameters   => l_access_parameters,
              reject_limit_clause => l_reject_limit_clause,
              schema_strategy     => l_schema_strategy
        );

      ELSE

        -- Bigdata Driver
        IF use_bigdata_driver(
              format_obj    => l_format_obj,
              base_table    => l_base_table,
              file_uri_list => l_file_uri_list)
        THEN

          l_external_type := EXTTAB_TYPE_BIGDATA;

          -- ACCESS PARAMETERS and REJECT LIMIT clause
          get_bigdata_access_parameters(
                format_obj          => l_format_obj,
                credential_schema   => invoker_schema,
                credential_name     => credential_name,
                file_uri_list       => l_file_uri_list,
                field_list          => field_list,
                access_parameters   => l_access_parameters,
                reject_limit_clause => l_reject_limit_clause,
                schema_strategy     => l_schema_strategy,
                part_in_file_uri    => l_part_in_file_uri
          );

        -- Oracle Loader Driver
        ELSE

          l_external_type := EXTTAB_TYPE_LOADER;

          -- ACCESS PARAMETERS and REJECT LIMIT clause
          get_access_parameters(
                format_obj          => l_format_obj,
                credential_schema   => invoker_schema,
                credential_name     => l_credential_name,
                file_uri_list       => l_file_uri_list,
                field_list          => field_list,
                dflt_diag_file      => log_file_prefix,
                os_ext_table        => os_ext_table,
                access_parameters   => l_access_parameters,
                reject_limit_clause => l_reject_limit_clause,
                part_in_file_uri    => l_part_in_file_uri
          );

        END IF;

    END CASE;

    -- COLUMN_LIST clause
    IF export_query IS NULL THEN
      l_column_clause := get_column_clause(
                               credential_schema => NVL(base_cred_owner,
                                                        invoker_schema),
                               credential_name   => NVL(base_cred_name,
                                                        credential_name),
                               file_uri_list     => l_file_uri_list,
                               base_table        => l_base_table,
                               base_table_schema => l_base_table_schema,
                               column_list       => l_column_list,
                               schema_strategy   => l_schema_strategy,
                               exttab_type       => l_type
                         );
    END IF;

    -- Type - Hybrid or External
    IF hybrid_table = TRUE THEN
      l_exttype_clause := 'EXTERNAL PARTITION ATTRIBUTES ';
    ELSE
      l_exttype_clause := 'ORGANIZATION EXTERNAL ';
    END IF;

    -- External Table clause
    l_extclause :=
       l_exttype_clause || NEWLINE ||
       '( ' || NEWLINE ||
       '  TYPE ' || l_external_type || NEWLINE;

    -- Bug 32795716: Skip default directory clause if 'logdir=null' format
    -- option is given
    IF l_log_dir IS NOT NULL AND
       (NOT l_format_obj.has('logdir') OR
        (l_base_table IS NULL AND
         get_json_string(l_format_obj, 'logdir') IS NOT NULL))
    THEN
      l_extclause := l_extclause ||
                       '  DEFAULT DIRECTORY '  || l_log_dir || ' ' || NEWLINE;
    END IF;

    l_extclause := l_extclause ||
       '  ACCESS PARAMETERS '  || NEWLINE ||
       '  ( ' || NEWLINE ||
              l_access_parameters || NEWLINE ||
       '  ) ' || NEWLINE;

    IF l_file_uri_list IS NOT NULL AND
       NOT l_part_in_file_uri THEN
      l_extclause := l_extclause ||
                       '  LOCATION (' || l_file_uri_list || ') ' || NEWLINE;
    END IF;

    -- Reject Limit clause
    -- Bug 30382591: For hybrid partitioned table, reject limit clause comes
    -- inside external table clause. Otherwise, it is outside external table
    -- clause.
    IF l_reject_limit_clause IS NOT NULL AND
       NOT l_part_in_file_uri
    THEN
      IF hybrid_table = TRUE THEN
        l_extclause := l_extclause || l_reject_limit_clause || NEWLINE ||
                          ') ' || NEWLINE;
      ELSE
        l_extclause := l_extclause || ') ' || NEWLINE ||
                          l_reject_limit_clause || NEWLINE;
      END IF;
    ELSE
      l_extclause := l_extclause || ') ' || NEWLINE;
    END IF;


    -- Construct the Create external table statement
    --
    -- Bug 27462297: To avoid SQL Injection possibility, return the statement
    -- text instead of executing it as a common user owing DBMS_CLOUD_INTERNAL
    -- Two user supplied inputs column_list and field_list are being used as
    -- it is and can be dangerous, when concatenated directly as part of
    -- dynamic SQL. We could potentially write custom parser(s) to validate
    -- these fields, but for now leaving them as arbitrary SQL expressions.
    --
    l_sqlstmt := 'CREATE TABLE ' || l_table_name || NEWLINE ||
                 NULLIF(l_column_clause || NEWLINE, NEWLINE) ||
                 l_extclause;

    -- Check if partitioning clause is set
    IF l_partitioning_clause IS NOT NULL THEN
      l_sqlstmt := l_sqlstmt || l_partitioning_clause || NEWLINE;
    END IF;

    -- Add PARALLEL clause
    l_sqlstmt := l_sqlstmt || 'PARALLEL';

    -- Add Export data clause
    -- Bug 29817501: Ensure that Export clause is only specified for datapump
    -- Change error message to be more generic
    IF export_query IS NOT NULL THEN
       IF l_external_type != EXTTAB_TYPE_DATAPUMP THEN
         raise_application_error(-20000,
              'Unsupported data format type for export - ' || l_type);
       END IF;
       l_sqlstmt := l_sqlstmt || ' AS ' || export_query;
    END IF;

    -- Enable bypass for create external table dd clause
    bypass_value := set_bypass;

    -- Return the create external table statement
    RETURN l_sqlstmt;

  END get_create_exttab_text;


  -----------------------------------------------------------------------------
  -- drop_external_table - Drop External Table for file in Object Store
  -----------------------------------------------------------------------------
  PROCEDURE drop_external_table(
        invoker_schema   IN  VARCHAR2,
        table_name       IN  VARCHAR2,
        parent_operation IN  VARCHAR2 DEFAULT NULL
  )
  IS
    l_table_name  VARCHAR2(M_QUAL_IDEN);
    l_stmt        VARCHAR2(M_VCSIZ_4K);
  BEGIN

    -- Nothing to do if table name is not passed in
    IF table_name IS NULL THEN
      RETURN;
    END IF;

    l_table_name := DBMS_CLOUD_CORE.get_qualified_name(
                                object_name => table_name,
                                schema_name => invoker_schema,
                                type => DBMS_CLOUD_CORE.ASSERT_TYPE_TAB);

    --
    -- Log external table operation
    --
    log_exttab_op(operation        => OPER_DROP_EXT,
                  invoker_schema   => invoker_schema,
                  table_name       => l_table_name,
                  parent_operation => parent_operation);

    -- Drop the table
    l_stmt := 'DROP TABLE ' || l_table_name || ' PURGE';
    EXECUTE IMMEDIATE l_stmt;

  EXCEPTION WHEN OTHERS THEN
    NULL;
  END drop_external_table;


  -----------------------------------------------------------------------------
  -- delete_load_operation - Delete a data load operation
  -----------------------------------------------------------------------------
  PROCEDURE delete_load_operation(
        id                IN  NUMBER,
        username          IN  VARCHAR2,
        payload           IN  CLOB,
        retval            OUT NUMBER
  )
  IS
    l_payload              JSON_OBJECT_T;
  BEGIN
    -- Parse the payload
    l_payload  := JSON_OBJECT_T(payload);

    -- Bug 26146301: Delete the log files listed in the log file external table
    delete_external_table_log_files(
        invoker_schema   => username,
        logfile_dir      => l_payload.get_string('LogfileDir'),
        logfile_prefix   => l_payload.get_string('LogfilePrefix')
    );

    -- Drop the supporting external tables
    drop_external_table(
        invoker_schema   => username,
        table_name       => l_payload.get_string('TempExtTable')
    );
    drop_external_table(
        invoker_schema   => username,
        table_name       => l_payload.get_string('LogfileTable')
    );
    drop_external_table(
        invoker_schema   => username,
        table_name       => l_payload.get_string('BadfileTable')
    );

    -- Return Success
    retval := 0;

  END delete_load_operation;


  -----------------------------------------------------------------------------
  -- delete_put_operation - Delete a put object operation
  -----------------------------------------------------------------------------
  PROCEDURE delete_put_operation(
        id                IN  NUMBER,
        username          IN  VARCHAR2,
        payload           IN  CLOB,
        retval            OUT NUMBER
  )
  IS
    l_payload              JSON_OBJECT_T;
  BEGIN
    -- Parse the payload
    l_payload  := JSON_OBJECT_T(payload);

    -- Delete the object
    BEGIN
      delete_object(invoker_schema  => username,
                    credential_name => l_payload.get_string('CredentialName'),
                    object_uri      => l_payload.get_string('FileUriList')
      );
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE NOT IN (-20401, -20404) THEN
          RAISE;
        END IF;
    END;

    -- Return Success
    retval := 0;

  END delete_put_operation;


  -----------------------------------------------------------------------------
  -- get_object - Get the contents of an object in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION get_object(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        object_uri       IN  VARCHAR2,
        startOffset      IN  NUMBER   DEFAULT 0,
        endOffset        IN  NUMBER   DEFAULT 0,
        compression      IN  VARCHAR2 DEFAULT NULL
  ) RETURN BLOB
  IS
     l_data   BLOB;
  BEGIN

    -- Get the object contents into the temporary lob
    get_object_int(
         invoker_schema => invoker_schema,
         credential_name => credential_name,
         object_uri      => object_uri,
         object_contents => l_data,
         startOffset     => startOffset,
         endOffset       => endOffset,
         compression     => compression
    );

    -- Return the temporary lob
    RETURN l_data;

  END get_object;


  -----------------------------------------------------------------------------
  -- get_object - Get the contents of an object in Cloud Store to local file
  -----------------------------------------------------------------------------
  PROCEDURE get_object(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        object_uri       IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2 DEFAULT NULL,
        startOffset      IN  NUMBER   DEFAULT 0,
        endOffset        IN  NUMBER   DEFAULT 0,
        compression      IN  VARCHAR2 DEFAULT NULL
  )
  IS
    l_data        BLOB;
  BEGIN

    --
    -- Download the file from object store to local file
    --
    get_object_int(invoker_schema  => invoker_schema,
                   credential_name => credential_name,
                   object_uri      => object_uri,
                   directory_name  => directory_name,
                   file_name       => file_name,
                   object_contents => l_data,
                   startOffset     => startOffset,
                   endOffset       => endOffset,
                   compression     => compression,
                   blob_output     => FALSE
    );

  END get_object;


  -----------------------------------------------------------------------------
  -- get_object - Get the contents of an object in Cloud Store using Raw ptr
  -----------------------------------------------------------------------------
  FUNCTION get_object_tabfunc(
        arguments_ptr    IN  RAW,
        contents_ptr     IN  RAW
  ) RETURN DBMS_CLOUD_TYPES.get_object_ret_tab PIPELINED
  IS
    invoker_schema     DBMS_QUOTED_ID;
    credential_name    DBMS_QUOTED_ID;
    object_uri         VARCHAR2(M_VCSIZ_4K);
    startOffset        NUMBER;
    endOffset          NUMBER;

    l_credential_name  VARCHAR2(M_QUAL_IDEN);
    l_ctx              DBMS_CLOUD_REQUEST.request_context_t;
    l_bytes_read       PLS_INTEGER := 0;
    l_using_cached_rsp BOOLEAN;
    l_record           DBMS_CLOUD_TYPES.get_object_ret_t;
  BEGIN

    -- Initialize the record type
    l_record.status := 1;

    LOOP

      -- Initialize locals
      l_using_cached_rsp := FALSE;

      -- Get the function arguments from arguments pointer
      get_args_from_raw_ptr(arguments_ptr, invoker_schema, credential_name,
                            object_uri, startOffset, endOffset);

      IF endOffset <= startOffset OR startOffset < 0 THEN
        DBMS_CLOUD_CORE.assert(FALSE, 'get_object2', 'Invalid startOffset (' ||
                               startOffset || ') or endOffset (' ||
                               endOffset || ')');
      END IF;

      DECLARE
        l_rsp UTL_HTTP.resp;
      BEGIN

        --
        -- Get the response for the request, check for cached response
        --
        IF RESPONSE_CACHING_ENABLED = TRUE AND
           CACHED_RESPONSE_ENDOFFSET > 0 AND
           startOffset = CACHED_RESPONSE_ENDOFFSET+1 AND--start offset in range
           endOffset > 0 AND
           endOffset <= CACHED_RESPONSE_MAXOFFSET AND    -- end offset in range
           CACHED_RESPONSE_URI = object_uri                  -- URI is matching
        THEN
          -- Use cached response
          l_rsp := CACHED_RESPONSE_RSP;
          l_using_cached_rsp := TRUE;

        ELSE
          -- End any previous cached response
          -- RTI 20760747: End the cached response at the beginning itself
          IF CACHED_RESPONSE_ENDOFFSET > 0 THEN
            CACHED_RESPONSE_ENDOFFSET := 0;
            DBMS_CLOUD_REQUEST.end_request(CACHED_RESPONSE_RSP);
          END IF;


          -- Initialize Request
          l_ctx := DBMS_CLOUD_REQUEST.init_request(
                    invoker_schema  => DBMS_ASSERT.enquote_name(invoker_schema,
                                                                FALSE),
                    credential_name => credential_name,
                    base_uri        => object_uri,
                    method          => DBMS_CLOUD.METHOD_GET
                   );

          -- Enable persistent connections for better performance of external
          -- table read
          UTL_HTTP.set_persistent_conn_support(TRUE, 1);

          -- Send a new range GET request
          l_rsp := send_range_get_request(
                     context     => l_ctx,
                     startOffset => startOffset,
                     endOffset   => startOffset + MAX_RANGE_OFFSET
                   );

          -- Bug 29788482: get_object is only allowed on files, not buckets
          IF DBMS_CLOUD_REQUEST.get_uri_file_path(l_ctx) IS NULL THEN
            raise_application_error(DBMS_CLOUD.EXCP_INVALID_OBJ_URI,
                'Invalid object uri - ' || object_uri);
          END IF;

          -- Cache the response
          CACHED_RESPONSE_RSP       := l_rsp;
          CACHED_RESPONSE_URI       := object_uri;
          CACHED_RESPONSE_MAXOFFSET := startOffset + MAX_RANGE_OFFSET;

        END IF;

        --
        -- Fetch the data from the response body
        --
        UTL_HTTP.read_raw_ptr(l_rsp, contents_ptr, endOffset - startOffset + 1,
                              l_bytes_read);

        -- Bug 27476333: If bytes read is less than the requested amount or
        -- if response caching is not enabled then end the response.
        IF l_bytes_read < (endOffset - startOffset + 1) OR
           RESPONSE_CACHING_ENABLED = FALSE
        THEN
          CACHED_RESPONSE_ENDOFFSET := 0;
          DBMS_CLOUD_REQUEST.end_request(l_rsp);
        ELSE
          CACHED_RESPONSE_ENDOFFSET := startOffset + l_bytes_read - 1;
        END IF;

      EXCEPTION
        -- End of response body, ignore error
        WHEN UTL_HTTP.end_of_body THEN
          CACHED_RESPONSE_ENDOFFSET := 0;
          DBMS_CLOUD_REQUEST.end_request(l_rsp);

        -- Caller does not want more data
        WHEN NO_DATA_NEEDED THEN
          RAISE;

        WHEN DBMS_CLOUD.invalid_object_uri THEN
          RAISE;

        WHEN OTHERS THEN
          CACHED_RESPONSE_ENDOFFSET := 0;
          DBMS_CLOUD_REQUEST.end_request(l_rsp);
          -- Ignore errors when using cached HTTP response handle
          -- Caller can retry the request
          IF l_using_cached_rsp = FALSE THEN
            DBMS_CLOUD.resignal_user_error();
            RAISE;
          END IF;
      END;

      -- Send dummy row with value 1 indicating success
      PIPE ROW (l_record);

    END LOOP;

    RETURN;

  END get_object_tabfunc;


  -----------------------------------------------------------------------------
  -- put_object - Put the contents in an object in Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE put_object(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        object_uri       IN  VARCHAR2,
        contents         IN  BLOB,
        compression      IN  VARCHAR2 DEFAULT NULL
  )
  IS
  BEGIN

    -- Put the object contents to object store
    put_object_int(invoker_schema  => invoker_schema,
                   credential_name => credential_name,
                   object_uri      => object_uri,
                   contents        => contents,
                   compression     => compression
    );
  END put_object;


  -----------------------------------------------------------------------------
  -- put_object - Put the contents of local file to object in Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE put_object(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        object_uri       IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2,
        compression      IN  VARCHAR2 DEFAULT NULL
  )
  IS
    l_data        BLOB;
    l_bfile_loc   BFILE;
    l_file_name   VARCHAR2(M_FILE_LEN);
  BEGIN

    -- Bug 27447846: validate file name
    l_file_name := validate_file_name(file_name);

    IF compression IS NULL THEN
      -- Bug 29061158: Get the BFILE locator
      l_bfile_loc := BFILENAME(directory_name, file_name);
      -- Bug 30536171: Validate the bfile locator
      validate_bfile(l_bfile_loc, file_name);
    ELSE
      -- Read the contents of a local file
      l_data := read_file(invoker_schema, directory_name, file_name);
    END IF;

    -- Put the object contents to object store
    put_object_int(invoker_schema  => invoker_schema,
                   credential_name => credential_name,
                   object_uri      => object_uri,
                   contents        => l_data,
                   directory_name  => directory_name,
                   file_name       => file_name,
                   compression     => compression,
                   bfile_locator   => l_bfile_loc
    );

  END put_object;


  -----------------------------------------------------------------------------
  -- put_object_tabfunc - Put contents to Cloud Store using Raw ptr
  -----------------------------------------------------------------------------
  FUNCTION put_object_tabfunc(
        arguments_ptr    IN  RAW,
        contents_ptr     IN  RAW
  ) RETURN DBMS_CLOUD_TYPES.get_object_ret_tab PIPELINED
  IS
    l_contents_len    NUMBER;
    l_invoker_schema  DBMS_QUOTED_ID;
    l_credential_name DBMS_QUOTED_ID;
    l_base_uri        VARCHAR2(M_VCSIZ_4K);
    l_file_name       VARCHAR2(M_VCSIZ_4K);
    l_rec             DBMS_CLOUD_TYPES.get_object_ret_t;
  BEGIN

    -- Initialize the record type
    l_rec.status := 1;

    LOOP

      -- Get the arguments to put_object_int from arguments_ptr
      put_object_args_from_raw_ptr(arguments_ptr   => arguments_ptr,
                                   invoker_schema  => l_invoker_schema,
                                   credential_name => l_credential_name,
                                   base_uri        => l_base_uri,
                                   file_name       => l_file_name,
                                   contents_len    => l_contents_len);

      -- Bug 33127422: Escape reserved characters in file name
      l_file_name := REPLACE(UTL_URL.escape(l_file_name, TRUE), '%2F', '/');

      -- Call put_object_int with content_ptr as input
      put_object_int(invoker_schema  => l_invoker_schema,
                     credential_name => l_credential_name,
                     object_uri      => l_base_uri,
                     contents        => NULL,
                     file_name       => l_file_name,
                     contents_ptr    => contents_ptr,
                     contents_len    => l_contents_len);

      -- Send dummy row with value 1 indicating success
      PIPE ROW (l_rec);

    END LOOP;

    RETURN;

  END put_object_tabfunc;


  -----------------------------------------------------------------------------
  -- get_metadata - Get the metadata for an object in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION get_metadata(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        object_uri       IN  VARCHAR2,
        external         IN  BOOLEAN   DEFAULT FALSE
  ) RETURN CLOB
  IS
    l_ctx              DBMS_CLOUD_REQUEST.request_context_t;
    l_rsp              UTL_HTTP.resp;
    l_buffer           VARCHAR2(M_VCSIZ_4K);
    l_metadata         CLOB;
    l_json_rsp_obj     JSON_OBJECT_T;
  BEGIN

    -- Generate metadata as JSON
    l_json_rsp_obj := JSON_OBJECT_T.parse('{}');

    -- Initialize Request
    l_ctx := DBMS_CLOUD_REQUEST.init_request(
               invoker_schema  => invoker_schema,
               credential_name => credential_name,
               base_uri        => object_uri,
               method          => DBMS_CLOUD.METHOD_HEAD
             );

    BEGIN
      -- Send the request
      l_rsp := DBMS_CLOUD_REQUEST.send_request(context => l_ctx);

      -- Get the Content Length
      -- Bug 28376672: Content-Length is not returned for buckets, so
      -- ignore the exception and treat as 0 length.
      get_http_header(l_rsp, HEADER_CONTENT_LENGTH, l_buffer);

    EXCEPTION
      WHEN DBMS_CLOUD.MISSING_CREDENTIAL THEN
        -- Bug 30291020: If encountered HTTP 403 Forbidden for Amazon S3 and it
        -- an internal request from RDBMS code, then it is possible that the
        -- URI is a Preauth GET request URI. In order
        -- to support external table with S3 Preauth GET URI, we do a dummy GET
        -- request of 1 byte range to check if the file is valid.
        IF NOT external AND
           credential_name IS NULL AND
           DBMS_CLOUD_REQUEST.get_cloud_store_type(l_ctx) =
                DBMS_CLOUD_REQUEST.CSTYPE_AMAZON_S3
        THEN
          -- End the previous HEAD request
          DBMS_CLOUD_REQUEST.end_request(l_rsp);

          -- Send a dummy range GET request of 1 byte
          l_ctx(DBMS_CLOUD_REQUEST.REQUEST_CTX_METHOD) :=
                                                        DBMS_CLOUD.METHOD_GET;
          BEGIN
            l_rsp := send_range_get_request(
                       context     => l_ctx,
                       startOffset => 0,
                       endOffset   => 1
                     );
            l_buffer := '1';

          EXCEPTION
            WHEN UTL_HTTP.end_of_body THEN
              -- If it is an empty file, then startOffset=1 will raise end of
              -- body exception, but file still exists so we can return size=0.
              l_buffer := '0';
            WHEN OTHERS THEN
              l_ctx(DBMS_CLOUD_REQUEST.REQUEST_CTX_METHOD) :=
                                                        DBMS_CLOUD.METHOD_HEAD;
              RAISE;
          END;

          -- Restore the request method
          l_ctx(DBMS_CLOUD_REQUEST.REQUEST_CTX_METHOD) :=
                                                        DBMS_CLOUD.METHOD_HEAD;
        ELSE
          RAISE;
        END IF;
    END;

    -- End the response
    DBMS_CLOUD_REQUEST.end_request(l_rsp);

    -- Return the metadata as JSON
    l_json_rsp_obj.put(HEADER_CONTENT_LENGTH, TO_NUMBER(NVL(l_buffer, '0')));
    RETURN l_json_rsp_obj.to_clob();

  EXCEPTION
    WHEN OTHERS THEN
      -- End the response to avoid leaking HTTP connection
      DBMS_CLOUD_REQUEST.end_request(l_rsp);
      DBMS_CLOUD.resignal_user_error();
      RAISE;
  END get_metadata;


  -----------------------------------------------------------------------------
  -- list_objects - List objects at a given location in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION list_objects(
        invoker_schema   IN      VARCHAR2,
        credential_name  IN      VARCHAR2,
        location_uri     IN      VARCHAR2,
        resume_obj       IN      VARCHAR2,
        filter_path      OUT     VARCHAR2,
        list_fields      OUT     DBMS_CLOUD_TYPES.list_object_fields_t,
        nextmarker       IN OUT  VARCHAR2
  ) RETURN CLOB
  IS
    l_ctx              DBMS_CLOUD_REQUEST.request_context_t;
    l_query_params     JSON_OBJECT_T;
    l_rsp              UTL_HTTP.resp;
    l_buffer_raw       RAW(M_VCSIZ_4K);
    l_data             CLOB;
    l_data_temp        CLOB;
    l_element          JSON_ELEMENT_T;
    l_object           JSON_OBJECT_T;
    l_path             VARCHAR2(M_VCSIZ_4K) := NULL;
    l_cloud_store_type PLS_INTEGER;
    l_request_uri      VARCHAR2(M_VCSIZ_4K);
    l_host_name        VARCHAR2(M_VCSIZ_4K);
    l_store_type       DBMS_ID;
    l_end_of_scan      BOOLEAN := FALSE;
    l_use_bucket_uri   BOOLEAN := TRUE;
    l_uri              VARCHAR2(MAX_URI_LEN);

  BEGIN
    -- Bug 33171493: S3 compatible URLs require to terminate URL with slash
    l_uri := location_uri;
    IF l_uri IS NOT NULL AND SUBSTR(l_uri, -1) != '/' THEN
      l_uri := l_uri || '/';
    END IF;

    -- Initialize Request
    l_ctx := DBMS_CLOUD_REQUEST.init_request(
               invoker_schema  => invoker_schema,
               credential_name => credential_name,
               base_uri        => l_uri,
               method          => DBMS_CLOUD.METHOD_GET
             );
    l_cloud_store_type := DBMS_CLOUD_REQUEST.get_cloud_store_type(l_ctx);

    -- Get the filter path for folders
    -- Terminate filter path with / if required.
    -- Bug 30780102: result of list objects does not have escape characters,
    -- so unescape filter path for comparison with the list result.
    IF filter_path IS NULL THEN
      filter_path   := UTL_URL.unescape(
                          DBMS_CLOUD_REQUEST.get_uri_file_path(l_ctx));
      IF SUBSTR(filter_path, -1) != '/' THEN
        filter_path := filter_path || '/';
      END IF;
    END IF;

    -- If the storage type does not support something like marker to resume
    -- GETting at a certain point, return as if there were no more data
    -- Bug 31463476: add support for Google Cloud.
    -- Bug 31461405: add support for OCI S3 compatible URLs.
    -- Bug 31647905: If nextmarker is not NULL, list_objects is not complete
    -- for Azure. We cannot return an empty object list.
    IF resume_obj IS NOT NULL AND
       l_cloud_store_type NOT IN (DBMS_CLOUD_REQUEST.CSTYPE_ORACLE_BMC_SWIFT,
                                  DBMS_CLOUD_REQUEST.CSTYPE_AMAZON_S3,
                                  DBMS_CLOUD_REQUEST.CSTYPE_GOOGLE_CLOUD,
                                  DBMS_CLOUD_REQUEST.CSTYPE_OCI_S3_COMPAT) AND
       nextmarker IS NULL
    THEN
      RETURN '{"object_list": [] }';
    END IF;

    l_query_params := JSON_OBJECT_T('{}');

    -- Bug 26938912: For Oracle OSS, request for response in JSON format
    IF l_cloud_store_type = DBMS_CLOUD_REQUEST.CSTYPE_ORACLE_OSS THEN
      l_path := QS_JSON_RESPONSE;
    -- Bug 27716801: For Azure Blob Storage, add parameters to get the
    -- list of blobs from the container
    -- Bug 31647905: Add marker and prefix for Azure. Arrange query parameters
    -- in the lexical order.
    ELSIF l_cloud_store_type = DBMS_CLOUD_REQUEST.CSTYPE_MS_AZURE_BLOB THEN
      l_query_params.put(DBMS_CLOUD_REQUEST.QSPARAM_COMP, 'list');
      l_path                                             := QS_MS_AZURE_LIST;
      IF resume_obj IS NOT NULL THEN
        l_query_params.put(QS_MARKER, nextmarker);
        l_path := l_path || '&' || QS_MARKER || '=' || nextmarker;
      END IF;
      IF filter_path IS NOT NULL THEN
        l_query_params.put(QS_PREFIX, filter_path);
        -- Bug 32983836: Escape reserved characters in filter path
        l_path := l_path || '&' || QS_PREFIX || '=' ||
                  UTL_URL.escape(filter_path, TRUE);
      END IF;
      l_query_params.put(DBMS_CLOUD_REQUEST.QSPARAM_RESTYPE, 'container');
    -- Bug 29353148: For Oracle BMC object storage, add query parameters to get
    -- the list of objects(name, size)
    ELSIF l_cloud_store_type = DBMS_CLOUD_REQUEST.CSTYPE_ORACLE_BMC THEN
      l_path := QS_ORCL_BMC_LIST;
      -- Bug 33518936: escape the reserved characters in the filename passed as
      -- the start query param to OCI list objects API
      IF nextmarker IS NOT NULL THEN
        l_path := l_path || '&' || QS_ORCL_BMC_NEXT_START || '=' ||
                  UTL_URL.escape(nextmarker, TRUE);
      END IF;
    -- Bug 27752606/28448036: support for marker
    -- Bug 29703106: support for prefix
    --   BMC SWIFT and AMAZON S3 have a concept of prefix, limit and marker -
    --   prefix: a prefix string to match object names returned
    --   limit: allows one to limit the number of objects returned
    --   marker: allows one to resume reading at a point after a given
    --           object
    -- Bug 30887751: Escape reserved characters in filter path.
    -- Bug 31463476: add support for Google Cloud.
    -- Bug 31461405: add support for OCI S3 compatible URLs.
    ELSIF l_cloud_store_type IN (DBMS_CLOUD_REQUEST.CSTYPE_ORACLE_BMC_SWIFT,
                                 DBMS_CLOUD_REQUEST.CSTYPE_AMAZON_S3,
                                 DBMS_CLOUD_REQUEST.CSTYPE_GOOGLE_CLOUD,
                                 DBMS_CLOUD_REQUEST.CSTYPE_OCI_S3_COMPAT)
    THEN
      -- Marker
      IF resume_obj IS NOT NULL THEN
        l_path := QS_MARKER || '=' || UTL_URL.escape(resume_obj, TRUE);
      END IF;
      -- Prefix
      IF filter_path IS NOT NULL THEN
        l_path := NULLIF(l_path || '&', '&') ||
                  QS_PREFIX || '=' || UTL_URL.escape(filter_path, TRUE);
      END IF;
    END IF;

    -- Add the query string delimiter (?) if we have any path
    -- Bug 31461405: If there is no credential and the original uri already has
    -- the query string delimiter (?), the query string delimiter (&) will be
    -- appended.
    -- Bug 31829284: Remove checking the username.
    IF l_path IS NOT NULL THEN
      IF INSTR(location_uri, '?') > 0 THEN
        l_path := '&' || l_path;
        l_use_bucket_uri := FALSE;
      ELSE
        l_path := '?' || l_path;
      END IF;
    END IF;


    --
    -- Send the request
    --   For S3 and BMC, if we had set l_path to use a "marker", and there is
    --   nothing after that marker, we will get an ORA-20404.
    --
    BEGIN
      l_rsp := DBMS_CLOUD_REQUEST.send_request(
                   context        => l_ctx,
                   path           => l_path,
                   params         => l_query_params,
                   use_bucket_uri => l_use_bucket_uri
               );
    EXCEPTION
      WHEN uri_object_not_found THEN
        IF resume_obj IS NOT NULL THEN
          l_end_of_scan := TRUE;              -- nothing after the "resume_obj"
        ELSE
          RAISE;
        END IF;
    END;

    IF l_end_of_scan THEN
      l_data := NULL;                         -- end of scan means no more data
    ELSE
      BEGIN
        -- Bug 32011784: The 'Content-Type' response header from remote
        -- webserver, says the media type is 'application' and not text
        -- based. Hence, read the incoming on-the-wire data in binary form
        -- since the media-type clearly says that is NOT a text. After
        -- that, transform the raw that we read to a varchar, in the
        -- backdrop of the current db charset. Or else, the underlying
        -- utl_http tries to perform a charset conversion from  on-the-wire
        -- charset to database charset and we loose the correct representation
        -- of the incoming data, during read_text.
        --
        -- Loop to get the entire response of the object list
        LOOP
          UTL_HTTP.read_raw(l_rsp, l_buffer_raw, M_VCSIZ_4K);
          l_data := l_data || utl_raw.cast_to_varchar2(l_buffer_raw);
        END LOOP;

        DBMS_CLOUD_REQUEST.end_request(l_rsp);

      EXCEPTION
        WHEN UTL_HTTP.end_of_body THEN
          DBMS_CLOUD_REQUEST.end_request(l_rsp);
      END;
    END IF;

    -- Initialize field names and format
    list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_NAME)    :=
                                            DBMS_CLOUD.LIST_OBJ_FIELD_NAME;
    list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_BYTES)   :=
                                            DBMS_CLOUD.LIST_OBJ_FIELD_BYTES;
    list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_CHECKSUM) :=
                                            DBMS_CLOUD.LIST_OBJ_FIELD_CHECKSUM;
    list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_CREATED) :=
                                            DBMS_CLOUD.LIST_OBJ_FIELD_CREATED;
    list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_CREATED_FMT) :=
                                             'YYYY-MM-DD"T"HH24:MI:SS.FFTZR';
    list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_LASTMOD) :=
                                            DBMS_CLOUD.LIST_OBJ_FIELD_LASTMOD;
    list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_LASTMOD_FMT) :=
                                             'YYYY-MM-DD"T"HH24:MI:SS.FFTZR';

    --
    -- Bug 26856154: Convert response to JSON format as follows:
    -- Bug 28538910: Add last modified field
    --    {
    --     "name" : type string,
    --     "bytes": type number,
    --     "last_modified": type string
    --    }
    --
    CASE
      -- Oracle BMC Swift: convert to JSON Array
      WHEN l_cloud_store_type = DBMS_CLOUD_REQUEST.CSTYPE_ORACLE_BMC_SWIFT THEN
        -- if we get NOTHING in l_data, the JSON_ARRAY_T() will get us an
        -- ORA-30625!
        IF l_data IS NOT NULL THEN
          l_data := JSON_ARRAY_T(l_data).to_clob();
        END IF;
        list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_CHECKSUM) := 'hash';

      -- Amazon S3: convert XML to JSON
      -- RTI 23295153: updates XMLNAMESPACE for OCI S3 compatible URLs.
      WHEN l_cloud_store_type IN (DBMS_CLOUD_REQUEST.CSTYPE_AMAZON_S3,
                                  DBMS_CLOUD_REQUEST.CSTYPE_OCI_S3_COMPAT) THEN
        IF NOT l_end_of_scan THEN     -- we have data if not end_of scan
           -- Bug 27139629: JSON_ARRAYAGG does not support more than 4000 char.
           -- So instead of combining the json objects using JSON_ARRAYAGG, we
           -- manually concatenate all the objects using a CLOB.
           SELECT JSON_ARRAYAGG(
                    JSON_OBJECT('name'      VALUE name,
                                'bytes'     VALUE bytes,
                                'checksum'  VALUE TRIM(BOTH '"' FROM checksum),
                                'last_modified' VALUE last_modified)
                    RETURNING CLOB) INTO l_data
             FROM XMLTABLE(
              XMLNAMESPACES(DEFAULT 'http://s3.amazonaws.com/doc/2006-03-01/'),
              '/ListBucketResult/Contents'
              PASSING XMLTYPE(l_data)
              COLUMNS name          VARCHAR2(4000) PATH 'Key/text()',
                      bytes         NUMBER         PATH 'Size/text()',
                      checksum      VARCHAR2(128)  PATH 'ETag/text()',
                      last_modified VARCHAR2(128)  PATH 'LastModified/text()');
        END IF;

      -- Oracle OSS: response is already in JSON format
      WHEN l_cloud_store_type = DBMS_CLOUD_REQUEST.CSTYPE_ORACLE_OSS THEN
        list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_CHECKSUM) := 'hash';

      -- Oracle BMC: convert to JSON Array
      -- Bug 29353148: The reponse is of the below format
      -- { "objects" : [ { "name" : "1MB.data" } ] }
      -- So we have to get the value of "objects" and then use it as l_data
      WHEN l_cloud_store_type = DBMS_CLOUD_REQUEST.CSTYPE_ORACLE_BMC THEN
        l_element := JSON_ELEMENT_T.parse(l_data);
        l_object  := treat(l_element AS JSON_OBJECT_T);
        l_data    := l_object.get_array('objects').to_clob();

        list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_BYTES)    := 'size';
        list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_CHECKSUM) := 'md5';
        list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_CREATED)  := 'timeCreated';
        list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_LASTMOD)  := 'timeModified';

        -- Bug 32484796: In case of OCI object storage, it returns
        -- 1000 objects, by default. To be able to scroll through
        -- the next set of objects, it sends a marker 'nextStartWith'.
        -- We should capture the value of this marker here and provide
        -- it as the value of 'start' paramter, on the subsequent request.
        nextmarker := l_object.get_String('nextStartWith');

      -- Microsoft Azure: convert XML to JSON
      WHEN l_cloud_store_type = DBMS_CLOUD_REQUEST.CSTYPE_MS_AZURE_BLOB THEN
        -- The first 3 characters of list blobs XML output has "i>?".
        -- We need to ignore these characters and then parse the XML
        -- to extract the name and the bytes
        list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_CREATED_FMT) :=
                                             'Dy, DD MON YYYY HH24:MI:SS TZR';
        list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_LASTMOD_FMT) :=
                                             'Dy, DD MON YYYY HH24:MI:SS TZR';
        -- Bug 31647905: Get NextMarker element from response when list_objects
        -- is not complete.
        nextmarker := SUBSTR(l_data, INSTR(l_data, '<NextMarker>') + 12,
                             INSTR(l_data, '</NextMarker>') -
                             INSTR(l_data, '<NextMarker>') - 12);

        SELECT JSON_ARRAYAGG(
                 JSON_OBJECT('name'          VALUE name,
                             'bytes'         VALUE bytes,
                             'checksum'      VALUE checksum,
                             'created'       VALUE created,
                             'last_modified' VALUE last_modified)
                 RETURNING CLOB) INTO l_data
          FROM XMLTABLE(
              '/EnumerationResults/Blobs/Blob'
              PASSING XMLTYPE(l_data)
              COLUMNS name     VARCHAR2(4000) PATH 'Name/text()',
                      bytes    NUMBER         PATH 'Properties/Content-Length',
                      checksum VARCHAR2(128)  PATH 'Properties/Content-MD5',
                      created  VARCHAR2(128)  PATH 'Properties/Creation-Time',
                 last_modified VARCHAR2(128)  PATH 'Properties/Last-Modified');

      -- Google Cloud Storage: convert XML to JSON.
      WHEN l_cloud_store_type = DBMS_CLOUD_REQUEST.CSTYPE_GOOGLE_CLOUD THEN
        IF NOT l_end_of_scan THEN  -- we have data if not end_of scan
          SELECT JSON_ARRAYAGG(
                   JSON_OBJECT('name'      VALUE name,
                               'bytes'     VALUE bytes,
                               'checksum'  VALUE TRIM(BOTH '"' FROM checksum),
                               'last_modified' VALUE last_modified)
                   RETURNING CLOB) INTO l_data
            FROM XMLTABLE(
             -- Bug 31463476: support xml namespace from Google Cloud.
             XMLNAMESPACES(DEFAULT 'http://doc.s3.amazonaws.com/2006-03-01'),
             '/ListBucketResult/Contents'
             PASSING XMLTYPE(l_data)
             COLUMNS name          VARCHAR2(4000) PATH 'Key/text()',
                     bytes         NUMBER         PATH 'Size/text()',
                     checksum      VARCHAR2(128)  PATH 'ETag/text()',
                     last_modified VARCHAR2(128)  PATH 'LastModified/text()');
        END IF;

      ELSE
        raise_application_error(-20000,
           'Invalid cloud store type ' ||
           DBMS_CLOUD_REQUEST.get_cloud_store_type(l_ctx));
    END CASE;

    -- Handle empty bucket
    IF l_data IS NULL THEN
      l_data := '[]';
    END IF;

    --
    -- Return the JSON document as CLOB
    --
    RETURN '{"object_list":' || l_data || '}';

  EXCEPTION
    WHEN OTHERS THEN
      -- End the response to avoid leaking HTTP connection
      DBMS_CLOUD_REQUEST.end_request(l_rsp);
      RAISE;
  END list_objects;


  -----------------------------------------------------------------------------
  -- list_objects - List objects at a given location in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION list_objects(
        invoker_schema   IN      VARCHAR2,
        credential_name  IN      VARCHAR2,
        location_uri     IN      VARCHAR2,
        resume_obj       IN      VARCHAR2,
        filter_path      OUT     VARCHAR2,
        list_fields      OUT     DBMS_CLOUD_TYPES.list_object_fields_t
  ) RETURN CLOB
  IS
    l_nextmarker       VARCHAR2(M_VCSIZ_4K) := NULL;
  BEGIN
    RETURN list_objects(invoker_schema, credential_name, location_uri,
                        resume_obj, filter_path, list_fields, l_nextmarker);
  END list_objects;


  -----------------------------------------------------------------------------
  -- list_files - List files at a given directory object location
  -----------------------------------------------------------------------------
  FUNCTION list_files(
        invoker_schema   IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name_filter IN  VARCHAR2
  ) RETURN CLOB
  IS
    l_data           CLOB;
    l_sqlstmt        VARCHAR2(M_VCSIZ_4K);
    l_directory_name DBMS_ID;
    l_directory_path VARCHAR2(M_VCSIZ_4K);
    l_path_prefix    VARCHAR2(M_VCSIZ_4K);
    l_root_object    RAW(16);
    l_epoch_time     CONSTANT DBMS_ID := '1970-01-01T00:00:00.0 UTC +00:00';
    l_epoch_time_fmt CONSTANT DBMS_ID := 'YYYY-MM-DD"T"HH24:MI:SS.FF TZD TZR';
    l_stmt_cursor    INTEGER;
    l_rows_processed INTEGER;
  BEGIN

    -- Validate input
    l_directory_name := DBMS_CLOUD_CORE.assert_simple_sql_name(
                            directory_name, DBMS_CLOUD_CORE.ASSERT_TYPE_DIR);

    -- Get the PATH_PREFIX path, if set
    -- Bug 30545823: Get the DBFS store name.
    DBMS_CLOUD_CORE.get_db_property(PROPERTY_PATH_PREFIX, l_path_prefix);

    -- Get the relative directory path by removing path_prefix
    BEGIN
      SELECT SUBSTR(directory_path, LENGTH(l_path_prefix)+1)
                INTO l_directory_path
        FROM dba_directories
        WHERE directory_name = l_directory_name;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         raise_application_error(-20000,
                'Directory object ' || directory_name || ' does not exist');
    END;

    -- Bug 30545823: If directory path is NULL, also append '/'.
    IF l_directory_path IS NULL OR SUBSTR(l_directory_path, -1) != '/' THEN
      l_directory_path := l_directory_path || '/';
    END IF;

    -- Bug 30545823: Get the type of the first mounted file system.
    -- Bug 32082996: Cache the store type to optimize performance.
    IF FS_STORE_TYPE IS NULL THEN
      BEGIN
        EXECUTE IMMEDIATE 'SELECT OFS_FSTYPE FROM v$ofsmount ' ||
                           'fetch first 1 row only' INTO FS_STORE_TYPE;
      EXCEPTION
        WHEN OTHERS THEN
          raise_application_error(-20000, 'No Oracle File System mounted');
      END;
    END IF;

    -- Bug 28538910: Include created and last_modified timestamp for files
    l_sqlstmt :=
      'SELECT JSON_ARRAYAGG(rec RETURNING CLOB) FROM
        (SELECT JSON_OBJECT(
                      ''name''  VALUE
                                SUBSTR(object_path, LENGTH(:directory_path)+1),
                      ''bytes'' VALUE object_size,
                      ''created'' VALUE TO_CHAR(TO_TIMESTAMP_TZ(''' ||
                               l_epoch_time || ''',''' || l_epoch_time_fmt ||
                               ''') + NUMTODSINTERVAL(ctime, ''SECOND'')),
                      ''last_modified'' VALUE TO_CHAR(TO_TIMESTAMP_TZ(''' ||
                               l_epoch_time || ''',''' || l_epoch_time_fmt ||
                               ''') + NUMTODSINTERVAL(mtime, ''SECOND''))
           ) rec
         FROM ';

    CASE LOWER(FS_STORE_TYPE)
      WHEN 'ofs' THEN
        -- Get the root object id for the file system
        -- Bug 30545823: Only OFS needs this root object id.
        BEGIN
          EXECUTE IMMEDIATE 'SELECT object_irid FROM sys.ofs$obj_data
                             WHERE object_name = ''/''' INTO l_root_object;
        EXCEPTION
          WHEN OTHERS THEN
            raise_application_error(-20000,
                'Oracle File System root directory not found');
        END;

        BEGIN
          -- Fetch the list of files
          -- Bug 30069879: Support nested directories using CONNECT BY
          -- Bug 30148053: Ignore hidden OFS files starting with .ofs_%
          l_sqlstmt := l_sqlstmt ||
                 '(SELECT object_size,
                          SYS_CONNECT_BY_PATH(object_name, ''/'') object_path,
                          ctime, mtime
                   FROM sys.ofs$obj_data
                   WHERE fs_object_type = 1 and object_name NOT LIKE ''.ofs_%''
                   START WITH parent_obj_irid = :root_object
                   CONNECT BY PRIOR object_irid = parent_obj_irid)
                WHERE object_path LIKE :directory_path || ''%'')';

          l_stmt_cursor := dbms_sql.open_cursor;
          sys.dbms_sys_sql.parse_as_user(l_stmt_cursor, l_sqlstmt,
                                         DBMS_SQL.NATIVE, KSYS);
          dbms_sql.define_column(l_stmt_cursor, 1, l_data);
          dbms_sql.bind_variable(l_stmt_cursor, ':root_object', l_root_object);
          dbms_sql.bind_variable(l_stmt_cursor, ':directory_path',
                                 l_directory_path);
          l_rows_processed := dbms_sql.execute(l_stmt_cursor);
          l_rows_processed := dbms_sql.fetch_rows(l_stmt_cursor);
          dbms_sql.column_value(l_stmt_cursor, 1, l_data);
          dbms_sql.close_cursor(l_stmt_cursor);
        EXCEPTION
          WHEN OTHERS THEN
            dbms_sql.close_cursor(l_stmt_cursor);
            raise_application_error(-20000,
                'Unable to access directory objects - ' || l_directory_name ||
                ' - ' || SQLERRM);
       END;

      WHEN 'dbfs' THEN
        -- Get the store name.
        IF FS_STORE_NAME IS NULL THEN
          BEGIN
            EXECUTE IMMEDIATE 'SELECT param_value FROM dbms_cloud_config_param
                               WHERE param_name = ''dbfs_store_name'''
                               INTO FS_STORE_NAME;
          EXCEPTION
            WHEN OTHERS THEN
              raise_application_error(-20000, 'Oracle Store Name not found');
          END;
        END IF;

        -- Bug 3054823: Look up the DBFS table name. Get the first one if
        -- multiple DBFS mounts or tablespaces exist.
        -- Bug 32082996: Cache the DBFS table name to optimize performance.
        IF DBFS_TBL_NAME IS NULL THEN
          BEGIN
            l_stmt_cursor := dbms_sql.open_cursor;
            sys.dbms_sys_sql.parse_as_user(l_stmt_cursor,
                                           'SELECT table_name
                                            FROM SYS.DBFS_SFS$_TAB tab,
                                                 SYS.DBFS_SFS$_FS fs
                                            WHERE
                                            fs.store_name = :store_name AND
                                            fs.tabid = tab.tabid',
                                           DBMS_SQL.NATIVE, KSYS);
            dbms_sql.define_column(l_stmt_cursor, 1, DBFS_TBL_NAME, 128);
            dbms_sql.bind_variable(l_stmt_cursor, ':store_name',
                                   FS_STORE_NAME);
            l_rows_processed := dbms_sql.execute(l_stmt_cursor);
            l_rows_processed := dbms_sql.fetch_rows(l_stmt_cursor);
            dbms_sql.column_value(l_stmt_cursor, 1, DBFS_TBL_NAME);
            dbms_sql.close_cursor(l_stmt_cursor);
          EXCEPTION
            WHEN OTHERS THEN
              dbms_sql.close_cursor(l_stmt_cursor);
              raise_application_error(-20000,
                  'Unable to identify Oracle File System Metadata');
          END;
        END IF;

        BEGIN
          -- Fetch the list of files
          -- Bug 30545823: support dbfs.
          -- DBFS_TBL_NAME should be validated for sql injection.
          l_sqlstmt :=  l_sqlstmt ||
                 '(SELECT dbms_lob.getlength(filedata) object_size,
                          pathname object_path,
                          dbms_dbfs_sfs.to_epoch(STD_CREATION_TIME) CTIME,
                          dbms_dbfs_sfs.to_epoch(STD_MODIFICATION_TIME) MTIME
                   FROM "SYS".' ||
                   DBMS_ASSERT.enquote_name(DBFS_TBL_NAME, FALSE) || '
                   WHERE pathtype = 1 and
                         pathname NOT LIKE ''/.sfs%'' and
                         pathname LIKE :directory_path || ''%''))';

          l_stmt_cursor := dbms_sql.open_cursor;
          sys.dbms_sys_sql.parse_as_user(l_stmt_cursor, l_sqlstmt,
                                         DBMS_SQL.NATIVE, KSYS);
          dbms_sql.define_column(l_stmt_cursor, 1, l_data);
          dbms_sql.bind_variable(l_stmt_cursor, ':directory_path',
                                 l_directory_path);
          l_rows_processed := dbms_sql.execute(l_stmt_cursor);
          l_rows_processed := dbms_sql.fetch_rows(l_stmt_cursor);
          dbms_sql.column_value(l_stmt_cursor, 1, l_data);
          dbms_sql.close_cursor(l_stmt_cursor);
        EXCEPTION
          WHEN OTHERS THEN
            dbms_sql.close_cursor(l_stmt_cursor);
            raise_application_error(-20000,
                'Unable to access directory object - ' || l_directory_name ||
                ' - ' || SQLERRM);
        END;

      ELSE
        raise_application_error(-20000,
            'Oracle File System mounted is not supported');

    END CASE;

    -- Handle null value to avoid returning bad json string
    IF l_data IS NULL OR LENGTH(l_data) = 0 THEN
      l_data := '[]';
    END IF;

    RETURN '{"object_list":' || l_data || '}';

  END list_files;


  -----------------------------------------------------------------------------
  -- list_objects - List objects at a given location in Cloud Store
  -----------------------------------------------------------------------------
  FUNCTION list_objects_tabfunc(
        invoker_schema   IN  VARCHAR2,
        credential_name  IN  VARCHAR2,
        location_uri     IN  VARCHAR2
  ) RETURN DBMS_CLOUD_TYPES.list_object_ret_tab PIPELINED
  IS
    l_data             CLOB;
    l_object           JSON_OBJECT_T;
    l_object_list      JSON_ARRAY_T;
    l_record           DBMS_CLOUD_TYPES.list_object_ret_t;
    l_list_fields      DBMS_CLOUD_TYPES.list_object_fields_t;
    l_filter_path      VARCHAR2(M_VCSIZ_4K);
    l_filter_path_len  PLS_INTEGER;
    l_resume_obj       VARCHAR2(256) := NULL;
    l_nextmarker       VARCHAR2(M_VCSIZ_4K) := NULL;
  BEGIN

    LOOP
      -- keep  calling list_objects until there are no objects returned

      -- Get the list of objects as a JSON CLOB
      -- Bug 26939185: enquote invoker name without changing case
      l_data := list_objects(DBMS_ASSERT.enquote_name(invoker_schema, FALSE),
                             credential_name, location_uri, l_resume_obj,
                             l_filter_path, l_list_fields, l_nextmarker);
      l_filter_path_len := NVL(LENGTH(l_filter_path)+1, 1);

      -- Generate metadata as JSON
      l_object_list := JSON_OBJECT_T(l_data).get_Array('object_list');

      EXIT WHEN l_object_list.get_size = 0;

      FOR i in 0 .. l_object_list.get_size - 1  LOOP
        l_object             := JSON_OBJECT_T(l_object_list.get(i));
        l_record.bytes       :=
           l_object.get_Number(l_list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_BYTES));
        l_record.object_name :=
            l_object.get_String(l_list_fields(DBMS_CLOUD.LIST_OBJ_FIELD_NAME));

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

        -- Bug 31104577: Escape special characters in object name for Amazon S3
        l_record.object_name :=
             REPLACE(UTL_URL.escape(l_record.object_name, TRUE), '%2F', '/');

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
      DBMS_CLOUD.resignal_user_error();
      RAISE;
  END list_objects_tabfunc;


  -----------------------------------------------------------------------------
  -- delete_object - Delete an object in Cloud Store
  -----------------------------------------------------------------------------
  PROCEDURE delete_object(
        invoker_schema     IN  VARCHAR2,
        credential_name    IN  VARCHAR2,
        object_uri         IN  VARCHAR2
  )
  IS
    l_ctx              DBMS_CLOUD_REQUEST.request_context_t;
    l_cloud_store_type PLS_INTEGER;
  BEGIN

    -- Initialize Request
    l_ctx := DBMS_CLOUD_REQUEST.init_request(
               invoker_schema  => invoker_schema,
               credential_name => credential_name,
               base_uri        => object_uri,
               method          => DBMS_CLOUD.METHOD_DELETE
             );

    -- Bug 31166211: Handle Dynamic Large Object (DLO) deletion for OCI
    l_cloud_store_type := DBMS_CLOUD_REQUEST.get_cloud_store_type(l_ctx);
    IF l_cloud_store_type = DBMS_CLOUD_REQUEST.CSTYPE_ORACLE_BMC_SWIFT OR
       (l_cloud_store_type = DBMS_CLOUD_REQUEST.CSTYPE_ORACLE_BMC AND
        l_ctx(DBMS_CLOUD_REQUEST.REQUEST_CTX_ISPAR) = 'FALSE')
    THEN
      -- Delete chunks of a dynamic large object before deleting the object
      delete_object_chunks(
           context         => l_ctx,
           invoker_schema  => invoker_schema,
           credential_name => credential_name,
           object_uri      => object_uri
      );
    END IF;

    -- Delete the object
    delete_object_int(
        context         => l_ctx,
        invoker_schema  => invoker_schema,
        credential_name => credential_name,
        object_uri      => object_uri
    );

  END delete_object;


  -----------------------------------------------------------------------------
  -- write_file  - Write contents to a local file
  -----------------------------------------------------------------------------
  PROCEDURE write_file(
        invoker_schema   IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2,
        contents         IN  BLOB
  )
  IS
    l_file      UTL_FILE.file_type;
    l_data_len  INTEGER;
    l_buffer    RAW(M_VCSIZ_32K);
    l_pos       INTEGER := 1;
    l_amount    INTEGER := M_VCSIZ_32K;
  BEGIN
    -- Get the data length to write
    l_data_len := DBMS_LOB.getlength(contents);

    -- Write the contents to local file
    l_file := UTL_FILE.fopen(directory_name, file_name, 'wb', l_amount);
    WHILE l_pos < l_data_len
    LOOP
      DBMS_LOB.read(contents, l_amount, l_pos, l_buffer);
      UTL_FILE.put_raw(l_file, l_buffer, TRUE);  -- auto-flush file after write
      l_pos := l_pos + l_amount;
    END LOOP;
    UTL_FILE.FCLOSE(l_file);

  EXCEPTION
    WHEN OTHERS THEN
      UTL_FILE.FCLOSE(l_file);
      RAISE;
  END write_file;


  -----------------------------------------------------------------------------
  -- read_file  - Read contents of a local file
  -----------------------------------------------------------------------------
  FUNCTION read_file(
        invoker_schema   IN  VARCHAR2,
        directory_name   IN  VARCHAR2,
        file_name        IN  VARCHAR2
  ) RETURN BLOB
  IS
    l_bfile      BFILE;
    l_contents   BLOB := NULL;
  BEGIN

    -- Create temporary lob to return OUT
    DBMS_LOB.createtemporary(l_contents, FALSE, DBMS_LOB.CALL);

    -- Load the contents of the file using BFILE
    l_bfile := BFILENAME(directory_name, file_name);

    -- Bug 30536171: Validate the bfile locator
    validate_bfile(l_bfile, file_name);

    DBMS_LOB.fileopen(l_bfile, DBMS_LOB.file_readonly);
    -- If the file is empty then do not read it
    IF DBMS_LOB.getlength(l_bfile) != 0 THEN
      DBMS_LOB.loadfromfile(l_contents, l_bfile, DBMS_LOB.LOBMAXSIZE);
    END IF;
    DBMS_LOB.fileclose(l_bfile);

    -- Return the contents
    RETURN l_contents;

  EXCEPTION
    WHEN OTHERS THEN
      -- Bug 30476989: Check if bfile was opened before closing it.
      IF l_bfile IS NOT NULL AND DBMS_LOB.fileisopen(l_bfile) = 1 THEN
        DBMS_LOB.fileclose(l_bfile);
      END IF;
      RAISE;
  END read_file;


  -----------------------------------------------------------------------------
  -- delete_file - Delete a file in given directory object location
  -----------------------------------------------------------------------------
  PROCEDURE delete_file(
        invoker_schema    in  VARCHAR2,
        directory_name    IN  VARCHAR2,
        file_name         IN  VARCHAR2
  )
  IS
    l_file_name   VARCHAR2(M_FILE_LEN);
  BEGIN

    -- Validate the file name
    l_file_name := validate_file_name(file_name);

    --
    -- Log the object operation
    --
    log_file_op(operation      => OPER_DEL_FILE,
                invoker_schema => invoker_schema,
                directory_name => directory_name,
                file_name      => l_file_name);

    --
    -- Delete the file
    --
    UTL_FILE.FREMOVE(directory_name, l_file_name);

  EXCEPTION
    WHEN UTL_FILE.invalid_filename OR UTL_FILE.invalid_path OR
         UTL_FILE.invalid_operation THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_FILE_NAME,
                'Invalid file name - ' || file_name);
    WHEN UTL_FILE.delete_failed THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_FILE_NAME,
                'Failed to delete file - ' || file_name);
    WHEN UTL_FILE.access_denied THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_FILE_NAME,
                'Access denied on file - ' || file_name);
    WHEN OTHERS THEN
      RAISE;
  END delete_file;


  -----------------------------------------------------------------------------
  -- convert_comma_str2strlist - convert command separted string to string list
  -----------------------------------------------------------------------------
  FUNCTION convert_comma_str2strlist(
    p_comma_string IN CLOB,
    p_item_string  IN VARCHAR2,
    p_max_length   IN NUMBER
  )
  RETURN SYS.ODCIVARCHAR2LIST
  IS
    l_item        CLOB;
    l_item_len    NUMBER;
    l_item_count  NUMBER;
    l_startOffset NUMBER := 1;
    l_string_list SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();
  BEGIN

    -- If input string is null, then return empty string list
    IF p_comma_string IS NULL THEN
      RETURN l_string_list;
    END IF;

    -- Check max item length to avoid buffer overflow
    DBMS_CLOUD_CORE.assert(p_max_length <= M_VCSIZ_4K,
                           'convert_comma_str2strlist',
                           'max_length (' || p_max_length || ') exceeds ' ||
                           M_VCSIZ_4K);

    l_item_count := LENGTH(REGEXP_REPLACE(p_comma_string,'".*?"|[^,]*')) + 1;

    FOR i IN 1..l_item_count
    LOOP
      -- Bug 31104577: Avoid CONNECT BY for performance reason when large list
      -- of URIs is given. Use offset based regex_substr for faster splitting.
      -- Bug 31306859: allow period(.) wild card to match newline characters
      l_item := REGEXP_SUBSTR(p_comma_string, '(".*?"|.*?)(,|$)',
                              l_startOffset, 1, 'n');

      -- Calculate the offset for the next item to search in the string
      l_startOffset := l_startOffset + LENGTH(l_item);

      -- Trim double quotes and white spaces
      -- Bug 31306859: Trim newlines
      l_item     := TRIM(TRIM(CHR(10) FROM (
                         TRIM('"' FROM TRIM(',' FROM TRIM(l_item))))));
      l_item_len := LENGTH(l_item);

      -- For each row in the result, stitch the value together by first
      -- enclosing with single quotes and then separate by comma
      IF l_item_len > 0 THEN
        IF l_item_len > p_max_length THEN
          raise_application_error(-20000,
            p_item_string ||
            ' exceeds maximum length (' || p_max_length || ') - ' || l_item);
        END IF;
        l_string_list.EXTEND;
        l_string_list(l_string_list.COUNT) := l_item;
      END IF;
    END LOOP;

    RETURN l_string_list;

  END convert_comma_str2strlist;


  -----------------------------------------------------------------------------
  -- resize_api_result_cache_size - Resize REST API cache size
  -----------------------------------------------------------------------------
  PROCEDURE resize_api_result_cache_size(
       cache_size IN NUMBER
  )
  IS
    l_cnt      NUMBER := 0;
    l_sqlstmt  VARCHAR2(M_VCSIZ_4K);
  BEGIN
    -- Bug 31659526: If the cache table reaches the max cache size, delete
    -- the oldest record.
    l_sqlstmt := 'select count(*) from dbms_cloud_rest_api_results$';
    EXECUTE IMMEDIATE l_sqlstmt INTO l_cnt;
    -- Bug 31659526: If the number of rows is greater than the max cache
    -- size, delete older records.
    IF l_cnt > cache_size THEN
      BEGIN
        l_sqlstmt := 'delete from dbms_cloud_rest_api_results$ ' ||
                      'where rowid IN ' ||
                      '(select rowid ' ||
                       'from (select rowid '||
                             'from dbms_cloud_rest_api_results$ ' ||
                             'order by timestamp ASC) ' ||
                       'fetch first :1 rows only)';
        EXECUTE IMMEDIATE l_sqlstmt using l_cnt - cache_size;
      END;
    END IF;
  EXCEPTION
  WHEN OTHERS THEN
    -- If the above SELECT or DELETE fail, ignore the error so that
    -- insertion can be done.
    NULL;
  END resize_api_result_cache_size;


  -----------------------------------------------------------------------------
  -- cache_rest_api_results - Cache REST API results
  -----------------------------------------------------------------------------
  PROCEDURE cache_rest_api_results(
        username             IN VARCHAR2,
        request_uri          IN VARCHAR2,
        timestamp            IN TIMESTAMP WITH TIME ZONE,
        request_method       IN VARCHAR2,
        request_headers      IN CLOB,
        request_body_text    IN CLOB,
        response_status_code IN NUMBER,
        response_headers     IN CLOB,
        response_body_text   IN CLOB,
        cache_scope          IN VARCHAR2 DEFAULT NULL
  )
  IS
    -- Use autonomous transaction to avoid committing a customer's transaction.
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_cnt                  NUMBER := 0;
    l_sqlstmt              VARCHAR2(M_VCSIZ_4K);
    l_cache_scope          VARCHAR2(M_IDEN);
    l_scope                NUMBER := CACHE_SCOPE_PRIVATE_ID;
  BEGIN
    -- Check if api result cache is enabled.
    IF CACHE_CAPACITY <= 0 THEN
      RETURN;
    END IF;

    IF cache_scope IS NULL THEN
      l_cache_scope := CACHE_SCOPE_PRIVATE;
    ELSIF LENGTH(TRIM(cache_scope)) > M_IDEN THEN
      raise_application_error(-20041, 'Invalid cache scope - ' ||
                              cache_scope);
    END IF;

    l_cache_scope := UPPER(TRIM(cache_scope));

    IF l_cache_scope NOT IN (CACHE_SCOPE_PUBLIC, CACHE_SCOPE_PRIVATE) THEN
      raise_application_error(-20041, 'Invalid cache scope - ' ||
                              cache_scope);
    END IF;

    IF l_cache_scope = CACHE_SCOPE_PUBLIC THEN
      l_scope := CACHE_SCOPE_PUBLIC_ID;
    END IF;

    resize_api_result_cache_size(CACHE_CAPACITY-1);

    l_sqlstmt := 'insert into dbms_cloud_rest_api_results$ ' ||
                 '(username, request_uri, timestamp, request_method, ' ||
                  'request_headers, request_body_text, ' ||
                  'response_status_code, response_headers, ' ||
                  'response_body_text, scope) ' ||
                  'values (:1, :2, :3, :4, :5, :6, :7, :8, :9, :10)';
    EXECUTE IMMEDIATE l_sqlstmt using username, request_uri, timestamp,
                                      request_method, request_headers,
                                      request_body_text,
                                      response_status_code, response_headers,
                                      response_body_text, l_scope;
    COMMIT;

  END cache_rest_api_results;


  -----------------------------------------------------------------------------
  -- set_api_result_cache_size - Update REST API max cache size
  -----------------------------------------------------------------------------
  PROCEDURE set_api_result_cache_size(
        cache_size  IN NUMBER
  )
  IS
    -- Use autonomous transaction to avoid committing a customer's transaction.
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_cnt      NUMBER := 0;
    l_sqlstmt  VARCHAR2(M_VCSIZ_4K);
  BEGIN
    IF DBMS_CLOUD_CORE.whole_number(cache_size) = FALSE OR
       cache_size > CACHE_MAX_SIZE THEN
      raise_application_error(-20032,
                              'invalid API result cache size');
    END IF;

    -- Resize api result cache if required
    resize_api_result_cache_size(cache_size);

    COMMIT;
    -- Update the cache max size
    CACHE_CAPACITY := cache_size;
  END set_api_result_cache_size;


  -----------------------------------------------------------------------------
  -- get_api_result_cache_size - Get REST API max cache size
  -----------------------------------------------------------------------------
  FUNCTION get_api_result_cache_size
  RETURN NUMBER
  IS
  BEGIN
    RETURN CACHE_CAPACITY;
  END get_api_result_cache_size;


  -----------------------------------------------------------------------------
  -- check_capability_status - Check capability status
  -----------------------------------------------------------------------------
  FUNCTION check_capability_status(
       capability   IN   VARCHAR2
  ) RETURN BOOLEAN
  IS
    l_stmt              VARCHAR2(M_VCSIZ_4K);
    l_status            BOOLEAN;
  BEGIN
    l_stmt := 'BEGIN                                                   ' ||
              ' :1 := DBMS_CLOUD_CAPABILITY.check_capability_func(:2); ' ||
              'END;';
    EXECUTE IMMEDIATE l_stmt USING OUT l_status, IN capability;

    RETURN l_status;
  END check_capability_status;

END dbms_cloud_internal;  -- End of DBMS_CLOUD_INTERNAL Package Body
/
