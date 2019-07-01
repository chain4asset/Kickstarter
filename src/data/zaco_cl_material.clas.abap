class ZACO_CL_MATERIAL definition
  public
  create public .

public section.

  methods GET_MATNR
    changing
      !CV_MATNR type MATNR .
  methods GET_KTXT
    returning
      value(CV_MAKTX) type MAKTX .
  methods GET_WBZ
    returning
      value(CV_WZEIT) type WZEIT .
  methods GET_DISPOMERKMAL
    returning
      value(CV_DISMM) type DISMM .
  methods SET_MATNR
    importing
      !IV_MATNR type MATNR
      !IV_WERKS type WERKS_D .
  methods SET_WERKS
    importing
      !IV_WERKS type WERKS_D .
  methods GET_WERKS
    changing
      !CV_WERKS type WERKS_D .
  methods SET_NORMT
    importing
      !IV_NORMT type NORMT .
  methods SET_WRKST
    importing
      !IV_WRKST type WRKST .
  methods SET_BAUGRUPPE
    importing
      !IV_SOBSL type SOBSL .
  methods GET_NORMT
    changing
      !CV_NORMT type NORMT .
  methods GET_WRKST
    changing
      !CV_WRKST type WRKST .
  methods GET_BAUGRUPPE
    changing
      !CV_BAUGRUPPE type ZPSPP_DE_BAUGRUPPE .
  methods ERMITTLE_WZEIT .
  methods SET_RUEZT
    importing
      !IV_RUEZT type RUEZT .
  methods SET_BEARZ
    importing
      !IV_BEARZ type BEARZ .
  methods SET_TRANZ
    importing
      !IV_TRANZ type TRANZ .
  methods GET_RUEZT
    changing
      !CV_RUEZT type RUEZT .
  methods GET_BEARZ
    changing
      !CV_BEARZ type BEARZ .
  methods GET_TRANZ
    changing
      !CV_TRANZ type TRANZ .
  methods SET_BESKZ
    importing
      !IV_BESKZ type BESKZ .
  methods GET_BESKZ
    changing
      !CV_BESKZ type BESKZ .
  methods SET_PLIFZ
    importing
      !IV_PLIFZ type PLIFZ .
  methods GET_PLIFZ
    changing
      !CV_PLIFZ type PLIFZ .
  methods SET_MSTAE
    importing
      !IV_MSTAE type MSTAE .
  methods GET_MSTAE
    changing
      !CV_MSTAE type MSTAE .
  methods SET_GROES
    importing
      !IV_GROES type GROES .
  methods GET_GROES
    changing
      !CV_GROES type GROES .
  methods SET_MMSTA
    importing
      !IV_MMSTA type MMSTA .
  methods GET_MMSTA
    changing
      !CV_MMSTA type MMSTA .
  methods GET_MVER
    changing
      !CT_MVER type ZPSPP_TT_MVER .
  methods SET_VOLUM
    importing
      !IV_VOLUM type MARA-VOLUM .
  methods GET_VOLUM
    changing
      value(CV_VOLUM) type MARA-VOLUM .
  methods SET_VOLEH
    importing
      !IV_VOLEH type VOLEH .
  methods GET_VOLEH
    changing
      !CV_VOLEH type VOLEH .
  methods GET_MFRPN
    changing
      !CV_MFRPN type MFRPN .
  methods SET_MFRPN
    importing
      !IV_MFRPN type MFRPN .
  methods GET_MARM
    changing
      value(CT_MARM) type MARM_TAB .
  methods GET_MARM_FOR_UNIT
    importing
      !IV_MEINH type MEINH
    changing
      value(CS_MARM) type MARM
    exceptions
      NOT_FOUND .
  methods SET_MEINS
    importing
      !IV_MEINS type MEINS .
  methods GET_MEINS
    changing
      !CV_MEINS type MEINS .
  methods SET_KTXT
    importing
      !IV_MAKTX type MAKTX .
  methods SET_WBZ
    importing
      !IV_WZEIT type WZEIT .
  methods SET_DISPOMERKMAL
    importing
      !IV_DISMM type DISMM .
  methods SET_NTGEW
    importing
      !IV_NTGEW type NTGEW .
  methods GET_NETGW
    changing
      !CV_NTGEW type NTGEW .
  methods GET_BRGEW
    changing
      !CV_BRGEW type BRGEW .
  methods SET_BRGEW
    importing
      !IV_BRGEW type BRGEW .
  methods GET_GEWEI
    changing
      !CV_GEWEI type GEWEI .
  methods SET_GEWEI
    importing
      !IV_GEWEI type GEWEI .
  methods SET_GRUTXT
    importing
      !IT_GRUTXT type TLINETAB .
  methods GET_GRUTXT
    changing
      value(CT_GRUTXT) type TLINETAB .
  methods LESE_MARM
    importing
      !IV_MATNR type MATNR .
  methods SET_LAENG
    importing
      !IV_LAENG type LAENG .
  methods SET_BREIT
    importing
      !IV_BREIT type BREIT .
  methods SET_HOEHE
    importing
      !IV_HOEHE type HOEHE .
  methods SET_MEABM
    importing
      !IV_MEABM type MEABM .
  methods GET_LAENG
    changing
      !CV_LAENG type LAENG .
  methods GET_BREIT
    changing
      !CV_BREIT type BREIT .
  methods GET_HOEHE
    changing
      !CV_HOEHE type HOEHE .
  methods GET_MEABM
    changing
      !CV_MEABM type MEABM .
  methods SET_EKGRP
    importing
      !IV_EKGRP type EKGRP .
  methods GET_EKGRP
    changing
      !CV_EKGRP type EKGRP .
  methods SET_LGRAD
    importing
      !IV_LGRAD type LGRAD .
  methods GET_LGRAD
    changing
      !CV_LGRAD type LGRAD .
  methods SET_EISBE
    importing
      !IV_EISBE type EISBE .
  methods GET_EISBE
    changing
      !CV_EISBE type EISBE .
  methods SET_DISPO
    importing
      !IV_DISPO type DISPO .
  methods GET_DISPO
    changing
      !CV_DISPO type DISPO .
  methods SET_LBKUM
    importing
      !IV_LBKUM type LBKUM .
  methods GET_LBKUM
    changing
      !CV_LBKUM type LBKUM .
  methods SET_SALK3
    importing
      !IV_SALK3 type SALK3 .
  methods GET_SALK3
    changing
      !CV_SALK3 type SALK3 .
  methods SET_STPRS
    importing
      !IV_STPRS type STPRS .
  methods GET_STPRS
    changing
      !CV_STPRS type STPRS .
  methods SET_VERPR
    importing
      !IV_VERPR type VERPR .
  methods GET_VERPR
    changing
      !CV_VERPR type VERPR .
  methods SET_PEINH
    importing
      !IV_PEINH type PEINH .
  methods GET_PEINH
    changing
      !CV_PEINH type PEINH .
  methods SET_PRDHA
    importing
      !IV_PRDHA type PRODH_D .
  methods GET_PRDHA
    changing
      !CV_PRDHA type PRODH_D .
  methods SET_MATKL
    importing
      !IV_MATKL type MATKL .
  methods GET_MATKL
    changing
      !CV_MATKL type MATKL .
  methods SET_WBZ_STD
    importing
      !IV_WBZ type ZPSPP_DE_WBZ .
  methods GET_WBZ_STD
    changing
      !CV_WZEIT type WZEIT .
  methods SET_WEBAZ
    importing
      !IV_WEBAZ type WEBAZ .
  methods GET_WEBAZ
    changing
      !CV_WEBAZ type WEBAZ .
  methods SET_FHORI
    importing
      !IV_FHORI type FHORI .
  methods GET_FHORI
    changing
      !CV_FHORI type FHORI .
  methods GET_VORGZ
    changing
      !CV_VORGZ type VORGZ .
  methods SET_LABST
    importing
      !IV_LABST type LABST .
  methods GET_LABST
    changing
      !CV_LABST type LABST .
  methods SET_MAKT
    importing
      !IT_MAKT type MAKT_TAB .
  methods GET_MAKT
    changing
      !CT_MAKT type MAKT_TAB .
  protected section.
