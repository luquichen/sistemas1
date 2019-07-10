unit ListPointer;

interface

Uses
Tipos, stdctrls, SysUtils, Variants,Vcl.Dialogs;

Const
MIN=1;
MAX=10;
NULO=Nil;

Type

PosicionLista = ^NodoLista;     // apuntador

NodoLista = object
  Datos: TipoElemento;
  Ante:PosicionLista;           // apuntador
  Prox:PosicionLista;           // apuntador
End;

Lista= object
  Private
  Inicio,Final:posicionLista;
  Q_items:Integer;
  Procedure Intercambio(P,Q:PosicionLista);

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

  procedure Lista.Crear;
  begin
  Inicio:=NULO;
  Final:=NULO;
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
  if Q_Items= max then
    EsLlena:=true
  else
    EsLlena:=false;
  end;

  function Lista.Agregar(X: TipoElemento):Errores;
  var
  PL:PosicionLista;
  begin
  if self.EsLLena then
    Agregar:=Llena
  else
    begin

    New(PL);                               // creo la posicion de la lista
    PL^.Datos:=X;                          // cargo los datos
    if self.EsVacia then                   // si esta vacía
      begin
      Crear;
      inicio:=PL;                              // inicio apunta al nuevo elemento (y unico)

      PL^.Ante:=NULO;                          // el elemento.anterior apunta a nulo
      PL^.Prox:=NULO;                          // el proximo es nulo
      inc(Q_items);                            // aumento cantidad elementos

      Final:=PL;                               // PL es el nuevo final
      end
    else                                   // si la lista tiene algun elemento
      begin
      Final^.Prox:=PL;                         // final.proximo es PL
      PL^.Ante:=Final;                         // PL.ante es final
      Final:=PL;                               // PL es el nuevo final
      PL^.Prox:=NULO;                          // PL.proximo es nil
      inc(Q_items);                            // aumento cantidad de elementos
      end;
    Agregar:=OK;
    end;
  end;





  function Lista.Insertar(X: TipoElemento; P: PosicionLista):Errores;
  var
   Q: PosicionLista;
  Begin
   Insertar := CError;
   if EsLlena then
    Insertar := Llena
   else
   begin
     if ValidarPosicion(P) Then
     begin
       new(Q);
       Q^.Datos := X;
       Q^.Prox := P;
       Q^.Ante := P^.Ante;
       if P = Inicio then
          Inicio := Q             // Cambia el Inicio
       else
          P^.Ante^.Prox := Q;
       P^.Ante := Q;
       Inc(Q_Items);
       Insertar := OK;
     end
   else
   Insertar := PosicionInvalida;
   end;
  end;




  function Lista.Eliminar(P: PosicionLista):Errores;
  begin
  Eliminar:=CError;

  if self.EsVacia then
    Eliminar:=Vacia
  else
    if P=inicio then
      begin

        if P=final then                  // si p=inicio=final -> hay un solo elemento
          crear()                        // luego creo la lista vacía
        else                             // si no (si p=inicio pero hay más elementos)
          begin
          inicio:=P^.Prox;               // el próximo a P es el nuevo inicio
          P^.Prox^.Ante:=NULO;           // el próximo a P apunta (como anterior) a P -> lo aNULO
          end
      end
    else                          // si P<>inicio
        if P=final then                  // si P=final
        begin
        P^.Ante^.Prox:=NULO;
        Final:=P^.Ante;
        end
        else                             // si P<>final ( inicio<P<Final )
         begin
           P^.Ante^.Prox:=P^.Prox;
           P^.Prox^.Ante:=P^.Ante;
         end;

  Dec(Q_Items);
  dispose(p);
  Eliminar:=OK;

  end;


  function Lista.Buscar(X: TipoElemento; ComparaPor: CampoComparar):PosicionLista;
  var
  encuentre:boolean;
  aux:PosicionLista;

  begin
   Buscar:=NULO;
   encuentre:=false;
   if not self.EsVacia then
     begin
     aux:=inicio;
     while (not encuentre) and (aux<>NULO) do
      begin
        if aux^.Datos.CompararTE(X,ComparaPor)=igual then
          encuentre:=true
        else
          aux:=siguiente(aux);
      end;
     end;
   if encuentre then
     Buscar:=aux;
  end;

  function Lista.Siguiente(P: PosicionLista):posicionLista;
  begin
  Siguiente:=NULO;
  if validarPosicion(p) then
    Siguiente:=P^.Prox;
  end;

  function Lista.Anterior(P: PosicionLista):posicionLista;
  begin
  Anterior:=NULO;
  if validarPosicion(p) then
    Anterior:=P^.Ante;
  end;


  function Lista.Ordinal(PLogica: Integer):posicionLista;
  var
  aux:PosicionLista;
  i:integer;
  begin
  Ordinal:=NULO;

    if (not EsVacia) then
    begin
      aux:=inicio;                            // aux apunta al inicio
      i:=MIN;                                 // i arranca desde 1
      while (i<PLogica) and (aux<>NULO) do
      begin
        aux:=aux^.Prox;
        inc(i);
      end;
      if aux<> NULO then
      Ordinal:=aux;
    end;
  end;


  function Lista.Recuperar(var X: TipoElemento; P: PosicionLista):errores;
  begin
  Recuperar:=cError;
  if ValidarPosicion(P) then
    begin
    X:=P^.Datos;
    Recuperar:=OK;
    end
  else
    Recuperar:=PosicionInvalida;
  end;

  function Lista.Actualizar(X: TipoElemento; P: PosicionLista):errores;
  begin
  Actualizar:=cError;
  if ValidarPosicion(P) then
    begin
    P^.Datos:=X;
    Actualizar:=OK;
    end
  else
    Actualizar:=PosicionInvalida;
  end;

  function Lista.ValidarPosicion(P: PosicionLista):boolean;
  var
  aux:PosicionLista;
  encuentre:boolean;
  i:integer;
  begin
  encuentre:=false;
  if not self.EsVacia then                               // si no es vacia
    begin
      aux:=inicio;                                       // en aux va pointer inicio
      i:=MIN;                                            // i igual a const MIN
      while (not encuentre) and (i<=Q_items) do           // mientras i <cantidad elementos y no encuentre
         if aux=p then                                   // si la posicion esta en la lista
            encuentre:=true                              // bandera a true
          else
            aux:=aux^.Prox;                                // aux es el proximo item de lista
    end;
  ValidarPosicion:=encuentre;
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


  Procedure Lista.Intercambio(P: PosicionLista; Q: PosicionLista);
  var
  E1,E2:TipoElemento;
  begin
  recuperar(E1,P);
  recuperar(E2,Q);
  actualizar(E1,Q);
  actualizar(E2,P);
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
