class ZACO_CL_SPAREPARTS_MANAGEMENT definition
  public
  create public .

public section.

  methods HAS_EQUIPMENT_SPAREPARTS
    importing
      !IV_EQUI_AIN type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY
      !CV_BOM type CHAR1 .
  methods HANDLE_SPAREPART_OF_EQUIPMENT
    importing
      !IV_ASIGNEEID type STRING optional
      !IO_EQUIP_STUELI type ref to ZACO_CL_EQUIP_ERP_STUELI
      !IV_EQUNR type EQUNR
      !IV_ACTION type STRING
      !IV_RFCDEST type RFCDEST optional
    changing
      !CT_RETURN type ZACO_T_JSON_BODY
      !CO_HTTP_CLIENT type ref to IF_HTTP_CLIENT
      !CV_LOGHNDL type BALLOGHNDL optional .
  methods DELETE_SPAREPART_ASSIGNMENT
    importing
      !IV_ASIGNEEID type STRING optional
      !IO_EQUIP_STUELI type ref to ZACO_CL_EQUIP_ERP_STUELI
      !IV_EQUNR type EQUNR
      !IV_ACTION type STRING
      !IV_RFCDEST type RFCDEST optional
    changing
      !CT_RETURN type ZACO_T_JSON_BODY
      !CO_HTTP_CLIENT type ref to IF_HTTP_CLIENT
      !CV_LOGHNDL type BALLOGHNDL optional .
protected section.
private section.

  data GS_LOG type BAL_S_LOG .
  data GS_MSG type BAL_S_MSG .

  methods ASSIGHNEEID
    importing
      !IV_ASIGNEEID type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods OPERATION_TYPE
    importing
      !IV_OPERATION type STRING optional
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods PARTID
    importing
      !IV_PARTID type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods QUANTITY
    importing
      !IV_QUANTITY type KMPMG
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods OPERATIONQUANTITY
    importing
      !IV_QUANTITY type KMPMG
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods COMMISSIONINGQUANTITY
    importing
      !IV_QUANTITY type KMPMG
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods INITIALQUANTITY
    importing
      !IV_QUANTITY type KMPMG
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods ADVISEDSTOCKQUANTITY
    importing
      !IV_QUANTITY type KMPMG
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods BOMQUANTITY
    importing
      !IV_QUANTITY type KMPMG
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods ADDITIONALINFO
    importing
      !IV_INFO type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
ENDCLASS.



CLASS ZACO_CL_SPAREPARTS_MANAGEMENT IMPLEMENTATION.


method ADDITIONALINFO.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'additionalInfo'.
  ls_json-value = iv_info.
  ls_json-parent = 'partAssignments'.
  append ls_json to ct_json.

endmethod.


method ADVISEDSTOCKQUANTITY.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'advisedStockQuantity'.
  ls_json-value = iv_quantity.
  ls_json-parent = 'partAssignments'.
  append ls_json to ct_json.

endmethod.


method ASSIGHNEEID.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'assigneeID'.
  ls_json-value = iv_asigneeid.
  append ls_json to ct_json.

endmethod.


method BOMQUANTITY.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'bomQuantity'.
  ls_json-value = iv_quantity.
  ls_json-parent = 'partAssignments'.
  append ls_json to ct_json.

endmethod.


method COMMISSIONINGQUANTITY.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'commissioningQuantity'.
  ls_json-value = iv_quantity.
  ls_json-parent = 'partAssignments'.
  append ls_json to ct_json.

endmethod.


METHOD DELETE_SPAREPART_ASSIGNMENT.

  DATA: lo_http_client TYPE REF TO if_http_client.
  DATA: lo_sparepart   TYPE REF TO zaco_cl_spareparts.
  DATA: lo_stueli_pos  TYPE REF TO zaco_cl_equip_erp_stueli_pos.
  DATA: lo_material    TYPE REF TO zaco_cl_material.

  DATA: lt_json   TYPE zaco_t_json_body.
  DATA: lt_stueli TYPE zaco_tt_equi_stueli_pos.
  DATA: lt_result TYPE zaco_t_json_body.

  DATA: ls_stueli TYPE zaco_s_equi_stueli_pos.
  DATA: ls_return TYPE zaco_s_json_body.

  DATA: lv_ok           TYPE char1.
  DATA: lv_matid        TYPE string.
  DATA: lv_service      TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_tfill        TYPE sy-tfill.

  IF cv_loghndl IS INITIAL.
    CALL METHOD zaco_cl_logs=>create_log_handler
      EXPORTING
        is_log       = gs_log
        iv_objekt    = 'EQUI'
        iv_subobject = 'ZACOAINERS'
      CHANGING
        cv_loghndl   = cv_loghndl.
  ENDIF.

  CALL METHOD zaco_cl_connection_ain=>connect_to_ain
    EXPORTING
      iv_rfcdest     = iv_rfcdest
    CHANGING
      co_http_client = lo_http_client.
  IF sy-subrc <> 0.
