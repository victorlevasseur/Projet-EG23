unit PlanningDay;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, dbf, sqldb, FileUtil, Forms, Controls, StdCtrls,
  ComCtrls, Grids, Dialogs;

type

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
  public
    { public declarations }

    //Surcharge du constructeur permettant d'initialiser la connexion à la base
    //de données.
    constructor Create(AOwner: TComponent) ; override;

    //Permet de récupérer l'ID de l'entrée
    function GetStarter : Integer;

    //Permet de définir l'entrée du repas (son ID)
    procedure SetStarter(Id: Integer);

    //Permet de récupérer l'ID du repas
    function GetMeal : Integer;

    //Permet de définir le plat du repas (son ID)
    procedure SetMeal(Id: Integer);

    //Permet de récupérer l'ID du dessert
    function GetDessert : Integer;

    //Permet de définir le dessert du repas (son ID)
    procedure SetDessert(Id: Integer);
  end;

implementation

{$R *.lfm}

procedure TPlanningDayControl.RecipeDbfAfterOpen(DataSet: TDataSet);
begin
     SetStarter(1);
     SetMeal(2);
     SetDessert(3);
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

end.

