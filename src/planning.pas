unit Planning;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dbf, db, FileUtil, Forms, Controls, StdCtrls, ComCtrls,
  ExtCtrls, Dialogs, DbCtrls, DBGrids, PlanningDay, fgl;

type
  TPlanningDayControlsMap2 = specialize TFPGMap<TMealtime, TPlanningDayControl>;
  TPlanningDayControlsMap = specialize TFPGMap<TDayOfWeek, TPlanningDayControlsMap2>;
  TLabelList = array of TLabel;

  { TPlanningFrame }

  TPlanningFrame = class(TFrame)
      Button1: TButton;
      EditOkButton: TButton;
      EditCancelButton: TButton;
      DBGrid1: TDBGrid;
      EditRecipeButton: TButton;
      InfoCompoDS: TDatasource;
      InfoCompoDbf: TDbf;
      InfoIngrDS: TDatasource;
      InfoIngrDbf: TDbf;
      DBText1: TDBText;
      DBText2: TDBText;
      DBText3: TDBText;
      DBText4: TDBText;
      DBText5: TDBText;
      DBText6: TDBText;
      DBText7: TDBText;
      Image1: TImage;
      InfoRecipeDS: TDatasource;
      InfoRecipeNameLabel: TDBText;
      InfoRecipeDbf: TDbf;
    InformationGroupBox: TGroupBox;
    InformationPageControl: TPageControl;
    InfoDayMealtimeLabel: TLabel;
    CenterLabel: TLabel;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    InfoIngrListBox: TListView;
    ScrollPanel: TPanel;
    InsideScrollPanel: TPanel;
    ScrollBar1: TScrollBar;
    InformationTabSheet: TTabSheet;
    EditTabSheet: TTabSheet;
    procedure EditCancelButtonClick(Sender: TObject);
    procedure EditRecipeButtonClick(Sender: TObject);
    procedure FrameClick(Sender: TObject);
    procedure ScrollPanelResize(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
        var ScrollPos: Integer);
  private
    { private declarations }
    procedure OnDishSelected(Day: TDayOfWeek; Mealtime: TMealtime;
        TypeOfRecipe: TRecipeType; RecipeId: Integer);

    //Crée le PlanningDayControl associé à un jour + repas précis
    procedure CreatePlanningDayControl(Day: TDayOfWeek; Mealtime: TMealtime);

    //Dès que les deux PlanningDayControls d'un jour ont été créés, appeler
    //cette méthode afin de configurer leurs anchors pour qu'ils soient étirés
    //corectement
    procedure SetPlanningDayControlAnchors(Day: TDayOfWeek);

    //Crée les labels affichant les jours
    procedure AddDayLabels();

  private
    { Un tableau associatif pour associer un repas (jour + midi/soir) et un
      contrôle PlanningDayControl }
    PlanningDayControls: TPlanningDayControlsMap;

    //Tableau avec les labels créés pour chaque jours
    LabelList: TLabelList;

    //Plat actuellement sélectionné
    SelectedDay: TDayOfWeek;
    SelectedMealtime: TMealtime;
    SelectedRecipeType: TRecipeType;
    SelectedRecipeId: Integer;

    //Booléen qui est vrai si on est en mode "changement de recette"
    IsInEditMode: Boolean;

  public
    { public declarations }
    //Surcharge du constructeur permettant d'initialiser la connexion à la base
    //de données et de paramétrer quelques autres choses.
    constructor Create(AOwner: TComponent) ; override;

  end;

implementation

{$R *.lfm}

procedure TPlanningFrame.ScrollBar1Change(Sender: TObject);
begin

end;

procedure TPlanningFrame.ScrollPanelResize(Sender: TObject);
begin
    ScrollBar1.Max := 2365 - ScrollPanel.Width;
    ScrollBar1.PageSize := ScrollPanel.Width;
end;

procedure TPlanningFrame.FrameClick(Sender: TObject);
begin

