DROP TABLE IF EXISTS paste;
CREATE TABLE paste (  
  id MEDIUMINT NOT NULL AUTO_INCREMENT,
  digest BINARY(20) NOT NULL,
  content MEDIUMBLOB NOT NULL,
  raw BIT(1) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY (digest)
)
ENGINE = InnoDB;

DELIMITER @@
DROP PROCEDURE IF EXISTS insert_paste@@
CREATE PROCEDURE insert_paste (
  p_content MEDIUMBLOB,
  p_raw BIT(1),
  OUT p_id MEDIUMINT
)
BEGIN
  START TRANSACTION;
  INSERT paste (digest, content, raw)
  VALUES (UNHEX(SHA1(p_content)), p_content, p_raw);
  SELECT last_insert_id() INTO p_id;
  COMMIT;
END;
@@

DROP PROCEDURE IF EXISTS get_stats@@
CREATE PROCEDURE get_stats (
  OUT p_count INT
)
BEGIN
  SELECT COUNT(*) INTO p_count
  FROM paste;
END;
@@

DROP PROCEDURE IF EXISTS get_digest@@
CREATE PROCEDURE get_digest (
  p_digest BINARY(20),
  OUT p_id MEDIUMINT
)
BEGIN
  SELECT id INTO p_id
  FROM paste
  WHERE digest = p_digest;
END;
@@

DROP PROCEDURE IF EXISTS get_content@@
CREATE PROCEDURE get_content (
  p_id MEDIUMINT,
  OUT p_content MEDIUMBLOB,
  OUT p_raw BIT(1)
)
BEGIN
  SELECT content, raw INTO p_content, p_raw
  FROM paste
  WHERE id = p_id;
END;
@@