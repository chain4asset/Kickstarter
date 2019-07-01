class ZACO_CL_EQUIP_ERP_STUELI_POS definition
  public
  create public .

public section.

  methods SET_MATNR
    importing
      !IV_IDNRK type IDNRK .
  methods GET_MATNR
    changing
      value(CV_MATNR) type MATNR .
  methods SET_MEINS
    importing
      !IV_MEINS type KMPME .
  methods GET_MEINS
    changing
      value(CV_MEINS) type KMPME .
  methods GET_MENGE
    changing
      value(CV_MENGE) type KMPMG .
  methods SET_MENGE
    importing
      !IV_MENGE type KMPMG .
  methods GET_POSNR
    changing
      value(CV_POSNR) type SPOSN .
  methods SET_POSNR
    importing
      !IV_POSNR type SPOSN .
  methods GET_POSTP
    changing
      value(CV_POSTP) type POSTP .
  methods SET_POSTP
    importing
      !IV_POSTP type POSTP .
  methods GET_STLKN
    changing
      value(CV_STLKN) type STLKN .
  methods SET_STLKN
    importing
      !IV_STLKN type STLKN .
  methods GET_STLNR
    changing
      value(CV_STLNR) type STNUM .
  methods SET_STLNR
    importing
      !IV_STLNR type STNUM .
  methods GET_STUFE
    changing
      value(CV_STUFE) type HISTU .
  methods SET_STUFE
    importing
      !IV_STUFE type HISTU .
  methods GET_WERKS
    changing
      value(CV_WERKS) type WERKS_D .
  methods SET_WERKS
    importing
      !IV_WERKS type WERKS_D .
  methods SET_ERSKZ
    importing
      !IV_ERSKZ type ERSKZ .
  methods GET_ERSKZ
    changing
      !CV_ERSKZ type ERSKZ .
protected section.
private section.

  data GV_MATNR type MATNR .
  data GV_STLNR type STNUM .
  data GV_STLKN type STLKN .
  data GV_POSTP type POSTP .
  data GV_POSNR type SPOSN .
  data GV_MEINS type KMPME .
  data GV_MENGE type KMPMG .
  data GV_STUFE type HISTU .
  data GV_WERKS type WERKS_D .
  data GV_ERSKZ type ERSKZ .
ENDCLASS.



CLASS ZACO_CL_EQUIP_ERP_STUELI_POS IMPLEMENTATION.


method GET_ERSKZ.

  cv_erskz = gv_erskz.

endmethod.


method GET_MATNR.

  cv_matnr = gv_matnr.

endmethod.


method GET_MEINS.

  cv_meins = gv_meins.

endmethod.


method GET_MENGE.

  cv_menge = gv_menge.

endmethod.


method GET_POSNR.

  cv_posnr = gv_posnr.

endmethod.


method GET_POSTP.

  cv_postp = gv_postp.

endmethod.


method GET_STLKN.

  cv_stlkn  = gv_stlkn.

endmethod.


method GET_STLNR.

  cv_stlnr  = gv_stlnr.

endmethod.


method GET_STUFE.

  cv_stufe  = gv_stufe.

endmethod.


method GET_WERKS.

  cv_werks  = gv_werks.

endmethod.


METHOD SET_ERSKZ.

  IF iv_erskz NE space.
    gv_erskz = 'X'.     " iv_erskz.
  ENDIF.
ENDMETHOD.


method SET_MATNR.
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
*    bernhard.diemer@netzsch.com
*
*---------------------------------------------------------------------------*


  gv_matnr = iv_idnrk.

endmethod.


method SET_MEINS.

  gv_meins = iv_meins.

endmethod.


method SET_MENGE.

  gv_menge = iv_menge.

endmethod.


method SET_POSNR.

  gv_posnr = iv_posnr.

endmethod.


method SET_POSTP.

  gv_postp   = iv_postp.

endmethod.


method SET_STLKN.

  gv_stlkn = iv_stlkn.

endmethod.


method SET_STLNR.

  gv_stlnr = iv_stlnr.

endmethod.


method SET_STUFE.

  gv_stufe  = iv_stufe.

endmethod.


method SET_WERKS.

  gv_werks = iv_werks.

endmethod.
ENDCLASS.
