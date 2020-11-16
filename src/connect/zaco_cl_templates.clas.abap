class ZACO_CL_TEMPLATES definition
  public
  final
  create public .

public section.

  constants GC_MANUFACTURER_OLD type STRING value '57BFA5F5E8DF7418E10000000A4E73B2' ##NO_TEXT.
  constants GC_MANUFACTURER type STRING value '7A412F4496CB4015BEBED9755B17543E' ##NO_TEXT.

  class-methods CLASS_CONSTRUCTOR .
  methods CONSTRUCTOR
    importing
      !IO_HTTP_CLIENT type ref to IF_HTTP_CLIENT .
  methods GET_MODEL_ID_BY_NAME
    importing
      !IV_NAME type ZACO_DE_MODELNAME
    changing
      !CV_MODEL_ID type STRING
      !CV_OK type BOOLEAN .
  methods GET_EQUIPMENT_ID_BY_NAME
    importing
      !IV_NAME type ZACO_DE_MODELNAME
    changing
      !CV_MODEL_ID type STRING
      !CV_OK type BOOLEAN .
  methods GET_GROUP_ID_BY_NAME
    importing
      !IV_NAME type GROUP
    changing
      !CV_GROUP_ID type STRING
      !CV_OK type BOOLEAN .
  methods GET_ATTRIBUTE_ID_BY_NAME
    importing
      !IV_NAME type GROUP
    changing
      !CV_ATTRIBUTE_ID type STRING
      !CV_OK type BOOLEAN .
  class-methods TRANSLATE_UOM_TO_AIN
    importing
      !IV_UOM_ERP type ZACO_DE_EINHEIT
      !IV_RFCDEST type RFCDEST optional
    changing
      !CV_LOGHNDL type BALLOGHNDL optional
      !CV_UOM_AIN type ZACO_DE_EINHEIT
      !CV_DIMENSION type ZACO_DE_DIMENSION .
  methods GET_MODEL_NAME_BY_MATERIAL
    importing
      !IV_MATNR type MATNR
      !IV_KMATN type KMATN
    changing
      !IC_NAME type ZACO_DE_MODELNAME
    exceptions
      NOT_FOUND .
  methods GET_GROUP_TEMPLATE_BY_NAME
    importing
      !IV_NAME type GROUP
    changing
      !CV_AIN_NAME type ZACO_DE_GROUP .
  methods GET_EXTERNAL_SYSTEM
    importing
      !IV_SYNAME type SYST-SYSID
      !IV_CLIENT type SYST-MANDT
      !IV_RFCDEST type RFCDEST
    changing
      !CV_SYSTEMID type ZACO_DE_EXTERN_SYSTEM_ID
      !CV_OK type CHAR1
    exceptions
      NO_SYSTEM_FOUND .
  methods GET_TEMPLATE_ID_BY_NAME
    importing
      !IV_TEMPLATENAME type ZACO_DE_TEMPLATE
    changing
      !CV_TEMPLATE_ID type STRING
      !CV_OK type BOOLEAN .
  methods GET_E_CL_GROUP_ID_BY_NAME
    importing
      !IV_NAME type GROUP
    changing
      !CV_GROUP_ID type STRING
      !CV_OK type BOOLEAN .
protected section.
private section.

  data GO_HTTP_CLIENT type ref to IF_HTTP_CLIENT .
  data GT_MODEL type ZACO_TT_MODEL .

  methods GET_GROUP_NAME_BY_NAME
    importing
      !IV_NAME type GROUP
    changing
      !CV_AIN_NAME type ZACO_DE_GROUP .
ENDCLASS.



CLASS ZACO_CL_TEMPLATES IMPLEMENTATION.


  method CLASS_CONSTRUCTOR.
  endmethod.


method CONSTRUCTOR.

  go_http_client = io_http_client.

endmethod.


