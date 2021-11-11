*&---------------------------------------------------------------------*
*& Report ZCHAIN_ERROR_LOG
*&---------------------------------------------------------------------*
*& CHAIN Log
*&---------------------------------------------------------------------*
REPORT zchain_error_log.

DATA: go_error_log_gui TYPE REF TO zaco_cl_error_log_gui,
      gv_date          TYPE datum,
      gv_error_group   TYPE zaco_de_err_group,
      gv_equipment     TYPE equnr.

**********************************************************************
* Selection Screen
SELECT-OPTIONS: s_date   FOR gv_date.
SELECT-OPTIONS: s_errgrp FOR gv_error_group NO INTERVALS.
SELECT-OPTIONS: s_equnr  FOR gv_equipment NO INTERVALS.
PARAMETERS: p_msg_s TYPE flag AS CHECKBOX DEFAULT abap_true.
PARAMETERS: p_msg_i TYPE flag AS CHECKBOX DEFAULT abap_true.
PARAMETERS: p_msg_e TYPE flag AS CHECKBOX DEFAULT abap_true.

**********************************************************************
INITIALIZATION.

  go_error_log_gui = NEW #( ).
  s_date[] =  go_error_log_gui->get_default_date_range( ).

**********************************************************************
START-OF-SELECTION.

  " Set parameter
  go_error_log_gui->set_date_range( s_date[] ).
  go_error_log_gui->set_error_group_range( s_errgrp[] ).
  go_error_log_gui->set_equipment_range( s_equnr[] ).
  go_error_log_gui->set_message_types(
                      iv_success  = p_msg_s
                      iv_info     = p_msg_i
                      iv_error    = p_msg_e
                    ).
  " Run ...
  go_error_log_gui->display( ).
  WRITE: space.
