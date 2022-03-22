unit Quide.Classes.Painters;

interface

Uses
  Quide.Classes, SimpleGraph;

type
  TquideGraphPainter = class(TGraphObject)

  private
    FQuideObject: TquideCustomStoryItem;
  public
    property QuideObject: TquideCustomStoryItem read FQuideObject write
        FQuideObject;
  end;

implementation

end.
