unit ArbolPointer;

interface

Uses
Tipos, Dialogs, QueuesPointer, StackPointer, SysUtils, Variants;

Const
MAX=5000;
NULO=Nil;

type

PosicionArbol=^NodoArbol;

NodoArbol=Object
  Datos:TipoElemento;
  HI,HD:PosicionArbol;
  FE:-1..1;
End;

Arbol=Object
  Private
    Raiz:PosicionArbol;
    Q_Items:Longint;
  Public
    procedure Crear;
    function EsVacio():boolean;
    function EsLleno():boolean;
    function RamaNula(P:PosicionArbol):boolean;
    function Recuperar(P:PosicionArbol; var X:TipoElemento):errores;
    function CargarArbol():errores;
    function PreOrden():String;
    function InOrden():string;
    function PostOrden():string;
    function Anchura():string;
    function PreOrdenITE():string;
    function Altura():integer;
    function BuscarPreOrden(X:TipoElemento; ComparaPor:CampoComparar):PosicionArbol;
    function Nivel(Q:PosicionArbol):longint;
    function HijoIzquierdo(P:PosicionArbol):PosicionArbol;
    function HijoDerecho(P:PosicionArbol):PosicionArbol;
    function Padre(Hijo:PosicionArbol):PosicionArbol;
    procedure CrearNodo(var P:PosicionArbol; X:TipoElemento);
    function InsertarNodo(X:TipoElemento; ComparaPor:CampoComparar):Errores;
    function EliminarNodo(X:TipoElemento; ComparaPor:CampoComparar):Errores;
    function BusquedaBinaria(X:TipoElemento; ComparaPor:CampoComparar):PosicionArbol;
    function InsertarNodoAVL(X:TipoElemento; ComparaPor:CampoComparar):Errores;
    function EliminarNodoAVL(X:TipoElemento; ComparaPor:CampoComparar):Errores;
    function Salvar(sFileName:string):boolean;
    function Cargar(sFileName:string):boolean;
    procedure LlenarRandom(RangoHasta:longint);
    function CantidadNodos():longint;
    function Root():posicionArbol;
    procedure SetRoot(R:posicionArbol);
    procedure ConectarHI(P:posicionArbol; Q:PosicionArbol);
    procedure ConectarHD(P:PosicionArbol; Q:PosicionArbol);
End;

    procedure R_II(var N:PosicionArbol; N1:posicionArbol);
    procedure R_DD(var N:PosicionArbol; N1:posicionArbol);
    procedure R_ID(var N:PosicionArbol; N1:posicionArbol);
    procedure R_DI(var N:PosicionArbol; N1:posicionArbol);
    procedure Equilibrar_I(var N:PosicionArbol; var bh:boolean);
    procedure Equilibrar_D(var N:PosicionArbol; var bh:boolean);

