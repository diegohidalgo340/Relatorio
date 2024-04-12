unit Relatorio.Enums;

interface

type

TReportAlign = (raLeft, raRight, raCenter);

TReportBorders = (rbTop, rbBottom, rbLeft, rbRight);

TReportImagesExt = (riePNG, rieJPG);

TReportMode = (rmFile, rmStream);

TReportRenders = (rrFPFD);

TArrayReportBorders = array of TReportBorders;


TReportImagesExtHelper = record helper for TReportImagesExt
  function ToString: String;
end;

implementation

{ TReportImagesExtHelper }

function TReportImagesExtHelper.ToString: String;
begin
  case self of
    riePNG : result := 'PNG';
    rieJPG : result := 'JPG';
  end;
end;

end.
