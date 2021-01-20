class ZACO_CL_CONNECTION_AIN definition
  public
  create public .

public section.

  class-data GV_RFCDEST type RFCDEST value 'AIN_TEST' ##NO_TEXT.
  class-data GV_SERVICE type STRING value '/ain/services/api/v1' ##NO_TEXT.
  class-data GV_OAUTH_TOKEN type STRING .

  class-methods CONNECT_TO_AIN
    importing
      !IV_RFCDEST type RFCDEST optional
    changing
      !CO_HTTP_CLIENT type ref to IF_HTTP_CLIENT
    exceptions
      DEST_NOT_FOUND
      DESTINATION_NO_AUTHORITY .
  class-methods CLOSE_CONNECTION
    changing
      !CO_HTTP_CLIENT type ref to IF_HTTP_CLIENT .
  class-methods CONSTRUCT_BODY
    importing
      !IT_BODY type ZACO_T_JSON_BODY
    changing
      !CV_BODY type STRING .
  class-methods CONSTRUCT_BODY_HIER
    importing
      !IT_BODY type ZACO_T_JSON_BODY
    changing
      !CV_BODY type STRING .
  class-methods BODY_RECURSIVE
    importing
      !IT_BODY type ZACO_T_JSON_BODY
      !IV_STUFE type CIM_COUNT
    changing
      !CV_BODY type STRING .
  class-methods CONSTRUCT_BODY_PROD_DATEN
    importing
      !IT_JSON type ZACO_T_JSON_BODY
      !IV_TEMPLATE_ID type STRING
    changing
      !LV_BODY type STRING .
  class-methods CONSTRUCT_BODY_MAT_LANGU
    importing
      !IT_BODY type ZACO_T_JSON_BODY
    changing
      !CV_BODY type STRING .
  class-methods CREATE_TOKEN
    importing
      !IV_CLIENT_ID type ZACO_DE_AIN_CLIENT_ID
      !IV_CLIENT_SECRET type ZACO_DE_AIN_CLIENT_SECRET
      !IV_TOKEN_URL type ZACO_DE_AIN_TOKEN_URL
    changing
      !CO_HTTP_CLIENT type ref to IF_HTTP_CLIENT
      !CV_OAUTH_TOKEN type STRING .
protected section.
private section.
ENDCLASS.



CLASS ZACO_CL_CONNECTION_AIN IMPLEMENTATION.


METHOD BODY_RECURSIVE.

  DATA: ls_body TYPE zaco_s_json_body.

  DATA: lv_begin TYPE string.
  DATA: lv_end TYPE string.
  DATA: lv_stufe TYPE cim_count.
  DATA: lv_parent TYPE string.
  DATA: lv_ok TYPE char1.
  DATA: lv_zaehl TYPE i.

  lv_begin = |\{|.
  lv_end = |\}|.

  READ TABLE it_body INTO ls_body WITH KEY stufe = iv_stufe.
  IF sy-subrc = 0.
    IF iv_stufe < 2.
      CONCATENATE cv_body '"' ls_body-parent '": ['  lv_begin INTO cv_body.
      lv_parent = ls_body-parent.
    ELSE.
      CONCATENATE cv_body '","' ls_body-parent '": ['  lv_begin INTO cv_body.
      lv_parent = ls_body-parent.
    ENDIF.
  ENDIF.
  LOOP AT it_body INTO ls_body WHERE stufe = iv_stufe.
    IF lv_zaehl = 0.
*      IF iv_stufe = 1.
*        CONCATENATE cv_body '"' ls_body-name '": "' ls_body-value '",' INTO cv_body.
*      ELSE.
      CONCATENATE cv_body '"' ls_body-name '": "' ls_body-value INTO cv_body.
*      ENDIF.
    ELSE.
      IF ls_body-last = 'X'.
        CONCATENATE cv_body '",' '"' ls_body-name '": "' ls_body-value '"' lv_end INTO cv_body.
      ELSE.
        IF ls_body-next = 'X'.
          CONCATENATE cv_body ',' lv_begin '"' ls_body-name '": "' ls_body-value INTO cv_body.
        ELSE.
          IF iv_stufe = 2.
            CONCATENATE cv_body '","' ls_body-name '": "' ls_body-value INTO cv_body.
          ELSE.
            CONCATENATE cv_body ', "' ls_body-name '": "' ls_body-value INTO cv_body.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
