unit StackPointer;

interface

uses
Tipos, stdctrls, SysUtils, Variants;

const
MIN=1;
MAX=10;
NULO=nil;

type

PosicionPila=^NodoPila;

NodoPila=object
  Datos:tipoElemento;
  Prox:PosicionPila;
end;

Pila=object
  private
    Inicio:PosicionPila;
    Q_Items:Integer;
  public
    Procedure Crear();
    Function EsVacia():boolean;
    Function EsLlena():boolean;
    Function Apilar(x:TipoElemento):errores;
    Function Desapilar():errores;
    Function Recuperar(var x:TipoElemento):errores;
    Function RetornarString():string;
    Procedure Intercambiar(var PAux:pila; bCrearVacia:boolean);
    Procedure LlenarRandom(RangoHasta:Longint);
    Procedure Salvar(sFileName:string);
    Procedure Cargar(sFileName:string);
    Function Tope:PosicionPila;
    Function CantidadElementos:Longint;

end;

implementation

procedure Pila.Crear;
begin
  Inicio:=NULO;
  Q_Items:=0;
end;

function Pila.EsVacia:boolean;
begin
  EsVacia:=(inicio=NULO);
end;

function Pila.EsLlena;
begin
  EsLlena:=(Q_items=MAX);
end;

function Pila.Apilar(x: TipoElemento):errores;
var
P:PosicionPila;
begin
  Apilar:=cError;
  if esLlena then
    Apilar:=llena
  else
    begin
    New(P);
    P^.Datos:=X;
    P^.Prox:=inicio;
    inicio:=P;
    inc(Q_items);
    Apilar:=OK;
    end;
end;


function Pila.Desapilar:errores;
var
P:PosicionPila;
begin
  Desapilar:=cError;
  if esVacia then
    Desapilar:=Vacia
  else
    begin
    P:=inicio;
    inicio:=inicio^.Prox;
    Dispose(P);
    dec(Q_Items);
    Desapilar:=OK;
    end;
end;

function Pila.Recuperar(var x: TipoElemento):errores;

begin
  Recuperar:=cError;
  if esVacia then
    Recuperar:=Vacia
  else
    begin
     x:=inicio^.Datos;
     Recuperar:=OK;
    end;
end;

procedure Pila.Intercambiar(var PAux: Pila; bCrearVacia: Boolean);
var
x:TipoElemento;
begin
  if bCrearVacia then
    Crear;
  while not PAux.EsVacia do
    begin
    PAux.Recuperar(x);
    PAux.Desapilar;
    Apilar(x);
    end;
end;

function Pila.RetornarString:string;
var
s1,s2:string;
PAux:pila;
x:TipoElemento;
begin
  PAux.Crear;
  s2:='';
  while not EsVacia do
    begin
    Recuperar(x);
    PAux.Apilar(x);
    Desapilar;
    s1:=x.ArmarString;
    s2:=s2 + s1 +cCRLF;
    end;
  Intercambiar(PAux,true);
  RetornarString:=s2;
end;

procedure Pila.Salvar(sFileName: string);
var
t:TextFile;
PAux:Pila;
x:TipoElemento;
begin
assign(t,sFileName);
rewrite(t);
PAux.Crear;
while not EsVacia do
  begin
  recuperar(x);
  writeln(t,x.ArmarString);
  PAux.Apilar(x);
  Desapilar;
  end;
Intercambiar(PAux,true);
closeFile(t);
end;

procedure Pila.Cargar(sFileName: string);
var
t:textFile;
x:TipoElemento;
s:string;
begin
assign(t,sFileName);
reset(t);
Crear;
while not eof(t) do
  begin
    readln(t,s);
    x.CargarTE(s);
    Apilar(x);
  end;
closeFile(t);
end;

procedure Pila.LlenarRandom(RangoHasta: Integer);
var
x:TipoElemento;
begin
x.Inicializar;
Crear;
Randomize;
while not esLlena do
  begin
    x.DI:=random(RangoHasta);
    apilar(x);
  end;
end;

function Pila.Tope:PosicionPila;
begin
Tope:=Inicio;
end;

function Pila.CantidadElementos:integer;
begin
CantidadElementos:=Q_items;
end;
end.

