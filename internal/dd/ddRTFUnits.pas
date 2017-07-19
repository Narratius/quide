unit ddRTFUnits;
{ Преобразование единиц }

//$Id: ddRTFUnits.pas,v 1.1 2011/04/15 12:41:27 narry Exp $

// $Log: ddRTFUnits.pas,v $
// Revision 1.1  2011/04/15 12:41:27  narry
// Обрезать картинку (262636436)
//


interface

function Inch2Pixel(aInch: Integer; aDPI: Integer = 96): Integer;

function Inch2Point(aInch: Integer): Integer;

function Inch2Twip(aInch: Integer): Integer;

function Pixel2Inch(aPixel: Integer; aDPI: Integer = 96): Integer;

function Pixel2Twip(aPixels: Integer; aDPI: Integer = 96): Integer;

function Point2Inch(aPoints: Integer): Integer;

function Twip2Inch(aTwip: Integer): Integer;

function Twip2Pixel(aTwips: Integer; aDPI: Integer = 96): Integer;

implementation

uses
 l3Math;

function Twip2Pixel(aTwips: Integer; aDPI: Integer = 96): Integer;
begin
 Result:= l3MulDiv(aTwips, aDPI, 1440);
end;

function Point2Inch(aPoints: Integer): Integer;
begin
 Result:= aPoints * 72;
end;

function Inch2Point(aInch: Integer): Integer;
begin
 Result := aInch div 72;
end;

function Twip2Inch(aTwip: Integer): Integer;
begin
 Result := aTwip div 1440
end;

function Inch2Twip(aInch: Integer): Integer;
begin
 Result := 1440 * aInch
end;

function Pixel2Inch(aPixel: Integer; aDPI: Integer = 96): Integer;
begin
 Result := aPixel div aDPI;
end;

function Inch2Pixel(aInch: Integer; aDPI: Integer = 96): Integer;
begin
 Result := aDPI * aInch
end;

function Pixel2Twip(aPixels: Integer; aDPI: Integer = 96): Integer;
begin
 Result := l3MulDiv(aPixels, 1440, aDPI);
end;

end.
