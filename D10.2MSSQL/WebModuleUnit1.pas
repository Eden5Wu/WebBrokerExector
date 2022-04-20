unit WebModuleUnit1;

interface

uses
  DBXCommon, System.SysUtils, System.Classes, Web.HTTPApp, Web.HTTPProd,
  Data.DB, System.StrUtils;

type
  TWebModule1 = class(TWebModule)
    WebFileDispatcher1: TWebFileDispatcher;
    Index: TPageProducer;
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1FetchMainTreeAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure IndexHTMLTag(Sender: TObject; Tag: TTag; const TagString: string;
      TagParams: TStrings; var ReplaceText: string);
    procedure WebModule1DeptActionAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1DeptAppendActionAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1DeptEditActionAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1DetpDestoryActionAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1EmpActionAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1EmpAppendActionAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1EmpEditActionAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1EmpDestoryActionAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const CT_JSON = 'application/json';

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

uses
  DataModuleUnit, Data.DBXDBReaders, Data.DBXJSONCommon, EdenDBXJsonHelper,
  System.JSON;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TWebModule1.IndexHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if SameText(TagString, 'urlpath') then
    ReplaceText := string(Request.InternalScriptName)
  else if SameText(TagString, 'port') then
    ReplaceText := IntToStr(Request.ServerPort)
  else if SameText(TagString, 'host') then
    ReplaceText := string(Request.Host)
end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>Web Server Application</title></head>' +
    '<body>Web Server Application</body>' +
    '</html>';
end;

procedure TWebModule1.WebModule1DeptActionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  LDM: TDataModule1;
  LReader: TDBXReader;
  LResObj: TJSONObject;
  LJsonRows: TJSONArray;
  LPage, LRows, LOffset, LTotal: Integer;
begin
  LPage := StrToIntDef(Request.ContentFields.Values['page'], 1);
  LRows := StrToIntDef(Request.ContentFields.Values['rows'], 10);
  LOffset := (LPage-1) * LRows;
  LDM := TDataModule1.Create(Self);
  LDM.SQLQuery1.SQL.Text := 'SELECT count(*) FROM dept';
  LDM.SQLQuery1.Open;
  LTotal := LDM.SQLQuery1.Fields[0].AsInteger;
  LDM.SQLQuery1.Close;

  LDM.SQLQuery1.SQL.Text := 'SELECT * FROM dept ORDER BY DEPT_ID OFFSET '
    + IntToStr(LOffset) + ' ROWS '
    + 'FETCH NEXT ' + IntToStr(LRows) + ' ROWS ONLY ';
  LDM.SQLQuery1.Open;
  LReader := TDBXDataSetReader.Create(LDM.SQLQuery1);
  LJsonRows := TDBXJSONTools.TableToJSONArray(LReader);

  LResObj := TJSONObject.Create;
  LResObj.AddPair('total', TJSONNumber.Create(LTotal));
  LResObj.AddPair('rows', LJsonRows);
  Response.Content :=  LResObj.ToJson;
  LResObj.Free;
  LDM.Free;
end;

procedure TWebModule1.WebModule1DeptAppendActionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  if SameStr(Request.ContentFields.Values['isNewRecord'], 'true') then
  begin
    with TDataModule1.Create(nil) do
    begin
      SQLQuery1.SQL.Text := 'SELECT TOP 0 DEPT_ID, DEPT_NAM FROM dept';
      try
        ClientDataSet1.Open;
        ClientDataSet1.Append;
        ClientDataSet1.Fields[0].AsString := Request.ContentFields.Values['DEPT_ID'];
        ClientDataSet1.Fields[1].AsString := Request.ContentFields.Values['DEPT_NAM'];
        ClientDataSet1.Post;
        if ClientDataSet1.ChangeCount > 0 then
          ClientDataSet1.ApplyUpdates(0);
        with TDBXJSONTools.DataSetRecToJSONObj(ClientDataSet1) do
        begin
          Response.ContentType := CT_JSON;
          Response.Content := ToJson;
          Free;
        end;
        ClientDataSet1.Close;
      finally
        Free;
      end;
    end;
  end;
end;

procedure TWebModule1.WebModule1DeptEditActionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  with TDataModule1.Create(nil) do
  begin
    SQLQuery1.SQL.Text := 'SELECT DEPT_ID, DEPT_NAM FROM dept WHERE DEPT_ID=:DEPT_ID';
    SQLQuery1.Params[0].AsString := Request.ContentFields.Values['DEPT_ID'];
    try
      ClientDataSet1.Open;
      if not ClientDataSet1.IsEmpty then
      begin
        ClientDataSet1.Edit;
        ClientDataSet1.Fields[1].AsString := Request.ContentFields.Values['DEPT_NAM'];
        ClientDataSet1.Post;
        if ClientDataSet1.ChangeCount > 0 then
          ClientDataSet1.ApplyUpdates(0);
        with TDBXJSONTools.DataSetRecToJSONObj(ClientDataSet1) do
        begin
          Response.ContentType := CT_JSON;
          Response.Content := ToJson;
          Free;
        end;
        ClientDataSet1.Close;
      end;
    finally
      Free;
    end;
  end;
end;

procedure TWebModule1.WebModule1DetpDestoryActionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  LResObj: TJSONObject;
begin
  with TDataModule1.Create(nil) do
  begin
    SQLQuery1.SQL.Text := 'DELETE FROM dept WHERE DEPT_ID=:DEPT_ID';
    SQLQuery1.Params[0].AsString := Request.ContentFields.Values['id'];
    try
      SQLQuery1.ExecSQL();
      if SQLQuery1.RowsAffected > 0 then
        LResObj := TJSONObject.Create(TJSONPair.Create('success', TJSONTrue.Create))
      else
        LResObj := TJSONObject.Create(TJSONPair.Create('success', TJSONFalse.Create));
      Response.ContentType := CT_JSON;
      Response.Content := LResObj.ToJson;
      LResObj.Free;
    finally
      Free;
    end;
  end;
