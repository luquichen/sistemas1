object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 746
  ClientWidth = 1357
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 273
    Height = 114
    Caption = 'GroupBox1'
    TabOrder = 0
    object Button1: TButton
      Left = 16
      Top = 14
      Width = 113
      Height = 25
      Caption = 'CARGAR CLIENTE'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 16
      Top = 45
      Width = 113
      Height = 25
      Caption = 'MOSTRAR'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 195
      Top = 3
      Width = 75
      Height = 25
      Caption = 'Button3'
      TabOrder = 2
    end
    object Button8: TButton
      Left = 16
      Top = 76
      Width = 169
      Height = 25
      Caption = 'CARGAR CLIENTE ARCHIVO'
      TabOrder = 3
      OnClick = Button8Click
    end
  end
  object Memo1: TMemo
    Left = 287
    Top = 8
    Width = 449
    Height = 217
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 353
    Width = 273
    Height = 105
    Caption = 'GroupBox2'
    TabOrder = 2
    object Button4: TButton
      Left = 38
      Top = 43
      Width = 75
      Height = 25
      Caption = 'TOTALES'
      TabOrder = 0
      OnClick = Button4Click
    end
    object Edit1: TEdit
      Left = 16
      Top = 16
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Edit1'
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 449
    Width = 273
    Height = 105
    Caption = 'GroupBox3'
    TabOrder = 3
    object Button5: TButton
      Left = 16
      Top = 24
      Width = 216
      Height = 25
      Caption = 'CLIENTE QUE MAS Y MENOS FACTRURO'
      TabOrder = 0
      OnClick = Button5Click
    end
  end
  object GroupBox4: TGroupBox
    Left = 742
    Top = 8
    Width = 607
    Height = 249
    Caption = 'GroupBox4'
    TabOrder = 4
    object Button6: TButton
      Left = 16
      Top = 24
      Width = 75
      Height = 25
      Caption = 'CARGAR'
      TabOrder = 0
      OnClick = Button6Click
    end
    object Memo2: TMemo
      Left = 128
      Top = 16
      Width = 441
      Height = 209
      Lines.Strings = (
        'Memo2')
      TabOrder = 1
    end
    object Button7: TButton
      Left = 16
      Top = 55
      Width = 75
      Height = 25
      Caption = 'MOSTRAR'
      TabOrder = 2
      OnClick = Button7Click
    end
  end
  object Memo3: TMemo
    Left = 287
    Top = 353
    Width = 449
    Height = 201
    TabOrder = 5
  end
  object GroupBox5: TGroupBox
    Left = 8
    Top = 128
    Width = 273
    Height = 105
    Caption = 'GroupBox5'
    TabOrder = 6
    object Button9: TButton
      Left = 16
      Top = 24
      Width = 200
      Height = 25
      Caption = 'ARMAR DICCIONARIO POR FACTURA'
      TabOrder = 0
    end
  end
end
