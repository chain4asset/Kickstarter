*----------------------------------------------------------------------*
***INCLUDE ZCHAIN_ERR_LOG_DISPLAY_JSONF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_JSON
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_json .

  DATA: lo_textedit TYPE REF TO cl_gui_textedit.

  LOOP AT gt_error_dia INTO gs_error_dia WHERE check NE space.


    IF ( gs_error_dia-err_group = 'EQUI' ).
      /ui2/cl_json=>deserialize( EXPORTING
                                   json        = gs_error_dia-json
                                   pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING
                                   data        = gs_json_equi ).

      DATA(json_writer) = cl_sxml_string_writer=>create(
                        type = if_sxml=>co_xt_json ).
      CALL TRANSFORMATION id SOURCE result = gs_json_equi
                           RESULT XML json_writer.
      DATA(json) = json_writer->get_output( ).
      CALL TRANSFORMATION sjson2html SOURCE XML json
                                     RESULT XML DATA(html).

      cl_demo_output=>display_html(
      cl_abap_codepage=>convert_from( html ) ).
    ENDIF.
    clear html.
    clear json.
    clear gs_json_equi.
  ENDLOOP.

ENDFORM.
