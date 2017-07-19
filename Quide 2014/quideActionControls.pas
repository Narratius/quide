unit quideActionControls;

interface
Uses
 PropertiesControls,
 quideActions;

type
 TquideActionPanel = class(TPropertiesPanel)
  private
    f_Action: TquideAction;
 public
  property Action: TquideAction
   read f_Action write f_Action;
 end;


implementation

end.
