class ZACO_CL_SPAREPARTS definition
  public
  create public .

public section.

  methods SPAREPARTS_ALREADY_TRANSFERRED
    importing
      !IV_MATNR type MATNR
      !IV_RFCDEST type RFCDEST
    changing
      !CV_TRANSFERRED type CHAR1
      !CV_AIN_PART type STRING .
  methods CREATE_SPAREPART
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_RFCDEST type RFCDEST
    changing
      !CT_RESULT type ZACO_T_JSON_BODY .
  methods DELETE_SPAREPART
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_ID type STRING
      !IV_RFCDEST type RFCDEST
    changing
      !CT_RESULT type ZACO_T_JSON_BODY .
  methods UPDATE_SPAREPART
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_ID type STRING
      !IV_RFCDEST type RFCDEST optional
    changing
      !CT_RESULT type ZACO_T_JSON_BODY .
protected section.
private section.

  methods MANUFACTURERPARTNUMBER
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods MANUFACTURER
    importing
      !IO_MATERIAL type ref to ZACO_CL_MATERIAL
      !IV_RFCDEST type RFCDEST
    changing
      !CT_JSON type ZACO_T_JSON_BODY .
  methods EANNUMBER
    importing
      !IO_MATERIAL type ref to ZPSPP_UTIL_CL_MATERIAL
    changing
      !CT_JSON type ZPSAIN_T_JSON_BODY .
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
      !IO_MATERIAL type ref to ZPSPP_UTIL_CL_MATERIAL
    changing
      !CT_JSON type ZPSAIN_T_JSON_BODY .
  methods SPAREPARTNAME
    importing
      !IO_MATERIAL type ref to ZPSPP_UTIL_CL_MATERIAL
    changing
      !CT_JSON type ZPSAIN_T_JSON_BODY .
  methods SPAREPARTDESCRIPTION
    importing
      !IO_MATERIAL type ref to ZPSPP_UTIL_CL_MATERIAL
    changing
      !CT_JSON type ZPSAIN_T_JSON_BODY .
  methods SUBCLASS
    importing
      !IO_MATERIAL type ref to ZPSPP_UTIL_CL_MATERIAL
    changing
      !CT_JSON type ZPSAIN_T_JSON_BODY .
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
      !CT_JSON type ZPSAIN_T_JSON_BODY .
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
ENDCLASS.



CLASS ZACO_CL_SPAREPARTS IMPLEMENTATION.


METHOD bestandsmenge.

  DATA: ls_json  TYPE zaco_s_json_body.
  DATA: lv_eisbe TYPE marc-eisbe.
  DATA: lv_labst TYPE mard-labst.
  DATA: lv_dismm TYPE marc-dismm.
*---- Idee hier den Sicherheitsbestand zu veröfentlichen !

  CALL METHOD io_material->get_eisbe
    CHANGING
      cv_eisbe = lv_eisbe.

  CALL METHOD io_material->get_labst
    CHANGING
      cv_labst = lv_labst.

  ls_json-name = 'manufacturerStockLevel'.
  ls_json-value = lv_labst.
  APPEND ls_json TO ct_json.

ENDMETHOD.


METHOD BREIT.

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: lv_breit TYPE breit.

  ls_json-name = 'width'.
  CALL METHOD io_material->get_breit
    CHANGING
      cv_breit = lv_breit.
  IF lv_breit > 0.
    ls_json-value = lv_breit.
    APPEND ls_json TO ct_json.
  ENDIF.
ENDMETHOD.


METHOD CREATE_SPAREPART.

  DATA: lo_http_client TYPE REF TO if_http_client.

  DATA: lt_json TYPE zaco_t_json_body.

  DATA: lv_service TYPE string.
  DATA: lv_status_code TYPE i.
  DATA: lv_reason TYPE string.
  DATA: lv_body TYPE string.
  DATA: lv_json TYPE string.

  CALL METHOD me->manufacturerpartnumber
    EXPORTING
      io_material = io_material
    CHANGING
      ct_json     = lt_json.

  CALL METHOD me->manufacturer
    EXPORTING
      io_material = io_material
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

   call method me->sparepartdescription_langu
     exporting
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
    MESSAGE e001(zpsain).
  ENDIF.
