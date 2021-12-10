class ZACO_CL_SPAREPARTS definition
  public
  create public .

public section.

  methods CONSTRUCTOR .
  methods SPAREPARTS_ALREADY_TRANSFERRED
    importing
      !IV_MATNR type MATNR
      !IV_RFCDEST type RFCDEST
    changing
      !CV_TRANSFERRED type CHAR1
      !CV_AIN_PART type STRING .
  methods MANUFACTURERPARTNUMBER
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods CREATE_SPAREPART
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_RFCDEST type RFCDEST
      !IV_BP_NAME type ZACO_DE_BP_AIN
    changing
      !CT_RESULT type ZACO_T_JSON_BODY .
  methods MANUFACTURER
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_RFCDEST type RFCDEST
      !IV_BP_NAME type ZACO_DE_BP_AIN
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods DELETE_SPAREPART
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_ID type STRING
      !IV_RFCDEST type RFCDEST
    changing
      !CT_RESULT type ZACO_T_JSON_BODY .
  methods EANNUMBER
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods UPDATE_SPAREPART
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_ID type STRING
      !IV_RFCDEST type RFCDEST optional
      !IV_BP_NAME type ZACO_DE_BP_AIN
    changing
      !CT_RESULT type ZACO_T_JSON_BODY .
  methods UOM
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_RFCDEST type RFCDEST optional
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods NETWEIGHT
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods GROSSWEIGHT
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods WEIGHTUNIT
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_RFCDEST type RFCDEST
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods LONGDESCRIPTION
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods SPAREPARTNAME
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods SPAREPARTDESCRIPTION
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods SUBCLASS
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods DIMENSION
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_RFCDEST type RFCDEST
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods LEADTIMEDURATION
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods LEADTIMEDURATIONUNIT
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods SPAREPARTS
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods ID
    importing
      !IV_ID type STRING
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods INTERNALID
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods BESTANDSMENGE
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods LAENGE
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods BREIT
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods HOEHE
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods UOM_LENGTH_WIDTH_HEIGHT
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_RFCDEST type RFCDEST
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods VOLUMEN
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods UOM_VOLUMEN
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_RFCDEST type RFCDEST
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods GROESSE_ABMESSUNG
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods SPAREPARTDESCRIPTION_LANGU
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
protected section.
private section.

  data GS_MSG type BAL_S_MSG .
  data GT_CUSTOM type ZACO_TT_OBJECTS_CU .
  constants GC_SPAREPART type ZACO_DE_OBJEKTTYPE value 'SPAREPART' ##NO_TEXT.
ENDCLASS.



CLASS ZACO_CL_SPAREPARTS IMPLEMENTATION.


METHOD bestandsmenge.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_eisbe TYPE marc-eisbe.
  DATA: lv_labst TYPE mard-labst.
  DATA: lv_dismm TYPE marc-dismm.


  ls_json-name = 'manufacturerStockLevel'.
  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'BESTANDSMENGE'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~bestandsmenge
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_eisbe
          CHANGING
            cv_eisbe = lv_eisbe.

        CALL METHOD io_material->get_labst
          CHANGING
            cv_labst = lv_labst.

        ls_json-value = lv_labst.
        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.


ENDMETHOD.


METHOD breit.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_breit TYPE breit.



  ls_json-name = 'width'.
  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'BREIT'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~breit
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_breit
          CHANGING
            cv_breit = lv_breit.
        IF lv_breit > 0.
          ls_json-value = lv_breit.
          APPEND ls_json TO ct_json.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.


  METHOD constructor.

    SELECT * FROM ZACO_objects_CU APPENDING TABLE gt_custom.

  ENDMETHOD.


