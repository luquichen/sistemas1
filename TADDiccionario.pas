unit TADDiccionario;

interface

Uses
  Tipos, ListPointer;

Const
  Nulo = NIL;

Type
  PosicionDic = PosicionLista;
  Valores = Lista;
  Clave = TipoElemento;
  Valor = TipoElemento;

  Diccionario = Object
  Private
    Claves: Lista;
  Public
    Procedure Crear();
    Function EsVacio(): Boolean;
    Function EsLleno(): Boolean;
    Function InsertarClave(C: Clave; CCC: CampoComparar): PosicionDic;
    Function InsertarValor(C: Clave; CCC: CampoComparar; V: Valor;
      CCV: CampoComparar): Errores;
    Function InsertarValorPosClave(PC: PosicionDic; V: Valor;
      CCV: CampoComparar): Errores;
    Function EliminarClave(C: Clave; CCC: CampoComparar): Errores;
    Function EliminarValor(C: Clave; CCC: CampoComparar; V: Valor;
      CCV: CampoComparar): Errores;
    Function BuscarClave(C: Clave; CCC: CampoComparar): PosicionDic;
    Function BuscarValor(PC: PosicionDic; V: Valor; CCV: CampoComparar)
      : PosicionDic;
    Function RetornarValores(C: Clave; CCC: CampoComparar): Valores;

    Function RetornarClave(PC: PosicionDic): Clave;
    Function RetornarClavePosLogica(PosLogica: LongInt): Clave;

    Function RetornarValor(PC: PosicionDic; PV: PosicionDic): Valor;
    Function RetornarDic(): String;
    Function CantidadClaves(): LongInt;
    Function CantidadValores(C: Clave; CCC: CampoComparar): LongInt;
  End;

implementation

Procedure Diccionario.Crear();
Begin
  Claves.Crear;
End;

Function Diccionario.EsVacio(): Boolean;
Begin
  EsVacio := Claves.EsVacia;
End;

Function Diccionario.EsLleno(): Boolean;
Begin
  EsLleno := Claves.EsLLena;
End;

// Inserta la clave en orden dentro del dominio del diccionario
Function Diccionario.InsertarClave(C: Clave; CCC: CampoComparar): PosicionDic;
Var
  Q: PosicionDic;
  Encontre: Boolean;
  X: TipoElemento;
Begin
  If EsLleno = True Then
    InsertarClave := Nulo
  Else
  Begin
    // Busco si la clave no se encuentra Todavía
    Q := Claves.Buscar(C, CCC);
    If Q <> Nulo Then
      InsertarClave := Q
    Else
    Begin
      // Busca el lugar donde insertar
      Q := Claves.Comienzo;
      Encontre := False;
      While (Q <> Nulo) And Not(Encontre) Do
      Begin
        Claves.Recuperar(X, Q);
        If C.CompararTE(X, CCC) = mayor Then
          Q := Claves.Siguiente(Q)
        Else
          Encontre := True;
      End;
      // Averiguo si lo encontro al lugar de insertar o es nulo
      If Q = Nulo Then
      Begin
        Claves.Agregar(C);
        InsertarClave := Claves.Fin;
      End
      Else
      Begin
        Claves.Insertar(C, Q);
        InsertarClave := Claves.Anterior(Q);
      End;
    End;
  End;
End;

// Inserta un Valor para una clave dada
Function Diccionario.InsertarValor(C: Clave; CCC: CampoComparar; V: Valor;
  CCV: CampoComparar): Errores;
Var
  QC, QV: PosicionDic;
  X: TipoElemento;
  PV: ^Valores;
Begin
  // Busca si la clave existe
  QC := Claves.Buscar(C, CCC);
  If QC = Nulo Then
    InsertarValor := CError
  Else
  Begin
    // Recupera la clave para tomar la lista de valores
    Claves.Recuperar(X, QC);
    PV := X.DP;
    // SI NO hay valores para la clave debo inicializar y poner el primer valor
    If PV = Nulo Then
    Begin
      New(PV);
      PV^.Crear;
      PV^.Agregar(V);
      X.DP := PV;
      Claves.Actualizar(X, QC);
      InsertarValor := OK;
    End
    Else
    Begin
      // Si ya tiene valores busco que el valor Ya no exista
      QV := PV^.Buscar(V, CCV);
      If QV <> Nulo Then
        InsertarValor := CError
      Else
      Begin
        PV^.Agregar(V);
        InsertarValor := OK;
      End;
    End;
  End;
