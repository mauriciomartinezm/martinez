--
-- PostgreSQL database dump
--

\restrict 597NGHHkpGNFbzgCh3Cna6E4AvR4ezSKy7PRlyfH5sLmwXdUWiffYXjncRsuMsW

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.0

-- Started on 2026-01-19 14:33:42

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.pago_mensual DROP CONSTRAINT IF EXISTS fk_pago_contrato;
ALTER TABLE IF EXISTS ONLY public.contrato_arriendo DROP CONSTRAINT IF EXISTS fk_contrato_arrendatario;
ALTER TABLE IF EXISTS ONLY public.contrato_arriendo DROP CONSTRAINT IF EXISTS fk_contrato_apartamento;
ALTER TABLE IF EXISTS ONLY public.apartamento DROP CONSTRAINT IF EXISTS fk_apartamento_edificio;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_username_key;
ALTER TABLE IF EXISTS ONLY public.usuario DROP CONSTRAINT IF EXISTS usuario_pkey;
ALTER TABLE IF EXISTS ONLY public.pago_mensual DROP CONSTRAINT IF EXISTS uk_pago_mes;
ALTER TABLE IF EXISTS ONLY public.pago_mensual DROP CONSTRAINT IF EXISTS pago_mensual_pkey;
ALTER TABLE IF EXISTS ONLY public.edificio DROP CONSTRAINT IF EXISTS edificio_pkey;
ALTER TABLE IF EXISTS ONLY public.contrato_arriendo DROP CONSTRAINT IF EXISTS contrato_arriendo_pkey;
ALTER TABLE IF EXISTS ONLY public.arrendatario DROP CONSTRAINT IF EXISTS arrendatario_pkey;
ALTER TABLE IF EXISTS ONLY public.apartamento DROP CONSTRAINT IF EXISTS apartamento_pkey;
DROP TABLE IF EXISTS public.usuario;
DROP TABLE IF EXISTS public.pago_mensual;
DROP TABLE IF EXISTS public.edificio;
DROP TABLE IF EXISTS public.contrato_arriendo;
DROP TABLE IF EXISTS public.arrendatario;
DROP TABLE IF EXISTS public.apartamento;
DROP EXTENSION IF EXISTS "uuid-ossp";
--
-- TOC entry 2 (class 3079 OID 16389)
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 222 (class 1259 OID 16451)
-- Name: apartamento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.apartamento (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    edificio_id uuid NOT NULL,
    piso character varying(20),
    activa boolean DEFAULT true
);


--
-- TOC entry 223 (class 1259 OID 16465)
-- Name: arrendatario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.arrendatario (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    nombre character varying(150) NOT NULL,
    telefono character varying(30),
    correo character varying(150)
);


--
-- TOC entry 224 (class 1259 OID 16473)
-- Name: contrato_arriendo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contrato_arriendo (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    apartamento_id uuid NOT NULL,
    arrendatario_id uuid NOT NULL,
    fecha_inicio date NOT NULL,
    fecha_fin date,
    activo boolean DEFAULT true
);


--
-- TOC entry 221 (class 1259 OID 16442)
-- Name: edificio; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.edificio (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    nombre character varying(150) NOT NULL,
    direccion character varying(255) NOT NULL
);


--
-- TOC entry 225 (class 1259 OID 16536)
-- Name: pago_mensual; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pago_mensual (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    contrato_arriendo_id uuid NOT NULL,
    tipo character varying(20) NOT NULL,
    mes character varying(20) NOT NULL,
    anio character varying(20) NOT NULL,
    valor_arriendo numeric(12,2) NOT NULL,
    cuota_administracion numeric(12,2) NOT NULL,
    fondo_inmueble numeric(12,2),
    total_neto numeric(12,2) NOT NULL,
    fecha_pago date
);


--
-- TOC entry 220 (class 1259 OID 16431)
-- Name: usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usuario (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(255) NOT NULL
);


--
-- TOC entry 5063 (class 0 OID 16451)
-- Dependencies: 222
-- Data for Name: apartamento; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.apartamento VALUES ('f2d75794-fadf-4599-97a3-140dabad8511', 'f709fb48-fb72-40ed-89af-1a11e4e3cac5', '2', true);
INSERT INTO public.apartamento VALUES ('f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f709fb48-fb72-40ed-89af-1a11e4e3cac5', '3', true);
INSERT INTO public.apartamento VALUES ('4e73c4a8-7583-43e9-b846-596410f9cb05', '848fd967-3ba9-42c6-9160-f366e518bab1', '1', true);
INSERT INTO public.apartamento VALUES ('e25c9827-2fbd-4716-bbab-ebd888d5597b', '848fd967-3ba9-42c6-9160-f366e518bab1', '2', true);
INSERT INTO public.apartamento VALUES ('bb4e81f1-c95c-4cd2-aa67-3eb2aa7b6800', '848fd967-3ba9-42c6-9160-f366e518bab1', '3', true);
INSERT INTO public.apartamento VALUES ('b00bc0d7-a2ca-4f34-8f54-acd0fdf6ca49', '861d9d58-48e6-440b-a335-08e8ae4ee50e', '1', true);
INSERT INTO public.apartamento VALUES ('3d5b6b39-5f1e-4ca4-addb-256048e1b643', '861d9d58-48e6-440b-a335-08e8ae4ee50e', '2', true);
INSERT INTO public.apartamento VALUES ('6926f374-59ca-4ce4-96cb-d2cf9d120833', '861d9d58-48e6-440b-a335-08e8ae4ee50e', '3', true);
INSERT INTO public.apartamento VALUES ('abbc7da7-d0a7-4d39-9e2a-838316ee6359', '861d9d58-48e6-440b-a335-08e8ae4ee50e', '4', true);
INSERT INTO public.apartamento VALUES ('052e5614-86d7-487a-acf6-bb6b0b7a62d9', '9a4bf847-353d-43f7-b2e7-91afb4c54797', '1', true);
INSERT INTO public.apartamento VALUES ('bc8e8245-e212-4187-b290-c88e9580746e', '9a4bf847-353d-43f7-b2e7-91afb4c54797', '2', true);
INSERT INTO public.apartamento VALUES ('9d29130f-4be0-4405-a313-464f687ef78f', '9a4bf847-353d-43f7-b2e7-91afb4c54797', '3', true);
INSERT INTO public.apartamento VALUES ('9458433e-82fe-4269-9562-a5fbb98a81b3', '9a4bf847-353d-43f7-b2e7-91afb4c54797', '4', true);
INSERT INTO public.apartamento VALUES ('31db49ff-19dd-4296-bbfd-ab522a330dbd', 'f709fb48-fb72-40ed-89af-1a11e4e3cac5', '1', true);


