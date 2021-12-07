CREATE OR REPLACE NONEDITIONABLE PACKAGE C##CLOUD$SERVICE.dbms_cloud_types AUTHID CURRENT_USER AS

  ----------------------------
  --  CONSTANTS AND TYPES
  ----------------------------

  M_IDEN       CONSTANT   PLS_INTEGER := 128;
  M_VCSIZ_4K   CONSTANT   PLS_INTEGER := 4000;

  --
  -- Type for return value from list_objects table function
  --
  TYPE list_object_ret_t   IS RECORD(object_name   VARCHAR2(M_VCSIZ_4K),
                                     bytes         NUMBER,
                                     checksum      VARCHAR2(M_IDEN),
                                     created       TIMESTAMP WITH TIME ZONE,
                                     last_modified TIMESTAMP WITH TIME ZONE);
  TYPE list_object_ret_tab IS TABLE OF list_object_ret_t;

  --
  -- Type for return value from get_object table function
  --
  TYPE get_object_ret_t   IS RECORD (status NUMBER);
  TYPE get_object_ret_tab IS TABLE OF get_object_ret_t;

  --
  -- Type for return value from get_network_acl function
  --
  TYPE network_acl_ret_t   IS RECORD(ace VARCHAR2(1024));
  TYPE network_acl_ret_tab IS TABLE OF network_acl_ret_t;

  --
  -- Associative array for storing field names from the list object response
  --
  TYPE list_object_fields_t IS TABLE OF VARCHAR2(M_IDEN)
         INDEX BY VARCHAR2(M_IDEN/2);


  --
  -- HTTP Response type
  --
  TYPE resp IS RECORD (
        headers        JSON_OBJECT_T,     -- Response headers as JSON object
        body           BLOB,              -- Response body as a BLOB
        status_code    PLS_INTEGER,       -- Response status code
        init           BOOLEAN            -- Response initialized
  );


  --
  -- Type for expected states of async operation
  --
  TYPE wait_for_states_t IS TABLE OF VARCHAR2(M_IDEN);


END dbms_cloud_types; -- End of DBMS_CLOUD_TYPES Package
/
