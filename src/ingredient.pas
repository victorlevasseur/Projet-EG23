unit Ingredient;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, db, FileUtil, Forms, Controls, StdCtrls, DBGrids,
  Dialogs, DbCtrls, strutils;

type

  { TIngredientFrame }

  TIngredientFrame = class(TFrame)
    DBComboBox1: TDBComboBox;
    DBComboBox2: TDBComboBox;
    DBComboBox3: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBGrid1: TDBGrid;
    DBText1: TDBText;
    IngrDS: TDataSource;
    IngrDbf: TDbf;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    RemoveIngrButton: TButton;
    NewIngrButton: TButton;
    SearchIngrEdit: TEdit;
    procedure IngrDbfFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure SearchIngrEditChange(Sender: TObject);
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

procedure TIngredientFrame.SearchIngrEditChange(Sender: TObject);
begin
    if SearchIngrEdit.Text = '' then
    begin
        IngrDbf.Refresh;
        IngrDbf.Filtered := False;
    end
    else
    begin
        IngrDbf.Refresh;
        IngrDbf.Filtered := True;
    end;
end;

procedure TIngredientFrame.IngrDbfFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
    Accept := AnsiStartsText(SearchIngrEdit.Text,
        IngrDbf.FieldByName('INTITULE').AsString);
end;

constructor TIngredientFrame.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);

    IngrDbf.FilePathFull := GetCurrentDir();
    IngrDbf.TableLevel := 4;
    IngrDbf.TableName :='INGREDIE.DBF';
    IngrDbf.Open;
end;

end.