*-----------------------------------------------------------------------
* Set Request URI
*-----------------------------------------------------------------------
  CONCATENATE zaco_cl_connection_ain=>gv_service '/parts' INTO lv_service.
  cl_http_utility=>set_request_uri( request = lo_http_client->request
                                       uri  = lv_service ).

  lo_http_client->request->set_method( 'POST' ).
  lo_http_client->request->set_header_field( name = 'Content-Type' value = 'application/json' ).


  CALL METHOD zaco_cl_connection_ain=>CONSTRUCT_BODY_MAT_LANGU
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
    REFRESH ct_result.
  ENDIF.
  CALL METHOD lo_http_client->close( ).

ENDMETHOD.


METHOD DELETE_SPAREPART.

  DATA: lo_http_client TYPE REF TO if_http_client.

  DATA: lt_json TYPE zaco_t_json_body.

  DATA: lv_matnr TYPE matnr.
  DATA: lv_service TYPE string.
  DATA: lv_status_code TYPE i.
  DATA: lv_reason TYPE string.
  DATA: lv_body TYPE string.
  DATA: lv_json TYPE string.
  DATA: lv_ok TYPE char1.
  DATA: lv_id TYPE string.

  DATA: lv_body_begin TYPE string.
  DATA: lv_body_end TYPE string.
  DATA: lv_name_end TYPE string.
  DATA: lv_name_begin TYPE string.
  DATA: lv_multiple_begin TYPE string.
  DATA: lv_multiple_last TYPE string.
  DATA: lv_line_end TYPE string.

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
    MESSAGE e001(zpsain).
  ENDIF.


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
    REFRESH ct_result.
  ENDIF.


ENDMETHOD.


METHOD DIMENSION.

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: lv_meins TYPE mara-meins.
  DATA: lv_uom_erp TYPE zaco_de_einheit.
  DATA: lv_uom_ain TYPE zaco_de_einheit.
  DATA: lv_dimension TYPE zaco_de_dimension.

  ls_json-name = 'dimension'.
  CALL METHOD io_material->get_meins
    CHANGING
      cv_meins = lv_meins.
  lv_uom_erp = lv_meins.
  CALL METHOD zaco_cl_templates=>translate_uom_to_ain
    EXPORTING
      iv_uom_erp   = lv_uom_erp
      iv_rfcdest   = iv_rfcdest
    CHANGING
*     cv_loghndl   =
      cv_uom_ain   = lv_uom_ain
      cv_dimension = lv_dimension.
  ls_json-value = lv_dimension.
  APPEND ls_json TO ct_json.


ENDMETHOD.


method EANNUMBER.

  data: ls_json type zpsain_s_json_body.
  data: ls_marm type marm.

  data: lv_ean type ean11.
  data: lv_meins type meins.

  ls_json-name = 'eannumber'.

  CALL METHOD io_material->GET_MEINS
    CHANGING
      CV_MEINS = lv_meins.

  CALL METHOD io_material->GET_MARM_FOR_UNIT
    EXPORTING
      IV_MEINH  = lv_meins
    CHANGING
      CS_MARM   = ls_marm
    EXCEPTIONS
      NOT_FOUND = 1
      others    = 2.
  IF SY-SUBRC = 0.
    ls_json-value = ls_marm-ean11.
    append ls_json to ct_json.
  ENDIF.

endmethod.


METHOD GROESSE_ABMESSUNG.

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: lv_groes TYPE groes.

  ls_json-name = 'sizeDimensions'.
  CALL METHOD io_material->get_groes
    CHANGING
      cv_groes = lv_groes.
  ls_json-value = lv_groes.
  APPEND ls_json TO ct_json.
ENDMETHOD.


method GROSSWEIGHT.

  data: ls_json type zaco_s_json_body.
  data: lv_brgew type brgew.

  ls_json-name = 'grossWeight'.
  CALL METHOD io_material->GET_BRGEW
    CHANGING
      CV_BrGEW = lv_brgew.
  ls_json-value = lv_brgew.
  append ls_json to ct_json.

endmethod.


METHOD HOEHE.

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: lv_hoehe TYPE hoehe.

  ls_json-name = 'height'.
  CALL METHOD io_material->get_hoehe
    CHANGING
      cv_hoehe = lv_hoehe.
  IF lv_hoehe > 0.
    ls_json-value = lv_hoehe.
    APPEND ls_json TO ct_json.
  ENDIF.
ENDMETHOD.


method ID.

  data: ls_json type zpsain_s_json_body.
  data: lv_meins type mara-meins.

  ls_json-name = 'id'.