end;

procedure TWebModule1.WebModule1EmpActionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  LDM: TDataModule1;
  LReader: TDBXReader;
  LResObj: TJSONObject;
  LJsonRows: TJSONArray;
   LRows, LOffset, LTotal: Integer;
begin
  LRows := StrToIntDef(Request.ContentFields.Values['take'], 20);
  LOffset := StrToIntDef(Request.ContentFields.Values['skip'], 0);
  LDM := TDataModule1.Create(Self);
  LDM.SQLQuery1.SQL.Text := 'SELECT count(*) FROM emp';
  LDM.SQLQuery1.Open;
  LTotal := LDM.SQLQuery1.Fields[0].AsInteger;
  LDM.SQLQuery1.Close;

  LDM.SQLQuery1.SQL.Text := 'SELECT * FROM emp ORDER BY DEPT_ID OFFSET '
    + IntToStr(LOffset) + ' ROWS '
    + 'FETCH NEXT ' + IntToStr(LRows) + ' ROWS ONLY ';
  LDM.SQLQuery1.Open;
  LReader := TDBXDataSetReader.Create(LDM.SQLQuery1);
  LJsonRows := TDBXJSONTools.TableToJSONArray(LReader);

  LResObj := TJSONObject.Create;
  LResObj.AddPair('totalCount', TJSONNumber.Create(LTotal));
  LResObj.AddPair('data', LJsonRows);
  Response.Content :=  LResObj.ToJson;
  LResObj.Free;
  LDM.Free;
end;

procedure TWebModule1.WebModule1EmpAppendActionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  LFieldPos: Integer;
  LEmpJson: TJSONObject;
begin
    LEmpJson := TJSONObject.ParseJSONValue(Request.Content).AsJsonObject;

    with TDataModule1.Create(nil) do
    begin
      SQLQuery1.SQL.Text := 'SELECT count(*) FROM emp WHERE EMP_ID=:EMP_ID';
      SQLQuery1.Params[0].AsString := LEmpJson.GetValue('EMP_ID').Value;
      SQLQuery1.Open;
      if SQLQuery1.Fields[0].AsInteger > 0 then
      begin
        Response.Content := '員工編號重複，請重新輸入';
        Exit;
      end;

      SQLQuery1.SQL.Text := 'SELECT TOP 0 * FROM emp';
      try
        ClientDataSet1.Open;
        ClientDataSet1.Append;
        for LFieldPos := 0 to LEmpJson.Count-1 do
          ClientDataSet1.FieldByName(LEmpJson.Pairs[LFieldPos].JsonString.Value).Value := LEmpJson.Pairs[LFieldPos].JsonValue.Value;
        ClientDataSet1.Post;
        if ClientDataSet1.ChangeCount > 0 then
          ClientDataSet1.ApplyUpdates(0);
        ClientDataSet1.Close;
        Response.Content := '1';
      finally
        LEmpJson.Free;
        Free;
      end;
    end;
end;

procedure TWebModule1.WebModule1EmpDestoryActionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  with TDataModule1.Create(nil) do
  begin
    SQLQuery1.SQL.Text := 'DELETE FROM emp WHERE EMP_ID=:EMP_ID';
    SQLQuery1.Params[0].AsString := Request.QueryFields.Values['key'];
    try
      SQLQuery1.ExecSQL();
      { TODO : 刪除前檢查 }
      if SQLQuery1.RowsAffected > 0 then
        Response.Content := '1';
    finally
    end;
  end;
end;

procedure TWebModule1.WebModule1EmpEditActionAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  LFieldPos: Integer;
  LEmpJson: TJSONObject;
begin
  LEmpJson := TJSONObject.ParseJSONValue(Request.Content).AsJsonObject;
  with TDataModule1.Create(nil) do
  begin
    SQLQuery1.SQL.Text := 'SELECT * FROM emp WHERE EMP_ID=:EMP_ID';
    SQLQuery1.Params[0].AsString := Request.QueryFields.Values['key'];
    try
      ClientDataSet1.Open;
      if not ClientDataSet1.IsEmpty then
      begin
        ClientDataSet1.Edit;
        for LFieldPos := 0 to LEmpJson.Count-1 do
        begin
          if SameStr(LEmpJson.Pairs[LFieldPos].JsonString.Value, 'EMP_ID') then
            Continue;
          ClientDataSet1.FieldByName(LEmpJson.Pairs[LFieldPos].JsonString.Value).Value := LEmpJson.Pairs[LFieldPos].JsonValue.Value;
        end;
        ClientDataSet1.Post;
        if ClientDataSet1.ChangeCount > 0 then
          ClientDataSet1.ApplyUpdates(0);
        ClientDataSet1.Close;
        Response.Content := '1';
      end;
    finally
      LEmpJson.Free;
      Free;
    end;
  end;
end;

procedure TWebModule1.WebModule1FetchMainTreeAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.ContentType := 'application/json';
  Response.Content := '[{"id": 1,"text": "Node 1","state": "closed",'
        +'"children": [{"id": 11,"text": "Node 11"},{"id": 12,"text": "Node 12"}]},'
        +'{"id": 2,"text": "Node 2","state": "closed"}]';
end;

end.
