unit Recipe;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, db, FileUtil, Forms, Controls, DBGrids, StdCtrls,
  DbCtrls, ComCtrls, ExtCtrls, strutils, Dialogs;

type

  { TRecipeFrame }

  TRecipeFrame = class(TFrame)
    AddIngrButton: TButton;
    CompoDbf: TDbf;
    CompoDS: TDataSource;
    CompoIngrDbf: TDbf;
    Compo2Dbf: TDbf;
    DBGrid3: TDBGrid;
    SearchIngrEdit: TEdit;
    IngrDS: TDataSource;
    IngrDbf: TDbf;
    DBGrid2: TDBGrid;
    DeleteIngrButton: TButton;
    DBComboBox1: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBMemo1: TDBMemo;
    DBRadioGroup1: TDBRadioGroup;
    DBText1: TDBText;
    DeleteRecipeButton: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    SearchEdit: TEdit;
    Label1: TLabel;
    NewRecipeButton: TButton;
    DBGrid1: TDBGrid;
    RecipeDS: TDataSource;
    RecipeDbf: TDbf;
    procedure AddIngrButtonClick(Sender: TObject);
    procedure CompoDbfAfterOpen(DataSet: TDataSet);
    procedure CompoDbfBeforeOpen(DataSet: TDataSet);

    //Est appelée quand la base de donnée veut recalculer les champs
    //"calculé" (pas stocker dans la BDD)
    //Ici, on veut afficher le nom de l'ingrédient dans le tableau
    procedure CompoDbfCalcFields(DataSet: TDataSet);
    procedure CompoIngrDbfAfterOpen(DataSet: TDataSet);
    procedure DeleteIngrButtonClick(Sender: TObject);
    procedure DeleteRecipeButtonClick(Sender: TObject);
    procedure IngrDbfFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure NewRecipeButtonClick(Sender: TObject);

    procedure RecipeDbfAfterScroll(DataSet: TDataSet);
    procedure RecipeDbfFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure SearchEditChange(Sender: TObject);
    procedure SearchIngrEditChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.lfm}

procedure TRecipeFrame.SearchEditChange(Sender: TObject);
begin
    //On filtre les recettes selon la recherche de l'utilisateur
    if SearchEdit.Text = '' then
    begin
        RecipeDbf.Refresh;
        RecipeDbf.Filtered := False;
    end
    else
    begin
        RecipeDbf.Refresh;
        RecipeDbf.Filtered := True;
    end;

    //Voir la méthode RecipeDbfFilterRecord pour le filtrage des enregistrements
    //de recettes selon la recherche de l'utilisateur
end;

procedure TRecipeFrame.SearchIngrEditChange(Sender: TObject);
begin
    //On filtre les ingrédients selon la recherche de l'utilisateur
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

    //Voir la méthode IngrDbfFilterRecord pour le filtrage des enregistrements
    //d'ingrédients selon la recherche de l'utilisateur
end;

procedure TRecipeFrame.RecipeDbfFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
    //Fonction qui permet de définir quelles recettes sont filtrées.
    //On teste si elles commencent comme la recherche de l'utilisateur.
    Accept := AnsiStartsText(SearchEdit.Text,
        RecipeDbf.FieldByName('INTITULE').AsString);
end;

procedure TRecipeFrame.RecipeDbfAfterScroll(DataSet: TDataSet);
begin
    //Evénement déclenché lors de la sélection d'une nouvelle
    //recette à éditer

    //Mise à jour de la liste d'ingrédient avec ceux de la recette
    CompoDbf.Filter := 'CODE_RECET = ' + IntToStr(
        RecipeDbf.FieldByName('CODE').AsInteger);
end;

procedure TRecipeFrame.CompoDbfCalcFields(DataSet: TDataSet);
begin
    if CompoIngrDbf.Active then
    begin
        //On cherche l'ingrédient dont le numéro est celui du champ 'CODE_INGRE'
        if CompoIngrDbf.Locate('CODE', CompoDbf.FieldByName('CODE_INGRE').AsString,
            [loCaseInsensitive]) then
        begin
            CompoDbf.FieldByName('NAME_INGRE').AsString :=
            CompoIngrDbf.FieldByName('INTITULE').AsString;
        end
        else
        begin
            CompoDbf.FieldByName('NAME_INGRE').AsString := '(Ingrédient inconnu)';
        end;
    end
    else
    begin
        CompoDbf.FieldByName('NAME_INGRE').AsString := '(Pas disponible)';
    end;
