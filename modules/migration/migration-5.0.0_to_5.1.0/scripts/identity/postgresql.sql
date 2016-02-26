DO $$ DECLARE con_name varchar(200); BEGIN SELECT 'ALTER TABLE idn_oauth1a_request_token DROP CONSTRAINT ' || tc .constraint_name || ';' INTO con_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name = 'idn_oauth1a_request_token' AND kcu.column_name = 'consumer_key'; EXECUTE con_name; END $$;

DO $$ DECLARE con_name varchar(200); BEGIN SELECT 'ALTER TABLE idn_oauth1a_access_token DROP CONSTRAINT ' || tc .constraint_name || ';' INTO con_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name = 'idn_oauth1a_access_token' AND kcu.column_name = 'consumer_key'; EXECUTE con_name; END $$;

DO $$ DECLARE con_name varchar(200); BEGIN SELECT 'ALTER TABLE idn_oauth2_access_token DROP CONSTRAINT ' || tc .constraint_name || ';' INTO con_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name = 'idn_oauth2_access_token' AND kcu.column_name = 'consumer_key'; EXECUTE con_name; END $$;

DO $$ DECLARE con_name varchar(200); BEGIN SELECT 'ALTER TABLE idn_oauth2_authorization_code DROP CONSTRAINT ' || tc .constraint_name || ';' INTO con_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name = 'idn_oauth2_authorization_code' AND kcu.column_name = 'consumer_key'; EXECUTE con_name; END $$;

DO $$ DECLARE con_name varchar(200); BEGIN SELECT 'ALTER TABLE idn_oauth_consumer_apps DROP CONSTRAINT ' || tc .constraint_name || ';' INTO con_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name WHERE constraint_type = 'PRIMARY KEY' AND tc.table_name = 'idn_oauth_consumer_apps'; EXECUTE con_name; END $$;

DROP TABLE IF EXISTS IDP_METADATA;
DROP SEQUENCE IF EXISTS IDP_METADATA_SEQ;
CREATE SEQUENCE IDP_METADATA_SEQ;
CREATE TABLE IDP_METADATA (
  ID INTEGER DEFAULT NEXTVAL('IDP_METADATA_SEQ'),
  IDP_ID INTEGER,
  NAME VARCHAR(255) NOT NULL,
  VALUE VARCHAR(255) NOT NULL,
  DISPLAY_NAME VARCHAR(255),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (ID),
  CONSTRAINT IDP_METADATA_CONSTRAINT UNIQUE (IDP_ID, NAME),
  FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE);

INSERT INTO IDP_METADATA (IDP_ID, NAME, VALUE, DISPLAY_NAME, TENANT_ID) VALUES (1, 'SessionIdleTimeout', '15', 'Session Idle Timeout', -1234);
INSERT INTO IDP_METADATA (IDP_ID, NAME, VALUE, DISPLAY_NAME, TENANT_ID) VALUES (1, 'RememberMeTimeout', '20160', 'RememberMe Timeout', -1234);

DROP TABLE IF EXISTS SP_METADATA;
DROP SEQUENCE IF EXISTS SP_METADATA_SEQ;
CREATE SEQUENCE SP_METADATA_SEQ;
CREATE TABLE SP_METADATA (
  ID INTEGER DEFAULT NEXTVAL('SP_METADATA_SEQ'),
  SP_ID INTEGER,
  NAME VARCHAR(255) NOT NULL,
  VALUE VARCHAR(255) NOT NULL,
  DISPLAY_NAME VARCHAR(255),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (ID),
  CONSTRAINT SP_METADATA_CONSTRAINT UNIQUE (SP_ID, NAME),
  FOREIGN KEY (SP_ID) REFERENCES SP_APP(ID) ON DELETE CASCADE);

ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD USER_DOMAIN VARCHAR(50);
DROP SEQUENCE IF EXISTS IDN_OAUTH_CONSUMER_APPS_PK_SEQ;
CREATE SEQUENCE IDN_OAUTH_CONSUMER_APPS_PK_SEQ;
ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD ID INTEGER DEFAULT NEXTVAL('IDN_OAUTH_CONSUMER_APPS_PK_SEQ');
ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD PRIMARY KEY (ID);
ALTER TABLE idn_oauth_consumer_apps ALTER COLUMN CONSUMER_KEY TYPE VARCHAR(255) USING CONSUMER_KEY::VARCHAR;
ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD CONSTRAINT CONSUMER_KEY_CONSTRAINT UNIQUE (CONSUMER_KEY);

