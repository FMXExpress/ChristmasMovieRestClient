unit uImageFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  System.Actions, FMX.ActnList, FMX.Objects;

type
  TImageFrame = class(TFrame)
    Image: TImage;
    NetHTTPClient1: TNetHTTPClient;
    procedure ImageClick(Sender: TObject);
    procedure ImageTap(Sender: TObject; const Point: TPointF);
  private
    { Private declarations }
  public
    { Public declarations }
    Title, Year, imdbID, aType: String;
    ImageURL: String;
    procedure LoadImageFromURL(URL: String);
  end;

implementation

{$R *.fmx}

uses
 Unit1;

procedure TImageFrame.ImageClick(Sender: TObject);
begin
{$IF DEFINED(MSWINDOWS) OR (DEFINED(MACOS) AND NOT DEFINED(IOS))}
MainForm.OpenData(imdbID,Image.Bitmap);
{$ENDIF}
end;

procedure TImageFrame.ImageTap(Sender: TObject; const Point: TPointF);
begin
{$IF DEFINED(ANDROID) OR DEFINED(IOS)}
MainForm.OpenData(imdbID,Image.Bitmap);
{$ENDIF}
end;

procedure TImageFrame.LoadImageFromURL(URL: String);
var
AResponseContent: TMemoryStream;
begin
ImageURL := URL;
AResponseContent := TMemoryStream.Create;
if (URL<>'N/A') then
 begin
  NetHTTPClient1.Get(ImageURL,AResponseContent);
  try
  Image.Bitmap.LoadFromStream(AResponseContent);
  except
  end;
 end;
Self.Width := Image.Width;
AResponseContent.Free;
NetHTTPClient1.Free;
end;

end.
