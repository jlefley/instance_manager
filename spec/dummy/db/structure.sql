--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: instance_users_created_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION instance_users_created_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$        BEGIN
          IF (TG_OP = 'UPDATE') THEN
            NEW."created_at" := OLD."created_at";
          ELSIF (TG_OP = 'INSERT') THEN
            NEW."created_at" := CURRENT_TIMESTAMP;
          END IF;
          RETURN NEW;
        END;
$$;


--
-- Name: instances_created_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION instances_created_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$        BEGIN
          IF (TG_OP = 'UPDATE') THEN
            NEW."created_at" := OLD."created_at";
          ELSIF (TG_OP = 'INSERT') THEN
            NEW."created_at" := CURRENT_TIMESTAMP;
          END IF;
          RETURN NEW;
        END;
$$;


--
-- Name: instances_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION instances_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$        BEGIN
          NEW."updated_at" := CURRENT_TIMESTAMP;
          RETURN NEW;
        END;
$$;


--
-- Name: registration_codes_created_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION registration_codes_created_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$        BEGIN
          IF (TG_OP = 'UPDATE') THEN
            NEW."created_at" := OLD."created_at";
          ELSIF (TG_OP = 'INSERT') THEN
            NEW."created_at" := CURRENT_TIMESTAMP;
          END IF;
          RETURN NEW;
        END;
$$;


--
-- Name: users_created_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION users_created_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$        BEGIN
          IF (TG_OP = 'UPDATE') THEN
            NEW."created_at" := OLD."created_at";
          ELSIF (TG_OP = 'INSERT') THEN
            NEW."created_at" := CURRENT_TIMESTAMP;
          END IF;
          RETURN NEW;
        END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: instance_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE instance_users (
    user_id integer NOT NULL,
    instance_id integer NOT NULL,
    creator_id integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    admin boolean DEFAULT false NOT NULL
);


--
-- Name: instances; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE instances (
    id integer NOT NULL,
    name text NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: instances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: instances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE instances_id_seq OWNED BY instances.id;


--
-- Name: registration_codes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE registration_codes (
    code text NOT NULL,
    user_id integer,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: schema_info; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_info (
    version integer DEFAULT 0 NOT NULL
);


--
-- Name: things; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE things (
    id integer NOT NULL,
    name text
);


--
-- Name: things_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE things_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: things_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE things_id_seq OWNED BY things.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email text NOT NULL,
    reset_password_token text,
    reset_password_sent_at timestamp with time zone,
    remember_created_at timestamp with time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    current_sign_in_ip text,
    last_sign_in_ip text,
    confirmation_token text,
    confirmed_at timestamp with time zone,
    confirmation_sent_at timestamp with time zone,
    unconfirmed_email text,
    failed_attempts integer DEFAULT 0,
    system_admin boolean DEFAULT false NOT NULL,
    locked_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    encrypted_password text,
    username text
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY instances ALTER COLUMN id SET DEFAULT nextval('instances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY things ALTER COLUMN id SET DEFAULT nextval('things_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: instance_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY instance_users
    ADD CONSTRAINT instance_users_pkey PRIMARY KEY (user_id, instance_id);


--
-- Name: instances_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY instances
    ADD CONSTRAINT instances_name_key UNIQUE (name);


--
-- Name: instances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: registration_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY registration_codes
    ADD CONSTRAINT registration_codes_pkey PRIMARY KEY (code);


--
-- Name: things_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY things
    ADD CONSTRAINT things_pkey PRIMARY KEY (id);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_username_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: instance_users_instance_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX instance_users_instance_id_index ON instance_users USING btree (instance_id);


--
-- Name: created_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER created_at BEFORE INSERT OR UPDATE ON instances FOR EACH ROW EXECUTE PROCEDURE instances_created_at();


--
-- Name: created_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER created_at BEFORE INSERT OR UPDATE ON users FOR EACH ROW EXECUTE PROCEDURE users_created_at();


--
-- Name: created_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER created_at BEFORE INSERT OR UPDATE ON registration_codes FOR EACH ROW EXECUTE PROCEDURE registration_codes_created_at();


--
-- Name: created_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER created_at BEFORE INSERT OR UPDATE ON instance_users FOR EACH ROW EXECUTE PROCEDURE instance_users_created_at();


--
-- Name: updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER updated_at BEFORE INSERT OR UPDATE ON instances FOR EACH ROW EXECUTE PROCEDURE instances_updated_at();


--
-- Name: instance_users_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY instance_users
    ADD CONSTRAINT instance_users_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES users(id);


--
-- Name: instance_users_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY instance_users
    ADD CONSTRAINT instance_users_instance_id_fkey FOREIGN KEY (instance_id) REFERENCES instances(id);


--
-- Name: instance_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY instance_users
    ADD CONSTRAINT instance_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: instances_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY instances
    ADD CONSTRAINT instances_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: registration_codes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY registration_codes
    ADD CONSTRAINT registration_codes_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_info VALUES (12);