unit EConn2026.Test;

interface

uses
  DUnitX.TestFramework,
  FEConn2026;

type
  [TestFixture]
  TEConn2026Test = class
  private
    FForm1: TForm1;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    [TestCase('SomaSimples', '2,2,4')]
    procedure Test1(const ANum1, ANum2: Integer; const AResultadoEsperado: Integer);
  end;

implementation

procedure TEConn2026Test.Setup;
begin
  FForm1 := TForm1.Create(nil);
end;

procedure TEConn2026Test.TearDown;
begin
  FForm1.Free;
end;

procedure TEConn2026Test.Test1(const ANum1, ANum2: Integer; const AResultadoEsperado: Integer);
var
  LResultadoObtido: Integer;
begin
  LResultadoObtido := FForm1.Soma(ANum1, ANum2);
  Assert.AreEqual(AResultadoEsperado, LResultadoObtido);
end;

end.
