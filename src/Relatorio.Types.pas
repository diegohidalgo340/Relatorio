unit Relatorio.Types;

interface

uses
  Relatorio.Interfaces, Relatorio.Enums, System.Generics.Collections,
  System.Classes;

type

TReportLogo = class(TInterfacedObject, IReportLogo)
  strict private
    FPosicaoTamanhoFixa: Boolean;
    FX: Double;
    FY: Double;
    FWidth: Double;
    FHeight: Double;
    FFileName: String;
    FStream: TStream;
    FReportImagesExt: TReportImagesExt;
  public
    class function New: IReportLogo;

    constructor Create;

    function Filename : String; overload;
    function Filename(Value: String): IReportLogo; overload;
    function Height : Double; overload;
    function Height(Value: Double): IReportLogo; overload;
    function PosicaoTamanhoFixa: Boolean; overload;
    function PosicaoTamanhoFixa(Value: Boolean): IReportLogo; overload;
    function ReportImagesExt : TReportImagesExt; overload;
    function ReportImagesExt(const Value: TReportImagesExt): IReportLogo; overload;
    function Stream : TStream; overload;
    function Stream(const Value: TStream): IReportLogo; overload;
    function Width : Double; overload;
    function Width(Value: Double): IReportLogo; overload;
    function X : Double; overload;
    function X(Value: Double): IReportLogo; overload;
    function Y : Double; overload;
    function Y(Value: Double): IReportLogo; overload;
end;

TReportFooter = class(TInterfacedObject, IReportFooter)
  strict private
    FDrawLine: Boolean;
    FPageNumber: Boolean;
    FPrefix: String;
    FTotalPages: Boolean;
    FDataHora: Boolean;
    FTexto: String;
  public
    class function New : IReportFooter;

    constructor Create;

    function DataHora: Boolean; overload;
    function DataHora(Value: Boolean): IReportFooter; overload;
    function DrawLine(Value: Boolean): IReportFooter; overload;
    function DrawLine: Boolean; overload;
    function PageNumber(Value: Boolean): IReportFooter; overload;
    function PageNumber: Boolean; overload;
    function Prefix(Value: String): IReportFooter; overload;
    function Prefix: String; overload;
    function Texto: String; overload;
    function Texto(Value: String): IReportFooter; overload;
    function TotalPages(Value: Boolean): IReportFooter; overload;
    function TotalPages: Boolean; overload;
end;

TReportHeader = class(TInterfacedObject, IReportHeader)
  strict private
    FReportLogo: IReportLogo;
    FTitle: String;
    FDrawLine: boolean;
    FSubTitles: TStringList;
    FColumnID: Integer;
    FColumnTitles : TStringList;
  public
    class function New : IReportHeader;

    constructor Create;
    destructor Destroy; override;

    function AddSubTitle(Value: String): IReportHeader;
    function AddTable(ColumnID: Integer): IReportHEader;
    function AddColumnTitle(Title: String): IReportHeader;
    function ColumnID: Integer;
    function DrawLine : boolean; overload;
    function DrawLine(Value: boolean):IReportHeader ; overload;
    function ColumnTitles: TStringList;
    function ReportLogo : IReportLogo; overload;
    function ReportLogo(const Value: IReportLogo) : IReportHeader; overload;
    function SubTitles : TStringList;
    function Title : String; overload;
    function Title(Value: String): IReportHeader; overload;
end;

TReportTableColumn = class(TInterfacedObject, IReportTableColumn)
strict private
  FAlign: TReportAlign;
  FHeight: Double;
  FBorder: TArrayReportBorders;
  FFill: Boolean;
  FWidth: Double;
public
  class function New: IReportTableColumn;

  function Align: TReportAlign; overload;
  function Align(const Value: TReportAlign) : IReportTableColumn; overload;
  function Height: Double; overload;
  function Height(Value: Double): IReportTableColumn; overload;
  function Border: TArrayReportBorders; overload;
  function Border(const Value: TArrayReportBorders): IReportTableColumn; overload;
  function Clone : IReportTableColumn;
  function Fill: Boolean; overload;
  function Fill(Value: Boolean): IReportTableColumn; overload;
  function Width: Double; overload;
  function Width(Value: Double): IReportTableColumn; overload;

end;

TListReportTablecolumn = TList<IReportTableColumn>;

TReportTable = class(TInterfacedObject, IReportTable)
strict private
  FColumnList: TDictionary<Integer, TListReportTablecolumn>;
  FCurrentColumn: Integer;
  FColumnID: Integer;