private section.

  data GV_LABST type LABST .
  data GV_MATNR type MATNR .
  data GV_MAKTX type MAKTX .
  data GV_RUEZT type RUEZT .
  data GV_TRANZ type TRANZ .
  data GV_BEARZ type BEARZ .
  data GV_DISMM type DISMM .
  data GV_WZEIT type WZEIT .
  data GV_WERKS type WERKS_D .
  data GV_NORMT type NORMT .
  data GV_WRKST type WRKST .
  data GV_BAUGRUPPE type ZACO_DE_BAUGRUPPE .
  data GV_BESKZ type BESKZ .
  data GV_PLIFZ type PLIFZ .
  data GV_MSTAE type MSTAE .
  data GV_GROES type GROES .
  data GV_MMSTA type MMSTA .
  data GT_MVER type ZACO_TT_MVER .
  data GV_VOLUM type MARA-VOLUM .
  data GV_VOLEH type MARA-VOLEH .
  data GV_MFRPN type MARA-MFRPN .
  data GT_MARM type MARM_TAB .
  data GV_MEINS type MARA-MEINS .
  data GV_GEWEI type GEWEI .
  data GV_BRGEW type BRGEW .
  data GV_NTGEW type NTGEW .
  data GT_GRUTXT type TLINETAB .
  data GV_LAENG type LAENG .
  data GV_BREIT type BREIT .
  data GV_MEABM type MEABM .
  data GV_HOEHE type HOEHE .
  data GV_EKGRP type EKGRP .
  data GV_LGRAD type LGRAD .
  data GV_EISBE type EISBE .
  data GV_DISPO type DISPO .
  data GV_LBKUM type LBKUM .
  data GV_SALK3 type SALK3 .
  data GV_STPRS type STPRS .
  data GV_VERPR type VERPR .
  data GV_PEINH type PEINH .
  data GV_PRDHA type PRODH_D .
  data GV_WBZ type ZACO_DE_WBZ .
  data GV_MATKL type MATKL .
  data GV_WEBAZ type WEBAZ .
  data GV_WZEIT_LANG type WZEIT .
  data GV_FHORI type FHORI .
  data GV_VORGZ type VORGZ .
  data GT_MAKT type MAKT_TAB .

  methods LESE_MATERIAL
    importing
      !IV_MATNR type MATNR
      !IV_WERKS type WERKS_D .
  methods COLLECT_LABST
    importing
      !IV_MATNR type MATNR
      !IV_WERKS type WERKS_D
    returning
      value(CV_LABST) type LABST .
