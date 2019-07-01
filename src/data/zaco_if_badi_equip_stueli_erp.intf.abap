interface ZACO_IF_BADI_EQUIP_STUELI_ERP
  public .


  interfaces IF_BADI_INTERFACE .

  methods ENHANCE_BOM
    importing
      !IO_EQUIP_ERP_STUELI type ref to ZACO_CL_EQUIP_ERP_STUELI .
endinterface.
