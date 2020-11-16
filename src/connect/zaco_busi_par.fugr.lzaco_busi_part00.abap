*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 04.11.2019 at 13:00:25
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZACO_BUSI_PAR...................................*
DATA:  BEGIN OF STATUS_ZACO_BUSI_PAR                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZACO_BUSI_PAR                 .
CONTROLS: TCTRL_ZACO_BUSI_PAR
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZACO_BUSI_PAR                 .
TABLES: ZACO_BUSI_PAR                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
