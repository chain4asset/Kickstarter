class ZACO_CL_EXTERNAL_IDS definition
  public
  final
  create public .

public section.

  methods SET_EXTERNAL_IDS
    importing
      !IV_RFCDEST type RFCDEST
      !IV_OBJECT_ID type STRING
      !IV_OBJECT_TYPE type ZACO_D_EXTERNAL_ID_TYPE
    changing
      !CV_OK type CHAR1
      !CV_LOGHNDL type BALLOGHNDL optional
      !CT_RETURN type ZACO_T_JSON_BODY optional
    exceptions
      NO_DATA .
  methods ADD_EXTERNAL_ID
    importing
      !IS_EXT_ID type ZACO_S_EXTERNAL_ID .
protected section.
private section.

  data GT_EXT_IDS type ZACO_TT_EXTERNAL_ID .
  data GS_LOG type BAL_S_LOG .
  data GS_MSG type BAL_S_MSG .

  methods OBJECT_TYPE
    importing
      !IV_OBJECT_TYPE type ZACO_D_EXTERNAL_ID_TYPE
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods OBJECT_ID
    importing
      !IV_OBJECT_ID type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods SYSTEM_ID
    importing
      !IV_SYSTEM_ID type ZACO_D_EXTERN_SYSTEM_ID
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods EXTERNAL_ID
    importing
      !IV_EXTERNAL_ID type ZACO_D_EXTERNAL_ID
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods IS_PRIMARY
    importing
      !IV_IS_PRIMARY type ZACO_D_EXTERNAL_PRIMARY
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods EXTERNAL_OBJECT_TYPE
    importing
      !IV_OBJECT_TYPE type ZACO_D_EXTERNAL_ID_TYPE
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
ENDCLASS.



CLASS ZACO_CL_EXTERNAL_IDS IMPLEMENTATION.


METHOD ADD_EXTERNAL_ID.

  APPEND is_ext_id TO gt_ext_ids.

ENDMETHOD.


METHOD EXTERNAL_ID.

  DATA: ls_json TYPE zaco_s_json_body.

  ls_json-name = 'ExternalID'.
  ls_json-value = iv_external_id.
  ls_json-parent = 'IDMappings'.
*  ls_json-multiple = 'X'.
*  ls_json-multiple_body = 'X'.
  APPEND ls_json TO ct_json.

ENDMETHOD.


METHOD EXTERNAL_OBJECT_TYPE.

  DATA: ls_json TYPE zaco_s_json_body.

  ls_json-name = 'ExternalObjectTypeCode'.
  ls_json-value = iv_object_type.
  ls_json-parent = 'IDMappings'.
  APPEND ls_json TO ct_json.

ENDMETHOD.


METHOD IS_PRIMARY.

  DATA: ls_json TYPE zaco_s_json_body.

  ls_json-name = 'isPrimary'.
  ls_json-value = iv_is_primary.
  ls_json-parent = 'IDMappings'.
*  ls_json-multiple = 'X'.
*  ls_json-multiple_body = 'X'.
  APPEND ls_json TO ct_json.

ENDMETHOD.


METHOD OBJECT_ID.

  DATA: ls_json TYPE zaco_s_json_body.

  ls_json-name = 'AINObjectID'.
  ls_json-value = iv_object_id.
  APPEND ls_json TO ct_json.

ENDMETHOD.


METHOD OBJECT_TYPE.

  DATA: ls_json TYPE zaco_s_json_body.

  ls_json-name = 'ObjectType'.
  ls_json-value = iv_object_type.
  APPEND ls_json TO ct_json.

ENDMETHOD.


METHOD set_external_ids.

  DATA: lo_http_client TYPE REF TO if_http_client.

  DATA: lt_json TYPE zaco_t_json_body.

  DATA: ls_ext_ids TYPE zaco_s_external_id.

  DATA: lv_zaehl TYPE sy-tfill.
  DATA: lv_body  TYPE string.
  DATA: lv_service      TYPE string.
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
  CALL METHOD zaco_cl_connection_ain=>connect_to_ain
    EXPORTING
      iv_rfcdest               = iv_rfcdest
    CHANGING
      co_http_client           = lo_http_client
    EXCEPTIONS
      dest_not_found           = 1
      destination_no_authority = 2
      OTHERS                   = 3.
  IF sy-subrc <> 0.
**message i102(ZPSAIN)
    gs_msg-msgty = 'E'.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgno = '102'.  "Verbindung zu AIN System fehlgeschlagen.
    CALL METHOD zaco_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.
  ENDIF.

  CALL METHOD me->object_type
    EXPORTING
      iv_object_type = iv_object_type
    CHANGING
      ct_json        = lt_json.

  CALL METHOD me->object_id
    EXPORTING
      iv_object_id = iv_object_id
    CHANGING
      ct_json      = lt_json.

  DESCRIBE TABLE gt_ext_ids LINES lv_zaehl.
  IF lv_zaehl > 0.
    LOOP AT gt_ext_ids INTO ls_ext_ids WHERE object_type = iv_object_type.
      CALL METHOD me->system_id
        EXPORTING
          iv_system_id = ls_ext_ids-system_id
        CHANGING
          ct_json      = lt_json.

      CALL METHOD me->external_id
        EXPORTING
          iv_external_id = ls_ext_ids-external_id
        CHANGING
          ct_json        = lt_json.

      CALL METHOD me->is_primary
        EXPORTING
          iv_is_primary = ls_ext_ids-is_primary
        CHANGING
          ct_json       = lt_json.

      CALL METHOD me->external_object_type
        EXPORTING
          iv_object_type = iv_object_type
        CHANGING
          ct_json        = lt_json.

    ENDLOOP.
    CALL METHOD zaco_cl_connection_ain=>construct_body
      EXPORTING
        it_body = lt_json
      CHANGING
        cv_body = lv_body.
*-----------------------------------------------------------------------
* Set Request URI
*-----------------------------------------------------------------------
    CONCATENATE zaco_cl_connection_ain=>gv_service '/object/externalids' INTO lv_service.
    cl_http_utility=>set_request_uri( request = lo_http_client->request
                                         uri  = lv_service ).

    lo_http_client->request->set_method( 'POST' ).
    lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).
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

    lv_json = lo_http_client->response->get_cdata( ).
    CALL METHOD zaco_cl_json=>json_to_data
      EXPORTING
        iv_json = lv_json
      CHANGING
        ct_data = ct_return.
    lo_http_client->close( ).
    CLEAR lv_json.
    REFRESH lt_json.
    CLEAR lv_service.
  ELSE.
    RAISE no_data.
  ENDIF.

ENDMETHOD.


METHOD SYSTEM_ID.

  DATA: ls_json TYPE zaco_s_json_body.

  ls_json-name = 'SystemID'.
  ls_json-value = iv_system_id.
  ls_json-parent = 'IDMappings'.
  ls_json-multiple = 'X'.
*  ls_json-multiple_body = 'X'.
  APPEND ls_json TO ct_json.

ENDMETHOD.
ENDCLASS.
