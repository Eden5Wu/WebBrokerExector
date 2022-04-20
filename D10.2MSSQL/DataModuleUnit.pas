unit DataModuleUnit;

interface

uses
  Data.DBXCommon,
  MidasLib,
  ActiveX,
  System.SysUtils, System.Classes, DBXDevartSQLServer, Data.FMTBcd,
  Datasnap.DBClient, Datasnap.Provider, Data.DB, Data.SqlExpr;

type
  TDataModule1 = class(TDataModule)
    SQLConnection1: TSQLConnection;
    SQLQuery1: TSQLQuery;
    DataSetProvider1: TDataSetProvider;
    ClientDataSet1: TClientDataSet;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  CoInitialize(nil);
  SQLConnection1.Params.Values[TDBXPropertyNames.HostName] := '.\SQLEXPRESS';
  SQLConnection1.Params.Values[TDBXPropertyNames.Database] := 'EdenHR';
  SQLConnection1.Params.Values[TDBXPropertyNames.UserName] := '';
  SQLConnection1.Params.Values[TDBXPropertyNames.Password] := '';
end;

procedure TDataModule1.DataModuleDestroy(Sender: TObject);
begin
  CoUninitialize;
end;

end.
