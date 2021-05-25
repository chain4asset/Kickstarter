*&---------------------------------------------------------------------*
*& Report ZACO_UPDATE_SPAREPART
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zaco_update_sparepart.

TABLES eqst.

TYPES: BEGIN OF ltt_equnr,
         equnr TYPE equnr,
       END OF ltt_equnr.

DATA: lo_http_client    TYPE REF TO if_http_client.
DATA: lo_equipment      TYPE REF TO zaco_cl_equip_erp.
DATA: lo_equi_stue      TYPE REF TO zaco_cl_equip_erp_stueli.
DATA: lo_equi_stue_pos  TYPE REF TO zaco_cl_equip_erp_stueli_pos.
DATA: lo_material       TYPE REF TO zaco_cl_material.
DATA: lo_sparepart      TYPE REF TO zaco_cl_spareparts.

DATA: lt_equnr          TYPE STANDARD TABLE OF ltt_equnr.
DATA: lt_result         TYPE zaco_t_json_body.
*DATA: lt_parameters     TYPE zpsain_tt_name_value.
DATA: lt_position       TYPE zaco_tt_equi_stueli_pos.

DATA: ls_equnr          TYPE ltt_equnr.
DATA: ls_result         TYPE zaco_s_json_body.
DATA: ls_position       TYPE zaco_s_equi_stueli_pos.
DATA: ls_msg            TYPE bal_s_msg.

DATA: lv_ok             TYPE char1.
DATA: lv_matnr          TYPE matnr.
DATA: lv_werks          TYPE werks_d.
DATA: lv_transferred    TYPE char1.
DATA: lv_subrc          TYPE sy-subrc.
DATA: lv_loghndl        TYPE balloghndl.
DATA: lv_status         TYPE char1.

PARAMETERS: pmatnr      TYPE matnr.
PARAMETERS: pwerks      TYPE werks_d.
PARAMETERS: pbpname     TYPE zaco_de_bp_ain.
PARAMETERS: prfcdest    TYPE rfcdest.


START-OF-SELECTION.

  IF pmatnr NE space.
    CREATE OBJECT lo_material.
    CREATE OBJECT lo_sparepart.
    CALL METHOD lo_material->set_matnr
      EXPORTING
        iv_matnr = pmatnr
        iv_werks = pwerks.

    CALL METHOD lo_sparepart->update_sparepart
      EXPORTING
        io_material = lo_material
        iv_id       = 'BF2DC15698C0464DA85811BF0A7A5172'
        iv_rfcdest  = prfcdest
        iv_bp_name  = pbpname
      CHANGING
        ct_result   = lt_result.


    IF lv_status = space.
*-------------------------------------
*       Ausgabe LT_RESULT ist noch zu designen
*---------------------------------------
      WRITE:/'***************************************'.
      WRITE:/ pmatnr.
      WRITE:/'***************************************'.
      LOOP AT lt_result INTO ls_result.
        WRITE:/ ls_result-value.
      ENDLOOP.
      REFRESH lt_result.
    ENDIF. "
  ENDIF. " Keine Lagerposition mit Materialnummer
  FREE:lo_material.
  ULINE.
  WRITE:/ TEXT-013.
