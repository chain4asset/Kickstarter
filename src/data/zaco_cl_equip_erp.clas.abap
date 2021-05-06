class ZACO_CL_EQUIP_ERP definition
  public
  create public .

public section.

  methods LESE_EQUIPMENT
    importing
      !IV_EQUNR type EQUNR
      !IV_SPRAS type SPRAS optional
    changing
      !CV_OK type CHAR1 optional .
  methods GET_EQUNR
    changing
      !CV_EQUNR type EQUNR .
  methods SET_EQUNR
    importing
      !IV_EQUNR type EQUNR .
  methods GET_KDAUF
    changing
      !CV_KDAUF type KDAUF
      !CV_KDPOS type KDPOS .
  methods SET_KDAUF
    importing
      !IV_KDAUF type KDAUF
      !IV_KDPOS type KDPOS .
  methods GET_LVORM
    changing
      !CV_LVORM type LVORM .
  methods SET_LVORM
    importing
      !IV_LVORM type LVORM .
  methods GET_MATNR
    changing
      !CV_MATNR type MATNR .
  methods SET_MATNR
    importing
      !IV_MATNR type MATNR .
  methods GET_SERNR
    changing
      !CV_SERNR type GERNR .
  methods SET_SERNR
    importing
      !IV_SERNR type GERNR .
  methods GET_SHTXT
    changing
      !CV_SHTXT type KTX01 .
  methods SET_SHTXT
    importing
      !IV_SHTXT type KTX01 .
  methods GET_SUBMT
    changing
      !CV_SUBMT type SUBMT .
  methods SET_SUBMT
    importing
      !IV_SUBMT type SUBMT .
  methods SET_TYPBZ
    importing
      !IV_TYPBZ type TYPBZ .
  methods GET_TYPBZ
    changing
      !IC_TYPBZ type TYPBZ .
  methods SET_WERK
    importing
      !IV_WERK type WERKS_D .
  methods GET_WERK
    changing
      !IC_WERK type WERKS_D .
  methods SET_HERSTTEILNR
    importing
      !IV_MAPAR type MAPAR .
  methods GET_HERSTTEILNR
    changing
      !CV_MAPAR type MAPAR .
  methods SET_HERLD
    importing
      !IV_HERLD type HERLD .
  methods GET_HERLD
    changing
      !IC_HERLD type HERLD .
  methods SET_BAUJJ
    importing
      !IV_BAUJJ type BAUJJ .
  methods SET_BAUMM
    importing
      !IV_BAUMM type BAUMM .
  methods GET_BAUJJ
    changing
      !IC_BAUJJ type BAUJJ .
  methods GET_BAUMM
    changing
      !IC_BAUMM type BAUMM .
  methods GET_TPLNR
    changing
      !CV_TPLNR type TPLNR .
  methods SET_TPLNR
    importing
      !IV_TPLNR type TPLNR .
  methods GET_INVNR
    changing
      !CV_INVNR type INVNR .
  methods SET_INVNR
    importing
      !IV_INVNR type INVNR .
  methods SET_AUFNR
    importing
      !IV_AUFNR type AUFNR .
  methods GET_AUFNR
    changing
      !CV_AUFNR type AUFNR .
  methods SET_PPOSNR
    importing
      !IV_PPOSNR type CO_POSNR .
  methods GET_PPOSNR
    changing
      !CV_PPOSNR type CO_POSNR .
  methods GET_KMATN
    changing
      !CV_KMATN type KMATN .
  methods SET_KMATN
    importing
      !IV_KMATN type KMATN .
  methods GET_KUNNR
    changing
      !CV_KUNNR type KUNNR .
  methods GET_LANGTEXT
    changing
      !CT_LANGTEXT type ZCHAIN_TT_LANGTEXT .
  methods SET_LANGTEXT
    importing
      !IV_EQUNR type EQUNR
      !IV_SPRAS type SPRAS .
protected section.
private section.

  data GV_EQUNR type EQUNR .
  data GV_LVORM type LVORM .
  data GV_SUBMT type SUBMT .
  data GV_MATNR type MATNR .
  data GV_SERNR type GERNR .
  data GV_KDAUF type KDAUF .
  data GV_KDPOS type KDPOS .
  data GV_SHTXT type KTX01 .
  data GV_TYPBZ type TYPBZ .
  data GV_WERK type WERKS_D .
  data GV_MAPAR type MAPAR .
  data GV_HERLD type HERLD .
  data GV_BAUJJ type BAUJJ .
  data GV_BAUMM type BAUMM .
  data GV_TPLNR type TPLNR .
  data GV_INVNR type INVNR .
  data GV_PAUFNR type AUFNR .
  data GV_PPOSNR type CO_POSNR .
  data GV_KMATN type KMATN .
  data GT_LINE_T type TLINE_T .
  data GT_LANGTEXT type ZCHAIN_TT_LANGTEXT .