ENDCLASS.



CLASS ZACO_CL_MATERIAL IMPLEMENTATION.


  METHOD COLLECT_LABST.

    DATA: lt_mard TYPE /cwm/tt_mard.

    DATA: ls_mard TYPE mard.

    CALL FUNCTION '/CWM/MDMB_MARD'
      EXPORTING
        i_matnr          = iv_matnr
        i_werks          = iv_werks
*       I_LGORT          =
*       IT_MARD_KEYS     =
*       I_FILL_PQ_BUFFER = 'X'
*       I_FILL_MCHB_RESULT       = ' '
      IMPORTING
*       E_MARD           =
        et_mard          = lt_mard
*       E_MARD_PQ        =
*       ET_MARD_PQ       =
*       E_DBCNT          =
*     TABLES
*       IR_MATNR         =
*       IR_WERKS         =
*       IR_LGORT         =
      EXCEPTIONS
        no_entries_found = 1
        system_failure   = 2
        OTHERS           = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    LOOP AT lt_mard INTO ls_mard.
      cv_labst = cv_labst + ls_mard-labst.
    ENDLOOP.

  ENDMETHOD.


  METHOD ERMITTLE_WZEIT.

    DATA: lv_wzeit TYPE wzeit.

    CALL METHOD me->get_wbz_std
      CHANGING
        cv_wzeit = lv_wzeit.

    CALL METHOD me->set_wbz
      EXPORTING
        iv_wzeit = lv_wzeit.

  ENDMETHOD.


  method GET_BAUGRUPPE.

    cv_baugruppe = gv_baugruppe.

  endmethod.


  method GET_BEARZ.

    cv_bearz = gv_bearz.

  endmethod.


  method GET_BESKZ.

    cv_beskz = gv_beskz.

  endmethod.


method GET_BREIT.

  cv_breit = gv_breit.

endmethod.


method GET_BRGEW.

  cv_brgew = gv_brgew.

endmethod.


METHOD GET_DISPO.

  cv_dispo  = gv_dispo.

ENDMETHOD.


  method GET_DISPOMERKMAL.

    cv_dismm = gv_dismm.

  endmethod.


method GET_EISBE.

  cv_eisbe = gv_eisbe.

endmethod.