end;

procedure TRecipeFrame.CompoIngrDbfAfterOpen(DataSet: TDataSet);
begin
    if CompoDbf.Active then
        CompoDbf.Refresh;
end;

procedure TRecipeFrame.DeleteIngrButtonClick(Sender: TObject);
var
  i: Integer;
begin
    //Suppresion d'un/des ingrédient(s)
    //On supprime les ingrédients sélectionnés
    if DBGrid2.SelectedRows.Count > 0 then
    begin
        //On parcourt chacun des ingrédients sélectionnés
        for i := 0 to DBGrid2.SelectedRows.Count-1 do
        begin
            //On va (tenter) chercher l'enregistrement de l'ingrédient correspondant
            try
            begin
                Compo2Dbf.GotoBookmark(Pointer(DBGrid2.SelectedRows.Items[i]));

                //On supprime l'enregistrement
                Compo2Dbf.Delete;
            end
            except
            end;
        end;

        CompoDbf.Refresh;
        Compo2Dbf.Refresh;
    end
end;

procedure TRecipeFrame.DeleteRecipeButtonClick(Sender: TObject);
var
  i: Integer;
begin
    //Demande de confirmation
    if MessageDlg('Êtes-vous sûr(e) de vouloir supprimer le(s) recette(s) sélectionnée(s) ?',
        mtConfirmation, [mbYes,mbNo], 0) = mrYes then
    begin
        //Suppression d'une recette
        if DBGrid1.SelectedRows.Count > 0 then
        begin
            //On parcourt chacune des recettes sélectionnées
            for i := 0 to DBGrid1.SelectedRows.Count-1 do
            begin
                //On va chercher l'enregistrement de la recette correspondante
                try
                begin
                    RecipeDbf.GotoBookmark(Pointer(DBGrid1.SelectedRows.Items[i]));

                    //On supprime l'enregistrement
                    RecipeDbf.Delete;
                end
                except
                end;
            end;
        end
    end;
end;

procedure TRecipeFrame.IngrDbfFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
    //Fonction qui permet de définir quels ingrédients sont filtrés.
    //On teste s'ils commencent comme la recherche de l'utilisateur.
    Accept := AnsiStartsText(SearchIngrEdit.Text,
        IngrDbf.FieldByName('INTITULE').AsString);
end;

procedure TRecipeFrame.NewRecipeButtonClick(Sender: TObject);
var
  LastCodeUsed: Integer;
begin
    //Ajout d'un nouvel enregistrement de recette

    //Récuperation du dernier 'CODE' (pour créer une nouvelle recette avec
    //DernierCode + 1
    RecipeDbf.Last;
    LastCodeUsed := RecipeDbf.FieldByName('CODE').AsInteger;

    //Ajout de l'enregistrement avec un 'CODE' unique.
    RecipeDbf.Insert;
    RecipeDbf.FieldByName('CODE').AsInteger := LastCodeUsed + 1;
    RecipeDbf.FieldByName('INTITULE').AsString := 'Nouvelle recette';
    RecipeDbf.Post;
end;

procedure TRecipeFrame.CompoDbfAfterOpen(DataSet: TDataSet);
begin
    //Juste après l'ouverture de la BDD
    //On définit le champ NAME_INGRE comme étant un champ calculé
    CompoDbf.FieldByName('NAME_INGRE').FieldKind := fkCalculated;
end;

procedure TRecipeFrame.AddIngrButtonClick(Sender: TObject);
var
  i: Integer;
  lastId: Integer;