End;

// Inserta un VALOR en función a la Posición de la Clave directamente
Function Diccionario.InsertarValorPosClave(PC: PosicionDic; V: Valor;
  CCV: CampoComparar): Errores;
Var
  QV: PosicionDic;
  X: TipoElemento;
  PV: ^Valores;
Begin
  // Busca si la clave existe
  If Claves.ValidarPosicion(PC) = False Then
    InsertarValorPosClave := CError
  Else
  Begin
    // Recupera la clave para tomar la lista de valores
    Claves.Recuperar(X, PC);
    PV := X.DP;
    // SI NO hay valores para la clave debo inicializar y poner el primer valor
    If PV = Nulo Then
    Begin
      New(PV);
      PV^.Crear;
      PV^.Agregar(V);
      X.DP := PV;
      Claves.Actualizar(X, PC);
      InsertarValorPosClave := OK;
    End
    Else
    Begin
      // Si ya tiene valores busco que el valor Ya no exista
      QV := PV^.Buscar(V, CCV);
      If QV <> Nulo Then
        InsertarValorPosClave := CError
      Else
      Begin
        PV^.Agregar(V);
        InsertarValorPosClave := OK;
      End;
    End;
  End;
End;

// Elimina una clave junto a todos sus valores
Function Diccionario.EliminarClave(C: Clave; CCC: CampoComparar): Errores;
Var
  QC: PosicionDic;
  PV: ^Valores;
  X: TipoElemento;
Begin
  If EsVacio Then
    EliminarClave := CError
  Else
  Begin
    QC := Claves.Buscar(C, CCC);
    If QC = Nulo Then
      EliminarClave := CError
    Else
    Begin
      // La clave existe entonces se fija si tiene valores
      Claves.Recuperar(X, QC);
      PV := X.DP;
      // Si tiene valores mando a eliminar todos los valores
      If PV <> Nulo Then
      Begin
        While Not PV^.EsVacia Do
        Begin
          PV^.Eliminar(PV^.Comienzo);
        End;
      End;
      // Ahora elimino la clave
      Claves.Eliminar(QC);
      EliminarClave := OK;
    End;
  End;
End;

// Elimina un solo valor de una clave dada
Function Diccionario.EliminarValor(C: Clave; CCC: CampoComparar; V: Valor;
  CCV: CampoComparar): Errores;
Var
  QC, QV: PosicionDic;
  PV: ^Valores;
  X: TipoElemento;
Begin
  If EsVacio Then
    EliminarValor := CError
  Else
  Begin
    QC := Claves.Buscar(C, CCC);
    If QC = Nulo Then
      EliminarValor := CError
    Else
    Begin
      // La clave existe entonces se fija si tiene valores
      Claves.Recuperar(X, QC);
      PV := X.DP;
      // Busca si el Valor existe para borrarlo
      If PV = Nulo Then
        EliminarValor := CError
      Else
      Begin
        QV := PV^.Buscar(V, CCV);
        If QV = Nulo Then
          EliminarValor := CError
        Else
          PV^.Eliminar(QV);
        EliminarValor := OK;
      End;
    End;
  End;
End;

// Busca una Clave en el Dominio
Function Diccionario.BuscarClave(C: Clave; CCC: CampoComparar): PosicionDic;
Var
  QC: PosicionDic;
Begin
  BuscarClave := Claves.Buscar(C, CCC);
End;

// Busca un valor de una clave dentro de la imagen
Function Diccionario.BuscarValor(PC: PosicionDic; V: Valor; CCV: CampoComparar)
  : PosicionDic;
Var
  PV: ^Valores;
  X: TipoElemento;
