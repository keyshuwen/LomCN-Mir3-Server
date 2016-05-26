unit Mir3.Forms.Main.System;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, System.Win.ScktComp,
  System.IniFiles,

  Mir3.Server.Core, Mir3.Forms.IDServer.Client, Mir3.Server.RunSocket,
  Mir3.Server.FrontEngine, Mir3.Server.UserEngine, Mir3.Server.Environment,
  Mir3.Server.UserManagerEngine, Mir3.Server.ItemUnit, Mir3.Forms.Inter.Message.Client;

type
  TFrmMain = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    LbServerVersion: TLabel;
    SpeedButton1: TSpeedButton;
    LbRunTime: TLabel;
    LbUserCount: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    LbTimeCount: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Timer1: TTimer;
    RunTimer: TTimer;
    Label3: TLabel;
    ConnectTimer: TTimer;
    StartTimer: TTimer;
    TCloseTimer: TTimer;
    LogUdp: TIdUDPClient;
    GateSocket: TServerSocket;
    DBSocket: TClientSocket;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1DblClick(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure RunTimerTimer(Sender: TObject);
    procedure ConnectTimerTimer(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);
    procedure TCloseTimerTimer(Sender: TObject);
    procedure DBSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure GateSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure GateSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure GateSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  private
    procedure MakeStoneMines;
  public
    procedure StartServer;
  end;

var
  FrmMain        : TFrmMain;
  GRunSocket     : TRunSocket;
  GItemUnit      : TItemUnit;
  GUserEngine    : TUserEngine;
  GEnvirnoment   : TEnvirList;
  GFrontEngine   : TFrontEngine;
  GUserMgrEngine : TUserMgrEngine;

implementation

{$R *.dfm}

uses Mir3.Forms.Local.DB, Mir3.Server.Events, Mir3.Server.Constants;

{$REGION ' - Form Section '}
  procedure TFrmMain.FormCreate(Sender: TObject);
  var
    FSetupFileName : String;
    FIniFile       : TIniFile;
  begin

    GRunSocket     := TRunSocket.Create;
    GItemUnit      := TItemUnit.Create;
    GEnvirnoment   := TEnvirList.Create;
    GFrontEngine   := TFrontEngine.Create;
    GUserEngine    := TUserEngine.Create;
    GUserMgrEngine := TUserMgrEngine.Create;

    (* Setup Ini Init *)

    {$REGION ' - INI Loading... '}

    Memo1.Lines.Add ('ready to load ini file..');
    FSetupFileName := ExtractFilePath(ParamStr(0)) + '\Setup\Setup.ini';
    if FileExists(FSetupFileName) then
    begin
      FIniFile := TIniFile.Create(FSetupFileName);
      if FIniFile <> nil then
      begin
        with FIniFile do
        begin
          (* Server *)
          GServerIndex      := ReadInteger('Server', 'ServerIndex' , 0);
          GServerName       := ReadString('Server' , 'ServerName'  , 'MIR3_LomCN');
          GServerNumber     := ReadInteger('Server', 'ServerNumber', 0);
          GTestServer       := Boolean(ReadInteger('Server','TestServer' , 0));
          GServiceMode      := Boolean(ReadInteger('Server','ServiceMode', 1));
          GTestLevel        := ReadInteger('Server', 'TestLevel'         , 1);
          GTestGold         := ReadInteger('Server', 'TestGold'          , 1500);
          GNonPKServer      := Boolean(ReadInteger('Server','NonPKServer', 0));
          GViewHackMessage  := Boolean(ReadInteger('Server','ViewHackMessage', 0));
          GEmergencyMap     := ReadInteger('Server', 'EmergencyMap' , 0);
          GEmergencyX       := ReadInteger('Server', 'EmergencyX'   , 100);
          GEmergencyY       := ReadInteger('Server', 'EmergencyY'   , 100);
          GHomeMap0         := ReadInteger('Server', 'HomeMap0'     , 0);     //Warrior Home
          GHomeX0           := ReadInteger('Server', 'HomeX0'       , 100);
          GHomeY0           := ReadInteger('Server', 'HomeY0'       , 100);
          GHomeMap1         := ReadInteger('Server', 'HomeMap1'     , 0);     //Wizard Home
          GHomeX1           := ReadInteger('Server', 'HomeX1'       , 100);
          GHomeY1           := ReadInteger('Server', 'HomeY1'       , 100);
          GHomeMap2         := ReadInteger('Server', 'HomeMap2'     , 0);     //Taoist Home
          GHomeX2           := ReadInteger('Server', 'HomeX2'       , 100);
          GHomeY2           := ReadInteger('Server', 'HomeY2'       , 100);
          GHomeMap3         := ReadInteger('Server', 'HomeMap3'     , 0);     //Assassin Home
          GHomeX3           := ReadInteger('Server', 'HomeX3'       , 100);
          GHomeY3           := ReadInteger('Server', 'HomeY3'       , 100);
          GSqlDBLoc         := ReadString('Server' , 'SqlDBLoc'     , '127.0.0.1');
          GSqlDBID          := ReadString('Server' , 'SqlDBID'      , 'sa');
          GSqlDBPassword    := ReadString('Server' , 'SqlDBPassword', '');
          GSqlDBDSN         := ReadString('Server' , 'SqlDBDSN'     , '');
          GDBAddr           := ReadString('Server' , 'DBAddr'       , '127.0.0.1');
          GDBPort           := ReadInteger('Server', 'DBPort'       , 9000);
          GHumLimit         := ReadInteger('Server', 'HumLimit'     , 10);
          GMonLimit         := ReadInteger('Server', 'MonLimit'     , 10);
          GZenLimit         := ReadInteger('Server', 'ZenLimit'     , 10);
          GNpcLimit         := ReadInteger('Server', 'NpcLimit'     , 10);
          GSocLimit         := ReadInteger('Server', 'SocLimit'     , 10);
          GMaxOpenStack     := ReadInteger('Server', 'MaxOpenStack' , 2000);
          GMaxSaveStack     := ReadInteger('Server', 'MaxSaveStack' , 2000);
          GUserFull         := ReadInteger('Server', 'UserFull'     , 3000);
          GZenFastStep      := ReadInteger('Server', 'ZenFastStep'  , 400);
          GMsgSrvAddr       := ReadString('Server' , 'MsgSrvAddr'   , '127.0.0.1');
          GMsgSrvPort       := ReadInteger('Server', 'MsgSrvPort'   , 4900);
          GLogServerAddr    := ReadString('Server' , 'LogServerAddr', '127.0.0.1');
          GLogServerPort    := ReadInteger('Server', 'LogServerPort', 10000);
          (* Share *)
          GDir_Guild        := ReadString('Share' , 'GuildDir'    , '.\GuildBase\Guilds\');
          GFile_Guild       := ReadString('Share' , 'GuildFile'   , '.\GuildBase\Guildlist.txt');
          GConLogDir        := ReadString('Share' , 'ConLogDir'   , '.\ShareL\conlog\');
          GDir_Envir        := ReadString('Share' , 'EnvirDir'    , '.\Envir\');
          GDir_Map          := ReadString('Share' , 'MapDir'      , '.\Map\');
          GBlanceLogDir     := ReadString('Share' , 'BlanceLogDir', '.\Share\');

          Memo1.Lines.Add ('Setup.ini loaded..');
        end;
      end;
      FIniFile.Free;
    end else ShowMessage('Setup\Setup.ini not found. fatal error..');

    (* EventSetup Ini Init *)

    FSetupFileName := ExtractFilePath(ParamStr(0)) + '\Setup\EventSetup.ini';
    if FileExists(FSetupFileName) then
    begin
      FIniFile := TIniFile.Create(FSetupFileName);
      if FIniFile <> nil then
      begin
        with FIniFile, GEventSetupInfo do
        begin
          (* Event *)
          ExtraExp1       := ReadInteger('EVENT', 'ExtraExp1', 0);
          ExtraLowLevel1  := ReadInteger('EVENT', 'ExtraLowLevel1', 0);
          ExtraHighLevel1 := ReadInteger('EVENT', 'ExtraHighLevel1', 0);
          ExtraLowLevel2  := ReadInteger('EVENT', 'ExtraLowLevel2', 0);
          ExtraHighLevel2 := ReadInteger('EVENT', 'ExtraHighLevel2', 0);
          ExtraLowLevel3  := ReadInteger('EVENT', 'ExtraLowLevel3', 0);
          ExtraHighLevel3 := ReadInteger('EVENT', 'ExtraHighLevel3', 0);
          ExtraMoneyPer   := ReadInteger('EVENT', 'ExtraMoneyPer', 0);
          ExtraItemPer    := ReadInteger('EVENT', 'ExtraItemPer', 0);
          GoldDrop        := ReadInteger('EVENT', 'GoldDrop', 0);
          ExtraLowDC      := ReadInteger('EVENT', 'ExtraLowDC', 0);
          ExtraHighDC     := ReadInteger('EVENT', 'ExtraHighDC', 0);
          ExtraLowMC      := ReadInteger('EVENT', 'ExtraLowMC', 0);
          ExtraHighMC     := ReadInteger('EVENT', 'ExtraHighMC', 0);
          ExtraHighSC     := ReadInteger('EVENT', 'ExtraHighSC', 0);
          ExtraPW         := ReadInteger('EVENT', 'ExtraPW', 0);
          ExtraLowAC      := ReadInteger('EVENT', 'ExtraLowAC', 0);
          ExtraHighAC     := ReadInteger('EVENT', 'ExtraHighAC', 0);
          ExtraLowMAC     := ReadInteger('EVENT', 'ExtraLowMAC', 0);
          ExtraHighMAC    := ReadInteger('EVENT', 'ExtraHighMAC', 0);
          ExtraLUCK       := ReadInteger('EVENT', 'ExtraLUCK', 0);
          ExtraMAXHP      := ReadInteger('EVENT', 'ExtraMAXHP', 0);
          ExtraMAXMP      := ReadInteger('EVENT', 'ExtraMAXMP', 0);
          NoDelayRun      := Boolean(ReadInteger('EVENT', 'NoDelayRun', 0));
          ExtraMonGenRate := ReadInteger('EVENT', 'ExtraMonGenRate', 0);
          TrialLevel      := ReadInteger('EVENT', 'TrialLevel', 1);
          ServerUserLimit := ReadInteger('EVENT', 'ServerUserLimit', 1);
        end;
        Memo1.Lines.Add ('EventSetup.ini loaded..');
      end;
      FIniFile.Free;
    end else ShowMessage('Setup\EventSetup.ini not found. fatal error..');

    (* TestMode Ini Init *)

    FSetupFileName := ExtractFilePath(ParamStr(0)) + '\Setup\TestMode.ini';
    if FileExists(FSetupFileName) then
    begin
      FIniFile := TIniFile.Create(FSetupFileName);
      if FIniFile <> nil then
      begin
        with FIniFile, GTestMode do
        begin
          (* Mode *)
          TestServer := Boolean(ReadInteger('MODE', 'TestServer', 0));
          FreeMode   := Boolean(ReadInteger('MODE', 'FreeMode'  , 0));
        end;
        Memo1.Lines.Add ('TestMode.ini loaded..');
      end;
      FIniFile.Free;
    end else ShowMessage('Setup\TestMode.ini not found. fatal error..');

    {$ENDREGION}


    Caption                 := GServerName + ' [ ' + DateToStr(Date) + ' - ' + TimeToStr(Time) + ' ]';
    LbServerVersion.Caption := GServerVersion;

    ConnectTimer.Enabled    := True;
    GServerRunTime          := GetTickCount;
    StartTimer.Enabled      := True;
    Timer1.Enabled          := True;
  end;

  procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  begin
    //
  end;

  procedure TFrmMain.FormDestroy(Sender: TObject);
  begin
    //
  end;
{$ENDREGION}

{$REGION ' - GateSocket Events '}
  procedure TFrmMain.GateSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
  begin
    GRunSocket.Connect(Socket);
  end;

  procedure TFrmMain.GateSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  begin
    GRunSocket.Disconnect(Socket);
  end;

  procedure TFrmMain.GateSocketClientError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  begin
    GRunSocket.SocketError(Socket, ErrorCode);
  end;

  procedure TFrmMain.GateSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
  begin
    GRunSocket.SocketRead(Socket);
  end;
{$ENDREGION}

{$REGION ' - DBSocket Events   '}
  procedure TFrmMain.DBSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
  begin
   //
  end;

  procedure TFrmMain.DBSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
  begin
   //
  end;

  procedure TFrmMain.DBSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
  var
    FErrorMessage : String;
  begin
    try
      FErrorMessage := 'DBSocket Error Code = ' + IntToStr(ErrorCode);
      Memo1.Lines.Add(FErrorMessage);
      ServerLogMessage(FErrorMessage);
      ErrorCode := 0;
      Socket.Close;
    finally

    end;
  end;

  procedure TFrmMain.DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);
  begin
    //
  end;
{$ENDREGION}

{$REGION ' - Timer Section '}
  procedure TFrmMain.Timer1Timer(Sender: TObject);
  begin
    try


    except
      ServerLogMessage('Exception...');
    end;
  end;

  procedure TFrmMain.RunTimerTimer(Sender: TObject);
  begin
    //
  end;

  procedure TFrmMain.ConnectTimerTimer(Sender: TObject);
  begin //
    try
      //DBSocket

      DBSocket.Active := True;
    except

    end;
  end;

  procedure TFrmMain.StartTimerTimer(Sender: TObject);
  var
    FError : Integer;
  begin
    StartTimer.Enabled := False;
    try

      (* Begin Load Mini Map *)
      Memo1.Lines.Add('loading MiniMap.txt...');
      FError := FrmDB.LoadMiniMapInfos;
      if FError < 0 then
      begin
        ShowMessage('Read error (MiniMap.txt). code=' + IntToStr(FError));
        close;
        exit;
      end else Memo1.Lines.Add('MiniMap information loaded.');


      (* Begin Load Map Files *)
      Memo1.Lines.Add('loading MapFiles...');
      FError := FrmDB.LoadMapFiles;
      if FError < 0 then
      begin
        ShowMessage('Read error (Map Files). code=' + IntToStr(FError));
        close;
        exit;
      end else Memo1.Lines.Add('Mapfile loaded.');


      (* Begin Load Mon AI *)
      Memo1.Lines.Add('loading MonAIs.txt...');
      FError := FrmDB.LoadMonAI;
      if FError < 0 then
      begin
        ShowMessage('Read error (MonAIs.txt). code=' + IntToStr(FError));
        close;
        exit;
      end else Memo1.Lines.Add('MonAIs.txt loaded.');


      (* Begin Load Mon Gen *)
      Memo1.Lines.Add ('loading MonGen.txt...');
      FError := FrmDB.LoadMonGen;
      if FError < 0 then
      begin
        ShowMessage('Read error (MonGen.txt). code=' + IntToStr(FError));
        close;
        exit;
      end else Memo1.Lines.Add('MonGen.txt loaded.');


      (* Begin Load Map Quests *)
      Memo1.Lines.Add ('loading MapQuest.txt...');
      FError := FrmDB.LoadMapQuest;
      if FError < 0 then
      begin
        ShowMessage ('Read error (MapQuest.txt). code=' + IntToStr(FError));
        close;
        exit;
      end else Memo1.Lines.Add('Map Quest information loaded.');


      (* Begin Load Admin List *)
      Memo1.Lines.Add ('loading AdminList.txt...');
      FError := FrmDB.LoadAdminFile;
      if FError <= 0 then
      begin
        Memo1.Lines.Add('Error : AdminList loading failure...');
      end else Memo1.Lines.Add('AdminList loaded..');

      if GServerIndex = 0 then
      begin
        //FrmSrvMsg.Initialize;
      end else begin
        FrmMsgClient.Initialize;
      end;


    except
      ServerLogMessage('Start Timer Exception...');
    end;
  end;

  procedure TFrmMain.TCloseTimerTimer(Sender: TObject);
  begin
    //
  end;
{$ENDREGION}

procedure TFrmMain.Memo1DblClick(Sender: TObject);
begin
  //
end;

procedure TFrmMain.Panel1DblClick(Sender: TObject);
begin
  //
end;

procedure TFrmMain.SpeedButton1Click(Sender: TObject);
begin
  try
    FrmIDSoc.Timer1Timer(Self);
    if (GServerIndex <> 0) then
    begin
      if (FrmMsgClient.MsgClient.Port = 0) then
      begin
        FrmMsgClient.MsgClient.Active := True;
      end;
    end;
  finally
  end;
end;

procedure TFrmMain.StartServer;
var
  FError : Integer;
begin
  try
    FrmIDSoc.Initialize;
    Memo1.Lines.Add('IDSoc Initialized..');

    GEnvirnoment.InitEnvironment;
    Memo1.Lines.Add('GEnvirnoment loaded..');

    MakeStoneMines;
    Memo1.Lines.Add('MakeStoneMines...');

    FError := FrmDB.LoadMerchants;
    if FError < 0 then
    begin
      ShowMessage ('merchant.txt' + ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
    end;

  except
    ServerLogMessage('Startserver exception..');
  end;
end;

procedure TFrmMain.MakeStoneMines;
var
  I      : Integer;
  X, Y   : Integer;
  FEvent : TStoneMineEvent;
  FEnvir : TEnvironment;
begin
  for I := 0 to GEnvirnoment.Count-1 do
  begin
    FEvent := nil;
    FEnvir := TEnvironment(GEnvirnoment[i]);
    if (maMine in FEnvir.Attributes) then
    begin
      for X := 0 to FEnvir.MapWidth-1 do
      begin
        for Y := 0 to FEnvir.MapHeight-1 do
        begin
          if (maMine in FEnvir.Attributes) then
          begin
            FEvent := TStoneMineEvent.Create(FEnvir, X, Y, EVENT_MINE);
          end;

          if (maMine2 in FEnvir.Attributes) then
          begin
            FEvent := TStoneMineEvent.Create(FEnvir, X, Y, EVENT_MINE2);
          end;

          if (maMine3 in FEnvir.Attributes) then
          begin
            FEvent := TStoneMineEvent.Create(FEnvir, X, Y, EVENT_MINE3);
          end;

          if (FEvent <> nil) and FEvent.IsAddToMap = False then
          begin
            FEvent.Free;
            FEvent := nil;
          end;
        end;
      end;
    end;
  end;
end;

end.
