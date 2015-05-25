unit PlanningDay;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, dbf, sqldb, FileUtil, Forms, Controls, StdCtrls,
  ComCtrls, Grids, ColorBox, ValEdit, Dialogs, DBGrids;

type

  { TPlanningDayControl }

  TPlanningDayControl = class(TFrame)
    Datasource1: TDatasource;
    RecipeDbf: TDbf;
    InformationLabel: TLabel;
    ListView1: TListView;
    procedure RecipeDbfAfterOpen(DataSet: TDataSet);
  private
    { private declarations }
    function GetRecipeName(Id: Integer) : string;
  public
    { public declarations }
    constructor Create(AOwner: TComponent) ; override;

    procedure SetStarter(Id: Integer);
    procedure SetMeal(Id: Integer);
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

constructor TPlanningDayControl.Create(AOwner: TComponent);
begin
     inherited Create(AOwner) ;

     RecipeDbf.FilePathFull := GetCurrentDir();
     RecipeDbf.TableLevel := 4;
     RecipeDbf.TableName :='RECETTES.DBF';
     RecipeDbf.Open;
end;

procedure TPlanningDayControl.SetStarter(Id: Integer);
begin
     //Affichage de l'entrée avec l'ID Id
     ListView1.Items.Item[0].Caption := GetRecipeName(Id);
end;

procedure TPlanningDayControl.SetMeal(Id: Integer);
begin
     ListView1.Items.Item[1].Caption := GetRecipeName(Id);
end;

procedure TPlanningDayControl.SetDessert(Id: Integer);
begin
     ListView1.Items.Item[2].Caption := GetRecipeName(Id);
end;

end.

