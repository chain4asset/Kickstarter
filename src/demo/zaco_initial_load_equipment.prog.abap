*&---------------------------------------------------------------------*
*& Report  ZACO_INITIAL_LOAD_EQUIPMENT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zaco_initial_load_equipment.
*---------------------------------------------------------------------------*
*
*    Copyright (C) 2019 NETZSCH Pumps and Systems GmbH
*
*    This program is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*
*    NETZSCH Pumpen & Systeme GmbH
*    Geretsrieder Straße 1
*    84478 Waldkraiburg
*    Germany
*
*    aconn@nedgex.com
*
*---------------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Beschreibung: Es sollen nur gebaute Equipments übertragen werden
*& das machen wir daren fest ob eine Erstzteilstückliste erzeugt wurde.
*& Diese entsteht am Prüfstand und ist damit das untrügliche Zeichen für
*& ein erfolgreich gebautes Aggregat.
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Ersteller: Diemer Bernhard
* Datum: 23.02.2017
* Projekt: SAPAIN
*----------------------------------------------------------------------*
* Änderungsvermerk:
* Wer:          Wann:       Was:
*----------------------------------------------------------------------*

TABLES equi.

TYPES: BEGIN OF ltt_equnr,
         equnr TYPE equnr,
       END OF ltt_equnr.

DATA: lo_http_client    TYPE REF TO if_http_client.
DATA: lo_equipment_ain  TYPE REF TO zaco_cl_equipment_ain.
DATA: lo_equipment      TYPE REF TO zaco_cl_equip_erp.


DATA: lt_equnr      TYPE STANDARD TABLE OF ltt_equnr.
DATA: lt_result     TYPE zaco_t_json_body.
*DATA: lt_parameters TYPE zaco_tt_name_value.

DATA: ls_equnr        TYPE ltt_equnr.
DATA: ls_result       TYPE zaco_s_json_body.

DATA: lv_ok           TYPE char1.
DATA: lv_transferred  TYPE char1.
DATA: lv_equi_id      TYPE string.
DATA: lv_subrc        TYPE sy-subrc.
DATA: lv_loghndl      TYPE balloghndl.
DATA: lv_status       TYPE char1.


SELECT-OPTIONS: sequnr FOR equi-equnr.
parameters: pbuspa   type ZACO_DE_BP_AIN.
PARAMETERS: prfcdest TYPE rfcdest.


START-OF-SELECTION.
*---- Alle Equipments im System
  SELECT equnr FROM equi INTO ls_equnr-equnr WHERE equnr IN sequnr
                                              AND  lvorm = space.
    APPEND ls_equnr TO lt_equnr.
  ENDSELECT.

END-OF-SELECTION.

  CALL METHOD zaco_cl_connection_ain=>connect_to_ain
    EXPORTING
      iv_rfcdest               = prfcdest
    CHANGING
      co_http_client           = lo_http_client
    EXCEPTIONS
      dest_not_found           = 1
      destination_no_authority = 2
      OTHERS                   = 3.
  IF sy-subrc <> 0.
    MESSAGE e001(zpsain).
  ENDIF.
*--- ermitlle equipments mit Stückliste
  LOOP AT lt_equnr INTO ls_equnr.
    lv_subrc = 0.


    CREATE OBJECT lo_equipment.
    CALL METHOD lo_equipment->lese_equipment
      EXPORTING
        iv_equnr = ls_equnr-equnr
      CHANGING
        cv_ok    = lv_ok.
    IF lv_ok = 'X'.
      CREATE OBJECT lo_equipment_ain
        EXPORTING
          co_http_client = lo_http_client.

      CALL METHOD lo_equipment_ain->create_equipment
        EXPORTING
          io_equipment             = lo_equipment
          iv_rfcdest               = prfcdest
          iv_business_pa_std       = pbuspa
        CHANGING
          ct_result                = lt_result
          cv_loghndl               = lv_loghndl
        EXCEPTIONS
          no_model                 = 1
          no_modelid               = 2
          no_equipment_template_id = 3
          OTHERS                   = 4.


      IF lv_status = space.
*-------------------------------------
*       Ausgabe LT_RESULT ist noch zu designen
*---------------------------------------
        WRITE:/'***************************************'.
        WRITE:/ ls_equnr-equnr.
        WRITE:/'***************************************'.
        LOOP AT lt_result INTO ls_result.
          WRITE:/ ls_result-value.
        ENDLOOP.

      ENDIF. "Equipment bereits übertragen

    ENDIF.
    FREE: lo_equipment_ain, lo_equipment.

  ENDLOOP.   "Equipments
  ULINE.
  WRITE:/ TEXT-013.