--
-- TOC entry 5064 (class 0 OID 16465)
-- Dependencies: 223
-- Data for Name: arrendatario; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.arrendatario VALUES ('88644c09-b932-4abd-af1c-43c990cd077e', 'Orlenys', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('aae6134e-f4d2-43d1-9590-0e2486b8c358', 'Daniel', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('9b571c15-e540-4b04-97b7-7cc718e9adbf', 'Angelica', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('bea3a15c-5d1d-4119-bc8f-fe16ceea2ec1', 'Daniela', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('b90ca589-eedb-4b8c-ac56-39b55d682a6c', 'Victor', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('408b5bab-8439-46c0-8bf9-3aa90a8bea8e', 'Ana', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('bc9b4875-6f01-45f4-beb4-24c805250c0a', 'Jaiver', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('85e5531a-bedf-4991-a76f-be3278d894f5', 'Bleikes', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('f27e868d-b05c-4894-bc83-812b173c80ed', 'Gustavo', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('be76d1e1-ae9c-42c2-a730-5a022d9578a8', 'Yelisa', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('773626b4-f895-4b2f-8a0b-1f8c8188e878', 'Melisa', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('2322a96b-ee14-456e-8819-7bf88ef498cf', 'Evelyn', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('3e62e286-c9ba-44c7-968a-a6b0ab93c232', 'Carlos Rios', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('f7aeeb23-e9cc-4d87-b2cc-f0079fddef62', 'Yadeisy', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('3b4510b1-461f-4434-8d4d-9aa402421119', 'Luz', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('3f565d54-0d0a-48a7-b2d2-c808c4cec2bd', 'Juan Olmos', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('fb29b33a-508f-4ffa-860c-a8af5ee6ffd8', 'Henry', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('3beb2cda-45b6-4575-b893-a493ee3a1650', 'Yuranis', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('88b14b34-c298-45eb-b77a-11dd14b22a99', 'Liliana', NULL, NULL);
INSERT INTO public.arrendatario VALUES ('0c568d56-3142-44e6-a07c-543ee133c9ad', 'Johana', NULL, NULL);


--
-- TOC entry 5065 (class 0 OID 16473)
-- Dependencies: 224
-- Data for Name: contrato_arriendo; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.contrato_arriendo VALUES ('4c98583b-658d-4d2e-816a-705f956fba8d', '4e73c4a8-7583-43e9-b846-596410f9cb05', '88b14b34-c298-45eb-b77a-11dd14b22a99', '2026-01-11', '2026-07-11', true);
INSERT INTO public.contrato_arriendo VALUES ('4d99141d-777f-42b8-9171-236b233bb4bf', 'e25c9827-2fbd-4716-bbab-ebd888d5597b', 'bea3a15c-5d1d-4119-bc8f-fe16ceea2ec1', '2025-12-06', '2026-06-06', true);
INSERT INTO public.contrato_arriendo VALUES ('7366f152-e5d2-44a3-8beb-4d85e5905cbc', '6926f374-59ca-4ce4-96cb-d2cf9d120833', '88644c09-b932-4abd-af1c-43c990cd077e', '2025-11-21', '2026-05-21', true);
INSERT INTO public.contrato_arriendo VALUES ('cac5cc64-81f9-466e-94ec-47be649d3deb', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2025-11-09', '2026-05-09', true);
INSERT INTO public.contrato_arriendo VALUES ('40f08409-f7a6-467c-8e53-1f5a9a143a9f', '052e5614-86d7-487a-acf6-bb6b0b7a62d9', 'fb29b33a-508f-4ffa-860c-a8af5ee6ffd8', '2025-11-02', '2026-05-02', true);
INSERT INTO public.contrato_arriendo VALUES ('e39b3e8a-33b6-49ac-8fe8-f4ed22ad8b90', 'f2d75794-fadf-4599-97a3-140dabad8511', '3b4510b1-461f-4434-8d4d-9aa402421119', '2025-10-12', '2026-04-12', true);
INSERT INTO public.contrato_arriendo VALUES ('2aaff763-f744-410b-9718-249c5a655998', '9d29130f-4be0-4405-a313-464f687ef78f', '2322a96b-ee14-456e-8819-7bf88ef498cf', '2025-09-30', '2026-03-30', true);
INSERT INTO public.contrato_arriendo VALUES ('2eb39786-09e7-4dd1-ae3f-137c5bc86751', 'bb4e81f1-c95c-4cd2-aa67-3eb2aa7b6800', '773626b4-f895-4b2f-8a0b-1f8c8188e878', '2025-09-25', '2026-03-25', true);
INSERT INTO public.contrato_arriendo VALUES ('3dcc043e-cebd-4562-843a-73004bc5a5fb', '31db49ff-19dd-4296-bbfd-ab522a330dbd', '408b5bab-8439-46c0-8bf9-3aa90a8bea8e', '2025-09-21', '2026-03-21', true);
INSERT INTO public.contrato_arriendo VALUES ('1138e6b0-3b54-4f90-9461-f8f76393e615', '9458433e-82fe-4269-9562-a5fbb98a81b3', 'aae6134e-f4d2-43d1-9590-0e2486b8c358', '2025-09-04', '2026-03-04', true);
INSERT INTO public.contrato_arriendo VALUES ('b934fcd1-5390-4b7c-b3bc-4a642a1d7f9e', 'abbc7da7-d0a7-4d39-9e2a-838316ee6359', 'bc9b4875-6f01-45f4-beb4-24c805250c0a', '2025-08-22', '2026-02-22', true);
INSERT INTO public.contrato_arriendo VALUES ('02c61008-4e84-43c2-88b5-08e054eb6049', 'b00bc0d7-a2ca-4f34-8f54-acd0fdf6ca49', 'be76d1e1-ae9c-42c2-a730-5a022d9578a8', '2025-08-15', '2026-02-15', true);
INSERT INTO public.contrato_arriendo VALUES ('359216a7-8ba9-4e24-8cac-7dc225c9d6e1', '3d5b6b39-5f1e-4ca4-addb-256048e1b643', '85e5531a-bedf-4991-a76f-be3278d894f5', '2025-07-29', '2026-01-29', true);
INSERT INTO public.contrato_arriendo VALUES ('10959edc-7e2c-4e4e-b5ee-d6bdac93ae9e', 'bc8e8245-e212-4187-b290-c88e9580746e', 'f7aeeb23-e9cc-4d87-b2cc-f0079fddef62', '2025-07-29', '2026-01-29', true);
INSERT INTO public.contrato_arriendo VALUES ('1f5eb474-0cc5-4f59-bde6-8b6fb39d4b29', '4e73c4a8-7583-43e9-b846-596410f9cb05', '88b14b34-c298-45eb-b77a-11dd14b22a99', '2025-07-11', '2026-01-11', false);
INSERT INTO public.contrato_arriendo VALUES ('3222d3e6-2b5b-4103-bc55-29e39c33ca84', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2025-05-09', '2025-11-09', false);
INSERT INTO public.contrato_arriendo VALUES ('01fb67ad-1898-47db-a814-5a658a723a89', '052e5614-86d7-487a-acf6-bb6b0b7a62d9', 'fb29b33a-508f-4ffa-860c-a8af5ee6ffd8', '2025-05-02', '2025-11-02', false);
INSERT INTO public.contrato_arriendo VALUES ('0d8d157d-f9ab-4cd6-ac8a-7ed1a74a6746', 'f2d75794-fadf-4599-97a3-140dabad8511', '3b4510b1-461f-4434-8d4d-9aa402421119', '2025-04-12', '2025-10-12', false);
INSERT INTO public.contrato_arriendo VALUES ('652336e7-90e6-4346-a1db-9c99b994afe6', 'bb4e81f1-c95c-4cd2-aa67-3eb2aa7b6800', '773626b4-f895-4b2f-8a0b-1f8c8188e878', '2025-03-25', '2025-09-25', false);
INSERT INTO public.contrato_arriendo VALUES ('0f257e4c-3331-4e0e-869e-42c5a332a2a1', '31db49ff-19dd-4296-bbfd-ab522a330dbd', '408b5bab-8439-46c0-8bf9-3aa90a8bea8e', '2025-03-21', '2025-09-21', false);
INSERT INTO public.contrato_arriendo VALUES ('8dc982a8-8e30-4eb7-905c-fb55c4175ca4', '9458433e-82fe-4269-9562-a5fbb98a81b3', 'aae6134e-f4d2-43d1-9590-0e2486b8c358', '2025-03-04', '2025-09-04', false);
INSERT INTO public.contrato_arriendo VALUES ('ec860adc-defd-41d8-a89b-21d87b7ea128', '6926f374-59ca-4ce4-96cb-d2cf9d120833', '9b571c15-e540-4b04-97b7-7cc718e9adbf', '2024-11-08', '2025-05-08', false);
INSERT INTO public.contrato_arriendo VALUES ('4768bece-ab83-433d-8e6e-3a9988dd03b1', '9d29130f-4be0-4405-a313-464f687ef78f', '3e62e286-c9ba-44c7-968a-a6b0ab93c232', '2024-08-01', '2025-02-01', false);
INSERT INTO public.contrato_arriendo VALUES ('165e1685-0b5f-46a9-8720-08682265922b', 'abbc7da7-d0a7-4d39-9e2a-838316ee6359', '3beb2cda-45b6-4575-b893-a493ee3a1650', '2024-06-19', '2024-12-19', false);
INSERT INTO public.contrato_arriendo VALUES ('e5026bf5-3439-43f5-a430-a6f452320778', 'b00bc0d7-a2ca-4f34-8f54-acd0fdf6ca49', '3f565d54-0d0a-48a7-b2d2-c808c4cec2bd', '2024-02-08', '2024-08-08', false);
INSERT INTO public.contrato_arriendo VALUES ('902883b7-2b53-41f8-9d1f-dae6135b4eb7', 'e25c9827-2fbd-4716-bbab-ebd888d5597b', 'b90ca589-eedb-4b8c-ac56-39b55d682a6c', '2023-11-15', '2024-05-15', false);
INSERT INTO public.contrato_arriendo VALUES ('6f8a6954-01b7-406a-a093-a2cdaaa92486', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2019-05-09', '2019-11-09', false);
INSERT INTO public.contrato_arriendo VALUES ('c40dcd0a-2212-45b3-b5d4-2aac8818bdf9', '31db49ff-19dd-4296-bbfd-ab522a330dbd', '408b5bab-8439-46c0-8bf9-3aa90a8bea8e', '2024-09-10', '2025-03-10', false);
INSERT INTO public.contrato_arriendo VALUES ('5c552dcf-ebef-4bfe-aee2-c4a6981c0f3a', '3d5b6b39-5f1e-4ca4-addb-256048e1b643', '85e5531a-bedf-4991-a76f-be3278d894f5', '2024-07-29', '2025-01-29', false);
INSERT INTO public.contrato_arriendo VALUES ('4665eec5-beab-4ad7-94aa-2367bd5ad522', '3d5b6b39-5f1e-4ca4-addb-256048e1b643', '85e5531a-bedf-4991-a76f-be3278d894f5', '2024-01-29', '2024-07-29', false);
INSERT INTO public.contrato_arriendo VALUES ('f60b893f-8aac-444a-b58c-711ee16b899d', '3d5b6b39-5f1e-4ca4-addb-256048e1b643', '85e5531a-bedf-4991-a76f-be3278d894f5', '2023-07-29', '2024-01-29', false);
INSERT INTO public.contrato_arriendo VALUES ('e6519542-cc79-4b71-bb1a-dedae13cc106', '9458433e-82fe-4269-9562-a5fbb98a81b3', 'aae6134e-f4d2-43d1-9590-0e2486b8c358', '2024-09-04', '2025-03-04', false);
INSERT INTO public.contrato_arriendo VALUES ('8e4d74fa-ec72-4872-a04b-81c46e2fbd96', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2024-05-09', '2024-11-09', false);
INSERT INTO public.contrato_arriendo VALUES ('ad170f28-d2f4-44b9-8d89-c741ab0358f7', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2023-11-09', '2024-05-09', false);
INSERT INTO public.contrato_arriendo VALUES ('02bc2bed-c436-414b-bec4-87348717f99f', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2023-05-09', '2023-11-09', false);
INSERT INTO public.contrato_arriendo VALUES ('d3d28afd-5f91-4852-8fec-fcfccbfe2f88', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2022-11-09', '2023-05-09', false);
INSERT INTO public.contrato_arriendo VALUES ('e75eaa65-dcd7-495b-9963-21e4793b7d6b', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2022-05-09', '2022-11-09', false);
INSERT INTO public.contrato_arriendo VALUES ('63486b31-652f-4bf6-9624-2dded95ee588', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2021-11-09', '2022-05-09', false);
INSERT INTO public.contrato_arriendo VALUES ('4a750489-eb15-410f-bb3c-6eb9865520f7', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2021-05-09', '2021-11-09', false);
INSERT INTO public.contrato_arriendo VALUES ('0373883e-fcad-45c8-8bfa-d9a9fed06e62', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2020-11-09', '2021-05-09', false);
INSERT INTO public.contrato_arriendo VALUES ('30fd925e-19d9-44bd-8b5c-433df4f552c5', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2020-05-09', '2020-11-09', false);
INSERT INTO public.contrato_arriendo VALUES ('a015cb3c-59da-4d45-baab-1eb8c5a27b18', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2019-11-09', '2020-05-09', false);
INSERT INTO public.contrato_arriendo VALUES ('27310f4f-85e3-4b88-a729-7ac95dafed90', 'f82be940-f02e-4e2a-a0b1-9430bce822e8', 'f27e868d-b05c-4894-bc83-812b173c80ed', '2019-05-09', '2019-11-09', false);
INSERT INTO public.contrato_arriendo VALUES ('16fbb6a2-d237-4dd2-8a6d-7bd76aa8645c', '052e5614-86d7-487a-acf6-bb6b0b7a62d9', 'fb29b33a-508f-4ffa-860c-a8af5ee6ffd8', '2024-11-02', '2025-05-02', false);
INSERT INTO public.contrato_arriendo VALUES ('d8bf72da-b904-40a1-aaa6-6daa1b9ff004', '052e5614-86d7-487a-acf6-bb6b0b7a62d9', 'fb29b33a-508f-4ffa-860c-a8af5ee6ffd8', '2024-05-02', '2024-11-02', false);
INSERT INTO public.contrato_arriendo VALUES ('e09f74db-f923-4e51-8bce-340da723f0cc', 'f2d75794-fadf-4599-97a3-140dabad8511', '3b4510b1-461f-4434-8d4d-9aa402421119', '2024-10-12', '2025-04-12', false);
INSERT INTO public.contrato_arriendo VALUES ('f0fd51a6-8061-417f-ba26-419ba1697033', 'f2d75794-fadf-4599-97a3-140dabad8511', '3b4510b1-461f-4434-8d4d-9aa402421119', '2024-04-12', '2024-10-12', false);
INSERT INTO public.contrato_arriendo VALUES ('3c91b9e4-e30d-43c4-93ec-843b4e0debfe', 'bb4e81f1-c95c-4cd2-aa67-3eb2aa7b6800', '773626b4-f895-4b2f-8a0b-1f8c8188e878', '2024-09-25', '2025-03-25', false);
INSERT INTO public.contrato_arriendo VALUES ('9164c581-af94-48fd-8c20-5bddb475655f', 'bb4e81f1-c95c-4cd2-aa67-3eb2aa7b6800', '773626b4-f895-4b2f-8a0b-1f8c8188e878', '2024-03-25', '2024-09-25', false);
INSERT INTO public.contrato_arriendo VALUES ('edf21768-caed-40a0-991e-289107b07c58', 'bb4e81f1-c95c-4cd2-aa67-3eb2aa7b6800', '773626b4-f895-4b2f-8a0b-1f8c8188e878', '2023-09-25', '2024-03-25', false);
INSERT INTO public.contrato_arriendo VALUES ('1cd652ac-940f-4a69-a321-3f92483495db', 'bb4e81f1-c95c-4cd2-aa67-3eb2aa7b6800', '773626b4-f895-4b2f-8a0b-1f8c8188e878', '2023-03-25', '2023-09-25', false);
INSERT INTO public.contrato_arriendo VALUES ('10424221-9e53-4f28-aea8-3549e2e43b87', 'bc8e8245-e212-4187-b290-c88e9580746e', 'f7aeeb23-e9cc-4d87-b2cc-f0079fddef62', '2025-01-29', '2025-07-29', false);
INSERT INTO public.contrato_arriendo VALUES ('09012b19-863a-4906-b34b-a89dcba8626e', 'bc8e8245-e212-4187-b290-c88e9580746e', 'f7aeeb23-e9cc-4d87-b2cc-f0079fddef62', '2024-07-29', '2025-01-29', false);
INSERT INTO public.contrato_arriendo VALUES ('a453002a-364d-498e-9097-955db383620d', '4e73c4a8-7583-43e9-b846-596410f9cb05', '0c568d56-3142-44e6-a07c-543ee133c9ad', '2022-12-29', '2023-06-29', false);
INSERT INTO public.contrato_arriendo VALUES ('4c0d2b4b-0d3e-42de-af57-9305df4b2c02', '3d5b6b39-5f1e-4ca4-addb-256048e1b643', '85e5531a-bedf-4991-a76f-be3278d894f5', '2025-01-29', '2025-07-29', false);
INSERT INTO public.contrato_arriendo VALUES ('ae88cdb7-93b0-42cd-bda5-e4576643e9c7', '6926f374-59ca-4ce4-96cb-d2cf9d120833', '9b571c15-e540-4b04-97b7-7cc718e9adbf', '2025-05-08', '2025-11-08', false);
INSERT INTO public.contrato_arriendo VALUES ('bd3eeb6f-a14f-42cf-9deb-94f16f5eee70', '9d29130f-4be0-4405-a313-464f687ef78f', '3e62e286-c9ba-44c7-968a-a6b0ab93c232', '2025-02-01', '2025-08-01', false);
INSERT INTO public.contrato_arriendo VALUES ('606f9920-bca3-4057-9abe-f16ab4f7062b', '4e73c4a8-7583-43e9-b846-596410f9cb05', '0c568d56-3142-44e6-a07c-543ee133c9ad', '2023-06-29', '2023-12-29', false);
INSERT INTO public.contrato_arriendo VALUES ('fbb0f214-f25a-43ce-bf0b-afe741b4c27b', '4e73c4a8-7583-43e9-b846-596410f9cb05', '0c568d56-3142-44e6-a07c-543ee133c9ad', '2023-12-29', '2024-06-29', false);
INSERT INTO public.contrato_arriendo VALUES ('9ce44e27-d7b6-4887-a696-e74e8e7b2a28', '4e73c4a8-7583-43e9-b846-596410f9cb05', '0c568d56-3142-44e6-a07c-543ee133c9ad', '2024-06-29', '2024-12-29', false);
INSERT INTO public.contrato_arriendo VALUES ('1c9d267f-bb28-462a-9b6c-10633cc45e36', '4e73c4a8-7583-43e9-b846-596410f9cb05', '0c568d56-3142-44e6-a07c-543ee133c9ad', '2024-12-29', '2025-06-29', false);
INSERT INTO public.contrato_arriendo VALUES ('e919ee59-138a-4725-be6c-8f7c401f3312', 'b00bc0d7-a2ca-4f34-8f54-acd0fdf6ca49', '3f565d54-0d0a-48a7-b2d2-c808c4cec2bd', '2024-08-08', '2025-02-08', false);
INSERT INTO public.contrato_arriendo VALUES ('420d1c8b-349d-466e-9369-1ab30c465800', 'b00bc0d7-a2ca-4f34-8f54-acd0fdf6ca49', '3f565d54-0d0a-48a7-b2d2-c808c4cec2bd', '2025-02-08', '2025-08-08', false);
INSERT INTO public.contrato_arriendo VALUES ('2735a74a-eaef-47c1-b2f0-822480f10700', 'e25c9827-2fbd-4716-bbab-ebd888d5597b', 'b90ca589-eedb-4b8c-ac56-39b55d682a6c', '2024-05-15', '2024-11-15', false);
INSERT INTO public.contrato_arriendo VALUES ('9d4e93ec-8103-4ec7-94d4-480e0647a578', 'e25c9827-2fbd-4716-bbab-ebd888d5597b', 'b90ca589-eedb-4b8c-ac56-39b55d682a6c', '2024-11-15', '2025-05-15', false);
INSERT INTO public.contrato_arriendo VALUES ('e725ef85-824a-4f9c-b7c6-445df4612ef0', 'e25c9827-2fbd-4716-bbab-ebd888d5597b', 'b90ca589-eedb-4b8c-ac56-39b55d682a6c', '2025-05-15', '2025-11-15', false);
INSERT INTO public.contrato_arriendo VALUES ('f2b5f4e7-1f87-4e12-8e0e-4963e89c092a', 'abbc7da7-d0a7-4d39-9e2a-838316ee6359', '3beb2cda-45b6-4575-b893-a493ee3a1650', '2024-12-19', '2025-06-19', false);


--
-- TOC entry 5062 (class 0 OID 16442)
-- Dependencies: 221
-- Data for Name: edificio; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.edificio VALUES ('f709fb48-fb72-40ed-89af-1a11e4e3cac5', 'Edificio 1 Gaitán', 'gaitán');
INSERT INTO public.edificio VALUES ('848fd967-3ba9-42c6-9160-f366e518bab1', 'Edificio 2 Gaitán', 'gaitán');
INSERT INTO public.edificio VALUES ('861d9d58-48e6-440b-a335-08e8ae4ee50e', 'Edificio 3 Gaitán', 'gaitán');
INSERT INTO public.edificio VALUES ('9a4bf847-353d-43f7-b2e7-91afb4c54797', 'Edificio Manantial', 'Manantial');


--
-- TOC entry 5066 (class 0 OID 16536)
-- Dependencies: 225
-- Data for Name: pago_mensual; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.pago_mensual VALUES ('f6fefd25-f4a6-4114-9569-8f95b936fae1', 'c40dcd0a-2212-45b3-b5d4-2aac8818bdf9', 'ARRIENDO', 'Diciembre', '2024', 700000.00, 68000.00, 20000.00, 612000.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('0c358da8-b96f-4f37-875b-28acc4c98424', 'e09f74db-f923-4e51-8bce-340da723f0cc', 'ARRIENDO', 'Diciembre', '2024', 630000.00, 61000.00, 20000.00, 549000.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('a05cebc5-ed66-4647-b42d-17a1778de53a', '8e4d74fa-ec72-4872-a04b-81c46e2fbd96', 'ARRIENDO', 'Diciembre', '2024', 600000.00, 60000.00, 0.00, 540000.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('f814a89d-8bc1-40e4-b282-eedaf3fe59e8', '9ce44e27-d7b6-4887-a696-e74e8e7b2a28', 'ARRIENDO', 'Diciembre', '2024', 732100.00, 71210.00, 20000.00, 640890.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('2d618a66-440d-4d12-ab9a-9eb3adfa5ab7', '9d4e93ec-8103-4ec7-94d4-480e0647a578', 'ARRIENDO', 'Diciembre', '2024', 688000.00, 66800.00, 20000.00, 601200.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('67fa02f6-0b2d-4a3d-a278-45769ffc5b1c', '3c91b9e4-e30d-43c4-93ec-843b4e0debfe', 'ARRIENDO', 'Diciembre', '2024', 601000.00, 58000.00, 20000.00, 523000.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('cdbad0c2-c16a-4572-98ba-1bdb74569890', 'e919ee59-138a-4725-be6c-8f7c401f3312', 'ARRIENDO', 'Diciembre', '2024', 780000.00, 76000.00, 20000.00, 684000.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('ae181333-d027-4431-a4ba-432acb67cd8f', '5c552dcf-ebef-4bfe-aee2-c4a6981c0f3a', 'ARRIENDO', 'Diciembre', '2024', 764000.00, 74400.00, 20000.00, 669600.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('98096812-7273-4247-9334-900d96bda0d6', 'ec860adc-defd-41d8-a89b-21d87b7ea128', 'ARRIENDO', 'Diciembre', '2024', 700000.00, 68000.00, 20000.00, 612000.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('056d12ff-4378-401b-b1d6-6f7ce13d353c', '165e1685-0b5f-46a9-8720-08682265922b', 'ARRIENDO', 'Diciembre', '2024', 620000.00, 60000.00, 20000.00, 540000.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('a8adfbbc-df09-4c9e-83d7-e27ecbb1be68', '16fbb6a2-d237-4dd2-8a6d-7bd76aa8645c', 'ARRIENDO', 'Diciembre', '2024', 660000.00, 64000.00, 20000.00, 576000.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('0424bc10-a0e2-497b-8ebf-bea4765a81a0', '09012b19-863a-4906-b34b-a89dcba8626e', 'ARRIENDO', 'Diciembre', '2024', 670000.00, 65000.00, 20000.00, 585000.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('e1825a2f-77c9-4e03-9848-adddb9b9e54c', '4768bece-ab83-433d-8e6e-3a9988dd03b1', 'ARRIENDO', 'Diciembre', '2024', 650000.00, 63000.00, 20000.00, 567000.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('f4a59087-53d5-4541-9592-ff6a4cf4dd9a', 'e6519542-cc79-4b71-bb1a-dedae13cc106', 'ARRIENDO', 'Diciembre', '2024', 600000.00, 58000.00, 20000.00, 522000.00, '2025-01-10');
INSERT INTO public.pago_mensual VALUES ('00c96632-971e-4e72-91e8-24d727503a15', 'c40dcd0a-2212-45b3-b5d4-2aac8818bdf9', 'ARRIENDO', 'Enero', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('1d88b3ab-63bf-43e1-a276-7e7f233aec52', 'e09f74db-f923-4e51-8bce-340da723f0cc', 'ARRIENDO', 'Enero', '2025', 630000.00, 61000.00, 20000.00, 549000.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('356be47a-7011-4517-889c-20d74605207e', '8e4d74fa-ec72-4872-a04b-81c46e2fbd96', 'ARRIENDO', 'Enero', '2025', 600000.00, 60000.00, 0.00, 540000.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('af6bb1c5-0f48-40f0-b4b4-06c0e53b1a10', '1c9d267f-bb28-462a-9b6c-10633cc45e36', 'ARRIENDO', 'Enero', '2025', 732100.00, 71210.00, 20000.00, 640890.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('24da11e7-796a-4c42-8d81-4fd8a6a924a3', '9d4e93ec-8103-4ec7-94d4-480e0647a578', 'ARRIENDO', 'Enero', '2025', 688000.00, 66800.00, 20000.00, 601200.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('a7e9873a-253c-4212-a3f6-9253bc2d91fa', '3c91b9e4-e30d-43c4-93ec-843b4e0debfe', 'ARRIENDO', 'Enero', '2025', 601000.00, 58000.00, 20000.00, 523000.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('a9757633-542c-474a-b00c-0f744ba0d3b7', 'e919ee59-138a-4725-be6c-8f7c401f3312', 'ARRIENDO', 'Enero', '2025', 780000.00, 76000.00, 20000.00, 684000.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('febd7eea-d8dd-42fa-9b48-fa5a9de23b1d', '5c552dcf-ebef-4bfe-aee2-c4a6981c0f3a', 'ARRIENDO', 'Enero', '2025', 764000.00, 74400.00, 20000.00, 669600.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('d4b06c34-0268-45db-bf02-72c4fd781d35', 'ec860adc-defd-41d8-a89b-21d87b7ea128', 'ARRIENDO', 'Enero', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('71d19e65-f13f-4e28-92b4-f58a49bb1395', 'f2b5f4e7-1f87-4e12-8e0e-4963e89c092a', 'ARRIENDO', 'Enero', '2025', 620000.00, 60000.00, 20000.00, 540000.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('e1a47078-668f-4c55-a647-e8b63ae3399b', '16fbb6a2-d237-4dd2-8a6d-7bd76aa8645c', 'ARRIENDO', 'Enero', '2025', 660000.00, 64000.00, 20000.00, 576000.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('725a12d9-ebc0-49db-bbf1-ff825f053d4f', '09012b19-863a-4906-b34b-a89dcba8626e', 'ARRIENDO', 'Enero', '2025', 670000.00, 65000.00, 20000.00, 585000.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('09b40097-0b6a-436f-845c-b02d9e8a9a6a', '4768bece-ab83-433d-8e6e-3a9988dd03b1', 'ARRIENDO', 'Enero', '2025', 650000.00, 63000.00, 20000.00, 567000.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('b5ca3999-ec42-4155-b258-16b8190c2e74', 'e6519542-cc79-4b71-bb1a-dedae13cc106', 'ARRIENDO', 'Enero', '2025', 600000.00, 58000.00, 20000.00, 522000.00, '2025-02-10');
INSERT INTO public.pago_mensual VALUES ('a2ba611f-3da9-4e93-bdd3-7519269e5cc5', 'c40dcd0a-2212-45b3-b5d4-2aac8818bdf9', 'ARRIENDO', 'Febrero', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('0671b97f-618c-4336-a8bb-807608155095', 'c40dcd0a-2212-45b3-b5d4-2aac8818bdf9', 'OTRO', 'Febrero', '2025', 233000.00, 0.00, 0.00, 233000.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('7b627598-a728-40dd-8356-390b5970a3ef', 'e09f74db-f923-4e51-8bce-340da723f0cc', 'ARRIENDO', 'Febrero', '2025', 630000.00, 61000.00, 20000.00, 549000.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('b8783aa8-da40-4c9f-ab27-ba9fa44862d2', '8e4d74fa-ec72-4872-a04b-81c46e2fbd96', 'ARRIENDO', 'Febrero', '2025', 600000.00, 60000.00, 0.00, 540000.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('65d2e6b4-e6a8-4f75-a42a-8b50100b8068', '1c9d267f-bb28-462a-9b6c-10633cc45e36', 'ARRIENDO', 'Febrero', '2025', 732100.00, 71210.00, 20000.00, 640890.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('b12972bc-4b5f-4884-b7a9-1aa233dc6a5a', '9d4e93ec-8103-4ec7-94d4-480e0647a578', 'ARRIENDO', 'Febrero', '2025', 688000.00, 66800.00, 20000.00, 601200.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('b4aada19-6e82-4de4-b685-98f235e2b651', '3c91b9e4-e30d-43c4-93ec-843b4e0debfe', 'ARRIENDO', 'Febrero', '2025', 601000.00, 58000.00, 20000.00, 523000.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('cfb214dd-60fc-4db2-af6d-a6ea1241ff8d', 'e919ee59-138a-4725-be6c-8f7c401f3312', 'ARRIENDO', 'Febrero', '2025', 820000.00, 80000.00, 20000.00, 720000.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('5feedf28-f398-4e7f-a80e-cd6f0db95271', '4c0d2b4b-0d3e-42de-af57-9305df4b2c02', 'ARRIENDO', 'Febrero', '2025', 764000.00, 74400.00, 20000.00, 669600.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('82de300e-7009-4a60-8934-2eb56cf3a549', 'ec860adc-defd-41d8-a89b-21d87b7ea128', 'ARRIENDO', 'Febrero', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('8e78b50c-7108-4f0f-aa20-5ab49e9aaf6d', 'f2b5f4e7-1f87-4e12-8e0e-4963e89c092a', 'ARRIENDO', 'Febrero', '2025', 620000.00, 60000.00, 20000.00, 540000.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('ba731732-3778-441b-acb3-76c19a0020a6', '16fbb6a2-d237-4dd2-8a6d-7bd76aa8645c', 'ARRIENDO', 'Febrero', '2025', 660000.00, 64000.00, 20000.00, 576000.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('9499cf90-13a3-480b-ad1a-a0a056ee7b2d', '10424221-9e53-4f28-aea8-3549e2e43b87', 'ARRIENDO', 'Febrero', '2025', 670000.00, 65000.00, 20000.00, 585000.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('8ba22119-8f12-4e11-895b-5a6597c6bf0d', '4768bece-ab83-433d-8e6e-3a9988dd03b1', 'ARRIENDO', 'Febrero', '2025', 650000.00, 63000.00, 20000.00, 567000.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('74836863-2053-4a5d-88ff-85fc331bd715', 'e6519542-cc79-4b71-bb1a-dedae13cc106', 'ARRIENDO', 'Febrero', '2025', 600000.00, 58000.00, 20000.00, 522000.00, '2025-03-14');
INSERT INTO public.pago_mensual VALUES ('37984470-8ee8-4cdd-a498-55fe4ff35b2e', 'c40dcd0a-2212-45b3-b5d4-2aac8818bdf9', 'ARRIENDO', 'Marzo', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('83271240-a484-4674-9d49-3d9ed26d99ee', 'e09f74db-f923-4e51-8bce-340da723f0cc', 'ARRIENDO', 'Marzo', '2025', 630000.00, 61000.00, 20000.00, 549000.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('491d0b3e-19e1-4832-b31f-c68dce4d1757', '8e4d74fa-ec72-4872-a04b-81c46e2fbd96', 'ARRIENDO', 'Marzo', '2025', 600000.00, 60000.00, 0.00, 540000.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('b6fb50ff-57f6-4c09-907e-32644688ce77', '1c9d267f-bb28-462a-9b6c-10633cc45e36', 'ARRIENDO', 'Marzo', '2025', 732100.00, 71210.00, 20000.00, 640890.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('ad046c7b-961e-4ff9-ad9d-50c2d7fbcbc2', '9d4e93ec-8103-4ec7-94d4-480e0647a578', 'ARRIENDO', 'Marzo', '2025', 688000.00, 66800.00, 20000.00, 601200.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('4da4562a-3819-4841-a56d-b99f02459092', '3c91b9e4-e30d-43c4-93ec-843b4e0debfe', 'ARRIENDO', 'Marzo', '2025', 632200.00, 61220.00, 20000.00, 550980.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('5e3c5fcf-4bc3-40bd-b9a8-b1029a5b737f', '420d1c8b-349d-466e-9369-1ab30c465800', 'ARRIENDO', 'Marzo', '2025', 820000.00, 80000.00, 20000.00, 720000.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('200a86dc-84e4-48b2-a06a-f073861ee808', '4c0d2b4b-0d3e-42de-af57-9305df4b2c02', 'ARRIENDO', 'Marzo', '2025', 764000.00, 74400.00, 20000.00, 669600.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('236968db-e374-491d-99c1-7e1a4472eb09', 'ec860adc-defd-41d8-a89b-21d87b7ea128', 'ARRIENDO', 'Marzo', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('caec5869-1f57-483e-820a-7ec9fcd740bf', 'f2b5f4e7-1f87-4e12-8e0e-4963e89c092a', 'ARRIENDO', 'Marzo', '2025', 620000.00, 60000.00, 20000.00, 540000.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('203dfd61-eb1e-42cf-a2b2-410b98a12dc5', '16fbb6a2-d237-4dd2-8a6d-7bd76aa8645c', 'ARRIENDO', 'Marzo', '2025', 660000.00, 64000.00, 20000.00, 576000.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('b37323eb-6dab-45dd-b0d8-a97a586ef5ea', '10424221-9e53-4f28-aea8-3549e2e43b87', 'ARRIENDO', 'Marzo', '2025', 670000.00, 65000.00, 20000.00, 585000.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('19dfd16e-acd1-465a-8513-b856f9bbcf0e', 'bd3eeb6f-a14f-42cf-9deb-94f16f5eee70', 'ARRIENDO', 'Marzo', '2025', 650000.00, 63000.00, 20000.00, 567000.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('1f6b06fa-caef-4bcb-80f1-46edb7b7a608', 'e6519542-cc79-4b71-bb1a-dedae13cc106', 'ARRIENDO', 'Marzo', '2025', 600000.00, 58000.00, 20000.00, 522000.00, '2025-04-08');
INSERT INTO public.pago_mensual VALUES ('133c8bb0-e6af-4bda-a053-72a1ee525772', '0f257e4c-3331-4e0e-869e-42c5a332a2a1', 'ARRIENDO', 'Abril', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('1e77d99c-72ea-47ed-80b8-fde3ca0e8e4e', 'e09f74db-f923-4e51-8bce-340da723f0cc', 'ARRIENDO', 'Abril', '2025', 662700.00, 64270.00, 20000.00, 578430.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('50660c36-3b6f-4d1b-9535-3a7c25abe508', '8e4d74fa-ec72-4872-a04b-81c46e2fbd96', 'ARRIENDO', 'Abril', '2025', 600000.00, 60000.00, 0.00, 540000.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('b81f78c5-79e5-46ef-9208-57ba3d7c3f10', '1c9d267f-bb28-462a-9b6c-10633cc45e36', 'ARRIENDO', 'Abril', '2025', 732100.00, 71210.00, 20000.00, 640890.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('75f6aa35-6974-41f5-9929-dd69c531fe86', '9d4e93ec-8103-4ec7-94d4-480e0647a578', 'ARRIENDO', 'Abril', '2025', 688000.00, 66800.00, 20000.00, 601200.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('608ce394-7c93-4b6d-9e8b-27bfc7111adc', '652336e7-90e6-4346-a1db-9c99b994afe6', 'ARRIENDO', 'Abril', '2025', 632200.00, 61220.00, 20000.00, 550980.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('32155466-7f05-4468-8da3-60c739f2718a', '420d1c8b-349d-466e-9369-1ab30c465800', 'ARRIENDO', 'Abril', '2025', 820000.00, 80000.00, 20000.00, 720000.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('fc852dc5-e195-4d1b-a8d9-007c5990220b', '4c0d2b4b-0d3e-42de-af57-9305df4b2c02', 'ARRIENDO', 'Abril', '2025', 764000.00, 74400.00, 20000.00, 669600.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('bf31d71f-0c31-4c2c-be2b-7f3823fa55f8', 'ec860adc-defd-41d8-a89b-21d87b7ea128', 'ARRIENDO', 'Abril', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('a5fb6c28-6c58-42e5-a603-1e43c150662b', 'f2b5f4e7-1f87-4e12-8e0e-4963e89c092a', 'ARRIENDO', 'Abril', '2025', 620000.00, 60000.00, 20000.00, 540000.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('42a71461-d7e6-44eb-9df1-77e80a16d800', '16fbb6a2-d237-4dd2-8a6d-7bd76aa8645c', 'ARRIENDO', 'Abril', '2025', 660000.00, 64000.00, 20000.00, 576000.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('3141fb27-d5da-4fe8-a940-dc54144dae30', '10424221-9e53-4f28-aea8-3549e2e43b87', 'ARRIENDO', 'Abril', '2025', 670000.00, 65000.00, 20000.00, 585000.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('ef453eb6-099a-4032-8cd8-838ab52751ee', 'bd3eeb6f-a14f-42cf-9deb-94f16f5eee70', 'ARRIENDO', 'Abril', '2025', 650000.00, 63000.00, 20000.00, 567000.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('4c8a6a54-90d3-49fa-bd41-a84963965ed6', '8dc982a8-8e30-4eb7-905c-fb55c4175ca4', 'ARRIENDO', 'Abril', '2025', 600000.00, 58000.00, 20000.00, 522000.00, '2025-05-09');
INSERT INTO public.pago_mensual VALUES ('5ed88f9a-6204-4bbb-82c5-faca22e46567', '0f257e4c-3331-4e0e-869e-42c5a332a2a1', 'ARRIENDO', 'Mayo', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('d397e52e-ac56-4664-8612-92a6bf8e45b8', '0d8d157d-f9ab-4cd6-ac8a-7ed1a74a6746', 'ARRIENDO', 'Mayo', '2025', 662700.00, 64270.00, 20000.00, 578430.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('4e39540b-c203-477d-ad7c-fcd65f3fd48e', '8e4d74fa-ec72-4872-a04b-81c46e2fbd96', 'ARRIENDO', 'Mayo', '2025', 631200.00, 63120.00, 0.00, 568080.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('575ff676-5aa9-431e-91fc-e1de2fff4fde', '1c9d267f-bb28-462a-9b6c-10633cc45e36', 'ARRIENDO', 'Mayo', '2025', 732100.00, 71210.00, 20000.00, 640890.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('448bbc02-9317-473e-94f1-6344d6e731f1', '9d4e93ec-8103-4ec7-94d4-480e0647a578', 'ARRIENDO', 'Mayo', '2025', 688000.00, 66800.00, 20000.00, 601200.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('18db973d-ea09-4d0f-94b2-937ed661e80c', '652336e7-90e6-4346-a1db-9c99b994afe6', 'ARRIENDO', 'Mayo', '2025', 632200.00, 61220.00, 20000.00, 550980.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('522a339b-7d06-43a8-ba09-720445cd74f9', '420d1c8b-349d-466e-9369-1ab30c465800', 'ARRIENDO', 'Mayo', '2025', 820000.00, 80000.00, 20000.00, 720000.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('8670ffc9-4d35-4a96-9a99-698aa9e064d2', '4c0d2b4b-0d3e-42de-af57-9305df4b2c02', 'ARRIENDO', 'Mayo', '2025', 764000.00, 74400.00, 20000.00, 669600.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('2c249f4a-282e-4abf-b8fe-85c140dceec6', 'ec860adc-defd-41d8-a89b-21d87b7ea128', 'ARRIENDO', 'Mayo', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('40fb82c6-bba4-4aff-8e35-086dbda1803d', 'f2b5f4e7-1f87-4e12-8e0e-4963e89c092a', 'ARRIENDO', 'Mayo', '2025', 620000.00, 60000.00, 20000.00, 540000.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('e34b7f1a-1e8e-4f7a-8ebe-3a597a67f36c', '16fbb6a2-d237-4dd2-8a6d-7bd76aa8645c', 'ARRIENDO', 'Mayo', '2025', 673280.00, 65328.00, 20000.00, 587952.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('c5ab722f-34a6-40ba-95e8-7bc5195924c3', '10424221-9e53-4f28-aea8-3549e2e43b87', 'ARRIENDO', 'Mayo', '2025', 670000.00, 65000.00, 20000.00, 585000.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('e5d2e4e8-34b1-475b-a610-1aeca8e2591c', 'bd3eeb6f-a14f-42cf-9deb-94f16f5eee70', 'ARRIENDO', 'Mayo', '2025', 650000.00, 63000.00, 20000.00, 567000.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('e8ba800c-4473-4f60-8d13-63b0d52e13ad', '8dc982a8-8e30-4eb7-905c-fb55c4175ca4', 'ARRIENDO', 'Mayo', '2025', 600000.00, 58000.00, 20000.00, 522000.00, '2025-06-27');
INSERT INTO public.pago_mensual VALUES ('09543fa3-850c-4d2f-95da-8fb320a8e8fd', '0f257e4c-3331-4e0e-869e-42c5a332a2a1', 'ARRIENDO', 'Junio', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-07-08');
INSERT INTO public.pago_mensual VALUES ('3334ed97-482f-4e93-bedb-5d1b71858f37', '0d8d157d-f9ab-4cd6-ac8a-7ed1a74a6746', 'ARRIENDO', 'Junio', '2025', 662700.00, 64270.00, 20000.00, 578430.00, '2025-07-08');
INSERT INTO public.pago_mensual VALUES ('8be21cea-14eb-4b32-985b-86555054e92b', '3222d3e6-2b5b-4103-bc55-29e39c33ca84', 'ARRIENDO', 'Junio', '2025', 631200.00, 63120.00, 0.00, 568080.00, '2025-07-08');
INSERT INTO public.pago_mensual VALUES ('09ec5edf-9936-480e-b59b-c676b57a2d51', 'e725ef85-824a-4f9c-b7c6-445df4612ef0', 'ARRIENDO', 'Junio', '2025', 688000.00, 66800.00, 20000.00, 601200.00, '2025-07-08');
INSERT INTO public.pago_mensual VALUES ('7b2ffecb-4154-42c2-a393-bba300e375a1', '652336e7-90e6-4346-a1db-9c99b994afe6', 'ARRIENDO', 'Junio', '2025', 632200.00, 61220.00, 20000.00, 550980.00, '2025-07-08');
INSERT INTO public.pago_mensual VALUES ('63852cce-6559-4cd8-ad62-d828bb8517a5', '420d1c8b-349d-466e-9369-1ab30c465800', 'ARRIENDO', 'Junio', '2025', 820000.00, 80000.00, 20000.00, 720000.00, '2025-07-08');
INSERT INTO public.pago_mensual VALUES ('dd431d19-3117-4523-913c-47eb428935f1', '4c0d2b4b-0d3e-42de-af57-9305df4b2c02', 'ARRIENDO', 'Junio', '2025', 764000.00, 74400.00, 20000.00, 669600.00, '2025-07-08');
INSERT INTO public.pago_mensual VALUES ('3a6b5d24-40d8-49cb-bb1a-b1751a10df84', 'ae88cdb7-93b0-42cd-bda5-e4576643e9c7', 'ARRIENDO', 'Junio', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-07-08');
INSERT INTO public.pago_mensual VALUES ('88c401fe-e564-459a-9b76-b8b62a9ebc31', '01fb67ad-1898-47db-a814-5a658a723a89', 'ARRIENDO', 'Junio', '2025', 673280.00, 65328.00, 20000.00, 587952.00, '2025-07-08');
INSERT INTO public.pago_mensual VALUES ('0a13e598-155d-4ef6-847a-86a44666e6b3', '10424221-9e53-4f28-aea8-3549e2e43b87', 'ARRIENDO', 'Junio', '2025', 670000.00, 65000.00, 20000.00, 585000.00, '2025-07-08');
INSERT INTO public.pago_mensual VALUES ('07454090-5e82-47b7-b0a0-63c33dd3c8c5', 'bd3eeb6f-a14f-42cf-9deb-94f16f5eee70', 'ARRIENDO', 'Junio', '2025', 650000.00, 63000.00, 20000.00, 567000.00, '2025-07-08');
INSERT INTO public.pago_mensual VALUES ('4252f5e7-f41f-4d19-9344-7c63308b685c', '8dc982a8-8e30-4eb7-905c-fb55c4175ca4', 'ARRIENDO', 'Junio', '2025', 600000.00, 58000.00, 20000.00, 522000.00, '2025-07-08');
INSERT INTO public.pago_mensual VALUES ('22fa1d6b-b709-4a73-8700-e0cee10749a9', '0f257e4c-3331-4e0e-869e-42c5a332a2a1', 'ARRIENDO', 'Julio', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('17ae21a5-175f-4617-9336-3aeee3b871e6', '0d8d157d-f9ab-4cd6-ac8a-7ed1a74a6746', 'ARRIENDO', 'Julio', '2025', 662700.00, 64270.00, 20000.00, 578430.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('df476da5-2bc4-4f10-8659-1a14a81ab958', '3222d3e6-2b5b-4103-bc55-29e39c33ca84', 'ARRIENDO', 'Julio', '2025', 631200.00, 63120.00, 0.00, 568080.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('669e2a63-74cc-4abe-8c0e-b76c5b7f5900', '1f5eb474-0cc5-4f59-bde6-8b6fb39d4b29', 'ARRIENDO', 'Julio', '2025', 800000.00, 78000.00, 20000.00, 702000.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('cb709a6f-2c6d-48ee-8281-678492f4b06b', 'e725ef85-824a-4f9c-b7c6-445df4612ef0', 'ARRIENDO', 'Julio', '2025', 688000.00, 66800.00, 20000.00, 601200.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('516d9029-fb6d-49e5-a6dd-ce7a713664f6', '652336e7-90e6-4346-a1db-9c99b994afe6', 'ARRIENDO', 'Julio', '2025', 632200.00, 61220.00, 20000.00, 550980.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('46cd2bb0-7607-4659-b181-f8b5a593e9aa', '420d1c8b-349d-466e-9369-1ab30c465800', 'ARRIENDO', 'Julio', '2025', 820000.00, 80000.00, 20000.00, 720000.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('a67669e9-9e4f-4db7-aeed-963459703766', '4c0d2b4b-0d3e-42de-af57-9305df4b2c02', 'ARRIENDO', 'Julio', '2025', 764000.00, 74400.00, 20000.00, 669600.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('4cf80561-63b0-480b-b7de-1a18f7a9ea2c', 'ae88cdb7-93b0-42cd-bda5-e4576643e9c7', 'ARRIENDO', 'Julio', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('10cebeaf-8038-4d07-b056-07b79d1bf737', '01fb67ad-1898-47db-a814-5a658a723a89', 'ARRIENDO', 'Julio', '2025', 673280.00, 65328.00, 20000.00, 587952.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('a1837168-5313-41a5-9c36-037f78e7d366', '10424221-9e53-4f28-aea8-3549e2e43b87', 'ARRIENDO', 'Julio', '2025', 670000.00, 65000.00, 20000.00, 585000.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('f6b8485d-0948-48fd-bb8c-04c52edae614', 'bd3eeb6f-a14f-42cf-9deb-94f16f5eee70', 'ARRIENDO', 'Julio', '2025', 650000.00, 63000.00, 20000.00, 567000.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('15131884-71d3-4efa-9ccf-554efdbabdd5', '8dc982a8-8e30-4eb7-905c-fb55c4175ca4', 'ARRIENDO', 'Julio', '2025', 600000.00, 58000.00, 20000.00, 522000.00, '2025-08-08');
INSERT INTO public.pago_mensual VALUES ('22a76952-b736-44c0-bf6b-df62afc9809e', '0f257e4c-3331-4e0e-869e-42c5a332a2a1', 'ARRIENDO', 'Agosto', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('a21bca1d-82ff-4610-bf24-868a6fd04636', '0d8d157d-f9ab-4cd6-ac8a-7ed1a74a6746', 'ARRIENDO', 'Agosto', '2025', 662700.00, 64270.00, 20000.00, 578430.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('d2b0d70e-891c-4334-9d15-2626e2b3107d', '3222d3e6-2b5b-4103-bc55-29e39c33ca84', 'ARRIENDO', 'Agosto', '2025', 631200.00, 63120.00, 0.00, 568080.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('96158d16-8a06-4ba1-839d-6de197f1f233', '1f5eb474-0cc5-4f59-bde6-8b6fb39d4b29', 'ARRIENDO', 'Agosto', '2025', 800000.00, 78000.00, 20000.00, 702000.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('16008280-25d0-4bbe-be27-a379196f6a3d', 'e725ef85-824a-4f9c-b7c6-445df4612ef0', 'ARRIENDO', 'Agosto', '2025', 688000.00, 66800.00, 20000.00, 601200.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('e3726a58-521b-47a7-b93b-8c7405d84634', '652336e7-90e6-4346-a1db-9c99b994afe6', 'ARRIENDO', 'Agosto', '2025', 632200.00, 61220.00, 20000.00, 550980.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('f23930cb-47de-4b1b-bd17-df33b62d8e96', '02c61008-4e84-43c2-88b5-08e054eb6049', 'ARRIENDO', 'Agosto', '2025', 850000.00, 83000.00, 20000.00, 747000.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('217c9073-15d1-4e10-9236-4af11ca1845e', '359216a7-8ba9-4e24-8cac-7dc225c9d6e1', 'ARRIENDO', 'Agosto', '2025', 764000.00, 74400.00, 20000.00, 669600.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('56c2c6bd-b655-487b-b764-a5fd6724dbe8', 'ae88cdb7-93b0-42cd-bda5-e4576643e9c7', 'ARRIENDO', 'Agosto', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('4834c968-8872-45a3-962c-647114c28d1e', 'b934fcd1-5390-4b7c-b3bc-4a642a1d7f9e', 'ARRIENDO', 'Agosto', '2025', 650000.00, 63000.00, 20000.00, 567000.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('324aa5c0-fbd3-4ab0-8152-3178d79d7fd5', '01fb67ad-1898-47db-a814-5a658a723a89', 'ARRIENDO', 'Agosto', '2025', 673280.00, 65328.00, 20000.00, 587952.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('2e66f86c-aaae-472f-ba6b-563cef9c2ab6', '10959edc-7e2c-4e4e-b5ee-d6bdac93ae9e', 'ARRIENDO', 'Agosto', '2025', 670000.00, 65000.00, 20000.00, 585000.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('d2498aed-3cd4-4327-8562-ffe8d9cb0941', '8dc982a8-8e30-4eb7-905c-fb55c4175ca4', 'ARRIENDO', 'Agosto', '2025', 600000.00, 63000.00, 20000.00, 517000.00, '2025-09-10');
INSERT INTO public.pago_mensual VALUES ('b113e0b0-7359-473b-bcb6-84495a9144df', '0f257e4c-3331-4e0e-869e-42c5a332a2a1', 'ARRIENDO', 'Septiembre', '2025', 736400.00, 74640.00, 20000.00, 641760.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('2418edaa-3b95-4710-8b6b-871e68cecd91', '0d8d157d-f9ab-4cd6-ac8a-7ed1a74a6746', 'ARRIENDO', 'Septiembre', '2025', 662700.00, 64270.00, 20000.00, 578430.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('84009aee-d373-465e-ba1c-3aac04496b4f', '3222d3e6-2b5b-4103-bc55-29e39c33ca84', 'ARRIENDO', 'Septiembre', '2025', 631200.00, 63120.00, 0.00, 568080.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('88f13363-40a0-4735-be07-20c721dbe7b4', '1f5eb474-0cc5-4f59-bde6-8b6fb39d4b29', 'ARRIENDO', 'Septiembre', '2025', 800000.00, 78000.00, 20000.00, 702000.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('685d3154-03c7-4954-a67c-739c9bb84551', 'e725ef85-824a-4f9c-b7c6-445df4612ef0', 'ARRIENDO', 'Septiembre', '2025', 688000.00, 66800.00, 20000.00, 601200.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('151dd57d-1e56-407a-a6c0-02b05fe5edde', '652336e7-90e6-4346-a1db-9c99b994afe6', 'ARRIENDO', 'Septiembre', '2025', 632200.00, 61220.00, 20000.00, 550980.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('e77a09a4-b672-4e52-ab7a-0b4c915c0708', '02c61008-4e84-43c2-88b5-08e054eb6049', 'ARRIENDO', 'Septiembre', '2025', 850000.00, 83000.00, 20000.00, 747000.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('0cd09bc2-b904-4e94-9918-e19a6b32fbe3', '359216a7-8ba9-4e24-8cac-7dc225c9d6e1', 'ARRIENDO', 'Septiembre', '2025', 803700.00, 78370.00, 20000.00, 705330.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('06360316-7d0e-4bb7-9a42-a995e32838eb', 'ae88cdb7-93b0-42cd-bda5-e4576643e9c7', 'ARRIENDO', 'Septiembre', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('0f4e74ec-1473-4592-a830-cbd488005ee6', 'b934fcd1-5390-4b7c-b3bc-4a642a1d7f9e', 'ARRIENDO', 'Septiembre', '2025', 650000.00, 63000.00, 20000.00, 567000.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('e28a8eaf-bdae-41d6-9242-9fa950cae7c6', '01fb67ad-1898-47db-a814-5a658a723a89', 'ARRIENDO', 'Septiembre', '2025', 673280.00, 65328.00, 20000.00, 587952.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('83bc86ea-dbcc-42a1-a8fd-389af7924eca', '10959edc-7e2c-4e4e-b5ee-d6bdac93ae9e', 'ARRIENDO', 'Septiembre', '2025', 704800.00, 68480.00, 20000.00, 616320.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('59d7de14-e656-40aa-badc-b9a7b0697b36', '2aaff763-f744-410b-9718-249c5a655998', 'ARRIENDO', 'Septiembre', '2025', 680000.00, 66000.00, 0.00, 614000.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('b2abe39d-a225-46a0-aba6-b0272b7ea2ee', '2aaff763-f744-410b-9718-249c5a655998', 'OTRO', 'Septiembre', '2025', 113333.00, 0.00, 0.00, 113333.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('b2b6d825-bc95-4d5c-abc3-95aad4dbdd69', '8dc982a8-8e30-4eb7-905c-fb55c4175ca4', 'ARRIENDO', 'Septiembre', '2025', 631200.00, 61120.00, 20000.00, 550080.00, '2025-10-09');
INSERT INTO public.pago_mensual VALUES ('10e9f720-1601-4609-adb5-368811787933', '3dcc043e-cebd-4562-843a-73004bc5a5fb', 'ARRIENDO', 'Octubre', '2025', 736400.00, 74640.00, 20000.00, 641760.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('2d143f56-8357-405b-8524-75b05007a839', '0d8d157d-f9ab-4cd6-ac8a-7ed1a74a6746', 'ARRIENDO', 'Octubre', '2025', 662700.00, 64270.00, 20000.00, 578430.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('8f05c4ef-04c9-4037-93f7-a85b4063b054', '3222d3e6-2b5b-4103-bc55-29e39c33ca84', 'ARRIENDO', 'Octubre', '2025', 631200.00, 63120.00, 0.00, 568080.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('c7f89d14-aea1-45f2-998e-01ea74a63e44', '1f5eb474-0cc5-4f59-bde6-8b6fb39d4b29', 'ARRIENDO', 'Octubre', '2025', 800000.00, 78000.00, 20000.00, 702000.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('13507aa6-e76c-4282-933e-4baad0d119c2', 'e725ef85-824a-4f9c-b7c6-445df4612ef0', 'ARRIENDO', 'Octubre', '2025', 688000.00, 66800.00, 20000.00, 601200.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('c5e6f579-3d19-4b51-bace-276a21652fd9', '2eb39786-09e7-4dd1-ae3f-137c5bc86751', 'ARRIENDO', 'Octubre', '2025', 632200.00, 61220.00, 20000.00, 550980.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('c3bfb295-a4a4-408e-b224-9b1eba6d2e07', '02c61008-4e84-43c2-88b5-08e054eb6049', 'ARRIENDO', 'Octubre', '2025', 850000.00, 83000.00, 20000.00, 747000.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('aedcc855-b5d3-41e2-ac80-03aae8d8ade8', '359216a7-8ba9-4e24-8cac-7dc225c9d6e1', 'ARRIENDO', 'Octubre', '2025', 803700.00, 78370.00, 20000.00, 705330.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('e094d8da-a5c1-4593-bbff-9e7a7b1a77b4', 'ae88cdb7-93b0-42cd-bda5-e4576643e9c7', 'ARRIENDO', 'Octubre', '2025', 700000.00, 68000.00, 20000.00, 612000.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('e77e2e46-a192-4bfd-99f3-754674769b4a', 'b934fcd1-5390-4b7c-b3bc-4a642a1d7f9e', 'ARRIENDO', 'Octubre', '2025', 650000.00, 63000.00, 20000.00, 567000.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('3be50340-1c2b-4f92-8b48-3e8d5229615e', '01fb67ad-1898-47db-a814-5a658a723a89', 'ARRIENDO', 'Octubre', '2025', 673280.00, 65328.00, 20000.00, 587952.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('e3a60208-4e87-482e-86ae-0f445f3c0372', '10959edc-7e2c-4e4e-b5ee-d6bdac93ae9e', 'ARRIENDO', 'Octubre', '2025', 704800.00, 68480.00, 20000.00, 616320.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('dfe9ba42-34a5-41f0-a752-e3ff4a58512e', '2aaff763-f744-410b-9718-249c5a655998', 'ARRIENDO', 'Octubre', '2025', 680000.00, 66000.00, 0.00, 614000.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('7c6c5d42-7ec1-495e-ad1e-e329b96c4ec4', '1138e6b0-3b54-4f90-9461-f8f76393e615', 'ARRIENDO', 'Octubre', '2025', 631200.00, 61120.00, 20000.00, 550080.00, '2025-11-08');
INSERT INTO public.pago_mensual VALUES ('dc7a029e-7689-49ee-bede-e34a87212512', '3dcc043e-cebd-4562-843a-73004bc5a5fb', 'ARRIENDO', 'Noviembre', '2025', 736400.00, 71640.00, 20000.00, 644760.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('e1ecf47c-ea60-45fe-9a38-3b179b82d2ef', 'e39b3e8a-33b6-49ac-8fe8-f4ed22ad8b90', 'ARRIENDO', 'Noviembre', '2025', 662700.00, 64270.00, 20000.00, 578430.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('f8561b2f-b6b1-41ca-88f7-56a7f5285899', '3222d3e6-2b5b-4103-bc55-29e39c33ca84', 'ARRIENDO', 'Noviembre', '2025', 631200.00, 63120.00, 0.00, 568080.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('e4e096f2-ed1e-4023-ad9e-81d68d930dd9', '1f5eb474-0cc5-4f59-bde6-8b6fb39d4b29', 'ARRIENDO', 'Noviembre', '2025', 800000.00, 78000.00, 20000.00, 702000.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('d590a23e-1bda-4a2f-a822-63d6296ea275', '2eb39786-09e7-4dd1-ae3f-137c5bc86751', 'ARRIENDO', 'Noviembre', '2025', 632200.00, 61220.00, 20000.00, 550980.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('35fd17c4-5dfe-40e6-b142-8638f6e68f57', '02c61008-4e84-43c2-88b5-08e054eb6049', 'ARRIENDO', 'Noviembre', '2025', 850000.00, 83000.00, 20000.00, 747000.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('77391712-9ac7-4740-85f3-b10d8e3e6335', '359216a7-8ba9-4e24-8cac-7dc225c9d6e1', 'ARRIENDO', 'Noviembre', '2025', 803700.00, 78370.00, 20000.00, 705330.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('858d35d5-91fb-4c6d-ac78-0c4249e2ab04', '7366f152-e5d2-44a3-8beb-4d85e5905cbc', 'ARRIENDO', 'Noviembre', '2025', 750000.00, 73000.00, 20000.00, 657000.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('5a807d6e-6a94-4442-85da-3f6acda79a25', 'b934fcd1-5390-4b7c-b3bc-4a642a1d7f9e', 'ARRIENDO', 'Noviembre', '2025', 650000.00, 63000.00, 20000.00, 567000.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('3e46c8e8-b616-4647-a617-47537f9b368a', '01fb67ad-1898-47db-a814-5a658a723a89', 'ARRIENDO', 'Noviembre', '2025', 673280.00, 65328.00, 20000.00, 587952.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('5aed5039-8157-4e96-93f3-2e261e870dcf', '10959edc-7e2c-4e4e-b5ee-d6bdac93ae9e', 'ARRIENDO', 'Noviembre', '2025', 704800.00, 68480.00, 20000.00, 616320.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('6abddba2-fee2-4179-868d-4cd59a9b93e3', '2aaff763-f744-410b-9718-249c5a655998', 'ARRIENDO', 'Noviembre', '2025', 680000.00, 66000.00, 20000.00, 594000.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('23eea01c-dc85-4160-9d56-69921f2afd07', '1138e6b0-3b54-4f90-9461-f8f76393e615', 'ARRIENDO', 'Noviembre', '2025', 631200.00, 61120.00, 20000.00, 550080.00, '2025-12-11');
INSERT INTO public.pago_mensual VALUES ('e91ebbb7-2893-4c0c-b331-b24bd4b0d7c1', '3dcc043e-cebd-4562-843a-73004bc5a5fb', 'ARRIENDO', 'Diciembre', '2025', 736400.00, 71640.00, 20000.00, 644760.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('655124f8-4803-479d-be55-6981b2f51dee', 'e39b3e8a-33b6-49ac-8fe8-f4ed22ad8b90', 'ARRIENDO', 'Diciembre', '2025', 662700.00, 64270.00, 20000.00, 578430.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('129fcd19-6475-4ab0-8b2b-93d89bf82940', 'cac5cc64-81f9-466e-94ec-47be649d3deb', 'ARRIENDO', 'Diciembre', '2025', 631200.00, 63120.00, 0.00, 568080.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('9dd0b2c7-20f1-47dd-9650-6ff477788dc9', '1f5eb474-0cc5-4f59-bde6-8b6fb39d4b29', 'ARRIENDO', 'Diciembre', '2025', 800000.00, 78000.00, 20000.00, 702000.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('3eb63124-1789-45ad-8ddd-9864e8ac7d98', '4d99141d-777f-42b8-9171-236b233bb4bf', 'ARRIENDO', 'Diciembre', '2025', 720000.00, 70000.00, 20000.00, 630000.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('9877a7e4-993b-476f-aa88-bdca092a72d9', '2eb39786-09e7-4dd1-ae3f-137c5bc86751', 'ARRIENDO', 'Diciembre', '2025', 632200.00, 61220.00, 20000.00, 550980.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('93abace9-1e9b-4cac-88e7-20a63cc7de4a', '02c61008-4e84-43c2-88b5-08e054eb6049', 'ARRIENDO', 'Diciembre', '2025', 850000.00, 83000.00, 20000.00, 747000.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('226409b0-bef0-4b5d-bb1f-75f3358939b1', '359216a7-8ba9-4e24-8cac-7dc225c9d6e1', 'ARRIENDO', 'Diciembre', '2025', 803700.00, 78370.00, 20000.00, 705330.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('c263384d-9663-409c-b76d-c56f9edfe7fe', '7366f152-e5d2-44a3-8beb-4d85e5905cbc', 'ARRIENDO', 'Diciembre', '2025', 750000.00, 73000.00, 20000.00, 657000.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('96314dc1-0a99-471b-ac80-bc7b6043ab70', 'b934fcd1-5390-4b7c-b3bc-4a642a1d7f9e', 'ARRIENDO', 'Diciembre', '2025', 650000.00, 63000.00, 20000.00, 567000.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('c31a8b8b-0de0-48b1-ae9a-a1581c0ff5c6', '40f08409-f7a6-467c-8e53-1f5a9a143a9f', 'ARRIENDO', 'Diciembre', '2025', 694320.00, 67432.00, 20000.00, 606888.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('e98943f9-a355-4957-a13a-72f2643b4fa8', '10959edc-7e2c-4e4e-b5ee-d6bdac93ae9e', 'ARRIENDO', 'Diciembre', '2025', 704800.00, 68480.00, 20000.00, 616320.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('b5c8f708-668e-4f09-9693-19275a6daee5', '2aaff763-f744-410b-9718-249c5a655998', 'ARRIENDO', 'Diciembre', '2025', 680000.00, 66000.00, 20000.00, 594000.00, '2026-01-09');
INSERT INTO public.pago_mensual VALUES ('68ca3bea-f737-4853-bfca-c73f6691a7ac', '1138e6b0-3b54-4f90-9461-f8f76393e615', 'ARRIENDO', 'Diciembre', '2025', 631200.00, 61120.00, 20000.00, 550080.00, '2026-01-09');


--
-- TOC entry 5061 (class 0 OID 16431)
-- Dependencies: 220
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.usuario VALUES ('0e0d8972-a7b7-4176-a382-48259937433e', 'german', '123');


--
-- TOC entry 4901 (class 2606 OID 16459)
-- Name: apartamento apartamento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.apartamento
    ADD CONSTRAINT apartamento_pkey PRIMARY KEY (id);


--
-- TOC entry 4903 (class 2606 OID 16472)
-- Name: arrendatario arrendatario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.arrendatario
    ADD CONSTRAINT arrendatario_pkey PRIMARY KEY (id);


--
-- TOC entry 4905 (class 2606 OID 16483)
-- Name: contrato_arriendo contrato_arriendo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contrato_arriendo
    ADD CONSTRAINT contrato_arriendo_pkey PRIMARY KEY (id);


--
-- TOC entry 4899 (class 2606 OID 16450)
-- Name: edificio edificio_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.edificio
    ADD CONSTRAINT edificio_pkey PRIMARY KEY (id);


--
-- TOC entry 4907 (class 2606 OID 16549)
-- Name: pago_mensual pago_mensual_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pago_mensual
    ADD CONSTRAINT pago_mensual_pkey PRIMARY KEY (id);


--
-- TOC entry 4909 (class 2606 OID 16551)
-- Name: pago_mensual uk_pago_mes; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pago_mensual
    ADD CONSTRAINT uk_pago_mes UNIQUE (contrato_arriendo_id, mes, anio, tipo);


--
-- TOC entry 4895 (class 2606 OID 16439)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 4897 (class 2606 OID 16441)
-- Name: usuario usuario_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_username_key UNIQUE (username);


--
-- TOC entry 4910 (class 2606 OID 16460)
-- Name: apartamento fk_apartamento_edificio; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.apartamento
    ADD CONSTRAINT fk_apartamento_edificio FOREIGN KEY (edificio_id) REFERENCES public.edificio(id) ON DELETE CASCADE;


--
-- TOC entry 4911 (class 2606 OID 16484)
-- Name: contrato_arriendo fk_contrato_apartamento; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contrato_arriendo
    ADD CONSTRAINT fk_contrato_apartamento FOREIGN KEY (apartamento_id) REFERENCES public.apartamento(id) ON DELETE CASCADE;


--
-- TOC entry 4912 (class 2606 OID 16489)
-- Name: contrato_arriendo fk_contrato_arrendatario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contrato_arriendo
    ADD CONSTRAINT fk_contrato_arrendatario FOREIGN KEY (arrendatario_id) REFERENCES public.arrendatario(id) ON DELETE RESTRICT;


--
-- TOC entry 4913 (class 2606 OID 16552)
-- Name: pago_mensual fk_pago_contrato; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pago_mensual
    ADD CONSTRAINT fk_pago_contrato FOREIGN KEY (contrato_arriendo_id) REFERENCES public.contrato_arriendo(id) ON DELETE CASCADE;


-- Completed on 2026-01-19 14:33:42

--
-- PostgreSQL database dump complete
--

\unrestrict 597NGHHkpGNFbzgCh3Cna6E4AvR4ezSKy7PRlyfH5sLmwXdUWiffYXjncRsuMsW