ALTER TABLE IDN_OAUTH1A_REQUEST_TOKEN ADD CONSUMER_KEY_ID INTEGER;
UPDATE IDN_OAUTH1A_REQUEST_TOKEN set CONSUMER_KEY_ID = (select ID from IDN_OAUTH_CONSUMER_APPS where IDN_OAUTH_CONSUMER_APPS.CONSUMER_KEY = IDN_OAUTH1A_REQUEST_TOKEN.CONSUMER_KEY);
ALTER TABLE IDN_OAUTH1A_REQUEST_TOKEN DROP COLUMN CONSUMER_KEY;
ALTER TABLE IDN_OAUTH1A_REQUEST_TOKEN ADD FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE;
ALTER TABLE IDN_OAUTH1A_REQUEST_TOKEN ADD TENANT_ID INTEGER DEFAULT -1;

ALTER TABLE IDN_OAUTH1A_ACCESS_TOKEN ADD CONSUMER_KEY_ID INTEGER;
UPDATE IDN_OAUTH1A_ACCESS_TOKEN set CONSUMER_KEY_ID = (select ID from IDN_OAUTH_CONSUMER_APPS where IDN_OAUTH_CONSUMER_APPS.CONSUMER_KEY = IDN_OAUTH1A_ACCESS_TOKEN.CONSUMER_KEY);
ALTER TABLE IDN_OAUTH1A_ACCESS_TOKEN DROP COLUMN CONSUMER_KEY;
ALTER TABLE IDN_OAUTH1A_ACCESS_TOKEN ADD FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE;
ALTER TABLE IDN_OAUTH1A_ACCESS_TOKEN ADD TENANT_ID INTEGER DEFAULT -1;

DO $$ DECLARE con_name varchar(200); BEGIN SELECT 'ALTER TABLE idn_oauth2_access_token DROP CONSTRAINT ' || tc .constraint_name || ';' INTO con_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name WHERE constraint_type = 'PRIMARY KEY' AND tc.table_name = 'idn_oauth2_access_token'; EXECUTE con_name; END $$;
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD TOKEN_ID VARCHAR (255);
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD CONSUMER_KEY_ID INTEGER;
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD GRANT_TYPE VARCHAR (50);
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD SUBJECT_IDENTIFIER VARCHAR(255);
UPDATE IDN_OAUTH2_ACCESS_TOKEN set CONSUMER_KEY_ID = (select ID from IDN_OAUTH_CONSUMER_APPS where IDN_OAUTH_CONSUMER_APPS.CONSUMER_KEY = IDN_OAUTH2_ACCESS_TOKEN.CONSUMER_KEY);
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN DROP CONSTRAINT CON_APP_KEY;
DROP INDEX IF EXISTS IDX_AT_CK_AU;
DROP INDEX IF EXISTS IDX_OAUTH_ACCTKN_CONK_UTYPE;
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN DROP COLUMN CONSUMER_KEY;
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD TENANT_ID INTEGER;
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD USER_DOMAIN VARCHAR(50);
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD REFRESH_TOKEN_TIME_CREATED TIMESTAMP;
UPDATE IDN_OAUTH2_ACCESS_TOKEN SET REFRESH_TOKEN_TIME_CREATED = TIME_CREATED;
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD REFRESH_TOKEN_VALIDITY_PERIOD BIGINT;
UPDATE IDN_OAUTH2_ACCESS_TOKEN SET REFRESH_TOKEN_VALIDITY_PERIOD = 84600000;
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD TOKEN_SCOPE_HASH VARCHAR (32);
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ALTER COLUMN TOKEN_STATE_ID TYPE VARCHAR(128) USING TOKEN_STATE_ID::VARCHAR;
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ALTER COLUMN TOKEN_STATE_ID SET DEFAULT 'NONE';
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD CONSTRAINT CON_APP_KEY UNIQUE (CONSUMER_KEY_ID,AUTHZ_USER,TENANT_ID,USER_DOMAIN,USER_TYPE,TOKEN_SCOPE_HASH,TOKEN_STATE,TOKEN_STATE_ID);
CREATE INDEX IDX_AT_CK_AU ON IDN_OAUTH2_ACCESS_TOKEN(CONSUMER_KEY_ID, AUTHZ_USER, TOKEN_STATE, USER_TYPE);
CREATE INDEX IDX_TC ON IDN_OAUTH2_ACCESS_TOKEN(TIME_CREATED);
ALTER TABLE IDN_OAUTH2_ACCESS_TOKEN ADD FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE;

