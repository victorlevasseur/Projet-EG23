unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ActnList, Menus, Planning, Ingredient, recipe;

type

  { TForm1 }

  TForm1 = class(TForm)
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

end.

