unit Mir3.Objects.Base;

interface  //5 Classes

uses System.SysUtils, System.Classes, Mir3.Server.Core, Mir3.Server.Constants;

type

  (* base class TCreature *)

  TCreature = class
  private
    FMapName        : String;
    FUserName       : String;
    FHomeMap0       : String;   //Home Warrior
    FHomeMap1       : String;   //Home Wizard
    FHomeMap2       : String;   //Home Taoist
    FHomeMap3       : String;   //Home Assassin
    FDirection      : Byte;
    FGender         : Byte;
    FJob            : Byte;     //0: Warrior 1: Wizard 2: Taoist 3:Assassin
    FLifeAttribute  : Byte;
    FCoolEye        : Byte;
    FAntiMagic      : Byte;
    FSpeedPoint     : Byte;
    FAccuracyPoint  : Byte;
    FRaceServer     : Word;
    FRaceImage      : Word;
    FHair           : Word;
    FAppearance     : Word;
    FCX             : Integer;
    FCY             : Integer;
    FHomeX0         : Integer;
    FHomeY0         : Integer;
    FHomeX1         : Integer;
    FHomeY1         : Integer;
    FHomeX2         : Integer;
    FHomeY2         : Integer;
    FHomeX3         : Integer;
    FHomeY3         : Integer;
    FCharStatus     : Integer;
    FCharStatusEx   : Integer;
    FViewRange      : Integer;
    FMeatQuality    : Integer;
    FFightExp       : Integer;
    FAntiPush       : Integer;
    FAntiUndead     : Integer;
    FSizeRate       : Integer;
    FAntiStop       : Integer;
    FNextWalkTime   : Integer;
    FWalkStep       : Integer;
    FWalkWaitTime   : Integer;
    FNextHitTime    : Integer;
    FTame           : Integer;
    FBodyLuckLevel  : Integer;
    FGhostTime      : Cardinal;
    FGold           : Int64;
    FGhost          : Boolean;
    FDeath          : Boolean;
    FHoldPlace      : Boolean;
    FAnimal         : Boolean;
    FSkeleton       : Boolean;
    FHideMode       : Boolean;
    FSuperviserMode : Boolean;
    FViewFixedHide  : Boolean;
    FErrorOnInit    : Boolean;
    FBodyLuck       : Real;
    FItemList       : TList;
    FMagicList      : TList;
    FEnvironment    : TObject;
    FAbility        : TAbility;
    FWAbility       : TAbility;
    FStatus_Array   : array[0..MIR3_STATUS_ARRAY_SIZE-1] of Word;
  public
    constructor Create;
    destructor Destroy; override;
  public
    procedure DropUseItems(AItemOwnerShip: TObject; ADieFromMob : Boolean);
    procedure Initialize;
    procedure InitValues;
    procedure SetAbility(AValue: TAbility);
    procedure SetWAbility(AValue: TAbility);
    function Appear: Boolean;
    procedure AddBodyLuck(AValue: Real);
    function GetCharStatus: Integer;
  public
    procedure SendRefMsg(AMessage, WParam: Word; LParam1, LParam2, LParam3: Longint; AStringValue: String);
  public
    {$REGION ' - TCreature Propertys '}
    property MapName        : String   read FMapName         write FMapName;
    property UserName       : String   read FUserName        write FUserName;
    property HomeMap0       : String   read FHomeMap0        write FHomeMap0;
    property HomeMap1       : String   read FHomeMap1        write FHomeMap1;
    property HomeMap2       : String   read FHomeMap2        write FHomeMap2;
    property HomeMap3       : String   read FHomeMap3        write FHomeMap3;
    property Ghost          : Boolean  read FGhost           write FGhost;
    property Death          : Boolean  read FDeath           write FDeath;
    property HoldPlace      : Boolean  read FHoldPlace       write FHoldPlace;
    property Animal         : Boolean  read FAnimal          write FAnimal;
    property Skeleton       : Boolean  read FSkeleton        write FSkeleton;
    property HideMode       : Boolean  read FHideMode        write FHideMode;
    property SuperviserMode : Boolean  read FSuperviserMode  write FSuperviserMode;
    property ViewFixedHide  : Boolean  read FViewFixedHide   write FViewFixedHide;
    property ErrorOnInit    : Boolean  read FErrorOnInit     write FErrorOnInit;
    property GhostTime      : Cardinal read FGhostTime       write FGhostTime;
    property Gold           : Int64    read FGold            write FGold;
    property Direction      : Byte     read FDirection       write FDirection;
    property Gender         : Byte     read FGender          write FGender;
    property Job            : Byte     read FJob             write FJob;
    property LifeAttribute  : Byte     read FLifeAttribute   write FLifeAttribute;
    property CoolEye        : Byte     read FCoolEye         write FCoolEye;
    property AntiMagic      : Byte     read FAntiMagic       write FAntiMagic;
    property SpeedPoint     : Byte     read FSpeedPoint      write FSpeedPoint;
    property AccuracyPoint  : Byte     read FAccuracyPoint   write FAccuracyPoint;
    property RaceServer     : Word     read FRaceServer      write FRaceServer;
    property RaceImage      : Word     read FRaceImage       write FRaceImage;
    property Hair           : Word     read FHair            write FHair;
    property Appearance     : Word     read FAppearance      write FAppearance;
    property CX             : Integer  read FCX              write FCX;
    property CY             : Integer  read FCY              write FCY;
    property HomeX0         : Integer  read FHomeX0          write FHomeX0;
    property HomeY0         : Integer  read FHomeY0          write FHomeY0;
    property HomeX1         : Integer  read FHomeX1          write FHomeX1;
    property HomeY1         : Integer  read FHomeY1          write FHomeY1;
    property HomeX2         : Integer  read FHomeX2          write FHomeX2;
    property HomeY2         : Integer  read FHomeY2          write FHomeY2;
    property HomeX3         : Integer  read FHomeX3          write FHomeX3;
    property HomeY4         : Integer  read FHomeY3          write FHomeY3;
    property CharStatus     : Integer  read FCharStatus      write FCharStatus;
    property CharStatusEx   : Integer  read FCharStatusEx    write FCharStatusEx;
    property ViewRange      : Integer  read FViewRange       write FViewRange;
    property MeatQuality    : Integer  read FMeatQuality     write FMeatQuality;
    property FightExp       : Integer  read FFightExp        write FFightExp;
    property NextWalkTime   : Integer  read FNextWalkTime    write FNextWalkTime;
    property WalkStep       : Integer  read FWalkStep        write FWalkStep;
    property WalkWaitTime   : Integer  read FWalkWaitTime    write FWalkWaitTime;
    property NextHitTime    : Integer  read FNextHitTime     write FNextHitTime;
    property Tame           : Integer  read FTame            write FTame;
    property AntiPush       : Integer  read FAntiPush        write FAntiPush;
    property AntiUndead     : Integer  read FAntiUndead      write FAntiUndead;
    property SizeRate       : Integer  read FSizeRate        write FSizeRate;
    property AntiStop       : Integer  read FAntiStop        write FAntiStop;
    property BodyLuckLevel  : Integer  read FBodyLuckLevel   write FBodyLuckLevel;
    property BodyLuck       : Real     read FBodyLuck        write FBodyLuck;
    property ItemList       : TList    read FItemList        write FItemList;
    property MagicList      : TList    read FMagicList       write FMagicList;
    property Environment    : TObject  read FEnvironment     write FEnvironment;
    property Ability        : TAbility read FAbility;
    property WAbility       : TAbility read FWAbility;
    {$ENDREGION}
  end;

  (* class TAnimal *)

  TAnimal = class (TCreature)
  public
    constructor Create;
    destructor Destroy; override;
  public

  end;

  (* class TMagicGate *)

  TMagicGate = class(TCreature)
  public
    constructor Create;
    destructor Destroy; override;
  public

  end;

  (* class TMagicGate 2 *)

  TMagicGate2 = class(TCreature)
  public
    constructor Create;
    destructor Destroy; override;
  public

  end;

  (* class TUserHuman *)

  TUserHuman = class (TAnimal)
  strict private
    FEmergencyClose   : Boolean;
    FSoftClosed       : Boolean;
    FUserSocketClosed : Boolean;
    FSaveOk           : Boolean;
  public
    constructor Create;
    destructor Destroy; override;
  public
    // Comand Functions
    procedure ComandChangeJob(AJobName: String);
    procedure ComandChangeGender;
  public
    property EmergencyClose   : Boolean read FEmergencyClose   write FEmergencyClose;
    property SoftClosed       : Boolean read FSoftClosed       write FSoftClosed;
    property UserSocketClosed : Boolean read FUserSocketClosed write FUserSocketClosed;
    property SaveOk           : Boolean read FSaveOk           write FSaveOk;
  end;


