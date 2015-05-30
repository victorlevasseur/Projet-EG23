unit PlanningDay;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, dbf, sqldb, FileUtil, Forms, Controls, StdCtrls,
  ComCtrls, Grids, Dialogs;

type

  TDayOfWeek = (dowNone, dowMonday, dowTuesday, dowWednesday, dowThursday, dowFriday, dowSaturday, dowSunday);

  TMealtime = (mtNone, mtLunch, mtDinner);

  TRecipeType = (rtNone, rtStarter, rtMeal, rtDessert);

  TPlanningDayClickEvent = procedure (Day: TDayOfWeek; Mealtime: TMealtime;
    TypeOfRecipe: TRecipeType; RecipeId: Integer) of object;

  { TPlanningDayControl }
  //Cette classe est un contrôle permettant d'afficher le contenu d'un repas
  //sur le planning (entrée, plat et dessert) ainsi que quelques informations
  //comme le temps de préparation, le nombre de calories...
  TPlanningDayControl = class(TFrame)
    Datasource1: TDatasource;
    DurationLabel: TLabel;
    CostLabel: TLabel;
    RecipeDbf: TDbf;
    CaloriesLabel: TLabel;
    ListView1: TListView;

    procedure ListView1Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure RecipeDbfAfterOpen(DataSet: TDataSet);

  private
    { private declarations }

    //Fonction permettant de récupérer le nom d'une recette depuis son CODE/ID
    function GetRecipeName(Id: Integer) : string;

    //Met à jour l'affichage de la liste des recettes du repas ainsi que
    //le informations sur le temps de préparation / calories
    procedure UpdateListView();

  private
    //Stockage des IDs correspondant aux plats
    StarterId: Integer;
    MealId: Integer;
    DessertId: Integer;

    //Dernier plat sélectionné
    LastSelectedDish: TRecipeType;

  public
    { public declarations }

    //Un pointeur sur procédure permettant à l'application de donner une
    //procédure à exécuter quand l'utilisateur clique sur un élément de menu
    OnDishSelected: TPlanningDayClickEvent;

    //Surcharge du constructeur permettant d'initialiser la connexion à la base
    //de données.
    constructor Create(AOwner: TComponent) ; override;

    //Entrée
    function GetStarter : Integer;
    procedure SetStarter(Id: Integer);

    //Plat principal
    function GetMeal : Integer;
    procedure SetMeal(Id: Integer);

    //Dessert
    function GetDessert : Integer;
    procedure SetDessert(Id: Integer);

    //Méthode permettant de sélectionner un plat dans le contrôle
    procedure SelectDish(RecipeType: TRecipeType);

  public
    //Info à propos du jour et du repas auquel ce contrôle correspond
    Day: TDayOfWeek;
    Mealtime: TMealtime;
  end;

  PPlanningDayControl = ^TPlanningDayControl;

implementation

{$R *.lfm}

procedure TPlanningDayControl.RecipeDbfAfterOpen(DataSet: TDataSet);
begin
     SetStarter(1);
     SetMeal(2);
     SetDessert(3);
end;

procedure TPlanningDayControl.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
   DishType: TRecipeType;
   RecipeId: Integer;
begin
     //Prendre en compte uniquement les événements de sélection (et pas de
     //déselection) et juste si l'event handler OnDishSelected est "lié"
     if Selected and Assigned(OnDishSelected) and (ListView1.Selected <> nil) then
     begin
          if Item.Index = 0 then
              begin
                   DishType := rtStarter;
                   RecipeId := StarterId;
              end
          else if Item.Index = 1 then
              begin
                   DishType := rtMeal;
                   RecipeId := MealId;
              end
          else
              begin
                   DishType := rtDessert;
                   RecipeId := DessertId;
              end;

          LastSelectedDish := DishType;

          OnDishSelected(Day, Mealtime, DishType, RecipeId);
     end;
end;

procedure TPlanningDayControl.ListView1Click(Sender: TObject);
var
   DishType: TRecipeType;
   RecipeId: Integer;
begin
    //Prendre en compte uniquement les événements de sélection (et pas de
     //déselection) et juste si l'event handler OnDishSelected est "lié"
     if Assigned(OnDishSelected) and (ListView1.Selected <> nil) then
     begin
          if ListView1.Selected.Index = 0 then
              begin
                   DishType := rtStarter;
                   RecipeId := StarterId;
              end
          else if ListView1.Selected.Index = 1 then
              begin
                   DishType := rtMeal;
                   RecipeId := MealId;
              end
          else if ListView1.Selected.Index = 2 then
              begin
                   DishType := rtDessert;
                   RecipeId := DessertId;
              end;

          OnDishSelected(Day, Mealtime, DishType, RecipeId);
     end;

     if (ListView1.Selected = nil) and (LastSelectedDish <> rtNone) then
     begin
         ListView1.Selected := ListView1.Items[Integer(LastSelectedDish) - 1];
     end;