method GET_ATTRIBUTE_ID_BY_NAME.

  data: lt_RESULT       Type Zaco_T_JSON_BODY.

  data: ls_result       Type Zaco_S_JSON_BODY.

  data: lv_service      type string.
  data: lv_filter       type string.

  data: lv_status_code  type i.
  data: lv_reason       type string.
  data: lv_json         type string.
  data: lv_length       type i.

  cv_ok = 'X'.

  lv_filter = |/attribute?$filter=name eq '|.         "Attributgruppe

  concatenate ZACO_CL_CONNECTION_AIN=>gv_service lv_filter iv_name '''' into lv_service.

  cl_http_utility=>set_request_uri( request = go_http_client->request
                                    uri  = lv_service ).

  go_http_client->request->set_method( 'GET' ).

*-----------------------------------------------------------------------
* Send Request and Receive Response
*-----------------------------------------------------------------------
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

  if lv_status_code eq '200'.
    lv_json = go_http_client->response->get_cdata( ).

*------------ Lv_json deserialisieren und equipmentId filtern   ----------------*
    CALL METHOD ZACO_CL_JSON=>JSON_TO_DATA
      EXPORTING
        iV_JSON = lv_json
      CHANGING
        CT_DATA = lt_result.

    lv_length = strlen( lv_json ).
    if lv_length > 2.
      read table lt_result into ls_result with key name = 'id'.
      if sy-subrc = 0.
        cv_attribute_id = ls_result-value.
      else.
        cv_ok = space.
      endif.
    else.
      cv_ok = space.
    endif.
  else.
    cv_ok = space.
  endif.

endmethod.


method GET_EQUIPMENT_ID_BY_NAME.

  data: lt_RESULT       Type ZACO_T_JSON_BODY.

  data: ls_result       Type ZACO_S_JSON_BODY.

  data: lv_service      type string.
  data: lv_filter       type string.

  data: lv_status_code  type i.
  data: lv_reason       type string.
  data: lv_json         type string.
  data: lv_length       type i.

  cv_ok = 'X'.

  lv_filter = |/template?$filter=typeCode eq '4' and name eq '|.         "'Equipment Template' and name eq '|.

  concatenate ZACO_CL_CONNECTION_AIN=>gv_service lv_filter iv_name '''' into lv_service.

  cl_http_utility=>set_request_uri( request = go_http_client->request
                                    uri  = lv_service ).

  go_http_client->request->set_method( 'GET' ).

*-----------------------------------------------------------------------
* Send Request and Receive Response
*-----------------------------------------------------------------------
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

  if lv_status_code eq '200'.
    lv_json = go_http_client->response->get_cdata( ).

*------------ Lv_json deserialisieren und equipmentId filtern   ----------------*
    CALL METHOD ZACO_CL_JSON=>JSON_TO_DATA
      EXPORTING
        iV_JSON = lv_json
      CHANGING
        CT_DATA = lt_result.

    lv_length = strlen( lv_json ).
    if lv_length > 2.
      read table lt_result into ls_result with key name = 'id'.
      if sy-subrc = 0.
        cv_model_id = ls_result-value.
      else.
        cv_ok = space.
      endif.
    else.
      cv_ok = space.
    endif.
  else.
    cv_ok = space.
  endif.

endmethod.


METHOD GET_EXTERNAL_SYSTEM.

  DATA: lo_http_client TYPE REF TO if_http_client.

  DATA: lt_result       TYPE zaco_t_json_body.

  DATA: ls_result       TYPE zaco_s_json_body.

  DATA: lv_filter       TYPE string.
  DATA: lv_service      TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_length       TYPE i.
  DATA: lv_idx          TYPE sy-tabix.
  DATA: lv_clientx      TYPE sy-tabix.

  CLEAR cv_ok.
  CLEAR cv_systemid.

  CALL METHOD zaco_cl_connection_ain=>connect_to_ain
    EXPORTING
      iv_rfcdest               = iv_rfcdest
    CHANGING
      co_http_client           = lo_http_client
    EXCEPTIONS
      dest_not_found           = 1
      destination_no_authority = 2
      OTHERS                   = 3.
  IF sy-subrc = 0.

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

*------------ Lv_json deserialisieren und equipmentId filtern   ----------------*
      CALL METHOD zpsain_cl_json=>json_to_data
        EXPORTING
          iv_json = lv_json
        CHANGING
          ct_data = lt_result.
      LOOP AT lt_result INTO ls_result WHERE name = 'SystemName'
                                        AND  value = iv_syname.
        lv_idx = sy-tabix - 1.
        lv_clientx = lv_idx + 3.
        READ TABLE lt_result INTO ls_result INDEX lv_clientx.
        IF sy-subrc = 0.
          IF ls_result-value = iv_client.
            READ TABLE lt_result INTO ls_result INDEX lv_idx.
            IF sy-subrc = 0.
              cv_systemid = ls_result-value.
              cv_ok = 'X'.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDMETHOD.