implementation

uses Mir3.Forms.Main.System, Mir3.Server.Environment;

  (* base class TCreature *)

{$REGION ' - TCreature Constructor / Destructor '}
  constructor TCreature.Create;
  begin
    FGhost      := False;
    FRaceServer := RACE_ANIMAL;
    FItemList   := TList.Create;
    FMagicList  := TList.Create;
  end;

  destructor TCreature.Destroy;
  begin
    FItemList.Free;
    FMagicList.Free;
    inherited Destroy;
  end;
{$ENDREGION}

{$REGION ' - TCreature Public Function '}

  procedure TCreature.DropUseItems(AItemOwnerShip: TObject; ADieFromMob : Boolean);
  var
    I : Integer;
  begin
    try
      try
        for I := 0 to 12 do
        begin
          //_eax_ := 69 * lvar_C;
          //_edx_ := arg_0;
          //_eax_ := _edx_ + _eax_ * 22896;
        end;
      finally

      end;
    finally

    end;
  end;

  procedure TCreature.Initialize;
  var
    I, C: Integer;
  begin
    InitValues;

    for I := 0 to MagicList.Count-1 do
    begin
      C := PUserMagic(MagicList[I]).RLevel;
      if not (C in [0..3]) then
        PUserMagic(MagicList[I]).RLevel := 0;
    end;

    ErrorOnInit := True;
    if TEnvironment(FEnvironment).CanWalk(CX, CY, True) then
    begin
      if Appear then
      begin
         ErrorOnInit := False;
      end;
    end;
    CharStatus := GetCharStatus;
    AddBodyLuck(0);
  end;

  procedure TCreature.InitValues;
  begin
    SetWAbility(FAbility);
  end;

  procedure TCreature.SetAbility(AValue: TAbility);
  begin
    with FAbility do
    begin
      RLevel         := AValue.RLevel;
      RReserved1     := AValue.RReserved1;
      RAC            := AValue.RAC;
      RMAC           := AValue.RMAC;
      RDC            := AValue.RDC;
      RMC            := AValue.RMC;
      RSC            := AValue.RSC;
      RHP            := AValue.RHP;
      RMP            := AValue.RMP;
      RMaxHP         := AValue.RMaxHP;
      RMaxMP         := AValue.RMaxMP;
      RExpCount      := AValue.RExpCount;
      RExpMaxCount   := AValue.RExpMaxCount;
      RExp           := AValue.RExp;
      RMaxExp        := AValue.RMaxExp;
      RWeight        := AValue.RWeight;
      RMaxWeight     := AValue.RMaxWeight;
      RWearWeight    := AValue.RWearWeight;
      RMaxWearWeight := AValue.RMaxWearWeight;
      RHandWeight    := AValue.RHandWeight;
      RMaxHandWeight := AValue.RMaxHandWeight;
    end;
  end;

  procedure TCreature.SetWAbility(AValue: TAbility);
  begin
    with FWAbility do
    begin
      RLevel         := AValue.RLevel;
      RReserved1     := AValue.RReserved1;
      RAC            := AValue.RAC;
      RMAC           := AValue.RMAC;
      RDC            := AValue.RDC;
      RMC            := AValue.RMC;
      RSC            := AValue.RSC;
      RHP            := AValue.RHP;
      RMP            := AValue.RMP;
      RMaxHP         := AValue.RMaxHP;
      RMaxMP         := AValue.RMaxMP;
      RExpCount      := AValue.RExpCount;
      RExpMaxCount   := AValue.RExpMaxCount;
      RExp           := AValue.RExp;
      RMaxExp        := AValue.RMaxExp;
      RWeight        := AValue.RWeight;
      RMaxWeight     := AValue.RMaxWeight;
      RWearWeight    := AValue.RWearWeight;
      RMaxWearWeight := AValue.RMaxWearWeight;
      RHandWeight    := AValue.RHandWeight;
      RMaxHandWeight := AValue.RMaxHandWeight;
    end;
  end;

  function TCreature.Appear: Boolean;
  var
    FOutOfRange : Pointer;
  begin
    FOutOfRange := TEnvironment(FEnvironment).AddToMap(CX, CY, OS_MOVING_OBJECT, Self);
    if FOutOfRange = nil then
      Result := False
    else
      Result := True;

    if not HideMode then
      SendRefMsg(RM_TURN, Direction, CX, CY, 0, '');
  end;

  procedure TCreature.AddBodyLuck(AValue: Real);
  var
    I : Integer;
  begin
    if (AValue > 0) and (BodyLuck <   5 * BODY_LUCK_UNIT)  then BodyLuck := BodyLuck + AValue;
    if (AValue < 0) and (BodyLuck > -(5 * BODY_LUCK_UNIT)) then BodyLuck := BodyLuck + AValue;

    I := Trunc(BodyLuck / BODY_LUCK_UNIT);
    if I >   5 then I :=   5;
    if I < -10 then I := -10;

    BodyLuckLevel := I;
  end;

  function TCreature.GetCharStatus: Integer;
  var
    I, C : Integer;
  begin
    C := 0;
    for I := 0 to MIR3_STATUS_ARRAY_SIZE-1 do
    begin
      if FStatus_Array[I] > 0 then
        C := LongWord(C) or ($80000000 shr I);
    end;
    Result := C or (CharStatusEx and $0000FFFF);
  end;

  procedure TCreature.SendRefMsg(AMessage, WParam: Word; LParam1, LParam2, LParam3: Longint; AStringValue: String);
  begin

  end;

