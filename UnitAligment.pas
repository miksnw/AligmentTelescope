unit UnitAligment;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, sSkinManager, sSkinProvider,
  sPanel, sMemo,Math;

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
    procedure MovePoints(A,B,C,x0,y0:Double);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PaintTelescope;
    procedure PushUp(PushKey:Word);
    procedure PushDown(PushKey:Word);
    procedure PushLeft(PushKey:Word);
    procedure PushRight(PushKey:Word);
   // procedure NormalCheck;


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
     x0,y0:integer ;
     yCenter      :  integer;
    xCenter      :  Double;
    baseCenter:double ;
implementation

{$R *.dfm}

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
const
    val=1;
var
    check:bool;
    s:string;
begin
     check:= false;
     if PushKey= 38 //up
     then
     begin
         if not CheckCross then
         begin
          if yCenter<baseCenter
          then
          begin
               b:=b-cos(val);
          end
          else
          begin
               b:=b+cos(val);
          end;
         end;
     end;

     if PushKey=40     //down
     then
     begin
          if yCenter > baseCenter
          then
          begin
              b:=b-cos(val);
            //  s:=FloatToStr(b) + ':' +FloatToStr(y);
            //  Aligment.Memo1.Lines.Add(s);
       //       check:=true;
          end
          else
          begin
               b:=b+cos(val);
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
              a:=a-cos(val);
            //  s:=FloatToStr(a) + ':' +FloatToStr(x);
            //  Aligment.Memo1.Lines.Add(s);
            //  check:=true;
          end
          else
          begin
                a:=a+cos(val);
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
              a:=a-cos(val);
          end
          else
          begin
              a:=a+cos(val);
          end;
     end;
     result:=check;
end;

function CheckRotate_A(PKey:Word) : bool ;
const
   val=1;
var
    checkRotate: bool;
begin
      checkRotate:=false;

     if  yCenter > baseCenter then
     begin
        // showMessage('1');
          if xCenter > baseCenter then
          begin
               if PKey=VK_Left  then
               c:=c+cos(1);;
               if PKey=VK_Right  then
               c:=c-cos(1);
               if Pkey= VK_Up then
               c:=c-cos(1);
               if Pkey=VK_Down then
               c:=c+cos(1);
          end
          else
          begin
               if PKey=VK_Left  then
               c:=c+cos(1);
               if PKey=VK_Right  then
               c:=c-cos(1);
               if Pkey= VK_Up then
               c:=c+cos(1);
               if Pkey= VK_Down then
               c:=c-cos(1);
          end;
     end
     else
     begin
          if xCenter < baseCenter then
          begin
               if PKey=VK_Left  then
               c:=c-cos(1);
               if PKey=VK_Right  then
               c:=c+cos(1);
               if Pkey= VK_Up then
               c:=c+cos(1);
               if Pkey= VK_Down then
               c:=c-cos(1);
          end
          else
          begin
               if PKey=VK_Left  then
               c:=c-cos(1);
               if PKey=VK_Right  then
               c:=c+cos(1);

               if Pkey= VK_Up then
               c:=c-cos(1);
               if Pkey= VK_Down then
               c:=c+cos(1);
          end;
     end; checkRotate:=false;

     if  yCenter > baseCenter then
     begin
        // showMessage('1');
          if xCenter > baseCenter then
          begin
               if PKey=VK_Left  then
               c:=c+10;
               if PKey=VK_Right  then
               c:=c-cos(1);
               if Pkey= VK_Up then
               c:=c-cos(1);
               if Pkey= VK_Down then
               c:=c+cos(1);
          end
          else
          begin
               if PKey=VK_Left  then
               c:=c+cos(1);
               if PKey=VK_Right  then
               c:=c-cos(1);
               if Pkey= VK_Up then
               c:=c+cos(1);
               if Pkey= VK_Down then
               c:=c-cos(1);
          end;
     end
     else
     begin
          if xCenter < baseCenter then
          begin
               if PKey=VK_Left  then
               c:=c-cos(1);
               if PKey=VK_Right  then
               c:=c+cos(1);
               if Pkey= VK_Up then
               c:=c+cos(1);
               if Pkey= VK_Down then
               c:=c-cos(1);
          end
          else
          begin
               if PKey=VK_Left  then
               c:=c-cos(1);
               if PKey=VK_Right  then
               c:=c+cos(1);

                 if Pkey= VK_Up then
               c:=c-cos(1);
               if Pkey= VK_Down then
               c:=c+cos(1);

          end;
     end;
