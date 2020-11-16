*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZACO_BUSI_PAR
*   generation date: 04.11.2019 at 13:22:07
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZACO_BUSI_PAR      .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
