unit Unit2;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,TADDiccionario,Tipos,ListPointer,Unit3;

VAR
D,DXFACTURA:DICCIONARIO;
x:TipoElemento;

Function TotalFacturado(d:diccionario; NCliente:Integer; var Me,Ma:Real):real;
Procedure ClienteMasYMenos(d:diccionario;var NumMax,NumMin:Longint);
Function  BuscarMayor(L:Lista;var xMayor:TipoElemento):Boolean;
Function  BuscarMenor(L:Lista;var xMenor:TipoElemento):Boolean;
Procedure armarxfactrua(var d,dn:diccionario);
implementation
Function TotalFacturado(d:diccionario; NCliente:Integer;var Me,Ma:Real):real;
var
x,x2:tipoElemento;
p:PosicionDic;
l:lista;
Q:PosicionLista;
acum:real;
can:Longint;
Begin
  x.Inicializar;
  x.di:=NCLiente;
  x2.Inicializar;
  //d.BuscarClave(x,cdi);

  //can:=d.CantidadValores(x,cdi);

  L:= d.RetornarValores(x,cdi);
  q:=l.comienzo;

  acum:=0;
  l.Recuperar(x2,q);
  ma:=x2.DR;
  me:=x2.DR;
  while Q<>NULO do
  Begin
      l.Recuperar(x2,q);

      if (x2.DR> ma) then
        ma:=x2.DR;
      if (x2.dr< Me) then
        me:=x2.Dr;

      acum:=acum + x2.DR;
      q:=L.Siguiente(q);
  End;

TotalFacturado:=Acum;
End;

Procedure ClienteMasYMenos(d:diccionario;var NumMax,NumMin:Longint);
var
i,j:Longint;
xClave,xValor,xMayor,xMenor:TipoElemento;
ListAux:Lista;
NumCLiente,NumCLienteM:Integer;
Begin
xClave.Inicializar;
xMayor.Inicializar;
NumCliente:=0;
xMenor.Inicializar;
NumCLienteM:=1;

xClave:= d.RetornarClavePosLogica(1);
ListAux:=d.RetornarValores(xClave,cdi);
ListAux.Recuperar(xMayor,listaux.Comienzo);
xMenor:=xMayor;

  For I := 1 to (d.CantidadClaves) do
  Begin

       xClave:= d.RetornarClavePosLogica(I);
       ListAux:=d.RetornarValores(xClave,cdi);

        if BuscarMayor(listAux,xMayor) then
         Begin
            NumCliente:=i;
         End;
        if BuscarMenor(listAux,xMenor) then
         Begin
            NumClienteM:=i;
         End;


  End;
NumMax:=NumCliente;
NumMin:=NumClienteM;
End;


Function  BuscarMayor(L:Lista;var xMayor:TipoElemento):Boolean;
var
P:posicionLista;
xaux:tipoelemento;
Begin
p:=l.Comienzo;
BuscarMayor:=False;
  while p<>Nulo do
  Begin
      l.Recuperar(x,p);
      if (x.Dr> xMayor.DR) then
      BEGIN
        xMayor:=X;
        BuscarMayor:=True;
      END;
      p:=l.Siguiente(P);
  End;
  //Showmessage(floattostr(xMayor.DR));
End;
Function  BuscarMenor(L:Lista;var xMenor:TipoElemento):Boolean;
var
P:posicionLista;
Begin
p:=l.Comienzo;
BuscarMenor:=False;
  while p<>Nulo do
  Begin
      l.Recuperar(x,p);
      if (x.Dr<  xmenor.DR) then
      BEGIN
        xMenor:=X;
        BuscarMenor:=True;
      END;
      p:=l.Siguiente(P);
  End;

End;
Procedure armarxfactrua(var d,dn:diccionario);
var
i:integer;
xnuevo,x,xClave:TipoElemento;
ListAux:lista;
p:posicionLista;
q:Posiciondic;
Begin
dn.Crear;
x.Inicializar;
  For i := 1 to d.CantidadClaves do
  Begin
    xClave:= d.RetornarClavePosLogica(I);
    ListAux:=d.RetornarValores(xClave,cdi);
    p:=listaux.Comienzo;
      while p<>nulo do
      Begin
          ListAux.Recuperar(x,p);
          q:= dn.InsertarClave(x,cdi);
          dn.InsertarValor(x,cdi,xnuevo,cdi);

      End;

  End;
End;














end.