METHOD create_sparepart.

  DATA: lo_http_client  TYPE REF TO if_http_client.

  DATA: lt_json         TYPE zaco_t_json_body.

  DATA: lv_equnr        TYPE equnr.  "log
  DATA: lv_matnr        TYPE matnr.
  DATA: lv_service      TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_json         TYPE string.

  CALL METHOD me->manufacturerpartnumber
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->manufacturer
    EXPORTING
      io_material = io_material
      iv_bp_name  = iv_bp_name
      iv_rfcdest  = iv_rfcdest
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->uom
    EXPORTING
      io_material = io_material
      iv_rfcdest  = iv_rfcdest
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->dimension
    EXPORTING
      io_material = io_material
      iv_rfcdest  = iv_rfcdest
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->sparepartdescription_langu
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->internalid
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->grossweight
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->netweight
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->weightunit
    EXPORTING
      io_material = io_material
      iv_rfcdest  = iv_rfcdest
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->leadtimeduration
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->leadtimedurationunit
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->bestandsmenge
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->breit
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->hoehe
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->laenge
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->uom_length_width_height
    EXPORTING
      io_material = io_material
      iv_rfcdest  = iv_rfcdest
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->groesse_abmessung
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->volumen
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->uom_volumen
    EXPORTING
      io_material = io_material
      iv_rfcdest  = iv_rfcdest
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->eannumber
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.


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
  CONCATENATE zaco_cl_connection_ain=>gv_service '/parts' INTO lv_service.
  cl_http_utility=>set_request_uri( request = lo_http_client->request
                                       uri  = lv_service ).

  lo_http_client->request->set_method( 'POST' ).
  lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).


  CALL METHOD zaco_cl_connection_ain=>construct_body_mat_langu
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

  lv_json = lo_http_client->response->get_cdata( ).
  IF lv_status_code NE 200.
*-----------------------------------------------------------------------
* Refresh HTTP Request
*-----------------------------------------------------------------------
    lo_http_client->refresh_request( ).

    CALL METHOD zaco_cl_json=>json_to_data
      EXPORTING
        iv_json = lv_json
      CHANGING
        ct_data = ct_result.
    CALL METHOD io_material->get_matnr
      CHANGING
        cv_matnr = lv_matnr.

    gs_msg-msgid = 'ZACO'.
    gs_msg-msgty = 'E'.
    gs_msg-msgno = '402'.
    gs_msg-msgv1 = lv_matnr.
    lv_json  = lv_json.
    CALL METHOD zaco_cl_error_log=>write_error
      EXPORTING
        iv_msgty     = gs_msg-msgty
        iv_json      = lv_json
        iv_equnr     = lv_equnr
        iv_msgno     = gs_msg-msgno
        iv_msgid     = gs_msg-msgid
        iv_msgv1     = gs_msg-msgv1
        iv_err_group = 'MAT'.
  ELSE.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgty = 'S'.
    gs_msg-msgno = '407'.
    gs_msg-msgv1 = lv_matnr.
    lv_json  = lv_json.
    CALL METHOD zaco_cl_error_log=>write_error
      EXPORTING
        iv_msgty     = gs_msg-msgty
        iv_json      = lv_json
        iv_equnr     = lv_equnr
        iv_msgno     = gs_msg-msgno
        iv_msgid     = gs_msg-msgid
        iv_msgv1     = gs_msg-msgv1
        iv_err_group = 'MAT'.
    REFRESH ct_result.
  ENDIF.
  CALL METHOD lo_http_client->close( ).

ENDMETHOD.


METHOD delete_sparepart.

  DATA: lo_http_client  TYPE REF TO if_http_client.

  DATA: lt_json         TYPE zaco_t_json_body.

  DATA: lv_equnr        TYPE equnr.
  DATA: lv_matnr        TYPE matnr.
  DATA: lv_service      TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_ok           TYPE char1.
  DATA: lv_id           TYPE string.

  DATA: lv_body_begin     TYPE string.
  DATA: lv_body_end       TYPE string.
  DATA: lv_name_end       TYPE string.
  DATA: lv_name_begin     TYPE string.
  DATA: lv_multiple_begin TYPE string.
  DATA: lv_multiple_last  TYPE string.
  DATA: lv_line_end       TYPE string.

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
  CONCATENATE zaco_cl_connection_ain=>gv_service '/parts/remove' INTO lv_service.
  cl_http_utility=>set_request_uri( request = lo_http_client->request
                                       uri  = lv_service ).

  lo_http_client->request->set_method( 'PUT' ).
  lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).


  CALL METHOD me->spareparts
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->id
    EXPORTING
      iv_id   = iv_id
    CHANGING
      ct_json = lt_json.

  lv_body_begin = |\{|.
  lv_body_end = |\}|.
  lv_name_end = |:|.
  lv_name_begin = |"|.
  lv_multiple_begin = |[|.
  lv_multiple_last = |]|.
  lv_line_end = |\}|.

  CONCATENATE lv_body_begin lv_name_begin 'spareparts' lv_name_begin lv_name_end lv_multiple_begin lv_body_begin INTO lv_body.
  CONCATENATE lv_body lv_name_begin 'id' lv_name_begin lv_name_end lv_name_begin iv_id lv_name_begin lv_line_end lv_multiple_last lv_line_end INTO lv_body.

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
  IF lv_status_code NE 200.
