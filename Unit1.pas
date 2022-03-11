unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCCloudBase, FMX.TMSFNCCloudTranslation,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.ListBox,
  FMX.Controls.Presentation, FMX.TMSFNCTypes, FMX.TMSFNCUtils,
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCWXSpeechSynthesis,
  FMX.TMSFNCCustomControl, FMX.TMSFNCWebBrowser, FMX.TMSFNCCustomWEBControl,
  FMX.TMSFNCCustomWEBComponent, FMX.TMSFNCWXSpeechToText, FMX.Edit;

type
  TForm1 = class(TForm)
    TMSFNCCloudTranslation1: TTMSFNCCloudTranslation;
    btnGetLanguages: TButton;
    lbxLanguages: TListBox;
    lblSelectedLanguage: TLabel;
    btnTranslate: TButton;
    memoSentences: TMemo;
    memoTranslatedSentences: TMemo;
    btnDetect: TButton;
    lblDetectedLanguage: TLabel;
    procedure btnTranslateClick(Sender: TObject);
    procedure btnGetLanguagesClick(Sender: TObject);
    procedure btnDetectClick(Sender: TObject);
    procedure TMSFNCCloudTranslation1GetSupportedLanguages(Sender: TObject;
      const ALanguages: TStringList;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure lbxLanguagesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FTranslationLanguage: String;
    procedure DoTranslateMemo(const ARequest: TTMSFNCCloudTranslationRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoDetectEdit(const ARequest: TTMSFNCCloudTranslationRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FTranslationLanguage := 'en';
end;

procedure TForm1.btnGetLanguagesClick(Sender: TObject);
begin
  TMSFNCCloudTranslation1.GetSupportedLanguages;
end;

procedure TForm1.btnDetectClick(Sender: TObject);
begin
  TMSFNCCloudTranslation1.Detect(memoSentences.Text, DoDetectEdit);
end;

procedure TForm1.btnTranslateClick(Sender: TObject);
var
  sl: TStringList;
begin
  memoTranslatedSentences.Lines.Clear;
  sl := TStringList.Create;
  try
    sl.Assign(memoSentences.Lines);
    TMSFNCCloudTranslation1.Translate(sl, FTranslationLanguage, DoTranslateMemo);
  finally
    sl.Free;
  end;
end;

procedure TForm1.lbxLanguagesClick(Sender: TObject);
begin
  if (lbxLanguages.ItemIndex >= 0) and (lbxLanguages.ItemIndex <= lbxLanguages.Items.Count - 1) then
  begin
    lblSelectedLanguage.Text := 'Selected Language: ' + lbxLanguages.Items.Names[lbxLanguages.ItemIndex];
    FTranslationLanguage := lbxLanguages.Items.Values[lbxLanguages.Items.Names[lbxLanguages.ItemIndex]];
  end;
end;

procedure TForm1.TMSFNCCloudTranslation1GetSupportedLanguages(Sender: TObject; const ALanguages: TStringList; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  lbxLanguages.Items.Assign(ALanguages);
end;

procedure TForm1.DoDetectEdit(const ARequest: TTMSFNCCloudTranslationRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if ARequest.Detections.Count > 0 then
    lblDetectedLanguage.Text := 'Detected Language: ' + ARequest.Detections[0].SourceLanguage;
end;

procedure TForm1.DoTranslateMemo(const ARequest: TTMSFNCCloudTranslationRequest;const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
  I: Integer;
begin
  for I := 0 to ARequest.Translations.Count - 1 do
    memoTranslatedSentences.Lines.Add(ARequest.Translations[I].TranslatedText);
end;

end.