*message i102(ZPSAIN)
    gs_msg-msgty = 'E'.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgno = '102'.  "Verbindung zu AIN System fehlgeschlagen.
    CALL METHOD zaco_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.
  ENDIF.

  CONCATENATE zaco_cl_connection_ain=>gv_service '/equipment(' iv_asigneeid ')/spareparts' INTO lv_service.
  cl_http_utility=>set_request_uri( request = lo_http_client->request
                                       uri  = lv_service ).
  lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).

  lo_http_client->request->set_method( 'GET' ).
*-----------------------------------------------------------------------
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
  IF lv_status_code GE 299.
*  message i108(ZPSAIN).
    gs_msg-msgty = 'E'.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgno = '110'.  ""Equipment &1 wurde noch nicht ins AIN übertragen.
    gs_msg-msgv1 = iv_equnr.
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
      ct_data = ct_return.

  IF sy-subrc <> 0.
*message i102(ZPSAIN)
    gs_msg-msgty = 'E'.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgno = '110'.  "Equipment &1 wurde noch nicht ins AIN übertragen.
    gs_msg-msgv1 = iv_asigneeid.
    CALL METHOD zaco_cl_logs=>add_log_entry
      EXPORTING
        is_msg     = gs_msg
        iv_loghndl = cv_loghndl.
  ELSE.
    lv_ok = 'X'.
  ENDIF.
  CALL METHOD lo_http_client->close( ).
  CLEAR lv_json.
  DESCRIBE TABLE ct_return LINES lv_tfill.

  IF lv_ok = 'X' AND lv_tfill > 0. "Stückliste im AIN vorhanden
*------------ Daten aus LT_RETURN
    LOOP AT ct_return INTO ls_return WHERE name = '{id'
                                      OR   name = 'id'.


      CALL METHOD zaco_cl_connection_ain=>connect_to_ain
        EXPORTING
          iv_rfcdest     = iv_rfcdest
        CHANGING
          co_http_client = lo_http_client.
      IF sy-subrc <> 0.
*message i102(ZPSAIN)
        gs_msg-msgty = 'E'.
        gs_msg-msgid = 'ZACO'.
        gs_msg-msgno = '102'.  "Verbindung zu AIN System fehlgeschlagen.
        CALL METHOD zaco_cl_logs=>add_log_entry
          EXPORTING
            is_msg     = gs_msg
            iv_loghndl = cv_loghndl.
      ENDIF.


      CALL METHOD me->assighneeid
        EXPORTING
          iv_asigneeid = iv_asigneeid
        CHANGING
          ct_json      = lt_json.

      CALL METHOD me->operation_type
        EXPORTING
          iv_operation = 'rmv'       "Remove
        CHANGING
          ct_json      = lt_json.
*------------ Daten aus LT_RETURN
      CALL METHOD me->partid
        EXPORTING
          iv_partid = ls_return-value
        CHANGING
          ct_json   = lt_json.


      CONCATENATE zaco_cl_connection_ain=>gv_service '/equipment/spareparts' INTO lv_service.
      cl_http_utility=>set_request_uri( request = lo_http_client->request
                                           uri  = lv_service ).

      lo_http_client->request->set_method( 'PUT' ).
      lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).

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
*  go_http_client->refresh_request( ).
      IF lv_status_code GE 299.