method GET_EKGRP.

  cv_ekgrp = gv_ekgrp.

endmethod.


METHOD GET_FHORI.

  cv_fhori  = gv_fhori.

ENDMETHOD.


method GET_GEWEI.

  cv_gewei = gv_gewei.

endmethod.


  method GET_GROES.

    cv_groes = gv_GROES.

  endmethod.


method GET_GRUTXT.

  Ct_grutxt = gt_grutxt.

endmethod.


method GET_HOEHE.

  cv_hoehe = gv_hoehe.

endmethod.


  method GET_KTXT.

    cv_maktx = gv_maktx.

  endmethod.


METHOD GET_LABST.

  cv_labst = gv_labst.

ENDMETHOD.


method GET_LAENG.

  cv_laeng = gv_laeng.

endmethod.


METHOD GET_LBKUM.

  cv_lbkum  = gv_lbkum.

ENDMETHOD.


method GET_LGRAD.

  cv_lgrad = gv_lgrad.

endmethod.


METHOD GET_MAKT.

  ct_makt[] = gt_makt[].

ENDMETHOD.


  method GET_MARM.

    ct_marm[] = gt_marm[].

  endmethod.


  method GET_MARM_FOR_UNIT.

    data: ls_marm type marm.

    read table gt_marm into ls_marm with key meinh = iv_meinh.
    if sy-subrc = 0.
      cs_marm = ls_marm.
    else.
      clear cs_marm.
      raise not_found.
    endif.


  endmethod.


METHOD GET_MATKL.

  cv_matkl  = gv_matkl.

ENDMETHOD.


  method GET_MATNR.

    cv_matnr = gv_matnr.

  endmethod.


method GET_MEABM.

  cv_meabm = gv_meabm.

endmethod.


  method GET_MEINS.

    cv_meins = gv_meins.

  endmethod.


  method GET_MFRPN.

    cv_mfrpn = gv_mfrpn.

  endmethod.


  method GET_MMSTA.

    cv_mmsta = gv_mmsta.

  endmethod.


  method GET_MSTAE.

    cv_mstae = gv_mstae.

  endmethod.


  method GET_MVER.

    data: ls_mver type mver.

    data: lv_matnr type matnr.
    data: lv_werks type werks_d.

    describe table gt_mver lines sy-tfill.
    if sy-tfill = 0.
      CALL METHOD me->GET_MATNR
        CHANGING
          CV_MATNR = lv_matnr.

      CALL METHOD me->GET_WERKS
        CHANGING
          CV_WERKS = lv_werks.

      select * from mver appending table gt_mver where matnr = lv_matnr
                                                  and  werks = lv_werks.
    endif.
    ct_mver = gt_mver.


  endmethod.


method GET_NETGW.

  cv_ntgew = gv_ntgew.

endmethod.


  method GET_NORMT.

    cv_normt = gv_normt.

  endmethod.


METHOD GET_PEINH.

  cv_peinh  = gv_peinh.

ENDMETHOD.


  method GET_PLIFZ.

    cv_plifz = gv_plifz.

  endmethod.


METHOD GET_PRDHA.

  cv_prdha  = gv_prdha.

ENDMETHOD.


  method GET_RUEZT.

    cv_ruezt = gv_ruezt.

  endmethod.


METHOD GET_SALK3.

  cv_salk3  = gv_salk3.

ENDMETHOD.


METHOD GET_STPRS.

  cv_stprs  = gv_stprs.

ENDMETHOD.


  method GET_TRANZ.

    cv_tranz = gv_tranz.

  endmethod.


METHOD GET_VERPR.

  cv_verpr  = gv_verpr.

ENDMETHOD.


  method GET_VOLEH.

    cv_voleh = gv_voleh.

  endmethod.


  method GET_VOLUM.

    cv_volum = gv_volum.

  endmethod.


METHOD GET_VORGZ.

  cv_vorgz  = gv_vorgz.

ENDMETHOD.


  method GET_WBZ.
* Ergebnis der Methode ermittle WZEIT

    cv_wzeit = gv_wzeit.

  endmethod.


