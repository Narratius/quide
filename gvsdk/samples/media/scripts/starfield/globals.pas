uses
  GVDLL;

const
  MAX_STARS         = 250;

  SCREEN_WIDTH      = 640;
  SCREEN_HEIGHT     = 480;
  SCREEN_BPP        = 32;
  SCREEN_CAPTION    = 'StarField';

type
  TGVPoint = record
    x,y,z: double;
  end;

var
  Font   : Integer = -1;
  Star   : TStar   = nil;
  Point  : TGVPoint;
  MusicPath: string = '';
  SCREEN_WINDOWED: Boolean = True;



