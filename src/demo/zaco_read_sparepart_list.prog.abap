*&---------------------------------------------------------------------*
*& Report  ZACO_INITIAL_LOAD_EQUIPMENT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zaco_read_sparepart_list.
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
*&
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Ersteller: Diemer Bernhard
* Datum: 01.10.2019
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
DATA: lt_spareparts TYPE zaco_tt_sparepart_list.

DATA: ls_equnr        TYPE ltt_equnr.
DATA: ls_spareparts   TYPE zaco_s_sparepart_list.

DATA: lv_ok           TYPE char1.
DATA: lv_transferred  TYPE char1.
DATA: lv_equi_id      TYPE string.
DATA: lv_subrc        TYPE sy-subrc.
DATA: lv_loghndl      TYPE balloghndl.
DATA: lv_status       TYPE char1.
DATA: lv_sernr        TYPE gernr.
DATA: lv_sernr_req    TYPE gernr.
DATA: lv_equipment_id TYPE string.

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
    lv_sernr = ls_equnr-equnr.
    lv_sernr_req = ls_equnr-equnr.
    IF lv_sernr_req(1) = 'X' AND lv_sernr_req+1(1) = '4'.
      lv_sernr_req(1) = 'D'.
    ENDIF.
    IF lv_sernr_req(1) = 'X'.
      SHIFT lv_sernr_req LEFT DELETING LEADING 'X'.
    ENDIF.

    CREATE OBJECT lo_equipment_ain
      EXPORTING
        co_http_client = lo_http_client.

    CALL METHOD lo_equipment_ain->equipment_already_transferred
      EXPORTING
        iv_sernr        = lv_sernr_req
        iv_rfcdest      = prfcdest
      CHANGING
        cv_transferred  = lv_transferred
        cv_equipment_id = lv_equipment_id
*       ct_json         =
      .
    IF lv_transferred = 'X'.
      CALL METHOD lo_equipment_ain->get_sparepart_list
        EXPORTING
          iv_equipment_id = lv_equipment_id
          iv_rfcdest      = prfcdest
        CHANGING
          ct_spareparts   = lt_spareparts.


    ENDIF.
    FREE: lo_equipment_ain, lo_equipment.

  ENDLOOP.   "Equipments
  ULINE.
  WRITE:/ TEXT-013.