*-----------------------------------------------------------------------
* Refresh HTTP Request
*-----------------------------------------------------------------------
    lo_http_client->refresh_request( ).

    lv_json = lo_http_client->response->get_cdata( ).
    CALL METHOD zaco_cl_json=>json_to_data
      EXPORTING
        iv_json = lv_json
      CHANGING
        ct_data = ct_result.
  ELSE.
    CALL METHOD io_material->get_matnr
      CHANGING
        cv_matnr = lv_matnr.

    gs_msg-msgid = 'ZACO'.
    gs_msg-msgty = 'I'.
    gs_msg-msgno = '403'.
    gs_msg-msgv1 = lv_matnr.
    lv_json  = lv_json.
    CALL METHOD zaco_cl_error_log=>write_error
      EXPORTING
        iv_msgty     = gs_msg-msgty
        iv_json      = lv_json
        iv_equnr     = lv_equnr
        iv_msgno     = gs_msg-msgno
        iv_msgid     = gs_msg-msgid
        iv_msgv1     = gs_msg-msgv1
        iv_err_group = 'MAT'.
    REFRESH ct_result.
  ENDIF.


ENDMETHOD.


METHOD dimension.


  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_meins TYPE mara-meins.
  DATA: lv_uom_erp TYPE zaco_de_einheit.
  DATA: lv_uom_ain TYPE zaco_de_einheit.
  DATA: lv_dimension TYPE zaco_de_dimension.


  ls_json-name = 'dimension'.
  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'DIMENSION'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~dimension
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_meins
          CHANGING
            cv_meins = lv_meins.
        lv_uom_erp = lv_meins.
        CALL METHOD zaco_cl_templates=>translate_uom_to_ain
          EXPORTING
            iv_uom_erp   = lv_uom_erp
            iv_rfcdest   = iv_rfcdest
          CHANGING
*           cv_loghndl   =
            cv_uom_ain   = lv_uom_ain
            cv_dimension = lv_dimension.
        ls_json-value = lv_dimension.
        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD eannumber.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.
  DATA: ls_marm TYPE marm.

  DATA: lv_ean TYPE ean11.
  DATA: lv_meins TYPE meins.



  ls_json-name = 'eannumber'.
  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'EANNUMBER'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~eannumber
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_meins
          CHANGING
            cv_meins = lv_meins.

        CALL METHOD io_material->get_marm_for_unit
          EXPORTING
            iv_meinh  = lv_meins
          CHANGING
            cs_marm   = ls_marm
          EXCEPTIONS
            not_found = 1
            OTHERS    = 2.
        IF sy-subrc = 0.
          ls_json-value = ls_marm-ean11.
          APPEND ls_json TO ct_json.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD groesse_abmessung.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_groes TYPE groes.


  ls_json-name = 'sizeDimensions'.
  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'GROESSE_ABMESSUNG'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~groesse_abmessung
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_groes
          CHANGING
            cv_groes = lv_groes.
        ls_json-value = lv_groes.
        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD grossweight.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_brgew TYPE brgew.


  ls_json-name = 'grossWeight'.
  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'GROSSWEIGHT'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~grossweight
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_brgew
          CHANGING
            CV_BrGEW = lv_brgew.
        IF lv_brgew > 0.
          ls_json-value = lv_brgew.
          APPEND ls_json TO ct_json.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD hoehe.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_hoehe TYPE hoehe.


  ls_json-name = 'height'.
  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'HOEHE'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~hoehe
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_hoehe
          CHANGING
            cv_hoehe = lv_hoehe.
        IF lv_hoehe > 0.
          ls_json-value = lv_hoehe.
          APPEND ls_json TO ct_json.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


method ID.

  data: ls_json type zaco_s_json_body.
  data: lv_meins type mara-meins.

  ls_json-name = 'id'.
*  ls_json-parent = 'spareparts'.
  ls_json-value = iv_id.
  append ls_json to ct_json.


endmethod.


