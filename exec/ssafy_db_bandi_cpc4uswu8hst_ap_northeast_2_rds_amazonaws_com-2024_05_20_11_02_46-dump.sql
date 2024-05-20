--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: beacon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beacon (
    beacon_id character varying(255) NOT NULL,
    beacon_type character varying(255),
    floor integer NOT NULL,
    latitude double precision,
    longitude double precision,
    range integer NOT NULL,
    x integer NOT NULL,
    y integer NOT NULL,
    station_id integer
);


ALTER TABLE public.beacon OWNER TO postgres;

--
-- Name: edge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.edge (
    edge_id integer NOT NULL,
    distance integer,
    beacon_id1 character varying(255),
    beacon_id2 character varying(255),
    station_id integer
);


ALTER TABLE public.edge OWNER TO postgres;

--
-- Name: edge_edge_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edge_edge_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edge_edge_id_seq OWNER TO postgres;

--
-- Name: edge_edge_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.edge_edge_id_seq OWNED BY public.edge.edge_id;


--
-- Name: elevator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.elevator (
    elevator_id integer NOT NULL,
    is_up boolean NOT NULL,
    beacon_id character varying(255)
);


ALTER TABLE public.elevator OWNER TO postgres;

--
-- Name: elevator_elevator_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.elevator_elevator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.elevator_elevator_id_seq OWNER TO postgres;

--
-- Name: elevator_elevator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.elevator_elevator_id_seq OWNED BY public.elevator.elevator_id;


--
-- Name: escalator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.escalator (
    escalator_id integer NOT NULL,
    is_up boolean NOT NULL,
    beacon_id character varying(255)
);


ALTER TABLE public.escalator OWNER TO postgres;

--
-- Name: escalator_escalator_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.escalator_escalator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.escalator_escalator_id_seq OWNER TO postgres;

--
-- Name: escalator_escalator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.escalator_escalator_id_seq OWNED BY public.escalator.escalator_id;


--
-- Name: exit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exit (
    exit_id integer NOT NULL,
    elevator character varying(255),
    escalator character varying(255),
    landmark character varying(255),
    number integer,
    stair character varying(255),
    beacon_id character varying(255)
);


ALTER TABLE public.exit OWNER TO postgres;

--
-- Name: exit_exit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exit_exit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exit_exit_id_seq OWNER TO postgres;

--
-- Name: exit_exit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exit_exit_id_seq OWNED BY public.exit.exit_id;


--
-- Name: gate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gate (
    gate_id integer NOT NULL,
    elevator character varying(255),
    escalator character varying(255),
    is_up boolean,
    stair character varying(255),
    beacon_id character varying(255)
);


ALTER TABLE public.gate OWNER TO postgres;

--
-- Name: gate_gate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gate_gate_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gate_gate_id_seq OWNER TO postgres;

--
-- Name: gate_gate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gate_gate_id_seq OWNED BY public.gate.gate_id;


--
-- Name: point; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.point (
    point_id integer NOT NULL,
    beacon_id character varying(255)
);


ALTER TABLE public.point OWNER TO postgres;

--
-- Name: point_point_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.point_point_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.point_point_id_seq OWNER TO postgres;

--
-- Name: point_point_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.point_point_id_seq OWNED BY public.point.point_id;


--
-- Name: screendoor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.screendoor (
    screendoor_id integer NOT NULL,
    direction character varying(255),
    beacon_id character varying(255)
);


ALTER TABLE public.screendoor OWNER TO postgres;

--
-- Name: screendoor_screendoor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.screendoor_screendoor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.screendoor_screendoor_id_seq OWNER TO postgres;

--
-- Name: screendoor_screendoor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.screendoor_screendoor_id_seq OWNED BY public.screendoor.screendoor_id;


--
-- Name: stair; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stair (
    stair_id integer NOT NULL,
    is_up boolean NOT NULL,
    beacon_id character varying(255)
);


ALTER TABLE public.stair OWNER TO postgres;

--
-- Name: stair_stair_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stair_stair_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stair_stair_id_seq OWNER TO postgres;

--
-- Name: stair_stair_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stair_stair_id_seq OWNED BY public.stair.stair_id;


