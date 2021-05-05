*&---------------------------------------------------------------------*
*& Report  ZACO_INITIAL_LOAD_EQUIPMENT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zaco_initial_load_material_stu.
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

TABLES eqst.

TYPES: BEGIN OF ltt_equnr,
         equnr TYPE equnr,
       END OF ltt_equnr.

DATA: lo_http_client    TYPE REF TO if_http_client.
DATA: lo_equipment      TYPE REF TO zaco_cl_equip_erp.
DATA: lo_equi_stue      TYPE REF TO zaco_cl_equip_erp_stueli.
DATA: lo_equi_stue_pos  TYPE REF TO zaco_cl_equip_erp_stueli_pos.
DATA: lo_material       TYPE REF TO zaco_cl_material.
DATA: lo_sparepart      TYPE REF TO zaco_cl_spareparts.

DATA: lt_equnr          TYPE STANDARD TABLE OF ltt_equnr.
DATA: lt_result         TYPE zaco_t_json_body.
*DATA: lt_parameters     TYPE zpsain_tt_name_value.
DATA: lt_position       TYPE zaco_tt_equi_stueli_pos.

DATA: ls_equnr          TYPE ltt_equnr.
DATA: ls_result         TYPE zaco_s_json_body.
DATA: ls_position       TYPE zaco_s_equi_stueli_pos.
DATA: ls_msg            TYPE bal_s_msg.

DATA: lv_ok             TYPE char1.
DATA: lv_matnr          TYPE matnr.
DATA: lv_werks          TYPE werks_d.
DATA: lv_transferred    TYPE char1.
DATA: lv_subrc          TYPE sy-subrc.
DATA: lv_loghndl        TYPE balloghndl.
DATA: lv_status         TYPE char1.


SELECT-OPTIONS: sequnr  FOR eqst-equnr.
PARAMETERS: pwerks      TYPE eqst-werks.
PARAMETERS: pstlan      TYPE eqst-stlan.
PARAMETERS: pbpname     TYPE zaco_de_bp_ain.
PARAMETERS: prfcdest    TYPE rfcdest.


START-OF-SELECTION.
*---- Alle Equipments im System
  SELECT equnr FROM eqst INTO ls_equnr-equnr WHERE equnr IN sequnr
                                              AND  werks = pwerks
                                              AND  stlan = pstlan.
    APPEND ls_equnr TO lt_equnr.
  ENDSELECT.

END-OF-SELECTION.

  DESCRIBE TABLE lt_equnr LINES sy-tfill.
  IF sy-tfill > 0.

    CALL METHOD zaco_cl_connection_ain=>connect_to_ain
      EXPORTING
        iv_rfcdest               = prfcdest
      CHANGING
        co_http_client           = lo_http_client
      EXCEPTIONS
        dest_not_found           = 1
        destination_no_authority = 2
        OTHERS                   = 3.
    CASE sy-subrc.
      WHEN '1'.
        ls_msg-msgid = 'ZACO'.
        ls_msg-msgty = 'E'.
        ls_msg-msgno = '001'.
        ls_msg-msgv1 = prfcdest.
        CALL METHOD zaco_cl_error_log=>write_error
          EXPORTING
            iv_msgty     = ls_msg-msgty
            iv_msgno     = ls_msg-msgno
            iv_msgid     = ls_msg-msgid
            iv_msgv1     = ls_msg-msgv1
            iv_err_group = 'DEST'.
      WHEN '2'.
        ls_msg-msgid = 'ZACO'.
        ls_msg-msgty = 'E'.
        ls_msg-msgno = '002'.
        ls_msg-msgv1 = prfcdest.
        CALL METHOD zaco_cl_error_log=>write_error
          EXPORTING
            iv_msgty     = ls_msg-msgty
            iv_msgno     = ls_msg-msgno
            iv_msgid     = ls_msg-msgid
            iv_msgv1     = ls_msg-msgv1
            iv_err_group = 'DEST'.
      WHEN '3'.
        ls_msg-msgid = 'ZACO'.
        ls_msg-msgty = 'E'.
        ls_msg-msgno = '003'.
        ls_msg-msgv1 = prfcdest.
        CALL METHOD zaco_cl_error_log=>write_error
          EXPORTING
            iv_msgty     = ls_msg-msgty
            iv_msgno     = ls_msg-msgno
            iv_msgid     = ls_msg-msgid
            iv_msgv1     = ls_msg-msgv1
            iv_err_group = 'DEST'.

    ENDCASE.
