unit UnitAligment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, sSkinManager, sSkinProvider,
  sPanel, sMemo;

type
  TAligment = class(TForm)
    sPanel1: TsPanel;
    Memo1: TsMemo;
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    sPanel2: TsPanel;
    MyImg: TImage;
    StaticText_N: TStaticText;
    Image1: TImage;
    StaticText_W: TStaticText;
    StaticText_S: TStaticText;
    StaticText_E: TStaticText;
    ListView1: TListView;
    Light: TShape;
    Shape1: TShape;
    procedure FormCreate(Sender: TObject);
    procedure GdPaintObject  ;
    procedure MoveTelescope(A,B,C,x0,y0:Double);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PaintTelescope;
    procedure PushUp(PushKey:Word);
    procedure PushDown(PushKey:Word);
    procedure PushLeft(PushKey:Word);
    procedure PushRight(PushKey:Word);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Aligment: TAligment;
   pic: Tbitmap;
     h,w:integer;
     a,b,c,x,y: Double;
     lx,ly : array [0..100] of integer;
     StepCount    :  integer;
     yCenter      :  Double;
    xCenter      :  Double;
    baseCenter:double ;
implementation

{$R *.dfm}

procedure TAligment.GdPaintObject;
var
     lRadius: Integer;
begin

     MyImg.Canvas.Brush.Color := clBtnFace; //���� ������� ����������
     MyImg.Canvas.Pen.Color := clBtnFace; //���� ����� ���������� (������ ������)
     MyImg.Canvas.Rectangle(0, 0, MyImg.Width, MyImg.Height); // �
  //   MyImg.Canvas.Brush.Color := clSilver; //���� ������� ����������
     MyImg.Canvas.Pen.Color := clBlack; //���� ����� ���������� (������ ������)
     MyImg.Canvas.Ellipse(0, 0, MyImg.Width, MyImg.Height); // �
end;

function CheckCross: bool;
var
   cross:bool  ;
   x0,y0,r,n: integer;

begin
n:=0;
  cross:=false;
   x0:=Aligment.MyImg.Width div 2;
   y0:=x0;
   r:=x0;

  for n:=0 to 100 do
  if sqrt( (lx[n]-x0)*(lx[n]-x0) + (ly[n]-y0)*(ly[n]-y0))>r-5
  then
  begin
  result:=true;
  break;
  end
  else
  begin
  result:=false;
  end;
end;

function CheckCircl(PushKey:Word) : bool ;
var
    check:bool;
    s:string;
begin
     check:= false;

  { if CheckRotate_B=false  then
          begin
          end
          else
          begin
               c:=c-1;
               y:=y-3;
          end;
     }
     if PushKey= 38 //up
     then
     begin
          if yCenter<baseCenter
          then
          begin
               b:=b-1;
              // s:=FloatToStr(b) + ':'+FloatToStr(y);
            //   Aligment.Memo1.Lines.Add(s);
            //   check:=true;
          end
          else
          begin
               b:=b+1;
               //s:=FloatToStr(b) + ':' +FloatToStr(y);
              // Aligment.Memo1.Lines.Add(s);
          end;
     end;

     if PushKey=40     //down
     then
     begin
          if yCenter > baseCenter
          then
          begin
              b:=b-1;
            //  s:=FloatToStr(b) + ':' +FloatToStr(y);
            //  Aligment.Memo1.Lines.Add(s);
       //       check:=true;
          end
          else
          begin
               b:=b+1;
            //   s:=FloatToStr(b) + ':' +FloatToStr(y);
            //   Aligment.Memo1.Lines.Add(s);
          end;
     end;
     if PushKey=37//left
     then
     begin
          if xCenter < baseCenter
          then
          begin
              a:=a-1;
            //  s:=FloatToStr(a) + ':' +FloatToStr(x);
            //  Aligment.Memo1.Lines.Add(s);
            //  check:=true;
          end
          else
          begin
                a:=a+1;
             //   s:=FloatToStr(a) + ':' +FloatToStr(x);
           //     Aligment.Memo1.Lines.Add(s);
          end;
     end;
     if PushKey=39//right
     then
     begin
          if xCenter > baseCenter
          then
          begin
              a:=a-1;
              s:=FloatToStr(a) + ':' +FloatToStr(x);
              Aligment.Memo1.Lines.Add(s);
              check:=true;
          end
          else
          begin
               a:=a+1;
               s:=FloatToStr(a) + ':' +FloatToStr(x);
               Aligment.Memo1.Lines.Add(s);
          end;
     end;
     result:=check;
end;

function CheckRotate_A : bool ;
var
    checkRotate: bool;
begin
     checkRotate:=false;
     if a>b then
     checkRotate:=true;
     result := checkRotate;
end;

function CheckRotate_B : bool ;
var
    checkRotate: bool;
begin
     checkRotate:=false;
     if a+10<b  then
     checkRotate:=true;
     result := checkRotate;
end;

