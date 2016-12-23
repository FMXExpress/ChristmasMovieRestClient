unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FMX.Layouts, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.DBScope,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.TabControl,
  FMX.WebBrowser, Radiant.Shapes, System.Actions, FMX.ActnList, FMX.MultiView,
  FMX.ListBox;

type
  TMainForm = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    Timer1: TTimer;
    ScrollBox1: TScrollBox;
    Timer2: TTimer;
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TitleText: TText;
    YearText: TText;
    TypeText: TText;
    URLText: TText;
    PosterImage: TImage;
    PosterLBL: TLabel;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkPropertyToFieldText2: TLinkPropertyToField;
    LinkPropertyToFieldText5: TLinkPropertyToField;
    WebBrowser1: TWebBrowser;
    Layout1: TLayout;
    Layout2: TLayout;
    ActionList: TActionList;
    Action1: TAction;
    ToolBar1: TToolBar;
    BackButton: TButton;
    StyleBook: TStyleBook;
    Button2: TButton;
    Button3: TButton;
    Text1: TText;
    RESTClient2: TRESTClient;
    RESTRequest2: TRESTRequest;
    RESTResponse2: TRESTResponse;
    RESTResponseDataSetAdapter2: TRESTResponseDataSetAdapter;
    FDMemTable2: TFDMemTable;
    VertScrollBox1: TVertScrollBox;
    RatedText: TText;
    RuntimeText: TText;
    PlotText: TText;
    MetascoreText: TText;
    imdbRatingText: TText;
    imdbVotesText: TText;
    AwardsText: TText;
    ActorsText: TText;
    BindSourceDB2: TBindSourceDB;
    LinkPropertyToFieldText3: TLinkPropertyToField;
    LinkPropertyToFieldText4: TLinkPropertyToField;
    LinkPropertyToFieldText6: TLinkPropertyToField;
    LinkPropertyToFieldText7: TLinkPropertyToField;
    LinkPropertyToFieldText8: TLinkPropertyToField;
    LinkPropertyToFieldText9: TLinkPropertyToField;
    LinkPropertyToFieldText10: TLinkPropertyToField;
    LinkPropertyToFieldText11: TLinkPropertyToField;
    LinkPropertyToFieldText12: TLinkPropertyToField;
    LinkPropertyToFieldText13: TLinkPropertyToField;
    LinkPropertyToFieldText: TLinkPropertyToField;
    MenuButton: TButton;
    Layout3: TLayout;
    MultiView1: TMultiView;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    Rectangle1: TRectangle;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure PosterImageClick(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure BackButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure MenuButtonClick(Sender: TObject);
    procedure ListBoxItem1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declaration }
    IsResizing: Boolean;
    APIPage: Integer;
    APIKeyword: String;
    procedure OpenData(S: String; Img: TBitmap);
    procedure ClearScrollBox;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  uImageFrame;

procedure TMainForm.OpenData(S: string; Img: TBitmap);
begin
  TabControl.ActiveTab := TabItem2;
  BackButton.Visible := True;
  //FDMemTable1.Filter := 'imdbID = '''+S+'''';
 // FDMemTable1.Filtered := True;
  //FDMemTable1.First;
  PosterImage.Bitmap.Assign(Img);
  PosterImage.Repaint;
  RESTClient2.BaseURL := 'http://www.omdbapi.com/?plot=full&i='+S;
  RESTRequest2.Execute;
end;

procedure TMainForm.PosterImageClick(Sender: TObject);
begin
  TabControl.ActiveTab := TabItem3;
  WebBrowser1.Visible := True;
  WebBrowser1.URL := 'http://www.imdb.com/title/'+URLText.Text+'/';
end;

procedure TMainForm.ClearScrollBox;
var
I: Integer;
begin
    ScrollBox1.BeginUpdate;
    if ScrollBox1.Children[1].ChildrenCount>1 then
     for I := ScrollBox1.Children[1].ChildrenCount-1 downto 0 do
       begin
        TImageFrame(ScrollBox1.Children[1].Children[I]).Visible := False;
        TImageFrame(ScrollBox1.Children[1].Children[I]).Free;
       end;
    ScrollBox1.EndUpdate;
