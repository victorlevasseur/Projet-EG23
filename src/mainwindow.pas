unit mainWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ActnList, ExtCtrls, Menus, ongletPlanning;

type

  { TMainWindowForm }

  TMainWindowForm = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PageControl1: TPageControl;
    StatusBar1: TStatusBar;
    PlanningSheet: TTabSheet;
    RecettesSheet: TTabSheet;
    IngredientsSheet: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
  private
    { private declarations }
    planningPanel: TForm2;
  public
    { public declarations }
  end;

var
  MainWindowForm: TMainWindowForm;

implementation

{$R *.lfm}

{ TMainWindowForm }

procedure TMainWindowForm.MenuItem1Click(Sender: TObject);
begin

end;

procedure TMainWindowForm.FormCreate(Sender: TObject);
begin
     planningPanel := TForm2.Create(Self);
     PlanningSheet.InsertControl(planningPanel);
end;

end.