*  ls_json-parent = 'spareparts'.
  ls_json-value = iv_id.
  append ls_json to ct_json.


endmethod.


method INTERNALID.

  data: ls_json type zaco_s_json_body.
  data: lv_matnr type matnr.

  ls_json-name = 'sparepartInternalID'.
  CALL METHOD io_material->GET_MATNR
    CHANGING
      CV_MATNR = lv_matnr.

  ls_json-value = lv_matnr.
  append ls_json to ct_json.

endmethod.


METHOD LAENGE.

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: lv_laeng TYPE laeng.

  ls_json-name = 'length'.
  CALL METHOD io_material->get_laeng
    CHANGING
      cv_laeng = lv_laeng.
  IF lv_laeng > 0.
    ls_json-value = lv_laeng.
    APPEND ls_json TO ct_json.
  ENDIF.
ENDMETHOD.


method LEADTIMEDURATION.

  data: ls_json type zaco_s_json_body.
  data: lv_plifz type marc-plifz.
  data: lv_gwbz  type marc-wzeit.
  data: lv_beskz type marc-beskz.

  ls_json-name = 'leadTimeDuration'.
  CALL METHOD io_material->GET_BESKZ
    CHANGING
      CV_BESKZ = lv_beskz.

  case lv_beskz.
    when 'E'.
      CALL METHOD io_material->GET_WBZ
        RECEIVING
          CV_WZEIT = lv_gwbz.
      ls_json-value = lv_gwbz.
    when 'F'.
      CALL METHOD io_material->GET_PLIFZ
        CHANGING
          CV_PLIFZ = lv_plifz.
      ls_json-value = lv_plifz.
  endcase.
  append ls_json to ct_json.


endmethod.


method LEADTIMEDURATIONUNIT.

  data: ls_json type zaco_s_json_body.

  ls_json-name = 'leadTimeDurationUnit'.
  ls_json-value = '3'.                   "Tage
  append ls_json to ct_json.

endmethod.


method LONGDESCRIPTION.

*  data: lt_text type tline_tab.
*
*  data: ls_tline type tline.

  data: ls_json type zpsain_s_json_body.
*  data: lv_text type string.
  data: lv_maktx type maktx.
  data: lv_normt type normt.
  data: lv_wrkst type wrkst.

  ls_json-name = 'longDescription'.
*  CALL METHOD io_material->GET_GRUTXT
*    CHANGING
*      CT_GRUTXT = lt_text.
*
*  loop at lt_text into ls_tline.
*    concatenate lv_text ls_tline '\n' into lv_text.
*  endloop.
*  ls_json-value = lv_text.
  CALL METHOD io_material->GET_KTXT
    RECEIVING
      CV_MAKTX = lv_maktx.
  CALL METHOD io_material->GET_NORMT
    CHANGING
      CV_NORMT = lv_normt.

  CALL METHOD io_material->GET_WRKST
    CHANGING
      CV_WRKST = lv_wrkst.
  concatenate lv_maktx lv_normt lv_wrkst into ls_json-value SEPARATED BY space.

  ls_json-parent = 'sparepartDescription'.
  append ls_json to ct_json.

endmethod.


METHOD MANUFACTURER.

  DATA: lo_bp_ain TYPE REF TO zaco_cl_business_partner_ain.

  DATA: lt_result TYPE zaco_t_json_body.

  DATA: ls_json TYPE zaco_s_json_body.

  CREATE OBJECT lo_bp_ain.

  ls_json-name = 'manufacturer'.

  CALL METHOD lo_bp_ain->get_bp_id_by_name
    EXPORTING
      iv_bp_name = 'NETZSCH_PS'
      iv_rfcdest = iv_rfcdest
    CHANGING
*     cv_loghndl =
      cv_bp_id   = ls_json-value
      ct_result  = lt_result.

*  CALL METHOD zpsain_cl_templates=>get_businesspartner_by_name
*    EXPORTING
*      iv_rfcdest   = iv_rfcdest
*      iv_name      = 'NETZSCH_PS'
*    CHANGING
**     cv_loghndl   =
*      ic_partnerid = ls_json-value.

  APPEND ls_json TO ct_json.

ENDMETHOD.


method MANUFACTURERPARTNUMBER.

  data: ls_json type zaco_s_json_body.
  data: lv_matnr type matnr.

  ls_json-name = 'manufacturerPartNumber'.
  CALL METHOD io_material->GET_MATNR
    CHANGING
      CV_MATNR = lv_matnr.
  ls_json-value = lv_matnr.
  append ls_json to ct_json.

