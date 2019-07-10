unit ListArray;

interface

uses
  Tipos, stdctrls, SysUtils, Variants, Vcl.Dialogs;

const
  MIN=1; MAX=5000;
  NULO=0;

type
  PosicionLista=LongInt;

  Lista= object
    Private
      Elementos:array [MIN..MAX] of TipoElemento;
      Inicio, Final:PosicionLista;
      Q_items:Integer;
      Procedure Intercambio(P,Q:posicionLista);
    Public
      Procedure Crear();
      Function EsVacia(): Boolean;
      Function EsLLena(): Boolean;
      Function Agregar(X:TipoElemento): Errores;
      Function Insertar(X:TipoElemento; P:PosicionLista): Errores;
      Function Eliminar(P:PosicionLista): Errores;
      Function Buscar(X:TipoElemento; ComparaPor:CampoComparar):PosicionLista;
      Function Siguiente(P:PosicionLista): PosicionLista;
      Function Anterior(P:PosicionLista): PosicionLista;
      Function Ordinal(PLogica: Integer): PosicionLista;
      Function Recuperar(Var X:TipoElemento; P:PosicionLista): Errores;
      Function Actualizar(X:TipoElemento; P:PosicionLista): Errores;
      Function ValidarPosicion(P:PosicionLista): Boolean;
      Function RetornarString(): String;
      Function LlenarRandom(RangoHasta: LongInt): Errores;
      Procedure Sort(ComparaPor: CampoComparar);
      Procedure Salvar(sFileName: String);
      Procedure Cargar(sFileName: String);
      Function Comienzo: PosicionLista;
      Function Fin: PosicionLista;
      Function CantidadElementos: LongInt;
  end;



