unit Planning;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, db, FileUtil, Forms, Controls, StdCtrls, ComCtrls,
  ExtCtrls, Dialogs, DbCtrls, PlanningDay, fgl;

type
  TPlanningDayControlsMap2 = specialize TFPGMap<TMealtime, TPlanningDayControl>;
  TPlanningDayControlsMap = specialize TFPGMap<TDayOfWeek, TPlanningDayControlsMap2>;

  { TPlanningFrame }

  TPlanningFrame = class(TFrame)
      InfoRecipeDS: TDatasource;
      InfoRecipeNameLabel: TDBText;
      InfoRecipeDbf: TDbf;
    InformationGroupBox: TGroupBox;
    InformationPageControl: TPageControl;
    InfoDayMealtimeLabel: TLabel;
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

    procedure CreatePlanningDayControl(Day: TDayOfWeek; Mealtime: TMealtime);

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
    //Sélection de la recette dans le base de données
    InfoRecipeDbf.Locate('CODE', RecipeId, [loCaseInsensitive]);

    //Affichage du jour et du repas dans le panneau d'informations
    case Day of
        dowMonday: InfoDayMealtimeLabel.Caption := 'Lundi';
        dowTuesday: InfoDayMealtimeLabel.Caption := 'Mardi';
        dowWednesday: InfoDayMealtimeLabel.Caption := 'Mercredi';
        dowThursday: InfoDayMealtimeLabel.Caption := 'Jeudi';
        dowFriday: InfoDayMealtimeLabel.Caption := 'Vendredi';
        dowSaturday: InfoDayMealtimeLabel.Caption := 'Samedi';
        dowSunday: InfoDayMealtimeLabel.Caption := 'Dimanche';
    else InfoDayMealtimeLabel.Caption := '';
    end;

    case Mealtime of
        mtLunch: InfoDayMealtimeLabel.Caption := InfoDayMealtimeLabel.Caption + ' Midi';
        mtDinner: InfoDayMealtimeLabel.Caption := InfoDayMealtimeLabel.Caption + ' Soir';
    else InfoDayMealtimeLabel.Caption := InfoDayMealtimeLabel.Caption + '';
    end;
end;

procedure TPlanningFrame.CreatePlanningDayControl(
    Day: TDayOfWeek; Mealtime: TMealtime);
var
  UselessIndex: Integer;
begin
    //Si le jour n'est pas déjà dans le tableau associatif, on l'ajoute.
    if PlanningDayControls.Find(Day, UselessIndex) = False then
    begin
        PlanningDayControls.Add(Day, TPlanningDayControlsMap2.Create);
    end;

    //Si le repas (midi ou soir) n'est pas déjà dans le sous-tableau associatif,
    //on l'ajoute
    if PlanningDayControls[Day].Find(Mealtime, UselessIndex)
       = False then
    begin
        PlanningDayControls[Day].Add(Mealtime);
    end;

    //Enfin, on crée un nouveau TPlanningDayControl dans le tableau associatif
    PlanningDayControls[Day][Mealtime] := TPlanningDayControl.Create(self);
    PlanningDayControls[Day][Mealtime].Name := 'PlanningDayControl_' +
        IntToStr(Integer(Day)) + '_' + IntToStr(Integer(Mealtime));

    //On affecte un parent au contrôle
    PlanningDayControls[Day][Mealtime].Parent := ScrollBox1;

    //On affecte le jour et le repas au contrôle
    PlanningDayControls[Day][Mealtime].Day := Day;
    PlanningDayControls[Day][Mealtime].Mealtime := Mealtime;

    //On positionne le contrôle selon son jour et le repas
    if Mealtime = mtLunch then
        PlanningDayControls[Day][Mealtime].Top := 45
    else if Mealtime = mtDinner then
        PlanningDayControls[Day][Mealtime].Top := 285;

    PlanningDayControls[Day][Mealtime].Left := 125 + (Integer(Day) - 1) * 320;

    //Connexion à l'event handler
    PlanningDayControls[Day][Mealtime].OnDishSelected := @OnDishSelected;
end;

constructor TPlanningFrame.Create(AOwner: TComponent);
var
  Day: TDayOfWeek;
begin
     inherited Create(AOwner);

     //Chargement de(s) base(s) de données
     InfoRecipeDbf.FilePathFull := GetCurrentDir();
     InfoRecipeDbf.TableLevel := 4;
     InfoRecipeDbf.TableName :='RECETTES.DBF';
     InfoRecipeDbf.Open;

     //Création dynamique des TPlanningDayControls
     PlanningDayControls := TPlanningDayControlsMap.Create;

     for Day := dowMonday to dowSunday do
     begin
         CreatePlanningDayControl(Day, mtLunch);
         CreatePlanningDayControl(Day, mtDinner);
     end;
end;

end.

