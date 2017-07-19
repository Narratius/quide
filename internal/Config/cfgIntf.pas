unit cfgIntf;

interface

type
 IConfigWriter = Interface
   procedure LoadValue(Value: Variant);
   procedure SaveValue(Value: Variant);
 End;


implementation

end.