METHOD get_wbz_std.
*&---------------------------------------------------------------------*
*& Beschreibung:
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Ersteller: Diemer_B
* Datum:   24.05.2018
* Projekt: NPS PLUS
*----------------------------------------------------------------------*
* Änderungsvermerk:
* Wer: Diemer_B       Wann: 24.05.2018  Was: Ermittlung GWBZ
*
*  Die GWBZ für Eigenfertigungsmaterialien errechnet sich aus
*  Rüstzeit + Beabrietungszeit + Transportzeit + Vorgriffzeit + Wareneingangsbeabreitungszeit
*
*  Die GWBZ für Fremdbeschaffungsmaterialien errechnet sich aus
*  Planlieferzeit + Wareneingangsbeabreitungszeit
*
*  Die Vorgriffszeit wird über den Horizontschlüssel ermittelt
*----------------------------------------------------------------------*

  DATA: lv_ruezt TYPE ruezt.
  DATA: lv_bearz TYPE bearz.
  DATA: lv_tranz TYPE tranz.
  DATA: lv_wzeit TYPE wzeit.
  DATA: lv_beskz TYPE beskz.
  DATA: lv_plifz TYPE plifz.
  DATA: lv_dismm TYPE dismm.
  DATA: lv_vorgz TYPE vorgz.
  DATA: lv_webaz TYPE webaz.

  CALL METHOD me->get_beskz
    CHANGING
      cv_beskz = lv_beskz.

  IF lv_beskz = 'E'.
    CALL METHOD me->get_ruezt
      CHANGING
        cv_ruezt = lv_ruezt.
    CALL METHOD me->get_tranz
      CHANGING
        cv_tranz = lv_tranz.

    CALL METHOD me->get_bearz
      CHANGING
        cv_bearz = lv_bearz.

    CALL METHOD me->get_vorgz
      CHANGING
        cv_vorgz = lv_vorgz.

    CALL METHOD me->get_webaz
      CHANGING
        cv_webaz = lv_webaz.

    lv_wzeit = lv_ruezt + lv_tranz + lv_bearz + lv_vorgz + lv_webaz.

  ELSEIF lv_beskz = 'F'.
    CALL METHOD me->get_plifz
      CHANGING
        cv_plifz = lv_plifz.

    CALL METHOD me->get_webaz
      CHANGING
        cv_webaz = lv_webaz.
    lv_wzeit = lv_plifz + lv_webaz.
  else.
    lv_wzeit = 0.
  ENDIF.
  cv_wzeit = lv_wzeit.
ENDMETHOD.


METHOD GET_WEBAZ.

  cv_webaz  = gv_webaz.

