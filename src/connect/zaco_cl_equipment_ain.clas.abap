class ZACO_CL_EQUIPMENT_AIN definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !CO_HTTP_CLIENT type ref to IF_HTTP_CLIENT optional .
  methods EQUIPMENT_ALREADY_TRANSFERRED
    importing
      !IV_SERNR type GERNR
      !IV_RFCDEST type RFCDEST
    changing
      !CV_TRANSFERRED type CHAR1
      !CV_EQUIPMENT_ID type STRING
      !CT_JSON type ZACO_T_JSON_BODY optional .
  methods UPDATE_EQUIPMENT
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
      !IV_RFCDEST type RFCDEST optional
      !IV_BUSINESS_PA_STD type ZACO_DE_BP_AIN
    changing
      value(CT_RESULT) type ZACO_T_JSON_BODY
      value(CV_HTTP_CODE) type I optional
      !CV_LOGHNDL type BALLOGHNDL optional
    exceptions
      NO_MODEL
      NO_MODELID
      NO_EQUIPMENT_TEMPLATE_ID .
  methods CREATE_EQUIPMENT
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
      !IV_RFCDEST type RFCDEST optional
      !IV_BUSINESS_PA_STD type ZACO_DE_BP_AIN
    changing
      value(CT_RESULT) type ZACO_T_JSON_BODY
      value(CV_HTTP_CODE) type I optional
      !CV_LOGHNDL type BALLOGHNDL optional
    exceptions
      NO_MODEL
      NO_MODELID
      NO_EQUIPMENT_TEMPLATE_ID .
  methods ADD_ALL_COMPONENTS
    importing
      !IO_EQUI_STUELI type ref to ZACO_CL_EQUIP_ERP_STUELI
      !IV_EQUNR type EQUNR
      !IV_RFCDEST type RFCDEST
    changing
      !CT_RESULT type ZACO_T_JSON_BODY .
  methods DELETE_EQUIPMENT
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
      !IV_RFCDEST type RFCDEST optional
    changing
      value(CT_RESULT) type ZACO_T_JSON_BODY
      !CV_LOGHNDL type BALLOGHNDL optional
    exceptions
      NO_EQUIPMENT .
protected section.
private section.

  types:
    begin of gtt_grnam,
           grnam type group,
           group_id type string,
         end of gtt_grnam .
  types:
    begin of gtt_attribute,
           atnam type atnam,
           attribute_id type string,
         end of gtt_attribute .

  data GO_HTTP_CLIENT type ref to IF_HTTP_CLIENT .
  data GS_LOG type BAL_S_LOG .
  data GS_MSG type BAL_S_MSG .
  data:
    GT_GRNAM type standard table of gtt_grnam .
  data:
    GT_ATTRIBUTE type standard table of gtt_attribute .

  methods NAME
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods MODELID
    importing
      !IV_MODELID type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods SERIALNUMBER
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods SHORT
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods LONG
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods OPERATORID
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
      !IV_RFCDEST type RFCDEST
      !IV_BUSINESSPARTNER_NAME type ZACO_DE_BP_AIN
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods SOURCEBPROLE
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods MODELKNOWN
    importing
      !IV_MODEL_KNOWN type CHAR1
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods LIFECYCLE
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods EQUIPMENT_TEMPLATE_ID
    importing
      !IV_TEMPLATE_ID type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods COMPONENT_ID
    importing
      !IV_MATNR_ID type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods COMPONENT_TYPE_PART
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods GET_TYPE
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
    changing
      value(CV_TYPE) type ZNTYP .
  methods CREATE_LOG_HANDLE
    changing
      !CV_LOGHNDL type BALLOGHNDL .
  methods GET_EQUIPMENT_TEMPLATE_ID
    importing
      !IO_EQUIPMENT type ref to ZPSPP_CL_EQUIPMENT
    changing
      !CV_TEMPL_ID type STRING
      !CV_LOGHNDL type BALLOGHNDL .
  methods GET_ATTRIBUTE_GROUP_ID
    importing
      !IV_GRNAM type GROUP
    changing
      !CV_LOGHNDL type BALLOGHNDL
      !CV_GROUP_ID type STRING .
  methods GET_ATTRIBUTE_ID
    importing
      !IV_ATNAM type ATNAM
    changing
      !CV_LOGHNDL type BALLOGHNDL
      !CV_ATTRIBUTE_ID type STRING .
  methods ATTRIBUTE_TEMPLATE
    importing
      !IV_TEMPLATE_ID type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods GROUP_ATTRIBUTE_TEMPLATE
    importing
      !IV_GROUP_ID type STRING
      !IV_PARENT type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods ATTRIBUTE
    importing
      !IV_ATTRIBUTE_ID type STRING
      !IV_PARENT type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods ATTRIBUTE_VALUE1
    importing
      !IV_ATTRIBUTE_VALUE1 type STRING
      !IV_PARENT type STRING
      !IV_ATTRIBUTE_UOM1 type ZACO_DE_EINHEIT
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods ATTRIBUTE_UOM1
    importing
      !IV_ATTRIBUTE_UOM1 type ZACO_DE_EINHEIT
      !IV_PARENT type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods ATTRIBUTE_MINVALUE1
    importing
      !IV_ATTRIBUTE_MINVALUE1 type STRING
      !IV_PARENT type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods ATTRIBUTE_MAXVALUE1
    importing
      !IV_ATTRIBUTE_MAXVALUE1 type STRING
      !IV_PARENT type STRING
      !IV_ATFOR type ATFOR
      !IV_ATTRIBUTE_UOM1 type ZACO_DE_EINHEIT
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods INTERNALID
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods BUILTDATE
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods ATTRIBUTE_VALUE_EVALUATION
    importing
      !IV_VALUE type STRING
      !IV_PARENT type STRING
      !IV_ATFOR type ATFOR
      !IV_ATTRIBUTE_UOM1 type ZACO_DE_EINHEIT
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods EQUIMENT_ID_OP
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods DATA_GATHERING
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
      !IV_RFCDEST type RFCDEST
      !IV_UPDKZ type CHAR1 default 'H'
      !IV_BUSINESS_PA_STD type ZACO_DE_BP_AIN
    changing
      !CT_JSON type ZACO_T_JSON_BODY
      !CV_LOGHNDL type BALLOGHNDL optional
    exceptions
      NO_MODEL
      NO_MODELID
      NO_EQUIPMENT_TEMPLATE_ID .
  methods TECHNISCHE_ID
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
ENDCLASS.



CLASS ZACO_CL_EQUIPMENT_AIN IMPLEMENTATION.


