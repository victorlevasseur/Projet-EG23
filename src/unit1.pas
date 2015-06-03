unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ActnList, Menus, StdCtrls, Planning, Ingredient, recipe;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    IngredientFrame1: TIngredientFrame;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MainPageControl: TPageControl;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    PlanningFrame1: TPlanningFrame;
    PlanningTabSheet: TTabSheet;
    RecipeFrame1: TRecipeFrame;
    RecipesTabSheet: TTabSheet;
    IngredientsTabSheet: TTabSheet;
    procedure MenuItem4Click(Sender: TObject);
    procedure OnQuitMenuItemClicked(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.OnQuitMenuItemClicked(Sender: TObject);
begin
     Close();
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
    ShowMessage('Logiciel de gestion de repas'+sLineBreak+
        'Conçu par Charlelie Borella et Victor Levasseur');
end;

end.