method GET_E_CL_GROUP_ID_BY_NAME.

  data: lt_RESULT       Type ZACO_T_JSON_BODY.

  data: ls_result       Type ZACO_S_JSON_BODY.

  data: lv_service      type string.
  data: lv_filter       type string.

  data: lv_status_code  type i.
  data: lv_reason       type string.
  data: lv_json         type string.
  data: lv_length       type i.

  cv_ok = 'X'.

  lv_filter = |/attributeGroup?$filter=name eq '|.         "Attributgruppe

  concatenate ZACO_CL_CONNECTION_AIN=>gv_service lv_filter iv_name '''' into lv_service.

  cl_http_utility=>set_request_uri( request = go_http_client->request
                                    uri  = lv_service ).

  go_http_client->request->set_method( 'GET' ).

*-----------------------------------------------------------------------
* Send Request and Receive Response
*-----------------------------------------------------------------------
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

  if lv_status_code eq '200'.
    lv_json = go_http_client->response->get_cdata( ).

*------------ Lv_json deserialisieren und equipmentId filtern   ----------------*
    CALL METHOD ZACO_CL_JSON=>JSON_TO_DATA
      EXPORTING
        iV_JSON = lv_json
      CHANGING
        CT_DATA = lt_result.

    lv_length = strlen( lv_json ).
    if lv_length > 2.
      read table lt_result into ls_result with key name = 'id'.
      if sy-subrc = 0.
        cv_group_id = ls_result-value.
      else.
        cv_ok = space.
      endif.
    else.
      cv_ok = space.
    endif.
  else.
    cv_ok = space.
  endif.

endmethod.


method GET_GROUP_ID_BY_NAME.

  data: lt_RESULT       Type ZACO_T_JSON_BODY.

  data: ls_result       Type ZACO_S_JSON_BODY.

  data: lv_service      type string.
  data: lv_filter       type string.

  data: lv_status_code  type i.
  data: lv_reason       type string.
  data: lv_json         type string.
  data: lv_length       type i.
  data: lv_name         type zaco_de_group.


  CALL METHOD me->GET_GROUP_NAME_BY_NAME
    EXPORTING
      IV_NAME     = iv_name
    CHANGING
      CV_AIN_NAME = lv_name.


  cv_ok = 'X'.

  lv_filter = |/attributeGroup?$filter=name eq '|.         "Attributgruppe

  concatenate ZACO_CL_CONNECTION_AIN=>gv_service lv_filter lv_name '''' into lv_service.

  cl_http_utility=>set_request_uri( request = go_http_client->request
                                    uri  = lv_service ).

  go_http_client->request->set_method( 'GET' ).

*-----------------------------------------------------------------------
* Send Request and Receive Response
*-----------------------------------------------------------------------
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

  if lv_status_code eq '200'.
    lv_json = go_http_client->response->get_cdata( ).

*------------ Lv_json deserialisieren und equipmentId filtern   ----------------*
    CALL METHOD ZACO_CL_JSON=>JSON_TO_DATA
      EXPORTING
        iV_JSON = lv_json
      CHANGING
        CT_DATA = lt_result.

    lv_length = strlen( lv_json ).
    if lv_length > 2.
      read table lt_result into ls_result with key name = 'id'.
      if sy-subrc = 0.
        cv_group_id = ls_result-value.
      else.
        cv_ok = space.
      endif.
    else.
      cv_ok = space.
    endif.
  else.
    cv_ok = space.
  endif.

endmethod.


method GET_GROUP_NAME_BY_NAME.

  data: ls_groups type ZACO_T_GROUPS.

  select single * from ZACO_T_GROUPS into ls_groups where grnam = iv_name.
  if sy-subrc = 0.
    cv_ain_name = ls_groups-ain_group.
  else.
    clear cv_ain_name.
  endif.

endmethod.


METHOD GET_GROUP_TEMPLATE_BY_NAME.

  DATA: ls_groups TYPE zaco_t_groups.

  SELECT SINGLE * FROM zaco_t_groups INTO ls_groups WHERE grnam = iv_name.
  IF sy-subrc = 0.
    cv_ain_name = ls_groups-ain_template.
  ELSE.
    CLEAR cv_ain_name.
  ENDIF.

ENDMETHOD.


method GET_MODEL_ID_BY_NAME.

  data: lt_RESULT       Type ZACO_T_JSON_BODY.

  data: ls_result       Type ZACO_S_JSON_BODY.

  data: lv_service      type string.
  data: lv_filter       type string.

  data: lv_status_code  type i.
  data: lv_reason       type string.
  data: lv_json         type string.
  data: lv_length       type i.

  cv_ok = 'X'.

  lv_filter = |/models?$filter=name eq '|.