--
-- Name: station; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.station (
    station_id integer NOT NULL,
    line integer,
    login_id character varying(255),
    name character varying(255),
    login_pw character varying(255),
    role character varying(255)
);


ALTER TABLE public.station OWNER TO postgres;

--
-- Name: station_station_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.station_station_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.station_station_id_seq OWNER TO postgres;

--
-- Name: station_station_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.station_station_id_seq OWNED BY public.station.station_id;


--
-- Name: toilet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.toilet (
    toilet_id integer NOT NULL,
    man_dir character varying(255),
    woman_dir character varying(255),
    beacon_id character varying(255)
);


ALTER TABLE public.toilet OWNER TO postgres;

--
-- Name: toilet_toilet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.toilet_toilet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.toilet_toilet_id_seq OWNER TO postgres;

--
-- Name: toilet_toilet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.toilet_toilet_id_seq OWNED BY public.toilet.toilet_id;


--
-- Name: edge edge_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edge ALTER COLUMN edge_id SET DEFAULT nextval('public.edge_edge_id_seq'::regclass);


--
-- Name: elevator elevator_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elevator ALTER COLUMN elevator_id SET DEFAULT nextval('public.elevator_elevator_id_seq'::regclass);


--
-- Name: escalator escalator_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalator ALTER COLUMN escalator_id SET DEFAULT nextval('public.escalator_escalator_id_seq'::regclass);


--
-- Name: exit exit_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exit ALTER COLUMN exit_id SET DEFAULT nextval('public.exit_exit_id_seq'::regclass);


--
-- Name: gate gate_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gate ALTER COLUMN gate_id SET DEFAULT nextval('public.gate_gate_id_seq'::regclass);


--
-- Name: point point_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point ALTER COLUMN point_id SET DEFAULT nextval('public.point_point_id_seq'::regclass);


--
-- Name: screendoor screendoor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screendoor ALTER COLUMN screendoor_id SET DEFAULT nextval('public.screendoor_screendoor_id_seq'::regclass);


--
-- Name: stair stair_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stair ALTER COLUMN stair_id SET DEFAULT nextval('public.stair_stair_id_seq'::regclass);


--
-- Name: station station_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station ALTER COLUMN station_id SET DEFAULT nextval('public.station_station_id_seq'::regclass);


--
-- Name: toilet toilet_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toilet ALTER COLUMN toilet_id SET DEFAULT nextval('public.toilet_toilet_id_seq'::regclass);


--
-- Data for Name: beacon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.beacon (beacon_id, beacon_type, floor, latitude, longitude, range, x, y, station_id) FROM stdin;
삼성전자역3번출구	EXIT	-1	35.213333	129.024555	20	30	50	7
E3:2F:4B:F3:F2:77	STAIR	-2	35.096339	128.853998	2	344	5	1
DF:8F:78:F0:06:1F	SCREENDOOR	-2	35.096459	128.854098	2	346	76	1
삼성전자상행개찰구	GATE	-1	35.213341	129.02411	20	0	100	7
DA:B9:B0:9A:CD:76	STAIR	-1	35.096237	128.853908	2	50	280	1
D4:5C:67:6A:7A:7A	GATE	-1	35.0961565	128.8539389	2	321	280	1
지하 1층 엘리베이터	ELEVATOR	-1	35	127	2	170	100	1
CA:8D:AC:9C:63:64	TOILET	-1	35.09605415	128.85407296	2	813	62	1
FB:B8:E8:D8:0E:97	POINT	-1	35.096099	128.8539	2	813	280	1
intersection	POINT	-1	35.22222	127.222222	2	170	280	1
D0:41:AE:8E:5C:0A	EXIT	-1	35.096115	128.853881	2	626	400	1
CA:87:66:3E:6E:38	POINT	-1	35.096084	128.853923	2	626	280	1
\.


