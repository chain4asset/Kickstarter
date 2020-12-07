class ZACO_CL_JSON definition
  public
  final
  create public .

public section.

  class-methods JSON_TO_DATA
    importing
      !IV_JSON type STRING
    changing
      !CT_DATA type ZACO_T_JSON_BODY .
protected section.
private section.
ENDCLASS.



CLASS ZACO_CL_JSON IMPLEMENTATION.


method JSON_TO_DATA.

  data: ls_data type zaco_s_json_body.
  data: lv_work type String.
  data: lv_name type string.
  data: lv_value type string.
  data: lv_length type i.

  lv_work = iv_json.
  shift lv_work by 2 places left.
  lv_length = strlen( lv_work ).
  replace all OCCURRENCES OF ':{' in lv_work with ':" ",'.
  replace all OCCURRENCES OF ':[{' in lv_work with ':" ",'.

  while lv_length > 0.
    split lv_work at ':' into lv_name lv_work.
    find ',' in lv_work.
    if sy-subrc = 0.
      split lv_work at ',' into lv_value lv_work.
      lv_length = strlen( lv_work ).
    else.
      split lv_work at ':' into lv_name lv_work.
      replace all OCCURRENCES OF '"' in lv_work with ''.
      replace '}]' in lv_work with ''.
      lv_value = lv_work.
      lv_length = 0.
    endif.
    replace all OCCURRENCES OF '"' in lv_name with ''.
    replace '}]' in lv_name with ''.
    ls_data-name = lv_name.
    replace all OCCURRENCES OF '"' in lv_value with ''.
    replace '}]' in lv_value with ''.
    ls_data-value = lv_value.
    append ls_data to ct_data.
  endwhile.

endmethod.
ENDCLASS.