begin
    //On ajoute tous les ingrédients sélectionnés à la liste d'ingrédients
    if DBGrid3.SelectedRows.Count > 0 then
    begin
        //On parcourt chacun des ingrédients sélectionnés
        for i := 0 to DBGrid3.SelectedRows.Count-1 do
        begin
            //On va chercher l'enregistrement de l'ingrédient correspondant
            IngrDbf.GotoBookmark(Pointer(DBGrid3.SelectedRows.Items[i]));

            //On ajoute un nouvel enregistrement dans la table Composit.dbf
            //en remplissant les champs correctement
            Compo2Dbf.Insert;
            Compo2Dbf.FieldByName('CODE_RECET').AsFloat :=
                RecipeDbf.FieldByName('CODE').AsFloat;
            Compo2Dbf.FieldByName('CODE_INGRE').AsFloat :=
                IngrDbf.FieldByName('CODE').AsFloat;
            Compo2Dbf.FieldByName('QTE').AsFloat := 1;
            Compo2Dbf.Post;
        end;

        CompoDbf.Refresh;
    end
end;

procedure TRecipeFrame.CompoDbfBeforeOpen(DataSet: TDataSet);
begin

end;

constructor TRecipeFrame.Create(AOwner: TComponent);
var
  IngrNameCalcField: TStringField;
  QteField: TFloatField;
  CodeIngrField: TFloatField;
  CodeRecipeField: TFloatField;
begin
    inherited Create(AOwner);

    //Connexion à la BDD
    RecipeDbf.FilePathFull := GetCurrentDir();
    RecipeDbf.TableLevel := 4;
    RecipeDbf.TableName :='RECETTES.DBF';
    RecipeDbf.Open;

    //Ouverture de la BDD d'ingrédients (pour afficher les ingrédients dispos)
    IngrDbf.FilePathFull := GetCurrentDir();
    IngrDbf.TableLevel := 4;
    IngrDbf.TableName :='INGREDIE.DBF';
    IngrDbf.Open;

    //Ouverture de la BDD d'ingrédients (utilisée pour afficher les nom à la
    //place des numéro pour la BDD Composit.DBF)
    CompoIngrDbf.FilePathFull := GetCurrentDir();
    CompoIngrDbf.TableLevel := 4;
    CompoIngrDbf.TableName :='INGREDIE.DBF';
    CompoIngrDbf.Open;

    //Ajout d'un champ calculé à la BDD COMPOSIT.DBF (qui permettra d'afficher
    //le nom de l'ingrédient à partir de son CODE_INGRE)
    IngrNameCalcField := TStringField.Create(nil);
    IngrNameCalcField.FieldKind := fkCalculated;
    IngrNameCalcField.FieldName := 'NAME_INGRE';
    IngrNameCalcField.DataSet := CompoDbf;

    //Ajout du champ qui récupèrera la quantité (obligé de le faire manuellement
    //car on a ajouté un champs manuellement).
    QteField := TFloatField.Create(nil);
    QteField.FieldKind := fkData;
    QteField.FieldName := 'QTE';
    QteField.Precision := 5;
    QteField.DataSet := CompoDbf;

    //Ajout (pour la même raison) du champs contenant le code de l'ingrédient
    CodeIngrField := TFloatField.Create(nil);
    CodeIngrField.FieldKind := fkData;
    CodeIngrField.FieldName := 'CODE_INGRE';
    CodeIngrField.Precision := 5;
    CodeIngrField.DataSet := CompoDbf;

    //Ajout (pour la même raison) du champs contenant le code de la recette
    CodeRecipeField := TFloatField.Create(nil);
    CodeRecipeField.FieldKind := fkData;
    CodeRecipeField.FieldName := 'CODE_RECET';
    CodeRecipeField.Precision := 5;
    CodeRecipeField.DataSet := CompoDbf;

    //Ouverture de la BDD de composition
    CompoDbf.FilePathFull := GetCurrentDir();
    CompoDbf.TableLevel := 4;
    CompoDbf.TableName :='COMPOSIT.DBF';
    CompoDbf.Open;

    //Ouverture de la BDD de composition (encore une autre pour pourvoir y
    //ajouter des association recettes/ingrédients). En effet, l'ajout d'un
    //champ calculé dans CompoDbf cause un problème lors des modifications des
    //champs...
    Compo2Dbf.FilePathFull := GetCurrentDir();
    Compo2Dbf.TableLevel := 4;
    Compo2Dbf.TableName :='COMPOSIT.DBF';
    Compo2Dbf.Open;
end;

end.

