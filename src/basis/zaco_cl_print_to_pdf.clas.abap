class ZACO_CL_PRINT_TO_PDF definition
  public
  create public .

public section.

  class-methods PRINT_SPAEPART_TO_PDF
    importing
      !IV_SPRAS type LANGU
      !IV_REPLANGU1 type TDSPRAS optional
      !IV_REPLANGU2 type TDSPRAS optional
      !IV_REPLANGU3 type TDSPRAS optional
      !IV_FORMULARNAME type TDSFNAME
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP
      !IO_EQUIPMENT_STUELI type ref to ZACO_CL_EQUIP_ERP_STUELI
    changing
      !CV_PDF_BIN type XSTRING
    exceptions
      ERR_MAX_LINEWIDTH
      ERR_FORMAT
      ERR_CONV_NOT_POSSIBLE
      ERR_BAD_OTF
      UNDEF_ERROR .
protected section.
private section.
ENDCLASS.



CLASS ZACO_CL_PRINT_TO_PDF IMPLEMENTATION.


  METHOD PRINT_SPAEPART_TO_PDF.

*    DATA: lt_pdf TYPE tline_tab.
*
*    DATA: lv_fm_name              TYPE          rs38l_fnam,
*          ls_output_options       TYPE          ssfcompop,
*          ls_control_parameters   TYPE          ssfctrlop,
*          ls_document_output_info TYPE          ssfcrespd,
*          ls_job_output_info      TYPE          ssfcrescl,
*          ls_job_output_options   TYPE          ssfcresop.
*    DATA: ls_equip TYPE zpsain_bwa_s_ersatz_objekte.
*
*
*    DATA: lv_spoolid       TYPE rspoid,
*          lv_user_settings TYPE          tdbool.
*    DATA: lv_count TYPE i.
*
*
*    ls_equip-equip ?= io_equipment.
*    ls_equip-equip_stueli ?= io_equipment_stueli.
** Lese Funktionsbausteinname zu Smartforms
*    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*      EXPORTING
*        formname           = iv_formularname
*      IMPORTING
*        fm_name            = lv_fm_name
*      EXCEPTIONS
*        no_form            = 1
*        no_function_module = 2
*        OTHERS             = 3.
*
*    IF sy-subrc <> 0.
*      MESSAGE TEXT-001 TYPE 'E'.
**    MESSAGE 'Fehler beim Generieren des Funktionsbausteinnamens' TYPE 'E'.
*    ELSE.
*      lv_user_settings = ''.
*
**   Ausgabeoptionen setzen
*      ls_output_options-tddest   = 'ZPDB'.            " 'LOCL'.  "Druckerausgabegerät
*      ls_output_options-tdcopies = ''.  "Anzahl Druckexemplare
*
**   Kontrollparameter setzen
*      ls_control_parameters-no_open   = ''.   "Steuerfeld um mehrere Spoolaufträge zusammenzufassen
*      ls_control_parameters-no_close  = ''.   "Steuerfeld um mehrere Spoolaufträge zusammenzufassen
*      ls_control_parameters-device    = ''.   "Art des Ausgabegerätes (PRINTER, TELEFAX, MAIL)
*      ls_control_parameters-no_dialog = 'X'.  "Spooldialogbildschirm
*      ls_control_parameters-preview   = ''.   "Vorschau
*      ls_control_parameters-getotf    = 'X'.  "Kein Druck, dafür Rückgabe von OTF Daten
*      ls_control_parameters-langu     = iv_spras.  "Sprachenschlüssel
*      ls_control_parameters-replangu1 = iv_replangu1.  "Sprachenschlüssel
*      ls_control_parameters-replangu2 = iv_replangu2.  "Sprachenschlüssel
*      ls_control_parameters-replangu3 = iv_replangu3.  "Sprachenschlüssel
*      ls_control_parameters-startpage = ''.   "Kurzbezeichnung der Startseite (Default: oberste Seite
*      "im Smartforms Form Builder
*    ENDIF.
*
*    CALL FUNCTION lv_fm_name
*      EXPORTING
*        control_parameters   = ls_control_parameters
*        output_options       = ls_output_options
*        user_settings        = lv_user_settings
*        is_equip             = ls_equip
*        iv_spras             = iv_spras
*      IMPORTING
*        document_output_info = ls_document_output_info
*        job_output_info      = ls_job_output_info
*        job_output_options   = ls_job_output_options
*      EXCEPTIONS
*        formatting_error     = 1
*        internal_error       = 2
*        send_error           = 3
*        user_canceled        = 4
*        OTHERS               = 5.
*    IF sy-subrc EQ 0.
*
*      CALL FUNCTION 'CONVERT_OTF'
*        EXPORTING
*          format                = 'PDF'
*        IMPORTING
*          bin_filesize          = lv_count
*          bin_file              = cv_pdf_bin
*        TABLES
*          otf                   = ls_job_output_info-otfdata
*          lines                 = lt_pdf
*        EXCEPTIONS
*          err_max_linewidth     = 1
*          err_format            = 2
*          err_conv_not_possible = 3
*          err_bad_otf           = 4
*          OTHERS                = 5.
*      CASE sy-subrc.
*        WHEN 1.
*          RAISE err_max_linewidth.
*        WHEN 2.
*          RAISE err_format.
*        WHEN 3.
*          RAISE err_conv_not_possible.
*        WHEN 4.
*          RAISE err_bad_otf.
*        WHEN 5.
*          RAISE undef_error.
*      ENDCASE.
*    ENDIF.


  ENDMETHOD.
ENDCLASS.