ENDCLASS.



CLASS ZACO_CL_EQUIP_ERP IMPLEMENTATION.


METHOD GET_AUFNR.

  cv_aufnr = gv_paufnr.

ENDMETHOD.


method GET_BAUJJ.

  ic_baujj = gv_baujj.

endmethod.


method GET_BAUMM.

  ic_baumm = gv_baumm.

endmethod.


method GET_EQUNR.

  cv_equnr = gv_equnr.

endmethod.


method GET_HERLD.

  ic_herld = gv_herld.

endmethod.


method GET_HERSTTEILNR.

  cv_mapar = gv_mapar.

endmethod.


METHOD GET_INVNR.

  cv_invnr = gv_invnr.

ENDMETHOD.


method GET_KDAUF.

  cv_kdauf = gv_kdauf.
  cv_kdpos = gv_kdpos.

endmethod.


method GET_KMATN.

  cv_kmatn = gv_kmatn.

endmethod.


METHOD GET_KUNNR.

  CALL FUNCTION 'CONVERSION_EXIT_TPLNR_OUTPUT'
    EXPORTING
      input  = gv_tplnr
    IMPORTING
      output = cv_kunnr.


ENDMETHOD.


  method GET_LANGTEXT.

    ct_langtext = gt_langtext.

  endmethod.


method GET_LVORM.

  cv_lvorm = gv_lvorm.

endmethod.


method GET_MATNR.

  cv_matnr = gv_matnr.

endmethod.


METHOD GET_PPOSNR.

  cv_pposnr = gv_pposnr.

ENDMETHOD.


METHOD get_sernr.

  cv_sernr = gv_sernr.
  IF cv_sernr(1) = 'X' AND cv_sernr+1(1) = '4'.
    cv_sernr(1) = 'D'.
  ENDIF.
  IF cv_sernr(1) = 'X'.
    SHIFT cv_sernr LEFT DELETING LEADING 'X'.
  ENDIF.
  SHIFT cv_sernr LEFT DELETING LEADING '0'.
ENDMETHOD.


method GET_SHTXT.

  cv_shtxt = gv_shtxt.

endmethod.


method GET_SUBMT.

  cv_submt = gv_submt.

endmethod.


method GET_TPLNR.

  cv_tplnr = gv_tplnr.

endmethod.


method GET_TYPBZ.

  ic_typbz = gv_typbz.

endmethod.


method GET_WERK.

  ic_werk = gv_werk.

endmethod.


METHOD lese_equipment.
*---------------------------------------------------------------------------*
*
*    Copyright (C) 2019 NETZSCH Pumps and Systems GmbH
*
*    This program is free software: you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation, either version 3 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*
*    NETZSCH Pumpen & Systeme GmbH
*    Geretsrieder Straße 1
*    84478 Waldkraiburg
*    Germany
*
*    aconn@nedgex.com
*
*---------------------------------------------------------------------------*

  DATA: ls_equi TYPE equi.
  DATA: ls_eqbs TYPE eqbs.

  DATA: lv_eqktx      TYPE ktx01.
  DATA: lv_obknr      TYPE objknr.
  DATA: lv_vbeln      TYPE vbeln.
  DATA: lv_posnr      TYPE posnr.
  DATA: lv_kdauf      TYPE kdauf.
  DATA: lv_kdpos      TYPE kdpos.
  DATA: lv_mapar      TYPE mapar.
  DATA: lv_paufnr     TYPE aufnr.
  DATA: lv_pposnr     TYPE co_posnr.
  DATA: lv_projn      TYPE ps_psp_ele.
  DATA: lv_projn_ext  TYPE char40.
  DATA: lv_iloan      TYPE iloan.
  DATA: lv_tplnr      TYPE tplnr.
  DATA: lv_kunnr      TYPE kunnr.
  DATA: lv_fallb      TYPE spras.

  SELECT SINGLE * FROM equi INTO ls_equi WHERE equnr = iv_equnr.
  IF sy-subrc <> 0.
    cv_ok = space.
  ELSE.
    CALL METHOD me->set_equnr
      EXPORTING
        iv_equnr = iv_equnr.

    CALL METHOD me->set_lvorm
      EXPORTING
        iv_lvorm = ls_equi-lvorm.

    CALL METHOD me->set_matnr
      EXPORTING
        iv_matnr = ls_equi-matnr.

    CALL METHOD me->set_werk
      EXPORTING
        iv_werk = ls_equi-werk.

