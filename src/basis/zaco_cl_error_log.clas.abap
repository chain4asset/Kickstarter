class ZACO_CL_ERROR_LOG definition
  public
  create public .

public section.

  class-methods WRITE_ERROR
    importing
      !IV_MSGTY type SYMSGTY
      !IV_JSON type STRING
      !IV_EQUNR type EQUNR
      !IV_MSGNO type SYMSGNO .
  class-methods DELETE_ERROR_LOG .
protected section.
private section.
ENDCLASS.



CLASS ZACO_CL_ERROR_LOG IMPLEMENTATION.


  method DELETE_ERROR_LOG.

  endmethod.


  method WRITE_ERROR.

    data: ls_err_log type ZACO_ERR_LOG.

    ls_err_log-equnr = iv_equnr.
    ls_err_log-datum = sy-datum.
    ls_err_log-utime = sy-uzeit.
    ls_err_log-msgty = iv_msgty.
    ls_err_log-msgno = iv_msgno.
    ls_err_log-json  = iv_json.

    insert ZACO_ERR_LOG from ls_err_log.
    commit work.


  endmethod.
ENDCLASS.