procedure TAligment.MoveTelescope(A,B,C,x0,y0:Double);
var
    Bitmap       :  TBitmap;
    i            :  INTEGER;
    RotationAngle:  Double;
    theta        :  Double;    // angle parameter for ellipse
    x            :  Double;

    xRotated     :  INTEGER;   // final values are integers
    y            :  Double;

    yRotated     :  INTEGER;   // final values are integers
begin
  StepCount := 100;  // Example 50
  RotationAngle := c{degrees} *
                   PI/180 {radians/degee};

  try
 //   MyImg.Canvas.Pen.Color := clRed;
    // Axis of rotation will be center of Bitmap (Image)
    xCenter := MyImg.Width  div 2 + x0;
    yCenter := MyImg.Height div 2 + y0;
    for  i := 0 to StepCount do   // actually StepCount + 1 points
    begin
      theta := 360*(i/StepCount) {degrees} * (PI/180) {radians/degree};

      // Ellipse (x,y) coordinates [pre-rotation]
      x := xCenter + A*COS(theta);
      y := yCenter + B*SIN(theta);

      // Rotate Ellipse around (xCenter, yCenter) axis
      xRotated :=
           ROUND(
                 xCenter + (x - xCenter)* COS(RotationAngle)
                         - (y - yCenter)* SIN(RotationAngle) );
      yRotated :=
           ROUND(
                 yCenter + (x - xCenter)* SIN(RotationAngle)
                         + (y - yCenter)* COS(RotationAngle) );
           lx[i]:=xRotated; ly[i]:=yRotated;
    end;
   finally
  end;
end;
procedure Init;
begin
     a:=50;
     b:=50;
     c:=0;
end;
procedure TAligment.FormCreate(Sender: TObject);
begin
      Init;
     baseCenter:=MyImg.Width/2;
   //  GdPaintObject;
     MoveTelescope(a,b,c,0,0);
     GdPaintObject;
     PaintTelescope;
end;

//88888888888888888888888888888888888888888888888888888888888888888888888888888888888

procedure TALigment.PaintTelescope;
var
    i:integer;
begin
       for i:=0 to StepCount do
       begin
           if i = 0
           then
           begin
                MyImg.Canvas.MoveTo(lx[i],ly[i])
           end
           else
           begin
                MyImg.Canvas.LineTo(lx[i],ly[i]);
           end;
       end;
end;

procedure TAligment.PushUp(PushKey:Word);
var
    cross: bool ;
    s:string ;
begin
    cross:=  CheckCross;
   // if cross = false then // ��������
   // begin
          y:=y-3;
          MoveTelescope(a,b,c,x,y);     //�����������9
          CheckCircl(PushKey)  ;
          s:=FloatToStr(b) + ':'+FloatToStr(y);
          Aligment.Memo1.Lines.Add(s);
 {   end
    else
    begin
         cross:=false;
        // y:=y+3;
    end;
  }

     GdPaintObject;
     PaintTelescope;
end;

procedure TAligment.PushDown(PushKey:Word);
var
    cross: bool ;
    s: string;
begin
    cross:=  CheckCross;
    { if cross = false then // ��������
     begin}
          y:=y+3;
          MoveTelescope(a,b,c,x,y);     //�����������
          CheckCircl(PushKey);
          s:=FloatToStr(b) + ':'+FloatToStr(y);
          Aligment.Memo1.Lines.Add(s);
  {  end
    else
    begin
        cross:=false;
        // y:=y-3;

    end; }


   GdPaintObject;
   PaintTelescope;

end;

procedure TAligment.PushLeft(PushKey:Word);
var
    cross: bool;
    s:string;
begin
     cross:=  CheckCross;
    { if cross = false then // ��������
     begin
          x:=x-3;
     end
     else
     begin
          x:=x+3;
     end;    }

     CheckCircl(PushKey);

     if CheckRotate_a=false  then
     begin

     end
     else
     begin
     end;

     MoveTelescope(a,b,c,x,y);     //�����������
     GdPaintObject;
     PaintTelescope;
end;
procedure TAligment.PushRight(PushKey:Word);
var
    cross: bool ;
    s:string;
begin
     cross:=  CheckCross;

      CheckCircl(PushKey);

     if cross = false then // ��������
     begin
          x:=x+3;
     end
     else
     begin
          a:=a+1;
          x:=x+3;
         // cross:=false;
       //   ShowMessage('Stack');
     end;
     if CheckRotate_a=false  then
     begin

     end
     else
     begin
     end;

     MoveTelescope(a,b,c,x,y);     //�����������
     GdPaintObject;
     PaintTelescope;

end;
procedure TAligment.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      case Key of
               VK_Up:
               begin
                   PushUp(Key);
               end;
               VK_Down:
               begin
                   PushDown(Key);
               end;
               VK_RIGHT:
               begin
                   PushRight(Key);
               end;
               VK_LEFT:
               begin
                   PushLeft(Key);
               end;
               VK_NumPad4:
               begin
                    GdPaintObject;
                    c:=c-1;
                    MoveTelescope(a,b,c,x,y);
               end;
               VK_NumPad6:
               begin
                    GdPaintObject;
                    c:=c+1;
                    MoveTelescope(a,b,c,x,y);
               end;
     end;
end;
end.
