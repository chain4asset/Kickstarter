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

  perform lese_erneut.

  CALL SCREEN 110.

END-OF-SELECTION.

  INCLUDE zchain_err_log_backi01.

  INCLUDE zchain_err_log_status_0110o01.

  INCLUDE zchain_err_log_user_commandi01.

  INCLUDE zchain_err_log_exiti01.

  INCLUDE zchain_err_log_display_jsonf01.

INCLUDE zchain_err_log_update_tablei01.

INCLUDE zchain_err_log_lese_erneutf01.
