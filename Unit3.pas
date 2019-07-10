unit Unit3;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,TADDiccionario,Tipos,ListPointer;
Type
  Cliente = Record
    Cliente:Integer;
    NFactrua:Integer;
    Fecha:String[12];
    Importe:Real;
  End;
Archivo_Cliente = file of Cliente;

Var
RegCliente: Cliente;
ArchiCliente: Archivo_Cliente;


Procedure AsignarArchivo(var F: Archivo_Cliente);
Procedure CargarArchivo(var F: Archivo_Cliente);
//Procedure CargarClienteRandom ( var F: Archivo_Cliente);
Function Mostrar(VAR F: Archivo_Cliente): String;
Procedure CearDICCIONARIO(var D:dICCIONARIO; var F: Archivo_Cliente);


implementation
Procedure AsignarArchivo(var F: Archivo_Cliente);
Begin
  AssignFile(F, 'C:\Users\lucas\Desktop\Estuido Programacion\DICCIONARIO\archivo\cliente.dat');
End;

Procedure CargarArchivo(var F: Archivo_Cliente);
var
  Reg: Cliente;
  I: Integer;
Begin
  Reset(F);
  for I := 1 to 5 do
  Begin
    Reg.Cliente := strToInt(InputBox('Cargar', 'NUM Cliente:', ''));
    Reg.NFactrua := strToInt( InputBox('Cargar', 'Num Factura:', ''));
    Reg.Fecha := InputBox('Cargar', 'Fecha:', '');
    Reg.Importe := strtofloat(InputBox('Cargar', 'Importe:', ''));
    write(F, Reg);
  End;
  Close(F);
End;


Function Mostrar(VAR F: Archivo_Cliente): String;
var
  Reg: Cliente;
  S: String;
Begin
  Reset(F);
  while Not(Eof(F)) do
  Begin
    Read(F, Reg);
    S := S + IntToStr(Reg.Cliente) + CTAB + IntToStr(Reg.NFactrua) + CTAB +
      Reg.Fecha + CTAB + floattostr(Reg.Importe) + CCRLF;
  End;
  Close(F);
  Mostrar := S;
End;

Procedure CearDICCIONARIO(var D:dICCIONARIO; var F: Archivo_Cliente);
var
  Reg: Cliente;
  x,x2: tipoElemento;
  I: Integer;
  P:Posiciondic;
BEGIN
Reset(f);
d.Crear;
x.Inicializar;
x2.Inicializar;
 while not eof(f) do
 Begin
   read(f,reg);
   x.di:=reg.Cliente;
   P:=d.InsertarClave(x,cdi);
   x2.di:=reg.NFactrua;
   x2.ds:=reg.Fecha;
   x2.DR:=reg.Importe;
   d.InsertarValorPosClave(p,x2,cdi);
 End;

 close(f);
end;

end.
