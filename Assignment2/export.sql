--------------------------------------------------------
-- Archivo creado  - s�bado-noviembre-18-2017   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View INFORMACION_PACIENTE
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ADMINISTRADOR"."INFORMACION_PACIENTE" ("PACIENTE", "NOMBRE_PACIENTE", "DIRECCION", "FECHA", "TOTAL", "HABITACION") AS 
  (
select PACIENTES.ID_PACIENTE AS PACIENTE, PACIENTES.NOMBRE_PACIENTE AS NOMBRE_PACIENTE,
PACIENTES.DIRECCION AS DIRECCION, FACTURAS.FECHA_FACTURA AS FECHA, FACTURAS.TOTAL_FACTURA AS TOTAL,
SUM (SERVICIOS.VALOR_SERVICIO) AS Habitacion 
from servicios join DETALLE_FACTURAS on SERVICIOS.ID_SERVICIO = DETALLE_FACTURAS.SERVICIO_ID
JOIN CENTRO_DE_COSTOS ON CENTRO_DE_COSTOS.ID_CENTRO_COSTO = SERVICIOS.CENTRO_COSTO_ID JOIN FACTURAS
ON DETALLE_FACTURAS.FACTURA_ID = FACTURAS.ID_FACTURA JOIN PACIENTES 
ON FACTURAS.PACIENTE_ID = PACIENTES.ID_PACIENTE
WHERE CENTRO_DE_COSTOS.ID_CENTRO_COSTO ='2025'
GROUP BY PACIENTES.ID_PACIENTE, PACIENTES.NOMBRE_PACIENTE,
PACIENTES.DIRECCION, FACTURAS.FECHA_FACTURA, FACTURAS.TOTAL_FACTURA

)
;
--------------------------------------------------------
--  DDL for View P5_VIEW_INFORMATION_PATIENT
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "ADMINISTRADOR"."P5_VIEW_INFORMATION_PATIENT" ("ID_PACIENTE", "NOM_PACIENTE", "DIR_PACIENTE", "FECHA", "FECHA_INGRESO", "FECHA_SALIDA", "TOTAL_ITEMS_ROOM_BOARD", "TOTAL_VLR_FACTURA_ROMM_BOARD", "TOTAL_ITEMS_LABORATORY", "TOTAL_VLR_FACTURA_LABORATORY", "TOTAL_ITEMS_RADIOLOGY", "TOTAL_VLR_FACTURA_RADIOLOGY") AS 
  select
      tp.id_paciente as id_paciente
      ,tp.nombre_paciente as nom_paciente
      ,tp.direccion as dir_paciente
      ,tf.fecha_factura as fecha
      ,tf.fecha_ingreso as fecha_ingreso
      ,tf.fecha_salida as fecha_salida
      ,p4_total_bill_items(2025,tf.id_factura) as total_items_room_board -- cantidad de items del centro de costos 2005 Room and board y las facturas del paciente
      ,p4_total_bill_cost_center(2025,tf.id_factura) as total_vlr_factura_romm_board -- total factura del centro de costos 2005 room 2
      ,p4_total_bill_items(2027,tf.id_factura) as total_items_laboratory -- cantidad de items del centro de costos 2007 Laboratory y las facturas del paciente
      ,p4_total_bill_cost_center(2027,tf.id_factura) as total_vlr_factura_laboratory -- total factura del centro de costos 2007 Laboratory
      ,p4_total_bill_items(2022,tf.id_factura) as total_items_radiology -- cantidad de items del centro de costos 2002 Radiology y las facturas del paciente
      ,p4_total_bill_cost_center(2022,tf.id_factura) as total_vlr_factura_radiology -- total factura del centro de costos 2002 Radiology
    from
      pacientes tp
        inner join facturas tf
          on tf.paciente_id = tp.id_paciente
