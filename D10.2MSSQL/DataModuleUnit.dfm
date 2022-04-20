object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 308
  Width = 395
  object SQLConnection1: TSQLConnection
    ConnectionName = 'HR'
    DriverName = 'DevartSQLServer'
    Params.Strings = (
      'DriverName=DevartSQLServer'
      'SchemaOverride=%.dbo'
      'DriverUnit=DBXDevartSQLServer'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DBXCommonDriver210.' +
        'bpl'
      
        'MetaDataPackageLoader=TDBXDevartMSSQLMetaDataCommandFactory,DbxD' +
        'evartSQLServerDriver210.bpl'
      'ProductName=DevartSQLServer'
      'LibraryName=dbexpsda40.dll'
      'VendorLib=sqloledb.dll'
      'LibraryNameOsx=libdbexpsda40.dylib'
      'VendorLibOsx=sqloledb.dylib'
      'Port=1433'
      'LocaleCode=0000'
      'IsolationLevel=ReadCommitted'
      'MaxBlobSize=-1'
      'LongStrings=True'
      'EnableBCD=True'
      'FetchAll=True'
      'ParamPrefix=False'
      'UseUnicode=True'
      'IPVersion=IPv4'
      'UseQuoteChar=True'
      'HostName='
      'Database='
      'User_Name='
      'Password=')
    Left = 88
    Top = 56
  end
  object SQLQuery1: TSQLQuery
    GetMetadata = True
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 88
    Top = 112
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = SQLQuery1
    Left = 88
    Top = 168
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 88
    Top = 224
  end
end
