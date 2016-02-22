unit MainFMX;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts,
  FMX.Objects, FMX.Edit, FMX.TabControl, BOsU, EventBus.Commons,
  EventBus.Attributes;

type
  THeaderFooterForm = class(TForm)
    Header: TToolBar;
    HeaderLabel: TLabel;
    GridPanelLayout1: TGridPanelLayout;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    AniIndicator1: TAniIndicator;
    TabControl1: TTabControl;
    Text1: TText;
    TabItem1: TTabItem;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    [Subscribe(TThreadMode.Main)]
    procedure OnAfterLogin(AEvent: TOnLoginEvent);
  end;

var
  HeaderFooterForm: THeaderFooterForm;

implementation

uses
  EventBus;

{$R *.fmx}

procedure THeaderFooterForm.Button1Click(Sender: TObject);
begin
  AniIndicator1.Enabled := true;
  Button1.Enabled := false;
  TEventBus.GetDefault.Post(TDoLoginEvent.Create(Edit1.Text, Edit2.Text));
end;

procedure THeaderFooterForm.FormCreate(Sender: TObject);
begin
  // register subscribers
  TEventBus.GetDefault.RegisterSubscriber(Self);
  TEventBus.GetDefault.RegisterSubscriber(TRemoteProxy.GetDefault);
end;

procedure THeaderFooterForm.FormDestroy(Sender: TObject);
begin
  TRemoteProxy.GetDefault.Free;
end;

procedure THeaderFooterForm.OnAfterLogin(AEvent: TOnLoginEvent);
begin
  AniIndicator1.Enabled := false;
  Button1.Enabled := true;
  ShowMessage(AEvent.Msg);
  AEvent.Free;
end;

end.