end;

function TPlanningDayControl.GetRecipeName(Id: Integer) : string;
begin
     //Recherche de l'enregistrement avec l'ID correspondant
     RecipeDbf.Locate('CODE', Id, [loCaseInsensitive]);

     GetRecipeName := RecipeDbf.FieldByName('INTITULE').AsString;
end;

procedure TPlanningDayControl.UpdateListView;
var
  totalCalories: Integer;
  totalDuration: Integer;
  totalCost: Double;
begin
     ListView1.Items.Item[0].Caption := GetRecipeName(StarterId);
     ListView1.Items.Item[1].Caption := GetRecipeName(MealId);
     ListView1.Items.Item[2].Caption := GetRecipeName(DessertId);

     //Calcul du total de calories
     RecipeDbf.Locate('CODE', StarterId, [loCaseInsensitive]);
     totalCalories := RecipeDbf.FieldByName('CALORIE').AsInteger;
     RecipeDbf.Locate('CODE', MealId, [loCaseInsensitive]);
     totalCalories := totalCalories + RecipeDbf.FieldByName('CALORIE').AsInteger;
     RecipeDbf.Locate('CODE', DessertId, [loCaseInsensitive]);
     totalCalories := totalCalories + RecipeDbf.FieldByName('CALORIE').AsInteger;

     //Calcul du temps total de préparation
     RecipeDbf.Locate('CODE', StarterId, [loCaseInsensitive]);
     totalDuration := RecipeDbf.FieldByName('PREPARATIO').AsInteger + RecipeDbf.FieldByName('TPS_CUISSO').AsInteger;
     RecipeDbf.Locate('CODE', MealId, [loCaseInsensitive]);
     totalDuration := totalDuration + RecipeDbf.FieldByName('PREPARATIO').AsInteger + RecipeDbf.FieldByName('TPS_CUISSO').AsInteger;
     RecipeDbf.Locate('CODE', DessertId, [loCaseInsensitive]);
     totalDuration := totalDuration + RecipeDbf.FieldByName('PREPARATIO').AsInteger + RecipeDbf.FieldByName('TPS_CUISSO').AsInteger;

     //Calcul du prix total
     RecipeDbf.Locate('CODE', StarterId, [loCaseInsensitive]);
     totalCost := RecipeDbf.FieldByName('COUT').AsFloat;
     RecipeDbf.Locate('CODE', MealId, [loCaseInsensitive]);
     totalCost := totalCost + RecipeDbf.FieldByName('COUT').AsFloat;
     RecipeDbf.Locate('CODE', DessertId, [loCaseInsensitive]);
     totalCost := totalCost + RecipeDbf.FieldByName('COUT').AsFloat;

     //Ajout du texte dans la zone d'information
     CaloriesLabel.Caption := 'Calories : ' + IntToStr(totalCalories) + ' kCal';
     DurationLabel.Caption := 'Temps total (prép. + cuisson) : ' + IntToStr(totalDuration) + ' min';
     CostLabel.Caption := 'Prix total : ' + FloatToStr(totalCost) + ' €';
end;

constructor TPlanningDayControl.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);

     StarterId := -1;
     MealId := -1;
     DessertId := -1;

     LastSelectedDish := rtNone;

     Day := dowNone;
     Mealtime := mtNone;

     RecipeDbf.FilePathFull := GetCurrentDir();
     RecipeDbf.TableLevel := 4;
     RecipeDbf.TableName :='RECETTES.DBF';
     RecipeDbf.Open;
end;

function TPlanningDayControl.GetStarter : Integer;
begin
     GetStarter := StarterId;
end;

procedure TPlanningDayControl.SetStarter(Id: Integer);
begin
     //Affichage de l'entrée avec l'ID Id
     StarterId := Id;
     UpdateListView;
end;

function TPlanningDayControl.GetMeal : Integer;
begin
     GetMeal := MealId;
end;

procedure TPlanningDayControl.SetMeal(Id: Integer);
begin
     MealId := Id;
     UpdateListView;
end;

function TPlanningDayControl.GetDessert : Integer;
begin
     GetDessert := DessertId;
end;

procedure TPlanningDayControl.SetDessert(Id: Integer);
begin
     DessertId := Id;
     UpdateListView;
end;

procedure TPlanningDayControl.SelectDish(RecipeType: TRecipeType);
begin
     if RecipeType <> rtNone then
     begin
        ListView1.Selected := ListView1.Items[Integer(RecipeType) - 1];
     end
     else
     begin
        ListView1.Selected := nil;
     end;
end;

end.

