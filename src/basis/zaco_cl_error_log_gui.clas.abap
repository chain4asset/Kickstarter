class ZACO_CL_ERROR_LOG_GUI definition
  public
  final
  create public .

public section.

  types:
    ty_t_error_group_range TYPE RANGE OF zaco_de_err_group .
  types:
    ty_t_equipment_range TYPE RANGE OF equnr .
  types:
    ty_t_date_range  TYPE RANGE OF datum .
  types:
    ty_t_message_type_range TYPE RANGE OF msgty .
  types:
    BEGIN OF ty_s_log_output,
        message_icon TYPE char10,
        date         TYPE datum,
        time         TYPE utime,
        message_type TYPE msgty,
        error_group  TYPE zaco_de_err_group,
        equipment    TYPE equnr,
        message      TYPE string,
        json_icon    TYPE char10,
        json         TYPE string,
      END OF ty_s_log_output .
  types:
    ty_t_log_output TYPE STANDARD TABLE OF  ty_s_log_output WITH DEFAULT KEY .

  constants:
    BEGIN OF c_error_groups,
        equi TYPE zaco_de_err_group VALUE 'EQUI',
        org  TYPE zaco_de_err_group VALUE 'ORG',
        img  TYPE zaco_de_err_group VALUE 'IMG',
        loc  TYPE zaco_de_err_group VALUE 'LOC',
        spa  TYPE zaco_de_err_group VALUE 'SPA',
        temp TYPE zaco_de_err_group VALUE 'TEMP',
        mod  TYPE zaco_de_err_group VALUE 'MOD',
      END OF c_error_groups .
  constants:
    BEGIN OF c_json_structure_type,
        equi TYPE string VALUE 'ZCHAIN_S_EQUIPMENT_READ',
        org  TYPE string VALUE 'ZCHAIN_S_EXTERNAL_ORG_ANSW',
        img  TYPE string VALUE 'ZCHAIN_S_IMAGE_RESPONSE',
        loc  TYPE string VALUE 'ZCHAIN_S_INSTALL_LOCATION_JS',
        spa  TYPE string VALUE 'ZCHAIN_S_SPAREPART_READ',
        temp TYPE string VALUE 'ZCHAIN_S_TEMPLATE_READ',
        mod  TYPE string VALUE 'ZCHAIN_S_MODEL_GET_JSON',
      END OF c_json_structure_type .

  methods CONSTRUCTOR .
  methods DISPLAY .
  methods GET_DEFAULT_DATE_RANGE
    returning
      value(RT_DATE) type TY_T_DATE_RANGE .
  methods INIT .
  methods SET_ERROR_GROUP_RANGE
    importing
      !IT_ERROR_GROUP_RANGE type TY_T_ERROR_GROUP_RANGE .
  methods SET_DATE_RANGE
    importing
      !IT_DATE_RANGE type TY_T_DATE_RANGE .
  methods SET_EQUIPMENT_RANGE
    importing
      !IT_EQUIPMENT_RANGE type TY_T_EQUIPMENT_RANGE .
  methods SET_MESSAGE_TYPES
    importing
      !IV_SUCCESS type FLAG
      !IV_INFO type FLAG
      !IV_ERROR type FLAG .
protected section.
private section.

  data GO_ALV_LOG type ref to CL_SALV_TABLE .
  data GO_JSON_CONTAINER type ref to CL_GUI_CONTAINER .
  data GO_JSON_DOCKING_CONTAINER type ref to CL_GUI_DOCKING_CONTAINER .
  data GT_LOG_DATA type TY_T_LOG_OUTPUT .
  data GT_DATE_RANGE type TY_T_DATE_RANGE .
  data GT_ERROR_GROUP_RANGE type TY_T_ERROR_GROUP_RANGE .
  data GT_EQUIPMENT_RANGE type TY_T_EQUIPMENT_RANGE .
  data GT_MESSAGE_TYPE_RANGE type TY_T_MESSAGE_TYPE_RANGE .

  methods GENERATE_JSON_OUTPUT
    importing
      !IV_JSON_RAW type STRING
      !IV_ERROR_GROUP type ZACO_DE_ERR_GROUP
    returning
      value(RV_JSON) type STRING .
  methods HIDE_JSON_CONTAINER .
  methods INIT_ALV_LOG .
  methods INIT_JSON_CONTAINER .
  methods LOAD_DATA .
  methods ON_DOUBLE_CLICK_LOG_ALV
    for event DOUBLE_CLICK of CL_SALV_EVENTS_TABLE
    importing
      !ROW
      !COLUMN
      !SENDER .
  methods ON_FCT_SELECTED_JSON_TOOLBAR
    for event FUNCTION_SELECTED of CL_GUI_TOOLBAR
    importing
      !FCODE
      !SENDER .
  methods SHOW_JSON_CONTAINER .
