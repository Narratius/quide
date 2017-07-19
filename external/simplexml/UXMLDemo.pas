unit UXMLDemo;
{
 Copyright (C) 2009 Samuel Soldat <samuel.soldat@audio-data.de>

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, SimpleXML;

type
  TMainForm = class(TForm)
    TreeView: TTreeView;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    QuitMenu: TMenuItem;
    N1: TMenuItem;
    Druckereinrichtung1: TMenuItem;
    PrintMenu: TMenuItem;
    N2: TMenuItem;
    SaveAsFileMenu: TMenuItem;
    MSaveFileMenu: TMenuItem;
    N3: TMenuItem;
    CloseFileMenu: TMenuItem;
    OpenFileMenu: TMenuItem;
    NewFileMenu: TMenuItem;
    Splitter1: TSplitter;
    Panel1: TPanel;
    AttributMemo: TMemo;
    Splitter2: TSplitter;
    ValueMemo: TMemo;
    OpenDialog: TOpenDialog;
    StatusBar: TStatusBar;
    procedure OpenFileMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure MSaveFileMenuClick(Sender: TObject);
    procedure QuitMenuClick(Sender: TObject);
  private
    FFilename: String;
    XmlDocument: IXmlDocument;
    procedure DoOpenFile(const Filename: String);
    procedure CreateTreeView;
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.CreateTreeView;
  procedure AddNodes(Child: TTreeNode; aNode: IXmlNode);
  var
    i: Integer;
    XmlNodeList: IXmlNodeList;
  begin
    Child := TreeView.Items.AddChildObject(Child, aNode.NodeName, Pointer(aNode));
    XmlNodeList := aNode.ChildNodes;
    for i:=0 to XmlNodeList.Count-1 do
    begin
      AddNodes(Child, XmlNodeList.Item[i]);
    end;
  end;
begin
  TreeView.Items.BeginUpdate;
  try
    TreeView.Items.Clear;
    AddNodes(nil, XmlDocument);
    TreeView.Items.GetFirstNode.Expand(false);
  finally
    TreeView.Items.EndUpdate;
  end;
end;

procedure TMainForm.DoOpenFile(const Filename: String);
begin
  AttributMemo.Clear;
  ValueMemo.Clear;
  FFilename := Filename;
  Caption := Filename + ' - ' + Application.Title;
  XmlDocument := LoadXmlDocument(Filename);
  CreateTreeView;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
end;

procedure TMainForm.MSaveFileMenuClick(Sender: TObject);
begin
  XmlDocument.Save(FFilename);
end;

procedure TMainForm.OpenFileMenuClick(Sender: TObject);
begin
  if OpenDialog.Execute
  then begin
    DoOpenFile(OpenDialog.FileName);
  end;
end;

procedure TMainForm.QuitMenuClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.TreeViewChange(Sender: TObject; Node: TTreeNode);
var
  i: Integer;
  aNode: IXmlNode;
begin
  if Node.Data<>nil
  then begin
    aNode := IXmlNode(Node.Data);
    Statusbar.Panels[0].Text := aNode.FullPath;
    AttributMemo.Lines.BeginUpdate;
    try
      AttributMemo.Lines.Clear;
      for i:=0 to aNode.AttrCount-1 do
      begin
        AttributMemo.Lines.Add(aNode.AttrNames[i] + '=' + aNode.NeedAttr(aNode.AttrNameIDs[i]));
      end;
    finally
      AttributMemo.Lines.EndUpdate;
    end;
    ValueMemo.Lines.BeginUpdate;
    try
      ValueMemo.Text := aNode.Text
    finally
      ValueMemo.Lines.EndUpdate;
    end;
  end;
end;

end.