--
-- Data for Name: edge; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.edge (edge_id, distance, beacon_id1, beacon_id2, station_id) FROM stdin;
14	8	E3:2F:4B:F3:F2:77	DF:8F:78:F0:06:1F	1
11	7	CA:87:66:3E:6E:38	D0:41:AE:8E:5C:0A	1
13	7	DA:B9:B0:9A:CD:76	E3:2F:4B:F3:F2:77	1
8	5	CA:8D:AC:9C:63:64	FB:B8:E8:D8:0E:97	1
9	4	FB:B8:E8:D8:0E:97	CA:87:66:3E:6E:38	1
15	40	삼성전자역3번출구	삼성전자상행개찰구	7
16	31922	지하 1층 엘리베이터	intersection	1
17	148987	D4:5C:67:6A:7A:7A	intersection	1
18	148984	intersection	DA:B9:B0:9A:CD:76	1
21	8	CA:87:66:3E:6E:38	D4:5C:67:6A:7A:7A	1
\.


--
-- Data for Name: elevator; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.elevator (elevator_id, is_up, beacon_id) FROM stdin;
3	t	지하 1층 엘리베이터
\.


--
-- Data for Name: escalator; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.escalator (escalator_id, is_up, beacon_id) FROM stdin;
\.


--
-- Data for Name: exit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exit (exit_id, elevator, escalator, landmark, number, stair, beacon_id) FROM stdin;
4	\N	F	희망공원, 고모리 커피	3	\N	D0:41:AE:8E:5C:0A
5	R	\N	삼성전자방면	4	L	삼성전자역3번출구
\.


--
-- Data for Name: gate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gate (gate_id, elevator, escalator, is_up, stair, beacon_id) FROM stdin;
6	R	\N	t	L	삼성전자상행개찰구
8	R	\N	f	F	D4:5C:67:6A:7A:7A
\.


--
-- Data for Name: point; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.point (point_id, beacon_id) FROM stdin;
1	FB:B8:E8:D8:0E:97
3	CA:87:66:3E:6E:38
4	intersection
\.


--
-- Data for Name: screendoor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.screendoor (screendoor_id, direction, beacon_id) FROM stdin;
3	삼성전자역 방면 5-1 열차	DF:8F:78:F0:06:1F
\.


--
-- Data for Name: stair; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stair (stair_id, is_up, beacon_id) FROM stdin;
4	t	DA:B9:B0:9A:CD:76
5	f	E3:2F:4B:F3:F2:77
\.


--
-- Data for Name: station; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.station (station_id, line, login_id, name, login_pw, role) FROM stdin;
7	1	samsung	삼성전자역	$2a$10$9ZWcPIIJEYk/dRT4HnRodOOA4HIDSz0D0somGWOTuAgQiTbpnY7/W	USER
1	1	ssafy	싸피역	$2a$10$h5nndIwVEuWwg0fdxEgJbOfluFgJdU8mCHWwuL4ABG/haXW4jbd7C	USER
\.


--
-- Data for Name: toilet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.toilet (toilet_id, man_dir, woman_dir, beacon_id) FROM stdin;
8	L	R	CA:8D:AC:9C:63:64
\.


--
-- Name: edge_edge_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edge_edge_id_seq', 61, true);


--
-- Name: elevator_elevator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.elevator_elevator_id_seq', 19, true);


--
-- Name: escalator_escalator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.escalator_escalator_id_seq', 1, false);


--
-- Name: exit_exit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exit_exit_id_seq', 29, true);


--
-- Name: gate_gate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gate_gate_id_seq', 32, true);


--
-- Name: point_point_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.point_point_id_seq', 4, true);


--
-- Name: screendoor_screendoor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.screendoor_screendoor_id_seq', 19, true);


--
-- Name: stair_stair_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stair_stair_id_seq', 23, true);


--
-- Name: station_station_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.station_station_id_seq', 47, true);


--
-- Name: toilet_toilet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.toilet_toilet_id_seq', 45, true);


--
-- Name: beacon beacon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beacon
    ADD CONSTRAINT beacon_pkey PRIMARY KEY (beacon_id);


--
-- Name: edge edge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edge
    ADD CONSTRAINT edge_pkey PRIMARY KEY (edge_id);


--
-- Name: elevator elevator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elevator
    ADD CONSTRAINT elevator_pkey PRIMARY KEY (elevator_id);


--
-- Name: escalator escalator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalator
    ADD CONSTRAINT escalator_pkey PRIMARY KEY (escalator_id);