METHOD ADD_ALL_COMPONENTS.

  TYPES: BEGIN OF ltt_matnr_twice,
           matnr TYPE matnr,
         END OF ltt_matnr_twice.

  DATA: lo_http_client  TYPE REF TO if_http_client.
  DATA: lo_equi_pos     TYPE REF TO zaco_cl_equip_erp_stueli_pos.
  DATA: lo_spare        TYPE REF TO zaco_cl_spareparts.
  DATA: lo_equipment    TYPE REF TO zaco_cl_equip_erp.

  DATA: lt_json         TYPE zaco_t_json_body.
  DATA: lt_position     TYPE zaco_tt_equi_stueli_pos.
  DATA: lt_twice        TYPE STANDARD TABLE OF ltt_matnr_twice.

  DATA: ls_position     TYPE zaco_s_equi_stueli_pos.
  DATA: ls_twice        TYPE ltt_matnr_twice.

  DATA: lv_typbz        TYPE typbz.
  DATA: lv_nps_type     TYPE zaco_d_ntyp.
  DATA: lv_ok           TYPE boolean.
  DATA: lv_service      TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_equi_id      TYPE string.
  DATA: lv_transferred  TYPE char1.
  DATA: lv_matnr        TYPE matnr.
  DATA: lv_matnr_id     TYPE string.
  DATA: lv_sernr        TYPE gernr.

*-----------Check if Equipment exists in AIN
  CREATE OBJECT lo_equipment.
  CALL METHOD lo_equipment->lese_equipment
    EXPORTING
      iv_equnr = iv_equnr.

  CALL METHOD lo_equipment->get_sernr
    CHANGING
      cv_sernr = lv_sernr.

  CALL METHOD me->equipment_already_transferred
    EXPORTING
      iv_sernr        = lv_sernr
      iv_rfcdest      = iv_rfcdest
    CHANGING
      cv_transferred  = lv_transferred
      cv_equipment_id = lv_equi_id.

  IF lv_transferred = 'X'.
    CALL METHOD io_equi_stueli->get_positionen
      CHANGING
        ct_position = lt_position.
*--------
    CALL METHOD zaco_cl_connection_AIN=>connect_to_ain
*      EXPORTING
*        IV_RFCDEST               = 'AIN_TEST'
      CHANGING
        co_http_client           = lo_http_client
*      EXCEPTIONS
*        DEST_NOT_FOUND           = 1
*        DESTINATION_NO_AUTHORITY = 2
*        others                   = 3
            .
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

*    CREATE OBJECT lo_spare
*      EXPORTING
*        CO_HTTP_CLIENT = lo_http_client.

    LOOP AT lt_position INTO ls_position.
      lo_equi_pos ?= ls_position-lo_position.
      CALL METHOD lo_equi_pos->get_matnr
        CHANGING
          cv_matnr = lv_matnr.

      READ TABLE lt_twice INTO ls_twice WITH KEY matnr = lv_matnr.
      IF sy-subrc > 0.
        CALL METHOD lo_spare->spareparts_already_transferred
          EXPORTING
            iv_matnr       = lv_matnr
            iv_rfcdest     = iv_rfcdest
          CHANGING
            cv_transferred = lv_transferred
            cv_ain_part    = lv_matnr_id.
        IF lv_transferred = 'X'.
          CALL METHOD me->component_id
            EXPORTING
              iv_matnr_id = lv_matnr_id
            CHANGING
              ct_json     = lt_json.
*        CALL METHOD me->COMPONENT_TYPE_PART
*          CHANGING
*            CT_JSON = lt_json.
        ENDIF.
        ls_twice-matnr = lv_matnr.
        APPEND ls_twice TO lt_twice.
      ENDIF.
    ENDLOOP.
    FREE lo_http_client.
*--------------- Start new Sevice Connection

*--------
    CALL METHOD zaco_cl_connection_AIN=>connect_to_ain
*      EXPORTING
*        IV_RFCDEST               = 'AIN_TEST'
      CHANGING
        co_http_client           = lo_http_client
*      EXCEPTIONS
*        DEST_NOT_FOUND           = 1
*        DESTINATION_NO_AUTHORITY = 2
*        others                   = 3
            .
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

*-----------------------------------------------------------------------
* Set Request URI
*-----------------------------------------------------------------------
    CONCATENATE zaco_cl_connection_ain=>gv_service '/equipment(' lv_equi_id ')/components?type=PRT' INTO lv_service.
    cl_http_utility=>set_request_uri( request = lo_http_client->request
                                         uri  = lv_service ).

    lo_http_client->request->set_method( 'PUT' ).
    lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).

*-----------------------------------------------------------------------------------------------*

*           Bilden JSON Body und Request

*-----------------------------------------------------------------------------------------------*
    CALL METHOD zaco_cl_connection_ain=>construct_body
      EXPORTING
        it_body = lt_json
      CHANGING
        cv_body = lv_body.

    lo_http_client->request->set_cdata( lv_body ).
**-----------------------------------------------------------------------
** Send Request and Receive Response
**-----------------------------------------------------------------------
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

*-----------------------------------------------------------------------
* Refresh HTTP Request
*-----------------------------------------------------------------------
    lv_json = lo_http_client->response->get_cdata( ).
    CALL METHOD zaco_cl_json=>json_to_data
      EXPORTING
        iv_json = lv_json
      CHANGING
        ct_data = ct_result.

    CALL METHOD lo_http_client->close( ).
  ENDIF.   "transferred ID
ENDMETHOD.


method ATTRIBUTE.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'attributeId'.
  ls_json-value = iv_attribute_id.
  ls_json-parent_value = iv_parent.
  ls_json-parent = 'attributes'.
  ls_json-multiple = 'X'.
  ls_json-multiple_body = 'X'.
  ls_json-next = 'X'.
  ls_json-stufe = 2.
  append ls_json to ct_json.

endmethod.


METHOD ATTRIBUTE_MAXVALUE1.

  DATA: ls_json TYPE zaco_s_json_body.

  ls_json-name = 'maxValue1'.
  ls_json-value = iv_attribute_maxvalue1.
  ls_json-parent_value = iv_parent.
  ls_json-parent = 'attributes'.
  ls_json-multiple = 'X'.
  IF iv_attribute_uom1 = space.
    ls_json-last = 'X'.
  ENDIF.
  ls_json-stufe = 2.
  APPEND ls_json TO ct_json.

ENDMETHOD.


METHOD ATTRIBUTE_MINVALUE1.

  DATA: ls_json TYPE zaco_s_json_body.

  ls_json-name = 'minValue1'.
  ls_json-value = iv_attribute_minvalue1.
  ls_json-parent_value = iv_parent.
  ls_json-parent = 'attributes'.
  ls_json-multiple = 'X'.
  ls_json-multiple_body = 'X'.
  ls_json-stufe = 2.
  APPEND ls_json TO ct_json.

ENDMETHOD.