ALTER TABLE IDN_OAUTH2_RESOURCE_SCOPE ADD TENANT_ID INTEGER DEFAULT -1;
ALTER TABLE IDN_OPENID_ASSOCIATIONS ADD TENANT_ID INTEGER DEFAULT -1;
ALTER TABLE IDN_THRIFT_SESSION ADD TENANT_ID INTEGER DEFAULT -1;

ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD CONSUMER_KEY_ID INTEGER;
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD TENANT_ID INTEGER;
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD USER_DOMAIN VARCHAR(50);
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD STATE VARCHAR (25) DEFAULT 'ACTIVE';
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD TOKEN_ID VARCHAR(255);
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD CODE_ID VARCHAR (255);
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD SUBJECT_IDENTIFIER VARCHAR(255);
DO $$ DECLARE con_name varchar(200); BEGIN SELECT 'ALTER TABLE idn_oauth2_authorization_code DROP CONSTRAINT ' || tc .constraint_name || ';' INTO con_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name WHERE constraint_type = 'PRIMARY KEY' AND tc.table_name = 'idn_oauth2_authorization_code'; EXECUTE con_name; END $$;
UPDATE IDN_OAUTH2_AUTHORIZATION_CODE set CONSUMER_KEY_ID = (select ID from IDN_OAUTH_CONSUMER_APPS where IDN_OAUTH_CONSUMER_APPS.CONSUMER_KEY = IDN_OAUTH2_AUTHORIZATION_CODE.CONSUMER_KEY);
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE DROP COLUMN CONSUMER_KEY;
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE;

DROP TABLE IF EXISTS IDN_SCIM_PROVIDER;

ALTER TABLE IDN_IDENTITY_USER_DATA  ALTER COLUMN DATA_VALUE DROP NOT NULL;

UPDATE IDN_ASSOCIATED_ID set IDP_ID = (SELECT ID FROM IDP WHERE IDP.NAME = IDN_ASSOCIATED_ID.IDP_ID AND IDP.TENANT_ID = IDN_ASSOCIATED_ID.TENANT_ID );
ALTER TABLE IDN_ASSOCIATED_ID ALTER COLUMN IDP_ID TYPE INTEGER USING IDP_ID::INTEGER;
ALTER TABLE IDN_ASSOCIATED_ID ADD DOMAIN_NAME VARCHAR(255);
ALTER TABLE IDN_ASSOCIATED_ID ADD FOREIGN KEY (IDP_ID )  REFERENCES IDP (ID) ON DELETE CASCADE;