ENDCLASS.



CLASS ZACO_CL_ERROR_LOG_GUI IMPLEMENTATION.


  METHOD constructor.
  ENDMETHOD.


  METHOD display.

    load_data( ).
    init( ).

    CHECK go_alv_log IS BOUND.

    go_alv_log->display( ).
    hide_json_container( ).

  ENDMETHOD.


  METHOD generate_json_output.

*    DATA: lv_json_type TYPE string,
*          gs_json_equi TYPE zaco_s_equipment_json,
*          lr_json_data TYPE REF TO data.
*
*    FIELD-SYMBOLS: <ls_json_data> TYPE data.
*
*    CASE iv_error_group.
*
*      WHEN c_error_groups-equi.
*        lv_json_type = c_json_structure_type-equi.
*
*      WHEN c_error_groups-img.
*        lv_json_type = c_json_structure_type-img.
*
*      WHEN c_error_groups-loc.
*        lv_json_type = c_json_structure_type-loc.
*
*      WHEN c_error_groups-mod.
*        lv_json_type = c_json_structure_type-mod.
*
*      WHEN c_error_groups-org.
*        lv_json_type = c_json_structure_type-org.
*
*      WHEN c_error_groups-spa.
*        lv_json_type = c_json_structure_type-spa.
*
*      WHEN c_error_groups-temp.
*        lv_json_type = c_json_structure_type-temp.
*
*      WHEN OTHERS.
*
*        MESSAGE i803(zaco) WITH iv_error_group.
*        RETURN.
*
*    ENDCASE.
*
*    TRY .
*        CREATE DATA lr_json_data TYPE (lv_json_type).
*
*      CATCH cx_sy_create_data_error .
*
*        MESSAGE i804(zaco).
*        RETURN.
*
*    ENDTRY.
*
*
*    ASSIGN lr_json_data->* TO <ls_json_data>.
*
*
*    /ui2/cl_json=>deserialize( EXPORTING
*                                 json        = iv_json_raw
*                                 pretty_name = /ui2/cl_json=>pretty_mode-camel_case
*                               CHANGING
*                                 data        = <ls_json_data> ).
*
*    DATA(json_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
*
*    CALL TRANSFORMATION id SOURCE result = <ls_json_data> RESULT XML json_writer.
*
*    DATA(json) = json_writer->get_output( ).
*
*    CALL TRANSFORMATION sjson2html SOURCE XML json RESULT XML DATA(html).
*
*    rv_json = cl_abap_codepage=>convert_from( html ).

*    DATA lo_writer TYPE REF TO if_sxml_writer.

    CHECK iv_json_raw IS NOT INITIAL.

    TRY.

      CATCH cx_sxml_illegal_argument_error
            cx_sxml_parse_error.

    ENDTRY.

    DATA(lo_reader) = cl_sxml_String_reader=>create( cl_abap_codepage=>convert_to( iv_json_raw ) ).

    DATA(lo_writer) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

    lo_writer->if_sxml_writer~set_option( if_sxml_writer=>co_opt_linebreaks ).
    lo_writer->if_sxml_writer~set_option( if_sxml_writer=>co_opt_indent ).

    lo_reader->next_node( ).
    lo_reader->skip_node( lo_writer ).

    rv_json = cl_abap_codepage=>convert_from( lo_writer->get_output( ) ).

  ENDMETHOD.


  METHOD get_default_date_range.

    rt_date = VALUE #( (
      sign = 'I'
      option = 'BT'
      low    = sy-datum - 7
      high   = sy-datum
    ) ).

  ENDMETHOD.


  METHOD hide_json_container.

    go_json_docking_container->set_visible( abap_false ).

  ENDMETHOD.


  METHOD init.

    init_alv_log( ).
    init_json_container( ).
    hide_json_container( ).

  ENDMETHOD.


  METHOD init_alv_log.

    DATA lo_column TYPE REF TO cl_salv_column_table.

    CHECK go_alv_log IS NOT BOUND.

    TRY.

        cl_salv_table=>factory(
          EXPORTING
            r_container    = cl_gui_container=>screen0
          IMPORTING
            r_salv_table   = go_alv_log
          CHANGING
            t_table        = gt_log_data
        ).


        go_alv_log->get_functions( )->set_default( abap_true ).
        go_alv_log->get_functions( )->set_export_spreadsheet( abap_true ).
        go_alv_log->get_display_settings( )->set_striped_pattern( abap_true ).
        go_alv_log->get_columns( )->set_optimize( abap_true ).

        go_alv_log->get_columns( )->get_column( columnname = 'JSON' )->set_visible( abap_false ).
        go_alv_log->get_columns( )->get_column( columnname = 'MESSAGE_TYPE' )->set_visible( abap_false ).

        lo_column ?= go_alv_log->get_columns( )->get_column( columnname = 'MESSAGE_ICON' ).
        lo_column->set_icon( abap_true ).
        lo_column->set_alignment( if_salv_c_alignment=>centered ).

        lo_column ?= go_alv_log->get_columns( )->get_column( columnname = 'JSON_ICON' ).
        lo_column->set_icon( abap_true ).
        lo_column->set_alignment( if_salv_c_alignment=>centered ).
        lo_column->set_tooltip( 'JSON' ).

        SET HANDLER on_double_click_log_alv FOR go_alv_log->get_event( ).


      CATCH cx_salv_msg
            cx_salv_not_found.

    ENDTRY.

  ENDMETHOD.


  METHOD init_json_container.

    TYPES: lty_t_events TYPE STANDARD TABLE OF cntl_simple_event WITH DEFAULT KEY.

    CHECK go_json_docking_container IS NOT BOUND.

    go_json_docking_container = NEW #(
      ratio = 50
      no_autodef_progid_dynnr = abap_true
      side  = cl_gui_docking_container=>dock_at_right
    ).

    " Splitter for toolbar and JSON container
    DATA(lo_json_splitter) = NEW cl_gui_splitter_container(
                                parent  = go_json_docking_container
                                rows    = 2
                                columns = 1
                             ).

    lo_json_splitter->set_row_mode( cl_gui_splitter_container=>mode_absolute ).
    lo_json_splitter->set_row_height(
                        id     = 1
                        height = 24
                      ).
    lo_json_splitter->set_row_sash(
                        id    = 1
                        type  = cl_gui_splitter_container=>type_sashvisible
                        value = cl_gui_splitter_container=>false
                      ).

    " Toolbar
    DATA(lo_toolbar_container) = lo_json_splitter->get_container(
                                   row    = 1
                                   column = 1
                                 ).



    DATA(lo_json_toolbar) = NEW cl_gui_toolbar(
                              parent      = lo_toolbar_container
                              align_right = 1
                            ).

    lo_json_toolbar->add_button(
        fcode            = 'CLOSE_JSON'
        icon             = icon_close
        butn_type        = cntb_btype_button
    ).

    lo_json_toolbar->set_registered_events( VALUE lty_t_events( ( eventid    = cl_gui_toolbar=>m_id_function_selected
                                                                  appl_event = abap_true ) ) ).

    SET HANDLER on_fct_selected_json_toolbar FOR lo_json_toolbar.

    " Keep JSON container
    go_json_container = lo_json_splitter->get_container(
                          row    = 2
                          column = 1
                        ).

  ENDMETHOD.


  METHOD load_data.

    SELECT *
      FROM zaco_err_log
      INTO TABLE @DATA(lt_err_log)
        WHERE datum     IN @gt_date_range
          AND err_group IN @gt_error_group_range
          and equnr     IN @gt_equipment_range
          and msgty     IN @gt_message_type_range
      ORDER BY datum DESCENDING, utime DESCENDING.

    LOOP AT lt_err_log ASSIGNING FIELD-SYMBOL(<ls_err_log>).

      APPEND VALUE #(
        date         = <ls_err_log>-datum
        time         = <ls_err_log>-utime
        error_group  = <ls_err_log>-err_group
        equipment    = <ls_err_log>-equnr
        message_type = <ls_err_log>-msgty
        json         = <ls_err_log>-json
      ) TO gt_log_data ASSIGNING FIELD-SYMBOL(<ls_log_data>).

      " Message text
      MESSAGE
        ID <ls_err_log>-msgid
        TYPE <ls_err_log>-msgty
        NUMBER <ls_err_log>-msgno
        WITH <ls_err_log>-msgv1
             <ls_err_log>-msgv2
             <ls_err_log>-msgv3
             <ls_err_log>-msgv4
        INTO <ls_log_data>-message.

      " Message icon
      CASE <ls_err_log>-msgty.

        WHEN 'S'.
          <ls_log_data>-message_icon = icon_led_green.

        WHEN 'I'.
          <ls_log_data>-message_icon = icon_message_warning.

        WHEN 'W'.
          <ls_log_data>-message_icon = icon_message_warning.

        WHEN 'E'.
          <ls_log_data>-message_icon = icon_message_error.

      ENDCASE.

      " JSON icon
      IF <ls_log_data>-json IS NOT INITIAL.

        <ls_log_data>-json_icon = icon_display_text.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD on_double_click_log_alv.

    DATA lv_json_output TYPE string.

    TRY.

        lv_json_output = generate_json_output(
                           iv_json_raw    = gt_log_data[ row ]-json
                           iv_error_group = gt_log_data[ row ]-error_group
                         ).

      CATCH cx_sy_itab_line_not_found.

        RETURN.

    ENDTRY.

    IF lv_json_output IS INITIAL.

      MESSAGE 'No JSON message' TYPE 'S' DISPLAY LIKE 'E' .
      hide_json_container( ).
      RETURN.

    ENDIF.


    cl_abap_browser=>show_html(
        html_string  = lv_json_output
        check_html   = abap_false
        container    = go_json_container
    ).

    show_json_container( ).

  ENDMETHOD.


  METHOD on_fct_selected_json_toolbar.

    CASE fcode.

      WHEN 'CLOSE_JSON'.
        hide_json_container( ).

    ENDCASE.

  ENDMETHOD.


  METHOD set_date_range.

    gt_date_range = it_date_range.

  ENDMETHOD.


  METHOD set_equipment_range.

    gt_equipment_range = it_equipment_range.

  ENDMETHOD.


  METHOD set_error_group_range.

    gt_error_group_range = it_error_group_range.

  ENDMETHOD.


  METHOD SET_MESSAGE_TYPES.

    IF iv_success = 'X'.

      APPEND VALUE #(
        sign   = 'I'
        option = 'EQ'
        low    = 'S'
      ) TO gt_message_type_range.

    ENDIF.

    IF iv_info = 'X'.

      APPEND VALUE #(
        sign   = 'I'
        option = 'EQ'
        low    = 'I'
      ) TO gt_message_type_range.

    ENDIF.

    IF iv_error = 'X'.

      APPEND VALUE #(
        sign   = 'I'
        option = 'EQ'
        low    = 'E'
      ) TO gt_message_type_range.

      APPEND VALUE #(
          sign   = 'I'
          option = 'EQ'
          low    = 'W'
      ) TO gt_message_type_range.

    ENDIF.

  ENDMETHOD.


  METHOD show_json_container.

    go_json_docking_container->set_visible( abap_true ).

  ENDMETHOD.
ENDCLASS.