*---------- Auflösung rekursiv Stufe 1 - x
    lv_stufe = iv_stufe + 1.
    CALL METHOD zaco_cl_connection_ain=>body_recursive
      EXPORTING
        it_body  = it_body
        iv_stufe = lv_stufe
      CHANGING
        cv_body  = cv_body.
    lv_ok = 1.
    lv_zaehl = lv_zaehl + 1.
  ENDLOOP.
  IF lv_ok = 1.
*------- Abschluss Stufe 0.
    IF lv_stufe = 3.
      CONCATENATE cv_body ']}' INTO cv_body.
    ELSE.
      CONCATENATE cv_body lv_end ']' INTO cv_body.
    ENDIF.

  ENDIF.


ENDMETHOD.


method CLOSE_CONNECTION.

  if co_http_client is bound.
    clear co_http_client.
  endif.

endmethod.


METHOD connect_to_ain.

  DATA: lo_a2c_client TYPE REF TO if_oauth2_client.
  DATA: lx_oa2c       TYPE REF TO cx_oa2c.

  DATA: ls_tenant         TYPE zaco_tenant_sy.

  DATA: lv_rfcdest        TYPE rfcdest.
  DATA: lv_profile        TYPE oa2c_profile.
  DATA: lv_client_id      TYPE zaco_de_ain_client_id.
  DATA: lv_client_secret  TYPE zaco_de_ain_client_secret.
  DATA: lv_token_url      TYPE zaco_de_ain_token_url.

  IF iv_rfcdest <> space.
*    lv_rfcdest = iv_rfcdest.
    SELECT SINGLE rfcdest ain_client_id ain_client_secret ain_token_url FROM zaco_tenant_sy INTO (gv_rfcdest, lv_client_id, lv_client_secret, lv_token_url ) WHERE token_rfc = iv_rfcdest.

  ELSE.
    SELECT SINGLE rfcdest ain_client_id ain_client_secret ain_token_url FROM zaco_tenant_sy INTO (gv_rfcdest, lv_client_id, lv_client_secret, lv_token_url ) WHERE sysid = sy-sysid.
    IF sy-subrc <> 0.
      RAISE dest_not_found.      "im Notfall immer AIN_TEST
    ENDIF.
  ENDIF.

  cl_http_client=>create_by_destination(
  EXPORTING
    destination              = gv_rfcdest
  IMPORTING
    client                   = co_http_client    " HTTP Client Abstraction
  EXCEPTIONS
    argument_not_found       = 1
    destination_not_found    = 2
    destination_no_authority = 3
    plugin_not_active        = 4
    internal_error           = 5
    OTHERS                   = 6
 ).
  CASE sy-subrc.
    WHEN '2'.
      RAISE dest_not_found.
    WHEN '3'.
      RAISE destination_no_authority.
  ENDCASE.

*--------- Oauth2 Token
  CALL METHOD zaco_cl_connection_ain=>create_token
    EXPORTING
      iv_client_id     = lv_client_id
      iv_client_secret = lv_client_secret
      iv_token_url     = lv_token_url
    CHANGING
      co_http_client   = co_http_client
      cv_oauth_token   = gv_oauth_token.

  IF gv_oauth_token IS NOT INITIAL.
    co_http_client->request->set_header_field( EXPORTING name  = 'Authorization'
                                                         value = gv_oauth_token ).
  ENDIF.



ENDMETHOD.


