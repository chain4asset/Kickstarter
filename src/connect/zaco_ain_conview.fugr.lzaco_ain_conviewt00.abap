*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 06.06.2019 at 15:36:33
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZACO_AIN_UOM....................................*
DATA:  BEGIN OF STATUS_ZACO_AIN_UOM                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZACO_AIN_UOM                  .
CONTROLS: TCTRL_ZACO_AIN_UOM
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZACO_TENANT_SY..................................*
DATA:  BEGIN OF STATUS_ZACO_TENANT_SY                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZACO_TENANT_SY                .
CONTROLS: TCTRL_ZACO_TENANT_SY
            TYPE TABLEVIEW USING SCREEN '0004'.
*...processing: ZACO_T_GROUPS...................................*
DATA:  BEGIN OF STATUS_ZACO_T_GROUPS                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZACO_T_GROUPS                 .
CONTROLS: TCTRL_ZACO_T_GROUPS
            TYPE TABLEVIEW USING SCREEN '0002'.
*...processing: ZACO_T_MODEL....................................*
DATA:  BEGIN OF STATUS_ZACO_T_MODEL                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZACO_T_MODEL                  .
CONTROLS: TCTRL_ZACO_T_MODEL
            TYPE TABLEVIEW USING SCREEN '0003'.
*.........table declarations:.................................*
TABLES: *ZACO_AIN_UOM                  .
TABLES: *ZACO_TENANT_SY                .
TABLES: *ZACO_T_GROUPS                 .
TABLES: *ZACO_T_MODEL                  .
TABLES: ZACO_AIN_UOM                   .
TABLES: ZACO_TENANT_SY                 .
TABLES: ZACO_T_GROUPS                  .
TABLES: ZACO_T_MODEL                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