end;

procedure TMainForm.Action1Execute(Sender: TObject);
var
Img: TImageFrame;
I: Integer;
LastWidth: Single;
LastHeight: Single;
begin
RESTClient1.BaseURL := 'http://www.omdbapi.com/?s='+APIKeyword+'&page='+APIPage.ToString;
RESTRequest1.Execute;
FDMemTable1.First;
I := 0;
LastWidth := 0;
LastHeight := 0;
while not FDMemTable1.Eof do
 begin
  Img := TImageFrame.Create(Self);
  Img.Name := '';
  Img.Parent := ScrollBox1;
  Img.Position.X := LastWidth;
  Img.Position.Y := LastHeight;
  Img.LoadImageFromURL(FDMemTable1.FieldByName('Poster').AsString);
  Img.Title := FDMemTable1.FieldByName('Title').AsString;
  Img.Year := FDMemTable1.FieldByName('Year').AsString;
  Img.imdbID := FDMemTable1.FieldByName('imdbID').AsString;
  Img.aType := FDMemTable1.FieldByName('Type').AsString;
  {$IF DEFINED(ANDROID) OR DEFINED(IOS)}
  Img.Height := Img.Height * (Self.Width/Img.Width);
  Img.Width := Self.Width;
  {$ENDIF}
  LastWidth := Img.Width+LastWidth;
  if LastWidth>Self.Width-Img.Width then
   begin
     LastHeight := Img.Height+LastHeight;
     LastWidth := 0;
   end;
  Inc(I);
  FDMemTable1.Next;
 end;

end;

procedure TMainForm.BackButtonClick(Sender: TObject);
begin
if TabControl.ActiveTab=TabItem2 then
 begin
  TabControl.ActiveTab := TabItem1;
  BackButton.Visible := False;
 end;
if TabControl.ActiveTab=TabItem3 then
 TabControl.ActiveTab := TabItem2;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
 APIPage := APIPage+1;
 ClearScrollBox;
 Action1.Execute;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  if APIPage>1 then
   begin
    APIPage := APIPage-1;
    ClearScrollBox;
    Action1.Execute;
   end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
APIKeyword := ListBoxItem1.Text;
APIPage := 1;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
IsResizing := True;
end;

procedure TMainForm.ListBoxItem1Click(Sender: TObject);
begin
APIKeyword := TListBoxItem(Sender).Text;
APIPage := 1;
ClearScrollBox;
Action1.Execute;
MultiView1.HideMaster;
end;

procedure TMainForm.MenuButtonClick(Sender: TObject);
begin
TabControl.ActiveTab := TabItem1;
end;

procedure TMainForm.TabControlChange(Sender: TObject);
begin
if (TabControl.ActiveTab<>TabItem3) then
 begin
    WebBrowser1.Visible := False;
 end
else
 begin
    WebBrowser1.Visible := True;
 end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled := False;
Action1.Execute;
end;

procedure TMainForm.Timer2Timer(Sender: TObject);
var
  I: Integer;
  LastWidth,LastHeight: Single;
  Img: TImageFrame;
  S: String;
begin
if (IsResizing=True) AND (TabControl.ActiveTab=TabItem1) then
 begin
    LastWidth := 0;
    LastHeight := 0;
    ScrollBox1.BeginUpdate;
    if ScrollBox1.Children[1].ChildrenCount>1 then
     for I := 0 to ScrollBox1.Children[1].ChildrenCount-1 do
       begin
         Img := TImageFrame(ScrollBox1.Children[1].Children[I]);
         Img.Position.X := LastWidth;
         Img.Position.Y := LastHeight;
         LastWidth := Img.Width+LastWidth;
         if LastWidth>Self.Width-Img.Width then
          begin
            LastHeight := Img.Height+LastHeight;
            LastWidth := 0;
          end;
       end;
    ScrollBox1.EndUpdate;
    IsResizing := False;
 end;
end;

end.