end;

procedure TPlanningFrame.EditRecipeButtonClick(Sender: TObject);
begin
    //Si un plat est sélectionné, on passe en mode "changement de plat"
    if(SelectedDay <> dowNone) then
    begin
        IsInEditMode := True;
        InformationPageControl.PageIndex := 0;
    end;
end;

procedure TPlanningFrame.EditCancelButtonClick(Sender: TObject);
begin
    InformationPageControl.PageIndex := 1;

    IsInEditMode := False;

    //On réinitialise l'affichage pour être sûr de bien pointer le bon plat
    //dans le InfoRecipeDbf (on simule un clic sur le plat déjà sélectionné
    //dans le planning).
    OnDishSelected(SelectedDay, SelectedMealtime, SelectedRecipeType,
        SelectedRecipeId);
end;

procedure TPlanningFrame.ScrollBar1Scroll(Sender: TObject;
    ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
    InsideScrollPanel.Left := -ScrollPos;
end;

procedure TPlanningFrame.OnDishSelected(Day: TDayOfWeek; Mealtime: TMealtime;
    TypeOfRecipe: TRecipeType; RecipeId: Integer);
var
  i: Integer;
  CodeIngr: Integer;
  Item: TListItem;
begin
    if IsInEditMode and ((SelectedDay <> Day) or (SelectedMealtime <> Mealtime) or
        (SelectedRecipeType <> TypeOfRecipe))
        {TODO : Ajouter le demande de confirmation à l'utilisateur}  then
    begin
        //On est en mode édition, on demande à l'utilisateur s'il est sûr
        //de vouloir bouger la sélection pendant qu'il édite un plat

        //S'il le veut, on le repasse en mode édition, sinon, on abandonne le
        //changement de sélection

        //On remet la sélection (des listes de repas des jours) à son état
        //initial
    end
    else
    begin
        SelectedDay := Day;
        SelectedMealtime := Mealtime;
        SelectedRecipeType := TypeOfRecipe;
        SelectedRecipeId := RecipeId;

        //Sélection de la recette dans le base de données
        //Les informations seront automatiquement affichées avec les labels
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

        //On utilise la table des compositions pour trouver les ID des ingrédients
        //de la recette sélectionnée
        InfoCompoDbf.Filter:='CODE_RECET=' + IntToStr(RecipeId);
        InfoCompoDbf.Filtered:=True;
        InfoCompoDbf.First;

        //On boucle sur tous les ingrédients associés à la recette
        InfoIngrListBox.Clear;
        while not InfoCompoDbf.EOF do
        begin
            CodeIngr := InfoCompoDbf.FieldByName('CODE_INGRE').AsInteger;

            InfoIngrDbf.Filter := 'CODE=' + IntToStr(CodeIngr);
            InfoIngrDbf.Filtered := True;

            Item := InfoIngrListBox.Items.Add;
            Item.Caption := InfoIngrDbf.FieldByName('INTITULE').AsString;
            Item.SubItems.Add(InfoCompoDbf.FieldByName('QTE').AsString + ' ' + InfoIngrDbf.FieldByName('UNITE').AsString);

            InfoCompoDbf.Next;
        end;
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
    PlanningDayControls[Day][Mealtime].Parent := InsideScrollPanel;

    //On affecte le jour et le repas au contrôle
    PlanningDayControls[Day][Mealtime].Day := Day;
    PlanningDayControls[Day][Mealtime].Mealtime := Mealtime;

    //On positionne le contrôle selon son jour et le repas
    if Mealtime = mtLunch then
        PlanningDayControls[Day][Mealtime].Top := 45
    else if Mealtime = mtDinner then
        PlanningDayControls[Day][Mealtime].Top := 300;

    PlanningDayControls[Day][Mealtime].Left := 125 + (Integer(Day) - 1) * 320;

    //Connexion à l'event handler
    PlanningDayControls[Day][Mealtime].OnDishSelected := @OnDishSelected;
end;

procedure TPlanningFrame.SetPlanningDayControlAnchors(Day: TDayOfWeek);
begin
    //Définition des anchors et des contrôles sur lesquels s'ancrer
    PlanningDayControls[Day][mtLunch].AnchorSide[akBottom].Side := asrTop;
    PlanningDayControls[Day][mtLunch].AnchorSide[akBottom].Control := CenterLabel;

    PlanningDayControls[Day][mtDinner].AnchorSide[akTop].Side := asrBottom;
    PlanningDayControls[Day][mtDinner].AnchorSide[akTop].Control := CenterLabel;

    //Ajout des anchors à utiliser
    PlanningDayControls[Day][mtLunch].Anchors := PlanningDayControls[Day][mtLunch].Anchors + [akBottom];
    PlanningDayControls[Day][mtDinner].Anchors := [akBottom, akLeft, akTop];
end;

procedure TPlanningFrame.AddDayLabels();
var
  Day: TDayOfWeek;
begin
    SetLength(LabelList, 9);

    for Day := dowMonday to dowSunday do
    begin
        LabelList[Integer(Day) - 1] := TLabel.Create(self);
        LabelList[Integer(Day) - 1].Name := 'DayLabel' + IntToStr(Integer(Day));
        LabelList[Integer(Day) - 1].Parent := InsideScrollPanel;
        LabelList[Integer(Day) - 1].Left := 145 + (Integer(Day) - 1) * 320;
        LabelList[Integer(Day) - 1].Top := 20;
        LabelList[Integer(Day) - 1].Font.Bold := True;
        case Day of
            dowMonday: LabelList[Integer(Day) - 1].Caption := 'Lundi';
            dowTuesday: LabelList[Integer(Day) - 1].Caption := 'Mardi';
            dowWednesday: LabelList[Integer(Day) - 1].Caption := 'Mercredi';
            dowThursday: LabelList[Integer(Day) - 1].Caption := 'Jeudi';
            dowFriday: LabelList[Integer(Day) - 1].Caption := 'Vendredi';
            dowSaturday: LabelList[Integer(Day) - 1].Caption := 'Samedi';
            dowSunday: LabelList[Integer(Day) - 1].Caption := 'Dimanche';
        else LabelList[Integer(Day) - 1].Caption := '';
        end;
    end;
end;

constructor TPlanningFrame.Create(AOwner: TComponent);
var
  Day: TDayOfWeek;
begin
     inherited Create(AOwner);

     SelectedDay := dowNone;
     SelectedMealtime := mtNone;
     SelectedRecipeType := rtNone;
     SelectedRecipeId := -1;

     IsInEditMode := False;

     InformationPageControl.PageIndex := 1;

     //Chargement des bases de données
     InfoRecipeDbf.FilePathFull := GetCurrentDir();
     InfoRecipeDbf.TableLevel := 4;
     InfoRecipeDbf.TableName :='RECETTES.DBF';
     InfoRecipeDbf.Open;

     InfoIngrDbf.FilePathFull := GetCurrentDir();
     InfoIngrDbf.TableLevel := 4;
     InfoIngrDbf.TableName :='INGREDIE.DBF';
     InfoIngrDbf.Open;

     InfoCompoDbf.FilePathFull := GetCurrentDir();
     InfoCompoDbf.TableLevel := 4;
     InfoCompoDbf.TableName :='COMPOSIT.DBF';
     InfoCompoDbf.Open;

     //Création dynamique des TPlanningDayControls
     PlanningDayControls := TPlanningDayControlsMap.Create;

     for Day := dowMonday to dowSunday do
     begin
         CreatePlanningDayControl(Day, mtLunch);
         CreatePlanningDayControl(Day, mtDinner);
         SetPlanningDayControlAnchors(Day);
     end;
     AddDayLabels();
end;

end.