implementation

  procedure Lista.Intercambio(P,Q:posicionLista);
  var
  aux:tipoElemento;
  begin
  aux:=Elementos[p];
  Elementos[p]:=Elementos[q];
  Elementos[q]:=aux;
  end;

  procedure Lista.Crear;
  begin
  Inicio:=Nulo;
  Final:=Nulo;
  Q_items:=0;
  end;

  function Lista.EsVacia:boolean;
  begin
  if Inicio=NULO then
    EsVacia:=true
  else
    EsVacia:=false;
  end;

  function Lista.EsLLena:boolean;
  begin
  if Final=MAX then
    EsLlena:=true
  else
    EsLlena:=false;
  end;

  function Lista.Agregar(X: TipoElemento):errores;
  begin
  Agregar:=CError;
  if Lista.EsLLena then
    Agregar:=Llena
  else
    begin
    Final:=Final+1;
    elementos[final]:=X;
    if Lista.EsVacia then
       inicio:=final;
    Q_items:=Q_items+1;
    Agregar:=OK;
    end;

  end;

  function Lista.Insertar(X: TipoElemento; P: Integer):errores;
  var
  i:PosicionLista;               // auxiliar para desplazar elementos
  begin
  Insertar:=CError;
  if Lista.EsLLena then
    Insertar:=Llena
  else
    if not validarPosicion(P) then
      Insertar:=PosicionInvalida
    else
      begin
      for i:=Final downto P do
        Elementos[i+1]:=Elementos[i];
      Elementos[P]:=X;
      inc(final);
      inc(Q_items);
      Insertar:=OK;
      end;
  end;

  function Lista.Eliminar(P: Integer):Errores;
  var
  i:PosicionLista;
  begin
  if Lista.EsVacia then                       // si es vacia no hay elementos para eliminar
    Eliminar:=Vacia
  else
    if validarPosicion(P) then                // si la posicion es válida
       begin
       for i:=P to Final-1 do
         elementos[i]:=elementos[i+1];        //aplasto de derecha a izquierda
       Dec(final);
       Dec(Q_items);
       if final<inicio then
         Lista.Crear();
       Eliminar:=OK;
       end
       else
       Eliminar:=PosicionInvalida;
  end;

  function Lista.Buscar(X: TipoElemento; ComparaPor: CampoComparar):PosicionLista;
  var
  i:PosicionLista;
  encuentre:boolean;
  begin
  Buscar:=NULO;
  i:=inicio;
  while not encuentre and (i<final) do   // mientras no lo encuentre y la i no se pase
    begin
    if Elementos[i].CompararTE(x,ComparaPor)=igual then
      begin
        Buscar:=i;
        encuentre:=true;
        end;
    inc(i);
    end;
  end;

  function Lista.Siguiente(P: Integer):PosicionLista;
  begin
   Siguiente:=NULO;
   if ValidarPosicion(P) and (p<final) then
    Siguiente:=P+1;
  end;

  function Lista.Anterior(P: Integer):PosicionLista;
  begin
   Anterior:=NULO;
   if ValidarPosicion(P) and (p>inicio) then
    Anterior:=p-1;
  end;

  function Lista.Ordinal(PLogica: Integer):PosicionLista;
  begin
  if ValidarPosicion(PLogica) then
    ordinal:=PLogica+(MIN-Inicio);      // Diferencia entre MIN (física) e Inicio (lógica)
  end;                                  // sumado a PLogica obtengo posicion física de PLogica

  function Lista.Recuperar(var X: TipoElemento; P: Integer):Errores;
  begin
    Recuperar:=CError;
    if ValidarPosicion(P) then
      begin
      x:=Elementos[p];
      Recuperar:=OK;
      end;
  end;

  function Lista.Actualizar(X: TipoElemento; P: Integer):Errores;
  begin
  Actualizar:=CError;
  if ValidarPosicion(P) then
    begin
      Elementos[P]:=X;
      Actualizar:=OK;
    end;
  end;

  function Lista.ValidarPosicion(P: Integer):boolean;
  begin
  ValidarPosicion:=false;
  if (not Lista.EsVacia) and (P>=Inicio) and (P<=Final) then
    ValidarPosicion:=true;
  end;

  function Lista.RetornarString:string;
  var
  P:PosicionLista;
  E:tipoElemento;
  RS:string;                    // para armar y retornar string
  begin
  RS:='';
  P:=inicio;                    // si la lista es vacia inicio->Nulo
  while P<>NULO do
    begin
      Recuperar(E,P);                 // recupero en E el elemento de posicion P
      RS:=RS+E.ArmarString+cCRLF;     // concateno y fin de linea retorno carro
      P:=Siguiente(P);
    end;
  RetornarString:=RS;
  end;

  function Lista.LlenarRandom(RangoHasta: Integer):Errores;
  var
  E:tipoElemento;
  begin
    try
    Randomize;
    Lista.Crear();
    E.Inicializar;
    while (not Lista.EsLlena) do
      begin
        E.DI:=random(RangoHasta);
        Agregar(E);
      end;
    LlenarRandom:=OK;
    except
    LlenarRandom:=CError;
    end;
  end;

  procedure Lista.Sort(ComparaPor: CampoComparar);
  var
  E1,E2:TipoElemento;           // aca recupero para comparar
  i,j:PosicionLista;            // indices para recorrer la lista
  menor:PosicionLista;
  begin
  E1.Inicializar;
  E2.Inicializar;
  i:=Inicio;
  // ordenamiento por selección     de menor a mayor
  while siguiente(i)<>NULO do
     begin
     menor:=i;             // inicializo menor es el primero de cada ciclo de i
     j:=siguiente(i);           // comparo desde el segundo
     while j<>NULO do
        begin
        recuperar(E1,menor);                          // en E1 siempre el menor hasta el momento
        recuperar(E2,j);
        if E1.CompararTE(E2,ComparaPor)=MAYOR then    // si E1 > E2 then
          menor:=j;                                   // en menor guardo pos de E2 (el menor)
        j:=siguiente(j);
        end;
    Intercambio(i,menor);
    i:=siguiente(i);
    end;
  end;

  procedure Lista.Salvar(sFileName: string);
  var
  f:text;
  begin
  assign(f,sFileName);
  rewrite(f);
  write(f,self.RetornarString);         // retornarString devuelve listo para mostrar en memo/archivo
  closefile(f);
  end;

  procedure Lista.Cargar(sFileName: string);
  var
  f:text;
  E:TipoElemento;
  Str:String;
  begin
  assign(f,sFileName);
  reset(f);
  self.Crear;
  while not EOF(f) and (not self.EsLLena) do
     begin
       readln(f,str);
       E.CargarTE(str);
       self.Agregar(E);
     end;
  closefile(f);
  end;

  function Lista.Comienzo: posicionLista;
  begin
  Comienzo:=inicio;
  end;

  function Lista.Fin: posicionLista;
  begin
  fin:=Final;
  end;

  function Lista.CantidadElementos: Longint;
  begin
  CantidadElementos:=Q_Items;
  end;
end.
