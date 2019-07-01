class ZACO_CL_SAVE_LOCAL definition
  public
  final
  create public .

public section.

  class-methods SAVE_TO_LOCAL
    importing
      !IV_PDF_BIN type XSTRING
      !IV_FILENAME type CHAR255
      !IV_PATH type STRING .
  class-methods DELETE_LOCAL
    importing
      !IV_FILENAME type CHAR255
      !IV_PATH type STRING .
protected section.
private section.
ENDCLASS.



CLASS ZACO_CL_SAVE_LOCAL IMPLEMENTATION.


  METHOD delete_local.

    DATA: lv_out      TYPE string.

    CONCATENATE iv_path iv_filename INTO lv_out.
    DELETE DATASET lv_out.

  ENDMETHOD.


  METHOD save_to_local.

    DATA: lv_out      TYPE string.

    CONCATENATE iv_path iv_filename INTO lv_out.
    OPEN DATASET lv_out FOR OUTPUT IN BINARY MODE.
    TRANSFER iv_pdf_bin TO lv_out.
    CLOSE DATASET lv_out.

  ENDMETHOD.
ENDCLASS.