public
  constructor Create(const Report: IReport);
  destructor Destroy; override;

  class function New (const Report: IReport): IReportTable;

  function AddColumn(const Column: IReportTableColumn): IReportTable;
  function ClearColumns: IReportTable;
  function CurrentColumn: IReportTableColumn;
  function ColumnID: Integer;overload;
  function ColumnID(Value: Integer):IReportTable;overload;
  function NextColumn: IReportTable;
  function LastColumn: boolean;
end;

TReportPrinter = class(TInterfacedObject, IReportPrinter)
  class function New : IReportPrinter;

  function PrintReportFooter(const Report: IReport;
  const ReportFooter: IReportFooter): IReportPrinter;
  function PrintReportHeader(const Report: IReport; const ReportHeader: IReportHeader) : IReportPrinter;
end;



implementation

uses
  System.SysUtils, System.StrUtils;

{ TRelatorioTabela }

function TReportTable.AddColumn(const Column: IReportTableColumn): IReportTable;
begin
  result := self;
  if not FColumnList.ContainsKey(ColumnID) then
     FColumnList.Add(ColumnID, TListReportTablecolumn.Create);
  FColumnList.Items[ColumnID].Add(Column);
end;

function TReportTable.ClearColumns: IReportTable;
begin
  result := self;
  FColumnList.Items[ColumnID].Clear;
  FCurrentColumn := 0;
end;

function TReportTable.CurrentColumn: IReportTableColumn;
begin
  if (FColumnList.Items[ColumnID].Count < FCurrentColumn+1)or(FCurrentColumn < 0) then
    raise Exception.Create(' TRelatorioTabela.ColunaAtual: Posição de coluna inválida '+intToStr(FCurrentColumn));
  result := FColumnList.Items[ColumnID].Items[FCurrentColumn];
end;

function TReportTable.ColumnID(Value: Integer): IReportTable;
begin
  result := self;
  FColumnID := Value;
end;

function TReportTable.ColumnID: Integer;
begin
  result := FColumnID;
end;

constructor TReportTable.Create(const Report: IReport);
begin
  FCurrentColumn := 0;
  ColumnID(0);
  FColumnList := TDictionary<Integer, TListReportTablecolumn>.Create;
  ColumnID(-1)
    .AddColumn(TReportTableColumn
                 .New
                 .Border([])
                 .Align(raLeft)
                 .Width(3))
    .AddColumn(TReportTableColumn
                 .New
                 .Border([])
                 .Align(raCenter)
                 .Width(Report.Width - Report.MarginLeft - Report.MarginRight - 6))
    .AddColumn(TReportTableColumn
                 .New
                 .Border([])
                 .Align(raRight)
                 .Width(3))
end;

destructor TReportTable.Destroy;
var
  LColunaID : integer;
begin
  for LColunaID in FColumnList.Keys do
    FColumnList.Items[LColunaID].Free;
  FColumnList.Free;
  inherited;
end;

class function TReportTable.New(const Report: IReport): IReportTable;
begin
  result := Self.Create(Report);
end;

function TReportTable.NextColumn: IReportTable;
begin
  result := self;
  inc(FCurrentColumn);
  if FCurrentColumn > FColumnList.Items[ColumnID].Count-1 then
    FCurrentColumn := 0;
end;

function TReportTable.LastColumn: boolean;
begin
  result := FCurrentColumn = FColumnList.Items[ColumnID].Count - 1;
end;

{ TRelatorioTabelaColuna }

function TReportTableColumn.Align: TReportAlign;
begin
  Result := FAlign;
end;

function TReportTableColumn.Align(
  const Value: TReportAlign): IReportTableColumn;
begin
 result := self;
 FAlign := Value;
end;

function TReportTableColumn.Height(Value: Double): IReportTableColumn;
begin
  result := self;
  FHeight := Value;
end;

function TReportTableColumn.Height: Double;
begin
  result := FHeight;
end;

function TReportTableColumn.Border: TArrayReportBorders;
begin
  result := FBorder;
end;

function TReportTableColumn.Border(
  const Value: TArrayReportBorders): IReportTableColumn;
begin
  result := self;
  FBorder := Value;
end;

function TReportTableColumn.Clone: IReportTableColumn;
begin
  result := self.New
                .Align(self.Align)
                .Border(self.Border)
                .Fill(self.Fill)
                .Height(self.Height)
                .Width(self.Width);
end;

class function TReportTableColumn.New: IReportTableColumn;
begin
  result := self.Create;
end;

function TReportTableColumn.Fill: Boolean;
begin
  result := FFill;
end;

function TReportTableColumn.Fill(
  Value: Boolean): IReportTableColumn;
begin
  result := self;
  FFill := Value;
end;

function TReportTableColumn.Width: Double;
begin
  result := FWidth;
end;

