class ZACO_CL_ERROR_LOG definition
  public
  create public .

public section.

  class-methods WRITE_ERROR
    importing
      !IV_MSGTY type SYMSGTY
      !IV_JSON type STRING
      !IV_EQUNR type EQUNR
      !IV_MSGNO type SYMSGNO
      !IV_MSGID type MSGID
      !IV_MSGV1 type MSGV1 optional
      !IV_MSGV2 type MSGV2 optional
      !IV_MSGV3 type MSGV3 optional
      !IV_MSGV4 type MSGV4 optional
      !IV_ERR_GROUP type ZACO_DE_ERR_GROUP optional .
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
    ls_err_log-msgid = iv_msgid.
    ls_err_log-msgty = iv_msgty.
    ls_err_log-msgno = iv_msgno.
    ls_err_log-msgv1 = iv_msgv1.
    ls_err_log-msgv2 = iv_msgv2.
    ls_err_log-msgv3 = iv_msgv3.
    ls_err_log-msgv4 = iv_msgv4.
    ls_err_log-err_group = iv_err_group.
    ls_err_log-json  = iv_json.

    insert ZACO_ERR_LOG from ls_err_log.
    commit work.


  endmethod.
ENDCLASS.