METHOD internalid.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_matnr TYPE matnr.


  ls_json-name = 'sparepartInternalID'.
  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'INTERNALID'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~internalid
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_matnr
          CHANGING
            cv_matnr = lv_matnr.

        CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
          EXPORTING
            input  = lv_matnr
          IMPORTING
            output = lv_matnr.

        ls_json-value = lv_matnr.
        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD laenge.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_laeng TYPE laeng.


  ls_json-name = 'length'.
  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'LAENGE'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~laenge
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_laeng
          CHANGING
            cv_laeng = lv_laeng.
        IF lv_laeng > 0.
          ls_json-value = lv_laeng.
          APPEND ls_json TO ct_json.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD leadtimeduration.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_plifz TYPE marc-plifz.
  DATA: lv_gwbz  TYPE marc-wzeit.
  DATA: lv_beskz TYPE marc-beskz.


  ls_json-name = 'leadTimeDuration'.
  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'LEADTIMEDURATION'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~leadtimeduration
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_beskz
          CHANGING
            cv_beskz = lv_beskz.

        CASE lv_beskz.
          WHEN 'E'.
            CALL METHOD io_material->get_wbz
              RECEIVING
                cv_wzeit = lv_gwbz.
            ls_json-value = lv_gwbz.
          WHEN 'F'.
            CALL METHOD io_material->get_plifz
              CHANGING
                cv_plifz = lv_plifz.
            ls_json-value = lv_plifz.
        ENDCASE.
        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD leadtimedurationunit.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.


  ls_json-name = 'leadTimeDurationUnit'.
  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'LEADTIMEDURATIONUNIT'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~leadtimedurationunit
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        ls_json-name = 'leadTimeDurationUnit'.
        ls_json-value = '3'.                   "Tage
        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD longdescription.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_maktx TYPE maktx.
  DATA: lv_normt TYPE normt.
  DATA: lv_wrkst TYPE wrkst.

  ls_json-name = 'longDescription'.
  ls_json-parent = 'sparepartDescription'.
  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'LONGDESCRIPTION'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~longdescription
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_ktxt
          RECEIVING
            cv_maktx = lv_maktx.
        CALL METHOD io_material->get_normt
          CHANGING
            cv_normt = lv_normt.

        CALL METHOD io_material->get_wrkst
          CHANGING
            cv_wrkst = lv_wrkst.
        CONCATENATE lv_maktx lv_normt lv_wrkst INTO ls_json-value SEPARATED BY space.

        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD manufacturer.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.
  DATA: lo_bp_ain TYPE REF TO zaco_cl_business_partner_ain.

  DATA: lt_result TYPE zaco_t_json_body.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_maktx TYPE maktx.
  DATA: lv_normt TYPE normt.
  DATA: lv_wrkst TYPE wrkst.

  ls_json-name = 'manufacturer'.

  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'MANUFACTURER'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~manufacturer
          EXPORTING
            io_object  = io_material
            iv_rfcdest = iv_rfcdest
          CHANGING
            ct_json    = ct_json.
      ELSE.
        CREATE OBJECT lo_bp_ain.

        ls_json-name = 'manufacturer'.

        CALL METHOD lo_bp_ain->get_bp_id_by_name
          EXPORTING
            iv_bp_name = iv_bp_name              "'NETZSCH_PS'
            iv_rfcdest = iv_rfcdest
          CHANGING
*           cv_loghndl =
            cv_bp_id   = ls_json-value
            ct_result  = lt_result.

        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD manufacturerpartnumber.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_matnr TYPE matnr.

  ls_json-name = 'manufacturerPartNumber'.

  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'MANUFACTURERPARTNUMBER'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~manufacturerpartnumber
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_matnr
          CHANGING
            cv_matnr = lv_matnr.

        CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
          EXPORTING
            input  = lv_matnr
          IMPORTING
            output = lv_matnr.

        ls_json-value = lv_matnr.
        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD netweight.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_ntgew TYPE ntgew.

  ls_json-name = 'netWeight'.

  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'NETWEIGHT'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~netweight
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_netgw
          CHANGING
            cv_ntgew = lv_ntgew.
        IF lv_ntgew > 0.
          ls_json-value = lv_ntgew.
          APPEND ls_json TO ct_json.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD sparepartdescription.