*  message i108(ZPSAIN).
        gs_msg-msgty = 'E'.
        gs_msg-msgid = 'ZACO'.
        gs_msg-msgno = '133'.  "zuordnung material &1 zu equipment &2 nicht löschbar o. nicht vorhanden.
        gs_msg-msgv1 = iv_asigneeid.
        gs_msg-msgv2 = lv_status_code.
        CALL METHOD zaco_cl_logs=>add_log_entry
          EXPORTING
            is_msg     = gs_msg
            iv_loghndl = cv_loghndl.

      ENDIF.
      CALL METHOD lo_http_client->close( ).
    ENDLOOP.
  ENDIF.   "lv_ok

ENDMETHOD.


METHOD HANDLE_SPAREPART_OF_EQUIPMENT.

  DATA: lo_http_client TYPE REF TO if_http_client.
  DATA: lo_sparepart   TYPE REF TO zaco_cl_spareparts.
  DATA: lo_stueli_pos  TYPE REF TO ZACO_CL_EQUIP_ERP_STUELI_POS.  "zpspp_cl_equipment_stueli_pos.
  DATA: lo_material    TYPE REF TO ZACO_CL_MATERIAL.

  DATA: lt_json   TYPE zaco_t_json_body.
  DATA: lt_stueli TYPE ZACO_TT_EQUI_STUELI_POS.     "zpspp_tt_equi_stueli_pos.
  DATA: lt_result TYPE zaco_t_json_body.

  DATA: ls_stueli TYPE zaco_s_equi_stueli_pos.

  DATA: lv_ok           TYPE char1.
  DATA: lv_matnr        TYPE matnr.
  DATA: lv_erskz        TYPE erskz.
  DATA: lv_matid        TYPE string.
  DATA: lv_menge        TYPE kmpmg.
  DATA: lv_service      TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_posnr        TYPE sposn.
  DATA: lv_info         TYPE string.

  IF cv_loghndl IS INITIAL.
    CALL METHOD zaco_cl_logs=>create_log_handler
      EXPORTING
        is_log       = gs_log
        iv_objekt    = 'EQUI'
        iv_subobject = 'ZPSAINERS'
      CHANGING
        cv_loghndl   = cv_loghndl.
  ENDIF.

  CALL METHOD io_equip_stueli->get_positionen
    CHANGING
      ct_position = lt_stueli.

  LOOP AT lt_stueli INTO ls_stueli.

    lo_stueli_pos ?= ls_stueli-lo_position.
    REFRESH lt_json.

    CALL METHOD lo_stueli_pos->get_matnr
      CHANGING
        cv_matnr = lv_matnr.

    CALL METHOD lo_stueli_pos->get_erskz
      CHANGING
        cv_erskz = lv_erskz.
*------- Nur Ersatzteile
*    IF lv_erskz = 'X' OR lv_erskz = 'E'.
    IF lv_erskz <> space.
      CALL METHOD zaco_cl_connection_ain=>connect_to_ain
        EXPORTING
          iv_rfcdest     = iv_rfcdest
        CHANGING
          co_http_client = lo_http_client.
      IF sy-subrc <> 0.
*message i102(ZPSAIN)
        gs_msg-msgty = 'E'.
        gs_msg-msgid = 'ZPSAIN'.
        gs_msg-msgno = '102'.  "Verbindung zu AIN System fehlgeschlagen.
        CALL METHOD zaco_cl_logs=>add_log_entry
          EXPORTING
            is_msg     = gs_msg
            iv_loghndl = cv_loghndl.
      ENDIF.

      CREATE OBJECT lo_sparepart.
*        EXPORTING
*          co_http_client = lo_http_client.

      CALL METHOD lo_sparepart->spareparts_already_transferred
        EXPORTING
          iv_matnr       = lv_matnr
          iv_rfcdest     = iv_rfcdest
        CHANGING
          cv_transferred = lv_ok
          cv_ain_part    = lv_matid.

      CALL METHOD lo_http_client->close( ).
      IF lv_ok = space. " not transferred
*---- Einlesen Materialstammdaten
        CREATE OBJECT lo_material.
        CALL METHOD lo_material->set_matnr
          EXPORTING
            iv_matnr = lv_matnr
            iv_werks = '0002'.

        CALL METHOD lo_sparepart->create_sparepart
          EXPORTING
            io_material = lo_material
            iv_rfcdest  = iv_rfcdest
          CHANGING
            ct_result   = lt_result.

        CALL METHOD zaco_cl_connection_ain=>connect_to_ain
          EXPORTING
            iv_rfcdest     = iv_rfcdest
          CHANGING
            co_http_client = lo_http_client.

        IF sy-subrc <> 0.
