class ZHELLO_TO_ABAPGIT definition
  public
  final
  create public .

public section.

  interfaces IF_OO_ADT_CLASSRUN .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZHELLO_TO_ABAPGIT IMPLEMENTATION.


  METHOD IF_OO_ADT_CLASSRUN~MAIN.
    out->write( 'Hello World !' ).
  ENDMETHOD.
ENDCLASS.