method ATTRIBUTE_TEMPLATE.

  data: ls_json type zaco_s_json_body.
  read table ct_json into ls_json with key value = iv_template_id.
  if sy-subrc > 0.
    ls_json-name = 'templateId'.
    ls_json-value = iv_template_id.
    ls_json-parent = 'templates'.
    ls_json-multiple = 'X'.
    ls_json-stufe = 0.
    append ls_json to ct_json.
  endif.
endmethod.


method ATTRIBUTE_UOM1.

  data: ls_json type zpsain_s_json_body.

  ls_json-name = 'uom1'.
  if iv_attribute_UOM1 ne space.
     ls_json-value = iv_attribute_UOM1.
  else.
      ls_json-value = ''.
  endif.
  ls_json-parent_value = iv_parent.
  ls_json-parent = 'attributes'.
  ls_json-multiple = 'X'.
  ls_json-multiple_body = 'X'.
  ls_json-last = 'X'.
  ls_json-stufe = 2.
  append ls_json to ct_json.

endmethod.


METHOD ATTRIBUTE_VALUE1.

  DATA: ls_json TYPE zaco_s_json_body.

  ls_json-name = 'value1'.
  ls_json-value = iv_attribute_value1.
  ls_json-parent_value = iv_parent.
  ls_json-parent = 'attributes'.
  ls_json-multiple = 'X'.
  ls_json-multiple_body = 'X'.
  IF iv_attribute_uom1 = space.
    ls_json-last = 'X'.
  ENDIF.
  ls_json-stufe = 2.
  APPEND ls_json TO ct_json.

ENDMETHOD.


METHOD ATTRIBUTE_VALUE_EVALUATION.

  DATA: lv_value      TYPE string.
  DATA: lv_min_value  TYPE string.
  DATA: lv_max_value  TYPE string.
  DATA: lv_rest1      TYPE string.
  DATA: lv_rest2      TYPE string.

  IF iv_value CA '-' and iv_atfor = 'NUM'.
    SPLIT iv_value AT '-' INTO: lv_min_value lv_rest1.
    SPLIT lv_rest1 AT '-' INTO: lv_max_value lv_rest2.
    SHIFT lv_max_value LEFT DELETING LEADING space.
    REPLACE ',' IN lv_min_value WITH '.'.
    REPLACE ',' IN lv_max_value WITH '.'.
    CALL METHOD me->attribute_minvalue1
      EXPORTING
        iv_attribute_minvalue1 = lv_min_value
        iv_parent              = iv_parent
      CHANGING
        ct_json                = ct_json.

    CALL METHOD me->attribute_maxvalue1
      EXPORTING
        iv_attribute_maxvalue1 = lv_max_value
        iv_parent              = iv_parent
        iv_atfor               = iv_atfor
        iv_attribute_uom1      = iv_attribute_uom1
      CHANGING
        ct_json                = ct_json.

  ELSE.
    lv_value = iv_value.
    REPLACE ',' IN lv_value WITH '.'.
    CALL METHOD me->attribute_value1
      EXPORTING
        iv_attribute_value1 = lv_value
        iv_parent           = iv_parent
        iv_attribute_uom1   = iv_attribute_uom1
      CHANGING
        ct_json             = ct_json.

  ENDIF.
ENDMETHOD.


METHOD BUILTDATE.

*----------------------------------------------------------------------------*

*     Derzeit gibt es noch keine Definition zur Ermittlung
*     des Betreibers deshalb immer Netzsch

*----------------------------------------------------------------------------*

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: lv_monat TYPE baumm.
  DATA: lv_jahr  TYPE baujj.
  DATA: lv_tag   TYPE char2 VALUE '15'.

  ls_json-name = 'buildDate'.
  CALL METHOD io_equipment->get_baujj
    CHANGING
      ic_baujj = lv_jahr.

  CALL METHOD io_equipment->get_baumm
    CHANGING
      ic_baumm = lv_monat.
  IF lv_jahr NE space.   "API verträgt keinen leeren Wert
    CONCATENATE lv_jahr '-' lv_monat '-' lv_tag INTO  ls_json-value.

    APPEND ls_json TO ct_json.
  ENDIF.
ENDMETHOD.


method COMPONENT_ID.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'id'.
  ls_json-value = iv_matnr_id.
  ls_json-parent = 'children'.
  ls_json-multiple = 'X'.
  ls_json-multiple_body = 'X'.
  append ls_json to ct_json.

endmethod.


method COMPONENT_TYPE_PART.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'cardinality'.
  ls_json-value = 'PRT'.
  ls_json-parent = 'children'.
  ls_json-multiple_body = 'X'.
  append ls_json to ct_json.

endmethod.


method CONSTRUCTOR.

    go_http_client ?= co_http_client.

endmethod.


METHOD CREATE_EQUIPMENT.

  DATA: lo_template     TYPE REF TO zaco_cl_templates.
  DATA: lo_http_client  TYPE REF TO if_http_client.
  DATA: lo_business_pa  TYPE REF TO zaco_cl_business_partner_ain.

  DATA: lt_json         TYPE zaco_t_json_body.

  DATA: ls_result       TYPE zaco_s_json_body.

  DATA: lv_typbz        TYPE typbz.
  DATA: lv_nps_type     TYPE zntyp.
  DATA: lv_ok           TYPE boolean.
  DATA: lv_modelname    TYPE zaco_de_modelname.
  DATA: lv_modelid      TYPE string.              "AIN Modell Id
  DATA: lv_service      TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_equnr        TYPE equnr.
  DATA: lv_rfcdest      TYPE rfcdest.
  DATA: lv_matnr        TYPE matnr.
  DATA: lv_tplnr        TYPE tplnr.

