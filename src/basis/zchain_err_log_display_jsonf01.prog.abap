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

  loop at gt_error_dia into gs_error_dia where check ne space.
    call screen 210.

  endloop.

ENDFORM.
