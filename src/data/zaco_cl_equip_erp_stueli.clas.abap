class ZACO_CL_EQUIP_ERP_STUELI definition
  public
  create public .

public section.

  methods GET_POSITIONEN
    changing
      !CT_POSITION type ZACO_TT_EQUI_STUELI_POS .
  methods LESE_POSITIONEN
    importing
      !IV_EQUNR type EQUNR optional
      !IV_WERKS type WERKS_D default '0002'
    exceptions
      ALT_NOT_FOUND
      CALL_INVALID
      EQUIPMENT_NOT_FOUND
      MISSING_AUTHORIZATION
      NO_BOM_FOUND
      NO_PLANT_DATA
      NO_SUITABLE_BOM_FOUND
      OTHER_ERROR .
protected section.
private section.

  data GT_POSITION type ZACO_TT_EQUI_STUELI_POS .
ENDCLASS.



CLASS ZACO_CL_EQUIP_ERP_STUELI IMPLEMENTATION.


method GET_POSITIONEN.

  ct_position[] = gt_position[].

endmethod.


  method LESE_POSITIONEN.

  DATA: lo_badi_equip TYPE REF TO zaco_ain_data_equip_stueli_erp.
  DATA: lo_stuepo   TYPE REF TO zaco_cl_equip_erp_stueli_pos.

  DATA: lt_stb      TYPE roij_stpox_t.
  DATA: lt_matcat   TYPE zaco_tt_cscmat.

  DATA: ls_position TYPE zaco_s_equi_stueli_pos.
  DATA: ls_topequi  TYPE cstequi.
  DATA: ls_stb      TYPE stpox.
  DATA: ls_matcat   TYPE cscmat.
*  DATA: ls_drawing  TYPE zpspp_bwa_s_text.


  CALL FUNCTION 'CS_BOM_EXPL_EQU_V2'
    EXPORTING
      capid                 = 'INST'
      datuv                 = sy-datum
      eqnrv                 = iv_equnr
      werks                 = iv_werks
    IMPORTING
      topequi               = ls_topequi
    TABLES
      stb                   = lt_stb
      matcat                = lt_matcat
    EXCEPTIONS
      alt_not_found         = 1
      call_invalid          = 2
      equipment_not_found   = 3
      missing_authorization = 4
      no_bom_found          = 5
      no_plant_data         = 6
      no_suitable_bom_found = 7
      OTHERS                = 8.
  CASE sy-subrc.
    WHEN 1.
      RAISE alt_not_found.
    WHEN 2.
      RAISE call_invalid.
    WHEN 3.
      RAISE equipment_not_found.
    WHEN 4.
      RAISE missing_authorization.
    WHEN 5.
      RAISE no_bom_found.
    WHEN 6.
      RAISE no_plant_data.
    WHEN 7.
      RAISE  no_suitable_bom_found.
    WHEN 8.
      RAISE other_error.
  ENDCASE.
* Implement suitable error handling here

  LOOP AT lt_stb INTO ls_stb.
    CREATE OBJECT lo_stuepo.
    CALL METHOD lo_stuepo->set_matnr
      EXPORTING
        iv_idnrk = ls_stb-idnrk.
    CALL METHOD lo_stuepo->set_meins
      EXPORTING
        iv_meins = ls_stb-meins.
    CALL METHOD lo_stuepo->set_menge
      EXPORTING
        iv_menge = ls_stb-menge.
    CALL METHOD lo_stuepo->set_posnr
      EXPORTING
        iv_posnr = ls_stb-posnr.
    CALL METHOD lo_stuepo->set_postp
      EXPORTING
        iv_postp = ls_stb-postp.
    CALL METHOD lo_stuepo->set_stlkn
      EXPORTING
        iv_stlkn = ls_stb-stlkn.
    CALL METHOD lo_stuepo->set_stlnr
      EXPORTING
        iv_stlnr = ls_stb-stlnr.
    CALL METHOD lo_stuepo->set_stufe
      EXPORTING
        iv_stufe = ls_stb-stufe.
    CALL METHOD lo_stuepo->set_werks
      EXPORTING
        iv_werks = ls_stb-werks.

    CALL METHOD lo_stuepo->set_erskz
      EXPORTING
        iv_erskz = ls_stb-erskz.

    ls_position-stlkn = ls_stb-stlkn.
    ls_position-lo_position ?= lo_stuepo.
    APPEND ls_position TO gt_position.

  ENDLOOP.
*-------------------- Exit rein ------------------*

  GET BADI lo_badi_equip FILTERS zaco_werk = ls_stb-werks.
  CALL BADI lo_badi_equip->enhance_bom
    EXPORTING
      io_equip_erp_stueli = me.



  endmethod.
ENDCLASS.