endmethod.


method NETWEIGHT.

  data: ls_json type zaco_s_json_body.
  data: lv_ntgew type ntgew.

  ls_json-name = 'netWeight'.
  CALL METHOD io_material->GET_NETGW
    CHANGING
      CV_NTGEW = lv_ntgew.
  ls_json-value = lv_ntgew.
  append ls_json to ct_json.

endmethod.


method SPAREPARTDESCRIPTION.

  data: ls_json type zpsain_s_json_body.
  data: lv_maktx type maktx.
  data: lv_normt type normt.
  data: lv_wrkst type wrkst.

  ls_json-name = 'sparepartDescription'.
  CALL METHOD io_material->GET_KTXT
    RECEIVING
      CV_MAKTX = lv_maktx.
*  CALL METHOD io_material->GET_NORMT
*    CHANGING
*      CV_NORMT = lv_normt.
*
*  CALL METHOD io_material->GET_WRKST
*    CHANGING
*      CV_WRKST = lv_wrkst.
*  concatenate lv_maktx lv_normt lv_wrkst into ls_json-value SEPARATED BY space.
  ls_json-value = lv_maktx.
  ls_json-parent = ls_json-name.
  append ls_json to ct_json.

endmethod.


METHOD SPAREPARTDESCRIPTION_LANGU.

  DATA: lt_maktx TYPE makt_tab.

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: ls_maktx TYPE makt.

  DATA: lv_normt TYPE normt.
  DATA: lv_wrkst TYPE wrkst.
  DATA: lv_langu TYPE char2.

  CALL METHOD io_material->get_makt
    CHANGING
      ct_makt = lt_maktx.

  LOOP AT lt_maktx INTO ls_maktx where spras ne '1'.

    ls_json-name = 'sparepartDescription'.
    ls_json-parent = 'sparepartDescriptions'.
    ls_json-multiple = 'X'.
    ls_json-multiple_body = 'X'.
    ls_json-next = 'X'.
    ls_json-value = ls_maktx-maktx.
    APPEND ls_json TO ct_json.

    CLEAR ls_json.

    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
      EXPORTING
        input  = ls_maktx-spras
      IMPORTING
        output = lv_langu.

    translate lv_langu to lower case.
    ls_json-name = 'longDescription'.
    ls_json-parent = 'sparepartDescriptions'.
    ls_json-value = ls_maktx-maktx..
    ls_json-multiple_body = 'X'.
    APPEND ls_json TO ct_json.

    CLEAR ls_json.

    ls_json-name = 'languageISoCode'.
    ls_json-parent = 'sparepartDescriptions'.
    ls_json-value = lv_langu.
    ls_json-multiple_body = 'X'.
    ls_json-last = 'X'.
    APPEND ls_json TO ct_json.

    CLEAR ls_json.

  ENDLOOP.
ENDMETHOD.


method SPAREPARTNAME.

  data: ls_json type zpsain_s_json_body.
  data: lv_maktx type maktx.
  data: lv_normt type normt.
  data: lv_wrkst type wrkst.

  ls_json-name = 'sparepartName'.
  CALL METHOD io_material->GET_KTXT
    RECEIVING
      CV_MAKTX = lv_maktx.
  CALL METHOD io_material->GET_NORMT
    CHANGING
      CV_NORMT = lv_normt.

  CALL METHOD io_material->GET_WRKST
    CHANGING
      CV_WRKST = lv_wrkst.
  concatenate lv_maktx lv_normt lv_wrkst into ls_json-value SEPARATED BY space.
    ls_json-parent = 'sparepartDescription'.
  append ls_json to ct_json.

endmethod.


method SPAREPARTS.

  data: ls_json type zpsain_s_json_body.
  data: lv_meins type mara-meins.

  ls_json-name = 'spareparts'.
  ls_json-multiple = 'X'.
  append ls_json to ct_json.


endmethod.


METHOD SPAREPARTS_ALREADY_TRANSFERRED.

  DATA: lo_http_client TYPE REF TO if_http_client.

  DATA: lt_json TYPE zaco_t_json_body.

  DATA: ls_json TYPE zaco_s_json_body.

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
  IF sy-subrc <> 0.
    MESSAGE e001(zpsain).
  ENDIF.


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

  IF lv_status_code EQ '200'.
    lv_json = lo_http_client->response->get_cdata( ).
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
    cv_transferred = space.
  ENDIF.
  CALL METHOD lo_http_client->close( ).