function TReportTableColumn.Width(Value: Double): IReportTableColumn;
begin
  Result := self;
  FWidth := Value;
end;

{ TReportLogo }

function TReportLogo.Filename: String;
begin
  result := FFileName;
end;

constructor TReportLogo.Create;
begin
  PosicaoTamanhoFixa(false);
  Filename('');
  Stream(nil);
end;

function TReportLogo.Filename(Value: String): IReportLogo;
begin
  result := self;
  FFileName := Value;
end;

function TReportLogo.Height: Double;
begin
  result := FHeight;
end;

function TReportLogo.Height(Value: Double): IReportLogo;
begin
  result := self;
  FHeight := Value;
end;

class function TReportLogo.New: IReportLogo;
begin
  result := self.Create;
end;

function TReportLogo.PosicaoTamanhoFixa: Boolean;
begin
  result := FPosicaoTamanhoFixa;
end;

function TReportLogo.PosicaoTamanhoFixa(Value: Boolean): IReportLogo;
begin
  result := self;
  FPosicaoTamanhoFixa := Value;
end;

function TReportLogo.ReportImagesExt: TReportImagesExt;
begin
  result := FReportImagesExt;
end;

function TReportLogo.ReportImagesExt(
  const Value: TReportImagesExt): IReportLogo;
begin
  result := self;
  FReportImagesExt := Value;
end;

function TReportLogo.Stream(const Value: TStream): IReportLogo;
begin
  result := self;
  FStream := Value;
end;

function TReportLogo.Stream: TStream;
begin
  result := FStream;
end;

function TReportLogo.Width(Value: Double): IReportLogo;
begin
  result := self;
  FWidth := Value;
end;

function TReportLogo.Width: Double;
begin
  result := FWidth;
end;

function TReportLogo.X(Value: Double): IReportLogo;
begin
  result := self;
  FX := Value;
end;

function TReportLogo.X: Double;
begin
  result := FX;
end;

function TReportLogo.Y(Value: Double): IReportLogo;
begin
  result := self;
  FY := Value;
end;

function TReportLogo.Y: Double;
begin
  result := FY;
end;

{ TReportHeader }

function TReportHeader.AddColumnTitle(Title: String): IReportHeader;
begin
  result := self;
  FColumnTitles.Add(Title);
end;

function TReportHeader.AddSubTitle(Value: String): IReportHeader;
begin
  result := self;
  FSubTitles.Add(Value)
end;

function TReportHeader.AddTable(ColumnID: Integer): IReportHEader;
begin
  result := self;
  FColumnID := ColumnID;
end;

function TReportHeader.ColumnID: Integer;
begin
  result := FColumnID;
end;

function TReportHeader.ColumnTitles: TStringList;
begin
  result := FColumnTitles;
end;

constructor TReportHeader.Create;
begin
  ReportLogo(nil);
  Title('');
  FSubTitles := TStringList.Create;
  FColumnID := -1;
  FColumnTitles := TSTringList.Create;
end;

destructor TReportHeader.Destroy;
begin
  FColumnTitles.Free;
  FSubTitles.Free;
  inherited;
end;

function TReportHeader.DrawLine(Value: boolean): IReportHeader;
begin
  result := self;
  FDrawLine := Value;
end;

class function TReportHeader.New: IReportHeader;
begin
  result := self.Create;
end;

function TReportHeader.DrawLine: boolean;
begin
  result := FDrawLine;
end;

function TReportHeader.ReportLogo(const Value: IReportLogo): IReportHeader;
begin
  result := self;
  FReportLogo := Value;
end;

function TReportHeader.SubTitles: TStringList;
begin
  result := FSubTitles;
end;

function TReportHeader.ReportLogo: IReportLogo;
begin
  result := FReportLogo;
end;

function TReportHeader.Title: String;
begin
  result := FTitle;
end;

function TReportHeader.Title(Value: String): IReportHeader;
begin
  result := self;
  FTitle := Value;
end;

{ TReportPrinter }

class function TReportPrinter.New: IReportPrinter;
begin
  result := self.Create;
end;

function TReportPrinter.PrintReportFooter(const Report: IReport;
  const ReportFooter: IReportFooter): IReportPrinter;
var
  lColumnID: integer;
