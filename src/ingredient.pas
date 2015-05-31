unit Ingredient;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, db, FileUtil, Forms, Controls, StdCtrls, DBGrids;

type

  { TIngredientFrame }

  TIngredientFrame = class(TFrame)
    DBGrid1: TDBGrid;
    IngrDS: TDataSource;
    IngrDbf: TDbf;
    Label1: TLabel;
    RemoveIngrButton: TButton;
    NewIngrButton: TButton;
    SearchIngrEdit: TEdit;
  private
    { private declarations }
  public
    { public declarations }
    //Surcharge du constructeur permettant d'initialiser la connexion à la base
    //de données et de paramétrer quelques autres choses.
    constructor Create(AOwner: TComponent) ; override;
  end;

implementation

{$R *.lfm}

constructor TIngredientFrame.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

    IngrDbf.FilePathFull := GetCurrentDir();
    IngrDbf.TableLevel := 4;
    IngrDbf.TableName :='INGREDIE.DBF';
    IngrDbf.Open;
end;

end.

