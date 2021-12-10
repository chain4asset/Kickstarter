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
  methods FIND_EXTERNAL_ID
    importing
      !IV_RFCDEST type RFCDEST
      !IV_EXTERNAL_ID type STRING
      !IV_SYSTEMNAME type STRING
      !IV_OBJECTTYPE type STRING
    changing
      !CV_OK type CHAR1
      !CS_EXTERNAL_ID type ZACO_S_EXTERNAL_ID_OBJECTS
    exceptions
      NO_DATA .
  methods GET_SYSTEM_ID
    importing
      !IV_RFCDEST type RFCDEST
      !IV_SYNAME type SYST-SYSID
    changing
      !CV_SYSTEMID type ZACO_DE_EXTERN_SYSTEM_ID
    exceptions
      NOT_FOUND .
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


METHOD find_external_id.

  DATA: lo_http_client  TYPE REF TO if_http_client.

  DATA: lt_ext_ids      TYPE zaco_tt_external_id_objects.
  DATA: ls_ext_ids      TYPE zaco_s_external_id_objects.

  DATA: lv_body         TYPE string.
  DATA: lv_service      TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_equnr        TYPE equnr.


  CALL METHOD zaco_cl_connection_ain=>connect_to_ain
    EXPORTING
      iv_rfcdest               = iv_rfcdest
    CHANGING
      co_http_client           = lo_http_client
    EXCEPTIONS
      dest_not_found           = 1
      destination_no_authority = 2
      OTHERS                   = 3.
  CASE sy-subrc.
    WHEN '1'.
      gs_msg-msgid = 'ZACO'.
      gs_msg-msgty = 'E'.
      gs_msg-msgno = '001'.
      gs_msg-msgv1 = iv_rfcdest.
      lv_json  = iv_rfcdest.
      CALL METHOD zaco_cl_error_log=>write_error
        EXPORTING
          iv_msgty     = gs_msg-msgty
          iv_json      = lv_json
          iv_equnr     = lv_equnr
          iv_msgno     = gs_msg-msgno
          iv_msgid     = gs_msg-msgid
          iv_msgv1     = gs_msg-msgv1
          iv_err_group = 'DEST'.
    WHEN '2'.
      gs_msg-msgid = 'ZACO'.
      gs_msg-msgty = 'E'.
      gs_msg-msgno = '002'.
      gs_msg-msgv1 = iv_rfcdest.
      lv_json  = iv_rfcdest.
      CALL METHOD zaco_cl_error_log=>write_error
        EXPORTING
          iv_msgty     = gs_msg-msgty
          iv_json      = lv_json
          iv_equnr     = lv_equnr
          iv_msgno     = gs_msg-msgno
          iv_msgid     = gs_msg-msgid
          iv_msgv1     = gs_msg-msgv1
          iv_err_group = 'DEST'.
    WHEN '3'.
      gs_msg-msgid = 'ZACO'.
      gs_msg-msgty = 'E'.
      gs_msg-msgno = '003'.
      gs_msg-msgv1 = iv_rfcdest.
      lv_json  = iv_rfcdest.
      CALL METHOD zaco_cl_error_log=>write_error
        EXPORTING
          iv_msgty     = gs_msg-msgty
          iv_json      = lv_json
          iv_equnr     = lv_equnr
          iv_msgno     = gs_msg-msgno
          iv_msgid     = gs_msg-msgid
          iv_msgv1     = gs_msg-msgv1
          iv_err_group = 'DEST'.

  ENDCASE.

*-----------------------------------------------------------------------
* Set Request URI
*-----------------------------------------------------------------------
  CONCATENATE zaco_cl_connection_ain=>gv_service '/objectsid/ainobjects(' iv_external_id ')' INTO lv_service.
  cl_http_utility=>set_request_uri( request = lo_http_client->request
                                       uri  = lv_service ).

  lo_http_client->request->set_method( 'GET' ).
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
  IF lv_status_code = '200'.

    gs_msg-msgid = 'ZACO'.
    gs_msg-msgty = 'S'.
    gs_msg-msgno = '301'.
    gs_msg-msgv1 = iv_external_id.
    lv_json  = lv_json.
    CALL METHOD zaco_cl_error_log=>write_error
      EXPORTING
        iv_msgty     = gs_msg-msgty
        iv_json      = lv_json
        iv_equnr     = lv_equnr
        iv_msgno     = gs_msg-msgno
        iv_msgid     = gs_msg-msgid
        iv_msgv1     = gs_msg-msgv1
        iv_err_group = 'SYST'.

    CALL METHOD /ui2/cl_json=>deserialize
      EXPORTING
        json        = lv_json
*       jsonx       =
        pretty_name = /ui2/cl_json=>pretty_mode-camel_case
