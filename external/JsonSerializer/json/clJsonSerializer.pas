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

unit clJsonSerializer;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.Rtti, System.TypInfo, clJsonSerializerBase, Json;

type
  TclJsonSerializer = class(TclJsonSerializerBase)
  strict private
    procedure SerializeArray(AProperty: TRttiProperty; AObject: TObject;
      Attribute: TclJsonPropertyAttribute; AJson: TJsonObject);
    procedure DeserializeArray(AProperty: TRttiProperty; AObject: TObject; AJsonArray: TJSONArray);

    function Deserialize(AType: TClass; const AJson: TJSONObject): TObject; overload;
    function Deserialize(AObject: TObject; const AJson: TJSONObject): TObject; overload;
    function Serialize(AObject: TObject): TJSONObject;
  public
    function JsonToObject(AType: TClass; const AJson: string): TObject; overload; override;
    function JsonToObject(AObject: TObject; const AJson: string): TObject; overload; override;
    function ObjectToJson(AObject: TObject): string; override;
  end;

resourcestring
  cUnsupportedDataType = 'Unsupported data type';
  cNonSerializable = 'The object is not serializable';

implementation

{ TclJsonSerializer }

procedure TclJsonSerializer.DeserializeArray(AProperty: TRttiProperty;
  AObject: TObject; AJsonArray: TJSONArray);
var
  elType: PTypeInfo;
  len: LongInt;
  pArr: Pointer;
  rValue, rItemValue: TValue;
  i: Integer;
  objClass: TClass;
begin
  len := AJsonArray.Count;
  if (len = 0) then Exit;

  if (GetTypeData(AProperty.PropertyType.Handle).DynArrElType = nil) then Exit;

  elType := GetTypeData(AProperty.PropertyType.Handle).DynArrElType^;

  pArr := nil;

  DynArraySetLength(pArr, AProperty.PropertyType.Handle, 1, @len);
  try
    TValue.Make(@pArr, AProperty.PropertyType.Handle, rValue);

    for i := 0 to AJsonArray.Count - 1 do
    begin
      if (elType.Kind = tkClass)
        and (AJsonArray.Items[i] is TJSONObject) then
      begin
        objClass := elType.TypeData.ClassType;
        rItemValue := Deserialize(objClass, TJSONObject(AJsonArray.Items[i]));
      end else
      if (elType.Kind in [tkString, tkLString, tkWString, tkUString]) then
      begin
        rItemValue := AJsonArray.Items[i].Value;
      end else
      if (elType.Kind = tkInteger) then
      begin
        rItemValue := StrToInt(AJsonArray.Items[i].Value);
      end else
      if (elType.Kind = tkInt64) then
      begin
        rItemValue := StrToInt64(AJsonArray.Items[i].Value);
      end else
      if (elType.Kind = tkEnumeration)
        and (elType = System.TypeInfo(Boolean))
        and (AJsonArray.Items[i] is TJSONBool) then
      begin
        rItemValue := TJSONBool(AJsonArray.Items[i]).Value;
      end else
      begin
        raise EclJsonSerializerError.Create(cUnsupportedDataType);
      end;

      rValue.SetArrayElement(i, rItemValue);
    end;

    AProperty.SetValue(AObject, rValue);
  finally
    DynArrayClear(pArr, AProperty.PropertyType.Handle);
  end;
end;

function TclJsonSerializer.JsonToObject(AObject: TObject; const AJson: string): TObject;
var
  obj: TJSONObject;
begin
  obj := TJSONObject.Create;
  try
    Obj.ParseJSONValue(aJson);
    Result := Deserialize(AObject, obj);
  finally
    obj.Free();
  end;
end;

function TclJsonSerializer.JsonToObject(AType: TClass; const AJson: string): TObject;
var
  obj: TJSONObject;
begin
  obj := TJSONObject.Create;
  try
    Obj.ParseJSONValue(AJson);
    Result := Deserialize(AType, obj);
  finally
    obj.Free();
  end;
end;

function TclJsonSerializer.ObjectToJson(AObject: TObject): string;
var
  json: TclJsonSerializer;
begin
  json := TclJsonSerializer.Create;
  try
    json.Serialize(AObject);
    Result := json.ToString();
  finally
    json.Free();
  end;
end;

function TclJsonSerializer.Deserialize(AType: TClass; const AJson: TJSONObject): TObject;
begin
  Result := nil;
  if (AJson.Count = 0) then Exit;

  Result := AType.Create();
  try
    Result := Deserialize(Result, AJson);
  except
    Result.Free();
    raise;
  end;
end;

function TclJsonSerializer.Deserialize(AObject: TObject; const AJson: TjSONObject): TObject;
var
  ctx: TRttiContext;
  rType: TRttiType;
  rProp: TRttiProperty;
  attr: TCustomAttribute;
  member: TJSONPair;
  rValue: TValue;
  objClass: TClass;
  nonSerializable: Boolean;
