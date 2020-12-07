class ZACO_CL_SHARING definition
  public
  create public .

public section.

  methods GET_GROUP_BY_NAME
    importing
      !IV_NAME type ZCHAIN_DE_AUTH_GROUP
      !IV_RFCDEST type RFCDEST
    changing
      !CV_GROUP_ID type STRING
      !CV_LOGHNDL type BALLOGHNDL optional .
  methods SHARE_OBJECTS
    importing
      !IT_SHARE type ZACO_TT_SHARING_OBJECT
      !IV_RFCDEST type RFCDEST
      !IV_GROUP_ID type STRING
    changing
      !CV_OK type CHAR1
      !CT_RESULT type ZACO_T_JSON_BODY
      !CV_LOGHNDL type BALLOGHNDL optional .
protected section.
private section.

  data GS_MSG type BAL_S_MSG .

  methods SHARING
    importing
      !IS_SHARING type ZACO_S_SHARING_OBJECT
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
ENDCLASS.



CLASS ZACO_CL_SHARING IMPLEMENTATION.


  METHOD get_group_by_name.
    DATA: lo_http_client  TYPE REF TO if_http_client.

    DATA: lt_json         TYPE zaco_t_json_body.
    DATA: lt_result       TYPE zaco_t_json_body.

    DATA: ls_result       TYPE zaco_s_json_body.

    DATA: lv_body         TYPE string.
    DATA: lv_service      TYPE string.
    DATA: lv_status_code  TYPE i.
    DATA: lv_reason       TYPE string.
    DATA: lv_json         TYPE string.
    DATA: lv_filter       TYPE string.

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