*       assoc_arrays     = C_BOOL-FALSE
*       assoc_arrays_opt = C_BOOL-FALSE
*       name_mappings    =
      CHANGING
        data        = lt_ext_ids.
    SORT lt_ext_ids BY changedon DESCENDING.
    READ TABLE lt_ext_ids INTO cs_external_id WITH KEY systemname = iv_systemname
                                                       objecttype = iv_objecttype.
    IF sy-subrc = 0.
      cv_ok = 'X'.
    ENDIF.
  ELSE.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgty = 'W'.
    gs_msg-msgno = '302'.
    gs_msg-msgv1 = iv_external_id.
    lv_json  = lv_json.
    CALL METHOD zaco_cl_error_log=>write_error
      EXPORTING
        iv_msgty     = gs_msg-msgty
        iv_json      = lv_json
        iv_equnr     = lv_equnr
        iv_msgno     = gs_msg-msgno
        iv_msgid     = gs_msg-msgid
        iv_msgv1     = gs_msg-msgv1
        iv_err_group = 'SYST'.
    cv_ok = space.
  ENDIF.

  lo_http_client->close( ).
  CLEAR lv_json.
  CLEAR lv_service.
*  ELSE.
*    RAISE no_data.
*  ENDIF.

ENDMETHOD.


  METHOD get_system_id.

    DATA: lo_http_client TYPE REF TO if_http_client.

    DATA: lt_systeme_det  TYPE zaco_tt_systems_detail.

    DATA: ls_systeme      TYPE zaco_s_systems.
    DATA: ls_systeme_det  TYPE ZACO_s_SYSTEMS_DETAIL.

    DATA: lv_filter       TYPE string.
    DATA: lv_service      TYPE string.
    DATA: lv_status_code  TYPE i.
    DATA: lv_reason       TYPE string.
    DATA: lv_json         TYPE string.
    DATA: lv_length       TYPE i.
    DATA: lv_idx          TYPE sy-tabix.
    DATA: lv_clientx      TYPE sy-tabix.

    CLEAR cv_systemid.

    CALL METHOD zaco_cl_connection_ain=>connect_to_ain_log
      EXPORTING
        iv_rfcdest     = iv_rfcdest
      CHANGING
        co_http_client = lo_http_client.


    lv_filter = |/external/systems|.         "'Equipment Template' and name eq '|.

    CONCATENATE zaco_cl_connection_ain=>gv_service lv_filter INTO lv_service.

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
      CALL METHOD /ui2/cl_json=>deserialize
        EXPORTING
          json        = lv_json
          pretty_name = /ui2/cl_json=>pretty_mode-camel_case
        CHANGING
          data        = ls_systeme.
      lt_systeme_det[] = ls_systeme-systems[].
      READ TABLE lt_systeme_det INTO ls_systeme_det WITH KEY systemname = iv_syname.
      IF sy-subrc = 0.
        cv_systemid = ls_systeme_det-id.
      ELSE.
        RAISE not_found.
      ENDIF.
    ENDIF.


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

  DATA: lo_http_client  TYPE REF TO if_http_client.

  DATA: lt_json         TYPE zaco_t_json_body.

  DATA: ls_ext_ids      TYPE zaco_s_external_id.

  DATA: lv_equnr        TYPE equnr.    "log
  DATA: lv_zaehl        TYPE sy-tfill.
  DATA: lv_body         TYPE string.
  DATA: lv_service      TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_syname       TYPE sy-sysid.

  CALL METHOD zaco_cl_connection_ain=>connect_to_ain_log
    EXPORTING
      iv_rfcdest     = iv_rfcdest
    CHANGING
      co_http_client = lo_http_client.

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
      lv_syname =  ls_ext_ids-system_id.
      CALL METHOD me->get_system_id
        EXPORTING
          iv_rfcdest  = iv_rfcdest
          iv_syname   = lv_syname
        CHANGING
          cv_systemid = ls_ext_ids-system_id
        EXCEPTIONS
          not_found   = 1
          OTHERS      = 2.
      IF sy-subrc <> 0.
*       Implement suitable error handling here
      ENDIF.

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

      IF iv_object_type = 'ORG'.
        CALL METHOD me->external_object_type
          EXPORTING
            iv_object_type = space
        changing
          ct_json        = lt_json.
      ELSE.
        CALL METHOD me->external_object_type
          EXPORTING
            iv_object_type = iv_object_type
          CHANGING
            ct_json        = lt_json.
      ENDIF.
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
    IF lv_status_code >= '200' AND lv_status_code < '400' .
      gs_msg-msgid = 'ZACO'.
      gs_msg-msgty = 'S'.
      gs_msg-msgno = '301'.
      gs_msg-msgv1 = iv_object_id.
      lv_json  = lv_json.
      CALL METHOD zaco_cl_error_log=>write_error
        EXPORTING
          iv_msgty     = gs_msg-msgty
          iv_json      = lv_json
          iv_equnr     = lv_equnr
          iv_msgno     = gs_msg-msgno
          iv_msgid     = gs_msg-msgid
          iv_msgv1     = gs_msg-msgv1
          iv_err_group = 'SYST'.
    ELSE.
      gs_msg-msgid = 'ZACO'.
      gs_msg-msgty = 'E'.
      gs_msg-msgno = '302'.
      gs_msg-msgv1 = iv_object_id.
      lv_json  = lv_json.
      CALL METHOD zaco_cl_error_log=>write_error
        EXPORTING
          iv_msgty     = gs_msg-msgty
          iv_json      = lv_json
          iv_equnr     = lv_equnr
          iv_msgno     = gs_msg-msgno
          iv_msgid     = gs_msg-msgid
          iv_msgv1     = gs_msg-msgv1
          iv_err_group = 'SYST'.

    ENDIF.
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