*-----------------------------------------------------------------------
* Set Request URI
*-----------------------------------------------------------------------
  CONCATENATE zaco_cl_connection_ain=>gv_service '/equipment' INTO lv_service.
  cl_http_utility=>set_request_uri( request = go_http_client->request
                                       uri  = lv_service ).

  go_http_client->request->set_method( 'POST' ).
  go_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).

  CALL METHOD me->data_gathering
    EXPORTING
      io_equipment             = io_equipment
      iv_rfcdest               = iv_rfcdest
      iv_business_pa_std       = iv_business_pa_std
    CHANGING
      ct_json                  = lt_json
      cv_loghndl               = cv_loghndl
    EXCEPTIONS
      no_model                 = 1
      no_modelid               = 2
      no_equipment_template_id = 3
      OTHERS                   = 4.
  IF sy-subrc <> 0.
    CASE sy-subrc.
      WHEN 1.
        gs_msg-msgty = 'E'.
        gs_msg-msgid = 'ZACO'.
        gs_msg-msgno = '136'.  "HTTP Fehler bei Übertragung
        gs_msg-msgv1 = lv_equnr.
        ls_result-name = 'Equipment'.
        ls_result-value = lv_equnr.
        APPEND ls_result TO ct_result.
        ls_result-name = 'Meldung'.
        ls_result-value = text-002.
        APPEND ls_result TO ct_result.
      WHEN 2.
        gs_msg-msgty = 'E'.
        gs_msg-msgid = 'ZACO'.
        gs_msg-msgno = '137'.  "HTTP Fehler bei Übertragung
        gs_msg-msgv1 = lv_equnr.
        ls_result-name = 'Equipment'.
        ls_result-value = lv_equnr.
        APPEND ls_result TO ct_result.
        ls_result-name = 'Meldung'.
        ls_result-value = text-003.
        APPEND ls_result TO ct_result.
      WHEN 3.
        gs_msg-msgty = 'E'.
        gs_msg-msgid = 'ZACO'.
        gs_msg-msgno = '138'.  "HTTP Fehler bei Übertragung
        gs_msg-msgv1 = lv_equnr.
        ls_result-name = 'Equipment'.
        ls_result-value = lv_equnr.
        APPEND ls_result TO ct_result.
        ls_result-name = 'Meldung'.
        ls_result-value = text-004.
        APPEND ls_result TO ct_result.
      WHEN OTHERS.
        gs_msg-msgty = 'E'.
        gs_msg-msgid = 'ZACO'.
        gs_msg-msgno = '139'.  "HTTP Fehler bei Übertragung
        gs_msg-msgv1 = lv_equnr.
        ls_result-name = 'Equipment'.
        ls_result-value = lv_equnr.
        APPEND ls_result TO ct_result.
        ls_result-name = 'Meldung'.
        ls_result-value = text-005.
        APPEND ls_result TO ct_result.
    ENDCASE.
    CALL METHOD zaco_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.
* Implement suitable error handling here
  ENDIF.
*-----------------------------------------------------------------------------------------------*

*           Bilden JSON Body und Request

*-----------------------------------------------------------------------------------------------*
  CALL METHOD zaco_cl_connection_ain=>construct_body
    EXPORTING
      it_body = lt_json
    CHANGING
      cv_body = lv_body.

  go_http_client->request->set_cdata( lv_body ).
**-----------------------------------------------------------------------
** Send Request and Receive Response
**-----------------------------------------------------------------------
  go_http_client->send(
    EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2
    http_processing_failed     = 3
    http_invalid_timeout       = 4
    OTHERS                     = 5 ).

  go_http_client->receive(
    EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2
    http_processing_failed     = 3
    OTHERS                     = 4 ).

  go_http_client->response->get_status( IMPORTING code   = lv_status_code
                                                  reason = lv_reason ).

*  if lv_status_code ne 200.
*-----------------------------------------------------------------------
* Refresh HTTP Request
*-----------------------------------------------------------------------
*  go_http_client->refresh_request( ).
  CALL METHOD io_equipment->get_equnr
    CHANGING
      cv_equnr = lv_equnr.
  IF lv_status_code NE 200.
    gs_msg-msgty = 'E'.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgno = '108'.  "HTTP Fehler bei Übertragung
    gs_msg-msgv1 = lv_equnr.
    gs_msg-msgv2 = lv_status_code.
    CALL METHOD zaco_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.

  ELSE.
    gs_msg-msgty = 'I'.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgno = '109'.  "Konnte erfolgreich übertragen werden
    gs_msg-msgv1 = lv_equnr.
    gs_msg-msgv2 = lv_status_code.
    CALL METHOD zaco_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.

  ENDIF.

  lv_json = go_http_client->response->get_cdata( ).
  CALL METHOD zaco_cl_json=>json_to_data
    EXPORTING
      iv_json = lv_json
    CHANGING
      ct_data = ct_result.
*  else.
*    refresh ct_result.
*  endif.
  CALL METHOD go_http_client->close( ).
ENDMETHOD.


method CREATE_LOG_HANDLE.

  data: ls_log type BAL_S_LOG.

  if cv_loghndl is initial.
    ls_log-extnumber = 'ZACOEQUIPMENT'.
    ls_log-object = 'ZACOEQUI'.
    ls_log-aldate = sy-datum.
    ls_log-altime = sy-uzeit.
    ls_log-aluser = sy-uname.
    ls_log-aldate_del = ( sy-datum + 30 ).  "4 Wochen

    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        I_S_LOG                 = ls_log
      IMPORTING
        E_LOG_HANDLE            = cv_loghndl
      EXCEPTIONS
        LOG_HEADER_INCONSISTENT = 1
        OTHERS                  = 2.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.

  endif.

endmethod.


METHOD data_gathering.

  DATA: lo_template     TYPE REF TO zaco_cl_templates.
  DATA: lo_http_client  TYPE REF TO if_http_client.
  DATA: lo_business_pa  TYPE REF TO zaco_cl_business_partner_ain.

  DATA: lt_json         TYPE zpsain_t_json_body.

  DATA: lv_typbz        TYPE typbz.
  DATA: lv_nps_type     TYPE zntyp.
  DATA: lv_ok           TYPE boolean.
  DATA: lv_modelname    TYPE zaco_de_modelname.
  DATA: lv_modelid      TYPE string.              "AIN Modell Id
  DATA: lv_service      TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_equnr        TYPE equnr.
  DATA: lv_rfcdest      TYPE rfcdest.
  DATA: lv_matnr        TYPE matnr.
  DATA: lv_kmatn        TYPE kmatn.
  DATA: lv_tplnr        TYPE tplnr.

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
      iv_rfcdest     = iv_rfcdest
    CHANGING
      co_http_client = lo_http_client
*      EXCEPTIONS
*     DEST_NOT_FOUND = 1
*     DESTINATION_NO_AUTHORITY = 2
*     others         = 3
    .
  IF sy-subrc <> 0.
    gs_msg-msgty = 'E'.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgno = '102'.  "Verbindung zu AIN System fehlgeschlagen.
    CALL METHOD zpsain_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.
  ENDIF.

*----- instanziiere template objekt
  CREATE OBJECT lo_template
    EXPORTING
      io_http_client = lo_http_client.

*------ ermittle name des aggregats  (equnr)
  CALL METHOD me->name
    EXPORTING
      io_equipment = io_equipment
    CHANGING
      ct_json      = lt_json.

*--------     Diesen Abschnitt aktivieren wenn Customizing fertig -----------------------*

  CALL METHOD me->get_type
    EXPORTING
      io_equipment = io_equipment
    CHANGING
      cv_type      = lv_nps_type.
