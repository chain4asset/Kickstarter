*----------------------------------------------------------------------*
***INCLUDE ZCHAIN_ERR_LOG_USER_COMMANDI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0110  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0110 INPUT.

  case fcode.
    when 'BACK'.
      set screen 0.
      exit.
    when 'JSON'.
      perform display_json.
    when'REFR'.
      perform lese_erneut.
   endcase.



ENDMODULE.
