*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZACO_AIN_CONVIEW
*   generation date: 06.06.2019 at 15:36:30
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZACO_AIN_CONVIEW   .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
