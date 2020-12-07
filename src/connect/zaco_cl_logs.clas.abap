class ZACO_CL_LOGS definition
  public
  create public .

public section.

  constants CV_FILE_NOT_FOUND type CHAR2 value '01' ##NO_TEXT.
  constants CV_NO_VBELN type CHAR2 value '02' ##NO_TEXT.

  class-methods CREATE_LOG_HANDLER
    importing
      !IS_LOG type BAL_S_LOG
      !IV_OBJEKT type CHAR10 optional
      !IV_SUBOBJECT type BALSUBOBJ optional
    changing
      !CV_LOGHNDL type BALLOGHNDL .
  class-methods ADD_LOG_ENTRY
    importing
      !IS_MSG type BAL_S_MSG
      !IV_LOGHNDL type BALLOGHNDL optional .
protected section.
private section.
ENDCLASS.



CLASS ZACO_CL_LOGS IMPLEMENTATION.


method ADD_LOG_ENTRY.

  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      I_LOG_HANDLE              = iv_loghndl
      I_S_MSG                   = is_msg
*     IMPORTING
*       E_S_MSG_HANDLE            =
*       E_MSG_WAS_LOGGED          =
*       E_MSG_WAS_DISPLAYED       =
   EXCEPTIONS
     LOG_NOT_FOUND             = 1
     MSG_INCONSISTENT          = 2
     LOG_IS_FULL               = 3
     OTHERS                    = 4.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.

endmethod.


method CREATE_LOG_HANDLER.

  data: ls_log type BAL_S_LOG.

  case iv_objekt.
    when 'EQUI'.
      ls_log-extnumber = 'ZPSAINEQUIPMENT'.
      ls_log-object = 'ZPSAINEQUI'.
    when 'EQUIPMENT'.
      ls_log-extnumber = 'ZPSAINEQUIPMENT'.
      ls_log-object = 'ZPSAINEQUI'.
    when 'BWA'.
      ls_log-extnumber = 'ZPSAINBWA'.
      ls_log-object = 'ZPSAINBWA'.

  endcase.
*  ls_log-subobject = iv_subobject.
  ls_log-aldate = sy-datum.
  ls_log-altime = sy-uzeit.
  ls_log-aluser = sy-uname.
  ls_log-aldate_del = ( sy-datum + 30 ).  "4 Wochen

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      I_S_LOG                 = ls_log
    IMPORTING
      E_LOG_HANDLE            = cv_loghndl
    EXCEPTIONS
      LOG_HEADER_INCONSISTENT = 1
      OTHERS                  = 2.
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.



endmethod.
ENDCLASS.
