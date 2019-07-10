unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,TADDiccionario,Tipos,uNIT2, Vcl.StdCtrls,Unit3;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    GroupBox2: TGroupBox;
    Button4: TButton;
    Edit1: TEdit;
    GroupBox3: TGroupBox;
    Button5: TButton;
    GroupBox4: TGroupBox;
    Button6: TButton;
    Memo2: TMemo;
    Button7: TButton;
    Button8: TButton;
    Memo3: TMemo;
    GroupBox5: TGroupBox;
    Button9: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
x2:tipoElemento;
p:posicionDic;
begin
  x.di:= StrToInt(inputbox('Ingresar cliente','Numero Cliente',''));
  P:=d.InsertarClave(x,cdi);
  x2.Inicializar;
  x2.di:= StrToInt(inputbox('Ingresar cliente','Numero factura',''));
  x2.DS:= inputbox('Ingresar cliente','Fecha','');
  x2.DR:= StrTofloat(inputbox('Ingresar cliente','importe',''));
  d.InsertarValorPosClave(p,x2,cdi);

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 memo1.Lines.add(d.RetornarDic);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
r:real;
x:Tipoelemento;
ma,me:real;
begin
r:=TotalFacturado(d,StrToInt(edit1.text),me,ma);
memo3.lines.add('Cliente ' + edit1.text + ': ');
memo3.Lines.add(' Total: ' +  floattostr(r));
x.Inicializar;
x.di:=strToInt(edit1.Text);
memo3.Lines.add('Promedio Factrurado: ' + floattostr(r/d.CantidadValores(x,cdi)));
memo3.Lines.add('Importe Mayor: '+  floattostr(ma));
memo3.Lines.add('Importe Menos: '+  floattostr(me));
end;

procedure TForm1.Button5Click(Sender: TObject);
var
nummax,nummin:Integer;
begin
 ClienteMasYMenos(d,nummax,nummin);
 memo2.Lines.Add('El Cliente con mayor factruraccion es: ' + nummax.ToString);
 memo2.Lines.Add('El Cliente con menor factruraccion es: ' + nummin.ToString);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
CargarArchivo(ArchiCliente);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
memo2.Lines.Add(Mostrar(archiCliente));
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
CearDICCIONARIO(d,archicliente);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
AsignarArchivo(ArchiCliente);
end;

end.