DELETE FROM IDN_AUTH_SESSION_STORE;
ALTER TABLE IDN_AUTH_SESSION_STORE ALTER COLUMN SESSION_ID DROP DEFAULT;
ALTER TABLE IDN_AUTH_SESSION_STORE ALTER COLUMN SESSION_ID SET NOT NULL;
ALTER TABLE IDN_AUTH_SESSION_STORE ALTER COLUMN SESSION_TYPE DROP DEFAULT;
ALTER TABLE IDN_AUTH_SESSION_STORE ALTER COLUMN SESSION_TYPE SET NOT NULL;
ALTER TABLE IDN_AUTH_SESSION_STORE DROP COLUMN TIME_CREATED;
ALTER TABLE IDN_AUTH_SESSION_STORE ADD COLUMN TIME_CREATED BIGINT NOT NULL;
ALTER TABLE IDN_AUTH_SESSION_STORE ADD OPERATION VARCHAR(10) NOT NULL;
ALTER TABLE IDN_AUTH_SESSION_STORE ADD TENANT_ID INTEGER DEFAULT -1;
DO $$ DECLARE con_name varchar(200); BEGIN SELECT 'ALTER TABLE idn_auth_session_store DROP CONSTRAINT ' || tc .constraint_name || ';' INTO con_name FROM information_schema.table_constraints AS tc JOIN information_schema.key_column_usage AS kcu ON tc.constraint_name = kcu.constraint_name JOIN information_schema.constraint_column_usage AS ccu ON ccu.constraint_name = tc.constraint_name WHERE constraint_type = 'PRIMARY KEY' AND tc.table_name = 'idn_auth_session_store'; EXECUTE con_name; END $$;
ALTER TABLE IDN_AUTH_SESSION_STORE ADD PRIMARY KEY (SESSION_ID, SESSION_TYPE, TIME_CREATED, OPERATION);

ALTER TABLE SP_APP ADD IS_USE_TENANT_DOMAIN_SUBJECT CHAR(1) DEFAULT '1' NOT NULL;
ALTER TABLE SP_APP ADD IS_USE_USER_DOMAIN_SUBJECT CHAR(1) DEFAULT '1' NOT NULL;
ALTER TABLE SP_APP ADD IS_DUMB_MODE CHAR(1) DEFAULT '0';

INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) VALUES (-1234, 1, 'IDPProperties');
INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME) VALUES (-1234, 1, 'passivests');

INSERT INTO  IDP_AUTHENTICATOR_PROPERTY (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY,PROPERTY_VALUE, IS_SECRET ) VALUES (-1234, 3 , 'IdPEntityId', 'localhost', '0');

ALTER TABLE SP_INBOUND_AUTH ALTER INBOUND_AUTH_KEY DROP NOT NULL;

ALTER TABLE IDP_PROVISIONING_ENTITY ADD ENTITY_LOCAL_ID VARCHAR(255);

DROP TABLE IF EXISTS IDN_OAUTH2_ACCESS_TOKEN_SCOPE;
CREATE TABLE IDN_OAUTH2_ACCESS_TOKEN_SCOPE (
  TOKEN_ID VARCHAR (255),
  TOKEN_SCOPE VARCHAR (60),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (TOKEN_ID, TOKEN_SCOPE));

DROP TABLE IF EXISTS IDN_USER_ACCOUNT_ASSOCIATION;
CREATE TABLE IDN_USER_ACCOUNT_ASSOCIATION (
  ASSOCIATION_KEY VARCHAR(255) NOT NULL,
  TENANT_ID INTEGER,
  DOMAIN_NAME VARCHAR(255) NOT NULL,
  USER_NAME VARCHAR(255) NOT NULL,
  PRIMARY KEY (TENANT_ID, DOMAIN_NAME, USER_NAME));

DROP TABLE IF EXISTS WF_REQUEST;
CREATE TABLE WF_REQUEST (
  UUID VARCHAR (45),
  CREATED_BY VARCHAR (255),
  TENANT_ID INTEGER DEFAULT -1,
  OPERATION_TYPE VARCHAR (50),
  CREATED_AT TIMESTAMP,
  UPDATED_AT TIMESTAMP,
  STATUS VARCHAR (30),
  REQUEST BYTEA,
  PRIMARY KEY (UUID)
);

