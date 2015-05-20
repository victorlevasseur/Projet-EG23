unit mainWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ActnList, ExtCtrls, Menus, ValEdit, DbCtrls, StdCtrls, DBGrids, PairSplitter,
  Buttons, dbf, db;

type

  { TMainWindowForm }

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    ComboBox1: TComboBox;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBEdit1: TDBEdit;
    Dbf1: TDbf;
    Dbf2: TDbf;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PageControl1: TPageControl;
    PlanningSidePanel: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    ScrollBox1: TScrollBox;
    StatusBar1: TStatusBar;
    PlanningSheet: TTabSheet;
    RecettesSheet: TTabSheet;
    IngredientsSheet: TTabSheet;
    DescriptionPanelSheet: TTabSheet;
    ChangePanelSheet: TTabSheet;
    ToggleBox1: TToggleBox;
    procedure Button8Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure DBEdit1Change(Sender: TObject);
    procedure DBListBox1Click(Sender: TObject);
    procedure DBListBox4Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TMainWindowForm }

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.Panel1Click(Sender: TObject);
begin

end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.DBEdit1Change(Sender: TObject);
begin

end;

procedure TForm1.DBListBox1Click(Sender: TObject);
begin

end;

procedure TForm1.DBListBox4Click(Sender: TObject);
begin

end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin

end;

procedure TForm1.Button8Click(Sender: TObject);
begin

end;

procedure TForm1.Label2Click(Sender: TObject);
begin

end;

procedure TForm1.Label3Click(Sender: TObject);
begin

end;

end.

