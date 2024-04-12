unit Relatorio.FPDF;

interface

uses
  Relatorio.Interfaces, Classes, SysUtils, fpdf, fpdf_ext, System.Generics.Collections, Relatorio.Enums,
  Relatorio.Types;

type
  TReportFPDF = class(TInterfacedObject, IReport)
  strict private
    FFile: String;
    FFontSize: Double;
    FFooter: IReportFooter;
    FLineWidth: Double;
    FMarginBottom: Double;
    FMarginLeft: Double;
    FMarginRight: Double;
    FMarginTop: Double;
    FModo: TReportMode;
    Fpdf: TFPDFExt;
    FTable: IReportTable;
    FHeader: IReportHeader;
    FStream: TMemoryStream;
  strict private
    function ReportBorderToStr(const ArrayRelatorioBordas: TArrayReportBorders): String;
    function ReportAlignToStr(const Alinhamento: TReportAlign): String;
  private
    procedure PrintFooter(APDF: TFPDF);
    procedure PrintHeader(APDF: TFPDF);
  public
    class function New : IReport;

    constructor Create;
    destructor Destroy;override;

    function Execute: IReport;
    function Font(const Family : String; const Style : String = ''; Size: Double = 0): IReport;
    function FontSize: Double; overload;
    function FontSize(Value: Double): IReport; overload;
    function Footer: IReportFooter; overload;
    function Footer(Value: IReportFooter): IReport; overload;
    function Header : IReportHeader; overload;
    function Header(Value: IReportHeader): IReport; overload;
    function Height: Double; overload;
    function LineWidth: Double; overload;
    function LineWidth(Value: Double): IReport; overload;
    function MarginBottom: Double; overload;
    function MarginBottom(Value: Double): IReport; overload;
    function MarginLeft: Double; overload;
    function MarginLeft(Value: Double): IReport; overload;
    function MarginRight: Double; overload;
    function MarginRight(Value: Double): IReport; overload;
    function MarginTop: Double; overload;
    function MarginTop(Value: Double): IReport; overload;
    function Modo: TReportMode; overload;
    function Modo(Value: TReportMode): IReport; overload;
    function NewLine : IReport; overload;
    function NewLine(Height: Double): IReport; overload;
    function NewPage: IReport;
    function PageNumber: integer;
    function PosX: Double; overload;
    function PosX(Value: Double): IReport; overload;
    function PosXY(X, Y: Double): IReport; overload;
    function PosY: Double; overload;
    function PosY(Value: Double): IReport; overload;
    function PrintColumnTable(Const Value: String; Const ForceColumnDefinition: IReportTableColumn = nil) : IReport;
    function PrintImage(FileName: String): IReport; overload;
    function PrintImage(FileName: String; X, Y, Width, Height: Double): IReport; overload;
    function PrintImage(const Stream: TStream; Extension: TReportImagesExt): IReport; overload;
    function PrintImage(const Stream: TStream; Extension: TReportImagesExt; X, Y, Width, Height: Double): IReport; overload;
    function PrintLine(X1, Y1, X2, Y2: Double): IReport;
    function PrintLineTo(X, Y: Double): IReport;
    function PrintText(Const Value: String; QuebraLinha : Boolean = false): IReport;
    function SetFile(const Value: String): IReport; overload;
    function SetFile: String; overload;
    function Stream: TMemoryStream;
    function Table(const Value: IReportTable): IReport; overload;
    function Table : IReportTable; overload;
    function TotalPages: String;
    function Width: Double; overload;
  end;

implementation

uses
  System.Math;

{ TRelatorioFPDF }

function TReportFPDF.SetFile(const Value: String): IReport;
begin
  result := self;
  FFile := Value;
end;

function TReportFPDF.SetFile: String;
begin
  result := FFile;
end;

function TReportFPDF.Stream: TMemoryStream;
begin
  result :=  TMemoryStream.Create;
  result.LoadFromStream(FStream);
end;