ENDMETHOD.


  method GET_WERKS.

    cv_werks = gv_werks.

  endmethod.


  method GET_WRKST.

    cv_wrkst = gv_wrkst.

  endmethod.


  method LESE_MARM.

    data: lv_matnr type mara-matnr.

    describe table gt_marm lines sy-tfill.
    if sy-tfill = 0.
      CALL METHOD me->GET_MATNR
        CHANGING
          CV_MATNR = lv_matnr.
      select * from marm appending table gt_marm where matnr = lv_matnr.

    endif.

  endmethod.


  METHOD LESE_MATERIAL.

    DATA: lt_ltext TYPE tlinetab.
    DATA: lt_temp  TYPE tlinetab.
    DATA: lt_makt  TYPE makt_tab.

    DATA: ls_marm  TYPE marm.

    DATA: lv_maktx TYPE makt-maktx.
    DATA: lv_wzeit TYPE marc-wzeit.
    DATA: lv_dismm TYPE marc-dismm.
    DATA: lv_normt TYPE mara-normt.
    DATA: lv_wrkst TYPE mara-wrkst.
    DATA: lv_sobsl TYPE marc-sobsl.
    DATA: lv_ruezt TYPE marc-ruezt.
    DATA: lv_bearz TYPE marc-bearz.
    DATA: lv_tranz TYPE marc-tranz.
    DATA: lv_beskz TYPE marc-beskz.
    DATA: lv_plifz TYPE marc-plifz.
    DATA: lv_mstae TYPE mara-mstae.
    DATA: lv_groes TYPE mara-groes.
    DATA: lv_mmsta TYPE marc-mmsta.
    DATA: lv_ntgew TYPE mara-ntgew.
    DATA: lv_brgew TYPE mara-brgew.
    DATA: lv_gewei TYPE mara-gewei.
    DATA: lv_volum TYPE mara-volum.
    DATA: lv_voleh TYPE mara-voleh.
    DATA: lv_meins TYPE mara-meins.
    DATA: lv_mfrpn TYPE mara-mfrpn.
    DATA: lv_lines TYPE i.
    DATA: lv_name  TYPE thead-tdname.
    DATA: lv_meinh TYPE lrmei.
    DATA: lv_ekgrp TYPE ekgrp.
    DATA: lv_lgrad TYPE lgrad.
    DATA: lv_eisbe TYPE eisbe.
    DATA: lv_dispo TYPE dispo.
    DATA: lv_lbkum TYPE lbkum.
    DATA: lv_salk3 TYPE salk3.
    DATA: lv_stprs TYPE stprs.
    DATA: lv_verpr TYPE verpr.
    DATA: lv_peinh TYPE peinh.
    DATA: lv_matkl TYPE matkl.
    DATA: lv_prdha TYPE prodh_d.
    DATA: lv_wbz   TYPE zpspp_de_wbz.
    DATA: lv_webaz TYPE webaz.
    DATA: lv_fhori TYPE fhori.
    DATA: lv_labst_sum TYPE labst.
    DATA: lv_labst TYPE labst.

    SELECT SINGLE maktx FROM makt INTO lv_maktx  WHERE matnr = iv_matnr
                                                  AND  spras = sy-langu.

    IF sy-subrc = 0.
      CALL METHOD me->set_ktxt
        EXPORTING
          iv_maktx = lv_maktx.
    ENDIF.

    SELECT * FROM makt APPENDING TABLE lt_makt  WHERE matnr = iv_matnr.

    IF sy-subrc = 0.
      CALL METHOD me->set_makt
        EXPORTING
          it_makt = lt_makt.

    ENDIF.


    SELECT SINGLE normt wrkst mstae groes ntgew brgew gewei volum voleh meins mfrpn prdha matkl
                  FROM mara
                  INTO (lv_normt, lv_wrkst, lv_mstae, lv_groes, lv_ntgew, lv_brgew, lv_gewei, lv_volum, lv_voleh, lv_meins, lv_mfrpn, lv_prdha, lv_matkl)
                  WHERE matnr = iv_matnr.

    IF sy-subrc = 0.
      CALL METHOD me->set_normt
        EXPORTING
          iv_normt = lv_normt.

      CALL METHOD me->set_wrkst
        EXPORTING
          iv_wrkst = lv_wrkst.

      CALL METHOD me->set_mstae
        EXPORTING
          iv_mstae = lv_mstae.

      CALL METHOD me->set_groes
        EXPORTING
          iv_groes = lv_groes.

      CALL METHOD me->set_brgew
        EXPORTING
          iv_brgew = lv_brgew.

      CALL METHOD me->set_gewei
        EXPORTING
          iv_gewei = lv_gewei.

      CALL METHOD me->set_meins
        EXPORTING
          iv_meins = lv_meins.

      CALL METHOD me->set_mfrpn
        EXPORTING
          iv_mfrpn = lv_mfrpn.

      CALL METHOD me->set_ntgew
        EXPORTING
          iv_ntgew = lv_ntgew.

      CALL METHOD me->set_voleh
        EXPORTING
          iv_voleh = lv_voleh.

      CALL METHOD me->set_volum
        EXPORTING
          iv_volum = lv_volum.

      CALL METHOD me->set_matkl
        EXPORTING
          iv_matkl = lv_matkl.

      CALL METHOD me->set_prdha
        EXPORTING
          iv_prdha = lv_prdha.

    ENDIF.

    SELECT SINGLE wzeit dismm sobsl ruezt bearz tranz beskz plifz mmsta ekgrp lgrad eisbe dispo webaz fhori
                        FROM marc INTO (lv_wzeit, lv_dismm, lv_sobsl, lv_ruezt, lv_bearz, lv_tranz,
                                        lv_beskz, lv_plifz, lv_mmsta, lv_ekgrp, lv_lgrad, lv_eisbe,
                                        lv_dispo, lv_webaz, lv_fhori)
                       WHERE matnr = iv_matnr
                        AND  werks = iv_werks.
    IF sy-subrc = 0.

      CALL METHOD me->set_wbz
        EXPORTING
          iv_wzeit = lv_wzeit.

      CALL METHOD me->set_dispomerkmal
        EXPORTING
          iv_dismm = lv_dismm.

      CALL METHOD me->set_werks
        EXPORTING
          iv_werks = iv_werks.

      CALL METHOD me->set_baugruppe
        EXPORTING
          iv_sobsl = lv_sobsl.

      CALL METHOD me->set_ruezt
        EXPORTING
          iv_ruezt = lv_ruezt.

      CALL METHOD me->set_bearz
        EXPORTING
          iv_bearz = lv_bearz.

      CALL METHOD me->set_tranz
        EXPORTING
          iv_tranz = lv_tranz.

      CALL METHOD me->set_beskz
        EXPORTING
          iv_beskz = lv_beskz.

      CALL METHOD me->set_plifz
        EXPORTING
          iv_plifz = lv_plifz.

      CALL METHOD me->set_mmsta
        EXPORTING
          iv_mmsta = lv_mmsta.

      CALL METHOD me->set_ekgrp
        EXPORTING
          iv_ekgrp = lv_ekgrp.

      CALL METHOD me->set_lgrad
        EXPORTING
          iv_lgrad = lv_lgrad.

      CALL METHOD me->set_eisbe
        EXPORTING
          iv_eisbe = lv_eisbe.

      CALL METHOD me->set_dispo
        EXPORTING
          iv_dispo = lv_dispo.

      CALL METHOD me->set_webaz
        EXPORTING
          iv_webaz = lv_webaz.

      CALL METHOD me->set_fhori
        EXPORTING
          iv_fhori = lv_fhori.

    ENDIF.

    SELECT SINGLE lbkum salk3 stprs verpr peinh
                        FROM mbew INTO (lv_lbkum, lv_salk3, lv_stprs, lv_verpr, lv_peinh)
                       WHERE matnr = iv_matnr
                        AND  bwkey = iv_werks.
    IF sy-subrc = 0.
      CALL METHOD me->set_lbkum
        EXPORTING
          iv_lbkum = lv_lbkum.

      CALL METHOD me->set_salk3
        EXPORTING
          iv_salk3 = lv_salk3.

      CALL METHOD me->set_stprs
        EXPORTING
          iv_stprs = lv_stprs.

      CALL METHOD me->set_verpr
        EXPORTING
          iv_verpr = lv_verpr.

      CALL METHOD me->set_peinh
        EXPORTING
          iv_peinh = lv_peinh.
    ENDIF.

    CALL METHOD me->collect_labst
      EXPORTING
        iv_matnr = iv_matnr
        iv_werks = iv_werks
      RECEIVING
        cv_labst = lv_labst.

    CALL METHOD me->set_labst
      EXPORTING
        iv_labst = lv_labst.

    lv_name = iv_matnr.
    CALL FUNCTION 'READ_TEXT_INLINE'
      EXPORTING
        id              = 'GRUN'
        inline_count    = lv_lines
        language        = sy-langu
        name            = lv_name
        object          = 'MATERIAL'
