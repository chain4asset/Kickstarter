class ZACO_CL_TEXT_READ definition
  public
  create public .

public section.

  class-methods READ_TEXT
    importing
      !IV_TDOBJECT type THEAD-TDOBJECT
      !IV_TDNAME type THEAD-TDNAME
      !IV_TDID type THEAD-TDID
      !IV_TDSPRAS type THEAD-TDSPRAS
    returning
      value(CT_TLINE) type TLINE_T .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZACO_CL_TEXT_READ IMPLEMENTATION.


  METHOD READ_TEXT.

    TYPES:
      BEGIN OF ts_stxl,
        tdname TYPE stxl-tdname,
        clustr TYPE stxl-clustr,
        clustd TYPE stxl-clustd,
      END OF ts_stxl,

      BEGIN OF ts_stxl_raw,
        clustr TYPE stxl-clustr,
        clustd TYPE stxl-clustd,
      END OF ts_stxl_raw.

    DATA:
      lt_stxl     TYPE STANDARD TABLE OF ts_stxl,
      ls_stxl_raw TYPE ts_stxl_raw,
      lt_stxl_raw TYPE STANDARD TABLE OF ts_stxl_raw,
      lt_tline    TYPE STANDARD TABLE OF tline.

    FIELD-SYMBOLS:
      <ls_stxl>  TYPE ts_stxl,
      <ls_tline> TYPE tline.

    SELECT tdname clustr clustd
      INTO TABLE lt_stxl
      FROM stxl
      PACKAGE SIZE 3000
      WHERE relid    EQ 'TX'          "standard text
        AND tdobject EQ iv_tdobject
        AND tdname   EQ iv_tdname
        AND tdid     EQ iv_tdid
        AND tdspras  EQ iv_tdspras.

      LOOP AT lt_stxl ASSIGNING <ls_stxl>.
        CLEAR: lt_stxl_raw[], lt_tline[].
        ls_stxl_raw-clustr = <ls_stxl>-clustr.
        ls_stxl_raw-clustd = <ls_stxl>-clustd.
        APPEND ls_stxl_raw TO lt_stxl_raw.
        IMPORT tline = lt_tline FROM INTERNAL TABLE lt_stxl_raw.
        APPEND LINES OF lt_tline TO ct_tline.
      ENDLOOP.
      FREE lt_stxl.
    ENDSELECT.
  ENDMETHOD.
ENDCLASS.
