CREATE TABLE memory_usage (
  id INT PRIMARY KEY,
  process_id INT,
  memory_used DECIMAL(10, 2),
  timestamp DATETIME
);

CREATE TABLE processes (
  id INT PRIMARY KEY,
  process_name VARCHAR(255),
  start_time DATETIME,
  end_time DATETIME
);

CREATE TABLE memory_profiler_config (
  id INT PRIMARY KEY,
  sampling_interval INT,
  max_samples INT
);

INSERT INTO memory_profiler_config (id, sampling_interval, max_samples) 
VALUES (1, 1000, 10000);

CREATE PROCEDURE start_profiling()
BEGIN
  INSERT INTO processes (id, process_name, start_time) 
  VALUES (1, 'Memory Profiler', NOW());
END;

CREATE PROCEDURE stop_profiling()
BEGIN
  UPDATE processes SET end_time = NOW() WHERE id = 1;
END;

CREATE PROCEDURE collect_memory_usage()
BEGIN
  DECLARE sampling_interval INT;
  DECLARE max_samples INT;
  DECLARE current_sample INT;
  SET sampling_interval = (SELECT sampling_interval FROM memory_profiler_config WHERE id = 1);
  SET max_samples = (SELECT max_samples FROM memory_profiler_config WHERE id = 1);
  SET current_sample = 1;
  WHILE current_sample <= max_samples DO
    INSERT INTO memory_usage (process_id, memory_used, timestamp) 
    VALUES (1, (SELECT DECIMAL(10, 2) VALUE FROM information_schema.global_status WHERE VARIABLE_NAME = ' Innodb_buffer_pool_read_requests'), NOW());
    SET current_sample = current_sample + 1;
    SLEEP(sampling_interval / 1000);
  END WHILE;
END;

CREATE TRIGGER memory_profiler_trigger AFTER INSERT ON memory_usage
FOR EACH ROW
BEGIN
  IF (SELECT COUNT(*) FROM memory_usage WHERE process_id = 1) > (SELECT max_samples FROM memory_profiler_config WHERE id = 1) THEN
    DELETE FROM memory_usage WHERE process_id = 1 AND id = (SELECT MIN(id) FROM memory_usage WHERE process_id = 1);
  END IF;
END;

CREATE VIEW memory_profiler_view AS
SELECT mu.id, mu.process_id, mu.memory_used, mu.timestamp
FROM memory_usage mu
JOIN processes p ON mu.process_id = p.id
WHERE p.process_name = 'Memory Profiler';

CREATE PROCEDURE display_memory_usage()
BEGIN
  SELECT * FROM memory_profiler_view;
END;

CALL start_profiling();
CALL collect_memory_usage();
CALL stop_profiling();
CALL display_memory_usage();