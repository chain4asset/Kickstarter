*&---------------------------------------------------------------------*
*& Report ZCHAIN_ERR_LOG
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zchain_err_log.

CONTROLS cont_err   TYPE TABLEVIEW USING SCREEN '110'.

DATA: gt_error_dia  TYPE STANDARD TABLE OF zaco_s_dia_err_log.
DATA: lt_error_log  TYPE zaco_tt_err_log.

DATA: ls_error_log  TYPE zaco_err_log.
DATA: gs_error_dia  TYPE zaco_s_dia_err_log.
DATA: gs_json_equi  TYPE zaco_s_equipment_json.

DATA: gv_err_group  TYPE zaco_de_err_group.
DATA: gv_datumv     TYPE datum.
DATA: gv_datumb     TYPE datum.
DATA: gv_json       TYPE string.
DATA: fcode         TYPE sy-ucomm.

PARAMETERS: vdate   TYPE datum.
PARAMETERS: bdate   TYPE datum.
PARAMETERS: perrg   TYPE zaco_de_err_group.

START-OF-SELECTION.

  gv_datumv = vdate.
  gv_datumb = bdate.
  gv_err_group = perrg.

  CALL METHOD zaco_cl_error_log=>read_error
    EXPORTING
      iv_datum_b   = bdate
      iv_datum_v   = vdate
      iv_err_group = perrg
    CHANGING
      ct_err_log   = lt_error_log.

  LOOP AT lt_error_log INTO ls_error_log.
    gs_error_dia-datum = ls_error_log-datum.
    gs_error_dia-utime = ls_error_log-utime.
    gs_error_dia-equnr = ls_error_log-equnr.
    gs_error_dia-err_group = ls_error_log-err_group.
    gs_error_dia-json = ls_error_log-json.
    MESSAGE ID ls_error_log-msgid TYPE ls_error_log-msgty NUMBER ls_error_log-msgno
          INTO gs_error_dia-fehlertext WITH ls_error_log-msgv1 ls_error_log-msgv2 ls_error_log-msgv3 ls_error_log-msgv4.
    APPEND gs_error_dia TO gt_error_dia.

    IF ( gs_error_dia-err_group = 'EQUI' ).
      /ui2/cl_json=>deserialize( EXPORTING
                                   json        = ls_error_log-json
                                   pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                 CHANGING
                                   data        = gs_json_equi ).
    ENDIF.
  ENDLOOP.



  CALL SCREEN 110.

END-OF-SELECTION.

  INCLUDE zchain_err_log_backi01.

  INCLUDE zchain_err_log_status_0110o01.

  INCLUDE zchain_err_log_user_commandi01.

  INCLUDE zchain_err_log_exiti01.

  INCLUDE zchain_err_log_display_jsonf01.