*
*  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.
*
*  DATA: ls_json  TYPE zaco_s_json_body.
*  DATA: ls_cust  TYPE zaco_objects_cu.
*
*  DATA: lv_maktx TYPE maktx.
*  DATA: lv_normt TYPE normt.
*  DATA: lv_wrkst TYPE wrkst.
*
*  ls_json-name = 'sparepartDescription'.
*  ls_json-parent = ls_json-name.
*
*  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
*                                             fieldname  = 'SPAREPARTDESCRIPTION'.
*  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
*    IF ls_cust-useconstant = 'J'.
*      ls_json-value = ls_cust-constant.
*      APPEND ls_json TO ct_json.
*    ELSE.
*      IF ls_cust-use_userexit = 'J'.
*        CREATE OBJECT lo_exit.
*        CALL METHOD lo_exit->zchain_if_sparepart~sparepartdescription
*          EXPORTING
*            io_object = io_material
*          CHANGING
*            ct_json   = ct_json.
*      ELSE.
*        CALL METHOD io_material->get_ktxt
*          RECEIVING
*            cv_maktx = lv_maktx.
*
*        ls_json-value = lv_maktx.
*        APPEND ls_json TO ct_json.
*
*      ENDIF.
*    ENDIF.
*  ENDIF.

ENDMETHOD.


METHOD sparepartdescription_langu.

*  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.
*
*  DATA: lt_maktx TYPE makt_tab.
*
*  DATA: ls_json  TYPE zaco_s_json_body.
*  DATA: ls_cust  TYPE zaco_objects_cu.
*  DATA: ls_maktx TYPE makt.
*
*  DATA: lv_maktx TYPE maktx.
*  DATA: lv_langu TYPE char2.
*
*  ls_json-name = 'sparepartDescription'.
*  ls_json-parent = ls_json-name.
*
*  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
*                                             fieldname  = 'SPAREPARTDESCRIPTION'.
*  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
*    IF ls_cust-useconstant = 'J'.
*      CALL METHOD io_material->get_makt
*        CHANGING
*          ct_makt = lt_maktx.
*
*      READ TABLE lt_maktx INTO ls_maktx WITH KEY spras = ls_cust-constant.
*      IF sy-subrc = 0.
*
*        ls_json-name = 'sparepartDescription'.
*        ls_json-parent = 'sparepartDescriptions'.
*        ls_json-multiple = 'X'.
*        ls_json-multiple_body = 'X'.
*        ls_json-next = 'X'.
*        ls_json-value = ls_maktx-maktx.
*        APPEND ls_json TO ct_json.
*
*        CLEAR ls_json.
*
*        CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
*          EXPORTING
*            input  = ls_cust-constant
*          IMPORTING
*            output = lv_langu.
*
*        TRANSLATE lv_langu TO LOWER CASE.
*        ls_json-name = 'longDescription'.
*        ls_json-parent = 'sparepartDescriptions'.
*        ls_json-value = ls_maktx-maktx..
*        ls_json-multiple_body = 'X'.
*        APPEND ls_json TO ct_json.
*
*        CLEAR ls_json.
*
*        ls_json-name = 'languageISoCode'.
*        ls_json-parent = 'sparepartDescriptions'.
*        ls_json-value = ls_cust-constant.
*        ls_json-multiple_body = 'X'.
*        ls_json-last = 'X'.
*        APPEND ls_json TO ct_json.
*
*        CLEAR ls_json.
*
*        APPEND ls_json TO ct_json.
*      ENDIF.
*    ELSE.
*      IF ls_cust-use_userexit = 'J'.
*        CREATE OBJECT lo_exit.
*        CALL METHOD lo_exit->zchain_if_sparepart~sparepartdescription
*          EXPORTING
*            io_object = io_material
*          CHANGING
*            ct_json   = ct_json.
*      ELSE.
*        CALL METHOD io_material->get_makt
*          CHANGING
*            ct_makt = lt_maktx.
*
*        LOOP AT lt_maktx INTO ls_maktx WHERE spras NE '1'.
*
*          ls_json-name = 'sparepartDescription'.
*          ls_json-parent = 'sparepartDescriptions'.
*          ls_json-multiple = 'X'.
*          ls_json-multiple_body = 'X'.
*          ls_json-next = 'X'.
*          ls_json-value = ls_maktx-maktx.
*          APPEND ls_json TO ct_json.
*
*          CLEAR ls_json.
*
*          CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
*            EXPORTING
*              input  = ls_maktx-spras
*            IMPORTING
*              output = lv_langu.
*
*          TRANSLATE lv_langu TO LOWER CASE.
*          ls_json-name = 'longDescription'.
*          ls_json-parent = 'sparepartDescriptions'.
*          ls_json-value = ls_maktx-maktx..
*          ls_json-multiple_body = 'X'.
*          APPEND ls_json TO ct_json.
*
*          CLEAR ls_json.
*
*          ls_json-name = 'languageISoCode'.
*          ls_json-parent = 'sparepartDescriptions'.
*          ls_json-value = lv_langu.
*          ls_json-multiple_body = 'X'.
*          ls_json-last = 'X'.
*          APPEND ls_json TO ct_json.
*
*          CLEAR ls_json.
*
*        ENDLOOP.
*      ENDIF.
*    ENDIF.
*  ENDIF.

