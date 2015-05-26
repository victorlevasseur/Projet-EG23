unit Planning;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, db, FileUtil, Forms, Controls, StdCtrls, ComCtrls,
  ExtCtrls, Dialogs, DbCtrls, PlanningDay, fgl;

type
  TPlanningDayControlsMap2 = specialize TFPGMap<TMealtime, PPlanningDayControl>;
  TPlanningDayControlsMap = specialize TFPGMap<TDayOfWeek, TPlanningDayControlsMap2>;

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

    procedure RegisterPlanningDayControl(var Control: TPlanningDayControl);

  private
    { Un tableau associatif pour associer un repas (jour + midi/soir) et un
      contrôle PlanningDayControl }
    PlanningDayControls: TPlanningDayControlsMap;

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

procedure TPlanningFrame.RegisterPlanningDayControl(
    var Control: TPlanningDayControl);
var
  UselessIndex: Integer;
begin
    //Si le jour n'est pas déjà dans le tableau associatif, on l'ajoute.
    if PlanningDayControls.Find(Control.Day, UselessIndex) = False then
    begin
        PlanningDayControls.Add(Control.Day, TPlanningDayControlsMap2.Create);
    end;

    //Si le repas (midi ou soir) n'est pas déjà dans le sous-tableau associatif,
    //on l'ajoute
    if PlanningDayControls[Control.Day].Find(Control.Mealtime, UselessIndex)
       = False then
    begin
        PlanningDayControls[Control.Day].Add(Control.Mealtime);
    end;

    //Enfin, on affecte un pointeur vers le PlanningDayControl à cette clé du
    //tableau associatif
    PlanningDayControls[Control.Day][Control.Mealtime] := @Control;
end;

constructor TPlanningFrame.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);

     //Chargement de(s) base(s) de données
     InfoRecipeDbf.FilePathFull := GetCurrentDir();
     InfoRecipeDbf.TableLevel := 4;
     InfoRecipeDbf.TableName :='RECETTES.DBF';
     InfoRecipeDbf.Open;

     //Affectation des jours et des repas aux différents TPlanningDayControls
     PlanningDayControls := TPlanningDayControlsMap.Create;

     RegisterPlanningDayControl(PlanningDayControl1);
     RegisterPlanningDayControl(PlanningDayControl2);

     //Initialisation des events handlers
     PlanningDayControl1.OnDishSelected := @OnDishSelected;
     PlanningDayControl2.OnDishSelected := @OnDishSelected;
end;

end.

