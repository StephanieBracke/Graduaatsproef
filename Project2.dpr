program Project2;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Graduaatsproef\Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.