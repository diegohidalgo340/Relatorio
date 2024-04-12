unit Relatorio.Interfaces;

interface

uses System.Generics.Collections, Relatorio.Enums, System.Classes;

type
  IReportLogo = interface
    ['{C85B52A0-FE4D-4AA0-8CBC-2380ECFD6B71}']
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

  IReportFooter = interface
    ['{57DC3C57-B942-4F57-B204-6156FEDDFCB6}']
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

  IReportHeader = interface
    ['{68DC2FDC-7D4F-4FC3-A36D-7B7E0BB3CE52}']
    function AddSubTitle(Value: String): IReportHeader;
    function AddTable(ColumnID: Integer): IReportHEader;
    function AddColumnTitle(Title: String): IReportHeader;
    function ColumnID: Integer;
    function ColumnTitles: TStringList;
    function DrawLine : boolean; overload;
    function DrawLine(Value: boolean): IReportHeader; overload;
    function ReportLogo : IReportLogo; overload;
    function ReportLogo(const Value: IReportLogo) : IReportHeader; overload;
    function SubTitles : TStringList;
    function Title : String; overload;
    function Title(Value: String): IReportHeader; overload;
  end;

  IReportTableColumn = interface
    ['{4AC92C3C-ED31-48B3-AAA9-EB97683E8802}']
    function Align: TReportAlign; overload;
    function Align(const Value: TReportAlign) : IReportTableColumn; overload;
    function Border: TArrayReportBorders; overload;
    function Border(const Value: TArrayReportBorders): IReportTableColumn; overload;
    function Clone : IReportTableColumn;
    function Fill: Boolean; overload;
    function Fill(Value: Boolean): IReportTableColumn; overload;
    function Height: Double; overload;
    function Height(Value: Double): IReportTableColumn; overload;
    function Width: Double; overload;
    function Width(Value: Double): IReportTableColumn; overload;
  end;

  IReportTable = interface
    ['{9D7FA1B4-DEA7-435C-8AB1-ACB600EF7A51}']
    function AddColumn(const Coluna: IReportTableColumn): IReportTable;
    function ClearColumns: IReportTable;
    function ColumnID: Integer;overload;
    function ColumnID(Value: Integer):IReportTable;overload;
    function CurrentColumn: IReportTableColumn;
    function LastColumn: boolean;
    function NextColumn : IReportTable;
  end;

  IReport = interface
    ['{B1C14745-24DF-4509-816F-7E4DAACE39C1}']
    function Execute: IReport;
    function Font(const Family : String; const Style : String = ''; Size: Double = 0): IReport;
    function FontSize: Double; overload;
    function FontSize(Value: Double): IReport; overload;
    function Footer: IReportFooter; overload;
    function Footer(Value: IReportFooter): IReport; overload;
    function Header: IReportHeader; overload;
    function Header(Value: IReportHeader): IReport; overload;
    function Height: Double; overload;
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
    function NewLine(Height: Double) : IReport; overload;
    function NewPage: IReport;
    function PageNumber: integer;
    function PosX: Double; overload;
    function PosX(Value: Double): IReport; overload;
    function PosXY(X, Y: Double): IReport; overload;
    function PosY: Double; overload;
    function PosY(Value: Double): IReport; overload;
    function PrintColumnTable(Const Value: String; Const pForceColumnDefinition: IReportTableColumn = nil) : IReport;
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
    function Table: IReportTable; overload;
    function TotalPages: String;
    function Width: Double; overload;
  end;

  IReportPrinter = interface
    ['{17C97F49-7510-42AA-9173-A1E18F409FB7}']
    function PrintReportFooter(const Report: IReport; const ReportHeader: IReportFooter) : IReportPrinter;
    function PrintReportHeader(const Report: IReport; const ReportHeader: IReportHeader) : IReportPrinter;
  end;

implementation

end.