DROP TABLE IF EXISTS WF_BPS_PROFILE;
CREATE TABLE WF_BPS_PROFILE (
  PROFILE_NAME VARCHAR(45),
  HOST_URL_MANAGER VARCHAR(45),
  HOST_URL_WORKER VARCHAR(45),
  USERNAME VARCHAR(45),
  PASSWORD VARCHAR(255),
  CALLBACK_HOST VARCHAR (45),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (PROFILE_NAME, TENANT_ID)
);

DROP TABLE IF EXISTS WF_WORKFLOW;
CREATE TABLE WF_WORKFLOW(
  ID VARCHAR (45),
  WF_NAME VARCHAR (45),
  DESCRIPTION VARCHAR (255),
  TEMPLATE_ID VARCHAR (45),
  IMPL_ID VARCHAR (45),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (ID)
);

DROP TABLE IF EXISTS WF_WORKFLOW_ASSOCIATION;
DROP SEQUENCE IF EXISTS WF_WORKFLOW_ASSOCIATION_PK_SEQ;
CREATE SEQUENCE WF_WORKFLOW_ASSOCIATION_PK_SEQ;
CREATE TABLE WF_WORKFLOW_ASSOCIATION(
  ID INTEGER DEFAULT NEXTVAL('WF_WORKFLOW_ASSOCIATION_PK_SEQ'),
  ASSOC_NAME VARCHAR (45),
  EVENT_ID VARCHAR(45),
  ASSOC_CONDITION VARCHAR (2000),
  WORKFLOW_ID VARCHAR (45),
  IS_ENABLED CHAR (1) DEFAULT '1',
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY(ID),
  FOREIGN KEY (WORKFLOW_ID) REFERENCES WF_WORKFLOW(ID)ON DELETE CASCADE
);

DROP TABLE IF EXISTS WF_WORKFLOW_CONFIG_PARAM;
CREATE TABLE WF_WORKFLOW_CONFIG_PARAM(
  WORKFLOW_ID VARCHAR (45),
  PARAM_NAME VARCHAR (45),
  PARAM_VALUE VARCHAR (1000),
  PARAM_QNAME VARCHAR (45),
  PARAM_HOLDER VARCHAR (45),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (WORKFLOW_ID, PARAM_NAME, PARAM_QNAME, PARAM_HOLDER),
  FOREIGN KEY (WORKFLOW_ID) REFERENCES WF_WORKFLOW(ID)ON DELETE CASCADE
);

DROP TABLE IF EXISTS WF_REQUEST_ENTITY_RELATIONSHIP;
CREATE TABLE WF_REQUEST_ENTITY_RELATIONSHIP(
  REQUEST_ID VARCHAR (45),
  ENTITY_NAME VARCHAR (255),
  ENTITY_TYPE VARCHAR (50),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY(REQUEST_ID, ENTITY_NAME, ENTITY_TYPE, TENANT_ID),
  FOREIGN KEY (REQUEST_ID) REFERENCES WF_REQUEST(UUID)ON DELETE CASCADE
);

DROP TABLE IF EXISTS WF_WORKFLOW_REQUEST_RELATION;
CREATE TABLE WF_WORKFLOW_REQUEST_RELATION(
  RELATIONSHIP_ID VARCHAR (45),
  WORKFLOW_ID VARCHAR (45),
  REQUEST_ID VARCHAR (45),
  UPDATED_AT TIMESTAMP,
  STATUS VARCHAR (30),
  TENANT_ID INTEGER DEFAULT -1,
  PRIMARY KEY (RELATIONSHIP_ID),
  FOREIGN KEY (WORKFLOW_ID) REFERENCES WF_WORKFLOW(ID)ON DELETE CASCADE,
  FOREIGN KEY (REQUEST_ID) REFERENCES WF_REQUEST(UUID)ON DELETE CASCADE
);
