*----------------------------------------------------------------------*
***INCLUDE ZCHAIN_ERR_LOG_LESE_ERNEUTF01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  LESE_ERNEUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM lese_erneut .

  DATA: lt_error_log  TYPE zaco_tt_err_log.

  DATA: ls_error_log  TYPE zaco_err_log.

  REFRESH gt_error_dia.
  CLEAR gs_error_dia.

  CALL METHOD zaco_cl_error_log=>read_error
    EXPORTING
      iv_datum_b   = GV_DATUMB
      iv_datum_v   = GV_DATUMV
      iv_err_group = GV_ERR_GROUP
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

  ENDLOOP.

ENDFORM.
