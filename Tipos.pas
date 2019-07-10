unit Tipos;

interface

uses
Variants, SysUtils;

const
cTab=char(9);                     //tabulador
cCR=char(13);                     //retorno de carro
cCRLF=char(13)+Char(10);          //retorno de carro y fin de linea
cLF=char(10);                     //fin de linea

type

//Enumerados

//resultado de comparacion
Comparacion=(igual, menor, mayor, distinto, error);
//campo por el que comparar o buscar
CampoComparar=(CDI,CDR,CDS,CDP,CDV,CDIDS,CDIDR);
//Errores a devolver
Errores=(OK,CError,Llena,Vacia,PosicionInvalida,Otro);

TipoElemento=object
    DI:longint;
    DR:real;
    DS:string;
    DP:pointer;
    DV:variant;

    procedure Inicializar();
    function CompararTE(X2:TipoElemento; ComparaPor:CampoComparar):Comparacion;
    function ArmarString:string;
    function CargarTE(S:string):boolean;  // carga el elemento a partir de
                                          // texto separado por TAB
end;

implementation

// inicializa elemento
  procedure TipoElemento.Inicializar;
  begin
    DI:=0;
    DR:=0;
    DS:='';
    DP:=Nil;
  end;


// compara dos elementos segun campoComparar -> retorna un enumerado
  function TipoElemento.CompararTE(X2:TipoElemento; ComparaPor:CampoComparar):Comparacion;
  begin
    try
      case ComparaPor of
        CDI: begin
             if DI=X2.DI then
                CompararTE:=igual
             else
              if DI>X2.DI then
                CompararTE:=mayor
              else
                  CompararTe:=menor;

             end;

        CDR: begin
             if DR=X2.DR then
                CompararTE:=igual
             else
              if DR>X2.DR then
                CompararTE:=mayor
              else
                  CompararTe:=menor;

             end;

        CDS: begin
             if DS=X2.DS then
              compararTE:=igual
             else
              if DS<X2.DS then  CompararTE:=menor
              else  CompararTE:=Mayor;
             end;

        CDP: begin
             if DP=X2.DP then
              CompararTE:=igual
             else
               CompararTE:=distinto;
             end;

        CDV: begin
             if DV=X2.DV then
              CompararTE:=igual
             else
               CompararTE:=distinto;
             end;

         CDIDS: begin
             if (DI=X2.DI) and (DS=X2.DS) then
                CompararTE:=igual
             else
                CompararTE:=distinto;
         end;

         CDIDR: begin
             if (DI=X2.DI) and (DR=X2.DR) then
                CompararTE:=igual
             else
                CompararTE:=distinto;
         end;
      else
      CompararTE:=error;
      end;        // de case

    except
    CompararTE:=error;
    end;

  end;

// arma string separado por tabuladores a partir de tipoElemento
  function TipoElemento.ArmarString:string;
  begin
  ArmarString:=intToStr(DI)+ cTab+ floatToStr(DR)+ cTab+ DS+ cTab+ DV;
  end;

// carga un TipoElemento a partir de un string
  function TipoElemento.CargarTE(S:string):boolean;
  var
  posTab:integer;
  flag:boolean;
  begin
    flag:=true;
    posTab:=pos(cTab,S);                  // ubico primer Tab
    if posTab=0 then                      // si no hay Tab devuelvo error
       flag:=false                        // bandera de NoError -> false
    else
    begin
        if copy(s,1,posTab-1)='' then
          DI:=0
        else
          DI:=strToInt(copy(S,1,posTab-1));     // desde string[1] hasta pos anterior a Tab
        S:=copy(s,posTab+1,length(s)-1);      // asigno en S el resto del string desp de Tab

        posTab:=pos(cTab,S);
        if posTab=0 then
          flag:=false
        else
        begin
            if copy(s,1,posTab-1)='' then
              DR:=0.0
            else
              DR:=strToFloat(copy(S,1,posTab-1));
            S:=copy(s,posTab+1,length(s)-1);

            posTab:=pos(cTab,S);
            if posTab=0 then
              flag:=false
            else
            begin
            DS:=copy(S,1,posTab-1);
            S:=copy(s,posTab+1,length(s)-1);
            if DV<>'' then
              DV:=S;          // desde el copy anterior en S queda solo V
            end;
        end;
    end;
  CargarTE:=flag;     // si True entonces se cargó el elemento
  end;




end.
