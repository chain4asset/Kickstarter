class ZACO_CL_DOCUMENT_UPLOAD definition
  public
  create public .

public section.

  methods GET_PHIO_DOCUMENT
    importing
      !IV_BWA_UPLOAD type CHAR1 optional
      !IV_EQUNR type EQUNR
      !IO_EQUIPMENT type ref to ZPSPP_CL_EQUIPMENT optional
    changing
      !CT_PHIO type ZPSAIN_T_PHIO .
  methods UPLOAD_DOCUMENT
    importing
      !IV_EQUNR type EQUNR
      !IV_RFCDEST type RFCDEST optional
      !IO_EQUIPMENT type ref to ZPSPP_CL_EQUIPMENT optional
      !IV_BWA_UPLOAD type CHAR1 optional
    changing
      !CT_RESULT type ZPSAIN_T_JSON_BODY
      !CT_DOC_IDS type ZPSAIN_T_JSON_BODY .
  methods ERMITTLE_DOCUMENT_ID
    importing
      !IV_FILENAME type STRING
      !IV_RFCDEST type RFCDEST
    changing
      !CV_DOCID type STRING .
  methods CONNECT_DOCUMENT_EQUIPMENT
    importing
      !IV_EQUNR type EQUNR
      !IV_RFCDEST type RFCDEST optional
    changing
      !CT_RESULT type ZPSAIN_T_JSON_BODY
      !CT_DOC_IDS type ZPSAIN_T_JSON_BODY .
  methods GET_EQUIPMENT_VERSION
    importing
      !IV_EQUNR type EQUNR
      !IV_RFCDEST type RFCDEST
    changing
      !CT_RESULT type ZPSAIN_T_JSON_BODY
      !CV_VERSION type STRING .
protected section.

  methods READ_DRAD
    importing
      !IV_EQUNR type EQUNR
    changing
      !CT_DOKNR type ZPSAIN_T_DOKNR .
  methods READ_DRAW
    importing
      !IT_DOKNR type ZPSAIN_T_DOKNR
    changing
      !CT_DOKVR type ZPSAIN_T_DOKVER .
  methods READ_LOIO
    importing
      !IT_DOKVR type ZPSAIN_T_DOKVER
    changing
      !CT_PHIO type ZPSAIN_T_PHIO .
  methods PHASE_CODE
    importing
      !IV_ATWRT type ATWRT optional
    changing
      !CT_JSON type ZPSAIN_T_JSON_BODY
      !CV_PHASECODE type STRING optional .
  methods CATEGORY_CODE
    importing
      !IV_ATWRT type ATWRT optional
    changing
      !CV_CATEGORY type STRING optional
      !CT_JSON type ZPSAIN_T_JSON_BODY .
  methods DESCRIPTION
    importing
      !IV_DESCRIPTION type STRING
    changing
      !CT_JSON type ZPSAIN_T_JSON_BODY .
  methods LANGUAGE_CODE
    importing
      !IV_SPRAS type SPRAS
    changing
      !CT_JSON type ZPSAIN_T_JSON_BODY
      !CV_LANGU type CHAR2 .
  methods DOCUMENTID
    importing
      !IV_DOCID type STRING
    changing
      !CT_JSON type ZPSAIN_T_JSON_BODY .
  methods ASSIGNEEID
    importing
      !IV_ASSIGNEEID type STRING
    changing
      !CT_JSON type ZPSAIN_T_JSON_BODY .
  methods VERSION
    importing
      !IV_VERSION type STRING
    changing
      !CT_JSON type ZPSAIN_T_JSON_BODY .
  methods SHORTDESCRIPTION
    importing
      !IV_DESCRIPTION type STRING
    changing
      !CT_JSON type ZPSAIN_T_JSON_BODY .
private section.

  data GS_MSG type BAL_S_MSG .
ENDCLASS.



CLASS ZACO_CL_DOCUMENT_UPLOAD IMPLEMENTATION.


method ASSIGNEEID.

  data: ls_json type zpsain_s_json_body.
*---------- Leer
  ls_json-name = 'assigneeID'.
  ls_json-value = iv_assigneeid.
  ls_json-parent = 'documentIDMapping'.
  append ls_json to ct_json.


endmethod.


method CATEGORY_CODE.

  data: ls_json type zpsain_s_json_body.

  ls_json-name = 'categoryCode'.
  ls_json-value = '10'.
  append ls_json to ct_json.

endmethod.