;
--------------------------------------------------------
--  DDL for Table CENTRO_DE_COSTOS
--------------------------------------------------------

  CREATE TABLE "ADMINISTRADOR"."CENTRO_DE_COSTOS" 
   (	"ID_CENTRO_COSTO" NUMBER, 
	"DESCRIPCION" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSPITAL_BILLS" ;
--------------------------------------------------------
--  DDL for Table DETALLE_FACTURAS
--------------------------------------------------------

  CREATE TABLE "ADMINISTRADOR"."DETALLE_FACTURAS" 
   (	"ID_DETALLE_FACTURA" NUMBER, 
	"FECHA_SERVICIO" DATE, 
	"FACTURA_ID" NUMBER, 
	"SERVICIO_ID" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSPITAL_BILLS" ;
--------------------------------------------------------
--  DDL for Table FACTURAS
--------------------------------------------------------

  CREATE TABLE "ADMINISTRADOR"."FACTURAS" 
   (	"ID_FACTURA" NUMBER, 
	"FECHA_FACTURA" DATE, 
	"FECHA_INGRESO" DATE, 
	"FECHA_SALIDA" DATE, 
	"PACIENTE_ID" NUMBER, 
	"TOTAL_FACTURA" NUMBER(*,0) DEFAULT 0
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSPITAL_BILLS" ;
--------------------------------------------------------
--  DDL for Table PACIENTES
--------------------------------------------------------

  CREATE TABLE "ADMINISTRADOR"."PACIENTES" 
   (	"ID_PACIENTE" NUMBER, 
	"NOMBRE_PACIENTE" VARCHAR2(50 BYTE), 
	"DIRECCION" VARCHAR2(30 BYTE), 
	"CODIGO_POSTAL" NUMBER(6,0), 
	"CIUDAD" VARCHAR2(30 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSPITAL_BILLS" ;
--------------------------------------------------------
--  DDL for Table SERVICIOS
--------------------------------------------------------

  CREATE TABLE "ADMINISTRADOR"."SERVICIOS" 
   (	"ID_SERVICIO" NUMBER, 
	"DESCRIPCION" VARCHAR2(30 BYTE), 
	"VALOR_SERVICIO" NUMBER(*,0), 
	"CENTRO_COSTO_ID" NUMBER, 
	"UNIDADES_DISPONIBLES" NUMBER DEFAULT 0
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSPITAL_BILLS" ;
REM INSERTING into ADMINISTRADOR.INFORMACION_PACIENTE
SET DEFINE OFF;
Insert into ADMINISTRADOR.INFORMACION_PACIENTE (PACIENTE,NOMBRE_PACIENTE,DIRECCION,FECHA,TOTAL,HABITACION) values ('26','Blaze Spencer','P.O. Box 309, 2865 Augue Ave',to_date('20/11/16','DD/MM/RR'),'130000','918000');
Insert into ADMINISTRADOR.INFORMACION_PACIENTE (PACIENTE,NOMBRE_PACIENTE,DIRECCION,FECHA,TOTAL,HABITACION) values ('27','Dorian Dickerson','Ap #454-1330 Adipiscing Road',to_date('28/11/17','DD/MM/RR'),'918000','561000');
REM INSERTING into ADMINISTRADOR.P5_VIEW_INFORMATION_PATIENT
SET DEFINE OFF;
Insert into ADMINISTRADOR.P5_VIEW_INFORMATION_PATIENT (ID_PACIENTE,NOM_PACIENTE,DIR_PACIENTE,FECHA,FECHA_INGRESO,FECHA_SALIDA,TOTAL_ITEMS_ROOM_BOARD,TOTAL_VLR_FACTURA_ROMM_BOARD,TOTAL_ITEMS_LABORATORY,TOTAL_VLR_FACTURA_LABORATORY,TOTAL_ITEMS_RADIOLOGY,TOTAL_VLR_FACTURA_RADIOLOGY) values ('21','Silas Richmond','2613 Et Rd',to_date('26/07/17','DD/MM/RR'),to_date('20/07/17','DD/MM/RR'),to_date('26/07/17','DD/MM/RR'),'0','0','1','1645000','0','0');
Insert into ADMINISTRADOR.P5_VIEW_INFORMATION_PATIENT (ID_PACIENTE,NOM_PACIENTE,DIR_PACIENTE,FECHA,FECHA_INGRESO,FECHA_SALIDA,TOTAL_ITEMS_ROOM_BOARD,TOTAL_VLR_FACTURA_ROMM_BOARD,TOTAL_ITEMS_LABORATORY,TOTAL_VLR_FACTURA_LABORATORY,TOTAL_ITEMS_RADIOLOGY,TOTAL_VLR_FACTURA_RADIOLOGY) values ('22','Chandler Duffy','Ap #532-8719 Laoreet Av',to_date('26/07/17','DD/MM/RR'),to_date('20/07/17','DD/MM/RR'),to_date('26/07/17','DD/MM/RR'),'0','0','1','80000','0','0');
Insert into ADMINISTRADOR.P5_VIEW_INFORMATION_PATIENT (ID_PACIENTE,NOM_PACIENTE,DIR_PACIENTE,FECHA,FECHA_INGRESO,FECHA_SALIDA,TOTAL_ITEMS_ROOM_BOARD,TOTAL_VLR_FACTURA_ROMM_BOARD,TOTAL_ITEMS_LABORATORY,TOTAL_VLR_FACTURA_LABORATORY,TOTAL_ITEMS_RADIOLOGY,TOTAL_VLR_FACTURA_RADIOLOGY) values ('23','Chase James','Ap #278-2826 Risus. Rd',to_date('08/05/17','DD/MM/RR'),to_date('01/05/17','DD/MM/RR'),to_date('08/05/17','DD/MM/RR'),'0','0','0','0','0','0');
Insert into ADMINISTRADOR.P5_VIEW_INFORMATION_PATIENT (ID_PACIENTE,NOM_PACIENTE,DIR_PACIENTE,FECHA,FECHA_INGRESO,FECHA_SALIDA,TOTAL_ITEMS_ROOM_BOARD,TOTAL_VLR_FACTURA_ROMM_BOARD,TOTAL_ITEMS_LABORATORY,TOTAL_VLR_FACTURA_LABORATORY,TOTAL_ITEMS_RADIOLOGY,TOTAL_VLR_FACTURA_RADIOLOGY) values ('24','Simon Noel','915-9465 Viverra. Av.',to_date('07/05/17','DD/MM/RR'),to_date('02/05/17','DD/MM/RR'),to_date('07/05/17','DD/MM/RR'),'0','0','0','0','0','0');
Insert into ADMINISTRADOR.P5_VIEW_INFORMATION_PATIENT (ID_PACIENTE,NOM_PACIENTE,DIR_PACIENTE,FECHA,FECHA_INGRESO,FECHA_SALIDA,TOTAL_ITEMS_ROOM_BOARD,TOTAL_VLR_FACTURA_ROMM_BOARD,TOTAL_ITEMS_LABORATORY,TOTAL_VLR_FACTURA_LABORATORY,TOTAL_ITEMS_RADIOLOGY,TOTAL_VLR_FACTURA_RADIOLOGY) values ('25','Ralph Marquez','P.O. Box 476, 8484 Dolor Road',to_date('04/09/17','DD/MM/RR'),to_date('30/08/17','DD/MM/RR'),to_date('04/09/17','DD/MM/RR'),'0','0','1','200000','0','0');
Insert into ADMINISTRADOR.P5_VIEW_INFORMATION_PATIENT (ID_PACIENTE,NOM_PACIENTE,DIR_PACIENTE,FECHA,FECHA_INGRESO,FECHA_SALIDA,TOTAL_ITEMS_ROOM_BOARD,TOTAL_VLR_FACTURA_ROMM_BOARD,TOTAL_ITEMS_LABORATORY,TOTAL_VLR_FACTURA_LABORATORY,TOTAL_ITEMS_RADIOLOGY,TOTAL_VLR_FACTURA_RADIOLOGY) values ('26','Blaze Spencer','P.O. Box 309, 2865 Augue Ave',to_date('20/11/16','DD/MM/RR'),to_date('04/11/16','DD/MM/RR'),to_date('20/11/16','DD/MM/RR'),'1','130000','0','0','0','0');
Insert into ADMINISTRADOR.P5_VIEW_INFORMATION_PATIENT (ID_PACIENTE,NOM_PACIENTE,DIR_PACIENTE,FECHA,FECHA_INGRESO,FECHA_SALIDA,TOTAL_ITEMS_ROOM_BOARD,TOTAL_VLR_FACTURA_ROMM_BOARD,TOTAL_ITEMS_LABORATORY,TOTAL_VLR_FACTURA_LABORATORY,TOTAL_ITEMS_RADIOLOGY,TOTAL_VLR_FACTURA_RADIOLOGY) values ('27','Dorian Dickerson','Ap #454-1330 Adipiscing Road',to_date('28/11/17','DD/MM/RR'),to_date('04/11/17','DD/MM/RR'),to_date('28/11/17','DD/MM/RR'),'1','918000','0','0','0','0');
Insert into ADMINISTRADOR.P5_VIEW_INFORMATION_PATIENT (ID_PACIENTE,NOM_PACIENTE,DIR_PACIENTE,FECHA,FECHA_INGRESO,FECHA_SALIDA,TOTAL_ITEMS_ROOM_BOARD,TOTAL_VLR_FACTURA_ROMM_BOARD,TOTAL_ITEMS_LABORATORY,TOTAL_VLR_FACTURA_LABORATORY,TOTAL_ITEMS_RADIOLOGY,TOTAL_VLR_FACTURA_RADIOLOGY) values ('28','Jesse Gonzalez','3388 Aliquam, Avenue',to_date('24/12/16','DD/MM/RR'),to_date('04/12/16','DD/MM/RR'),to_date('24/12/16','DD/MM/RR'),'0','0','0','0','0','0');
Insert into ADMINISTRADOR.P5_VIEW_INFORMATION_PATIENT (ID_PACIENTE,NOM_PACIENTE,DIR_PACIENTE,FECHA,FECHA_INGRESO,FECHA_SALIDA,TOTAL_ITEMS_ROOM_BOARD,TOTAL_VLR_FACTURA_ROMM_BOARD,TOTAL_ITEMS_LABORATORY,TOTAL_VLR_FACTURA_LABORATORY,TOTAL_ITEMS_RADIOLOGY,TOTAL_VLR_FACTURA_RADIOLOGY) values ('29','Drake Mullen','P.O. Box 995, 3039 Egestas Ave',to_date('25/04/17','DD/MM/RR'),to_date('22/04/17','DD/MM/RR'),to_date('26/04/17','DD/MM/RR'),'0','0','0','0','1','132600');
Insert into ADMINISTRADOR.P5_VIEW_INFORMATION_PATIENT (ID_PACIENTE,NOM_PACIENTE,DIR_PACIENTE,FECHA,FECHA_INGRESO,FECHA_SALIDA,TOTAL_ITEMS_ROOM_BOARD,TOTAL_VLR_FACTURA_ROMM_BOARD,TOTAL_ITEMS_LABORATORY,TOTAL_VLR_FACTURA_LABORATORY,TOTAL_ITEMS_RADIOLOGY,TOTAL_VLR_FACTURA_RADIOLOGY) values ('30','Elijah Bartlett','7389 Mauris Ave',to_date('06/01/17','DD/MM/RR'),to_date('01/01/17','DD/MM/RR'),to_date('06/01/17','DD/MM/RR'),'0','0','0','0','0','0');
REM INSERTING into ADMINISTRADOR.CENTRO_DE_COSTOS
SET DEFINE OFF;
Insert into ADMINISTRADOR.CENTRO_DE_COSTOS (ID_CENTRO_COSTO,DESCRIPCION) values ('2022','Radiologia');
Insert into ADMINISTRADOR.CENTRO_DE_COSTOS (ID_CENTRO_COSTO,DESCRIPCION) values ('2023','Cirugia');
Insert into ADMINISTRADOR.CENTRO_DE_COSTOS (ID_CENTRO_COSTO,DESCRIPCION) values ('2024','Fracturas');
Insert into ADMINISTRADOR.CENTRO_DE_COSTOS (ID_CENTRO_COSTO,DESCRIPCION) values ('2025','Habitaci�n y comida');
Insert into ADMINISTRADOR.CENTRO_DE_COSTOS (ID_CENTRO_COSTO,DESCRIPCION) values ('2026','Tratamiento');
Insert into ADMINISTRADOR.CENTRO_DE_COSTOS (ID_CENTRO_COSTO,DESCRIPCION) values ('2027','Laboratory');
Insert into ADMINISTRADOR.CENTRO_DE_COSTOS (ID_CENTRO_COSTO,DESCRIPCION) values ('2028','Laboratorio');
REM INSERTING into ADMINISTRADOR.DETALLE_FACTURAS
SET DEFINE OFF;
Insert into ADMINISTRADOR.DETALLE_FACTURAS (ID_DETALLE_FACTURA,FECHA_SERVICIO,FACTURA_ID,SERVICIO_ID) values ('3020',to_date('21/07/17','DD/MM/RR'),'6820','1020');
Insert into ADMINISTRADOR.DETALLE_FACTURAS (ID_DETALLE_FACTURA,FECHA_SERVICIO,FACTURA_ID,SERVICIO_ID) values ('3021',to_date('21/07/17','DD/MM/RR'),'6821','1022');
Insert into ADMINISTRADOR.DETALLE_FACTURAS (ID_DETALLE_FACTURA,FECHA_SERVICIO,FACTURA_ID,SERVICIO_ID) values ('3022',to_date('02/05/17','DD/MM/RR'),'6822','1021');
Insert into ADMINISTRADOR.DETALLE_FACTURAS (ID_DETALLE_FACTURA,FECHA_SERVICIO,FACTURA_ID,SERVICIO_ID) values ('3023',to_date('03/05/17','DD/MM/RR'),'6823','1024');
Insert into ADMINISTRADOR.DETALLE_FACTURAS (ID_DETALLE_FACTURA,FECHA_SERVICIO,FACTURA_ID,SERVICIO_ID) values ('3024',to_date('01/09/17','DD/MM/RR'),'6824','1025');
Insert into ADMINISTRADOR.DETALLE_FACTURAS (ID_DETALLE_FACTURA,FECHA_SERVICIO,FACTURA_ID,SERVICIO_ID) values ('3025',to_date('05/11/16','DD/MM/RR'),'6825','1026');
Insert into ADMINISTRADOR.DETALLE_FACTURAS (ID_DETALLE_FACTURA,FECHA_SERVICIO,FACTURA_ID,SERVICIO_ID) values ('3026',to_date('05/11/17','DD/MM/RR'),'6826','1027');
Insert into ADMINISTRADOR.DETALLE_FACTURAS (ID_DETALLE_FACTURA,FECHA_SERVICIO,FACTURA_ID,SERVICIO_ID) values ('3027',to_date('05/12/16','DD/MM/RR'),'6827','1028');
Insert into ADMINISTRADOR.DETALLE_FACTURAS (ID_DETALLE_FACTURA,FECHA_SERVICIO,FACTURA_ID,SERVICIO_ID) values ('3028',to_date('23/04/17','DD/MM/RR'),'6829','1030');
Insert into ADMINISTRADOR.DETALLE_FACTURAS (ID_DETALLE_FACTURA,FECHA_SERVICIO,FACTURA_ID,SERVICIO_ID) values ('3029',to_date('02/01/17','DD/MM/RR'),'6828','1034');
REM INSERTING into ADMINISTRADOR.FACTURAS
SET DEFINE OFF;
Insert into ADMINISTRADOR.FACTURAS (ID_FACTURA,FECHA_FACTURA,FECHA_INGRESO,FECHA_SALIDA,PACIENTE_ID,TOTAL_FACTURA) values ('6820',to_date('26/07/17','DD/MM/RR'),to_date('20/07/17','DD/MM/RR'),to_date('26/07/17','DD/MM/RR'),'21','1645000');
Insert into ADMINISTRADOR.FACTURAS (ID_FACTURA,FECHA_FACTURA,FECHA_INGRESO,FECHA_SALIDA,PACIENTE_ID,TOTAL_FACTURA) values ('6821',to_date('26/07/17','DD/MM/RR'),to_date('20/07/17','DD/MM/RR'),to_date('26/07/17','DD/MM/RR'),'22','80000');
Insert into ADMINISTRADOR.FACTURAS (ID_FACTURA,FECHA_FACTURA,FECHA_INGRESO,FECHA_SALIDA,PACIENTE_ID,TOTAL_FACTURA) values ('6822',to_date('08/05/17','DD/MM/RR'),to_date('01/05/17','DD/MM/RR'),to_date('08/05/17','DD/MM/RR'),'23','450000');
Insert into ADMINISTRADOR.FACTURAS (ID_FACTURA,FECHA_FACTURA,FECHA_INGRESO,FECHA_SALIDA,PACIENTE_ID,TOTAL_FACTURA) values ('6823',to_date('07/05/17','DD/MM/RR'),to_date('02/05/17','DD/MM/RR'),to_date('07/05/17','DD/MM/RR'),'24','720000');
Insert into ADMINISTRADOR.FACTURAS (ID_FACTURA,FECHA_FACTURA,FECHA_INGRESO,FECHA_SALIDA,PACIENTE_ID,TOTAL_FACTURA) values ('6824',to_date('04/09/17','DD/MM/RR'),to_date('30/08/17','DD/MM/RR'),to_date('04/09/17','DD/MM/RR'),'25','200000');
Insert into ADMINISTRADOR.FACTURAS (ID_FACTURA,FECHA_FACTURA,FECHA_INGRESO,FECHA_SALIDA,PACIENTE_ID,TOTAL_FACTURA) values ('6825',to_date('20/11/16','DD/MM/RR'),to_date('04/11/16','DD/MM/RR'),to_date('20/11/16','DD/MM/RR'),'26','130000');
Insert into ADMINISTRADOR.FACTURAS (ID_FACTURA,FECHA_FACTURA,FECHA_INGRESO,FECHA_SALIDA,PACIENTE_ID,TOTAL_FACTURA) values ('6826',to_date('28/11/17','DD/MM/RR'),to_date('04/11/17','DD/MM/RR'),to_date('28/11/17','DD/MM/RR'),'27','918000');
Insert into ADMINISTRADOR.FACTURAS (ID_FACTURA,FECHA_FACTURA,FECHA_INGRESO,FECHA_SALIDA,PACIENTE_ID,TOTAL_FACTURA) values ('6827',to_date('24/12/16','DD/MM/RR'),to_date('04/12/16','DD/MM/RR'),to_date('24/12/16','DD/MM/RR'),'28','450000');
Insert into ADMINISTRADOR.FACTURAS (ID_FACTURA,FECHA_FACTURA,FECHA_INGRESO,FECHA_SALIDA,PACIENTE_ID,TOTAL_FACTURA) values ('6828',to_date('25/04/17','DD/MM/RR'),to_date('22/04/17','DD/MM/RR'),to_date('26/04/17','DD/MM/RR'),'29','132600');
Insert into ADMINISTRADOR.FACTURAS (ID_FACTURA,FECHA_FACTURA,FECHA_INGRESO,FECHA_SALIDA,PACIENTE_ID,TOTAL_FACTURA) values ('6829',to_date('06/01/17','DD/MM/RR'),to_date('01/01/17','DD/MM/RR'),to_date('06/01/17','DD/MM/RR'),'30','400000');
REM INSERTING into ADMINISTRADOR.PACIENTES
SET DEFINE OFF;
Insert into ADMINISTRADOR.PACIENTES (ID_PACIENTE,NOMBRE_PACIENTE,DIRECCION,CODIGO_POSTAL,CIUDAD) values ('21','Silas Richmond','2613 Et Rd','80169','Florida');
Insert into ADMINISTRADOR.PACIENTES (ID_PACIENTE,NOMBRE_PACIENTE,DIRECCION,CODIGO_POSTAL,CIUDAD) values ('22','Chandler Duffy','Ap #532-8719 Laoreet Av','17990','Aubange');
Insert into ADMINISTRADOR.PACIENTES (ID_PACIENTE,NOMBRE_PACIENTE,DIRECCION,CODIGO_POSTAL,CIUDAD) values ('23','Chase James','Ap #278-2826 Risus. Rd','77885','Codogn�');
Insert into ADMINISTRADOR.PACIENTES (ID_PACIENTE,NOMBRE_PACIENTE,DIRECCION,CODIGO_POSTAL,CIUDAD) values ('24','Simon Noel','915-9465 Viverra. Av.','90539','Port Coquitlam');
Insert into ADMINISTRADOR.PACIENTES (ID_PACIENTE,NOMBRE_PACIENTE,DIRECCION,CODIGO_POSTAL,CIUDAD) values ('25','Ralph Marquez','P.O. Box 476, 8484 Dolor Road','37123','Lille');
Insert into ADMINISTRADOR.PACIENTES (ID_PACIENTE,NOMBRE_PACIENTE,DIRECCION,CODIGO_POSTAL,CIUDAD) values ('26','Blaze Spencer','P.O. Box 309, 2865 Augue Ave','88906','Burlington');
Insert into ADMINISTRADOR.PACIENTES (ID_PACIENTE,NOMBRE_PACIENTE,DIRECCION,CODIGO_POSTAL,CIUDAD) values ('27','Dorian Dickerson','Ap #454-1330 Adipiscing Road','80663','M�rfelden-Walldorf');
Insert into ADMINISTRADOR.PACIENTES (ID_PACIENTE,NOMBRE_PACIENTE,DIRECCION,CODIGO_POSTAL,CIUDAD) values ('28','Jesse Gonzalez','3388 Aliquam, Avenue','12704','Carson City');
Insert into ADMINISTRADOR.PACIENTES (ID_PACIENTE,NOMBRE_PACIENTE,DIRECCION,CODIGO_POSTAL,CIUDAD) values ('29','Drake Mullen','P.O. Box 995, 3039 Egestas Ave','32664','Nieuwkapelle');
Insert into ADMINISTRADOR.PACIENTES (ID_PACIENTE,NOMBRE_PACIENTE,DIRECCION,CODIGO_POSTAL,CIUDAD) values ('30','Elijah Bartlett','7389 Mauris Ave','58475','Bowden');
REM INSERTING into ADMINISTRADOR.SERVICIOS
SET DEFINE OFF;
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1020','glucosa','52785','2027','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1021','colesterol','80000','2026','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1022','trigliceridos','62100','2027','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1023','tomografia axial computarizada','156000','2022','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1024','resonancia magnetica','200000','2023','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1025','mamografia','134550','2027','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1026','traqueostomia','918000','2025','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1027','embarazo ectopico','561000','2025','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1028','varicocele','450000','2023','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1029','femur','820000','2024','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1030','tobillo','720000','2024','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1031','craneo','1014300','2027','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1032','dermatitis_acne','450000','2026','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1033','hipertension','132600','2025','0');
Insert into ADMINISTRADOR.SERVICIOS (ID_SERVICIO,DESCRIPCION,VALOR_SERVICIO,CENTRO_COSTO_ID,UNIDADES_DISPONIBLES) values ('1034','renal','260000','2022','0');
--------------------------------------------------------
--  DDL for Trigger P8_TRIGGER_UNID_DISPO
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "ADMINISTRADOR"."P8_TRIGGER_UNID_DISPO" 
  after insert --or update or delete
  on DETALLE_FACTURAS
  for each row

declare
     valor_ser number;
begin
   valor_ser:=0;
   begin


       select
         ts.unidades_disponibles
         into
         valor_ser
       from
         servicios ts
       where
         ts.id_servicio = :old.servicio_id;
   EXCEPTION
       WHEN OTHERS THEN null;
   end;
   begin
     if valor_ser <> 0 then
          update servicios ts
                 set ts.unidades_disponibles = ts.unidades_disponibles - 1
          where
                 ts.id_servicio = :old.servicio_id;
          commit;
     end if;
   EXCEPTION
   WHEN OTHERS THEN null;
   dbms_output.put_line('Se actualizaron: ' || valor_ser || ' registros.');
   end;

 end;
/
ALTER TRIGGER "ADMINISTRADOR"."P8_TRIGGER_UNID_DISPO" ENABLE;
--------------------------------------------------------
--  DDL for Procedure P9_INCREASE_COST_ITEMS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "ADMINISTRADOR"."P9_INCREASE_COST_ITEMS" 
 as
        id_cost NUMBER;
 BEGIN
 	begin
     id_cost := 0;
     --If the item belongs to Room and board cost center: 2%
     --consulta el id del centro de costos
     select tc.id_centro_costo into id_cost
      DBMS_OUTPUT.PUT_LINE('CUSTOMER: '||id_cost);
     from centro_de_costos tc
     where tc.descripcion like '%Habitaci�n y comida%';
     --actualiza el valor de los servicios del centro de costos buscado
     update servicios ts
       set ts.valor_servcio = ts.valor_servcio + (ts.valor_servcio * 2 / 100)
     where ts.centro_costo_id = id_cost;
     commit;
     EXCEPTION WHEN OTHERS THEN NULL;
   end;
   begin
     id_cost := 0;
     --If the item belongs to Laboratory: 3.5%
     --consulta el id del centro de costos
     select tc.id_centro_costo into id_cost
     from centro_de_costos tc
     where tc.descripcion like '%Laboratory%';
     --actualiza el valor de los servicios del centro de costos buscado
     update servicios ts
       set ts.valor_servcio = ts.valor_servcio + (ts.valor_servcio * 3.5 / 100)
     where ts.centro_costo_id = id_cost;
     commit;
     EXCEPTION WHEN OTHERS THEN NULL;    
   end;
   begin
     id_cost := 0;
     --If the item belongs to Radiology: 4%
     --consulta el id del centro de costos
     select tc.id_centro_costo into id_cost
     from centro_de_costos tc
     where tc.descripcion like '%Radiologia%';
     --actualiza el valor de los servicios del centro de costos buscado
     update servicios ts
       set ts.valor_servcio = ts.valor_servcio + (ts.valor_servcio * 4 / 100)
     where ts.centro_costo_id = id_cost;
     commit;
     EXCEPTION WHEN OTHERS THEN NULL;     
   end;
end;

/
--------------------------------------------------------
--  DDL for Function BALANCE_TOTAL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ADMINISTRADOR"."BALANCE_TOTAL" (centro_costo IN integer, cuenta_cod IN integer)
RETURN varchar2 AS
   total_suma number := 0;

/
--------------------------------------------------------
--  DDL for Function FINMIN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ADMINISTRADOR"."FINMIN" (x in number, y in number)
return number is
z number :=0;
begin
    if x  >=y then
        z :=y;
    else
      z :=x;
    end if;
    return z;
end;

declare
begin
    dbms_output.put_line('min between 15-20:'||finmin(20, 15));
end;

/
--------------------------------------------------------
--  DDL for Function P4_TOTAL_BILL_COST_CENTER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ADMINISTRADOR"."P4_TOTAL_BILL_COST_CENTER" (
                           cost_center_id IN NUMBER,
                           bill_id IN NUMBER)
RETURN NUMBER AS
   p_total NUMBER(25,4);
BEGIN
   p_total := 0;
    select
      sum(nvl(tf.total_factura,0)) as total_fac
      INTO
      p_total
    from
      facturas tf
        inner join detalle_facturas tdf
          on tdf.factura_id = tf.id_factura
        inner join servicios ts
          on ts.id_servicio = tdf.servicio_id
        inner join centro_de_costos  tc
          on tc.id_centro_costo = ts.centro_costo_id
    where
        tf.id_factura = bill_id
        and tc.id_centro_costo = cost_center_id;

   RETURN nvl(p_total,0);
EXCEPTION
   WHEN OTHERS THEN null;
END;

/
--------------------------------------------------------
--  DDL for Function P4_TOTAL_BILL_ITEMS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "ADMINISTRADOR"."P4_TOTAL_BILL_ITEMS" (
                                cost_center_id IN NUMBER,
                                bill_id IN NUMBER) RETURN NUMBER AS
   p_total NUMBER(25);
BEGIN
   p_total := 0;
    select
      count(nvl(tdf.servicio_id,0)) as total_items
      INTO
      p_total
    from
      facturas tf
        inner join detalle_facturas tdf
          on tdf.factura_id = tf.id_factura
        inner join servicios ts
          on ts.id_servicio = tdf.servicio_id
        inner join centro_de_costos  tc
          on tc.id_centro_costo = ts.centro_costo_id
    where
        tf.id_factura = bill_id
        and tc.id_centro_costo = cost_center_id;

   RETURN nvl(p_total,0);
EXCEPTION
   WHEN OTHERS THEN null;
END;

/
--------------------------------------------------------
--  Constraints for Table FACTURAS
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."FACTURAS" ADD PRIMARY KEY ("ID_FACTURA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSPITAL_BILLS"  ENABLE;
  ALTER TABLE "ADMINISTRADOR"."FACTURAS" MODIFY ("TOTAL_FACTURA" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."FACTURAS" MODIFY ("PACIENTE_ID" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."FACTURAS" MODIFY ("FECHA_SALIDA" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."FACTURAS" MODIFY ("FECHA_INGRESO" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."FACTURAS" MODIFY ("FECHA_FACTURA" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."FACTURAS" MODIFY ("ID_FACTURA" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table DETALLE_FACTURAS
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."DETALLE_FACTURAS" ADD PRIMARY KEY ("ID_DETALLE_FACTURA")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSPITAL_BILLS"  ENABLE;
  ALTER TABLE "ADMINISTRADOR"."DETALLE_FACTURAS" MODIFY ("SERVICIO_ID" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."DETALLE_FACTURAS" MODIFY ("FACTURA_ID" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."DETALLE_FACTURAS" MODIFY ("FECHA_SERVICIO" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."DETALLE_FACTURAS" MODIFY ("ID_DETALLE_FACTURA" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PACIENTES
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."PACIENTES" ADD PRIMARY KEY ("ID_PACIENTE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSPITAL_BILLS"  ENABLE;
  ALTER TABLE "ADMINISTRADOR"."PACIENTES" MODIFY ("CIUDAD" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."PACIENTES" MODIFY ("CODIGO_POSTAL" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."PACIENTES" MODIFY ("DIRECCION" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."PACIENTES" MODIFY ("NOMBRE_PACIENTE" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."PACIENTES" MODIFY ("ID_PACIENTE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CENTRO_DE_COSTOS
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."CENTRO_DE_COSTOS" ADD PRIMARY KEY ("ID_CENTRO_COSTO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSPITAL_BILLS"  ENABLE;
  ALTER TABLE "ADMINISTRADOR"."CENTRO_DE_COSTOS" MODIFY ("DESCRIPCION" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."CENTRO_DE_COSTOS" MODIFY ("ID_CENTRO_COSTO" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table SERVICIOS
--------------------------------------------------------

  ALTER TABLE "ADMINISTRADOR"."SERVICIOS" MODIFY ("UNIDADES_DISPONIBLES" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."SERVICIOS" ADD PRIMARY KEY ("ID_SERVICIO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSPITAL_BILLS"  ENABLE;
  ALTER TABLE "ADMINISTRADOR"."SERVICIOS" MODIFY ("CENTRO_COSTO_ID" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."SERVICIOS" MODIFY ("VALOR_SERVICIO" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."SERVICIOS" MODIFY ("DESCRIPCION" NOT NULL ENABLE);
  ALTER TABLE "ADMINISTRADOR"."SERVICIOS" MODIFY ("ID_SERVICIO" NOT NULL ENABLE);