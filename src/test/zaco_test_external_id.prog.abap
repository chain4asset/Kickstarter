*&---------------------------------------------------------------------*
*& Report  ZACO_INITIAL_LOAD_EQUIPMENT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zaco_test_external_id.
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
DATA: lo_external       TYPE REF TO zaco_cl_external_ids.
DATA: lo_templates      TYPE REF TO zaco_cl_templates.


DATA: lt_equnr      TYPE STANDARD TABLE OF ltt_equnr.
DATA: lt_result     TYPE zaco_t_json_body.
DATA: lt_parameters TYPE zaco_tt_name_value.

DATA: ls_equnr        TYPE ltt_equnr.
DATA: ls_result       TYPE zaco_s_json_body.
DATA: ls_ext_ids      TYPE zaco_s_external_id.

DATA: lv_ok           TYPE char1.
DATA: lv_transferred  TYPE char1.
DATA: lv_equi_id      TYPE string.
DATA: lv_subrc        TYPE sy-subrc.
DATA: lv_loghndl      TYPE balloghndl.
DATA: lv_status       TYPE char1.
DATA: lv_systemid     TYPE zaco_de_extern_system_id.

SELECT-OPTIONS: sequnr FOR equi-equnr.
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
      CALL METHOD lo_equipment_ain->equipment_already_transferred
        EXPORTING
          iv_sernr        = ls_equnr-equnr
          iv_rfcdest      = prfcdest
        CHANGING
          cv_transferred  = lv_transferred
          cv_equipment_id = lv_equi_id
          ct_json         = lt_result.
      IF lv_transferred = 'X'.
        CREATE OBJECT lo_external.

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
*         Implement suitable error handling here
        ENDIF.

        CREATE OBJECT lo_templates
          EXPORTING
            io_http_client = lo_http_client.

        CALL METHOD lo_templates->get_external_system
          EXPORTING
            iv_syname       = sy-sysid
            iv_client       = '004'
            iv_rfcdest      = prfcdest
          CHANGING
            cv_systemid     = lv_systemid
            cv_ok           = lv_ok
          EXCEPTIONS
            no_system_found = 1
            OTHERS          = 2.
        IF sy-subrc <> 0.
*         Implement suitable error handling here
        ENDIF.


        ls_ext_ids-object_type = 'EQU'.
        ls_ext_ids-system_id = lv_systemid.
        ls_ext_ids-external_id = ls_equnr-equnr.
        ls_ext_ids-is_primary = '0'.

        CALL METHOD lo_external->add_external_id
          EXPORTING
            is_ext_id = ls_ext_ids.

        CALL METHOD lo_external->set_external_ids
          EXPORTING
            iv_rfcdest     = prfcdest
            iv_object_id   = lv_equi_id
            iv_object_type = 'EQU'
          CHANGING
            cv_ok          = lv_ok
*           cv_loghndl     = lv_loghndl
*           ct_return      = lt_return
          EXCEPTIONS
            no_data        = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.
*         Implement suitable error handling here
        ENDIF.


      ENDIF.

    ENDIF.
    FREE: lo_equipment_ain, lo_equipment.

  ENDLOOP.   "Equipments
  ULINE.
  WRITE:/ TEXT-013.