end;

procedure CheckRotate_B ;
var
    checkRotate: bool;
begin
     checkRotate:=false;


   {  if a<b  then
     begin
       c:=c+1;
       checkRotate:=true;
     end;
        }
end;

procedure RotFix(lenx,leny:integer);
begin
     xcenter:=sqrt(power(lenx,2)-power(leny,2));
end;

procedure CheckNormal(Key:word);
var
   er:integer;
   deltax,deltay:integer;
begin
    if (xCenter =baseCenter) or  (yCenter =baseCenter)
    then
    begin
      er:=Round(sqrt(power(xcenter,2)+power(ycenter,2)));
      deltax:= abs(x0-er);
      deltay:= abs(y0-ycenter);

    ///  SHowMessage(inttostr(deltax));
     CheckCircl(Key)
    end
    else
    begin
        CheckRotate_a(Key);
        RotFix(deltax,deltay);
        end                   ;
end;



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




procedure TAligment.MovePoints(A,B,C,x0,y0:Double);
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
     x0:=Aligment.MyImg.Width  div 2;
     xCenter:=x0;
     y0:=Aligment.MyImg.Height  div 2;
     yCenter:=y0;
end;
procedure TAligment.FormCreate(Sender: TObject);
begin
     Init;
     baseCenter:=MyImg.Width/2;
   // GdPaintObject;
     MovePoints(a,b,c,0,0);
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
    yCenter := yCenter -3 ; //����������
    MovePoints(a,b,c,x,y);     //�����������9
    checkCross;  //�������� ���������
    CheckNormal(PushKey);
    //  CheckCircl(PushKey)  ;      //��������
    //  CheckRotate_A;
    s:=FloatToStr(b) + ':'+FloatToStr(y);
    Aligment.Memo1.Lines.Add(s);
    GdPaintObject;
    PaintTelescope;
end;

procedure TAligment.PushDown(PushKey:Word);
var
    cross: bool ;
    s: string;
begin
    cross:=  CheckCross;

          yCenter := yCenter +3 ; //����������
          MovePoints(a,b,c,x,y);     //�����������
          CheckNormal(PushKey);
          //CheckCircl(PushKey);
       //   CheckRotate_A;
          s:=FloatToStr(b) + ':'+FloatToStr(y);
          Aligment.Memo1.Lines.Add(s);

   GdPaintObject;
   PaintTelescope;

end;

procedure TAligment.PushLeft(PushKey:Word);
var
    cross: bool;
    s:string;
begin
     xCenter:=xCenter-3;
          MovePoints(a,b,c,x,y);     //�����������
          CheckNormal(PushKey);
          //CheckRotate_B;
          s:=FloatToStr(b) + ':'+FloatToStr(y);
          Aligment.Memo1.Lines.Add(s);
   GdPaintObject;
   PaintTelescope;
end;
procedure TAligment.PushRight(PushKey:Word);
var
    cross: bool ;
    s:string;
begin
          xCenter:=xCenter+3;
          MovePoints(a,b,c,x,y);     //�����������
          CheckNormal(PushKey);

          s:=FloatToStr(b) + ':'+FloatToStr(y);
          Aligment.Memo1.Lines.Add(s);
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
                   // MoveTelescope(a,b,c,x,y);
               end;
               VK_NumPad6:
               begin
                    GdPaintObject;
                    c:=c+1;
                   // MoveTelescope(a,b,c,x,y);
               end;
     end;
end;
end.
