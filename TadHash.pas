unit TadHash;

interface

uses
  Tipos, ListArray;

Const
  MinTable = 0;
  MaxTable = 5000;
  PosNula = -1;
  NroPrimo = 497;

Type
  PosicionTabla = LongInt;

  TipoRegistroTabla = Object
    Clave: TipoElemento;
    Ocupado: Boolean;
    ListaColision: Lista;
  End;

  TablaHash = Object
  Private
    Tabla: Array [MinTable .. MaxTable] of TipoRegistroTabla;
    Q_Ocupados: Integer;
    Q_Claves: Integer;
    Q_ClavesLC: Integer;
  Public
    Procedure Crear();
    Function EsVacia(): Boolean;
    Function Insertar(X: TipoElemento; HashPor: CampoComparar): Errores;
    Function Eliminar(X: TipoElemento; CompararPor: CampoComparar): Errores;
    Function Buscar(X: TipoElemento; CompararPor: CampoComparar;
      Var PL: Variant): PosicionTabla;
    Function Recuperar(P: PosicionTabla; PL: Variant;
      Var X: TipoElemento): Errores;
    Function RetornarAsString(): String;
    Procedure LLenarRandom(RangoHasta: LongInt);
    Function Salvar(sFileName: String): Boolean;
    Function Cargar(sFileName: String): Boolean;
    Function CantidadClaves(): LongInt;
    Function CantidadOcupados(): LongInt;
    Function CantidadClavesZO(): LongInt;
  End;

implementation

// Marca todas las posiciones como vacías. Por cada posición crea la lista de
// colisiones vacia
Procedure TablaHash.Crear();
Var
  I: Integer;
Begin
  For I := MinTable To MaxTable Do
  Begin
    Tabla[I].Ocupado := False;
    Tabla[I].ListaColision.Crear;
  End;
  Q_Ocupados := 0;
  Q_Claves := 0;
End;

Function TablaHash.EsVacia(): Boolean;
Begin
  EsVacia := (Q_Ocupados = 0);
End;

// Esta es la funcion de transformación HASH
Function FuncionTransformacion(X: TipoElemento; HashPor: CampoComparar)
  : PosicionTabla;
Begin
  FuncionTransformacion := PosNula;
  If HashPor = CDI Then
    FuncionTransformacion := (X.DI Mod NroPrimo);
End;

// La funcion insertar primero ubica la posicion y se fija si esta libre
// En caso de estar ocupada lo agrega en la lista de colisiones
Function TablaHash.Insertar(X: TipoElemento; HashPor: CampoComparar): Errores;
Var
  P: PosicionTabla;
Begin
  P := FuncionTransformacion(X, HashPor);
  If P = PosNula Then
    Insertar := CError
  Else
  Begin
    If Tabla[P].Ocupado = False Then
    Begin
      Tabla[P].Clave := X;
      Tabla[P].Ocupado := True;
      Inc(Q_Ocupados);
    End
    Else
    Begin
      If Tabla[P].ListaColision.Agregar(X) <> OK Then
      Begin
        Insertar := CError;
        Exit;
      End
      Else
      Begin
        Inc(Q_ClavesLC);
      End;
    End;
    Inc(Q_Claves);
    Insertar := OK;
  End;
End;

// Primero busca si la clave existe.
// Luego si existe la elimina controlando si existe o NO lista de colisiones
Function TablaHash.Eliminar(X: TipoElemento;
  CompararPor: CampoComparar): Errores;
Var
  P: PosicionTabla;
  Q: PosicionLista;
Begin
  Eliminar := CError;
  // Llamo al FH
  P := FuncionTransformacion(X, CompararPor);
  If P <> PosNula Then
  Begin
    If Tabla[P].Ocupado = True Then
      If X.CompararTE(Tabla[P].Clave, CompararPor) = igual Then
        // Si tiene claves en colisión debo tomar la primer clave
        // de la lista y pasarla a la tabla hash
        If Not Tabla[P].ListaColision.EsVacia Then
        begin
          Tabla[P].ListaColision.Recuperar(X, Tabla[P].ListaColision.Comienzo);
          Tabla[P].Clave := X;
          Tabla[P].ListaColision.Eliminar(Tabla[P].ListaColision.Comienzo);
          Dec(Q_Claves);
          Dec(Q_ClavesLC);
          Eliminar := OK;
        End
        Else
        Begin
          // La clave esta en la tabla y no hay colisiones
          Tabla[P].Ocupado := False;
          Dec(Q_Ocupados);
          Dec(Q_Claves);
          Eliminar := OK;
        End
      Else
      Begin
        // La clave esta en la lista de colisión la borro de la lista simplemente
        Q := Tabla[P].ListaColision.Buscar(X, CompararPor);
        If Q <> Nulo Then
        Begin
          Tabla[P].ListaColision.Eliminar(Q);
          Dec(Q_Claves);
          Dec(Q_ClavesLC);
          Eliminar := OK;
        End;
      End;
  End;
End;

// Busca la clave segun la posicion que retorna la funcion hash
// Si no esta la busca en la lista de colisiones
Function TablaHash.Buscar(X: TipoElemento; CompararPor: CampoComparar;
  Var PL: Variant): PosicionTabla;
