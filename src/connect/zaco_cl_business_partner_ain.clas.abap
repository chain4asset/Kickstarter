class ZACO_CL_BUSINESS_PARTNER_AIN definition
  public
  create public .

public section.

  methods GET_BP_ID_BY_NAME
    importing
      !IV_BP_NAME type ZACO_DE_BP_AIN
      !IV_RFCDEST type RFCDEST
    changing
      !CV_LOGHNDL type BALLOGHNDL optional
      value(CV_BP_ID) type STRING
      !CT_RESULT type ZACO_T_JSON_BODY .
  methods GET_BP_AIN
    importing
      !IV_TPLNR type TPLNR
      !IV_RFCDEST type RFCDEST
      !IV_BUSI_PAR type ZACO_DE_BP_AIN default 'NETZSCH_PS'
    changing
      !CV_LOGHNDL type BALLOGHNDL optional
      !CV_BP_ID type STRING
      !CT_RESULT type ZACO_T_JSON_BODY .
  methods GET_BWA_CUSTOMIZING
    importing
      !IV_TPLNR type TPLNR
    changing
      !CV_BWA_ON type CHAR1 default SPACE .
protected section.
private section.

  data GS_LOG type BAL_S_LOG .
  data GS_MSG type BAL_S_MSG .

  methods GET_BP_NAME_FOR_TPLNR
    importing
      !IV_TPLNR type TPLNR
    changing
      !CV_BP_NAME type ZACO_DE_BP_AIN .
ENDCLASS.



CLASS ZACO_CL_BUSINESS_PARTNER_AIN IMPLEMENTATION.


METHOD GET_BP_AIN.
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
  DATA: lv_name TYPE zaco_de_bp_ain.

  CALL METHOD me->get_bp_name_for_tplnr
    EXPORTING
      iv_tplnr   = iv_tplnr
    CHANGING
      cv_bp_name = lv_name.

  CALL METHOD me->get_bp_id_by_name
    EXPORTING
      iv_bp_name = lv_name
      iv_rfcdest = iv_rfcdest
    CHANGING
      cv_loghndl = cv_loghndl
      cv_bp_id   = cv_bp_id
      ct_result  = ct_result.
  IF cv_bp_id = space.
    CALL METHOD me->get_bp_id_by_name
      EXPORTING
        iv_bp_name = IV_BUSI_PAR
        iv_rfcdest = iv_rfcdest
      CHANGING
        cv_loghndl = cv_loghndl
        cv_bp_id   = cv_bp_id
        ct_result  = ct_result.
  ENDIF.




ENDMETHOD.


METHOD GET_BP_ID_BY_NAME.
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
*    aconn@nedge.com
*
*---------------------------------------------------------------------------*
  DATA: lo_http_client  TYPE REF TO if_http_client.

  DATA: lt_json         TYPE zaco_t_json_body.

  DATA: ls_result       TYPE zaco_s_json_body.
  DATA: ls_result_temp  TYPE zaco_s_json_body.

  DATA: lv_ok           TYPE boolean.
  DATA: lv_service      TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_rfcdest      TYPE rfcdest.
  DATA: lv_tabix        TYPE sy-tabix.

  IF cv_loghndl IS INITIAL.
    CALL METHOD zaco_cl_logs=>create_log_handler
      EXPORTING
        is_log     = gs_log
        iv_objekt  = 'EQUI'
      CHANGING
        cv_loghndl = cv_loghndl.
  ENDIF.
*--------
  CALL METHOD zaco_cl_connection_ain=>connect_to_ain
    EXPORTING
      iv_rfcdest               = iv_rfcdest
     CHANGING
      co_http_client           = lo_http_client
*      EXCEPTIONS
*        DEST_NOT_FOUND           = 1
*        DESTINATION_NO_AUTHORITY = 2
*        others                   = 3
          .
  IF sy-subrc <> 0.
    gs_msg-msgty = 'E'.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgno = '102'.  "Verbindung zu AIN System fehlgeschlagen.
    CALL METHOD zaco_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.
  ENDIF.

  CONCATENATE zaco_cl_connection_ain=>gv_service '/organizations/byrole?roleid=3' INTO lv_service.
  cl_http_utility=>set_request_uri( request = lo_http_client->request
                                       uri  = lv_service ).

  lo_http_client->request->set_method( 'GET' ).
  lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).

  lo_http_client->send(
    EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2
    http_processing_failed     = 3
    http_invalid_timeout       = 4
    OTHERS                     = 5 ).

  lo_http_client->receive(
    EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2
    http_processing_failed     = 3
    OTHERS                     = 4 ).

  lo_http_client->response->get_status( IMPORTING code   = lv_status_code
                                                  reason = lv_reason ).

  lv_json = lo_http_client->response->get_cdata( ).

  CALL METHOD zaco_cl_json=>json_to_data
    EXPORTING
      iv_json = lv_json
    CHANGING
      ct_data = ct_result.

  LOOP AT ct_result INTO ls_result.
    IF ls_result-name = 'organizationName' AND ls_result-value = iv_bp_name.
      lv_tabix = sy-tabix.
      lv_tabix = lv_tabix - 1.
      READ TABLE ct_result INTO ls_result_temp INDEX lv_tabix.
      IF sy-subrc = 0.
        cv_bp_id = ls_result_temp-value.
      ENDIF.
    ENDIF.

  ENDLOOP.

  CALL METHOD lo_http_client->close( ).

ENDMETHOD.


METHOD GET_BP_NAME_FOR_TPLNR.
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
  data: lv_tplnr type char30.

  CALL FUNCTION 'CONVERSION_EXIT_TPLNR_OUTPUT'
    EXPORTING
      input         = iv_tplnr
   IMPORTING
      OUTPUT        = lv_tplnr.

  SELECT SINGLE bp_ain FROM zaco_busi_par INTO cv_bp_name WHERE tplnr = lv_tplnr.

ENDMETHOD.


METHOD GET_BWA_CUSTOMIZING.
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
  DATA: ls_busi_par TYPE zaco_busi_par.

  SELECT SINGLE * FROM zaco_busi_par INTO ls_busi_par WHERE tplnr = iv_tplnr.
  IF sy-subrc = 0.
    IF ls_busi_par-bwa_vdi = space.
      cv_bwa_on = 'X'.
    ELSE.
      cv_bwa_on = space.
    ENDIF.
  ENDIF.

ENDMETHOD.
ENDCLASS.