*----------- Typenbezeichnung
  CALL METHOD me->technische_id
    EXPORTING
      io_equipment = io_equipment
    CHANGING
      ct_json      = lt_json.

  CALL METHOD io_equipment->get_matnr
    CHANGING
      cv_matnr = lv_matnr.

  CALL METHOD io_equipment->get_kmatn
    CHANGING
      cv_kmatn = lv_kmatn.

  CALL METHOD lo_template->get_model_name_by_material
    EXPORTING
      iv_matnr  = lv_matnr
      iv_kmatn  = lv_kmatn
    CHANGING
      ic_name   = lv_modelname
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.
*  IF sy-subrc <> 0.
*    RAISE no_model.
*  ENDIF.
*  ENDIF.
  IF sy-subrc = 0.
*---- Ermittle die AIN ID des Modells zum ermittleten Mamen.
    CALL METHOD lo_template->get_model_id_by_name
      EXPORTING
        iv_name     = lv_modelname
      CHANGING
        cv_model_id = lv_modelid
        cv_ok       = lv_ok.
**----Fehler wenn Ermittlung nicht OK
*  IF lv_ok = space.
*    RAISE no_modelid.
*  ENDIF.
  ENDIF.
  CALL METHOD lo_http_client->close( ).
*--------    Abschnitt Customizing fertig ENDE   --------------------------------------------*
*------ Übergebe Model Id
  CALL METHOD me->modelid
    EXPORTING
      iv_modelid = lv_modelid         "'06AC072934E44900B180B5D0D43E328D'         "lv_modelid
    CHANGING
      ct_json    = lt_json.
*----- Ermittle eineindeutige ID
  CALL METHOD me->internalid
    EXPORTING
      io_equipment = io_equipment
    CHANGING
      ct_json      = lt_json.
*------ Ermittle Serialnummer
  CALL METHOD me->serialnumber
    EXPORTING
      io_equipment = io_equipment
    CHANGING
      ct_json      = lt_json.
*------ Ermittle Kurztext
  CALL METHOD me->short
    EXPORTING
      io_equipment = io_equipment
    CHANGING
      ct_json      = lt_json.
*------- Ermiitle Langtext
  CALL METHOD me->long                  "derzeit leer weil nicht definiert
    EXPORTING
      io_equipment = io_equipment
    CHANGING
      ct_json      = lt_json.
*------  Modell bekannt
  IF iv_updkz EQ 'H' AND lv_modelid NE space.
    CALL METHOD me->modelknown
      EXPORTING
        iv_model_known = 'X'
      CHANGING
        ct_json        = lt_json.
  ELSE.
    CALL METHOD me->modelknown
      EXPORTING
        iv_model_known = ''
      CHANGING
        ct_json        = lt_json.
  ENDIF.
*------ Betreiber ID

  CALL METHOD me->operatorid
    EXPORTING
      io_equipment            = io_equipment
      iv_rfcdest              = lv_rfcdest
      iv_businesspartner_name = iv_business_pa_std
    CHANGING
      ct_json                 = lt_json.
*-------- Equipment ID Betreiber
  CALL METHOD me->equiment_id_op
    EXPORTING
      io_equipment = io_equipment
    CHANGING
      ct_json      = lt_json.
*---- Lifecycle
  IF iv_updkz = 'H'.
    CALL METHOD me->lifecycle          "derzeit hart codiert weil Equipment erst transferiert wird wenn gebaut.
      CHANGING
        ct_json = lt_json.
  ENDIF.
*------- Betereiber Rolle
  CALL METHOD me->sourcebprole        "derezit immer Hersetller
    EXPORTING
      io_equipment = io_equipment
    CHANGING
      ct_json      = lt_json.
*----- Baujahr und Monat Tag immer 15
  CALL METHOD me->builtdate
    EXPORTING
      io_equipment = io_equipment
    CHANGING
      ct_json      = lt_json.

  ct_json[] = lt_json[].
ENDMETHOD.


METHOD delete_equipment.

  DATA: lo_template     TYPE REF TO zaco_cl_templates.

  DATA: lv_json         TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_ok           TYPE boolean.
  DATA: lv_id           TYPE string.              "AIN Modell Id
  DATA: lv_equnr        TYPE equnr.
  DATA: lv_service      TYPE string.
  DATA: lv_sernr        TYPE gernr.

  IF cv_loghndl IS INITIAL.
    CALL METHOD zaco_cl_logs=>create_log_handler
      EXPORTING
        is_log     = gs_log
        iv_objekt  = 'EQUI'
      CHANGING
        cv_loghndl = cv_loghndl.
  ENDIF.
**--------

  CALL METHOD io_equipment->get_equnr
    CHANGING
      cv_equnr = lv_equnr.

  CALL METHOD io_equipment->get_sernr
    CHANGING
      cv_sernr = lv_sernr.

  CALL METHOD me->equipment_already_transferred
    EXPORTING
      iv_sernr        = lv_sernr
      iv_rfcdest      = iv_rfcdest
    CHANGING
      cv_transferred  = lv_ok
      cv_equipment_id = lv_id.

  IF lv_ok NE 'X'.
    gs_msg-msgty = 'E'.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgno = '110'.  "Equipment noch nciht übertragen
    gs_msg-msgv1 = lv_equnr.
    CALL METHOD zaco_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.
    RAISE no_equipment.
  ENDIF.
*-----------------------------------------------------------------------
* Set Request URI
*-----------------------------------------------------------------------
  CONCATENATE zaco_cl_connection_ain=>gv_service '/equipment(' lv_id ')' INTO lv_service.
  cl_http_utility=>set_request_uri( request = go_http_client->request
                                       uri  = lv_service ).

  go_http_client->request->set_method( 'DELETE' ).
  go_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).

**-----------------------------------------------------------------------
** Send Request and Receive Response
**-----------------------------------------------------------------------
  go_http_client->send(
    EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2
    http_processing_failed     = 3
    http_invalid_timeout       = 4
    OTHERS                     = 5 ).

  go_http_client->receive(
    EXCEPTIONS
    http_communication_failure = 1
    http_invalid_state         = 2
    http_processing_failed     = 3
    OTHERS                     = 4 ).

  go_http_client->response->get_status( IMPORTING code   = lv_status_code
                                                  reason = lv_reason ).

*  if lv_status_code ne 200.
*-----------------------------------------------------------------------
* Refresh HTTP Request
*-----------------------------------------------------------------------
  IF lv_status_code NE 200.
    gs_msg-msgty = 'E'.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgno = '108'.  "HTTP Fehler bei Übertragung
    gs_msg-msgv1 = lv_equnr.
    gs_msg-msgv2 = lv_status_code.
    CALL METHOD zaco_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.
  ELSE.
    gs_msg-msgty = 'I'.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgno = '113'.  "Equipment &1 konnte erfolgreich gelöscht werden.
    gs_msg-msgv1 = lv_equnr.
    gs_msg-msgv2 = lv_status_code.
    CALL METHOD zaco_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.

  ENDIF.

  lv_json = go_http_client->response->get_cdata( ).
  CALL METHOD zaco_cl_json=>json_to_data
    EXPORTING
      iv_json = lv_json
    CHANGING
      ct_data = ct_result.