Var
  P: PosicionTabla;
Begin
  Buscar := PosNula;
  PL := Nulo;
  P := FuncionTransformacion(X, CompararPor);
  // Posicion valida de la tabla
  If P <> PosNula Then
  Begin
    If Tabla[P].Ocupado = True Then
      If X.CompararTE(Tabla[P].Clave, CompararPor) = igual Then
        Buscar := P
      Else
      Begin
        // Busca si esta en la lista de colisiones
        If Not Tabla[P].ListaColision.EsVacia() Then
        begin
          PL := Tabla[P].ListaColision.Buscar(X, CompararPor);
          If PL <> Nulo Then
            Buscar := P;
        End;
      End;
  End;
End;

// recupera la clave completa de la tabla o lista de colisiones
Function TablaHash.Recuperar(P: PosicionTabla; PL: Variant;
  Var X: TipoElemento): Errores;
Begin
  Recuperar := CError;
  If P <> PosNula Then
  Begin
    If PL <> Nulo Then
      // Toma la clave de las listas de colisiones
      Tabla[P].ListaColision.Recuperar(X, PL)
    Else
      // La clave esta directamente en la tabla
      X := Tabla[P].Clave;
    Recuperar := OK;
  End;
End;

// retorno toda la tabla como un string para ponerlo directamente
// en memo, con su lista de colisiones tambien
Function TablaHash.RetornarAsString(): String;
Var
  X: TipoElemento;
  I: Integer;
  S: String;
  SS: String;
  Q: PosicionLista;
Begin
  SS := '';
  For I := MinTable To MaxTable Do
  Begin
    If Tabla[I].Ocupado = True Then
    Begin
      X := Tabla[I].Clave;
      S := X.ArmarString;
      SS := SS + S + cCRLF;
      If Not Tabla[I].ListaColision.EsVacia() Then
      Begin
        Q := Tabla[I].ListaColision.Comienzo;
        While Q <> Nulo Do
        Begin
          Tabla[I].ListaColision.Recuperar(X, Q);
          S := X.ArmarString;
          SS := SS + cTab + 'LC: ' + S + cCRLF;
          Q := Tabla[I].ListaColision.Siguiente(Q);
        End;
      End;
      // SS:= SS + cCR;
    End;
  End; // del for
  RetornarAsString := SS;
End;

// Salva las claves en un archivo de TXT similar al de las listas
Function TablaHash.Salvar(sFileName: String): Boolean;
Var
  X: TipoElemento;
  I: Integer;
  S: String;
  Q: PosicionLista;
  T: TextFile;
Begin
  Salvar := False;
  AssignFile(T, sFileName);
  Rewrite(T);
  // Recorro la tabla salvando las claves en el archivo
  For I := MinTable To MaxTable Do
  Begin
    If Tabla[I].Ocupado = True Then
    Begin
      X := Tabla[I].Clave;
      S := X.ArmarString;
      Writeln(T, S);
      // Si hay colisiones paso las de las colisiones
      If Not Tabla[I].ListaColision.EsVacia() Then
      Begin
        Q := Tabla[I].ListaColision.Comienzo;
        While Q <> Nulo Do
        Begin
          Tabla[I].ListaColision.Recuperar(X, Q);
          S := X.ArmarString;
          Writeln(T, S);
          Q := Tabla[I].ListaColision.Siguiente(Q);
        End;
      End;
      // SS:= SS + cCR;
    End;
  End; // del for
  CloseFile(T);
  Salvar := True;
End;

// Carga de un archivo TXT las claves a la Tabla
Function TablaHash.Cargar(sFileName: String): Boolean;
Var
  X: TipoElemento;
  T: TextFile;
  S: String;
Begin
  Cargar := False;
  AssignFile(T, sFileName);
  Reset(T);
  Crear;
  While Not Eof(T) Do
  Begin
    Readln(T, S);
    X.CargarTE(S);
    Insertar(X, CDI);
  End;
  CloseFile(T);
  Cargar := True;
End;

// LLena la tabla con claves Random
Procedure TablaHash.LLenarRandom(RangoHasta: LongInt);
Var
  X: TipoElemento;
  I: LongInt;
Begin
  Crear;
  X.Inicializar;
  Randomize;
  For I := MinTable To MaxTable Do
  Begin
    X.DI := Random(RangoHasta);
    X.DR := I;
    Insertar(X, CDI);
  End;
End;

// Propiedad que retorna la cantidad de claves de la tabla
// Incluye todas la claves
Function TablaHash.CantidadClaves(): LongInt;
Begin
  CantidadClaves := Q_Claves;
End;

// Propiedad que retorna la cantidad de posiciones de la tabla ocupadas
Function TablaHash.CantidadOcupados(): LongInt;
Begin
  CantidadOcupados := Q_Ocupados;
End;

// Propiedad que retorna la cantidad de claves de la lista de Colisiones
Function TablaHash.CantidadClavesZO(): LongInt;
Begin
  CantidadClavesZO := Q_ClavesLC;
End;

end.