*  lv_filter = |/template?$filter=type eq 'Model Template' and name eq '|.

  concatenate ZACO_CL_CONNECTION_AIN=>gv_service lv_filter iv_name '''' into lv_service.

  cl_http_utility=>set_request_uri( request = go_http_client->request
                                    uri  = lv_service ).

  go_http_client->request->set_method( 'GET' ).

*-----------------------------------------------------------------------
* Send Request and Receive Response
*-----------------------------------------------------------------------
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

  if lv_status_code eq '200'.
    lv_json = go_http_client->response->get_cdata( ).

*------------ Lv_json deserialisieren und equipmentId filtern   ----------------*
    CALL METHOD ZACO_CL_JSON=>JSON_TO_DATA
      EXPORTING
        iV_JSON = lv_json
      CHANGING
        CT_DATA = lt_result.

    lv_length = strlen( lv_json ).
    if lv_length > 2.
      read table lt_result into ls_result with key name = 'modelId'.
      if sy-subrc = 0.
        cv_model_id = ls_result-value.
      else.
        cv_ok = space.
      endif.
    else.
      cv_ok = space.
    endif.
  else.
    cv_ok = space.
  endif.

endmethod.


METHOD GET_MODEL_NAME_BY_MATERIAL.

  DATA: ls_model  TYPE zaco_t_model.
  DATA: lv_anz    TYPE sy-tfill.
  DATA: lv_group  TYPE zaco_de_group.


  DESCRIBE TABLE gt_model LINES lv_anz.
  IF lv_anz = 0.
    SELECT * FROM zaco_t_model APPENDING TABLE gt_model. "#EC CI_NOWHERE
  ENDIF.
  READ TABLE gt_model INTO ls_model WITH KEY matnr = iv_matnr.
  IF sy-subrc = 0.
    ic_name = ls_model-modelname.
  ELSE.
    READ TABLE gt_model INTO ls_model WITH KEY matnr = iv_kmatn.   "Materialvariante
    IF sy-subrc = 0.
      ic_name = ls_model-modelname.
    ELSE.
      RAISE not_found.
    ENDIF.
  ENDIF.

ENDMETHOD.


method GET_TEMPLATE_ID_BY_NAME.

  data: lt_RESULT       Type ZACO_T_JSON_BODY.

  data: ls_result       Type ZACO_S_JSON_BODY.

  data: lv_service      type string.
  data: lv_filter       type string.

  data: lv_status_code  type i.
  data: lv_reason       type string.
  data: lv_json         type string.
  data: lv_length       type i.

  cv_ok = 'X'.

  lv_filter = |/template?$filter=typeCode eq '4' and name eq '|.         "'Equipment Template' and name eq '|.

  concatenate ZACO_CL_CONNECTION_AIN=>gv_service lv_filter iv_templatename '''' into lv_service.

  cl_http_utility=>set_request_uri( request = go_http_client->request
                                    uri  = lv_service ).

  go_http_client->request->set_method( 'GET' ).

*-----------------------------------------------------------------------
* Send Request and Receive Response
*-----------------------------------------------------------------------
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

  if lv_status_code eq '200'.
    lv_json = go_http_client->response->get_cdata( ).

*------------ Lv_json deserialisieren und equipmentId filtern   ----------------*
    CALL METHOD ZACO_CL_JSON=>JSON_TO_DATA
      EXPORTING
        iV_JSON = lv_json
      CHANGING
        CT_DATA = lt_result.

    lv_length = strlen( lv_json ).
    if lv_length > 2.
      read table lt_result into ls_result with key name = 'id'.
      if sy-subrc = 0.
        cv_template_id = ls_result-value.
      else.
        cv_ok = space.
      endif.
    else.
      cv_ok = space.
    endif.
  else.
    cv_ok = space.
  endif.

endmethod.


METHOD TRANSLATE_UOM_TO_AIN.


  DATA: lo_http_client TYPE REF TO if_http_client.

  DATA: lt_result       TYPE zaco_t_json_body.

  DATA: ls_result       TYPE zaco_s_json_body.

  DATA: lv_service      TYPE string.
  DATA: lv_filter       TYPE string.

  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_length       TYPE i.
  DATA: lv_body         TYPE string.

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
*   Implement suitable error handling here
  ENDIF.

  lv_filter = |/uom/targetunits|.         "Attributgruppe

  CONCATENATE '{ "srcUnits" :[ "' iv_uom_erp '" ] }' INTO lv_body.
  CONCATENATE zaco_cl_connection_ain=>gv_service lv_filter INTO lv_service.

  cl_http_utility=>set_request_uri( request = lo_http_client->request
                                    uri  = lv_service ).

  lo_http_client->request->set_method( 'POST' ).
  lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).

  lo_http_client->request->set_cdata( lv_body ).
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
        ct_data = lt_result.

    lv_length = strlen( lv_json ).
    IF lv_length > 2.
      READ TABLE lt_result INTO ls_result WITH KEY name = 'targetUnitIsoCode'.
      IF sy-subrc = 0.
        cv_uom_ain = ls_result-value.
      ENDIF.
      READ TABLE lt_result INTO ls_result WITH KEY name = 'dimensionId'.
      IF sy-subrc = 0.
        cv_dimension = ls_result-value.
      ENDIF.
    ENDIF.
  ENDIF. "200
ENDMETHOD.
ENDCLASS.