--
-- Name: exit exit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exit
    ADD CONSTRAINT exit_pkey PRIMARY KEY (exit_id);


--
-- Name: gate gate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gate
    ADD CONSTRAINT gate_pkey PRIMARY KEY (gate_id);


--
-- Name: point point_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point
    ADD CONSTRAINT point_pkey PRIMARY KEY (point_id);


--
-- Name: screendoor screendoor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screendoor
    ADD CONSTRAINT screendoor_pkey PRIMARY KEY (screendoor_id);


--
-- Name: stair stair_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stair
    ADD CONSTRAINT stair_pkey PRIMARY KEY (stair_id);


--
-- Name: station station_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_pkey PRIMARY KEY (station_id);


--
-- Name: toilet toilet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toilet
    ADD CONSTRAINT toilet_pkey PRIMARY KEY (toilet_id);


--
-- Name: edge fk3rwyeay8u4vlpsvj8812frjgi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edge
    ADD CONSTRAINT fk3rwyeay8u4vlpsvj8812frjgi FOREIGN KEY (station_id) REFERENCES public.station(station_id);


--
-- Name: stair fk7kccnijicyt1aje53xxsqrhke; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stair
    ADD CONSTRAINT fk7kccnijicyt1aje53xxsqrhke FOREIGN KEY (beacon_id) REFERENCES public.beacon(beacon_id);


--
-- Name: elevator fk82v1oum6ckspxoutx6okd4w9c; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.elevator
    ADD CONSTRAINT fk82v1oum6ckspxoutx6okd4w9c FOREIGN KEY (beacon_id) REFERENCES public.beacon(beacon_id);


--
-- Name: escalator fkalyxkfej41ca9rt2mtdto0gdh; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.escalator
    ADD CONSTRAINT fkalyxkfej41ca9rt2mtdto0gdh FOREIGN KEY (beacon_id) REFERENCES public.beacon(beacon_id);


--
-- Name: exit fkbjo3rhav7gcr3n1uvr8j4id25; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exit
    ADD CONSTRAINT fkbjo3rhav7gcr3n1uvr8j4id25 FOREIGN KEY (beacon_id) REFERENCES public.beacon(beacon_id);


--
-- Name: edge fkdjfe8r1ll19rya4d3pc429w58; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edge
    ADD CONSTRAINT fkdjfe8r1ll19rya4d3pc429w58 FOREIGN KEY (beacon_id2) REFERENCES public.beacon(beacon_id);


--
-- Name: beacon fkeamiewuiajgaarr5slln7vp2b; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beacon
    ADD CONSTRAINT fkeamiewuiajgaarr5slln7vp2b FOREIGN KEY (station_id) REFERENCES public.station(station_id);


--
-- Name: gate fkfut9k279kvysl15xp8l8v05s4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gate
    ADD CONSTRAINT fkfut9k279kvysl15xp8l8v05s4 FOREIGN KEY (beacon_id) REFERENCES public.beacon(beacon_id);


--
-- Name: toilet fkg3h6cvhmde6kq44hs2qodaed0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.toilet
    ADD CONSTRAINT fkg3h6cvhmde6kq44hs2qodaed0 FOREIGN KEY (beacon_id) REFERENCES public.beacon(beacon_id);


--
-- Name: edge fkk1sh0axhjavibxjxtrhm0nfu1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.edge
    ADD CONSTRAINT fkk1sh0axhjavibxjxtrhm0nfu1 FOREIGN KEY (beacon_id1) REFERENCES public.beacon(beacon_id);


--
-- Name: point fkky3g2vg0fa2rt6amhuq67mxr6; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point
    ADD CONSTRAINT fkky3g2vg0fa2rt6amhuq67mxr6 FOREIGN KEY (beacon_id) REFERENCES public.beacon(beacon_id);


--
-- Name: screendoor fkopx33k24m71akdlekogs2gj8q; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.screendoor
    ADD CONSTRAINT fkopx33k24m71akdlekogs2gj8q FOREIGN KEY (beacon_id) REFERENCES public.beacon(beacon_id);


--
-- PostgreSQL database dump complete
--

