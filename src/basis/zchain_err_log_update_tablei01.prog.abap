*----------------------------------------------------------------------*
***INCLUDE ZCHAIN_ERR_LOG_UPDATE_TABLEI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  UPDATE_TABLE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE update_table INPUT.
  modify gt_error_dia from gs_error_dia index CONT_ERR-CURRENT_LINE.
ENDMODULE.