Begin
  BuscarValor := Nulo;
  If Claves.ValidarPosicion(PC) = True Then
  Begin
    Claves.Recuperar(X, PC);
    PV := X.DP;
    If PV <> Nulo Then
      BuscarValor := PV^.Buscar(V, CCV);
  End
End;

// Retorno todos los valores de una Clave
Function Diccionario.RetornarValores(C: Clave; CCC: CampoComparar): Valores;
Var
  QC: PosicionDic;
  X: TipoElemento;
  V: Valores;
  PV: ^Valores;
Begin
  V.Crear;
  QC := Claves.Buscar(C, CCC);
  // Si existe la clave veo si tiene valores
  If QC <> Nulo Then
  Begin
    Claves.Recuperar(X, QC);
    PV := X.DP;
    If PV <> Nulo Then
    Begin
      QC := PV^.Comienzo;
      While QC <> Nulo Do
      Begin
        PV^.Recuperar(X, QC);
        V.Agregar(X);
        QC := PV^.Siguiente(QC);
      End;
    End;
  End;
  // Retorno los valores
  RetornarValores := V;
End;

// Retorno una clave del diccionario
Function Diccionario.RetornarClave(PC: PosicionDic): Clave;
Var
  X: TipoElemento;
Begin
  X.Inicializar;
  // Valido la posición recibida
  If Claves.ValidarPosicion(PC) Then
    Claves.Recuperar(X, PC);
  RetornarClave := X;
End;

// Retorna una Clave en función a su posición lógica
Function Diccionario.RetornarClavePosLogica(PosLogica: LongInt): Clave;
Var
  X: TipoElemento;
  P: PosicionDic;
Begin
  X.Inicializar;
  // Llamo al Ordinal para retornar la posición física
  P := Claves.Ordinal(PosLogica);
  If P <> Nulo Then
    Claves.Recuperar(X, P);
  RetornarClavePosLogica := X;
End;

// Retorna un Valor para una clave dada
Function Diccionario.RetornarValor(PC: PosicionDic; PV: PosicionDic): Valor;
Var
  QC: PosicionDic;
  X, V: TipoElemento;
  PI: ^Valores;
Begin
  V.Inicializar;
  // Si existe la clave veo si tiene valores
  If Claves.ValidarPosicion(PC) Then
  Begin
    Claves.Recuperar(X, PC);
    PI := X.DP;
    If PI <> Nulo Then
    Begin
      If PI^.ValidarPosicion(PV) Then
        PI^.Recuperar(V, PV);
    End;
  End;
  RetornarValor := V;
End;

// Retorno todo el diccionario como un String
Function Diccionario.RetornarDic(): String;
Var
  QC, QV: PosicionDic;
  PV: ^Valores;
  S, SS: String;
  XC, XV: TipoElemento;
Begin
  SS := '';
  QC := Claves.Comienzo;
  // Recorro la lista de dominio
  While QC <> Nulo Do
  Begin
    Claves.Recuperar(XC, QC);
    S := XC.ArmarString;
    SS := SS + S + cCRLF;
    // Agrego los valores de cada clave
    PV := XC.DP;
    If PV <> Nulo Then
    Begin
      QV := PV^.Comienzo;
      While QV <> Nulo Do
      Begin
        PV^.Recuperar(XV, QV);
        S := XV.ArmarString;
        SS := SS + ' --------> ' + S + cCRLF;
        QV := PV^.Siguiente(QV);
      End;
    End;
    QC := Claves.Siguiente(QC);
    SS := SS + cCRLF;
  End;
  RetornarDic := SS;
End;

// Cantidad de claves del diccionario
Function Diccionario.CantidadClaves(): LongInt;
Begin
  CantidadClaves := Claves.CantidadElementos;
End;

// retorno la cantidad de valores para una clave
// o CERO si no esta la clave o si no hay valores
Function Diccionario.CantidadValores(C: Clave; CCC: CampoComparar): LongInt;
Var
  P: PosicionDic;
  V: Valores;
Begin
  CantidadValores := 0;
  P := BuscarClave(C, CCC);
  If P <> Nulo Then
  Begin
    V := RetornarValores(C, CCC);
    CantidadValores := V.CantidadElementos;
  End;
End;

end.