ENDMETHOD.


METHOD sparepartname.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_maktx TYPE maktx.
  DATA: lv_normt TYPE normt.
  DATA: lv_wrkst TYPE wrkst.

  ls_json-name = 'sparepartName'.
  ls_json-parent = 'sparepartDescription'.

  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'SPAREPARTNAME'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~sparepartname
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_ktxt
          RECEIVING
            cv_maktx = lv_maktx.
        CALL METHOD io_material->get_normt
          CHANGING
            cv_normt = lv_normt.

        CALL METHOD io_material->get_wrkst
          CHANGING
            cv_wrkst = lv_wrkst.
        CONCATENATE lv_maktx lv_normt lv_wrkst INTO ls_json-value SEPARATED BY space.

        APPEND ls_json TO ct_json.

      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.


method SPAREPARTS.

  data: ls_json type zaco_s_json_body.
  data: lv_meins type mara-meins.

  ls_json-name = 'spareparts'.
  ls_json-multiple = 'X'.
  append ls_json to ct_json.


endmethod.


METHOD spareparts_already_transferred.

  DATA: lo_http_client  TYPE REF TO if_http_client.

  DATA: lt_json         TYPE zaco_t_json_body.

  DATA: ls_json         TYPE zaco_s_json_body.

  DATA: lv_equnr        TYPE equnr. "log
  DATA: lv_service      TYPE string.
  DATA: lv_filter       TYPE string.

  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_json         TYPE string.
  DATA: lv_result       TYPE string.
  DATA: lv_length       TYPE i.

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


  lv_filter = |/parts?$filter=manufacturerPartNumber eq '|.

  CONCATENATE zaco_cl_connection_ain=>gv_service lv_filter iv_matnr '''' INTO lv_service.

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

  lv_json = lo_http_client->response->get_cdata( ).
  IF lv_status_code EQ '200'.
    lv_length = strlen( lv_json ).
    IF lv_length > 2.
      cv_transferred = 'X'.
      REFRESH lt_json.
      CALL METHOD zaco_cl_json=>json_to_data
        EXPORTING
          iv_json = lv_json
        CHANGING
          ct_data = lt_json.
      READ TABLE lt_json INTO ls_json WITH KEY name = 'id'.
      IF sy-subrc = 0.
        cv_ain_part = ls_json-value.
      ENDIF.
    ELSE.
      cv_transferred = space.
    ENDIF.
  ELSE.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgty = 'E'.
    gs_msg-msgno = '404'.
    lv_json  = lv_json.
    CALL METHOD zaco_cl_error_log=>write_error
      EXPORTING
        iv_msgty     = gs_msg-msgty
        iv_json      = lv_json
        iv_equnr     = lv_equnr
        iv_msgno     = gs_msg-msgno
        iv_msgid     = gs_msg-msgid
        iv_msgv1     = gs_msg-msgv1
        iv_err_group = 'MAT'.
    cv_transferred = space.
  ENDIF.
  CALL METHOD lo_http_client->close( ).
ENDMETHOD.


METHOD subclass.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_maktx TYPE maktx.
  DATA: lv_normt TYPE normt.
  DATA: lv_wrkst TYPE wrkst.

  ls_json-name = 'subClass'.

  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'SUBCLASS'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~subclass
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
*        ls_json-value = 'C72A865B6302447FA109D97AAFDA05DE'.   "'A43F6328772B43D183345AF1FB7A0B96'.
*        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD uom.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_meins TYPE mara-meins.
  DATA: lv_uom_erp TYPE zaco_de_einheit.
  DATA: lv_uom_ain TYPE zaco_de_einheit.
  DATA: lv_dimension TYPE zaco_de_dimension.

  ls_json-name = 'uom'.

  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'UOM'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~uom
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_meins
          CHANGING
            cv_meins = lv_meins.
        CASE lv_meins.
          WHEN 'ST'.
            lv_meins = 'PC'.
        ENDCASE.
        lv_uom_erp = lv_meins.
        CALL METHOD zaco_cl_templates=>translate_uom_to_ain
          EXPORTING
            iv_uom_erp   = lv_uom_erp
            iv_rfcdest   = iv_rfcdest
          CHANGING
*           cv_loghndl   =
            cv_uom_ain   = lv_uom_ain
            cv_dimension = lv_dimension.
        ls_json-value = lv_uom_ain.
        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.


ENDMETHOD.


METHOD uom_length_width_height.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_meabm TYPE marm-meabm.
  DATA: lv_uom_erp TYPE zaco_de_einheit.
  DATA: lv_uom_ain TYPE zaco_de_einheit.
  DATA: lv_dimension TYPE zaco_de_dimension.

  ls_json-name = 'unitOfLengthWidthHeight'.

  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'UOM_LENGTH_WIDTH_HEIGHT'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~uom_length_width_height
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_meabm
          CHANGING
            cv_meabm = lv_meabm.

        CHECK lv_meabm NE space.

        lv_uom_erp = lv_meabm.
        CALL METHOD zaco_cl_templates=>translate_uom_to_ain
          EXPORTING
            iv_rfcdest   = iv_rfcdest
            iv_uom_erp   = lv_uom_erp
          CHANGING
*           cv_loghndl   =
            cv_uom_ain   = lv_uom_ain
            cv_dimension = lv_dimension.
        ls_json-value = lv_uom_ain.
        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD uom_volumen.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_voleh TYPE voleh.
  DATA: lv_volum TYPE volum.
  DATA: lv_uom_erp TYPE zaco_de_einheit.
  DATA: lv_uom_ain TYPE zaco_de_einheit.
  DATA: lv_dimension TYPE zaco_de_dimension.

  ls_json-name = 'volumeUnit'.

  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'UOM_VOLUMEN'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~uom_volumen
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_volum
          CHANGING
            cv_volum = lv_volum.
        IF lv_volum > 0.
          CALL METHOD io_material->get_voleh
            CHANGING
              cv_voleh = lv_voleh.

          lv_uom_erp = lv_voleh.
          CALL METHOD zaco_cl_templates=>translate_uom_to_ain
            EXPORTING
              iv_uom_erp   = lv_uom_erp
              iv_rfcdest   = iv_rfcdest
            CHANGING
*             cv_loghndl   =
              cv_uom_ain   = lv_uom_ain
              cv_dimension = lv_dimension.
          ls_json-value = lv_uom_ain.
          APPEND ls_json TO ct_json.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

ENDMETHOD.


METHOD update_sparepart.

  DATA: lo_http_client  TYPE REF TO if_http_client.

  DATA: lt_json         TYPE zaco_t_json_body.

  DATA: lv_equnr        TYPE equnr.  "log
  DATA: lv_matnr        TYPE matnr.
  DATA: lv_service      TYPE string.
  DATA: lv_status_code  TYPE i.
  DATA: lv_reason       TYPE string.
  DATA: lv_body         TYPE string.
  DATA: lv_json         TYPE string.

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
  CONCATENATE zaco_cl_connection_ain=>gv_service '/parts' INTO lv_service.
  cl_http_utility=>set_request_uri( request = lo_http_client->request
                                       uri  = lv_service ).

  lo_http_client->request->set_method( 'PUT' ).
  lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).

  CALL METHOD me->manufacturerpartnumber
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->manufacturer
    EXPORTING
      io_material = io_material
      iv_rfcdest  = iv_rfcdest
      iv_bp_name  = iv_bp_name
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->uom
    EXPORTING
      io_material = io_material
      iv_rfcdest  = iv_rfcdest
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->dimension
    EXPORTING
      io_material = io_material
      iv_rfcdest  = iv_rfcdest
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->sparepartdescription_langu
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->internalid
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->grossweight
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->netweight
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->weightunit
    EXPORTING
      io_material = io_material
      iv_rfcdest  = iv_rfcdest
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->leadtimeduration
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->leadtimedurationunit
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->bestandsmenge
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->breit
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->hoehe
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->laenge
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->uom_length_width_height
    EXPORTING
      io_material = io_material
      iv_rfcdest  = iv_rfcdest
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->groesse_abmessung
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->volumen
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->uom_volumen
    EXPORTING
      io_material = io_material
      iv_rfcdest  = iv_rfcdest
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->id
    EXPORTING
      iv_id   = iv_id
    CHANGING
      ct_json = lt_json.

  CALL METHOD me->eannumber
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD zaco_cl_connection_ain=>construct_body_mat_langu
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

  lv_json = lo_http_client->response->get_cdata( ).
  CALL METHOD io_material->get_matnr
    CHANGING
      cv_matnr = lv_matnr.

  IF lv_status_code NE 200.
*-----------------------------------------------------------------------
* Refresh HTTP Request
*-----------------------------------------------------------------------
    lo_http_client->refresh_request( ).

    CALL METHOD zaco_cl_json=>json_to_data
      EXPORTING
        iv_json = lv_json
      CHANGING
        ct_data = ct_result.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgty = 'E'.
    gs_msg-msgno = '405'.
    gs_msg-msgv1 = lv_matnr.
    lv_json  = lv_json.
    CALL METHOD zaco_cl_error_log=>write_error
      EXPORTING
        iv_msgty     = gs_msg-msgty
        iv_json      = lv_json
        iv_equnr     = lv_equnr
        iv_msgno     = gs_msg-msgno
        iv_msgid     = gs_msg-msgid
        iv_msgv1     = gs_msg-msgv1
        iv_err_group = 'MAT'.
  ELSE.
    gs_msg-msgid = 'ZACO'.
    gs_msg-msgty = 'S'.
    gs_msg-msgno = '406'.
    gs_msg-msgv1 = lv_matnr.
    lv_json  = lv_json.
    CALL METHOD zaco_cl_error_log=>write_error
      EXPORTING
        iv_msgty     = gs_msg-msgty
        iv_json      = lv_json
        iv_equnr     = lv_equnr
        iv_msgno     = gs_msg-msgno
        iv_msgid     = gs_msg-msgid
        iv_msgv1     = gs_msg-msgv1
        iv_err_group = 'MAT'.

    REFRESH ct_result.
  ENDIF.
  lo_http_client->close( ).
ENDMETHOD.


METHOD volumen.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_volum TYPE volum.

  ls_json-name = 'volume'.

  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'VOLUMEN'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~volumen
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_volum
          CHANGING
            cv_volum = lv_volum.
        IF lv_volum > 0.
          ls_json-value = lv_volum.
          APPEND ls_json TO ct_json.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.


METHOD weightunit.

  DATA: lo_exit  TYPE REF TO zchain_cl_sparepart_exit.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: ls_cust  TYPE zaco_objects_cu.

  DATA: lv_gewei TYPE mara-gewei.
  DATA: lv_uom_erp TYPE zaco_de_einheit.
  DATA: lv_uom_ain TYPE zaco_de_einheit.
  DATA: lv_dimension TYPE zaco_de_dimension.

  ls_json-name = 'weightUnit'.

  READ TABLE gt_custom INTO ls_cust WITH KEY objekttype = gc_sparepart
                                             fieldname  = 'WEIGHTUNIT'.
  IF ( sy-subrc = 0 AND ls_cust-load_field = 'J' ) OR sy-subrc <> 0.
    IF ls_cust-useconstant = 'J'.
      ls_json-value = ls_cust-constant.
      APPEND ls_json TO ct_json.
    ELSE.
      IF ls_cust-use_userexit = 'J'.
        CREATE OBJECT lo_exit.
        CALL METHOD lo_exit->zchain_if_sparepart~weightunit
          EXPORTING
            io_object = io_material
          CHANGING
            ct_json   = ct_json.
      ELSE.
        CALL METHOD io_material->get_gewei
          CHANGING
            cv_gewei = lv_gewei.

        lv_uom_erp = lv_gewei.
        CALL METHOD zaco_cl_templates=>translate_uom_to_ain
          EXPORTING
            iv_uom_erp   = lv_uom_erp
            iv_rfcdest   = iv_rfcdest
          CHANGING
*           cv_loghndl   =
            cv_uom_ain   = lv_uom_ain
            cv_dimension = lv_dimension.
        ls_json-value = lv_uom_ain.
        APPEND ls_json TO ct_json.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMETHOD.
ENDCLASS.
