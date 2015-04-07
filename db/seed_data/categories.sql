--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: kannan
--

INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (1, 'PERSONAL CARE', NULL, '2014-04-14 19:06:54.269044', '2014-04-14 19:06:54.269044');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (2, 'CREAMSLOTIONS', 1, '2014-04-14 19:06:54.272669', '2014-04-14 19:06:54.272669');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (3, 'PACKAGED FOODS', NULL, '2014-04-14 19:06:54.298124', '2014-04-14 19:06:54.298124');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (4, 'CHOCOLATE CONFECTIONARIES', 3, '2014-04-14 19:06:54.299913', '2014-04-14 19:06:54.299913');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (5, 'DEODARANTS', 1, '2014-04-14 19:06:54.329441', '2014-04-14 19:06:54.329441');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (6, 'FACE CARE', 1, '2014-04-14 19:06:54.486997', '2014-04-14 19:06:54.486997');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (7, 'FACE WASH', 1, '2014-04-14 19:06:54.49548', '2014-04-14 19:06:54.49548');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (8, 'SAUCESJAMS SPREADS', 3, '2014-04-14 19:06:54.790584', '2014-04-14 19:06:54.790584');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (9, 'TALCUM POWDER', 1, '2014-04-14 19:06:54.871973', '2014-04-14 19:06:54.871973');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (10, 'HOME CARE', NULL, '2014-04-14 19:06:54.880953', '2014-04-14 19:06:54.880953');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (11, 'OTC - PAIN RELIEF', 10, '2014-04-14 19:06:54.882796', '2014-04-14 19:06:54.882796');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (12, 'BEVERAGES', NULL, '2014-04-14 19:06:54.901351', '2014-04-14 19:06:54.901351');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (13, 'SOFT DRINKS', 12, '2014-04-14 19:06:54.903353', '2014-04-14 19:06:54.903353');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (14, 'COFFEE', 12, '2014-04-14 19:06:54.9209', '2014-04-14 19:06:54.9209');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (15, 'HAIR OIL', 1, '2014-04-14 19:06:55.049556', '2014-04-14 19:06:55.049556');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (16, 'SHAMPOO', 1, '2014-04-14 19:06:55.127662', '2014-04-14 19:06:55.127662');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (17, 'SOUPS', 3, '2014-04-14 19:06:55.227737', '2014-04-14 19:06:55.227737');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (18, 'ORAL CARE', NULL, '2014-04-14 19:06:55.387833', '2014-04-14 19:06:55.387833');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (19, 'TOOTH PASTE GELS', 18, '2014-04-14 19:06:55.390143', '2014-04-14 19:06:55.390143');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (20, 'STAPLES', NULL, '2014-04-14 19:06:55.588689', '2014-04-14 19:06:55.588689');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (21, 'MASALAS', 20, '2014-04-14 19:06:55.590967', '2014-04-14 19:06:55.590967');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (22, 'RAW SPICES', 20, '2014-04-14 19:06:55.61661', '2014-04-14 19:06:55.61661');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (23, 'HOUSEHOLD AIDS', 10, '2014-04-14 19:06:55.627748', '2014-04-14 19:06:55.627748');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (24, 'COOKING OILS', 20, '2014-04-14 19:06:55.645765', '2014-04-14 19:06:55.645765');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (25, 'SNACKS', 3, '2014-04-14 19:06:55.696481', '2014-04-14 19:06:55.696481');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (26, 'PICKLES', 3, '2014-04-14 19:06:55.727529', '2014-04-14 19:06:55.727529');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (27, 'BUTTERGHEE ETC', 20, '2014-04-14 19:06:55.763063', '2014-04-14 19:06:55.763063');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (28, 'DAIRY FROZEN', NULL, '2014-04-14 19:06:55.771643', '2014-04-14 19:06:55.771643');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (29, 'ICE CREAM', 28, '2014-04-14 19:06:55.773951', '2014-04-14 19:06:55.773951');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (30, 'OTHER DRINKS', 12, '2014-04-14 19:06:55.790184', '2014-04-14 19:06:55.790184');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (31, 'BAR SOAPS', 1, '2014-04-14 19:06:55.821264', '2014-04-14 19:06:55.821264');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (32, 'TOILET CLEANERS', 10, '2014-04-14 19:06:55.858885', '2014-04-14 19:06:55.858885');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (33, 'TOOTH BRUSH', 18, '2014-04-14 19:06:55.867944', '2014-04-14 19:06:55.867944');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (34, 'LIQUID SOAPS', 1, '2014-04-14 19:06:55.925395', '2014-04-14 19:06:55.925395');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (35, 'DEPILATORY AIDS', 1, '2014-04-14 19:06:55.941449', '2014-04-14 19:06:55.941449');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (36, 'ELECTRICALS', 10, '2014-04-14 19:06:55.951672', '2014-04-14 19:06:55.951672');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (37, 'FABRIC SOFTENER/LIQUID WASJ', 10, '2014-04-14 19:06:55.992625', '2014-04-14 19:06:55.992625');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (38, 'WASHING BARS', 10, '2014-04-14 19:06:56.000983', '2014-04-14 19:06:56.000983');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (39, 'SANITARY PADS', 1, '2014-04-14 19:06:56.008308', '2014-04-14 19:06:56.008308');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (40, 'WASHING POWDERS', 10, '2014-04-14 19:06:56.032271', '2014-04-14 19:06:56.032271');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (41, 'HAIR COLOURS', 1, '2014-04-14 19:06:56.087853', '2014-04-14 19:06:56.087853');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (42, 'CONDITIONERS', 1, '2014-04-14 19:06:56.097851', '2014-04-14 19:06:56.097851');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (43, 'JUICESCONCENTRATES', 12, '2014-04-14 19:06:56.120734', '2014-04-14 19:06:56.120734');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (44, 'NOODLES PASTAVERMICILLI', 3, '2014-04-14 19:06:56.137854', '2014-04-14 19:06:56.137854');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (45, 'AIR FRESHNERS', 10, '2014-04-14 19:06:56.154469', '2014-04-14 19:06:56.154469');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (46, 'WATER', 12, '2014-04-14 19:06:56.195624', '2014-04-14 19:06:56.195624');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (47, 'READY TO COOK INSTANT MIXES', 3, '2014-04-14 19:06:56.24844', '2014-04-14 19:06:56.24844');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (48, 'BABY PRODUCTS - DIAPERS', 1, '2014-04-14 19:06:56.324849', '2014-04-14 19:06:56.324849');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (49, 'DAIRY PRODUCTS', 28, '2014-04-14 19:06:56.375262', '2014-04-14 19:06:56.375262');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (50, 'DESSERTS', 3, '2014-04-14 19:06:56.384218', '2014-04-14 19:06:56.384218');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (51, 'SALT SUGAR', 20, '2014-04-14 19:06:56.407485', '2014-04-14 19:06:56.407485');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (52, 'FLOOR AND SURFACE CLEANERS', 10, '2014-04-14 19:06:56.417373', '2014-04-14 19:06:56.417373');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (53, 'BISCUITS', 3, '2014-04-14 19:06:56.43398', '2014-04-14 19:06:56.43398');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (54, 'STATIONERY', 10, '2014-04-14 19:06:56.442756', '2014-04-14 19:06:56.442756');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (55, 'AGARBATTI OTHER POOJA ITEMS', 10, '2014-04-14 19:06:56.497654', '2014-04-14 19:06:56.497654');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (56, 'MALE GROOMING - BLADESCATRIDGES', 1, '2014-04-14 19:06:56.521605', '2014-04-14 19:06:56.521605');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (57, 'REPELLANTS - MOSQUITEINSECT', 10, '2014-04-14 19:06:56.751198', '2014-04-14 19:06:56.751198');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (58, 'WHEAT', 20, '2014-04-14 19:06:56.826587', '2014-04-14 19:06:56.826587');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (59, 'MENS NEEDS', 1, '2014-04-14 19:06:56.885493', '2014-04-14 19:06:56.885493');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (60, 'FROZEN PRODUCTS', 28, '2014-04-14 19:06:57.215861', '2014-04-14 19:06:57.215861');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (61, 'BAKING/DESSERT PREP', 3, '2014-04-14 19:06:57.321087', '2014-04-14 19:06:57.321087');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (62, 'DAL PULSES', 20, '2014-04-14 19:06:57.392176', '2014-04-14 19:06:57.392176');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (63, 'OTC OTHERS', 10, '2014-04-14 19:06:57.599445', '2014-04-14 19:06:57.599445');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (64, 'CEREAL/BREAKFAST MIXES', 3, '2014-04-14 19:06:57.795878', '2014-04-14 19:06:57.795878');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (65, 'BREAD BAKERY', 3, '2014-04-14 19:06:57.822403', '2014-04-14 19:06:57.822403');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (66, 'FLOURS SOOJI', 20, '2014-04-14 19:06:57.985501', '2014-04-14 19:06:57.985501');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (67, 'FOOD COLOURSESSENCES', 3, '2014-04-14 19:06:58.09684', '2014-04-14 19:06:58.09684');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (68, 'DRY FRUITS', 20, '2014-04-14 19:06:58.173675', '2014-04-14 19:06:58.173675');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (69, 'RICE', 20, '2014-04-14 19:06:58.363375', '2014-04-14 19:06:58.363375');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (70, 'CANNED FOODS', 3, '2014-04-14 19:06:58.460875', '2014-04-14 19:06:58.460875');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (71, 'TEA', 12, '2014-04-14 19:06:59.144467', '2014-04-14 19:06:59.144467');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (72, 'READY TO EAT', 3, '2014-04-14 19:06:59.54041', '2014-04-14 19:06:59.54041');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (73, 'HEALTH DRINKS', 12, '2014-04-14 19:07:00.17102', '2014-04-14 19:07:00.17102');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (74, 'BABY PRODUCTS - OTHERS', 1, '2014-04-14 19:07:00.389116', '2014-04-14 19:07:00.389116');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (75, 'FRUITS VEGETABLES', 20, '2014-04-14 19:07:00.483386', '2014-04-14 19:07:00.483386');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (76, 'OTHERS', NULL, '2014-04-14 19:07:00.817122', '2014-04-14 19:07:00.817122');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (77, 'MOBILE RECHARGE', 76, '2014-04-14 19:07:00.8193', '2014-04-14 19:07:00.8193');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (78, 'MALE GROOMING - AFTER SHAVE', 1, '2014-04-14 19:07:01.105055', '2014-04-14 19:07:01.105055');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (79, 'MALE GROOMING - SHAVING CREAM/LOTIONS/GEL', 1, '2014-04-14 19:07:01.743826', '2014-04-14 19:07:01.743826');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (80, 'COLOUR COSMETICS', 1, '2014-04-14 19:07:04.343875', '2014-04-14 19:07:04.343875');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (81, 'UTENSIL AND KITCHEN CLEANERS', 10, '2014-04-14 19:07:07.151855', '2014-04-14 19:07:07.151855');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (82, 'MOUTH WASH', 18, '2014-04-14 19:07:07.33945', '2014-04-14 19:07:07.33945');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (83, 'PERFUME', 1, '2014-04-14 19:07:09.076502', '2014-04-14 19:07:09.076502');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (84, 'CIGARATTES ALCOHOL', NULL, '2014-04-14 19:07:11.732195', '2014-04-14 19:07:11.732195');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (85, 'WINE', 84, '2014-04-14 19:07:11.734806', '2014-04-14 19:07:11.734806');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (86, 'CLEANING ACCESORIES', 10, '2014-04-14 19:07:28.411218', '2014-04-14 19:07:28.411218');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (87, 'HEALTH DRINK', 12, '2014-04-14 19:07:31.621791', '2014-04-14 19:07:31.621791');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (88, 'BABY FOODS', 3, '2014-04-14 19:08:10.197532', '2014-04-14 19:08:10.197532');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (89, 'MASSAGE OIL', 1, '2014-04-14 19:08:21.635376', '2014-04-14 19:08:21.635376');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (90, 'SKIN CAREBODY LOTION', 1, '2014-04-14 19:08:22.22864', '2014-04-14 19:08:22.22864');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (91, 'TOOTH POWDER', 18, '2014-04-14 19:08:25.609779', '2014-04-14 19:08:25.609779');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (92, 'OTC - PAIN RELIEF', 1, '2014-04-14 19:08:28.387304', '2014-04-14 19:08:28.387304');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (93, 'CIGARATTES', 84, '2014-04-14 19:09:11.113729', '2014-04-14 19:09:11.113729');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (94, 'WET FLOUR', 28, '2014-04-14 19:09:27.067649', '2014-04-14 19:09:27.067649');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (95, 'GRAINS', 20, '2014-04-14 19:09:32.29513', '2014-04-14 19:09:32.29513');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (96, 'FROZEN FOODS', 28, '2014-04-14 19:09:34.194926', '2014-04-14 19:09:34.194926');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (97, 'BREAD BAKERY', 20, '2014-04-14 19:10:13.813254', '2014-04-14 19:10:13.813254');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (98, 'CLEANING ACCESSORIES', 20, '2014-04-14 19:10:13.848262', '2014-04-14 19:10:13.848262');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (99, 'DAIRY PRODUCTS', 20, '2014-04-14 19:10:13.889823', '2014-04-14 19:10:13.889823');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (100, 'DALS PULSES', 20, '2014-04-14 19:10:13.993766', '2014-04-14 19:10:13.993766');
INSERT INTO categories (id, name, parent_id, created_at, updated_at) VALUES (101, 'RICE RICE PRODUCTS', 20, '2014-04-14 19:10:14.587049', '2014-04-14 19:10:14.587049');


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kannan
--

SELECT pg_catalog.setval('categories_id_seq', 101, true);


--
-- PostgreSQL database dump complete
--