METHOD connect_document_equipment.

  FIELD-SYMBOLS:  <fs_content>  TYPE sdokcntbin.   "drao.

  DATA: lo_http_client   TYPE REF TO if_http_client.
  DATA: lo_entity        TYPE REF TO if_http_entity.
  DATA: lo_equipment_ain TYPE REF TO zaco_cl_equipment_ain.
  DATA: lo_equipment     TYPE REF TO zaco_cl_equip_erp.

  DATA: lt_json        TYPE zaco_t_json_body.
  DATA: lt_result      TYPE zaco_t_json_body.

  DATA: ls_docid        TYPE zaco_s_json_body.

  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_service      TYPE string.
  DATA: lv_sernr        TYPE gernr.
  DATA: lv_doc_id       TYPE string.
  DATA: lv_transferred  TYPE char1.
  DATA: lv_equi_id      TYPE string.
  DATA: lv_version      TYPE string.
  data: lv_equnr        type equnr.

  lv_equnr = iv_equnr.

*--------
  CALL METHOD zaco_cl_connection_ain=>connect_to_ain
    EXPORTING
      iv_rfcdest               = iv_rfcdest   "'AIN_TEST'
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

  CREATE OBJECT lo_equipment_ain
    EXPORTING
      co_http_client = lo_http_client.

  CREATE OBJECT lo_equipment.

  CALL METHOD lo_equipment->lese_equipment
    EXPORTING
      iv_equnr = iv_equnr.
*     CHANGING
*       cv_ok    = lv_ok.

  CALL METHOD lo_equipment->get_sernr
    CHANGING
      cv_sernr = lv_sernr.

  CALL METHOD lo_equipment_ain->equipment_already_transferred
    EXPORTING
      iv_sernr        = lv_sernr
      iv_rfcdest      = iv_rfcdest
    CHANGING
      cv_transferred  = lv_transferred
      cv_equipment_id = lv_equi_id.

  FREE lo_http_client.

  IF lv_transferred = 'X'.
    LOOP AT ct_doc_ids INTO ls_docid.
      CALL METHOD zaco_cl_connection_ain=>connect_to_ain
        EXPORTING
          iv_rfcdest               = iv_rfcdest   "'AIN_TEST'
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

      CALL METHOD me->get_equipment_version
        EXPORTING
          iv_equnr   = iv_equnr
          iv_rfcdest = iv_rfcdest
        CHANGING
          ct_result  = lt_result
          cv_version = lv_version.

*-----------------------------------------------------------------------
* Set Request URI
*-----------------------------------------------------------------------
      CALL METHOD me->documentid
        EXPORTING
          iv_docid = ls_docid-value
        CHANGING
          ct_json  = lt_json.

      CALL METHOD me->assigneeid
        EXPORTING
          iv_assigneeid = lv_equi_id
        CHANGING
          ct_json       = lt_json.

      CALL METHOD me->version
        EXPORTING
          iv_version = lv_version
        CHANGING
          ct_json    = lt_json.

*-----------------------------------------------------------------------------------------------*

*           Bilden JSON Body und Request

*-----------------------------------------------------------------------------------------------*
      CALL METHOD zaco_cl_connection_ain=>construct_body
        EXPORTING
          it_body = lt_json
        CHANGING
          cv_body = lv_body.

      CONCATENATE zaco_cl_connection_ain=>gv_service '/documents/assign/equipment' INTO lv_service.
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

*  if lv_status_code ne 200.
*-----------------------------------------------------------------------
* Refresh HTTP Request
*-----------------------------------------------------------------------
*  go_http_client->refresh_request( ).

      lv_json = lo_http_client->response->get_cdata( ).
      CALL METHOD zaco_cl_json=>json_to_data
        EXPORTING
          iv_json = lv_json
        CHANGING
          ct_data = ct_result.

      FREE lo_http_client.
      REFRESH lt_json.
      CLEAR lv_json.
    ENDLOOP. " Dokumente
  ELSE.
*----- Fehlermeldung Equipment noch nciht transferiert

  ENDIF.

ENDMETHOD.


method DESCRIPTION.

  data: ls_json type zpsain_s_json_body.

  ls_json-name = 'description'.
  ls_json-value = iv_description.
  append ls_json to ct_json.

endmethod.


method DOCUMENTID.
  data: ls_json type zpsain_s_json_body.
