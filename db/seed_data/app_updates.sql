SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: kannan
--

INSERT INTO app_updates (id, appname, created_at, path, version_number) VALUES (1, 'Billing', '2014-04-01 18:11:08.358732', '/snap_builds/1.0/SnapBilling.apk', '1.0');
INSERT INTO app_updates (id, appname, created_at, path, version_number) VALUES (2, 'Stock', '2014-04-01 18:11:08.358732', '/snap_builds/1.0/SnapInventory.apk', '1.0');

--
-- Name: brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kannan
--

SELECT pg_catalog.setval('brands_id_seq', 1207, true);


--
-- PostgreSQL database dump complete
--