function TReportFPDF.Font(const Family : String; const Style : String = ''; Size: Double = 0): IReport;
begin
  result := self;
  Fpdf.SetFont(Family, Style, Size);
  if Size > 0 then
    FFontSize := Size;
end;

function TReportFPDF.FontSize: Double;
begin
  result := FFontSize;
end;

function TReportFPDF.FontSize(Value: Double): IReport;
begin
  result := self;
  FFontSize := Value;
  Fpdf.SetFontSize(FontSize);
end;

function TReportFPDF.Footer(Value: IReportFooter): IReport;
begin
  result := self;
  FFooter := Value;
end;

function TReportFPDF.Footer: IReportFooter;
begin
  result := FFooter;
end;

function TReportFPDF.Header(Value: IReportHeader): IReport;
begin
  result := self;
  FHeader := Value;
end;

function TReportFPDF.Height: Double;
begin
  result := Fpdf.GetPageHeight;
end;


function TReportFPDF.Header: IReportHeader;
begin
  result := FHeader;
end;

constructor TReportFPDF.Create;
begin
  Fpdf := TFPDFExt.Create(PoPortrait, puCM, pfA4);
  fpdf.SetAliasNbPages;
  Fpdf.OnHeader := PrintHeader;
  Fpdf.OnFooter := PrintFooter;
  FTable := TReportTable.New(self);
  FStream := TMemoryStream.Create;
  MarginBottom(1);
  MarginLeft(1);
  MarginTop(1);
  MarginRight(1);
end;

destructor TReportFPDF.Destroy;
begin
  inherited;
  Fpdf.Free;
  FStream.Free;
end;

function TReportFPDF.Execute: IReport;
begin
  Result := self;
  if modo = rmFile then
    Fpdf.SaveToFile(SetFile)
  else if modo = rmStream then
    Fpdf.SaveToStream(FStream)
  else
    raise Exception.Create('Modo do relatório não foi selecionado!');
end;

function TReportFPDF.PrintText(const Value: String;
  QuebraLinha: Boolean): IReport;
begin
  result := self;
  Fpdf.Text(Fpdf.GetX, Fpdf.GetY, Value);
  if QuebraLinha then
    NewLine;
end;

class function TReportFPDF.New: IReport;
begin
  result := self.Create;
end;

function TReportFPDF.NewLine(Height: Double): IReport;
begin
  result := self;
  Fpdf.Ln(Height);
end;

function TReportFPDF.NewLine: IReport;
begin
  result := self;
  Fpdf.Ln;
end;

function TReportFPDF.NewPage: IReport;
begin
  Result := self;
  Fpdf.AddPage;
end;

procedure TReportFPDF.PrintFooter(APDF: TFPDF);
begin
  TReportPrinter
    .New
    .PrintReportFooter(self, Footer);
end;

procedure TReportFPDF.PrintHeader(APDF: TFPDF);
begin
  TReportPrinter
    .New
    .PrintReportHeader(self, Header);
end;

function TReportFPDF.PrintImage(const Stream: TStream; Extension: TReportImagesExt; X, Y, Width,
  Height: Double): IReport;
begin
  Fpdf.Image(Stream, Extension.ToString, X, Y, Width, Height);
end;

function TReportFPDF.PrintLine(X1, Y1, X2, Y2: Double): IReport;
begin
  result := self;
  Fpdf.Line(X1, Y1, X2, Y2);
end;

function TReportFPDF.PrintLineTo(X, Y: Double): IReport;
begin
  result := self;
  PrintLine(self.PosX, self.PosY, X, Y);
end;

function TReportFPDF.PrintImage(const Stream: TStream; Extension: TReportImagesExt): IReport;
begin
  Fpdf.Image(Stream, Extension.ToString);
end;

function TReportFPDF.PrintImage(FileName: String): IReport;
begin
  Fpdf.Image(FileName);
end;

function TReportFPDF.PrintImage(FileName: String; X, Y, Width, Height: Double): IReport;
begin
  Fpdf.Image(FileName, X, Y, Width, Height);
end;

function TReportFPDF.ReportAlignToStr(
  const Alinhamento: TReportAlign): String;