*--- ermitlle equipments mit Stückliste
    LOOP AT lt_equnr INTO ls_equnr.
      lv_subrc = 0.
      CREATE OBJECT lo_equipment.
      CREATE OBJECT lo_equi_stue.

      CALL METHOD lo_equipment->lese_equipment
        EXPORTING
          iv_equnr = ls_equnr-equnr
        CHANGING
          cv_ok    = lv_ok.
      IF lv_ok = 'X'.

        CALL METHOD lo_equi_stue->lese_positionen
          EXPORTING
            iv_equnr              = ls_equnr-equnr
            iv_werks              = pwerks
          EXCEPTIONS
            alt_not_found         = 1
            call_invalid          = 2
            equipment_not_found   = 3
            missing_authorization = 4
            no_bom_found          = 5
            no_plant_data         = 6
            no_suitable_bom_found = 7
            other_error           = 8
            OTHERS                = 9.
        IF sy-subrc <> 0.
          ls_msg-msgid = 'ZACO'.
          ls_msg-msgty = 'E'.
          ls_msg-msgno = '304'.
          ls_msg-msgv1 = ls_equnr-equnr.
          CALL METHOD zaco_cl_error_log=>write_error
            EXPORTING
              iv_msgty     = ls_msg-msgty
              iv_equnr     = ls_equnr-equnr
              iv_msgno     = ls_msg-msgno
              iv_msgid     = ls_msg-msgid
              iv_msgv1     = ls_msg-msgv1
              iv_err_group = 'EQUI'.
        ENDIF.
        CALL METHOD lo_equi_stue->get_positionen
          CHANGING
            ct_position = lt_position.
        CREATE OBJECT lo_sparepart.

        LOOP AT lt_position INTO ls_position.
          lo_equi_stue_pos ?= ls_position-lo_position.
          CALL METHOD lo_equi_stue_pos->get_matnr
            CHANGING
              cv_matnr = lv_matnr.
          CALL METHOD lo_equi_stue_pos->get_werks
            CHANGING
              cv_werks = lv_werks.
          IF lv_matnr NE space.
            CREATE OBJECT lo_material.
            CALL METHOD lo_material->set_matnr
              EXPORTING
                iv_matnr = lv_matnr
                iv_werks = lv_werks.

            CALL METHOD lo_sparepart->create_sparepart
              EXPORTING
                io_material = lo_material
                iv_rfcdest  = prfcdest
                iv_bp_name  = pbpname
              CHANGING
                ct_result   = lt_result.

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
              REFRESH lt_result.
            ENDIF. "
          ENDIF. " Keine Lagerposition mit Materialnummer
          FREE: lo_equi_stue_pos, lo_material.
        ENDLOOP.
        REFRESH: lt_position.
      ELSE.
        ls_msg-msgid = 'ZACO'.
        ls_msg-msgty = 'E'.
        ls_msg-msgno = '304'.
        ls_msg-msgv1 = ls_equnr-equnr.
        CALL METHOD zaco_cl_error_log=>write_error
          EXPORTING
            iv_msgty     = ls_msg-msgty
            iv_equnr     = ls_equnr-equnr
            iv_msgno     = ls_msg-msgno
            iv_msgid     = ls_msg-msgid
            iv_msgv1     = ls_msg-msgv1
            iv_err_group = 'EQUI'.
      ENDIF.
      FREE: lo_equipment, lo_equi_stue, lo_material.

    ENDLOOP.   "Equipments
  ELSE.
    ls_msg-msgid = 'ZACO'.
    ls_msg-msgty = 'E'.
    ls_msg-msgno = '304'.
    ls_msg-msgv1 = ls_equnr-equnr.
    CALL METHOD zaco_cl_error_log=>write_error
      EXPORTING
        iv_msgty     = ls_msg-msgty
        iv_equnr     = ls_equnr-equnr
        iv_msgno     = ls_msg-msgno
        iv_msgid     = ls_msg-msgid
        iv_msgv1     = ls_msg-msgv1
        iv_err_group = 'EQUI'.
  ENDIF. " Sy-tfill Zeilen Stückliste
  ULINE.
  WRITE:/ TEXT-013.