METHOD CONSTRUCT_BODY.
  TYPES: BEGIN OF ltt_parent,
          parent        TYPE string,
          multiple      TYPE char1,
          multiple_body TYPE char1,
        END OF ltt_parent.

  DATA: lt_parent TYPE STANDARD TABLE OF ltt_parent.
  DATA: ls_parent TYPE ltt_parent.
  DATA: ls_body TYPE zaco_s_json_body.
  DATA: lv_body_end TYPE string.
  DATA: lv_body_temp TYPE string.
  DATA: lv_name_end TYPE string.
  DATA: lv_name_begin TYPE string.
  DATA: lv_value_end TYPE string.
  DATA: lv_value_last TYPE string.
  DATA: lv_multiple_last TYPE string.
  DATA: lv_multiple_begin TYPE string.
  DATA: lv_line_end TYPE string.
  DATA: lv_line_begin TYPE string.
  DATA: lv_ohne_parent TYPE i.
  DATA: lv_count TYPE i.
  DATA: lv_multiple_change TYPE char1.
  DATA: lv_parent TYPE zaco_de_string.

  cv_body = |\{|.
  lv_body_end = |\}|.
  lv_name_end = |":"|.
  lv_value_end = |",|.
  lv_name_begin = |"|.
  lv_value_last = |"|.
  lv_multiple_begin = |[|.
  lv_multiple_last = |]|.
  lv_line_end = |"\}|.
  lv_line_begin = |,\{|.
  lv_count = 0.


  LOOP AT it_body INTO ls_body WHERE parent = space.
    IF sy-tabix = 1.
      CONCATENATE lv_body_temp lv_name_begin ls_body-name lv_name_end ls_body-value INTO lv_body_temp.
    ELSE.
      CONCATENATE lv_body_temp lv_value_end lv_name_begin ls_body-name lv_name_end ls_body-value INTO lv_body_temp.
    ENDIF.
    ADD 1 TO lv_ohne_parent.
  ENDLOOP.
  IF lv_ohne_parent >= 1.
    CONCATENATE lv_body_temp '"' INTO lv_body_temp.
  ENDIF.
*----- Komplexe Strukturen
  LOOP AT it_body INTO ls_body WHERE parent NE space.
    READ TABLE lt_parent INTO ls_parent WITH KEY parent = ls_body-parent.
    IF sy-subrc <> 0.
      ls_parent-parent = ls_body-parent.
      ls_parent-multiple = ls_body-multiple.
      ls_parent-multiple_body = ls_body-multiple_body.
      APPEND ls_parent TO lt_parent.
    ENDIF.
  ENDLOOP.
  LOOP AT lt_parent INTO ls_parent.
    IF ls_parent-multiple NE space.
      IF lv_ohne_parent >= 1.
        CONCATENATE lv_body_temp ',"' ls_parent-parent '":'  lv_multiple_begin cv_body INTO lv_body_temp.
      ELSE.
        IF lv_parent NE space or lv_ohne_parent >= 1.
          CONCATENATE lv_body_temp ',"' ls_parent-parent '":'  lv_multiple_begin cv_body INTO lv_body_temp.
        ELSE.
          CONCATENATE lv_body_temp '"' ls_parent-parent '":'  lv_multiple_begin cv_body INTO lv_body_temp.
        ENDIF.
      ENDIF.
    ELSE.
      IF lv_parent NE space or lv_ohne_parent >= 1.
        CONCATENATE lv_body_temp ',"' ls_parent-parent '":'  cv_body INTO lv_body_temp.
      ELSE.
        CONCATENATE lv_body_temp '"' ls_parent-parent '":'  cv_body INTO lv_body_temp.
      ENDIF.
    ENDIF.
    LOOP AT it_body INTO ls_body WHERE parent = ls_parent-parent.
      IF lv_count = 0.
        IF ls_body-multiple_body = 'X'.
          CONCATENATE lv_body_temp lv_name_begin ls_body-name lv_name_end ls_body-value lv_line_end INTO lv_body_temp.
        ELSE.
          CONCATENATE lv_body_temp lv_name_begin ls_body-name lv_name_end ls_body-value INTO lv_body_temp.
        ENDIF.
      ELSE.
        IF ls_body-multiple_body = 'X'.
          CONCATENATE lv_body_temp lv_line_begin lv_name_begin ls_body-name lv_name_end ls_body-value lv_line_end INTO lv_body_temp.
        ELSE.
          CONCATENATE lv_body_temp lv_value_end lv_name_begin ls_body-name lv_name_end ls_body-value INTO lv_body_temp.
        ENDIF.
      ENDIF.
      lv_count = lv_count + 1.
    ENDLOOP.
    IF ls_parent-multiple NE space.
      IF ls_body-multiple_body = 'X'.
        CONCATENATE lv_body_temp lv_multiple_last INTO lv_body_temp.
      ELSE.
        CONCATENATE lv_body_temp lv_value_last lv_body_end lv_multiple_last INTO lv_body_temp.
      ENDIF.
    ELSE.
      CONCATENATE lv_body_temp lv_value_last lv_body_end INTO lv_body_temp.
    ENDIF.
    lv_count = 0.
    lv_parent = ls_parent-parent.
  ENDLOOP.
  CONCATENATE cv_body lv_body_temp lv_body_end INTO cv_body.
ENDMETHOD.


method CONSTRUCT_BODY_HIER.

  data: ls_body type zaco_s_json_body.

  data: lv_begin type string.
  data: lv_end type string.
  data: lv_stufe type cim_count.

  lv_begin = |\{|.
  lv_end = |\}|.

  read table it_body into ls_body with key stufe = 0.
  if sy-subrc = 0.
    concatenate lv_begin '"' ls_body-parent '": ['  lv_begin into cv_body.
  endif.
  loop at it_body into ls_body where stufe = 0.
    concatenate cv_body '"' ls_body-name '": "' ls_body-value '",' into cv_body.
*---------- Auflösung rekursiv Stufe 1 - x
    lv_stufe = 1.
    CALL METHOD ZACO_CL_CONNECTION_AIN=>BODY_RECURSIVE
      EXPORTING
        IT_BODY  = it_body
        IV_STUFE = lv_stufe
      CHANGING
        CV_BODY  = cv_body.
*------- Abschluss Stufe 0.
    concatenate cv_body lv_end ']' lv_end into cv_body.
  endloop.


endmethod.


METHOD CONSTRUCT_BODY_MAT_LANGU.
  TYPES: BEGIN OF ltt_parent,
          parent        TYPE string,
          multiple      TYPE char1,
          multiple_body TYPE char1,
        END OF ltt_parent.

  DATA: lt_parent TYPE STANDARD TABLE OF ltt_parent.
  DATA: ls_parent TYPE ltt_parent.
  DATA: ls_body TYPE zaco_s_json_body.
  DATA: lv_body_end TYPE string.
  DATA: lv_body_temp TYPE string.
  DATA: lv_name_end TYPE string.
  DATA: lv_name_begin TYPE string.
  DATA: lv_value_end TYPE string.
  DATA: lv_value_last TYPE string.
  DATA: lv_multiple_last TYPE string.
  DATA: lv_multiple_begin TYPE string.
  DATA: lv_line_end TYPE string.
  DATA: lv_line_begin TYPE string.
  DATA: lv_ohne_parent TYPE i.
  DATA: lv_count TYPE i.
  DATA: lv_multiple_change TYPE char1.
  DATA: lv_parent TYPE zaco_de_string.

  cv_body = |\{|.
  lv_body_end = |\}|.
  lv_name_end = |":"|.
  lv_value_end = |",|.
  lv_name_begin = |"|.
  lv_value_last = |"|.
  lv_multiple_begin = |[|.
  lv_multiple_last = |]|.
  lv_line_end = |"\}|.
  lv_line_begin = |,\{|.
  lv_count = 0.


  LOOP AT it_body INTO ls_body WHERE parent = space.
    IF sy-tabix = 1.
      CONCATENATE lv_body_temp lv_name_begin ls_body-name lv_name_end ls_body-value INTO lv_body_temp.
    ELSE.
      CONCATENATE lv_body_temp lv_value_end lv_name_begin ls_body-name lv_name_end ls_body-value INTO lv_body_temp.
    ENDIF.
    ADD 1 TO lv_ohne_parent.
  ENDLOOP.
  IF lv_ohne_parent >= 1.
    CONCATENATE lv_body_temp '"' INTO lv_body_temp.
  ENDIF.
*----- Komplexe Strukturen
  LOOP AT it_body INTO ls_body WHERE parent NE space.
    READ TABLE lt_parent INTO ls_parent WITH KEY parent = ls_body-parent.
    IF sy-subrc <> 0.
      ls_parent-parent = ls_body-parent.
      ls_parent-multiple = ls_body-multiple.
      ls_parent-multiple_body = ls_body-multiple_body.
      APPEND ls_parent TO lt_parent.
    ENDIF.
  ENDLOOP.
  LOOP AT lt_parent INTO ls_parent.
    IF ls_parent-multiple NE space.
      IF lv_ohne_parent >= 1.
        CONCATENATE lv_body_temp ',"' ls_parent-parent '":' lv_multiple_begin cv_body INTO lv_body_temp.
      ELSE.
        IF lv_parent NE space OR lv_ohne_parent >= 1.
          CONCATENATE lv_body_temp ',"' ls_parent-parent '":' lv_multiple_begin cv_body INTO lv_body_temp.
        ELSE.
          CONCATENATE lv_body_temp '"' ls_parent-parent '":'  lv_multiple_begin cv_body INTO lv_body_temp.
        ENDIF.
      ENDIF.
    ELSE.
      IF lv_parent NE space OR lv_ohne_parent >= 1.
        CONCATENATE lv_body_temp ',"' ls_parent-parent '":'  cv_body INTO lv_body_temp.
      ELSE.
        CONCATENATE lv_body_temp '"' ls_parent-parent '":'  cv_body INTO lv_body_temp.
      ENDIF.
    ENDIF.
    LOOP AT it_body INTO ls_body WHERE parent = ls_parent-parent.
      IF lv_count = 0.
        IF ls_body-multiple_body = 'X'.
          CONCATENATE lv_body_temp lv_name_begin ls_body-name lv_name_end ls_body-value lv_value_last INTO lv_body_temp.
        ELSE.
          CONCATENATE lv_body_temp lv_name_begin ls_body-name lv_name_end ls_body-value INTO lv_body_temp.
        ENDIF.
      ELSE.
        IF ls_body-multiple_body = 'X'.
          IF ls_body-last = 'X'.
            CONCATENATE lv_body_temp lv_name_begin ls_body-name lv_name_end ls_body-value lv_line_end INTO lv_body_temp.
          ELSE.
            IF ls_body-next = 'X'.
              CONCATENATE lv_body_temp lv_line_begin lv_name_begin ls_body-name lv_name_end ls_body-value lv_value_last  INTO lv_body_temp.
            ELSE.
              CONCATENATE lv_body_temp ',' lv_name_begin ls_body-name lv_name_end ls_body-value lv_value_end INTO lv_body_temp.
            ENDIF.
          ENDIF.
        ELSE.
          CONCATENATE lv_body_temp lv_value_end lv_name_begin ls_body-name lv_name_end ls_body-value INTO lv_body_temp.
        ENDIF.
      ENDIF.
      lv_count = lv_count + 1.
    ENDLOOP.
    IF ls_parent-multiple NE space.
      IF ls_body-multiple_body = 'X'.
        CONCATENATE lv_body_temp lv_multiple_last INTO lv_body_temp.
      ELSE.
        CONCATENATE lv_body_temp lv_value_last lv_body_end lv_multiple_last INTO lv_body_temp.
      ENDIF.
    ELSE.
      CONCATENATE lv_body_temp lv_value_last lv_body_end INTO lv_body_temp.
    ENDIF.
    lv_count = 0.
    lv_parent = ls_parent-parent.
  ENDLOOP.
  CONCATENATE cv_body lv_body_temp lv_body_end INTO cv_body.
ENDMETHOD.


METHOD CONSTRUCT_BODY_PROD_DATEN.

  DATA: lt_json_group TYPE zaco_t_json_body.
  DATA: lt_json_attrid  TYPE zaco_t_json_body.
  DATA: lt_json_attrid_v  TYPE zaco_t_json_body.

  DATA: ls_json TYPE zaco_s_json_body.

  DATA: lv_group_id_old TYPE string.
  DATA: lv_attr_id_old TYPE string.

  LOOP AT it_json INTO ls_json WHERE parent = 'attributeGroups'
                                AND  parent_value   = iv_template_id.
    APPEND ls_json TO lt_json_group.
  ENDLOOP.
  LOOP AT it_json INTO ls_json WHERE parent = 'attributes'.
    APPEND ls_json TO lt_json_attrid.
  ENDLOOP.

  CONCATENATE '{ "templates": [{ "templateId": "' iv_template_id '",' INTO lv_body.
  LOOP AT lt_json_group INTO ls_json.
    IF lv_group_id_old NE ls_json-value.
      IF lv_group_id_old NE space.
        CONCATENATE lv_body '}], ' INTO lv_body.
      ENDIF.
      CONCATENATE lv_body '"attributeGroups": [{ "attributeGroupId": "' ls_json-value '",' INTO lv_body.
      IF  lv_attr_id_old NE space.
        CLEAR lv_attr_id_old.
      ENDIF.
      lv_group_id_old = ls_json-value.
    ENDIF.
    LOOP AT lt_json_attrid INTO ls_json WHERE parent_value = lv_group_id_old.
      IF ls_json-name = 'attributeId'.
        IF  lv_attr_id_old = space.
          CONCATENATE lv_body '"attributes": [{' INTO lv_body.
          lv_attr_id_old = ls_json-value.
        ELSE.
          CONCATENATE lv_body '}, {' INTO lv_body.
        ENDIF.
      ELSE.
        CONCATENATE lv_body ', ' INTO lv_body.
      ENDIF.
      CONCATENATE lv_body '"' ls_json-name '": "' ls_json-value '"' INTO lv_body.
    ENDLOOP.                    "attributes
    CONCATENATE lv_body '}]' INTO lv_body.
  ENDLOOP.
  CONCATENATE lv_body '}]}]}' INTO lv_body.


ENDMETHOD.


  METHOD create_token.

    CONSTANTS: lc_oauth_profile             TYPE ain_config_name VALUE 'AIN_OAUTH_PROFILE'.

    TYPES: BEGIN OF ty_token,
             access_token TYPE string,
           END OF ty_token.

    DATA: lo_http_client    TYPE REF TO if_http_client.
    DATA: lo_oa2c_client    TYPE REF TO if_oauth2_client.

    DATA: ls_token          TYPE ty_token.

    DATA: lv_oauth_cc       TYPE string.
    DATA: lv_client_id      TYPE string.
    DATA: lv_client_secret  TYPE string.
    DATA: lv_token_url      TYPE string.
    DATA: lv_ssl            TYPE ssfapplssl.
    DATA: lv_status_code    TYPE i.
    DATA: lv_reason         TYPE string.
    DATA: lv_response_data  TYPE string.
    DATA: lv_oauth_profile  TYPE oa2c_profile.

*-----------------------------------------------------------------------
* Check OAuth Client Credentials execution is required
*-----------------------------------------------------------------------
*    lv_oauth_cc =  cl_ain_common_utility=>get_config_value( 'AIN_OAUTH_CC' ).
    lv_oauth_cc = 'X'.
    IF lv_oauth_cc  = abap_true.
**-----------------------------------------------------------------------
** Get Client ID, Client Secret, Token URL
**-----------------------------------------------------------------------
      lv_client_id      =  iv_client_id.
      lv_client_secret  =  iv_client_secret.
      lv_token_url      =  iv_token_url.

*-----------------------------------------------------------------------
* OAuth Client Credentials Flow
*-----------------------------------------------------------------------
      CALL METHOD cl_http_client=>create_by_url(
        EXPORTING
          url    = lv_token_url
          ssl_id = lv_ssl
        IMPORTING
          client = lo_http_client ).

      lo_http_client->propertytype_logon_popup = lo_http_client->co_disabled.

      lo_http_client->request->set_method( method = if_http_request=>co_request_method_post ).

      lo_http_client->request->set_content_type( content_type = 'application/x-www-form-urlencoded' ).

      lo_http_client->request->set_form_field( EXPORTING   name  = 'grant_type'
                                                           value = 'client_credentials' ).

      lo_http_client->request->set_form_field( EXPORTING   name  = 'client_id'
                                                           value = lv_client_id ).

      lo_http_client->request->set_form_field( EXPORTING   name  = 'client_secret'
                                                           value = lv_client_secret ).

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

      lv_response_data = lo_http_client->response->get_cdata( ).

      lo_http_client->close( ).

      IF lv_status_code = 200 AND lv_response_data IS NOT INITIAL.
        cl_ain_services_helper=>deserialize(  EXPORTING json =  lv_response_data
                                              CHANGING  data =  ls_token  ).
      ENDIF.

      IF ls_token-access_token IS NOT INITIAL.
        CONCATENATE 'Bearer' ls_token-access_token INTO cv_oauth_token SEPARATED BY space.
      ENDIF.

    ELSE.
*-----------------------------------------------------------------------
* Get the OAuth profile
*-----------------------------------------------------------------------
      lv_oauth_profile =  cl_ain_common_utility=>get_config_value( lc_oauth_profile ).
      IF lv_oauth_profile IS NOT INITIAL.
*-----------------------------------------------------------------------
* Create OAuth client
*-----------------------------------------------------------------------
        TRY.
            cl_oauth2_client=>create(
               EXPORTING
                 i_profile        = lv_oauth_profile
               RECEIVING
                 ro_oauth2_client = lo_oa2c_client ).
          CATCH cx_oa2c.
            RETURN.
        ENDTRY.
        TRY.
            lo_oa2c_client->set_token( co_http_client ).
          CATCH cx_oa2c.
            RETURN.
        ENDTRY.
      ENDIF.
    ENDIF.


  ENDMETHOD.
ENDCLASS.
