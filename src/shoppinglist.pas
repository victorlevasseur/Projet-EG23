unit ShoppingList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, PlanningDay, dbf,
  Dialogs, StdCtrls, fgl, db;

type

  //Un tableau associatif contenant les recettes (en tant que clés)
  //et le nombre de fois que la recette apparaît dans le planning (en valeur)
  TRecipeList = specialize TFPGMap<Integer, Integer>;

  { TShoppingListDialog }

  TShoppingListDialog = class(TForm)
    CompoDbf: TDbf;
    IngrDbf: TDbf;
    PrintButton: TButton;
    SaveButton: TButton;
    CloseButton: TButton;
    Memo: TMemo;
    procedure CloseButtonClick(Sender: TObject);
    procedure CompoDbfAfterOpen(DataSet: TDataSet);
    procedure PrintButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
  private
    { private declarations }
    RecipesList: TRecipeList;
  public
    { public declarations }

    //Permet de passer la liste des recettes
    procedure SetRecipeList(RecipeList: TRecipeList);

    //Lance la connexion aux BDD
    procedure ConnectDB;
  end;

var
  ShoppingListDialog: TShoppingListDialog;

implementation

{$R *.lfm}

{ TShoppingListDialog }

procedure TShoppingListDialog.CloseButtonClick(Sender: TObject);
begin
    Close;
end;

procedure TShoppingListDialog.CompoDbfAfterOpen(DataSet: TDataSet);
var
  IngrList: TRecipeList; //Associe l'ID d'un ingrédient à sa quantité
  CodeRecipe: Integer;
  CodeIngr: Integer;
  QuantiteIngr: Integer;
  i: Integer;
  useless: Integer;
begin
    IngrList := TRecipeList.Create;

    if IngrDbf.Active and CompoDbf.Active then
    begin
        Memo.Clear;

        //On parcourt toute la liste des recettes (générée par le planning)
        for i := 0 to (RecipesList.Count - 1) do
        begin
            //On utilise la table des compositions pour trouver les ID des ingrédients
            //de la recette sélectionnée
            CodeRecipe := RecipesList.Keys[i];

            CompoDbf.Filter:='CODE_RECET=' + IntToStr(CodeRecipe);
            CompoDbf.Filtered:=True;
            CompoDbf.First;

            //On boucle sur tous les ingrédients associés à la recette
            //et on les ajoute dans le tableau associatif des ingrédients
            while not CompoDbf.EOF do
            begin
                CodeIngr := CompoDbf.FieldByName('CODE_INGRE').AsInteger;
                QuantiteIngr := CompoDbf.FieldByName('QTE').AsInteger;

                if not IngrList.Find(CodeIngr, useless) then
                    IngrList[CodeIngr] := 0;

                IngrList[CodeIngr] := IngrList[CodeIngr] +
                    QuantiteIngr * RecipesList[CodeRecipe];

                CompoDbf.Next;
            end;
        end;

        //Affichage dans la liste de courses
        for i := 0 to (IngrList.Count - 1) do
        begin
            //Recherche de l'ingrédient dans la BDD (pour obtenir son nom, son
            //unité)
            CodeIngr := IngrList.Keys[i];
            IngrDbf.Locate('CODE', IngrList.Keys[i], [loCaseInsensitive]);

            //Affichage de l'ingrédient
            Memo.Lines.Add(' - ' + IngrDbf.FieldByName('INTITULE').AsString
                + ' : ' + IntToStr(IngrList[CodeIngr]) + ' ' +
                IngrDbf.FieldByName('UNITE').AsString);
        end;
    end;
end;

procedure TShoppingListDialog.PrintButtonClick(Sender: TObject);
begin
    ShowMessage('Fonctionnalité non implémentée');
end;

procedure TShoppingListDialog.SaveButtonClick(Sender: TObject);
begin
    ShowMessage('Fonctionnalité non implémentée');
end;

procedure TShoppingListDialog.SetRecipeList(RecipeList: TRecipeList);
begin
    RecipesList := RecipeList;
end;

procedure TShoppingListDialog.ConnectDB;
begin
    IngrDbf.FilePathFull := GetCurrentDir();
    IngrDbf.TableLevel := 4;
    IngrDbf.TableName :='INGREDIE.DBF';
    IngrDbf.Open;

    CompoDbf.FilePathFull := GetCurrentDir();
    CompoDbf.TableLevel := 4;
    CompoDbf.TableName :='COMPOSIT.DBF';
    CompoDbf.Open;
end;

end.