*message i102(ZPSAIN)
          gs_msg-msgty = 'E'.
          gs_msg-msgid = 'ZPSAIN'.
          gs_msg-msgno = '102'.  "Verbindung zu AIN System fehlgeschlagen.
          CALL METHOD zaco_cl_logs=>add_log_entry
            EXPORTING
              is_msg     = gs_msg
              iv_loghndl = cv_loghndl.
        ENDIF.

        CREATE OBJECT lo_sparepart.
*          EXPORTING
*            co_http_client = lo_http_client.

        CALL METHOD lo_sparepart->spareparts_already_transferred
          EXPORTING
            iv_matnr       = lv_matnr
            iv_rfcdest     = iv_rfcdest
          CHANGING
            cv_transferred = lv_ok
            cv_ain_part    = lv_matid.

        CALL METHOD lo_http_client->close( ).
      ENDIF.
      IF lv_ok = 'X'. "Material im AIN vorhanden
        CALL METHOD me->assighneeid
          EXPORTING
            iv_asigneeid = iv_asigneeid
          CHANGING
            ct_json      = lt_json.

        CALL METHOD me->operation_type
          EXPORTING
            iv_operation = iv_action
          CHANGING
            ct_json      = lt_json.

        CALL METHOD me->partid
          EXPORTING
            iv_partid = lv_matid
          CHANGING
            ct_json   = lt_json.

        CALL METHOD lo_stueli_pos->get_menge
          CHANGING
            cv_menge = lv_menge.

        CALL METHOD me->quantity
          EXPORTING
            iv_quantity = '0'
          CHANGING
            ct_json     = lt_json.

*        CALL METHOD me->OPERATIONQUANTITY
*          EXPORTING
*            IV_QUANTITY = lv_menge
*          CHANGING
*            CT_JSON     = lt_json.

        CALL METHOD me->bomquantity
          EXPORTING
            iv_quantity = lv_menge
          CHANGING
            ct_json     = lt_json.

        CALL METHOD me->commissioningquantity
          EXPORTING
            iv_quantity = '0'       "Vorerst festwert
          CHANGING
            ct_json     = lt_json.

        CALL METHOD me->initialquantity
          EXPORTING
            iv_quantity = '0'
          CHANGING
            ct_json     = lt_json.

        CALL METHOD me->advisedstockquantity
          EXPORTING
            iv_quantity = '0'
          CHANGING
            ct_json     = lt_json.

        CALL METHOD lo_stueli_pos->get_posnr
          CHANGING
            cv_posnr = lv_posnr.

        lv_info = lv_posnr.
        CALL METHOD me->additionalinfo
          EXPORTING
            iv_info = lv_info              "Zeichnungspositionsnummer
          CHANGING
            ct_json = lt_json.


        CONCATENATE zaco_cl_connection_ain=>gv_service '/equipment/spareparts' INTO lv_service.
        cl_http_utility=>set_request_uri( request = co_http_client->request
                                             uri  = lv_service ).

        co_http_client->request->set_method( 'PUT' ).
        co_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).

        CALL METHOD zaco_cl_connection_ain=>construct_body
          EXPORTING
            it_body = lt_json
          CHANGING
            cv_body = lv_body.

        co_http_client->request->set_cdata( lv_body ).
**-----------------------------------------------------------------------
** Send Request and Receive Response
**-----------------------------------------------------------------------
        co_http_client->send(
          EXCEPTIONS
          http_communication_failure = 1
          http_invalid_state         = 2
          http_processing_failed     = 3
          http_invalid_timeout       = 4
          OTHERS                     = 5 ).

        co_http_client->receive(
          EXCEPTIONS
          http_communication_failure = 1
          http_invalid_state         = 2
          http_processing_failed     = 3
          OTHERS                     = 4 ).

        co_http_client->response->get_status( IMPORTING code   = lv_status_code
                                                        reason = lv_reason ).

*  if lv_status_code ne 200.
*-----------------------------------------------------------------------
* Refresh HTTP Request
*-----------------------------------------------------------------------
*  go_http_client->refresh_request( ).
        IF lv_status_code GE 299.