begin
  result := '';
  if Alinhamento = raRight then
    result := 'R'
  else if Alinhamento = raCenter then
    result := 'C';
end;

function TReportFPDF.ReportBorderToStr(
  const ArrayRelatorioBordas: TArrayReportBorders): String;
var
  lRelatorioBordas : TReportBorders;
begin
  result := '';

  for lRelatorioBordas in ArrayRelatorioBordas do
  begin
    if (rbTop = lRelatorioBordas) then
      result := result + 'T';
    if (rbBottom = lRelatorioBordas) then
      result := result + 'B';
    if (rbLeft = lRelatorioBordas) then
      result := result + 'L';
    if (rbRight = lRelatorioBordas) then
      result := result + 'R';
  end;
end;

function TReportFPDF.Table: IReportTable;
begin
  result := FTable;
end;

function TReportFPDF.TotalPages: String;
begin
  result := '{nb}';
end;

function TReportFPDF.Width: Double;
begin
  result := Fpdf.GetPageWidth;
end;

function TReportFPDF.PosX: Double;
begin
  result := Fpdf.GetX;
end;

function TReportFPDF.PosY: Double;
begin
  result := Fpdf.GetY;
end;

function TReportFPDF.PrintColumnTable(Const Value: String; Const ForceColumnDefinition: IReportTableColumn = nil) : IReport;
var
  lColumnDefinition : IReportTableColumn;
begin
  if ForceColumnDefinition = nil then
    lColumnDefinition := Table.CurrentColumn
  else
    lColumnDefinition := ForceColumnDefinition;
  Result := self;
  Fpdf.Cell(lColumnDefinition.Width,
            lColumnDefinition.Height,
            Value,
            ReportBorderToStr(lColumnDefinition.Border),
            ifthen(Table.LastColumn, 1, 0),
            ReportAlignToStr(lColumnDefinition.Align),
            lColumnDefinition.Fill);
  Table.NextColumn;
end;

function TReportFPDF.LineWidth(Value: Double): IReport;
begin
  result := self;
  FLineWidth := Value;
end;

function TReportFPDF.MarginBottom: Double;
begin
  result := FMarginBottom;
end;

function TReportFPDF.MarginBottom(Value: Double): IReport;
begin
  result := self;
  FMarginBottom := Value;
end;

function TReportFPDF.MarginLeft(Value: Double): IReport;
begin
  result := self;
  FMarginLeft := Value;
  fpdf.SetLeftMargin(Value);
end;

function TReportFPDF.MarginLeft: Double;
begin
  result := FMarginLeft;
end;

function TReportFPDF.MarginRight(Value: Double): IReport;
begin
  result := self;
  FMarginRight := Value;
  fpdf.SetRightMargin(Value);
end;

function TReportFPDF.MarginRight: Double;
begin
  result := FMarginRight;
end;

function TReportFPDF.MarginTop: Double;
begin
  result := FMarginTop;
end;

function TReportFPDF.MarginTop(Value: Double): IReport;
begin
  result := self;
  FMarginTop := Value;
  Fpdf.SetTopMargin(Value);
end;

function TReportFPDF.Modo(Value: TReportMode): IReport;
begin
  result := self;
  FModo := Value;
end;

function TReportFPDF.Modo: TReportMode;
begin
  result := FModo;
end;

function TReportFPDF.LineWidth: Double;
begin
  result := FLineWidth;
end;

function TReportFPDF.Table(const Value: IReportTable): IReport;
begin
  result := self;
  FTable := Value;
end;

function TReportFPDF.PageNumber: integer;
begin
  result := Fpdf.PageNo;
end;

function TReportFPDF.PosX(Value: Double): IReport;
begin
  result := self;
  Fpdf.SetX(Value);
end;

function TReportFPDF.PosXY(X, Y: Double): IReport;
begin
  result := self;
  Fpdf.SetXY(X, Y);
end;

function TReportFPDF.PosY(Value: Double): IReport;
begin
  result := self;
  Fpdf.SetY(Value, False)
end;

end.