*    CALL METHOD me->SET_SUBMT
*      EXPORTING
*        IV_SUBMT = ls_equi-submt.

    CALL METHOD me->set_sernr
      EXPORTING
        iv_sernr = ls_equi-sernr.

    CALL METHOD me->set_baujj
      EXPORTING
        iv_baujj = ls_equi-baujj.

    CALL METHOD me->set_baumm
      EXPORTING
        iv_baumm = ls_equi-baumm.

    CALL METHOD me->set_herld
      EXPORTING
        iv_herld = ls_equi-herld.

    CALL METHOD me->set_invnr
      EXPORTING
        iv_invnr = ls_equi-invnr.

    CALL METHOD me->set_kmatn
      EXPORTING
        iv_kmatn = ls_equi-kmatn.

    IF iv_spras = space.
      lv_fallb = sy-langu.
      SELECT SINGLE eqktx FROM eqkt INTO lv_eqktx WHERE equnr = ls_equi-equnr
                                                   AND  spras = sy-langu.
      IF sy-subrc <> 0.    "Fallback Sprache Englisch
        SELECT SINGLE eqktx FROM eqkt INTO lv_eqktx WHERE equnr = ls_equi-equnr
                                                     AND  spras = 'E'.
        lv_fallb = 'E'.
      ENDIF.
    ELSE.
      lv_fallb = iv_spras.
      SELECT SINGLE eqktx FROM eqkt INTO lv_eqktx WHERE equnr = ls_equi-equnr
                                                   AND  spras = iv_spras.
      IF sy-subrc <> 0.    "Fallback Sprache Englisch
        SELECT SINGLE eqktx FROM eqkt INTO lv_eqktx WHERE equnr = ls_equi-equnr
                                                     AND  spras = 'E'.
        lv_fallb = 'E'.
      ENDIF.

    ENDIF.
    CALL METHOD me->set_shtxt
      EXPORTING
        iv_shtxt = lv_eqktx.
*------------------------ Langtext lesen
    CALL METHOD me->set_langtext
      EXPORTING
        iv_equnr = ls_equi-equnr
        iv_spras = lv_fallb.                "gleiche Sprache wie Kurztext

    CALL METHOD me->set_typbz
      EXPORTING
        iv_typbz = ls_equi-typbz.

*    IF ls_equi-equnr(1) = 'X'.
    SELECT SINGLE mapar iloan FROM equz INTO (lv_mapar, lv_iloan) WHERE equnr = ls_equi-equnr
                                                                   AND  datbi >= sy-datum.
    IF sy-subrc = 0.
      CALL METHOD me->set_herstteilnr
        EXPORTING
          iv_mapar = lv_mapar.

      SELECT SINGLE tplnr FROM iloa INTO lv_tplnr WHERE iloan = lv_iloan.
      IF sy-subrc = 0.
        CALL METHOD me->set_tplnr
          EXPORTING
            iv_tplnr = lv_tplnr.
      ENDIF.
    ENDIF.

*    ENDIF.
    SELECT SINGLE * FROM eqbs INTO ls_eqbs WHERE equnr = iv_equnr.
    IF sy-subrc = 0 AND ls_eqbs-kdauf NE space.
      CALL METHOD me->set_kdauf
        EXPORTING
          iv_kdauf = ls_eqbs-kdauf
          iv_kdpos = ls_eqbs-kdpos.
      cv_ok = 'X'.
    ELSE.
      SELECT SINGLE obknr FROM objk INTO lv_obknr WHERE equnr = iv_equnr
                                                   AND  taser = 'SER02'.
      IF sy-subrc = 0.
        SELECT SINGLE sdaufnr posnr FROM ser02 INTO (lv_vbeln, lv_posnr) WHERE obknr = lv_obknr.
        IF sy-subrc  = 0.
          CALL METHOD me->set_kdauf
            EXPORTING
              iv_kdauf = lv_vbeln
              iv_kdpos = lv_posnr.
        ENDIF.
      ELSE.   "Projektauftrag ?
        SELECT SINGLE obknr FROM objk INTO lv_obknr WHERE equnr = iv_equnr
                                                     AND  taser = 'SER05'.
        IF sy-subrc = 0.
          SELECT SINGLE ppaufnr ppposnr FROM ser05 INTO (lv_paufnr, lv_pposnr) WHERE obknr = lv_obknr.
          IF sy-subrc  = 0.
            CALL METHOD me->set_aufnr
              EXPORTING
                iv_aufnr = lv_paufnr.

            CALL METHOD me->set_pposnr
              EXPORTING
                iv_pposnr = lv_pposnr.

            SELECT SINGLE projn FROM afpo INTO lv_projn WHERE aufnr = lv_paufnr
                                                         AND  posnr = lv_pposnr.
            IF sy-subrc = 0.
              IF lv_projn NE space.
                CALL FUNCTION 'CONVERSION_EXIT_ABPSP_OUTPUT'
                  EXPORTING
                    input  = lv_projn
                  IMPORTING
                    output = lv_projn_ext.
                REPLACE FIRST OCCURRENCE OF '-' IN lv_projn_ext WITH ''.
                lv_vbeln = lv_projn_ext(8).
                CONCATENATE '00' lv_vbeln INTO lv_vbeln.
                lv_posnr+2(4) = lv_projn_ext+14(4).
                CALL METHOD me->set_kdauf
                  EXPORTING
                    iv_kdauf = lv_vbeln
                    iv_kdpos = lv_posnr.
              ELSE.
