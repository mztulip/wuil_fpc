program hello_gui;

{$MODE DELPHI}

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Forms, StdCtrls, Dialogs;

type
  TMainForm = class(TForm)
  private
    FLabel: TLabel;
    FButton: TButton;
    FEdit: TEdit;
    procedure ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormCreate(Self);
  OnPaint := FormPaint;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption := 'WUIL - Windows UI Library (Win16)';
  Left := 50;
  Top := 50;
  Width := 340;
  Height := 200;

  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.Left := 20;
  FLabel.Top := 20;
  FLabel.Width := 300;
  FLabel.Height := 20;
  FLabel.Caption := 'Hello from WUIL on 16-bit Windows!';

  FEdit := TEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.Left := 20;
  FEdit.Top := 50;
  FEdit.Width := 200;
  FEdit.Height := 24;
  FEdit.Text := 'Edit control';

  FButton := TButton.Create(Self);
  FButton.Parent := Self;
  FButton.Left := 20;
  FButton.Top := 90;
  FButton.Width := 100;
  FButton.Height := 30;
  FButton.Caption := 'Click me!';
  FButton.OnClick := ButtonClick;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Canvas.Pen.Color := clBlue;
  Canvas.Pen.Width := 2;
  Canvas.MoveTo(20, 140);
  Canvas.LineTo(300, 140);
end;

procedure TMainForm.ButtonClick(Sender: TObject);
begin
  ShowMessage('Hello from Free Pascal and WUIL!');
  Close;
end;

var
  MainForm: TMainForm;

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
