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
  FMX.TMSFNCCustomWEBComponent, FMX.TMSFNCWXSpeechToText, FMX.Edit, StrUtils;

type
  TForm1 = class(TForm)
    TMSFNCCloudTranslation1: TTMSFNCCloudTranslation;
    btnGetLanguages: TButton;
    lbxLanguages: TListBox;
    lblSelectedLanguage: TLabel;
    btnTranslate: TButton;
    memoSentences: TMemo;
    memoTranslatedSentences: TMemo;
    lblDetectedLanguage: TLabel;
    TMSFNCWXSpeechSynthesis1: TTMSFNCWXSpeechSynthesis;
    btnSpeak: TButton;
    btnConfigure: TButton;
    TMSFNCWXSpeechToText1: TTMSFNCWXSpeechToText;
    btnPause: TButton;
    btnResume: TButton;
    btnCancel: TButton;
    lblSpeech: TLabel;
    btnClear: TButton;
    procedure btnTranslateClick(Sender: TObject);
    procedure btnGetLanguagesClick(Sender: TObject);
    procedure TMSFNCCloudTranslation1GetSupportedLanguages(Sender: TObject;
      const ALanguages: TStringList;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure lbxLanguagesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSpeakClick(Sender: TObject);
    procedure btnConfigureClick(Sender: TObject);
    procedure Init(Sender:TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnResumeClick(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure TMSFNCWXSpeechSynthesis1End(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure Clear(Sender: TObject);
    procedure Translate(Sender: TObject);
    procedure Speak(Sender: TObject);
    procedure Pause(Sender: TObject);
    procedure Resume(Sender: TObject);
    procedure Cancel(Sender: TObject);
    procedure ShowLanguages(Sender: TObject);
    procedure TMSFNCWXSpeechToText1ResultNoMatch(Sender: TObject;
      Phrases: TStrings);
    procedure Dutch(Sender: TObject);
    procedure TMSFNCWXSpeechToText1ResultMatch(Sender: TObject;
      userSaid: string; Parameters: TStrings;
      Command: TTMSFNCWXSpeechToTextCommand; Phrases: TStrings);
    procedure Select(Sender: TObject);
  private
    { Private declarations }
    FTranslationLanguage: String;
    procedure DoTranslateMemo(const ARequest: TTMSFNCCloudTranslationRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);
    procedure DoDetectEdit(const ARequest: TTMSFNCCloudTranslationRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);
  public
    { Public declarations }
  end;

ShowDebug = class(TTMSFNCWXSpeechToText);

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ShowDebug(TMSFNCWXSpeechToText1).ShowDebugConsole;
  FTranslationLanguage := 'en';
  TMSFNCWXSpeechToText1.OnInitialized := Init;
  TTMSFNCUtils.Log('Initialized');
end;

procedure TForm1.Init(Sender: TObject);
begin
 TMSFNCWXSpeechToText1.Start;
 TTMSFNCUtils.Log('started SpeechToText');
end;


procedure TForm1.btnGetLanguagesClick(Sender: TObject);
begin
  TMSFNCCloudTranslation1.GetSupportedLanguages;
end;

procedure TForm1.btnPauseClick(Sender: TObject);
begin
  TMSFNCWXSpeechSynthesis1.Pause;
  lblSpeech.Text := 'Paused';
end;

procedure TForm1.Pause(Sender: TObject);
begin
  TMSFNCWXSpeechSynthesis1.Pause;
  lblSpeech.Text := 'Paused';
end;

procedure TForm1.btnResumeClick(Sender: TObject);
begin
  TMSFNCWXSpeechSynthesis1.Resume;

  if (TMSFNCWXSpeechSynthesis1.IsSpeaking) then
    lblSpeech.Text :='Speaking...'
  else
    lblSpeech.Text := 'There''s nothing to resume';
end;

procedure TForm1.Resume(Sender: TObject);
begin
  TMSFNCWXSpeechSynthesis1.Resume;

  if (TMSFNCWXSpeechSynthesis1.IsSpeaking) then
    lblSpeech.Text :='Speaking...'
  else
    lblSpeech.Text := 'There''s nothing to resume';
end;

procedure TForm1.btnSpeakClick(Sender: TObject);
begin
  TMSFNCWXSpeechSynthesis1.Speak(memoTranslatedSentences.Lines.Text);

  if (TMSFNCWXSpeechSynthesis1.IsSpeaking) then
    lblSpeech.Text :='Please cancel and restart first'
  else
    lblSpeech.Text := 'Speaking...';
end;

procedure TForm1.Select(Sender: TObject);
begin
//Splat
end;

procedure TForm1.ShowLanguages(Sender: TObject);
begin
  TMSFNCCloudTranslation1.GetSupportedLanguages;
end;

procedure TForm1.Speak(Sender: TObject);
begin
  TMSFNCWXSpeechSynthesis1.Speak(memoTranslatedSentences.Lines.Text);

  if (TMSFNCWXSpeechSynthesis1.IsSpeaking) then
    lblSpeech.Text :='Please cancel and restart first'
  else
    lblSpeech.Text := 'Speaking...';
end;

procedure TForm1.btnCancelClick(Sender: TObject);
begin
  TMSFNCWXSpeechSynthesis1.Cancel;
end;

procedure TForm1.Cancel(Sender: TObject);
begin
  TMSFNCWXSpeechSynthesis1.Cancel;
end;

procedure TForm1.btnClearClick(Sender: TObject);
begin
  memoSentences.Lines.Clear;
end;

procedure TForm1.Clear(Sender: TObject);
begin
  memoSentences.Lines.Clear;
end;

procedure TForm1.btnConfigureClick(Sender: TObject);
begin
  TMSFNCWXSpeechSynthesis1.ConfigureVoices;
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
    TMSFNCCloudTranslation1.Detect(memoSentences.Text, DoDetectEdit);
  finally
    sl.Free;
  end;
end;

procedure TForm1.Translate(Sender: TObject);
var
  sl: TStringList;
begin
  memoTranslatedSentences.Lines.Clear;
  sl := TStringList.Create;
  try
    sl.Assign(memoSentences.Lines);
    TMSFNCCloudTranslation1.Translate(sl, FTranslationLanguage, DoTranslateMemo);
    TMSFNCCloudTranslation1.Detect(memoSentences.Text, DoDetectEdit);
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

procedure TForm1.TMSFNCWXSpeechSynthesis1End(Sender: TObject);
begin
  if (TMSFNCWXSpeechSynthesis1.IsSpeaking) then
    lblSpeech.Text :='Speaking...'
  else
    lblSpeech.Text := 'Ended';
end;

procedure TForm1.TMSFNCWXSpeechToText1ResultMatch(Sender: TObject;
  userSaid: string; Parameters: TStrings; Command: TTMSFNCWXSpeechToTextCommand;
  Phrases: TStrings);
var
  I: Integer;
  Select: TTMSFNCWXSpeechToTextCommand;
begin
   if Command.ID = 'Select' then
   begin
     if Parameters.Count > 0 then
     begin
       lblSelectedLanguage.Text := 'Selected Language: ' + Trim(Parameters[0]);
       FTranslationLanguage := lbxLanguages.Items.Values[Trim(Parameters[0])];
     end;
   end;
end;

procedure TForm1.TMSFNCWXSpeechToText1ResultNoMatch(Sender: TObject;
  Phrases: TStrings);
begin
  memoSentences.Lines.AddStrings(Phrases);
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





