unit QueuesPointer;

interface

uses
Tipos, StdCtrls, SysUtils, Variants;

const
MIN=1;
MAX=10;
NULO=NIL;

type
PosicionCola=^NodoCola;

NodoCola=Object
  Datos:TipoElemento;
  Prox:PosicionCola;
End;

Cola=Object
  Private
    Inicio,Fin:PosicionCola;
    Q_Items:Integer;
  Public
    Procedure Crear();
    Function EsVacia():Boolean;
    Function EsLLena():Boolean;
    Function Encolar(X:TipoElemento):Errores;
    Function Desencolar():Errores;
    Function Recuperar(Var X:TipoElemento):Errores;
    Function RetornarString(): String;
    Procedure Intercambiar (Var Caux: Cola; bCrearVacia: Boolean);
    Function LlenarRandom(RangoHasta: LongInt): Errores;
    Procedure Salvar(sFileName: String);
    Procedure Cargar(sFileName: String);
    Function Frente: PosicionCola;
    Function Final: PosicionCola;
    Function CantidadElementos: LongInt;
End;


implementation

  procedure Cola.Crear();
  begin
    Inicio:=NULO;
    Fin:=NULO;
    Q_Items:=0;
  end;


  function Cola.EsVacia():boolean;
  begin
  EsVacia:= (Inicio=NULO)
  end;

  Function Cola.EsLLena(): Boolean;
  begin
  EsLlena:=(Q_Items=MAX);
  End;

  // Agrega un elemento a la Cola al Final
  Function Cola.Encolar(X:TipoElemento): Errores;
  var
  P:PosicionCola;
  begin
    Encolar := CError;
    if esLlena then
      Encolar:=Llena
    else
      begin
        New(P);
        P^.Datos:=X;
        P^.Prox:=NULO;
        if EsVacia then
          Inicio:=P
        else
          Fin^.Prox:=P;
        Fin:=P;
        inc(Q_Items);
        Encolar:=OK;
      end;

  End;

  function Cola.Desencolar():errores;
  var
  P:PosicionCola;
  begin
  Desencolar:=cError;
  if EsVacia then
    Desencolar:=Vacia
  else
    begin
      P:=Inicio;
      Inicio:=P^.Prox;
      Dispose(P);
      Dec(Q_Items);
      Desencolar:=OK;
    end;
  end;


  function Cola.Recuperar(var X: TipoElemento):Errores;
  begin
  Recuperar:=cError;
  if EsVacia then
    Recuperar:=Vacia
  else
    begin
    X:=Inicio^.Datos;
    Recuperar:=OK;
    end;
  end;

  procedure Cola.Intercambiar(var Caux: Cola; bCrearVacia: Boolean);
  var
  X:TipoElemento;

  begin
  if bCrearVacia then
    Crear;
  while not CAux.EsVacia do
    begin
      CAux.Recuperar(X);
      CAux.Desencolar;
      Encolar(X);
    end;
  end;

  function Cola.RetornarString:string;
  var
  S:string;
  SS:String;
  X:TipoElemento;
  aux:Cola;
  begin
  SS:='';
  aux.Crear;
  while not EsVacia do
    begin
      Recuperar(X);
      S:=X.ArmarString;
      SS:=SS+S+cCRLF;
      Desencolar;
      Aux.Encolar(X);
    end;
  Intercambiar(aux,true);
  RetornarString:=SS;
  end;

  function Cola.LlenarRandom(RangoHasta: Integer):Errores;
  var
  X:TipoElemento;
  begin
  LlenarRandom:=cError;
  Crear;
  X.Inicializar;
  Randomize;
  while not EsLlena do
    begin
      X.DI:=Random(RangoHasta);
      Encolar(X);
    end;
  LlenarRandom:=OK;
  end;

  Procedure Cola.Salvar(sFileName: string);
  var
  f:TextFile;
  Aux:Cola;
  X:tipoElemento;
  S:String;
  begin
  assignFile(F,sFileName);
  rewrite(f);
  Aux.Crear;
  while not EsVacia do
    begin
    Recuperar(X);
    S:=X.ArmarString;
    writeln(f,s);
    Desencolar;
    Aux.Encolar(X);
    end;
  Intercambiar(aux,true);
  CloseFile(f);
  end;

  procedure cola.Cargar(sFileName: string);
  var
  f:textFile;
  s:string;
  X:TipoElemento;
  begin
  assign(f,sFileName);
  reset(f);
  crear;
  while not EOF(f) do
    begin
    readln(f,s);
    X.CargarTE(s);
    Encolar(x);
    end;
  CloseFile(f);
  end;

  function Cola.Frente:PosicionCola;
  begin
  Frente:=Inicio;
  end;

  function Cola.Final:PosicionCola;
  begin
  Final:=Fin;
  end;

  Function Cola.CantidadElementos:Longint;
  begin
  CantidadElementos:=Q_Items;
  end;
end.
