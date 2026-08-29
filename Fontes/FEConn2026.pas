unit FEConn2026;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
  private
    { Private declarations }
  public
    function Soma(const ANum1: Integer; const ANum2: Integer): Integer;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

function TForm1.Soma(const ANum1, ANum2: Integer): Integer;
begin
  Result := ANum1 + ANum2;
end;

end.