*       LOCAL_CAT       = ' '
*     IMPORTING
*       HEADER          =
      TABLES
        inlines         = lt_temp
        lines           = lt_ltext
      EXCEPTIONS
        id              = 1
        language        = 2
        name            = 3
        not_found       = 4
        object          = 5
        reference_check = 6
        OTHERS          = 7.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
    CALL METHOD me->set_grutxt
      EXPORTING
        it_grutxt = lt_ltext.

    CALL METHOD me->lese_marm
      EXPORTING
        iv_matnr = iv_matnr.

    lv_meinh = lv_meins.
    CALL METHOD me->get_marm_for_unit
      EXPORTING
        iv_meinh  = lv_meinh
      CHANGING
        cs_marm   = ls_marm
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.
    IF sy-subrc = 0.
      CALL METHOD me->set_breit
        EXPORTING
          iv_breit = ls_marm-breit.

      CALL METHOD me->set_hoehe
        EXPORTING
          iv_hoehe = ls_marm-hoehe.

      CALL METHOD me->set_laeng
        EXPORTING
          iv_laeng = ls_marm-laeng.

      CALL METHOD me->set_meabm
        EXPORTING
          iv_meabm = ls_marm-meabm.
    ENDIF.

  ENDMETHOD.


  method SET_BAUGRUPPE.

    if iv_sobsl = '52'.
      gv_baugruppe = 'X'.
    endif.
  endmethod.


  method SET_BEARZ.

    gv_bearz = iv_bearz.

  endmethod.


  method SET_BESKZ.

    gv_beskz = iv_beskz.

  endmethod.


