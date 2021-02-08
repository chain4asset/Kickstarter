class ZACO_CL_ERROR_LOG definition
  public
  create public .

public section.

  class-methods WRITE_ERROR
    importing
      !IV_MSGTY type SYMSGTY
      !IV_JSON type STRING optional
      !IV_EQUNR type EQUNR optional
      !IV_MSGNO type SYMSGNO
      !IV_MSGID type MSGID
      !IV_MSGV1 type MSGV1 optional
      !IV_MSGV2 type MSGV2 optional
      !IV_MSGV3 type MSGV3 optional
      !IV_MSGV4 type MSGV4 optional
      !IV_ERR_GROUP type ZACO_DE_ERR_GROUP optional .
  class-methods DELETE_ERROR_LOG
    importing
      !IV_ERR_GROUP type ZACO_DE_ERR_GROUP optional
      !IV_DATUM_V type DATUM
      !IV_DATUM_B type DATUM
    exceptions
      ERR_DEL_GROUP_FAIL
      ERR_DEL_FAIL .
  class-methods READ_ERROR
    importing
      !IV_DATUM_B type DATUM
      !IV_DATUM_V type DATUM
      !IV_ERR_GROUP type ZACO_DE_ERR_GROUP
    changing
      !CT_ERR_LOG type ZACO_TT_ERR_LOG .
  class-methods DESERIALIZE_ERROR_JSON
    importing
      !IV_ERR_GROUP type ZACO_DE_ERR_GROUP
      !IV_MSGTY type MSGTY
      !IV_JSON type ZACO_DE_STRING
    changing
      !CS_ERR_JSON type ZACO_S_JSON_ERROR .
protected section.
private section.
ENDCLASS.



CLASS ZACO_CL_ERROR_LOG IMPLEMENTATION.


  METHOD delete_error_log.

    IF iv_err_group NE space.
      DELETE FROM zaco_err_log WHERE ERR_GROUP = iv_err_group
                                and ( datum >= iv_datum_v
                                AND datum <= iv_datum_b ).
      if sy-subrc <> 0.
        raise err_del_group_fail.
      endif.
    ELSE.
      DELETE FROM zaco_err_log WHERE ( datum >= iv_datum_v
                                AND datum <= iv_datum_b ).
      if sy-subrc <> 0.
        raise err_del_fail.
      endif.
    ENDIF.

  ENDMETHOD.


  METHOD deserialize_error_json.
    IF iv_msgty = 'E'.
*--------------- Deserialize Error Message
      /ui2/cl_json=>deserialize(
        EXPORTING
          json        = iv_json
          pretty_name = /ui2/cl_json=>pretty_mode-camel_case
        CHANGING
          data        = cs_err_json ).

    ELSE.
      CASE iv_err_group.
        WHEN 'EQUI'.
*--------------- Deserialize Equipment Information

      ENDCASE.
    ENDIF.

  ENDMETHOD.


  METHOD read_error.

  if iv_err_group ne space.
    SELECT  zaco_err_log~datum,
            zaco_err_log~utime,
            zaco_err_log~msgid,
            zaco_err_log~msgno,
            zaco_err_log~equnr,
            zaco_err_log~err_group,
            zaco_err_log~msgty,
            zaco_err_log~msgv1,
            zaco_err_log~msgv2,
            zaco_err_log~msgv3,
            zaco_err_log~msgv4,
            zaco_err_log~json
            APPENDING CORRESPONDING FIELDS OF TABLE @ct_err_log
            FROM zaco_err_log
            WHERE err_group = @iv_err_group
             AND ( datum >= @iv_datum_v
                   AND datum <= @iv_datum_b ).
   else.
    SELECT  zaco_err_log~datum,
            zaco_err_log~utime,
            zaco_err_log~msgid,
            zaco_err_log~msgno,
            zaco_err_log~equnr,
            zaco_err_log~err_group,
            zaco_err_log~msgty,
            zaco_err_log~msgv1,
            zaco_err_log~msgv2,
            zaco_err_log~msgv3,
            zaco_err_log~msgv4,
            zaco_err_log~json
            APPENDING CORRESPONDING FIELDS OF TABLE @ct_err_log
            FROM zaco_err_log
            WHERE ( datum >= @iv_datum_v
                   AND datum <= @iv_datum_b ).

   endif.
  ENDMETHOD.


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

    modify ZACO_ERR_LOG from ls_err_log.
    commit work.


  endmethod.
ENDCLASS.