ENDMETHOD.


method SUBCLASS.

  data: ls_json type zpsain_s_json_body.
  ls_json-name = 'subClass'.
  ls_json-value = 'C72A865B6302447FA109D97AAFDA05DE'.   "'A43F6328772B43D183345AF1FB7A0B96'.
  append ls_json to ct_json.


endmethod.


METHOD UOM.

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: lv_meins TYPE mara-meins.
  DATA: lv_uom_erp TYPE zaco_de_einheit.
  DATA: lv_uom_ain TYPE zaco_de_einheit.
  DATA: lv_dimension TYPE zaco_de_dimension.

  ls_json-name = 'uom'.
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
*     cv_loghndl   =
      cv_uom_ain   = lv_uom_ain
      cv_dimension = lv_dimension.
  ls_json-value = lv_uom_ain.
  APPEND ls_json TO ct_json.



ENDMETHOD.


METHOD UOM_LENGTH_WIDTH_HEIGHT.

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: lv_meabm TYPE marm-meabm.
  DATA: lv_uom_erp TYPE zaco_de_einheit.
  DATA: lv_uom_ain TYPE zaco_de_einheit.
  DATA: lv_dimension TYPE zaco_de_dimension.

  ls_json-name = 'unitOfLengthWidthHeight'.
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
*     cv_loghndl   =
      cv_uom_ain   = lv_uom_ain
      cv_dimension = lv_dimension.
  ls_json-value = lv_uom_ain.
  APPEND ls_json TO ct_json.


ENDMETHOD.


METHOD UOM_VOLUMEN.

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: lv_voleh TYPE voleh.
  DATA: lv_uom_erp TYPE zaco_de_einheit.
  DATA: lv_uom_ain TYPE zaco_de_einheit.
  DATA: lv_dimension TYPE zaco_de_dimension.

  ls_json-name = 'volumeUnit'.

  CALL METHOD io_material->get_voleh
    CHANGING
      cv_voleh = lv_voleh.

  lv_uom_erp = lv_voleh.
  CALL METHOD zaco_cl_templates=>translate_uom_to_ain
    EXPORTING
      iv_uom_erp   = lv_uom_erp
      iv_rfcdest  = iv_rfcdest
    CHANGING
*     cv_loghndl   =
      cv_uom_ain   = lv_uom_ain
      cv_dimension = lv_dimension.
  ls_json-value = lv_uom_ain.
  APPEND ls_json TO ct_json.


ENDMETHOD.


METHOD UPDATE_SPAREPART.

  DATA: lo_http_client  TYPE REF TO if_http_client.

  DATA: lt_json TYPE zaco_t_json_body.

  DATA: lv_service TYPE string.
  DATA: lv_status_code TYPE i.
  DATA: lv_reason TYPE string.
  DATA: lv_body TYPE string.
  DATA: lv_json TYPE string.

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
  ENDIF.
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
    REFRESH ct_result.
  ENDIF.
  lo_http_client->close( ).
ENDMETHOD.


METHOD VOLUMEN.

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: lv_volum TYPE volum.

  ls_json-name = 'volume'.
  CALL METHOD io_material->get_volum
    CHANGING
      cv_volum = lv_volum.

  ls_json-value = lv_volum.
  APPEND ls_json TO ct_json.

ENDMETHOD.


METHOD WEIGHTUNIT.

  DATA: ls_json TYPE zaco_s_json_body.
  DATA: lv_gewei TYPE mara-gewei.
  DATA: lv_uom_erp TYPE zaco_de_einheit.
  DATA: lv_uom_ain TYPE zaco_de_einheit.
  DATA: lv_dimension TYPE zaco_de_dimension.


  ls_json-name = 'weightUnit'.
  CALL METHOD io_material->get_gewei
    CHANGING
      cv_gewei = lv_gewei.

  lv_uom_erp = lv_gewei.
  CALL METHOD zaco_cl_templates=>translate_uom_to_ain
    EXPORTING
      iv_uom_erp   = lv_uom_erp
      iv_rfcdest   = iv_rfcdest
    CHANGING
*     cv_loghndl   =
      cv_uom_ain   = lv_uom_ain
      cv_dimension = lv_dimension.
  ls_json-value = lv_uom_ain.
  APPEND ls_json TO ct_json.

ENDMETHOD.
ENDCLASS.
