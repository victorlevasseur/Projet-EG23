unit Planning;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, ComCtrls, ExtCtrls,
  Dialogs, PlanningDay;

type

  { TPlanningFrame }

  TPlanningFrame = class(TFrame)
    InformationGroupBox: TGroupBox;
    InformationPageControl: TPageControl;
    PlanningDayControl1: TPlanningDayControl;
    ScrollBox1: TScrollBox;
    InformationTabSheet: TTabSheet;
    EditTabSheet: TTabSheet;
    ToolBar1: TToolBar;
    GenerateWeekButton: TToolButton;
    ShoppingListButton: TToolButton;
    ToolButton2: TToolButton;
  private
    { private declarations }
    procedure OnDishSelected(Day: string; MomentOfDay: string; DishType: string);
  public
    { public declarations }
    //Surcharge du constructeur permettant d'initialiser la connexion à la base
    //de données et de paramétrer quelques autres choses.
    constructor Create(AOwner: TComponent) ; override;

  end;

implementation

{$R *.lfm}

procedure TPlanningFrame.OnDishSelected(Day: string; MomentOfDay: string; DishType: string);
begin

end;

constructor TPlanningFrame.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);

     //Affectation des jours et des repas aux différents TPlanningDayControl s


     //Initialisation des events handlers
end;

end.

