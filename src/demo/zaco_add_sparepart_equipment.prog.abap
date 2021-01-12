*&---------------------------------------------------------------------*
*& Report  zaco_add_sparepart_equipment
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zaco_add_sparepart_equipment.
*&---------------------------------------------------------------------*
*& Beschreibung: Es sollen die Stücklisteninformationen der geladenen
*& Ewuipments nachgelaen werden.
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Ersteller: Diemer Bernhard
* Datum: 30.12.2020
* Projekt: CHAIN
*----------------------------------------------------------------------*
* Änderungsvermerk:
* Wer:          Wann:       Was:
*----------------------------------------------------------------------*

TABLES equi.

TYPES: BEGIN OF ltt_equnr,
         equnr TYPE equnr,
       END OF ltt_equnr.

DATA: lo_equipment        TYPE REF TO zaco_cl_equip_erp.
DATA: lo_equipment_stueli TYPE REF TO zaco_cl_equip_erp_stueli.
DATA: lo_sparepart_ain    TYPE REF TO zaco_cl_spareparts_management.
DATA: lo_equi_ain         TYPE REF TO zaco_cl_equipment_ain.
DATA: lo_http_client      TYPE REF TO if_http_client.

DATA: lt_equnr TYPE STANDARD TABLE OF ltt_equnr.
DATA: lt_result TYPE zaco_t_json_body.

DATA: ls_equnr TYPE ltt_equnr.
DATA: ls_result TYPE zaco_s_json_body.

DATA: lv_ok TYPE char1.
DATA: lv_transferred TYPE char1.
DATA: lv_equi_id TYPE string.
DATA: lv_sernr TYPE gernr.
DATA: lv_subrc TYPE sy-subrc.

SELECT-OPTIONS: sequnr FOR equi-equnr.
PARAMETERS: pwerks   TYPE werks_d.
PARAMETERS: pstlty   TYPE stlty.
PARAMETERS: pstlan   TYPE stlan.
PARAMETERS: pbpname  TYPE zaco_de_bp_ain.
PARAMETERS: prfcdest TYPE rfcdest.


START-OF-SELECTION.
*---- Alle Equipments im System
  SELECT equnr FROM equi INTO ls_equnr-equnr WHERE equnr IN sequnr
                                              AND  lvorm = space.
    APPEND ls_equnr TO lt_equnr.
  ENDSELECT.

END-OF-SELECTION.
  CREATE OBJECT lo_sparepart_ain.

*--- ermitlle equipments mit Stückliste
  LOOP AT lt_equnr INTO ls_equnr.
    lv_subrc = 0.
    CREATE OBJECT lo_equipment_stueli.
    CALL METHOD lo_equipment_stueli->lese_positionen
      EXPORTING
        iv_equnr              = ls_equnr-equnr
        iv_werks              = pwerks
        iv_stlty              = pstlty
        iv_stlan              = pstlan
      EXCEPTIONS
        alt_not_found         = 1
        call_invalid          = 2
        equipment_not_found   = 3
        missing_authorization = 4
        no_bom_found          = 5
        no_plant_data         = 6
        no_suitable_bom_found = 7
        other_error           = 8
        OTHERS                = 9.
    CASE sy-subrc.
      WHEN 1.
        WRITE:/ TEXT-001 , ls_equnr-equnr, TEXT-002.
        lv_subrc = 1.
      WHEN 2.
        WRITE:/ TEXT-001 , ls_equnr-equnr, TEXT-003.
        lv_subrc = 1.
      WHEN 3.
        WRITE:/ TEXT-001 , ls_equnr-equnr, TEXT-004.
        lv_subrc = 1.
      WHEN 4.
        WRITE:/ TEXT-001 , ls_equnr-equnr, TEXT-005.
        lv_subrc = 1.
      WHEN 5.
        WRITE:/ TEXT-001 , ls_equnr-equnr, TEXT-006.
        lv_subrc = 1.
      WHEN 6.
        WRITE:/ TEXT-001 , ls_equnr-equnr, TEXT-007.
        lv_subrc = 1.
      WHEN 7.
        WRITE:/ TEXT-001 , ls_equnr-equnr, TEXT-008.
        lv_subrc = 1.
      WHEN 8.
        WRITE:/ TEXT-001 , ls_equnr-equnr, TEXT-009.
        lv_subrc = 1.
      WHEN 9.
        WRITE:/ TEXT-001 , ls_equnr-equnr, TEXT-009.
        lv_subrc = 1.
    ENDCASE.
    IF lv_subrc = 0.
*------------ Equipment daten nachlesen
      CREATE OBJECT lo_equipment.
      CALL METHOD lo_equipment->lese_equipment
        EXPORTING
          iv_equnr = ls_equnr-equnr
        CHANGING
          cv_ok    = lv_ok.

      IF lv_ok = 'X'.
*--------- HTTP Verbbindung aufbauen
        CALL METHOD zaco_cl_connection_ain=>connect_to_ain
          EXPORTING
            iv_rfcdest               = prfcdest
          CHANGING
            co_http_client           = lo_http_client
          EXCEPTIONS
            dest_not_found           = 1
            destination_no_authority = 2
            OTHERS                   = 3.
        IF sy-subrc <> 0.
          WRITE:/ TEXT-010.
        ENDIF.
*--------- AIn Objekt erstellen
        CREATE OBJECT lo_equi_ain
          EXPORTING
            co_http_client = lo_http_client.
*----------- prüfen ob Equipment bereits existiert
        CALL METHOD lo_equipment->get_sernr
          CHANGING
            cv_sernr = lv_sernr.

        CALL METHOD lo_equi_ain->equipment_already_transferred
          EXPORTING
            iv_sernr        = lv_sernr
            iv_rfcdest      = prfcdest
          CHANGING
            cv_transferred  = lv_transferred
            cv_equipment_id = lv_equi_id.
        IF lv_transferred = 'X'.
*------ Übertrage Equipment an AIN
          CALL METHOD lo_sparepart_ain->handle_sparepart_of_equipment
            EXPORTING
              iv_asigneeid    = lv_equi_id
              iv_action       = 'add'
              io_equip_stueli = lo_equipment_stueli
              iv_equnr        = ls_equnr-equnr
              iv_rfcdest      = prfcdest
              iv_bp_name      = pbpname
            CHANGING
              ct_return       = lt_result
              co_http_client  = lo_http_client.

          IF lv_subrc = 0.
*-------------------------------------
*       Ausgabe LT_RESULT ist noch zu designen
*---------------------------------------
            DESCRIBE TABLE lt_result LINES sy-tfill.
            IF sy-tfill > 0.
              WRITE:/'***************************************'.
              WRITE:/ ls_equnr-equnr.
              WRITE:/'***************************************'.
              LOOP AT lt_result INTO ls_result.
                WRITE:/ ls_result-value.
              ENDLOOP.
            ENDIF. " result
          ENDIF. "Equipment bereits übertragen
          FREE: lo_equi_ain.
          CALL METHOD lo_http_client->close( ).
        ENDIF. "equipment erflgreich angelegt
      ENDIF. "Equipment erfolgreih gelesen
      FREE: lo_equipment, lo_equipment_stueli, lo_http_client.
    ENDIF. "Stückliste vorhanden
  ENDLOOP.   "Equipments
  ULINE.
  WRITE:/ TEXT-013.