method SET_BREIT.

  gv_breit = iv_breit.

endmethod.


method SET_BRGEW.

  gv_brgew = iv_brgew.

endmethod.


METHOD SET_DISPO.

  gv_dispo = iv_dispo.

ENDMETHOD.


  method SET_DISPOMERKMAL.

    gv_dismm = iv_dismm.

  endmethod.


method SET_EISBE.

  gv_eisbe = iv_eisbe.

endmethod.


method SET_EKGRP.

  gv_ekgrp  = iv_ekgrp.

endmethod.


METHOD SET_FHORI.

  DATA: lv_werks TYPE werks_d.

  CALL METHOD me->get_werks
    CHANGING
      cv_werks = lv_werks.

  gv_Fhori = iv_Fhori.
  SELECT SINGLE vorgz FROM T436a INTO gv_vorgz WHERE werks = lv_werks
                                                AND  fhori = gv_fhori.

ENDMETHOD.


method SET_GEWEI.

  gv_gewei = iv_gewei.

endmethod.


  method SET_GROES.

    gv_groes = iv_GROES.

  endmethod.


method SET_GRUTXT.

  gt_grutxt = it_grutxt.

endmethod.


method SET_HOEHE.

  gv_hoehe = iv_hoehe.

endmethod.


  method SET_KTXT.

    gv_maktx = iv_maktx.

  endmethod.


METHOD SET_LABST.

  gv_labst = iv_labst.

ENDMETHOD.


method SET_LAENG.

  gv_laeng = iv_laeng.

endmethod.


METHOD SET_LBKUM.

  gv_lbkum = iv_lbkum.

ENDMETHOD.


method SET_LGRAD.

  gv_lgrad = iv_lgrad.

endmethod.


METHOD SET_MAKT.

  gt_makt[] = it_makt[].

ENDMETHOD.


METHOD SET_MATKL.

  gv_matkl = iv_matkl.

ENDMETHOD.


  method SET_MATNR.

    data: lv_maktx type makt-maktx.
    data: lv_wzeit type marc-wzeit.
    data: lv_dismm type marc-dismm.

    gv_matnr = iv_matnr.

    CALL METHOD me->LESE_MATERIAL
      EXPORTING
        IV_MATNR = iv_matnr
        IV_WERKS = iv_werks.

  endmethod.


method SET_MEABM.

  gv_meabm = iv_meabm.

endmethod.


  method SET_MEINS.

    gv_meins = iv_meins.

  endmethod.


  method SET_MFRPN.

    gv_mfrpn = iv_mfrpn.

  endmethod.


  method SET_MMSTA.

    gv_mmsta = iv_mmsta.

  endmethod.


  method SET_MSTAE.

    gv_mstae = iv_mstae.

  endmethod.


  method SET_NORMT.

    gv_normt = iv_normt.

  endmethod.


method SET_NTGEW.

  gv_ntgew = iv_ntgew.

endmethod.


METHOD SET_PEINH.

  gv_peinh = iv_peinh.

ENDMETHOD.


  method SET_PLIFZ.

    gv_plifz = iv_plifz.

  endmethod.


METHOD SET_PRDHA.

  gv_prdha = iv_prdha.

ENDMETHOD.


  method SET_RUEZT.

    gv_ruezt = iv_ruezt.

  endmethod.


METHOD SET_SALK3.

  gv_salk3 = iv_salk3.

ENDMETHOD.


METHOD SET_STPRS.

  gv_stprs = iv_stprs.

ENDMETHOD.


  method SET_TRANZ.

    gv_tranz = iv_tranz.

  endmethod.


METHOD SET_VERPR.

  gv_verpr = iv_verpr.

ENDMETHOD.


  method SET_VOLEH.

    gv_voleh = iv_voleh.

  endmethod.


  method SET_VOLUM.

    gv_volum = iv_volum.

  endmethod.


  method SET_WBZ.

    gv_wzeit = iv_wzeit.

  endmethod.


METHOD SET_WBZ_STD.

  gv_wbz = iv_wbz.

ENDMETHOD.


METHOD SET_WEBAZ.

  gv_webaz = iv_webaz.

ENDMETHOD.


  method SET_WERKS.

    gv_werks = iv_werks.

  endmethod.


  method SET_WRKST.

    gv_wrkst = iv_wrkst.

  endmethod.
ENDCLASS.
