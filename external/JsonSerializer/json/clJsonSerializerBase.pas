{
  Copyright (C) 2015 by Clever Components

  Author: Sergey Shirokov <admin@clevercomponents.com>

  Website: www.CleverComponents.com

  This file is part of Json Serializer.

  Json Serializer is free software: you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License version 3
  as published by the Free Software Foundation and appearing in the
  included file COPYING.LESSER.

  Json Serializer is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with Json Serializer. If not, see <http://www.gnu.org/licenses/>.

  The current version of Json Serializer needs for the non-free library
  Clever Internet Suite. This is a drawback, and we suggest the task of changing
  the program so that it does the same job without the non-free library.
  Anyone who thinks of doing substantial further work on the program,
  first may free it from dependence on the non-free library.
}

unit clJsonSerializerBase;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.Rtti, System.TypInfo;

type
  EclJsonSerializerError = class(Exception)
  end;

  TclJsonPropertyAttribute = class (TCustomAttribute)
  strict private
    FName: string;
  public
    constructor Create(const AName: string);
    property Name: string read FName;
  end;

  TclJsonStringAttribute = class(TclJsonPropertyAttribute);

  TclJsonSerializerBase = class abstract
  public
    function JsonToObject(AType: TClass; const AJson: string): TObject; overload; virtual; abstract;
    function JsonToObject(AObject: TObject; const AJson: string): TObject; overload; virtual; abstract;
    function ObjectToJson(AObject: TObject): string; virtual; abstract;
  end;

implementation

{ TclJsonPropertyAttribute }

constructor TclJsonPropertyAttribute.Create(const AName: string);
begin
  inherited Create();
  FName := AName;
end;

end.
