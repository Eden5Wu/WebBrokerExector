program DWebHR;
{$APPTYPE GUI}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  FormUnit1 in 'FormUnit1.pas' {Form1},
  WebModuleUnit1 in 'WebModuleUnit1.pas' {WebModule1: TWebModule},
  DataModuleUnit in 'DataModuleUnit.pas' {DataModule1: TDataModule},
  EdenDBXJSONConsts in 'EdenDBXJSONConsts.pas',
  EdenDBXJsonHelper in 'EdenDBXJsonHelper.pas',
  Iso8601Unit in 'Iso8601Unit.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  {$WARN SYMBOL_PLATFORM OFF}
  ReportMemoryLeaksOnShutdown := DebugHook<>0;  //Debug Memory Leak
  {$WARN SYMBOL_PLATFORM ON}
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