*---------- Leer
  ls_json-name = 'documentID'.
  ls_json-value = iv_docid.
  ls_json-parent = 'documentIDMapping'.
  ls_json-MULTIPLE = 'X'.
  append ls_json to ct_json.


endmethod.


METHOD ermittle_document_id.

  DATA: lo_http_client  TYPE REF TO if_http_client.
  DATA: lo_entity       TYPE REF TO if_http_entity.

  DATA: lt_result       TYPE zpsain_t_json_body.

  DATA: ls_result       TYPE zpsain_s_json_body.

  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_service      TYPE string.
  DATA: lv_tabix        TYPE sy-tabix.
  DATA: lv_filter       TYPE string.
  DATA: lv_langu        TYPE string.
  data: lv_equnr        type equnr.


  CHECK NOT iv_filename IS INITIAL.
*------------------------ Ermittlung der Document ID
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

  lv_filter = |/documents?$filter=name eq '|.
*  lv_langu = iv_langu.
*  TRANSLATE lv_langu TO LOWER CASE.
*
  CONCATENATE zaco_cl_connection_ain=>gv_service lv_filter iv_filename '''' INTO lv_service.

*  CONCATENATE zaco_cl_connection_ain=>gv_service '/documents$filter=(substringof(''' iv_filename ''',description) eq true)' INTO lv_service.
  cl_http_utility=>set_request_uri( request = lo_http_client->request
                                     uri  = lv_service ).

  lo_http_client->request->set_method( 'GET' ).
  lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).
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

  lv_json = lo_http_client->response->get_cdata( ).
  CALL METHOD zaco_cl_json=>json_to_data
    EXPORTING
      iv_json = lv_json
    CHANGING
      ct_data = lt_result.

  READ TABLE lt_result INTO ls_result WITH KEY name = 'documentId'.
  IF sy-subrc = 0.
    cv_docid = ls_result-value.
  ENDIF.

  lo_http_client->close( ).
  CLEAR lv_json.

ENDMETHOD.


METHOD GET_EQUIPMENT_VERSION.


  DATA: lo_http_client   TYPE REF TO if_http_client.
  DATA: lo_entity        TYPE REF TO if_http_entity.
  DATA: lo_equipment_ain TYPE REF TO zaco_cl_equipment_ain.
  DATA: lo_equipment     TYPE REF TO zaco_cl_equip_erp.

  DATA: lt_json        TYPE zaco_t_json_body.
  DATA: lt_result      TYPE zaco_t_json_body.

  DATA: ls_result      TYPE zaco_s_json_body.

  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_service      TYPE string.
  DATA: lv_sernr        TYPE gernr.
  DATA: lv_transferred  TYPE char1.
  DATA: lv_equi_id      TYPE string.
  data: lv_equnr        type equnr.

  lv_equnr = iv_equnr.

*--------
  CALL METHOD zaco_cl_connection_ain=>connect_to_ain
    EXPORTING
      iv_rfcdest               = iv_rfcdest
    CHANGING
      co_http_client           = lo_http_client
      EXCEPTIONS
        DEST_NOT_FOUND           = 1
        DESTINATION_NO_AUTHORITY = 2
        others                   = 3
          .
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

  CREATE OBJECT lo_equipment_ain
    EXPORTING
      co_http_client = lo_http_client.

  CREATE OBJECT lo_equipment.

  CALL METHOD lo_equipment->lese_equipment
    EXPORTING
      iv_equnr = iv_equnr.
*     CHANGING
*       cv_ok    = lv_ok.

  CALL METHOD lo_equipment->get_sernr
    CHANGING
      cv_sernr = lv_sernr.

  CALL METHOD lo_equipment_ain->equipment_already_transferred
    EXPORTING
      iv_sernr        = lv_sernr
      iv_rfcdest      = iv_rfcdest
    CHANGING
      cv_transferred  = lv_transferred
      cv_equipment_id = lv_equi_id.

  IF lv_transferred = 'X'.
    CONCATENATE zaco_cl_connection_ain=>gv_service '/equipment(' lv_equi_id ')/header' INTO lv_service.
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

*  if lv_status_code ne 200.
*-----------------------------------------------------------------------
* Refresh HTTP Request
*-----------------------------------------------------------------------
*  go_http_client->refresh_request( ).

    lv_json = lo_http_client->response->get_cdata( ).
    CALL METHOD zaco_cl_json=>json_to_data
      EXPORTING
        iv_json = lv_json
      CHANGING
        ct_data = ct_result.

    READ TABLE ct_result INTO ls_result WITH KEY name = 'equipmentVersion'.
    IF sy-subrc = 0.
      cv_version = ls_result-value.
    ENDIF.
    FREE lo_http_client.
    REFRESH lt_json.
    CLEAR lv_json.
  ELSE.
*----- Fehlermeldung Equipment noch nciht transferiert

  ENDIF.

ENDMETHOD.


method GET_PHIO_DOCUMENT.

  DATA: LT_DOKNR TYPE zaco_t_doknr.
  data: lt_dokvr type zaco_t_dokver.

  data: ls_phio type zaco_s_phio.

  data: lv_index type sy-tabix.

  CALL METHOD me->READ_DRAD
    EXPORTING
      IV_EQUNR = iv_equnr
    CHANGING
      CT_DOKNR = lt_doknr.

  CALL METHOD me->READ_DRAW
    EXPORTING
      IT_DOKNR = lt_doknr
    CHANGING
      CT_DOKVR = lt_dokvr.

  CALL METHOD me->READ_LOIO
    EXPORTING
      IT_DOKVR = lt_dokvr
    CHANGING
      CT_PHIO  = ct_phio.

  loop at ct_phio into ls_phio.
    lv_index = sy-tabix.
    select single * from DMS_PH_CD1 into CORRESPONDING FIELDS OF ls_phio where LOIO_ID = ls_phio-lo_objid.
    if sy-subrc = 0.
      ls_phio-equnr = iv_equnr.
      modify ct_phio from ls_phio index lv_index.
    endif.
  endloop.

endmethod.


method LANGUAGE_CODE.

  data: ls_json type zpsain_s_json_body.

  ls_json-name = 'languageCode'.
  select single laiso from t002 into ls_json-value where spras = iv_spras.
  translate ls_json-value to lower case.
  cv_langu = ls_json-value.
  append ls_json to ct_json.

endmethod.


method PHASE_CODE.

  data: ls_json type zpsain_s_json_body.

  ls_json-name = 'phaseCode'.
  ls_json-value = '4'.
  append ls_json to ct_json.

endmethod.


METHOD READ_DRAD.

  SELECT * FROM drad APPENDING CORRESPONDING FIELDS OF TABLE ct_doknr
                                              WHERE dokob = 'EQUI'
                                               AND  objky = iv_equnr.

  SORT ct_doknr.

ENDMETHOD.


METHOD READ_DRAW.

  DATA: lt_dokvr TYPE zpsain_t_dokver.

  DATA: ls_doknr TYPE zpsain_s_doknr.
  DATA: ls_dokvr TYPE zpsain_s_dokver.

  DATA: lv_lines TYPE sy-tfill.

  LOOP AT it_doknr INTO ls_doknr.
    SELECT * FROM draw INTO CORRESPONDING FIELDS OF TABLE lt_dokvr WHERE doknr = ls_doknr-doknr
                                                                    AND  dokst = 'FR'.


    DESCRIBE TABLE lt_dokvr LINES lv_lines.
    SORT lt_dokvr ASCENDING BY dokvr.
    READ TABLE lt_dokvr INTO ls_dokvr INDEX lv_lines.
    IF sy-subrc = 0.
      ls_dokvr-atwrt = ls_doknr-atwrt.
      ls_dokvr-is_unique = ls_doknr-is_unique.
      APPEND ls_dokvr TO ct_dokvr.
    ENDIF.
    REFRESH lt_dokvr.
  ENDLOOP.


ENDMETHOD.


METHOD READ_LOIO.

  DATA: ls_dokvr TYPE zpsain_s_dokver.
  DATA: ls_phio TYPE zpsain_s_phio.
  DATA: lv_tabix TYPE sy-tabix.

  LOOP AT it_dokvr INTO ls_dokvr.

    SELECT * FROM dms_doc2loio APPENDING CORRESPONDING FIELDS OF TABLE ct_phio
                                                        WHERE doknr = ls_dokvr-doknr
                                                         and  dokvr = ls_dokvr-dokvr.

  ENDLOOP.
  LOOP AT it_dokvr INTO ls_dokvr.
    LOOP AT ct_phio INTO ls_phio WHERE doknr = ls_dokvr-doknr.
      lv_tabix = sy-tabix.
      ls_phio-atwrt = ls_dokvr-atwrt.
      ls_phio-is_unique = ls_dokvr-is_unique.
      MODIFY ct_phio FROM ls_phio INDEX lv_tabix.
    ENDLOOP.
  ENDLOOP.
ENDMETHOD.


method SHORTDESCRIPTION.

  data: ls_json type zpsain_s_json_body.

  ls_json-name = 'shortDescription'.
  ls_json-value = iv_description.
  append ls_json to ct_json.

endmethod.


METHOD UPLOAD_DOCUMENT.

  FIELD-SYMBOLS:  <fs_content>  TYPE sdokcntbin.   "drao.

  DATA: lo_http_client  TYPE REF TO if_http_client.
  DATA: lo_entity       TYPE REF TO if_http_entity.

  DATA: lt_access_info TYPE STANDARD TABLE OF scms_acinf.
  DATA: lt_context_txt TYPE STANDARD TABLE OF sdokcntasc.
  DATA: lt_content_bin TYPE STANDARD TABLE OF sdokcntbin.
  DATA: lt_phio        TYPE zaco_t_phio.
  DATA: lt_json        TYPE zaco_t_json_body.
  DATA: lt_result      TYPE zaco_t_json_body.
  DATA: lt_raw_to_str  TYPE zaco_t_raw.
  DATA: lt_content     TYPE STANDARD TABLE OF  drao.

  DATA: ls_phio         TYPE zaco_s_phio.
  DATA: ls_content_bin  TYPE sdokcntbin.
  DATA: ls_access_info  TYPE scms_acinf.
  DATA: ls_docid        TYPE zaco_s_json_body.

  DATA: lv_file_data    TYPE xstring.
  DATA: lv_file         TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_service      TYPE string.
  DATA: lv_length       TYPE i.
  DATA: lv_name_str     TYPE string.
  DATA: lv_data         TYPE string.
  DATA: lv_mimetpye_str TYPE string.
  DATA: lv_doc_id       TYPE string.
  DATA: lv_langu        TYPE char2.
  data: lv_equnr        type equnr.

  lv_equnr = iv_equnr.

  CALL METHOD me->get_phio_document
    EXPORTING
      iv_equnr     = iv_equnr
      io_equipment = io_equipment
    CHANGING
      ct_phio      = lt_phio.

  LOOP AT lt_phio INTO ls_phio.

    CALL FUNCTION 'SCMS_DOC_READ'
      EXPORTING
        stor_cat              = 'ZPSBWA'
        doc_id                = space
        phio_id               = ls_phio-phio_id
*       SIGNATURE             = 'X'
*       SECURITY              = ' '
*       NO_CACHE              = ' '
*       RAW_MODE              = ' '
*     IMPORTING
*       FROM_CACHE            =
*       CREA_TIME             =
*       CREA_DATE             =
*       CHNG_TIME             =
*       CHNG_DATE             =
*       STATUS                =
*       DOC_PROT              =
      TABLES
        access_info           = lt_access_info
        content_txt           = lt_context_txt
        content_bin           = lt_content_bin
      EXCEPTIONS
        bad_storage_type      = 1
        bad_request           = 2
        unauthorized          = 3
        comp_not_found        = 4
        not_found             = 5
        forbidden             = 6
        conflict              = 7
        internal_server_error = 8
        error_http            = 9
        error_signature       = 10
        error_config          = 11
        error_format          = 12
        error_parameter       = 13
        error                 = 14
        OTHERS                = 15.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    LOOP AT lt_content_bin INTO ls_content_bin.
      APPEND ls_content_bin-line TO lt_raw_to_str.
    ENDLOOP.

    DESCRIBE TABLE lt_raw_to_str.
    lv_length = sy-tfill * sy-tleng.

    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = lv_length
*       FIRST_LINE   = 0
*       LAST_LINE    = 0
      IMPORTING
        buffer       = lv_file_data
      TABLES
        binary_tab   = lt_raw_to_str
*     EXCEPTIONS
*       FAILED       = 1
*       OTHERS       = 2
      .
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    READ TABLE lt_access_info INTO ls_access_info INDEX 1.
    IF sy-subrc = 0.
      lv_file = ls_access_info-comp_id.
    ELSE.
      EXIT.
    ENDIF.
    CLEAR lv_doc_id.
    CALL METHOD me->ermittle_document_id
      EXPORTING
        iv_filename = lv_file
        iv_rfcdest  = iv_rfcdest
*       iv_langu    = 'de'
      CHANGING
        cv_docid    = lv_doc_id.
    IF lv_doc_id IS INITIAL.

*--------
      CALL METHOD zaco_cl_connection_ain=>connect_to_ain
        EXPORTING
          iv_rfcdest     = iv_rfcdest
        CHANGING
          co_http_client = lo_http_client
*      EXCEPTIONS
*         DEST_NOT_FOUND = 1
*         DESTINATION_NO_AUTHORITY = 2
*         others         = 3
        .
      IF sy-subrc <> 0.
*     Implement suitable error handling here
      ENDIF.
*-----------------------------------------------------------------------
* Set Request URI
*-----------------------------------------------------------------------


      CALL METHOD me->category_code
        CHANGING
          ct_json = lt_json.

      CALL METHOD me->description
        EXPORTING
          iv_description = 'Betriebs und Wartungsanleitung'
        CHANGING
          ct_json        = lt_json.

      CALL METHOD me->language_code
        EXPORTING
          iv_spras = ls_phio-langu
        CHANGING
          cv_langu = lv_langu
          ct_json  = lt_json.

      CALL METHOD me->phase_code
        CHANGING
          ct_json = lt_json.

*-----------------------------------------------------------------------------------------------*

*           Bilden JSON Body und Request

*-----------------------------------------------------------------------------------------------*
      CALL METHOD zaco_cl_connection_ain=>construct_body
        EXPORTING
          it_body = lt_json
        CHANGING
          cv_body = lv_body.

      CONCATENATE zaco_cl_connection_ain=>gv_service '/document/upload' INTO lv_service.
      cl_http_utility=>set_request_uri( request = lo_http_client->request
                                           uri  = lv_service ).

      lo_http_client->request->set_method( 'POST' ).
      lo_http_client->request->set_header_field( name = 'Content-Type' value = 'multipart/form-data' ).

      lo_entity =  lo_http_client->request->if_http_entity~add_multipart( ).
*   --MultipartBoundry
      lv_name_str = 'form-data; name="file-data"'.

      CALL METHOD lo_entity->set_header_field
        EXPORTING
          name  = 'content-disposition'
          value = lv_name_str.

      lo_entity->suppress_content_type( ).

      CONCATENATE '{ "phaseCode": "3", "categoryCode": "6",   "languageCode": "' lv_langu '", "description": "Betriebs und Wartungsanleitung", "shortDescription": "Betriebs und Wartungsanleitung"  }'
            INTO lv_data.

      lo_entity->set_cdata( data   = lv_data  ).

      lo_entity =  lo_http_client->request->if_http_entity~add_multipart( ).

      CONCATENATE 'form-data; name="file"; filename="' lv_file '";' INTO lv_name_str.

      CALL METHOD lo_entity->set_header_field
        EXPORTING
          name  = 'content-disposition'
          value = lv_name_str.

      lv_mimetpye_str = 'application/pdf'.

      CALL METHOD lo_entity->set_content_type
        EXPORTING
          content_type = lv_mimetpye_str.

      lv_length = xstrlen( lv_file_data ).

      lo_entity->set_data(
        EXPORTING
         data               = lv_file_data
         length             = lv_length ).

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

      lv_json = lo_http_client->response->get_cdata( ).
      CALL METHOD zpsain_cl_json=>json_to_data
        EXPORTING
          iv_json = lv_json
        CHANGING
          ct_data = ct_result.

      FREE lo_http_client.
      REFRESH lt_access_info.
      REFRESH lt_context_txt.
      REFRESH lt_content_bin.
      CLEAR lv_json.

      CALL METHOD me->ermittle_document_id
        EXPORTING
          iv_filename = lv_file
          iv_rfcdest  = iv_rfcdest
*         iv_langu    = lv_langu
        CHANGING
          cv_docid    = ls_docid-value.
      ls_docid-name = 'docid'.
      APPEND ls_docid TO ct_doc_ids.
    ELSE. "doc_id is initial
      ls_docid-name = 'docid'.
      ls_docid-value = lv_doc_id.
      APPEND ls_docid TO ct_doc_ids.
    ENDIF.
  ENDLOOP.


ENDMETHOD.


method VERSION.

    data: ls_json type zpsain_s_json_body.
*---------- Leer
  ls_json-name = 'version'.
*  ls_json-value = '0.0'.    "iv_version.
  ls_json-value = iv_version.
  ls_json-parent = 'documentIDMapping'.
  append ls_json to ct_json.

endmethod.
ENDCLASS.
