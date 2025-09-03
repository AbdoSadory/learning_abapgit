*&---------------------------------------------------------------------*
*& REPORT ZMASS_CHANGE_MRP_AREA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmass_change_mrp_area.

DATA: material    TYPE matnr,
      mrp_areas   TYPE berid,
      it_rspar    TYPE TABLE OF rsparams,
      wa_rspar    LIKE LINE OF it_rspar,
      list_object LIKE TABLE OF  abaplist.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE b1_title.

  SELECTION-SCREEN SKIP.

  SELECT-OPTIONS matnr FOR material.
  PARAMETERS plant TYPE werkdp.
  SELECT-OPTIONS mrpareas FOR mrp_areas.

  SELECTION-SCREEN SKIP.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS create RADIOBUTTON GROUP mrp DEFAULT 'X'.
    SELECTION-SCREEN COMMENT 3(30) TEXT-001.
    PARAMETERS change RADIOBUTTON GROUP mrp.
    SELECTION-SCREEN COMMENT 37(30) TEXT-002.
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  b1_title = 'Mass Change MRP Areas'.


START-OF-SELECTION.

  PERFORM handling_material_values.
  PERFORM handling_Plant_value.
  PERFORM handling_mrp_areas_values.
  PERFORM handling_mrp_process_value.

  SUBMIT rmmddibe02
  with SELECTION-TABLE it_rspar.
*  EXPORTING LIST TO MEMORY
*    AND RETURN.
*
*  CALL FUNCTION 'LIST_FROM_MEMORY'
*    TABLES
*      listobject = list_object
*    exceptions
*      not_found  = 1
*      OTHERS     = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  CALL FUNCTION 'LIST_TO_ASCI'
*   TABLES
*     LISTOBJECT                         = list_object
*   EXCEPTIONS
*     EMPTY_LIST                         = 1
*     LIST_INDEX_INVALID                 = 2
*     OTHERS                             = 3
*            .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.


FORM handling_material_values.
  LOOP AT matnr INTO DATA(wa_matnr).
    wa_rspar = VALUE #( selname = 'SO_MATNR'
    kind = 'S'
    sign = wa_matnr-sign
    option = wa_matnr-option
    low = wa_matnr-low
    high  = wa_matnr-high
    ).
    APPEND wa_rspar TO it_rspar.
  ENDLOOP.

ENDFORM.

FORM handling_Plant_value.
  wa_rspar = VALUE #( selname = 'SO_WERKS'
  kind = 'P'
  sign = 'I'
  option = 'EQ'
  low = plant
  ).
  APPEND wa_rspar TO it_rspar.

ENDFORM.

FORM handling_mrp_areas_values.
  LOOP AT mrpareas INTO DATA(wa_mrpareas).
    wa_rspar = VALUE #( selname = 'SO_BERID'
    kind = 'S'
    sign = wa_mrpareas-sign
    option = wa_mrpareas-option
    low = wa_mrpareas-low
    high  = wa_mrpareas-high
    ).
    APPEND wa_rspar TO it_rspar.
  ENDLOOP.
ENDFORM.

FORM handling_mrp_process_value.
  CASE 'X'.
    WHEN create.
      wa_rspar = VALUE #( selname = 'PANE' kind = 'P' sign = 'I' option = 'EQ'  low = 'X' ).
      APPEND wa_rspar TO it_rspar.
    WHEN change.
      wa_rspar = VALUE #( selname = 'PACH' kind = 'P' sign = 'I' option = 'EQ' low = 'X' ).
      APPEND wa_rspar TO it_rspar.
  ENDCASE.

ENDFORM.
