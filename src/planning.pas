unit Planning;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, db, FileUtil, Forms, Controls, StdCtrls, ComCtrls,
  ExtCtrls, Dialogs, DbCtrls, PlanningDay;

type

  { TPlanningFrame }

  TPlanningFrame = class(TFrame)
      InfoRecipeDS: TDatasource;
      InfoRecipeNameLabel: TDBText;
      InfoRecipeDbf: TDbf;
    InformationGroupBox: TGroupBox;
    InformationPageControl: TPageControl;
    PlanningDayControl1: TPlanningDayControl;
    PlanningDayControl2: TPlanningDayControl;
    ScrollBox1: TScrollBox;
    InformationTabSheet: TTabSheet;
    EditTabSheet: TTabSheet;
    ToolBar1: TToolBar;
    GenerateWeekButton: TToolButton;
    ShoppingListButton: TToolButton;
    ToolButton2: TToolButton;
  private
    { private declarations }
    procedure OnDishSelected(Day: TDayOfWeek; Mealtime: TMealtime;
        TypeOfRecipe: TRecipeType; RecipeId: Integer);
  public
    { public declarations }
    //Surcharge du constructeur permettant d'initialiser la connexion à la base
    //de données et de paramétrer quelques autres choses.
    constructor Create(AOwner: TComponent) ; override;

  end;

implementation

{$R *.lfm}

procedure TPlanningFrame.OnDishSelected(Day: TDayOfWeek; Mealtime: TMealtime;
    TypeOfRecipe: TRecipeType; RecipeId: Integer);
begin
    InfoRecipeDbf.Locate('CODE', RecipeId, [loCaseInsensitive]);
end;

constructor TPlanningFrame.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);

     //Chargement de(s) base(s) de données
     InfoRecipeDbf.FilePathFull := GetCurrentDir();
     InfoRecipeDbf.TableLevel := 4;
     InfoRecipeDbf.TableName :='RECETTES.DBF';
     InfoRecipeDbf.Open;

     //Affectation des jours et des repas aux différents TPlanningDayControl s


     //Initialisation des events handlers
     PlanningDayControl1.OnDishSelected := @OnDishSelected;
     PlanningDayControl2.OnDishSelected := @OnDishSelected;
end;

end.

