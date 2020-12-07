
*----------------------------------------------------------------------*
*       CLASS zpsain_Cl_Test_Spareparts DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS zpsain_cl_test_spareparts DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
.
*?﻿<asx:abap xmlns:asx="http://www.sap.com/abapxml" version="1.0">
*?<asx:values>
*?<TESTCLASS_OPTIONS>
*?<TEST_CLASS>zpsain_Cl_Test_Spareparts
*?</TEST_CLASS>
*?<TEST_MEMBER>f_Cut
*?</TEST_MEMBER>
*?<OBJECT_UNDER_TEST>ZPSAIN_CL_SPAREPARTS
*?</OBJECT_UNDER_TEST>
*?<OBJECT_IS_LOCAL/>
*?<GENERATE_FIXTURE>X
*?</GENERATE_FIXTURE>
*?<GENERATE_CLASS_FIXTURE>X
*?</GENERATE_CLASS_FIXTURE>
*?<GENERATE_INVOCATION>X
*?</GENERATE_INVOCATION>
*?<GENERATE_ASSERT_EQUAL>X
*?</GENERATE_ASSERT_EQUAL>
*?</TESTCLASS_OPTIONS>
*?</asx:values>
*?</asx:abap>
  PRIVATE SECTION.
* ================
    DATA:
      f_cut TYPE REF TO zaco_cl_spareparts.  "class under test

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: spareparts_already_transferred FOR TESTING.
ENDCLASS.       "zpsain_Cl_Test_Spareparts


*----------------------------------------------------------------------*
*       CLASS zpsain_Cl_Test_Spareparts IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS zpsain_cl_test_spareparts IMPLEMENTATION.
* ===============================================

  METHOD class_setup.
* ===================


  ENDMETHOD.       "class_Setup


  METHOD class_teardown.
* ======================


  ENDMETHOD.       "class_Teardown


  METHOD setup.
* =============

    DATA: lo_http_client TYPE REF TO if_http_client.
    DATA: lo_connect TYPE REF TO zaco_cl_connection_ain.

    CREATE OBJECT lo_connect.

    CALL METHOD zaco_cl_connection_ain=>connect_to_ain
      EXPORTING
        iv_rfcdest               = 'AIN_TEST'
      CHANGING
        co_http_client           = lo_http_client
*      EXCEPTIONS
*        DEST_NOT_FOUND           = 1
*        DESTINATION_NO_AUTHORITY = 2
*        others                   = 3
            .
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.


  ENDMETHOD.       "setup


  METHOD teardown.
* ================


  ENDMETHOD.       "teardown


  METHOD spareparts_already_transferred.
* ======================================
    DATA iv_matnr TYPE matnr.
    DATA cv_transferred TYPE char1.
    DATA: lv_ain_part TYPE string.

    iv_matnr = '688972'.

    f_cut->spareparts_already_transferred(
      EXPORTING
        iv_rfcdest = 'AIN_TEST'
        iv_matnr = iv_matnr
      CHANGING
        cv_transferred = cv_transferred
        cv_ain_part = lv_ain_part ).

    cl_abap_unit_assert=>assert_equals(
      act   = cv_transferred
      exp   = space          "<--- please adapt expected value
    " msg   = 'Testing value cv_Transferred'
*     level =
    ).
  ENDMETHOD.       "spareparts_Already_Transferred




ENDCLASS.       "zpsain_Cl_Test_Spareparts