begin
  result := self;

  Report.PosY(-1 * (Report.MarginBottom+0.5));

  if ReportFooter.DrawLine then
    Report.PrintLine(Report.MarginLeft, Report.PosY-0.3, Report.Width - Report.MarginRight, Report.PosY-0.3);

  Report.Table.ColumnID(-1);
  lColumnID := Report.Table.ColumnID;

  if ReportFooter.DataHora then
    Report.PrintColumnTable(FormatDateTime('DD/MM/YYYY HH:NN', now))
  else
    Report.PrintColumnTable('');

  Report.PrintColumnTable(ReportFooter.Texto);


  if ReportFooter.PageNumber then
    Report.PrintColumnTable(ReportFooter.Prefix+IntToStr(Report.PageNumber)+ifthen(ReportFooter.TotalPages, '/'+Report.TotalPages, ''))
  else
    Report.PrintColumnTable('');



  Report.Table.ColumnID(lColumnID);
end;

function TReportPrinter.PrintReportHeader(const Report: IReport;
  const ReportHeader: IReportHeader): IReportPrinter;
var
  lFontSize: Double;
  lTitle: String;
  lColuna: integer;
  lColumnID: integer;
begin
  Result := self;
  if ReportHeader.ReportLogo <> nil then
  begin
    if ReportHeader.ReportLogo.PosicaoTamanhoFixa then
      if ReportHeader.ReportLogo.Filename <> '' then
        Report.PrintImage(ReportHeader.ReportLogo.Filename,
                   ReportHeader.ReportLogo.X,
                   ReportHeader.ReportLogo.Y,
                   ReportHeader.ReportLogo.Width,
                   ReportHeader.ReportLogo.Height)
      else
        Report.PrintImage(ReportHeader.ReportLogo.Stream,
                   ReportHeader.ReportLogo.ReportImagesExt,
                   ReportHeader.ReportLogo.X,
                   ReportHeader.ReportLogo.Y,
                   ReportHeader.ReportLogo.Width,
                   ReportHeader.ReportLogo.Height)
    else
      if ReportHeader.ReportLogo.Filename <> '' then
        Report.PrintImage(ReportHeader.ReportLogo.Filename)
      else
        Report.PrintImage(ReportHeader.ReportLogo.Stream, ReportHeader.ReportLogo.ReportImagesExt);
  end;

  if ReportHeader.Title <> '' then
  begin
    lFontSize := Report.FontSize;
    Report
      .FontSize(20)
      .PosX(Report.Width/2)
      .PrintText(ReportHeader.Title)
      .FontSize(lFontSize)
      .NewLine(0.4)
  end;

  if Report.Header.SubTitles.Count > 0 then
  begin
    for lTitle in Report.Header.SubTitles do
      Report
        .FontSize(10)
        .PrintText(lTitle)
        .NewLine(0.4);
    Report.FontSize(lFontSize)
  end;

  if Report.Header.DrawLine then
    Report.PrintLine(Report.MarginLeft, Report.PosY - 0.3,
      Report.Width - Report.MarginLeft, Report.PosY - 0.3);

  if Report.Header.ColumnID > -1 then
  begin
    lColumnID := Report.Table.ColumnID;
    Report.Table.ColumnID(Report.Header.ColumnID);
    for lColuna := 0 to Report.Header.ColumnTitles.Count-1 do
      Report.PrintColumnTable(Report.Header.ColumnTitles[lColuna]);
    Report.Table.ColumnID(lColumnID);
  end;
end;

{ TReportFooter }

function TReportFooter.DrawLine(Value: Boolean): IReportFooter;
begin
  result := self;
  FDrawLine := Value;
end;

constructor TReportFooter.Create;
begin
  FDrawLine := false;
  FPageNumber := false;
  FTotalPages := false;
  FPrefix := '';
  FDataHora := false;
  FTexto := '';
end;

function TReportFooter.DataHora(Value: Boolean): IReportFooter;
begin
  result := self;
  FDataHora := Value;
end;

function TReportFooter.DataHora: Boolean;
begin
  result := FDataHora;
end;

function TReportFooter.DrawLine: Boolean;
begin
  result := FDrawLine;
end;

class function TReportFooter.New: IReportFooter;
begin
  result := self.Create;
end;

function TReportFooter.PageNumber: boolean;
begin
  result := FPageNumber;
end;

function TReportFooter.Prefix: String;
begin
  result := FPrefix;
end;

function TReportFooter.Prefix(Value: String): IReportFooter;
begin
  result := self;
  FPrefix := Value;
end;

function TReportFooter.TotalPages(Value: Boolean): IReportFooter;
begin
  result := self;
  FTotalPages := Value;
end;

function TReportFooter.Texto(Value: String): IReportFooter;
begin
  result := self;
  FTexto := Value;
end;

function TReportFooter.Texto: String;
begin
  result := FTexto;
end;

function TReportFooter.TotalPages: Boolean;
begin
  result := FTotalPages;
end;

function TReportFooter.PageNumber(Value: Boolean): IReportFooter;
begin
  result := self;
  FPageNumber := Value;
end;

end.