*----------------- Kundenauftragsbezug über Fertigungsauftrag
                SELECT SINGLE kdauf kdpos INTO (lv_kdauf, lv_kdpos) FROM aufk WHERE aufnr = lv_paufnr.
                IF sy-subrc = 0.
                  CALL METHOD me->set_kdauf
                    EXPORTING
                      iv_kdauf = lv_kdauf
                      iv_kdpos = lv_kdpos.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    SELECT SINGLE obknr FROM objk INTO lv_obknr WHERE equnr = iv_equnr
                                           AND  taser = 'SER05'.
    IF sy-subrc = 0.
      SELECT SINGLE ppaufnr ppposnr FROM ser05 INTO (lv_paufnr, lv_pposnr) WHERE obknr = lv_obknr.
      IF sy-subrc  = 0.
        CALL METHOD me->set_aufnr
          EXPORTING
            iv_aufnr = lv_paufnr.

        CALL METHOD me->set_pposnr
          EXPORTING
            iv_pposnr = lv_pposnr.
      ENDIF.
    ENDIF.
    cv_ok = 'X'.

  ENDIF.

ENDMETHOD.


METHOD SET_AUFNR.

  gv_paufnr = iv_aufnr.

ENDMETHOD.


METHOD SET_BAUJJ.

  gv_baujj = iv_baujj.

ENDMETHOD.


method SET_BAUMM.

  gv_baumm = iv_baumm.

endmethod.


method SET_EQUNR.

  gv_equnr = iv_equnr.

endmethod.


METHOD SET_HERLD.

  gv_herld = iv_herld.

ENDMETHOD.


method SET_HERSTTEILNR.

    gv_MAPAR = iv_MAPAR.

endmethod.


METHOD SET_INVNR.

  gv_invnr = iv_invnr.
ENDMETHOD.


method SET_KDAUF.

  gv_kdauf = iv_kdauf.
  gv_kdpos = iv_kdpos.

endmethod.


METHOD SET_KMATN.

  gv_kmatn = iv_kmatn.

ENDMETHOD.


  METHOD set_langtext.

    DATA: lt_line_t TYPE tline_t.

    data: ls_langtext type ZCHAIN_S_LANGTEXT.

    DATA: lv_tdname TYPE thead-tdname.

    lv_tdname = iv_equnr.

    CALL METHOD zaco_cl_text_read=>read_text
      EXPORTING
        iv_tdobject = 'EQUI'
        iv_tdname   = lv_tdname
        iv_tdid     = 'LTXT'
        iv_tdspras  = iv_spras
      RECEIVING
        ct_tline    = lt_line_t.

    ls_langtext-spras = iv_spras.
    ls_langtext-LANGTEXTE[] = lt_line_t.
    append ls_langtext to gt_langtext.

  ENDMETHOD.


method SET_LVORM.

  gv_lvorm = iv_lvorm.

endmethod.


method SET_MATNR.

  gv_matnr = iv_matnr.

endmethod.


METHOD SET_PPOSNR.

  gv_pposnr = iv_pposnr.

ENDMETHOD.


method SET_SERNR.

  gv_sernr = iv_sernr.

endmethod.


method SET_SHTXT.

  gv_shtxt = iv_shtxt.

endmethod.


method SET_SUBMT.

  gv_submt = iv_submt.

endmethod.


method SET_TPLNR.

  gv_tplnr = iv_tplnr.

endmethod.


method SET_TYPBZ.

  gv_typbz = iv_typbz.

endmethod.


method SET_WERK.

  if iv_werk = space.
    if gv_equnr(1) = 'D'.
      gv_werk = '0002'.
    endif.
  else.
    gv_werk = iv_werk.
  endif.

endmethod.
ENDCLASS.
