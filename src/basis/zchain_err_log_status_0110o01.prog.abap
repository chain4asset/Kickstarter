*----------------------------------------------------------------------*
***INCLUDE ZCHAIN_ERR_LOG_STATUS_0110O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0110  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
   SET PF-STATUS 'ERRLOG'.
   SET TITLEBAR '110'.

   loop at gt_error_dia into gs_error_dia where check ne space.
     gs_error_dia-check = space.
     modify gt_error_dia from gs_error_dia index sy-tabix.
   ENDLOOP.

ENDMODULE.
