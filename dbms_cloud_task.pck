CREATE OR REPLACE NONEDITIONABLE PACKAGE C##CLOUD$SERVICE.dbms_cloud_task AS

  -- Constants for Task Class Status
  CLASS_STATUS_DISABLED CONSTANT PLS_INTEGER := 0;
  CLASS_STATUS_ENABLED  CONSTANT PLS_INTEGER := 1;
  CLASS_STATUS_DEFAULT  CONSTANT PLS_INTEGER := 1;

  -- Constants for Task Status
  TASK_STATUS_CREATED    CONSTANT PLS_INTEGER  := 1;
  TASK_STATUS_RUNNING    CONSTANT PLS_INTEGER  := 2;
  TASK_STATUS_COMPLETED  CONSTANT PLS_INTEGER  := 3;
  TASK_STATUS_FAILED     CONSTANT PLS_INTEGER  := 4;



  -----------------------------------------------------------------------------
  --               TASK CLASS MANAGEMENT PROCEDURES/FUNCTIONS
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- register_task_class  - Register a new task class for cloud access
  -----------------------------------------------------------------------------
  PROCEDURE register_task_class(
        class_name         IN  VARCHAR2,
        userid             IN  NUMBER,
        task_retention     IN  INTERVAL DAY TO SECOND DEFAULT NULL,
        task_deletion_cbk  IN  VARCHAR2 DEFAULT NULL,
        status             IN  NUMBER   DEFAULT CLASS_STATUS_DEFAULT
  );
    --
    -- NAME:
    --   register_task_class  - Register a task class for cloud access
    --
    -- DESCRIPTION:
    --   This procedure registers a new task class for cloud access. Once a
    --   task class is registered, then new tasks can be created for that task.
    --   The view USER_CLOUD_ACCESS_TASKS shows historical tasks issued for a
    --   given task class. The caller can define a custom retention period for
    --   tasks for the class, and a PL/SQL callback procedure to delete a task.
    --
    --   Task Classes can be disabled or enabled, default status is enabled.
    --
    -- PARAMETERS:
    --   class_name        (IN) - Name of the task class
    --
    --   userid            (IN) - User ID owning the task class
    --
    --   task_retention    (IN) - Interval to retain historical tasks
    --
    --   task_deletion_cbk (IN) - User.Package.Procedure name for task deletion
    --
    --   status            (IN) - Status of the task class (default enabled)
    --
    -- NOTES:
    --   Task class registration is required only one time.
    --


  -----------------------------------------------------------------------------
  -- update_task_class  - Update a task class for cloud access
  -----------------------------------------------------------------------------
  PROCEDURE update_task_class(
        class_name         IN  VARCHAR2,
        userid              IN  NUMBER,
        attribute_name     IN  VARCHAR2,
        attribute_value    IN  VARCHAR2
  );
    --
    -- NAME:
    --   update_task_class  - Update a task class for cloud access
    --
    -- DESCRIPTION:
    --   This procedure updates an attribute for an existing task class for
    --   cloud access.
    --
    --   Attributes for task class:
    --   --------------------------
    --     - task_retention
    --     - task_deletion_cbk
    --     - status
    --
    --
    -- PARAMETERS:
    --   class_name        (IN) - Name of the task class
    --
    --   userid             (IN) - User ID owning the task class
    --
    --   attribute_name    (IN) - Attribute of task class to update
    --
    --   attribute_value   (IN) - Attribute value
    --
    --
    -- NOTES:
    --



  -----------------------------------------------------------------------------
  --                  TASK MANAGEMENT PROCEDURES/FUNCTIONS
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- create_task  - Create a new task
  -----------------------------------------------------------------------------
  FUNCTION create_task(
        class_name         IN  VARCHAR2,
        userid             IN  NUMBER,
        status             IN  NUMBER DEFAULT TASK_STATUS_CREATED,
        payload            IN  CLOB   DEFAULT NULL,
        cleanup_interval   IN  INTERVAL DAY TO SECOND DEFAULT NULL
  ) RETURN NUMBER;
    --
    -- NAME:
    --   create_task  - Create a new task
    --
    -- DESCRIPTION:
    --   This function create a new task of a given task class. The task can
    --   have a custom payload to store custom information as a JSON document.
    --   This function allows maximum leading precision(2) of cleanup_interval.
    --
    --
    -- PARAMETERS:
    --   class_name       (IN) - Name of the task class
    --
    --   userid           (IN) - User ID owning the task
    --
    --   status           (IN) - Task status
    --
    --   payload          (IN) - Payload for the task
    --
    --   cleanup_interval (IN) - Cleanup interval for the task
    --
    -- RETURNS:
    --   Task ID which can used for future reference to the task
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- create_task2  - Create a new task with cleanup_interval(VARCHAR2)
  -----------------------------------------------------------------------------
  FUNCTION create_task2(
        class_name         IN  VARCHAR2,
        userid             IN  NUMBER,
        status             IN  NUMBER   DEFAULT TASK_STATUS_CREATED,
        payload            IN  CLOB     DEFAULT NULL,
        cleanup_interval   IN  VARCHAR2 DEFAULT NULL
  ) RETURN NUMBER;
    --
    -- NAME:
    --   create_task2  - Create a new task
    --
    -- DESCRIPTION:
    --   This function creates a new task of a given task class. Compared with
    --   create_task with cleanup_interval(INTERVAL DAY TO SECOND), this
    --   function allows cleanup interval precision up to 5 digits.
    --
    --
    -- PARAMETERS:
    --   class_name       (IN) - Name of the task class
    --
    --   userid           (IN) - User ID owning the task
    --
    --   status           (IN) - Task status
    --
    --   payload          (IN) - Payload for the task
    --
    --   cleanup_interval (IN) - Cleanup interval for the task
    --
    -- RETURNS:
    --   Task ID which can used for future reference to the task
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- update_task  - Update an existing task
  -----------------------------------------------------------------------------
  PROCEDURE update_task(
        id                 IN  NUMBER,
        userid             IN  NUMBER,
        status             IN  NUMBER DEFAULT NULL,
        payload            IN  CLOB   DEFAULT NULL
  );
    --
    -- NAME:
    --   update_task  - Update an existing task
    --
    -- DESCRIPTION:
    --   This function updates an existing task. The update can be for the
    --   status and/or payload attributes of the task.
    --
    --
    -- PARAMETERS:
    --   id              (IN) - ID for the task to update
    --
    --   user#           (IN) - User ID owning the task
    --
    --   status          (IN) - Task status
    --
    --   payload         (IN) - Payload for the task
    --
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- delete_task  - Delete an existing task
  -----------------------------------------------------------------------------
  PROCEDURE delete_task(
        id            IN  NUMBER,
        userid        IN  NUMBER,
        force         IN  BOOLEAN DEFAULT FALSE
  );
    --
    -- NAME:
    --   delete_task  - Delete an existing task
    --
    -- DESCRIPTION:
    --   This function deletes an existing task. It will automatically use
    --   the registered task deletion callback attribute (if any) for the
    --   task class and perform the task deletion.
    --
    --
    -- PARAMETERS:
    --   id              (IN) - ID for the task to update
    --
    --   userid          (IN) - User ID owning the task
    --
    --   force           (IN) - Force deletion of the task (optional)
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- delete_all_tasks  - Deletes all existing tasks
  -----------------------------------------------------------------------------
  PROCEDURE delete_all_tasks(
        class_name    IN  VARCHAR2,
        userid        IN  NUMBER
  );
    --
    -- NAME:
    --   delete_all_task  - Delete all existing task
    --
    -- DESCRIPTION:
    --   This function deletes all existing tasks for a given class type or all
    --   tasks if no class type specified. It will automatically use
    --   the registered task deletion callback attribute (if any) for the
    --   task class and perform the task deletion.
    --
    --
    -- PARAMETERS:
    --   class_name      (IN) - Name of the task class
    --
    --   userid          (IN) - User ID owning the task
    --
    -- NOTES:
    --


  -----------------------------------------------------------------------------
  -- delete_expired_tasks - Deletes expired tasks
  -----------------------------------------------------------------------------
  PROCEDURE delete_expired_tasks(
        class_name    IN  VARCHAR2 DEFAULT NULL,
        userid        IN  NUMBER   DEFAULT NULL
  );
    --
    -- NAME:
    --   delete_expired_tasks  - Delete expired tasks
    --
    -- DESCRIPTION:
    --   This function deletes all expired tasks, optionally for a given class
    --   and given user. It will automatically use the registered task deletion
    --   callback attribute (if any) for the task class and perform the task
    --   deletion.
    --
    --
    -- PARAMETERS:
    --   class_name      (IN) - Name of the task class (optional)
    --
    --   userid          (IN) - User ID owning the task (optional)
    --
    -- NOTES:
    --