*-----------------------------------------------------------------------
* Set Request URI
*-----------------------------------------------------------------------
    lv_filter = |/authorization/groups?$filter=name eq '|.
    CONCATENATE zaco_cl_connection_ain=>gv_service lv_filter iv_name '''' INTO lv_service.
    cl_http_utility=>set_request_uri( request = lo_http_client->request
                                         uri  = lv_service ).

    lo_http_client->request->set_method( 'GET' ).
    lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).

*-----------------------------------------------------------------------------------------------*

*           Bilden JSON Body und Request

*-----------------------------------------------------------------------------------------------*
*    CALL METHOD zaco_cl_connection_ain=>construct_body
*      EXPORTING
*        it_body = lt_json
*      CHANGING
*        cv_body = lv_body.
*
*    lo_http_client->request->set_cdata( lv_body ).
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
  IF lv_status_code NE 200.
*  message i108(ZPSAIN).
    gs_msg-msgty = 'E'.
    gs_msg-msgid = 'ZPSAIN'.
    gs_msg-msgno = '142'.  "HTTP Fehler bei Übertragung
    gs_msg-msgv1 = iv_name.
    gs_msg-msgv2 = lv_status_code.
    CALL METHOD zpsain_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.

  ELSE.
*  message i109(ZPSAIN).
    gs_msg-msgty = 'I'.
    gs_msg-msgid = 'ZPSAIN'.
    gs_msg-msgno = '143'.  "Konnte erfolgreich übertragen werden
    gs_msg-msgv1 = iv_name.
    gs_msg-msgv2 = lv_status_code.
    CALL METHOD zpsain_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.

  ENDIF.


    IF lv_status_code = '200'.
      lv_json = lo_http_client->response->get_cdata( ).
      CALL METHOD zaco_cl_json=>json_to_data
        EXPORTING
          iv_json = lv_json
        CHANGING
          ct_data = lt_result.
      READ TABLE lt_result INTO ls_result WITH KEY name = 'id'.
      IF sy-subrc = 0.
        cv_group_id = ls_result-value.
      ELSE.
        cv_group_id = space.
      ENDIF.
    ELSE.
      cv_group_id = space.
    ENDIF.

    CALL METHOD lo_http_client->close( ).

  ENDMETHOD.


  METHOD share_objects.

    DATA: lo_http_client  TYPE REF TO if_http_client.

    DATA: lt_json TYPE zaco_t_json_body.


    DATA: ls_share TYPE zaco_s_sharing_object.

    DATA: lv_body         TYPE string.
    DATA: lv_body_tmp     TYPE string.
    DATA: lv_count        TYPE i.
    DATA: lv_service      TYPE string.
    DATA: lv_status_code  TYPE i.
    DATA: lv_reason       TYPE string.
    DATA: lv_json         TYPE string.
    DATA: lv_rfcdest      TYPE rfcdest.


    LOOP AT it_share INTO ls_share.
      IF lv_count > 1.
        CONCATENATE lv_body ',' lv_body_tmp INTO lv_body.
      else.
        lv_body = lv_body_tmp.
      ENDIF.
      CALL METHOD me->sharing
        EXPORTING
          is_sharing = ls_share
        CHANGING
          ct_json    = lt_json.

      CALL METHOD zaco_cl_connection_ain=>construct_body
        EXPORTING
          it_body = lt_json
        CHANGING
          cv_body = lv_body_tmp.
      REFRESH lt_json.
      lv_count = lv_count + 1.
    ENDLOOP.
    CONCATENATE lv_body ',' lv_body_tmp INTO lv_body.
    REPLACE '"true"' IN lv_body WITH 'true'.
     REPLACE '"false"' IN lv_body WITH 'false'.
    CONCATENATE '[' lv_body ']' INTO lv_body.

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

*-----------------------------------------------------------------------
* Set Request URI
*-----------------------------------------------------------------------

    CONCATENATE zaco_cl_connection_ain=>gv_service '/authorization/groups(' iv_group_id ')/objects' INTO lv_service.
    cl_http_utility=>set_request_uri( request = lo_http_client->request
                                         uri  = lv_service ).

    lo_http_client->request->set_method( 'PUT' ).
    lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).

*-----------------------------------------------------------------------------------------------*

*           Bilden JSON Body und Request

*-----------------------------------------------------------------------------------------------*

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
    IF lv_status_code NE 200.
      gs_msg-msgty = 'E'.
      gs_msg-msgid = 'ZACO'.
      gs_msg-msgno = '145'.  "Veröffentlichung achlug fehl
      gs_msg-msgv1 = lv_status_code.
      CALL METHOD zaco_cl_logs=>add_log_entry
        EXPORTING
          is_msg     = gs_msg
          iv_loghndl = cv_loghndl.
      CLEAR cv_ok.
    ELSE.
      gs_msg-msgty = 'I'.
      gs_msg-msgid = 'ZACO'.
      gs_msg-msgno = '146'.  "Veröffentlichung erfolgreich
      gs_msg-msgv1 = lv_status_code.
      CALL METHOD zaco_cl_logs=>add_log_entry
        EXPORTING
          is_msg     = gs_msg
          iv_loghndl = cv_loghndl.
      cv_ok = 'X'.
    ENDIF.

    lv_json = lo_http_client->response->get_cdata( ).
    CALL METHOD zaco_cl_json=>json_to_data
      EXPORTING
        iv_json = lv_json
      CHANGING
        ct_data = ct_result.

    CALL METHOD lo_http_client->close( ).


  ENDMETHOD.


  METHOD sharing.

    DATA: ls_json TYPE zaco_s_json_body.

    ls_json-name = 'id'.
    ls_json-value = is_sharing-object_id.
    APPEND ls_json TO ct_json.

    ls_json-name = 'type'.
    ls_json-value = is_sharing-object_type.
    APPEND ls_json TO ct_json.

    ls_json-name = 'accessPrivilege'.
    ls_json-value = is_sharing-access_priv.
    APPEND ls_json TO ct_json.

    ls_json-name = 'operation'.
    ls_json-value = is_sharing-operation.
    APPEND ls_json TO ct_json.

    ls_json-name = 'primary'.
    ls_json-value = is_sharing-primary.
    APPEND ls_json TO ct_json.

  ENDMETHOD.
ENDCLASS.
