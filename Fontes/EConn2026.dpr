program EConn2026;

uses
  Vcl.Forms,
  FEConn2026 in 'FEConn2026.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