begin
  Result := AObject;

  if (AJson.Count = 0) or (Result = nil) then Exit;

  nonSerializable := True;

  rType := ctx.GetType(Result.ClassInfo);

  for rProp in rType.GetProperties() do
  begin
    for attr in rProp.GetAttributes() do
    begin
      if not (attr is TclJsonPropertyAttribute) then Continue;

      nonSerializable := False;

      member := AJson. Values[TclJsonPropertyAttribute(attr).Name];
      if (member = nil) then Break;

      if (rProp.PropertyType.TypeKind = tkDynArray)
        and (member.Value is TJSONArray) then
      begin
        DeserializeArray(rProp, Result, TJSONArray(member.Value));
      end else
      if (rProp.PropertyType.TypeKind = tkClass)
        and (member.Value is TJSONObject) then
      begin
        objClass := rProp.PropertyType.Handle^.TypeData.ClassType;
        rValue := Deserialize(objClass, TJSONObject(member.Value));
        rProp.SetValue(Result, rValue);
      end else
      if (rProp.PropertyType.TypeKind in [tkString, tkLString, tkWString, tkUString]) then
      begin
        rValue := member.ValueString;
        rProp.SetValue(Result, rValue);
      end else
      if (rProp.PropertyType.TypeKind = tkInteger) then
      begin
        rValue := StrToInt(member.ValueString);
        rProp.SetValue(Result, rValue);
      end else
      if (rProp.PropertyType.TypeKind = tkInt64) then
      begin
        rValue := StrToInt64(member.ValueString);
        rProp.SetValue(Result, rValue);
      end else
      if (rProp.PropertyType.TypeKind = tkEnumeration)
        and (rProp.GetValue(Result).TypeInfo = System.TypeInfo(Boolean))
        and (member.Value is TclJSONBoolean) then
      begin
        rValue := TclJSONBoolean(member.Value).Value;
        rProp.SetValue(Result, rValue);
      end else
      begin
        raise EclJsonSerializerError.Create(cUnsupportedDataType);
      end;

      Break;
    end;
  end;

  if (nonSerializable) then
  begin
    raise EclJsonSerializerError.Create(cNonSerializable);
  end;
end;

function TclJsonSerializer.Serialize(AObject: TObject): TclJSONObject;
var
  ctx: TRttiContext;
  rType: TRttiType;
  rProp: TRttiProperty;
  attr: TCustomAttribute;
  nonSerializable: Boolean;
begin
  if (AObject = nil) then
  begin
    Result := nil;
    Exit;
  end;

  nonSerializable := True;

  Result := TJSONObject.Create();
  try
    rType := ctx.GetType(AObject.ClassInfo);
    for rProp in rType.GetProperties() do
    begin
      for attr in rProp.GetAttributes() do
      begin
        if not (attr is TclJsonPropertyAttribute) then Continue;

        nonSerializable := False;

        if (rProp.PropertyType.TypeKind = tkDynArray) then
        begin
          SerializeArray(rProp, AObject, TclJsonPropertyAttribute(attr), Result);
        end else
        if (rProp.PropertyType.TypeKind = tkClass) then
        begin
          Result.AddMember(TclJsonPropertyAttribute(attr).Name, Serialize(rProp.GetValue(AObject).AsObject()));
        end else
        if (rProp.PropertyType.TypeKind in [tkString, tkLString, tkWString, tkUString]) then
        begin
          if (attr is TclJsonStringAttribute) then
          begin
            Result.AddString(TclJsonPropertyAttribute(attr).Name, rProp.GetValue(AObject).AsString());
          end else
          begin
            Result.AddValue(TclJsonPropertyAttribute(attr).Name, rProp.GetValue(AObject).AsString());
          end;
        end else
        if (rProp.PropertyType.TypeKind in [tkInteger, tkInt64]) then
        begin
          Result.AddValue(TclJsonPropertyAttribute(attr).Name, rProp.GetValue(AObject).ToString());
        end else
        if (rProp.PropertyType.TypeKind = tkEnumeration)
          and (rProp.GetValue(AObject).TypeInfo = System.TypeInfo(Boolean)) then
        begin
          Result.AddBoolean(TclJsonPropertyAttribute(attr).Name, rProp.GetValue(AObject).AsBoolean());
        end else
        begin
          raise EclJsonSerializerError.Create(cUnsupportedDataType);
        end;

        Break;
      end;
    end;

    if (nonSerializable) then
    begin
      raise EclJsonSerializerError.Create(cNonSerializable);
    end;
  except
    Result.Free();
    raise;
  end;
end;

procedure TclJsonSerializer.SerializeArray(AProperty: TRttiProperty; AObject: TObject;
  Attribute: TclJsonPropertyAttribute; AJson: TclJsonObject);
var
  rValue: TValue;
  i: Integer;
  arr: TclJSONArray;
begin
  rValue := AProperty.GetValue(AObject);

  if (rValue.GetArrayLength() > 0) then
  begin
    arr := TclJSONArray.Create();
    AJson.AddMember(Attribute.Name, arr);

    for i := 0 to rValue.GetArrayLength() - 1 do
    begin
      if (rValue.GetArrayElement(i).Kind = tkClass) then
      begin
        arr.Add(Serialize(rValue.GetArrayElement(i).AsObject()));
      end else
      if (rValue.GetArrayElement(i).Kind in [tkString, tkLString, tkWString, tkUString]) then
      begin
        if (Attribute is TclJsonStringAttribute) then
        begin
          arr.Add(TclJSONString.Create(rValue.GetArrayElement(i).AsString()));
        end else
        begin
          arr.Add(TclJSONValue.Create(rValue.GetArrayElement(i).AsString()));
        end;
      end else
      if (rValue.GetArrayElement(i).Kind in [tkInteger, tkInt64]) then
      begin
        arr.Add(TclJSONValue.Create(rValue.GetArrayElement(i).ToString()));
      end else
      if (rValue.GetArrayElement(i).Kind = tkEnumeration)
        and (rValue.GetArrayElement(i).TypeInfo = System.TypeInfo(Boolean)) then
      begin
        arr.Add(TclJSONBoolean.Create(rValue.GetArrayElement(i).AsBoolean()));
      end else
      begin
        raise EclJsonSerializerError.Create(cUnsupportedDataType);
      end;
    end;
  end;
end;

end.
