interface ZACO_IF_BADI_EQUIP_ERP
  public .


  interfaces IF_BADI_INTERFACE .

  methods ENHANCE_EUQIPMENT
    importing
      !IO_EQUIPMENT type ref to ZACO_CL_EQUIP_ERP .
endinterface.