END dbms_cloud_task; -- End of DBMS_CLOUD_TASK Package
/
CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY C##CLOUD$SERVICE.dbms_cloud_task AS

  ----------------------------
  -- Constants
  ----------------------------
  M_VCSIZ_4K   CONSTANT   PLS_INTEGER := 4000;

  -----------------------------------------------------------------------------
  --                     STATIC PROCEDURES/FUNCTIONS
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- validate__task_status - Validate rhe task status
  -----------------------------------------------------------------------------
  FUNCTION validate_task_status(
        status            IN  NUMBER
  ) RETURN BOOLEAN
  IS
    --
    -- NAME:
    --   validate__task_status - Validate rhe task status
    --
    -- DESCRIPTION:
    --   This function returns if the input status is valid value or not.
    --
    -- PARAMETERS:
    --   status           (IN)  - Task Status
    --
    -- RETURNS:
    --   TRUE  -  Task status is valid value
    --   FALSE -  Task status is not valid value
    -- NOTES:
    --
  BEGIN
    IF status = TASK_STATUS_CREATED   OR
       status = TASK_STATUS_RUNNING   OR
       status = TASK_STATUS_COMPLETED OR
       status = TASK_STATUS_FAILED
    THEN
       RETURN TRUE;
    ELSE
       RETURN FALSE;
    END IF;
  END;


  -----------------------------------------------------------------------------
  -- get_class_id    - Get Class id for a given Class name
  -----------------------------------------------------------------------------
  PROCEDURE get_class_id(
        class_name        IN  VARCHAR2,
        class_id          OUT NUMBER
  )
  IS
    --
    -- NAME:
    --   get_class_id    - Get Class id for a given Class name
    --
    -- DESCRIPTION:
    --   This procedure gets the class id for a given class name.
    --
    -- PARAMETERS:
    --   class_name       (IN)  - Name of the task class
    --
    --   class_id         (OUT) - ID for the task class
    --
    -- NOTES:
    --
  BEGIN
    -- Get the ID for given task class
    SELECT id# INTO class_id FROM dbms_cloud_task_class
        WHERE name = class_name;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OPERATION,
          'Operation class ' || class_name || ' does not exist');
  END;


  -----------------------------------------------------------------------------
  -- get_task_record  - Get Task record for a given task id
  -----------------------------------------------------------------------------
  PROCEDURE get_task_record(
        id                IN   NUMBER,
        userid            IN   NUMBER,
        task_record       OUT  dbms_cloud_tasks%ROWTYPE,
        lock_record       IN   BOOLEAN DEFAULT FALSE
  )
  IS
    --
    -- NAME:
    --   get_task_record  - Get Task record for a given task id
    --
    -- DESCRIPTION:
    --   This procedure gets the task information record as a row from
    --   the task table using the given task ID and the user id.
    --
    -- PARAMETERS:
    --   id                 (IN)  - ID for the task
    --
    --   userid             (IN)  - Owner user id for the task
    --
    --   task_record        (OUT) - Task record for the task
    --
    --   lock_record        (IN)  - Lock the record (optional, default FALSE)
    --
    -- NOTES:
    --
  BEGIN

    -- Bug 26636185: Validate operation id
    IF id IS NULL THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OPERATION,
          'Missing operation id');
    ELSIF DBMS_CLOUD_CORE.whole_number(id) = FALSE THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OPERATION,
          'Invalid operation id - ' || id);
    END IF;

    IF lock_record = TRUE THEN
      -- Get and lock the task record
      SELECT * INTO task_record
        FROM dbms_cloud_tasks
        WHERE id#=id AND (userid IS NULL OR user#=userid)
        FOR UPDATE;
    ELSE
      -- Get the task record
      SELECT * INTO task_record
        FROM dbms_cloud_tasks
        WHERE id#=id AND (userid IS NULL OR user#=userid);
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OPERATION,
          'Operation id ' || id || ' does not exist');
  END;


  -----------------------------------------------------------------------------
  -- get_class_record  - Get Task Class record for a given class id
  -----------------------------------------------------------------------------
  PROCEDURE get_class_record(
        class_id          IN   NUMBER,
        userid            IN   NUMBER,
        class_record      OUT  dbms_cloud_task_class%ROWTYPE,
        lock_record       IN   BOOLEAN DEFAULT FALSE
  )
  IS
    --
    -- NAME:
    --   get_class_record  - Get Task Class record for a given class id
    --
    -- DESCRIPTION:
    --   This procedure gets the task class information record as a row from
    --   the task class table using the given class ID and the user id.
    --
    -- PARAMETERS:
    --   class_id           (IN)  - ID for the task class
    --
    --   userid             (IN)  - Owner user id for the task class
    --
    --   class_record       (OUT) - Task class record for the class id
    --
    --   lock_record        (IN)  - Lock the record (select for update)
    --
    -- NOTES:
    --
  BEGIN

    IF class_id IS NULL THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OPERATION,
          'Missing operation class id');
    END IF;

    IF lock_record = TRUE THEN
      -- Get and lock the task class record
      SELECT * INTO class_record
        FROM dbms_cloud_task_class
        WHERE id#=class_id AND user#=userid
        FOR UPDATE;
    ELSE
      -- Get the task class record
      SELECT * INTO class_record
        FROM dbms_cloud_task_class
        WHERE id#=class_id AND user#=userid;
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OPERATION,
          'Invalid operation class id - ' || class_id);
  END;


  -----------------------------------------------------------------------------
  -- invoke_callback - Invoke a callback PL/SQL procedure
  -----------------------------------------------------------------------------
  PROCEDURE invoke_callback(
        userid             IN  NUMBER,
        procedure_name     IN  VARCHAR2,
        task_id            IN  NUMBER,
        task_userid        IN  NUMBER,
        payload            IN  CLOB,
        retval             OUT NUMBER
  )
  IS
    --
    -- NAME:
    --   invoke_callback - Invoke a callback PL/SQL procedure
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure to invoke a PL/SQL callback
    --   procedure in the context of a given user id.
    --
    --   The callback procedure has 2 fixed arguments of the Task ID and a
    --   custom payload for the task.
    --
    -- PARAMETERS:
    --   userid            (IN)  - User id to execute the callback procedure
    --
    --   procedure_name    (IN)  - Name of the callback procedure
    --
    --   task_id           (IN)  - Task ID as input to the callback procedure
    --
    --   task_userid       (IN)  - User ID for the task
    --
    --   payload           (IN)  - Payload as input to the callback procedure
    --
    --   retval            (OUT) - Output status from the callback procedure
    --
    -- NOTES:
    --
    cur       INTEGER;
    dummy     INTEGER;
    username  DBMS_QUOTED_ID;
  BEGIN
    -- Get the username for the task user id
    BEGIN
      SELECT username INTO username
          FROM  sys.all_users
          WHERE user_id = task_userid;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;

    -- Bug 26515981: Enquote username
    username := DBMS_ASSERT.enquote_name(username, FALSE);

    -- Execute the callback procedure in the context of given user id
    cur   := SYS.DBMS_SYS_SQL.open_cursor;
    SYS.DBMS_SYS_SQL.parse_as_user(cur,
        'BEGIN ' || DBMS_CLOUD_CORE.assert_qualified_sql_name(procedure_name)
                 || '(:id,:username,:payload,:retval); END;',
        DBMS_SQL.NATIVE, userid);
    SYS.DBMS_SYS_SQL.bind_variable(cur, ':id', task_id);
    SYS.DBMS_SYS_SQL.bind_variable(cur, ':username', username);
    SYS.DBMS_SYS_SQL.bind_variable(cur, ':payload', payload);
    SYS.DBMS_SYS_SQL.bind_variable(cur, ':retval', retval);
    dummy := SYS.DBMS_SYS_SQL.execute(cur);
    SYS.DBMS_SYS_SQL.close_cursor(cur);
  EXCEPTION
    WHEN OTHERS THEN
      SYS.DBMS_SYS_SQL.close_cursor(cur);
      RAISE;
  END;


  -----------------------------------------------------------------------------
  -- process_task_deletion_callback - Process Deletion callback for a task
  -----------------------------------------------------------------------------
  PROCEDURE process_task_deletion_callback(
        task_record        IN  dbms_cloud_tasks%ROWTYPE,
        retval             OUT NUMBER
  )
  IS
    --
    -- NAME:
    --   process_task_deletion_callback - Process Deletion callback for a task
    --
    -- DESCRIPTION:
    --   This procedure is a helper procedure to execute the deletion callback
    --   for a given task. The return value from the task deletion callback
    --   is set in the OUT argument.
    --
    -- PARAMETERS:
    --   task_record       (IN)  - Task record
    --
    --   retval            (OUT) - Output status from the callback procedure
    --
    -- NOTES:
    --
    class_record     dbms_cloud_task_class%ROWTYPE;
  BEGIN

    -- Get the Task Class record to see if there is any deletion callback for
    -- the class
    get_class_record(
        class_id     => task_record.class#,
        userid       => SYS_CONTEXT('USERENV', 'CURRENT_USERID'),
        class_record => class_record
    );

    -- Return early if not task deletion callback defined for the class
    IF class_record.cleanup_callback IS NULL OR
       LENGTH(class_record.cleanup_callback) = 0
    THEN
      RETURN;
    END IF;

    -- NOTE: for security reason, we switch back to the owner of the task
    invoke_callback(
         userid         => class_record.user#,
         procedure_name => class_record.cleanup_callback,
         task_id        => task_record.id#,
         task_userid    => task_record.user#,
         payload        => task_record.payload$,
         retval         => retval
    );

  END;



  -----------------------------------------------------------------------------
  --               TASK CLASS MANAGEMENT PROCEDURES/FUNCTIONS
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- register_task_class  - Register a new task class for cloud access
  -----------------------------------------------------------------------------
  PROCEDURE register_task_class(
        class_name         IN  VARCHAR2,
        userid             IN  NUMBER,
        task_retention     IN  INTERVAL DAY TO SECOND DEFAULT NULL,
        task_deletion_cbk  IN  VARCHAR2 DEFAULT NULL,
        status             IN  NUMBER   DEFAULT CLASS_STATUS_DEFAULT
  )
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_class_name    DBMS_ID;
  BEGIN

    -- Validate input
    l_class_name := DBMS_CLOUD_CORE.assert_simple_sql_name(class_name);
    DBMS_CLOUD_CORE.assert(DBMS_CLOUD_CORE.whole_number(userid) = TRUE,
                           'register_task_class',
                           'Missing of invalid user ID');
    DBMS_CLOUD_CORE.assert(status = CLASS_STATUS_ENABLED OR
                           status = CLASS_STATUS_DISABLED,
                          'register_task_class',
                          'Invalid status');

    -- Create the Task Class
    INSERT INTO dbms_cloud_task_class(name, user#, cleanup_interval,
                                      cleanup_callback, status)
        VALUES (l_class_name, userid, task_retention, task_deletion_cbk,
                status);
    COMMIT;

  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OPERATION,
          'Operation class ' || l_class_name || ' already exists');
  END;


  -----------------------------------------------------------------------------
  -- update_task_class  - Update a task class for cloud access
  -----------------------------------------------------------------------------
  PROCEDURE update_task_class(
        class_name         IN  VARCHAR2,
        userid             IN  NUMBER,
        attribute_name     IN  VARCHAR2,
        attribute_value    IN  VARCHAR2
  )
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_update_sql     CLOB;
    l_class_name     DBMS_ID;
    l_attribute_name DBMS_ID;
  BEGIN

    -- Validate input
    l_class_name     := DBMS_CLOUD_CORE.assert_simple_sql_name(class_name);
    l_attribute_name := DBMS_CLOUD_CORE.assert_simple_sql_name(attribute_name);
    DBMS_CLOUD_CORE.assert(DBMS_CLOUD_CORE.whole_number(userid) = TRUE,
                          'update_task_class','Missing of invalid user ID');
    DBMS_CLOUD_CORE.assert(attribute_value IS NOT NULL AND
                             LENGTH(attribute_value) <= M_VCSIZ_4K,
                           'update_task_class',
                           'Missing or invalid attribute value');

    -- Generate the UPDATE statement
    l_update_sql := 'UPDATE dbms_cloud_task_class SET ' ||
                          l_attribute_name || '=:1 WHERE name=:2 and user#=:3';
    EXECUTE IMMEDIATE l_update_sql
        USING attribute_value, l_class_name, userid;

    -- Verify that the task class row was updated
    IF (SQL%ROWCOUNT != 1) THEN
      ROLLBACK;
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OPERATION,
          'Operation class ' || l_class_name || ' does not exist');
    END IF;

    COMMIT;

  END;



  -----------------------------------------------------------------------------
  --                  TASK MANAGEMENT PROCEDURES/FUNCTIONS
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- create_task2  - Create a new task
  -----------------------------------------------------------------------------
  FUNCTION create_task2(
        class_name         IN  VARCHAR2,
        userid             IN  NUMBER,
        status             IN  NUMBER   DEFAULT TASK_STATUS_CREATED,
        payload            IN  CLOB     DEFAULT NULL,
        cleanup_interval   IN  VARCHAR2 DEFAULT NULL
  ) RETURN NUMBER
  IS
     PRAGMA AUTONOMOUS_TRANSACTION;
     l_task_id          NUMBER;
     l_class_id         NUMBER;
     l_sid              NUMBER;
     l_serial#          NUMBER;
     l_class_name       DBMS_ID;
     l_cleanup_interval INTERVAL DAY(5) TO SECOND;
  BEGIN

    -- Validate input
    l_class_name := DBMS_CLOUD_CORE.assert_simple_sql_name(class_name);
    DBMS_CLOUD_CORE.assert(DBMS_CLOUD_CORE.whole_number(userid) = TRUE,
                           'create_task', 'Invalid user id - ' || userid);
    DBMS_CLOUD_CORE.assert(validate_task_status(status),
                       'create_task', 'Invalid operation status - ' || status);

    -- Get Class ID
    get_class_id(l_class_name, l_class_id);

    -- Get current session sid and serial#
    DBMS_CLOUD_CORE.get_current_sessionid(l_sid, l_serial#);

    l_cleanup_interval := TO_DSINTERVAL(cleanup_interval);

    -- Create the Task
    -- Bug 31588608: Use the table instead of view for insert, to workaround
    --               an optimizer bug.
    INSERT INTO dbms_cloud_task$(sid, serial#, user#, class#, start_ts,
                                update_ts, status#, payload$, cleanup_interval)
                VALUES(l_sid, l_serial#, userid, l_class_id,
                       CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, status, payload,
                       l_cleanup_interval)
                RETURNING id# INTO l_task_id;
    COMMIT;

    RETURN l_task_id;
  END;


  -----------------------------------------------------------------------------
  -- create_task  - Create a new task
  -----------------------------------------------------------------------------
  FUNCTION create_task(
        class_name         IN  VARCHAR2,
        userid             IN  NUMBER,
        status             IN  NUMBER   DEFAULT TASK_STATUS_CREATED,
        payload            IN  CLOB     DEFAULT NULL,
        cleanup_interval   IN  INTERVAL DAY TO SECOND DEFAULT NULL
  ) RETURN NUMBER
  IS
     PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN

    RETURN create_task2(class_name, userid, status, payload,
                        TO_CHAR(cleanup_interval));
  END;


  -----------------------------------------------------------------------------
  -- update_task  - Update an existing task
  -----------------------------------------------------------------------------
  PROCEDURE update_task(
        id            IN  NUMBER,
        userid        IN  NUMBER,
        status        IN  NUMBER DEFAULT NULL,
        payload       IN  CLOB   DEFAULT NULL
  )
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN

    -- Validate input
    DBMS_CLOUD_CORE.assert(status IS NOT NULL OR payload IS NOT NULL,
                    'update_task', 'status or payload must be passed');
    DBMS_CLOUD_CORE.assert(DBMS_CLOUD_CORE.whole_number(userid) = TRUE,
                    'update_task','Missing of invalid user ID');
    IF status IS NOT NULL THEN
      DBMS_CLOUD_CORE.assert(validate_task_status(status),
                      'update_task', 'Missing or invalid status ' || status);
    END IF;

    -- Update the status and/or payload
    IF status IS NOT NULL AND payload IS NULL THEN
      UPDATE dbms_cloud_task$
        SET status#=status, update_ts=CURRENT_TIMESTAMP
        WHERE id#=id AND user#=userid;
    ELSIF payload IS NOT NULL AND status IS NULL THEN
      UPDATE dbms_cloud_task$
        SET payload$=payload, update_ts=CURRENT_TIMESTAMP
        WHERE id#=id AND user#=userid;
    ELSE
      UPDATE dbms_cloud_task$
        SET status#=status, payload$=payload, update_ts=CURRENT_TIMESTAMP
        WHERE id#=id AND user#=userid;
    END IF;

    COMMIT;

  END;


  -----------------------------------------------------------------------------
  -- delete_task  - Delete an existing task
  -----------------------------------------------------------------------------
  PROCEDURE delete_task(
        id            IN  NUMBER,
        userid        IN  NUMBER,
        force         IN  BOOLEAN DEFAULT FALSE
  )
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_task_record dbms_cloud_tasks%ROWTYPE;
    retval        NUMBER;
    l_force_str   VARCHAR2(10) := CASE WHEN force THEN 'TRUE' ELSE 'FALSE' END;
  BEGIN

    -- Validate input
    IF userid IS NOT NULL THEN
      DBMS_CLOUD_CORE.assert(DBMS_CLOUD_CORE.whole_number(userid) = TRUE,
                             'delete_task', 'Invalid userid ' || userid);
    END IF;

    -- If user is not passed, then force must be passed
    DBMS_CLOUD_CORE.assert(userid IS NOT NULL OR force = TRUE, 'delete_task',
        'Invalid userid: userid=' || userid || ' force=' || l_force_str);

    -- Get the task record
    get_task_record(id, userid, l_task_record, TRUE);

    -- Check that the task is not running
    IF force = FALSE AND
       l_task_record.status# != TASK_STATUS_COMPLETED AND
       l_task_record.status# != TASK_STATUS_FAILED
    THEN
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OPERATION,
          'Cannot delete operation in progress - ' || id);
    END IF;

    -- If the Task Class has a task deletion callback, then call it now
    -- If deletion callback fails, then signal error
    process_task_deletion_callback(l_task_record, retval);
    IF retval != 0 THEN
      ROLLBACK;
      raise_application_error(DBMS_CLOUD.EXCP_INVALID_OPERATION,
          'Failed to delete operation' || CHR(10) || SQLERRM);
    END IF;

    -- Delete the task
    DELETE FROM dbms_cloud_tasks WHERE id#=id;
    DBMS_CLOUD_CORE.assert(SQL%ROWCOUNT = 1, 'delete_task',
                           'Failed to delete operation');

    COMMIT;

  END;


  -----------------------------------------------------------------------------
  -- delete_all_tasks  - Deletes all existing tasks
  -----------------------------------------------------------------------------
  PROCEDURE delete_all_tasks(
        class_name    IN  VARCHAR2,
        userid        IN  NUMBER
  )
  IS
    l_class_id     NUMBER;
  BEGIN

    -- Validate input
    DBMS_CLOUD_CORE.assert(DBMS_CLOUD_CORE.whole_number(userid) = TRUE,
                           'delete_all_tasks', 'Invalid user id - ' || userid);

    -- Get Class ID
    IF class_name IS NOT NULL THEN
      get_class_id(DBMS_CLOUD_CORE.assert_simple_sql_name(class_name),
                   l_class_id);
    END IF;

    -- Find all tasks
    FOR l_task_id IN
      ( SELECT id# FROM dbms_cloud_tasks
          WHERE user#=userid AND (l_class_id IS NULL OR class#=l_class_id)
      )
    LOOP
      -- Delete the task, ignore errors
      BEGIN
        delete_task(l_task_id.id#, userid, FALSE);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;

  END;


  -----------------------------------------------------------------------------
  -- delete_expired_task_log_files  - Deletes all expired task log files
  -----------------------------------------------------------------------------
  PROCEDURE delete_expired_task_log_files(
    log_prefix           IN VARCHAR2,
    log_directory        IN VARCHAR2
  )
  IS
    --
    -- NAME:
    --   delete_expired_task_log_files  - Deletes all expired task log files
    --
    -- DESCRIPTION:
    --   This procedure is used to delete all the expired task log files in the
    --   log_directory provided which have the prefix provided.
    --
    -- PARAMETERS:
    --   log_prefix      (IN)  - Prefix of the task log files to be deleted
    --
    --   log_directory   (IN)  - Directory in which the task log files exist
    --
    -- NOTES:
    --
    l_log_prefix_len     NUMBER;
    l_current_user       DBMS_QUOTED_ID;
  BEGIN

    -- Nothing to do if log_prefix and log_directory are not passed in
    IF log_prefix IS NULL OR log_directory IS NULL THEN
      RETURN;
    END IF;

    l_log_prefix_len := LENGTH(log_prefix);
    l_current_user   := DBMS_ASSERT.enquote_name(
                            SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA'), FALSE);

    FOR l_file_record IN
      ( SELECT object_name
          FROM DBMS_CLOUD.list_files(directory_name => log_directory)
          WHERE (object_name LIKE log_prefix || '_%.log' OR
                 object_name LIKE log_prefix || '_%.bad') AND
                TO_NUMBER(
                  SUBSTR(object_name,
                         l_log_prefix_len + 1,
                         INSTR(object_name, '_') - l_log_prefix_len - 1))
                NOT IN (SELECT ID FROM DBA_LOAD_OPERATIONS)
     )
    LOOP
      DBMS_CLOUD_INTERNAL.delete_file(
          invoker_schema => l_current_user,
          directory_name => log_directory,
          file_name      => l_file_record.object_name
      );
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;


  -----------------------------------------------------------------------------
  -- delete_expired_tasks  - Deletes all expired tasks
  -----------------------------------------------------------------------------
  PROCEDURE delete_expired_tasks(
        class_name    IN  VARCHAR2 DEFAULT NULL,
        userid        IN  NUMBER   DEFAULT NULL
  )
  IS
    l_class_name   DBMS_ID;
  BEGIN

    -- Validate input
    IF class_name IS NOT NULL THEN
      l_class_name := DBMS_CLOUD_CORE.assert_simple_sql_name(class_name);
    END IF;

    -- Find all expired tasks, optionally belonging to give class and user
    -- Bug 32761637: check for task cleanup interval, if specified in the task
    FOR l_task_id IN
      ( SELECT t.id# FROM dbms_cloud_tasks t, dbms_cloud_task_class c
          WHERE t.class# = c.id# AND
                systimestamp - t.start_ts > nvl(t.cleanup_interval,
                                                c.cleanup_interval) AND
                (userid IS NULL OR t.user# = userid) AND
                (l_class_name IS NULL OR c.name = l_class_name)
      )
    LOOP
      -- Delete the task, ignore errors
      BEGIN
        delete_task(l_task_id.id#, NULL, TRUE);
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;

    -- Bug 27896377: Delete expired task log files
    -- This is a workaround to handle any pending files from previous
    -- failed deletions
    delete_expired_task_log_files(
      log_prefix    =>   DBMS_CLOUD_CORE.COPY_LOG_PREFIX,
      log_directory =>   DBMS_CLOUD_CORE.DEFAULT_LOG_DIR
    );

    delete_expired_task_log_files(
      log_prefix    =>   DBMS_CLOUD_CORE.VALIDATE_LOG_PREFIX,
      log_directory =>   DBMS_CLOUD_CORE.DEFAULT_LOG_DIR
    );

  END;

END dbms_cloud_task;  -- End of DBMS_CLOUD_TASK Package
/