*  else.
*    refresh ct_result.
*  endif.

ENDMETHOD.


METHOD equiment_id_op.

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: lv_invnr TYPE invnr.

  CALL METHOD io_equipment->get_invnr
    CHANGING
      cv_invnr = lv_invnr.
  IF lv_invnr NE space.
    ls_json-name = 'secondaryKey'.
    ls_json-value = lv_invnr.
    APPEND ls_json TO ct_json.
  ENDIF.

ENDMETHOD.


METHOD equipment_already_transferred.

  DATA: lo_http_client TYPE REF TO if_http_client.

  DATA: ls_result       TYPE zaco_s_json_body.

  DATA: lv_service      TYPE string.
  DATA: lv_filter       TYPE string.

  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_length       TYPE i.

  CALL METHOD zpsain_cl_connection=>connect_to_ain
    EXPORTING
      iv_rfcdest               = iv_rfcdest
    CHANGING
      co_http_client           = lo_http_client
    EXCEPTIONS
      dest_not_found           = 1
      destination_no_authority = 2
      OTHERS                   = 3.

  lv_filter = |/equipment?$filter=serialNumber eq '|.

  CONCATENATE zaco_cl_connection_ain=>gv_service lv_filter iv_sernr '''' INTO lv_service.

  cl_http_utility=>set_request_uri( request = lo_http_client->request
                                    uri  = lv_service ).

  lo_http_client->request->set_method( 'GET' ).

*-----------------------------------------------------------------------
* Send Request and Receive Response
*-----------------------------------------------------------------------
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

  IF lv_status_code EQ '200'.
    lv_json = lo_http_client->response->get_cdata( ).

*------------ Lv_json deserialisieren und equipmentId filtern   ----------------*
    CALL METHOD zaco_cl_json=>json_to_data
      EXPORTING
        iv_json = lv_json
      CHANGING
        ct_data = ct_json.

    lv_length = strlen( lv_json ).
    IF lv_length > 2.
      cv_transferred = 'X'.
    ELSE.
      cv_transferred = space.
    ENDIF.
  ELSE.
    cv_transferred = space.
  ENDIF.
  READ TABLE ct_json INTO ls_result WITH KEY name = 'equipmentId'.
  IF sy-subrc = 0.
    cv_equipment_id = ls_result-value.
  ELSE.
    cv_transferred = space.
  ENDIF.

  lo_http_client->close( ).
ENDMETHOD.


method EQUIPMENT_TEMPLATE_ID.

  data: ls_json  type zpsain_s_json_body.

  ls_json-name = 'id'.
  ls_json-value = iv_template_id.
  ls_json-parent = 'templates'.
  ls_json-multiple = 'X'.
  ls_json-multiple_body = 'X'.
  append ls_json to ct_json.

endmethod.


METHOD get_attribute_group_id.

  DATA: lo_http_client TYPE REF TO if_http_client.
  DATA: lo_templates   TYPE REF TO zaco_cl_templates.

  DATA: ls_grnam TYPE gtt_grnam.

  DATA: lv_ok    TYPE char1.

  READ TABLE gt_grnam INTO ls_grnam WITH KEY grnam = iv_grnam.
  IF sy-subrc > 0.
*----- Ermittle Template ID
    CALL METHOD zaco_cl_connection_ain=>connect_to_ain
      CHANGING
        co_http_client           = lo_http_client
      EXCEPTIONS
        dest_not_found           = 1
        destination_no_authority = 2
        OTHERS                   = 3.
    IF sy-subrc <> 0.
*message i102(ZPSAIN)
      gs_msg-msgty = 'E'.
      gs_msg-msgid = 'ZPSAIN'.
      gs_msg-msgno = '102'.  "Verbindung zu AIN System fehlgeschlagen.
      CALL METHOD zaco_cl_logs=>add_log_entry
        EXPORTING
          is_msg     = gs_msg
          iv_loghndl = cv_loghndl.
    ELSE.
      CREATE OBJECT lo_templates
        EXPORTING
          io_http_client = lo_http_client.

      CALL METHOD lo_templates->get_group_id_by_name
        EXPORTING
          iv_name     = iv_grnam
        CHANGING
          cv_group_id = cv_group_id
          cv_ok       = lv_ok.
      ls_grnam-grnam = iv_grnam.
      ls_grnam-group_id = cv_group_id.
      APPEND ls_grnam TO gt_grnam.
    ENDIF.
  ELSE.
    cv_group_id = ls_grnam-group_id.
  ENDIF.

ENDMETHOD.


method GET_ATTRIBUTE_ID.

  data: lo_http_client type ref to if_http_client.
  data: lo_http_client2 type ref to if_http_client.
  data: lo_templates   type ref to zaco_cl_templates.

  data: ls_attribute type gtt_attribute.

  data: lv_ok    type char1.

  read table gt_attribute into ls_attribute with key atnam = iv_atnam.
  if sy-subrc > 0.
*----- Ermittle Template ID
    CALL METHOD ZAco_CL_CONNECTION_ain=>CONNECT_TO_AIN
      CHANGING
        CO_HTTP_CLIENT           = lo_http_client
      EXCEPTIONS
        DEST_NOT_FOUND           = 1
        DESTINATION_NO_AUTHORITY = 2
        others                   = 3.
    IF SY-SUBRC <> 0.
*message i102(ZPSAIN)
      gs_msg-msgty = 'E'.
      gs_msg-msgid = 'ZPSAIN'.
      gs_msg-msgno = '102'.  "Verbindung zu AIN System fehlgeschlagen.
      CALL METHOD ZACO_CL_LOGS=>ADD_LOG_ENTRY
        EXPORTING
          IS_MSG     = gs_msg
          IV_LOGHNDL = cv_loghndl.
    else.
*----- Ermittle Template ID
      CALL METHOD ZACO_CL_CONNECTION_AIN=>CONNECT_TO_AIN
        CHANGING
          CO_HTTP_CLIENT           = lo_http_client2
        EXCEPTIONS
          DEST_NOT_FOUND           = 1
          DESTINATION_NO_AUTHORITY = 2
          others                   = 3.
      CREATE OBJECT lo_templates
        EXPORTING
          IO_HTTP_CLIENT = lo_http_client2.
      CALL METHOD lo_templates->GET_ATTRIBUTE_ID_BY_NAME
        EXPORTING
          IV_NAME         = iv_atnam
        CHANGING
          CV_ATTRIBUTE_ID = cv_attribute_id
          CV_OK           = lv_ok.
      if lv_ok ne space.
        ls_attribute-atnam = iv_atnam.
        ls_attribute-attribute_id = cv_attribute_id.
        append ls_attribute to gt_attribute.
      else.
        clear cv_attribute_id.
      endif.
    ENDIF.
  else.
    cv_attribute_id = ls_attribute-attribute_id.
  endif.
  free: lo_http_client, lo_http_client2.
endmethod.


method GET_EQUIPMENT_TEMPLATE_ID.

*  data: lo_http_client type ref to if_http_client.
*  data: lo_templates   type ref to zpsain_cl_templates.
*
*  data: lv_typbz type typbz.
*  data: lv_name  type ZNPS_D_EQUIMODEL.
*  data: lv_ok    type char1.
*
**----- Ermittle Template ID
*  CALL METHOD ZPSAIN_CL_CONNECTION=>CONNECT_TO_AIN
*    CHANGING
*      CO_HTTP_CLIENT           = lo_http_client
*    EXCEPTIONS
*      DEST_NOT_FOUND           = 1
*      DESTINATION_NO_AUTHORITY = 2
*      others                   = 3.
*  IF SY-SUBRC <> 0.
**message i102(ZPSAIN)
*    gs_msg-msgty = 'E'.
*    gs_msg-msgid = 'ZPSAIN'.
*    gs_msg-msgno = '102'.  "Verbindung zu AIN System fehlgeschlagen.
*    CALL METHOD ZPSAIN_CL_LOGS=>ADD_LOG_ENTRY
*      EXPORTING
*        IS_MSG     = gs_msg
*        IV_LOGHNDL = cv_loghndl.
*  ENDIF.
*
*  CREATE OBJECT lo_templates
*    EXPORTING
*      IO_HTTP_CLIENT = lo_http_client.
*
*  CALL METHOD io_equipment->GET_TYPBZ
*    CHANGING
*      IC_TYPBZ = lv_typbz.
*
*  CALL METHOD lo_templates->GET_EQUIPMENT_NAME_BY_TYPE
*    EXPORTING
*      IV_TYPE      = lv_typbz
*    CHANGING
*      IC_EQUI_NAME = lv_name
*    EXCEPTIONS
*      NOT_FOUND    = 1
*      others       = 2.
*  IF SY-SUBRC <> 0.
**   Implement suitable error handling here
*  ENDIF.
*
*  CALL METHOD lo_templates->GET_EQUIPMENT_ID_BY_NAME
*    EXPORTING
*      IV_NAME     = lv_name
*    CHANGING
*      CV_MODEL_ID = cv_templ_id
*      CV_OK       = lv_ok.


endmethod.


method GET_TYPE.

  data: lv_typbz type typbz.

  CALL METHOD io_equipment->GET_TYPBZ
    CHANGING
      IC_TYPBZ = lv_typbz.

  cv_type = lv_typbz.
endmethod.


method GROUP_ATTRIBUTE_TEMPLATE.

  data: ls_json type zaco_s_json_body.
  read table ct_json into ls_json with key value = iv_group_id.
  if sy-subrc > 0.
    ls_json-name = 'attributeGroupId'.
    ls_json-value = iv_group_id.
    ls_json-parent_value = iv_parent.
    ls_json-parent = 'attributeGroups'.
    ls_json-multiple = 'X'.
    ls_json-multiple_body = 'X'.
    ls_json-stufe = 1.
    append ls_json to ct_json.
  endif.

endmethod.


METHOD internalid.

  DATA: ls_json TYPE zaco_s_json_body.

  DATA: lv_equnr TYPE equnr.
  DATA: lv_sonder TYPE string.
  DATA: lv_invnr TYPE invnr.

  lv_sonder = |/|.

  CALL METHOD io_equipment->get_invnr
    CHANGING
      cv_invnr = lv_invnr.
  IF lv_invnr = space.
    CALL METHOD io_equipment->get_equnr
      CHANGING
        cv_equnr = lv_equnr.
*    CONCATENATE io_equipment->gc_url lv_sonder lv_equnr INTO ls_json-value.
    ls_json-value = lv_equnr.
  ELSE.
    ls_json-value = lv_invnr.           "Operator Equipment ID
  ENDIF.
  ls_json-name = 'internalId'.
  APPEND ls_json TO ct_json.

ENDMETHOD.


method LIFECYCLE.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'lifeCycle'.
  ls_json-value = '2'.
  append ls_json to ct_json.

endmethod.


method LONG.

  data: ls_json type zaco_s_json_body.
*---------- Leer
  ls_json-name = 'long'.
  ls_json-value = space.
  ls_json-parent = 'description'.
  append ls_json to ct_json.

endmethod.


METHOD modelid.

  DATA: ls_json  TYPE zaco_s_json_body.
  IF iv_modelid NE space.
    ls_json-name = 'modelId'.
    ls_json-value = iv_modelid.
    APPEND ls_json TO ct_json.
  ENDIF.
ENDMETHOD.


method MODELKNOWN.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'modelKnown'.
  if iv_model_known = 'X'.
     ls_json-value = 'true'.
  else.
    ls_json-value = 'false'.
  endif.
  append ls_json to ct_json.

endmethod.


METHOD NAME.

  DATA: ls_json TYPE zaco_s_json_body.

  DATA: lv_equnr TYPE equnr.

  CALL METHOD io_equipment->get_equnr
    CHANGING
      cv_equnr = lv_equnr.
  ls_json-value = lv_equnr.
  ls_json-name = 'name'.
  APPEND ls_json TO ct_json.

ENDMETHOD.


METHOD OPERATORID.

*----------------------------------------------------------------------------*

*     Derzeit gibt es noch keine Definition zur Ermittlung
*     des Betreibers deshalb immer Netzsch

*----------------------------------------------------------------------------*
  DATA: lo_bp_ain TYPE REF TO zaco_cl_business_partner_ain.

  DATA: lt_result TYPE zaco_t_json_body.

  DATA: ls_json  TYPE zaco_s_json_body.

  DATA: lv_tplnr TYPE tplnr.

  CREATE OBJECT lo_bp_ain.
  ls_json-name = 'operatorID'.
  CALL METHOD io_equipment->get_tplnr
    CHANGING
      cv_tplnr = lv_tplnr.
  IF lv_tplnr NE space.
    CALL METHOD lo_bp_ain->get_bp_ain
      EXPORTING
        iv_tplnr   = lv_tplnr
        iv_rfcdest = iv_rfcdest
      CHANGING
*       cv_loghndl =
        cv_bp_id   = ls_json-value
        ct_result  = lt_result.
  ELSE.
    CALL METHOD lo_bp_ain->get_bp_id_by_name
      EXPORTING
        iv_bp_name = IV_BUSINESSPARTNER_NAME
        iv_rfcdest = iv_rfcdest
      CHANGING
*       cv_loghndl =
        cv_bp_id   = ls_json-value
        ct_result  = lt_result.
  ENDIF.

  APPEND ls_json TO ct_json.

ENDMETHOD.


METHOD SERIALNUMBER.

  DATA: ls_json TYPE zaco_s_json_body.

  DATA: lv_sernr TYPE gernr.

  CALL METHOD io_equipment->get_sernr
    CHANGING
      cv_sernr = lv_sernr.

  IF lv_sernr(1) = 'X' AND lv_sernr+1(1) = '4'.
    lv_sernr(1) = 'D'.
  ENDIF.
  if lv_sernr(1) = 'X'.
    shift lv_sernr LEFT DELETING LEADING 'X'.
  endif.
  ls_json-name = 'serialNumber'.
  ls_json-value = lv_sernr.
  APPEND ls_json TO ct_json.

ENDMETHOD.


method SHORT.

  data: ls_json type zaco_s_json_body.

  data: lv_text Type ktx01.

  CALL METHOD io_equipment->GET_SHTXT
    CHANGING
      CV_SHTXT = lv_text.

  ls_json-name = 'short'.
  ls_json-value = lv_text.
  ls_json-parent = 'description'.
  append ls_json to ct_json.

endmethod.


method SOURCEBPROLE.
*----------------------------------------------------------------------------*

*     Derzeit gibt es noch keine Definition zur Ermittlung
*     der Betriebs Rolle deshalb immer für Kunde = 3

*----------------------------------------------------------------------------*

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'sourceBPRole'.
  ls_json-value = '3'.                " 1=Meine eigenen, 2=für Servicepartner, 3=für Kunden
  append ls_json to ct_json.

endmethod.


METHOD TECHNISCHE_ID.

  DATA: ls_json TYPE zaco_s_json_body.

  DATA: lv_typbz TYPE typbz.

  CALL METHOD io_equipment->get_typbz
    CHANGING
      ic_typbz = lv_typbz.

  ls_json-value = lv_typbz.
  ls_json-name = 'tin'.
  APPEND ls_json TO ct_json.

ENDMETHOD.


METHOD update_equipment.

  DATA: lo_http_client  TYPE REF TO if_http_client.
  DATA: lt_json         TYPE zaco_t_json_body.

  DATA: lv_equnr        TYPE equnr.
  DATA: lv_rfcdest      TYPE rfcdest.
  DATA: lv_sernr        TYPE gernr.
  DATA: lv_transfer     TYPE char1.
  DATA: lv_equi_id      TYPE string.
  DATA: lv_service      TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_json         TYPE string.

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
      iv_rfcdest     = iv_rfcdest
    CHANGING
      co_http_client = lo_http_client.
  IF sy-subrc <> 0.
    gs_msg-msgty = 'E'.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgno = '102'.  "Verbindung zu AIN System fehlgeschlagen.
    CALL METHOD zaco_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.
  ENDIF.
*
  CALL METHOD io_equipment->get_sernr
    CHANGING
      cv_sernr = lv_sernr.

  CALL METHOD me->equipment_already_transferred
    EXPORTING
      iv_sernr        = lv_sernr
      iv_rfcdest      = iv_rfcdest
    CHANGING
      cv_transferred  = lv_transfer
      cv_equipment_id = lv_equi_id
      ct_json         = lt_json.
  IF lv_transfer = 'X'.
    CALL METHOD lo_http_client->close( ).
    CALL METHOD zaco_cl_connection_ain=>connect_to_ain
      EXPORTING
        iv_rfcdest     = iv_rfcdest
      CHANGING
        co_http_client = lo_http_client.
    IF sy-subrc <> 0.
      gs_msg-msgty = 'E'.
      gs_msg-msgid = 'ZACO'.
      gs_msg-msgno = '102'.  "Verbindung zu AIN System fehlgeschlagen.
      CALL METHOD zaco_cl_logs=>add_log_entry
        EXPORTING
          is_msg     = gs_msg
          iv_loghndl = cv_loghndl.
    ENDIF.
*
*-----------------------------------------------------------------------
* Set Request URI
*-----------------------------------------------------------------------
    CONCATENATE zaco_cl_connection_ain=>gv_service '/equipment(' lv_equi_id ')/header' INTO lv_service.
    cl_http_utility=>set_request_uri( request = lo_http_client->request
                                         uri  = lv_service ).

    lo_http_client->request->set_method( 'PUT' ).
    lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).

    CALL METHOD me->data_gathering
      EXPORTING
        io_equipment             = io_equipment
        iv_rfcdest               = iv_rfcdest
        iv_updkz                 = 'U'
        iv_business_pa_std       = iv_business_pa_std
      CHANGING
        ct_json                  = lt_json
        cv_loghndl               = cv_loghndl
      EXCEPTIONS
        no_model                 = 1
        no_modelid               = 2
        no_equipment_template_id = 3
        OTHERS                   = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

*-----------------------------------------------------------------------------------------------*

*           Bilden JSON Body und Request

*-----------------------------------------------------------------------------------------------*
    CALL METHOD zaco_cl_connection_ain=>construct_body
      EXPORTING
        it_body = lt_json
      CHANGING
        cv_body = lv_body.

    lo_http_client->request->set_cdata( lv_body ).
**-----------------------------------------------------------------------
** Send Request and Receive Response
**-----------------------------------------------------------------------
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

*  if lv_status_code ne 200.
*-----------------------------------------------------------------------
* Refresh HTTP Request
*-----------------------------------------------------------------------
    CALL METHOD io_equipment->get_equnr
      CHANGING
        cv_equnr = lv_equnr.
    IF lv_status_code NE 200.
      gs_msg-msgty = 'E'.
      gs_msg-msgid = 'ZACO'.
      gs_msg-msgno = '108'.  "HTTP Fehler bei Übertragung
      gs_msg-msgv1 = lv_equnr.
      gs_msg-msgv2 = lv_status_code.
      CALL METHOD zaco_cl_logs=>add_log_entry
        EXPORTING
          is_msg     = gs_msg
          iv_loghndl = cv_loghndl.

    ELSE.
      gs_msg-msgty = 'I'.
      gs_msg-msgid = 'ZACO'.
      gs_msg-msgno = '109'.  "Konnte erfolgreich übertragen werden
      gs_msg-msgv1 = lv_equnr.
      gs_msg-msgv2 = lv_status_code.
      CALL METHOD zaco_cl_logs=>add_log_entry
        EXPORTING
          is_msg     = gs_msg
          iv_loghndl = cv_loghndl.

    ENDIF.

    lv_json = lo_http_client->response->get_cdata( ).
    CALL METHOD zaco_cl_json=>json_to_data
      EXPORTING
        iv_json = lv_json
      CHANGING
        ct_data = ct_result.

    CALL METHOD lo_http_client->close( ).
  ENDIF.
ENDMETHOD.
ENDCLASS.