{$ENDREGION}

{$REGION ' - TCreature Private Functions '}

{$ENDREGION}

  (* class TAnimal *)

{$REGION ' - TAnimal Constructor / Destructor '}
  constructor TAnimal.Create;
  begin

  end;

  destructor TAnimal.Destroy;
  begin

    inherited Destroy;
  end;
{$ENDREGION}

{$REGION ' - TAnimal Public Function '}

{$ENDREGION}

{$REGION ' - TAnimal Private Functions '}

{$ENDREGION}

  (* class TMagicGate *)

{$REGION ' - TMagicGate Constructor / Destructor '}
  constructor TMagicGate.Create;
  begin

  end;

  destructor TMagicGate.Destroy;
  begin

    inherited Destroy;
  end;
{$ENDREGION}

{$REGION ' - TMagicGate Public Function '}

{$ENDREGION}

{$REGION ' - TMagicGate Private Functions '}

{$ENDREGION}

  (* class TMagicGate 2 *)

{$REGION ' - TMagicGate2 Constructor / Destructor '}
  constructor TMagicGate2.Create;
  begin

  end;

  destructor TMagicGate2.Destroy;
  begin

    inherited Destroy;
  end;
{$ENDREGION}

{$REGION ' - TMagicGate2 Public Function '}

{$ENDREGION}

{$REGION ' - TMagicGate2 Private Functions '}

{$ENDREGION}

  (* class TUserHuman *)

{$REGION ' - TUserHuman Constructor / Destructor '}
  constructor TUserHuman.Create;
  begin
    FEmergencyClose := False;
    FSoftClosed     := False;
  end;

  destructor TUserHuman.Destroy;
  begin

    inherited Destroy;
  end;
{$ENDREGION}

{$REGION ' - TUserHuman Public Function '}



  (* TUserHuman Commands *)

procedure TUserHuman.ComandChangeJob(AJobName: String);
begin
  if CompareText(AJobName, 'Warrior')  = 0 then FJob := 0;
  if CompareText(AJobName, 'Wizard')   = 0 then FJob := 1;
  if CompareText(AJobName, 'Taoist')   = 0 then FJob := 2;
  if CompareText(AJobName, 'Assassin') = 0 then FJob := 3;
end;

procedure TUserHuman.ComandChangeGender;
begin
  if FGender = 0 then
    FGender := 1
  else FGender := 0;
end;

{$ENDREGION}

{$REGION ' - TUserHuman Private Functions '}

{$ENDREGION}


end.