*  message i108(ZPSAIN).
          gs_msg-msgty = 'E'.
          gs_msg-msgid = 'ZACO'.
          gs_msg-msgno = '108'.  "HTTP Fehler bei Übertragung
          gs_msg-msgv1 = iv_equnr.
          gs_msg-msgv2 = lv_status_code.
          CALL METHOD zaco_cl_logs=>add_log_entry
            EXPORTING
              is_msg     = gs_msg
              iv_loghndl = cv_loghndl.

        ELSE.
*  message i109(ZPSAIN).
          gs_msg-msgty = 'I'.
          gs_msg-msgid = 'ZACO'.
          gs_msg-msgno = '114'.  "Konnte erfolgreich übertragen werden
          gs_msg-msgv1 = lv_matnr.
          gs_msg-msgv2 = iv_equnr.
          CALL METHOD zaco_cl_logs=>add_log_entry
            EXPORTING
              is_msg     = gs_msg
              iv_loghndl = cv_loghndl.

        ENDIF.

        lv_json = co_http_client->response->get_cdata( ).
        CALL METHOD zaco_cl_json=>json_to_data
          EXPORTING
            iv_json = lv_json
          CHANGING
            ct_data = ct_return.

      ELSE. "Material nicht übertragen
        IF sy-subrc <> 0.
*message i102(ZPSAIN)
          gs_msg-msgty = 'E'.
          gs_msg-msgid = 'ZACO'.
          gs_msg-msgno = '115'.  "Ersatzteil &1 wurde noch nicht ans AIN übertragen.
          gs_msg-msgv1 = lv_matnr.
          CALL METHOD zaco_cl_logs=>add_log_entry
            EXPORTING
              is_msg     = gs_msg
              iv_loghndl = cv_loghndl.
        ENDIF.
      ENDIF.  "Material im AIN vorhanden
    ENDIF. "Ersatzteile
  ENDLOOP.


ENDMETHOD.


method HAS_EQUIPMENT_SPAREPARTS.

  data: lo_http_client type ref to if_http_client.

  data: ls_result       Type ZACO_S_JSON_BODY.

  data: lv_service      type string.
  data: lv_filter       type string.
  data: lv_ende         type string.

  data: lv_status_code  type i.
  data: lv_reason       type string.
  data: lv_json         type string.


  lv_filter = |/equipment(|.
  lv_ende = |)/spareparts|.

  concatenate ZACO_CL_CONNECTION_ain=>gv_service lv_filter iv_equi_ain  lv_ende into lv_service.

  CALL METHOD ZACO_CL_CONNECTION_ain=>CONNECT_TO_AIN
    CHANGING
      CO_HTTP_CLIENT = lo_http_client.

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

  if lv_status_code eq '200'.
    lv_json = lo_http_client->response->get_cdata( ).
    cv_bom = 'X'.
*------------ Lv_json deserialisieren und equipmentId filtern   ----------------*
    CALL METHOD ZACO_CL_JSON=>JSON_TO_DATA
      EXPORTING
        iV_JSON = lv_json
      CHANGING
        CT_DATA = ct_json.
  else.
    clear cv_bom.
  endif.

endmethod.


method INITIALQUANTITY.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'initialQuantity'.
  ls_json-value = iv_quantity.
  ls_json-parent = 'partAssignments'.
  append ls_json to ct_json.

endmethod.


method OPERATIONQUANTITY.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'operationQuantity'.
  ls_json-value = iv_quantity.
  ls_json-parent = 'partAssignments'.
  append ls_json to ct_json.

endmethod.


method OPERATION_TYPE.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'operation'.
  ls_json-value = iv_operation.
  append ls_json to ct_json.

endmethod.


method PARTID.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'partID'.
  ls_json-value = iv_partid.
  ls_json-parent = 'partAssignments'.
  ls_json-multiple = 'X'.
  append ls_json to ct_json.

endmethod.


method QUANTITY.

  data: ls_json type zaco_s_json_body.
  data: iv_temp type string.

  move iv_quantity to iv_temp.
  ls_json-name = 'quantity'.
  ls_json-value = iv_temp.
  ls_json-parent = 'partAssignments'.
  append ls_json to Ct_json.

endmethod.
ENDCLASS.