implementation

  procedure arbol.Crear;
  begin
  Raiz:=Nulo;
  Q_Items:=0;
  end;

  function Arbol.EsVacio;
  begin
  EsVacio:= (Raiz=NULO);
  end;

  function Arbol.EsLleno;
  begin
  EsLleno:= (Q_Items=MAX);
  end;

  function Arbol.RamaNula(P: PosicionArbol):boolean;
  begin
  RamaNula:= (P=NULO);
  end;

  function Arbol.Recuperar(P: PosicionArbol; var X: TipoElemento):Errores;
  begin
  if esVacio then
    Recuperar:=Vacia
  else
    begin
      try
       X:=P^.Datos;
       Recuperar:=OK;
       except
       Recuperar:=cError;
       end;
    end;
  end;

  // pre orden -> raiz - sub izq - sub der
  function Arbol.CargarArbol:Errores;
    var
    X:TipoElemento;

    procedure Load(var P:PosicionArbol);

    begin
    X.DS:=InputBox('Ingresar un caracter' , 'Input' , '.');
    if X.DS='.' then
      P:=NULO
    else
      begin
        New(P);
        P^.Datos:=X;
        Inc(Q_Items);
        Load(P^.HI);
        Load(P^.HD);
      end;
    end;

  begin
  X.Inicializar;
  CargarArbol:=cError;
  Crear();
  Load(raiz);
  CargarArbol:=OK;
  end;

  function arbol.PreOrden:string;
  var
  s:string;

    procedure PreOrd(P:PosicionArbol);
    begin
      if RamaNula(p) then
        S:=S+ '.'
      else
        begin
          S:=S+P^.Datos.DS;
          PreOrd(P^.HI);
          PreOrd(P^.HD);
        end;
    end;

  // Function PreOrden
  begin
  S:='';
  PreOrd(raiz);
  PreOrden:=S;
  end;


  function arbol.InOrden:string;
  var
  S:string;

    procedure InOrd(P:PosicionArbol);
    begin
      if RamaNula(p) then
        S:= S+ '.'
      else
        begin
          InOrd(P^.HI);
          S:=S+P^.Datos.DS;
          InOrd(P^.HD);
        end;
    end;
  // Function InOrden
  begin
  S:='';
  InOrd(Raiz);
  InOrden:=S;
  end;


  function arbol.PostOrden:string;
  var
  S:String;

    procedure PostOrd(P:posicionArbol);
    begin
      if RamaNula(p) then
        S:=S+ '.'
      else
        begin
          PostOrd(P^.HI);
          PostOrd(P^.HD);
          S:=S+P^.Datos.DS;
        end;
    end;

  begin
  S:='';
  PostOrd(Raiz);
  PostOrden:=S;
  end;



  function arbol.Anchura:string;
  var
  C:Cola;
  X:TipoElemento;
  S:string;
  Q:PosicionArbol;

  begin
    S:='';
    if not esVacio then
      begin
        C.Crear;
        X.Inicializar;
        X.DP:=Raiz;
        C.Encolar(X);
        while not C.EsVacia do
          begin
            C.Recuperar(X);            // recupero de la COLA el dato que contiene el puntero al arbol
            C.Desencolar;
            Q:=X.DP;                     // guardo la posicion del arbol en Q
            S:=S+Q^.Datos.DS+' ';          // el elemento recuperado lo concateno a la respuesta
            if not RamaNula(Q^.HI) then
              begin
              X.DP:=Q^.HI;
              C.Encolar(X);
              end;
            if not RamaNula(Q^.HD) then
              begin
              X.DP:=Q^.HD;
              C.Encolar(X);
              end;
          end;
      end;
    anchura:=S;
  end;


  function arbol.PreOrdenITE:string;
  var
  stack:pila;
  X:TipoElemento;
  S:String;
  Q:PosicionArbol;

  begin
  stack.Crear;
  S:='';
  X.Inicializar;
  X.DP:=Raiz;
  stack.Apilar(X);
  while not Stack.EsVacia do
    begin
    stack.Recuperar(X);
    stack.Desapilar;
    Q:=X.DP;
    S:=S+Q^.Datos.DS+' ';
    if not RamaNula(Q^.HI) then
      begin
      X.DP:=Q^.HD;
      stack.Apilar(X);
      end;
    if HijoIzquierdo(X.DP)<>NULO then
      begin
      X.Inicializar;
      X.DP:=HijoIzquierdo(X.DP);
      stack.Apilar(X);
      end;
    end;
  end;


  function arbol.BuscarPreOrden(X: TipoElemento; ComparaPor: CampoComparar):PosicionArbol;
  var
  Pos:PosicionArbol;

    procedure Buscar(P:PosicionArbol);
    begin
      if not RamaNula(p) then
      begin
        if X.CompararTE(P^.Datos,ComparaPor)=igual then
          Pos:=P
        else
          begin
          Buscar(P^.HI);
          Buscar(P^.HD);
          end;
      end;
    end;

  begin
  Pos:=NULO;
  Buscar(Raiz);
  BuscarPreOrden:=Pos;
  end;




 function Arbol.Altura:integer;
 var
 H:integer;

  procedure Alt(P:PosicionArbol; C:Integer);
    begin
      if RamaNula(P) then
        begin
          if C>H then H:=C;
        end
      else
        begin
          Alt(P^.HI, C+1);
          Alt(P^.HD, C+1);
        end;
    end;

 begin
 H:=0;
 Alt(Raiz,0);
 Altura:=H;
 end;


 function Arbol.Nivel(Q: PosicionArbol):integer;
 var
 N:Integer;

    procedure Niv(P:PosicionArbol; C:Integer);
    begin
     if not RamaNula(p) then
        if P=Q then
          N:=C
        else
        begin
          Niv(P^.HI,C+1);
          Niv(P^.HD,C+1);
        end;
    end;

 begin
 N:=0;
 Niv(Raiz,0);
 Nivel:=N;
 end;


  function arbol.Padre(Hijo: PosicionArbol):PosicionArbol;
  var
  pad:PosicionArbol;

    procedure BuscarPadre(P:PosicionArbol);
      begin
        if not RamaNula(P) then
          begin
            if (P^.HI=Hijo) or (P^.HD=Hijo) then
              pad:=P
            else
              begin
                BuscarPadre(P^.HI);
                BuscarPadre(P^.HD);
              end;
          end;
      end;

  begin
  Pad:=NULO;
  BuscarPadre(Raiz);
  Padre:=Pad;
  end;


  function arbol.HijoIzquierdo(P: PosicionArbol):PosicionArbol;
  begin
  HijoIzquierdo:=NULO;
  if not RamaNula(P) then
    HijoIzquierdo:=P^.HI;
  end;

  function arbol.HijoDerecho(P: PosicionArbol):PosicionArbol;
  begin
  HijoDerecho:=NULO;
  if not RamaNula(P) then
    HijoDerecho:=P^.HD;
  end;


  procedure arbol.CrearNodo(var P: PosicionArbol; X: TipoElemento);
  begin
  New(P);
  P^.Datos:=X;
  P^.HI:=NULO;
  P^.HD:=NULO;
  P^.FE:=0;
  end;


  function arbol.InsertarNodo(X:TipoElemento; ComparaPor:CampoComparar):Errores;
  var
  P,Q:PosicionArbol;

  begin

    if EsLleno then
      InsertarNodo:=Llena

    else
      begin
      if EsVacio then
        begin
          CrearNodo(Q,x);
          Raiz:=Q;
          Inc(Q_Items);
          InsertarNodo:=OK;
        end
      else
        begin
          Q:=Raiz;
          while not RamaNula(Q) do
            begin
            P:=Q;
            if X.CompararTE(Q^.Datos,ComparaPor)=menor then
              Q:=Q^.HI
            else
              Q:=Q^.HD;
            end;
          // Cuando llego a un Q nulo, ahi tengo que insertar el nuevo nodo
          CrearNodo(Q,X);
          // Tengo que conectarlo al arbol determinando si es menor o no a su padre
          if X.CompararTE(P^.Datos,ComparaPor)=menor then
            P^.HI:=Q
          else
            P^.HD:=Q;
          end;
      Inc(Q_items);
      InsertarNodo:=OK;
      end;
  end;


  function Arbol.EliminarNodo(X: TipoElemento; ComparaPor: CampoComparar):Errores;
  var
   Q:PosicionArbol;
   B:Boolean;

    procedure Eliminar(Var P:PosicionArbol);

      procedure Buscar_Clave_Reemplazar(var R:PosicionArbol);
      begin
        if not (RamaNula(R^.HI)) then
          Buscar_Clave_Reemplazar(R^.HI)
        else
          begin
            Q^.Datos:=R^.Datos;
            Q:=R;
            R:=Q^.HD;
          end;
      end;

    begin
    if not RamaNula(P) then
      if X.CompararTE(P^.Datos,ComparaPor)=menor then
        Eliminar(P^.HI)
      else
        if X.CompararTE(P^.Datos,ComparaPor)=mayor then
          Eliminar(P^.HD)
        else
          begin
          Q:=P;
          if RamaNula(Q^.HI) then
            P:=Q^.HD
          else
            if RamaNula(Q^.HD) then
              P:=Q^.HI
            else
              Buscar_Clave_Reemplazar(Q^.HD);
          Dispose(Q);
          Dec(Q_items);
          b:=true;
          end;
    end;

  begin
  if EsVacio then
    EliminarNodo:=Vacia
  else
    begin
    EliminarNodo:=cError;
    B:=False;
    Eliminar(Raiz);
    if B then EliminarNodo:=OK;
    end;
  end;


  function Arbol.BusquedaBinaria(X: TipoElemento; ComparaPor: CampoComparar):PosicionArbol;
  var
  Q:PosicionArbol;
  Encontre:boolean;
  rtaComp:Comparacion;
  begin
  if EsVacio then
    BusquedaBinaria:=NULO
  else
    begin
      Q:=Raiz;
      Encontre:=false;
      while (Q<>NULO) and (not Encontre) do
        begin
          RtaComp:=X.CompararTE(Q^.Datos,ComparaPor);
          if RtaComp=igual then
            Encontre:=True
          else
            if RtaComp=menor then
              Q:=Q^.HI
            else
              Q:=Q^.HD;
        end;
      if Encontre then
        BusquedaBinaria:=Q;
    end;
  end;


  function arbol.InsertarNodoAVL(X: TipoElemento; ComparaPor: CampoComparar):Errores;
  var
  bh:boolean;
  Inserto:boolean;

    procedure Insertar(var R:posicionArbol; var bh:boolean);
    Var
    N1:PosicionArbol;
    begin
      if RamaNula(R) then
        begin
          CrearNodo(R,X);
          bh:=true;
          Inserto:=true;
        end
      else
        if X.CompararTE(R^.Datos,ComparaPor)=menor then
          begin
            Insertar(R^.HI,bh);
            if bh then
              Case R^.FE of
                1:begin
                  R^.FE:=0;
                  bh:=false;
                end;

                0:begin
                  R^.FE:=-1;
                end;

                -1:begin
                  N1:=R^.HI;
                  if N1.FE <= 0 then
                    R_II(R,N1)
                  else
                    R_ID(R,N1);
                  bh:=false;
                end;
              End;
          end
        else
          if (X.CompararTE(R^.Datos,ComparaPor)=mayor) or (X.CompararTE(R^.Datos,ComparaPor)=igual) then
            begin
              Insertar(R^.HD,bh);
              if bh then

                  case R^.FE of
                  -1: begin
                      R^.FE:=0;
                      bh:=false;
                      end;

                  0:R^.FE:=1;

                  1: begin
                     N1:=R^.HD;
                     if N1^.FE>=0 then
                       R_DD(R,N1)
                     else
                       R_DI(R,N1);
                     bh:=false;
                     end;
                  end;
            end;
    end;

  begin
  if EsLleno then
    InsertarNodoAVL:=llena
  else
    begin
    InsertarNodoAvl:=cError;
    inserto:=false;
    bh:=false;
    Insertar(Raiz,bh);
    if Inserto then
      begin
      InsertarNodoAVL:=OK;
      inc(Q_Items);
      end;
    end;
  end;



  function arbol.EliminarNodoAVL(X: TipoElemento; ComparaPor: CampoComparar):errores;
  var
  bh:boolean;


    procedure Eliminar(Var R:PosicionArbol; Var bh:boolean);
    var
    Q:PosicionArbol;

          procedure B_N_R(Var P:posicionArbol; Var bh:Boolean);
          begin
            if P^.HI<>NULO then
              begin
                B_N_R(P^.HI,bh);
                if bh then Equilibrar_I(P,bh);
              end
            else
              begin
                Q^.Datos:=P^.Datos;
                Q:=P;
                P:=P^.HD;
                bh:=true;
              end;
          end;


    begin
    if not RamaNula(R) then
      if X.CompararTE(R^.Datos,ComparaPor)=menor then
        begin
        Eliminar(R^.HI,bh);
        if bh then Equilibrar_I(R,bh);
        end
      else
        if X.CompararTE(R^.Datos,ComparaPor)=mayor then
          begin
          Eliminar(R^.HD,bh);
          if bh then Equilibrar_D(R,bh);
          end
        else
          begin
          Q:=R;
          if RamaNula(Q^.HD) then
            begin
            R:=Q^.HI;
            bh:=true;
            end
          else
            if RamaNula(Q^.HI) then
              begin
              R:=Q^.HD;
              bh:=true;
              end
            else
              begin
              B_N_R(Q^.HD,bh);
              if bh then Equilibrar_D(R,bh);
              end;
          Dispose(Q);
          Dec(Q_items);
          end;
    end;

  begin
  if EsVacio then EliminarNodoAVL:=Vacia
  else
    begin
    EliminarNodoAVL:=cError;
    Eliminar(raiz,bh);
    EliminarNodoAVL:=OK;
    end;
  end;




  function arbol.CantidadNodos():integer;
  begin
  CantidadNodos:=Q_Items;
  end;


  procedure R_II(Var N:posicionArbol; N1:PosicionArbol);
  begin
  N^.HI:=N1^.HD;
  N1^.HD:=N;

  if N1^.FE=-1 then
    begin
      N^.FE:=0;
      N1^.FE:=0;
    end
  else
    begin
      N^.FE:=-1;
      N1^.FE:=1;
    end;
   N:=N1;
  end;

  procedure R_DD(Var N:posicionArbol; N1:posicionArbol);
  begin
  N^.HD:=N1^.HI;
  N1^.HI:=N;

  if N1^.FE=1 then
    begin
      N1^.FE:=0;
      N^.FE:=0;
    end
  else
    begin
      N^.FE:=1;
      N1^.FE:=-1;
    end;
  N:=N1;
  end;


  procedure R_ID(Var N:posicionArbol; N1:posicionArbol);
  var
  N2:PosicionArbol;
  begin
    N2:=N1^.HD;

    N^.HI:=N2^.HD;
    N2^.HD:=N;

    N1^.HD:=N2^.HI;
    N2^.HI:=N1;

    if N2^.FE=-1 then
      N^.FE:=1
    else
      N^.FE:=0;

    if N2^.FE=1 then
      N1^.FE:=-1
    else
      N1^.FE:=0;
  N2^.FE:=0;

  N:=N2;
  end;


  procedure R_DI(Var N:posicionArbol; N1:PosicionArbol);
  var
  N2:PosicionArbol;
  begin
    N2:=N1^.HI;

    N^.HD:=N2^.HI;
    N2^.HI:=N;

    N1^.HI:=N2^.HD;
    N2^.HD:=N1;

    if N2^.FE=1 then
      N.FE:=-1
    else
      N.FE:=0;
    if N2^.FE=-1 then
      N1.FE:=1
    else
      N1.FE:=0;
  N2^.FE:=0;

  N:=N2;
  end;


  procedure Equilibrar_I(var N:posicionArbol; var bh:boolean);
  var
  N1:posicionArbol;
  begin
    case N^.FE of
      -1: N^.FE:=0;

       0: begin
          N^.FE:=1;
          bh:=false;
       end;

       1: begin
          N1:=N^.HD;

          if N1^.FE>=0 then
            begin
            if N1^.FE=0 then bh:=false;
            R_DD(N,N1);
            end
          else
            R_DI(N,N1);

       end;
    end;
  end;

  procedure Equilibrar_D(var N:posicionArbol; var bh:boolean);
  var
  N1:posicionArbol;
  begin
    case N^.FE of
      1: N^.FE:=0;

      0: begin
         N^.FE:=-1;
         bh:=false;
      end;

      -1: begin
          N1:=N^.HI;
          if N1^.FE<=0 then
            begin
            if N1^.FE=0 then bh:=false;
            R_II(N,N1);
            end
          else
            R_ID(N,N1);

      end;
    end;
  end;


  function Arbol.Salvar(sFileName: string):Boolean;
  var
  S:String;
  T:TextFile;
  X:TipoElemento;

    procedure Salva(P:PosicionArbol);
    begin
      if not RamaNula(p) then
        begin
        X:=P^.Datos;
        S:=X.ArmarString;
        Writeln(T,S);
        Salva(P^.HI);
        Salva(P^.HD);
        end;
    end;

  begin
  Salvar:=false;
  assignFile(T,sFileName);
  rewrite(T);
  Salva(Raiz);
  CloseFile(T);
  Salvar:=true;
  end;



  function Arbol.Cargar(sFileName: string):boolean;
  var
  S:String;
  T:TextFile;
  X:TipoElemento;
  begin
  assignFile(T,sFileName);
  reset(T);
  crear;
  while not EOF(T) do
    begin
      readln(T,S);
      X.CargarTE(S);
      InsertarNodoAVL(X,cDI);
    end;

  closefile(T);
  end;


  Procedure Arbol.LlenarRandom(RangoHasta: LongInt);
Var X: TipoElemento;
Begin
 X.Inicializar;
 Crear();
 Randomize;
 // Cargo hasta que se llene
 While Not EsLleno() Do Begin
 X.DI := Random(RangoHasta);
 X.DS := IntToStr(X.DI);
 InsertarNodoAVL(X, CDI);
 End;
End;

Function Arbol.Root(): PosicionArbol;
Begin
 Root := raiz;
End;
// Propiedades de Asignacion al Arbol
Procedure Arbol.SetRoot(R:PosicionArbol);
Begin
 Raiz := R;
 If R <> Nulo Then Inc(Q_Items);
End;
// Conecta Hijo Izquierdo (P-->Q)
Procedure Arbol.ConectarHI(P:PosicionArbol; Q:PosicionArbol);
Begin
 P^.HI := Q;
 If Q <> Nulo Then Inc(Q_Items);
End;
// Conecta Hijo Derecho (P-->Q)
Procedure Arbol.ConectarHD(P:PosicionArbol; Q:PosicionArbol);
Begin
 P^.HD := Q;
 If Q <> Nulo Then Inc(Q_Items);
End;

end.
