{$I ACBr.inc}

unit ACBreSocialWebServices;

interface

uses
  Classes, SysUtils,
  ACBrDFe, ACBrDFeWebService,
  pcnNFe,//pcneSocial?
  pcnRetConsReciNFe, pcnRetConsCad, pcnAuxiliar, pcnConversao, eSocial_Conversao,
  pcnProcNFe, pcnRetCancNFe, pcnEnvEventoNFe, pcnRetEnvEventoNFe,
  pcnRetConsSitNFe, pcnConsNFeDest, pcnRetConsNFeDest, pcnDownloadNFe,
  pcnRetDownloadNFe, pcnAdmCSCNFCe, pcnRetAdmCSCNFCe, pcnDistDFeInt,
  pcnRetDistDFeInt, pcnRetEnvNFe,
  ACBreSocialEventos, ACBreSocialConfiguracoes;

type

  { TeSocialWebService }

  TeSocialWebService = class(TDFeWebService)
  private
  protected
    FPStatus: TStatusACBreSocial//Fazer um enumerador
    FPLayout: TLayOut;
    FPConfiguracoeseSocial: TConfiguracoeseSocial;

    procedure ConfigurarSoapDEPC;
    function ExtrairModeloChaveAcesso(AChaveNFE: String): String;

  protected
    procedure InicializarServico; override;
    procedure DefinirURL; override;
    function GerarVersaoDadosSoap: String; override;
    procedure FinalizarServico; override;

  public
    constructor Create(AOwner: TACBrDFe); override;

    property Status: TStatusACBreSocial read FPStatus;//?
    property Layout: TLayOut read FPLayout;
  end;

  { TNFeRecibo }//Checar como ser� o recibo, para caso necess�rio usar esta classe...

  TNFeRecibo = class(TNFeWebService)
  private
    FRecibo: String;
    Fversao: String;
    FTpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: integer;
    FxMotivo: String;
    FcUF: integer;
    FxMsg: String;
    FcMsg: integer;

    FNFeRetorno: TRetConsReciNFe;
  protected
    procedure DefinirServicoEAction; override;
    procedure DefinirURL; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
  public
    constructor Create(AOwner: TACBrDFe); override;
    destructor Destroy; override;

    property versao: String read Fversao;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: integer read FcStat;
    property xMotivo: String read FxMotivo;
    property cUF: integer read FcUF;
    property xMsg: String read FxMsg;
    property cMsg: integer read FcMsg;
    property Recibo: String read FRecibo write FRecibo;

    property NFeRetorno: TRetConsReciNFe read FNFeRetorno;
  end;

  { TeSocialConsulta }

  TeSocialConsulta = class(TeSocialWebService)
  private
    FeSocialChave: String;//campo id de 36 posi��es
    FProtocolo: String;
    FDhRecbto: TDateTime;
    FXMotivo: String;
    Fversao: String;
    FTpAmb: TpcnTipoAmbiente;
    FverAplic: String;
    FcStat: integer;
    FcUF: integer;
    FReteSocialDFe: String;

    FprotNFe: TProcNFe;//checar equivalente no esocial
    FprocEventoeSocial: TRetEventoeSocialCollection; // cole��o de resposta do processamento de eventos...
  protected
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe); override;
    destructor Destroy; override;

    property eSocialChave: String read FeSocialChave write FeSocialChave;
    property Protocolo: String read FProtocolo write FProtocolo;
    property DhRecbto: TDateTime read FDhRecbto write FDhRecbto;
    property XMotivo: String read FXMotivo write FXMotivo;
    property versao: String read Fversao;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;
    property verAplic: String read FverAplic;
    property cStat: integer read FcStat;
    property cUF: integer read FcUF;
    property ReteSocialDFe: String read FReteSocialDFe;

    property protNFe: TProcNFe read FprotNFe;
    property procEventoeSocial: TRetEventoeSocialCollection read FprocEventoNFe;
  end;

  { TeSocialEnvEvento }// usar para o WS EnviarLoteEventos

  TeSocialEnvEvento = class(TeSocialWebService)
  private
    FidLote: integer;
    Fversao: String;
    FEvento: TEventoNFe;
    FcStat: integer;
    FxMotivo: String;
    FTpAmb: TpcnTipoAmbiente;

    FEventoRetorno: TRetEventoNFe;

    function GerarPathEvento: String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    procedure SalvarEnvio; override;
    function TratarResposta: Boolean; override;
    procedure SalvarResposta; override;

    function GerarMsgLog: String; override;
    function GerarPrefixoArquivo: String; override;
  public
    constructor Create(AOwner: TACBrDFe; AEvento: TEventoNFe); reintroduce; overload;
    destructor Destroy; override;

    property idLote: integer read FidLote write FidLote;
    property versao: String read Fversao write Fversao;
    property cStat: integer read FcStat;
    property xMotivo: String read FxMotivo;
    property TpAmb: TpcnTipoAmbiente read FTpAmb;

    property EventoRetorno: TRetEventoNFe read FEventoRetorno;
  end;

  { TeSocialEnvioWebService }

  TeSocialEnvioWebService = class(TeSocialWebService)
  private
    FXMLEnvio: String;
    FPURLEnvio: String;
    FVersao: String;
    FSoapActionEnvio: String;
  protected
    procedure DefinirURL; override;
    procedure DefinirServicoEAction; override;
    procedure DefinirDadosMsg; override;
    function TratarResposta: Boolean; override;

    function GerarMsgErro(E: Exception): String; override;
    function GerarVersaoDadosSoap: String; override;
  public
    constructor Create(AOwner: TACBrDFe); override;
    destructor Destroy; override;
    function Executar: Boolean; override;

    property XMLEnvio: String read FXMLEnvio write FXMLEnvio;
    property URLEnvio: String read FPURLEnvio write FPURLEnvio;
    property SoapActionEnvio: String read FSoapActionEnvio write FSoapActionEnvio;
  end;

  { TWebServices }

  TWebServices = class
  private
    FACBreSocial: TACBrDFe;
    FStatusServico: TNFeStatusServico;
    FEnviar: TNFeRecepcao;
    FRetorno: TNFeRetRecepcao;
    FRecibo: TNFeRecibo;
    FConsulta: TNFeConsulta;
    FEnvEvento: TNFeEnvEvento;
    FEnvioWebService: TNFeEnvioWebService;
  public
    constructor Create(AOwner: TACBrDFe); overload;
    destructor Destroy; override;

    function Envia(ALote: integer; const ASincrono: Boolean = False): Boolean;
      overload;
    function Envia(ALote: String; const ASincrono: Boolean = False): Boolean;
      overload;
    procedure Inutiliza(CNPJ, AJustificativa: String;
      Ano, Modelo, Serie, NumeroInicial, NumeroFinal: integer);

    property ACBreSocial: TACBrDFe read FACBreSocial write FACBreSocial;
    property StatusServico: TNFeStatusServico read FStatusServico write FStatusServico;
    property Enviar: TNFeRecepcao read FEnviar write FEnviar;
    property Retorno: TNFeRetRecepcao read FRetorno write FRetorno;
    property Recibo: TNFeRecibo read FRecibo write FRecibo;
    property Consulta: TNFeConsulta read FConsulta write FConsulta;
    property EnvEvento: TNFeEnvEvento read FEnvEvento write FEnvEvento;
    property EnvioWebService: TNFeEnvioWebService read FEnvioWebService write FEnvioWebService;
  end;

implementation

uses
  StrUtils, Math,
  ACBrUtil, ACBreSocial,
  pcnGerador, pcnConsStatServ, pcnRetConsStatServ,
  pcnConsSitNFe, pcnInutNFe, pcnRetInutNFe, pcnConsReciNFe,
  pcnConsCad, pcnLeitor;

{ TeSocialWebService }

constructor TeSocialWebService.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FPConfiguracoeseSocial := TConfiguracoeseSocail(FPConfiguracoes);
  FPLayout := LayNfeStatusServico;//checar o layout
  FPStatus := stIdle;
end;

procedure TeSocialWebService.ConfigurarSoapDEPC;
begin
  FPSoapVersion := 'soap';
  FPHeaderElement := 'sceCabecMsg';
  FPSoapEnvelopeAtributtes :=
    'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
    'xmlns:xsd="http://www.w3.org/2001/XMLSchema"' +
    'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/';
  FPBodyElement := 'sceDadosMsg';
end;

function TeSocialWebService.ExtrairModeloChaveAcesso(AChaveeSocial: String): String;
begin
  AChaveNFE := OnlyNumber(AChaveeSocial);
  if ValidarChave(AChaveeSocial) then
    Result := copy(AChaveeSocial, 21, 2)// checar esses valores no copy
  else
    Result := '';
end;

procedure TeSocialWebService.DefinirURL;
var
  Versao: Double;
begin
  { sobrescrever apenas se necess�rio.
    Voc� tamb�m pode mudar apenas o valor de "FLayoutServico" na classe
    filha e chamar: Inherited;     }

  Versao := 0;
  FPVersaoServico := '';
  FPURL := '';

  TACBreSocail(FPDFeOwner).LerServicoDeParams(FPLayout, Versao, FPURL);
  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;


function TeSocialWebService.GerarVersaoDadosSoap: String;
begin
  { Sobrescrever apenas se necess�rio }

  if EstaVazio(FPVersaoServico) then
    FPVersaoServico := TACBreSocial(FPDFeOwner).LerVersaoDeParams(FPLayout);

  Result := '<versaoDados>' + FPVersaoServico + '</versaoDados>';
end;

procedure TeSocialWebService.FinalizarServico;
begin
  { Sobrescrever apenas se necess�rio }

  TACBreSocial(FPDFeOwner).SetStatus(stIdle);
end;

{ TNFeStatusServico }

constructor TNFeStatusServico.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FPStatus := stNFeStatusServico;
  FPLayout := LayNfeStatusServico;
  FPArqEnv := 'ped-sta';
  FPArqResp := 'sta';
end;

procedure TNFeStatusServico.DefinirServicoEAction;
begin
  if (FPConfiguracoesNFe.Geral.ModeloDF = moNFe) and
     (FPConfiguracoesNFe.Geral.VersaoDF = ve310) and
     (FPConfiguracoesNFe.WebServices.UFCodigo = 29) then
  begin
    FPServico := GetUrlWsd + 'NfeStatusServico';
    FPSoapAction := FPServico + '/NfeStatusServicoNF';
  end
  else
  begin
    FPServico := GetUrlWsd + 'NfeStatusServico2';
    FPSoapAction := FPServico;
  end;
end;

procedure TNFeStatusServico.DefinirDadosMsg;
var
  ConsStatServ: TConsStatServ;
begin
  ConsStatServ := TConsStatServ.Create;
  try
    ConsStatServ.TpAmb := FPConfiguracoesNFe.WebServices.Ambiente;
    ConsStatServ.CUF := FPConfiguracoesNFe.WebServices.UFCodigo;

    ConsStatServ.Versao := FPVersaoServico;
    ConsStatServ.GerarXML;

    // Atribuindo o XML para propriedade interna //
    FPDadosMsg := ConsStatServ.Gerador.ArquivoFormatoXML;
  finally
    ConsStatServ.Free;
  end;
end;

function TNFeStatusServico.TratarResposta: Boolean;
var
  NFeRetorno: TRetConsStatServ;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'nfeStatusServicoNF2Result');
  if FPRetWS = '' then
    FPRetWS := SeparaDados(FPRetornoWS, 'NfeStatusServicoNFResult');

  NFeRetorno := TRetConsStatServ.Create;
  try
    NFeRetorno.Leitor.Arquivo := FPRetWS;
    NFeRetorno.LerXml;

    Fversao := NFeRetorno.versao;
    FtpAmb := NFeRetorno.tpAmb;
    FverAplic := NFeRetorno.verAplic;
    FcStat := NFeRetorno.cStat;
    FxMotivo := NFeRetorno.xMotivo;
    FcUF := NFeRetorno.cUF;
    FdhRecbto := NFeRetorno.dhRecbto;
    FTMed := NFeRetorno.TMed;
    FdhRetorno := NFeRetorno.dhRetorno;
    FxObs := NFeRetorno.xObs;
    FPMsg := FxMotivo + LineBreak + FxObs;

    if FPConfiguracoesNFe.WebServices.AjustaAguardaConsultaRet then
      FPConfiguracoesNFe.WebServices.AguardarConsultaRet := FTMed * 1000;

    Result := (FcStat = 107);

  finally
    NFeRetorno.Free;
  end;
end;

function TNFeStatusServico.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s' + LineBreak +
                           'Status Descri��o: %s' + LineBreak +
                           'UF: %s' + LineBreak +
                           'Recebimento: %s' + LineBreak +
                           'Tempo M�dio: %s' + LineBreak +
                           'Retorno: %s' + LineBreak +
                           'Observa��o: %s' + LineBreak),
                   [Fversao, TpAmbToStr(FtpAmb), FverAplic, IntToStr(FcStat),
                    FxMotivo, CodigoParaUF(FcUF),
                    IfThen(FdhRecbto = 0, '', FormatDateTimeBr(FdhRecbto)),
                    IntToStr(FTMed),
                    IfThen(FdhRetorno = 0, '', FormatDateTimeBr(FdhRetorno)),
                    FxObs]);
  {*)}
end;

function TNFeStatusServico.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService Consulta Status servi�o:' + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

{ TNFeRecepcao }

constructor TNFeRecepcao.Create(AOwner: TACBrDFe; ANotasFiscais: TNotasFiscais);
begin
  inherited Create(AOwner);

  FNotasFiscais := ANotasFiscais;
  FSincrono := False;

  FPStatus := stNFeRecepcao;
  FPLayout := LayNfeRecepcao;
  FPArqEnv := 'env-lot';
  FPArqResp := 'rec';

  FNFeRetornoSincrono := nil;
  FNFeRetorno := nil;
end;

destructor TNFeRecepcao.Destroy;
begin
  if Assigned(FNFeRetornoSincrono) then
    FNFeRetornoSincrono.Free;

  if Assigned(FNFeRetorno) then
    FNFeRetorno.Free;

  inherited Destroy;
end;

function TNFeRecepcao.GetLote: String;
begin
  Result := Trim(FLote);
end;

function TNFeRecepcao.GetRecibo: String;
begin
  Result := Trim(FRecibo);
end;

procedure TNFeRecepcao.DefinirURL;
begin
  if TACBrNFe(FPDFeOwner).EhAutorizacao then
    FPLayout := LayNfeAutorizacao
  else
    FPLayout := LayNfeRecepcao;

  inherited DefinirURL;
end;

procedure TNFeRecepcao.DefinirServicoEAction;
begin
  if FPLayout = LayNfeAutorizacao then
    FPServico := GetUrlWsd + 'NfeAutorizacao'
  else
    FPServico := GetUrlWsd + 'NfeRecepcao2';

  FPSoapAction := FPServico;
end;

procedure TNFeRecepcao.DefinirDadosMsg;
var
  I: integer;
  vNotas: String;
  indSinc: String;
begin
  if (FPLayout = LayNfeAutorizacao) or (FPConfiguracoesNFe.Geral.ModeloDF = moNFCe) or
    (FPConfiguracoesNFe.Geral.VersaoDF = ve310) then
    indSinc := '<indSinc>' + IfThen(FSincrono, '1', '0') + '</indSinc>'
  else
    indSinc := '';

  vNotas := '';
  for I := 0 to FNotasFiscais.Count - 1 do
    vNotas := vNotas + '<NFe' + RetornarConteudoEntre(
      FNotasFiscais.Items[I].XMLAssinado, '<NFe', '</NFe>') + '</NFe>';

  FPDadosMsg := '<enviNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' +
    FPVersaoServico + '">' + '<idLote>' + FLote + '</idLote>' + indSinc +
    vNotas + '</enviNFe>';

  // Lote tem mais de 500kb ? //
  if Length(FPDadosMsg) > (500 * 1024) then
    GerarException(ACBrStr('Tamanho do XML de Dados superior a 500 Kbytes. Tamanho atual: ' +
      IntToStr(trunc(Length(FPDadosMsg) / 1024)) + ' Kbytes'));

  FRecibo := '';
end;

function TNFeRecepcao.TratarResposta: Boolean;
var
  I: integer;
  chNFe, NomeArquivo: String;
  AProcNFe: TProcNFe;
  SalvarXML: Boolean;
begin
  if FPLayout = LayNfeAutorizacao then
  begin
    FPRetWS := SeparaDados(FPRetornoWS, 'nfeAutorizacaoLoteResult');
    if FPRetWS = '' then
      FPRetWS := SeparaDados(FPRetornoWS, 'nfeAutorizacaoResult');
  end
  else
    FPRetWS := SeparaDados(FPRetornoWS, 'nfeRecepcaoLote2Result');

  if ((FPConfiguracoesNFe.Geral.ModeloDF = moNFCe) or
    (FPConfiguracoesNFe.Geral.VersaoDF = ve310)) and FSincrono then
  begin
    FNFeRetornoSincrono := TRetConsSitNFe.Create;

    if pos('retEnviNFe', FPRetWS) > 0 then
      FNFeRetornoSincrono.Leitor.Arquivo :=
        StringReplace(FPRetWS, 'retEnviNFe', 'retConsSitNFe',
        [rfReplaceAll, rfIgnoreCase])
    else if pos('retConsReciNFe', FPRetWS) > 0 then
      FNFeRetornoSincrono.Leitor.Arquivo :=
        StringReplace(FPRetWS, 'retConsReciNFe', 'retConsSitNFe',
        [rfReplaceAll, rfIgnoreCase])
    else
      FNFeRetornoSincrono.Leitor.Arquivo := FPRetWS;

    FNFeRetornoSincrono.LerXml;

    Fversao := FNFeRetornoSincrono.versao;
    FTpAmb := FNFeRetornoSincrono.TpAmb;
    FverAplic := FNFeRetornoSincrono.verAplic;

    // Consta no Retorno da NFC-e
    FRecibo := FNFeRetornoSincrono.nRec;
    FcUF := FNFeRetornoSincrono.cUF;
    chNFe := FNFeRetornoSincrono.ProtNFe.chNFe;

    if (FNFeRetornoSincrono.protNFe.cStat > 0) then
      FcStat := FNFeRetornoSincrono.protNFe.cStat
    else
      FcStat := FNFeRetornoSincrono.cStat;

    if (FNFeRetornoSincrono.protNFe.xMotivo <> '') then
    begin
      FPMsg := FNFeRetornoSincrono.protNFe.xMotivo;
      FxMotivo := FNFeRetornoSincrono.protNFe.xMotivo;
    end
    else
    begin
      FPMsg := FNFeRetornoSincrono.xMotivo;
      FxMotivo := FNFeRetornoSincrono.xMotivo;
    end;

    // Verificar se a NF-e foi autorizada com sucesso
    Result := (FNFeRetornoSincrono.cStat = 104) and
      (TACBrNFe(FPDFeOwner).CstatProcessado(FNFeRetornoSincrono.protNFe.cStat));

    NomeArquivo := PathWithDelim(FPConfiguracoesNFe.Arquivos.PathSalvar) + chNFe;

    if Result then
    begin
      for I := 0 to TACBrNFe(FPDFeOwner).NotasFiscais.Count - 1 do
      begin
        if OnlyNumber(chNFe) = TACBrNFe(FPDFeOwner).NotasFiscais.Items[I].NumID then
        begin
          if (TACBrNFe(FPDFeOwner).Configuracoes.Geral.ValidarDigest) and
            (TACBrNFe(FPDFeOwner).NotasFiscais.Items[I].NFe.signature.DigestValue <>
            FNFeRetornoSincrono.protNFe.digVal) and
            (FNFeRetornoSincrono.protNFe.digVal <> '') then
          begin
            raise EACBrNFeException.Create('DigestValue do documento ' +
              TACBrNFe(FPDFeOwner).NotasFiscais.Items[I].NumID + ' n�o confere.');
          end;
          with TACBrNFe(FPDFeOwner).NotasFiscais.Items[I] do
          begin
            NFe.procNFe.cStat := FNFeRetornoSincrono.protNFe.cStat;
            NFe.procNFe.tpAmb := FNFeRetornoSincrono.tpAmb;
            NFe.procNFe.verAplic := FNFeRetornoSincrono.verAplic;
            NFe.procNFe.chNFe := FNFeRetornoSincrono.ProtNFe.chNFe;
            NFe.procNFe.dhRecbto := FNFeRetornoSincrono.protNFe.dhRecbto;
            NFe.procNFe.nProt := FNFeRetornoSincrono.ProtNFe.nProt;
            NFe.procNFe.digVal := FNFeRetornoSincrono.protNFe.digVal;
            NFe.procNFe.xMotivo := FNFeRetornoSincrono.protNFe.xMotivo;
          end;

          if (FileExists(NomeArquivo + '-nfe.xml')) or
            NaoEstaVazio(TACBrNFe(FPDFeOwner).NotasFiscais.Items[I].NomeArq) then
          begin
            AProcNFe := TProcNFe.Create;
            try
              if NaoEstaVazio(TACBrNFe(
                FPDFeOwner).NotasFiscais.Items[I].NomeArq) then
                AProcNFe.PathNFe := TACBrNFe(FPDFeOwner).NotasFiscais.Items[I].NomeArq
              else
                AProcNFe.PathNFe := NomeArquivo + '-nfe.xml';

              AProcNFe.PathRetConsSitNFe := '';
              AProcNFe.PathRetConsReciNFe := '';
              AProcNFe.tpAmb := FNFeRetornoSincrono.protNFe.tpAmb;
              AProcNFe.verAplic := FNFeRetornoSincrono.protNFe.verAplic;
              AProcNFe.chNFe := FNFeRetornoSincrono.protNFe.chNFe;
              AProcNFe.dhRecbto := FNFeRetornoSincrono.protNFe.dhRecbto;
              AProcNFe.nProt := FNFeRetornoSincrono.protNFe.nProt;
              AProcNFe.digVal := FNFeRetornoSincrono.protNFe.digVal;
              AProcNFe.cStat := FNFeRetornoSincrono.protNFe.cStat;
              AProcNFe.xMotivo := FNFeRetornoSincrono.protNFe.xMotivo;

              AProcNFe.Versao := FPVersaoServico;
              AProcNFe.GerarXML;

              if NaoEstaVazio(AProcNFe.Gerador.ArquivoFormatoXML) then
                AProcNFe.Gerador.SalvarArquivo(AProcNFe.PathNFe);
            finally
              AProcNFe.Free;
            end;
          end;

          if FPConfiguracoesNFe.Arquivos.Salvar then
          begin
            SalvarXML := (not FPConfiguracoesNFe.Arquivos.SalvarApenasNFeProcessadas) or
                         TACBrNFe(FPDFeOwner).NotasFiscais.Items[I].Processada;

            if SalvarXML then
            begin
              with TACBrNFe(FPDFeOwner).NotasFiscais.Items[I] do
              begin
                GerarXML;   // Gera novamente, para incluir informa��es de "procNFe" no XML
                GravarXML;
              end;
            end;
          end;

          Break;
        end;
      end;
    end;
  end
  else
  begin
    FNFeRetorno := TretEnvNFe.Create;

    FNFeRetorno.Leitor.Arquivo := FPRetWS;
    FNFeRetorno.LerXml;

    Fversao := FNFeRetorno.versao;
    FTpAmb := FNFeRetorno.TpAmb;
    FverAplic := FNFeRetorno.verAplic;
    FcStat := FNFeRetorno.cStat;
    FxMotivo := FNFeRetorno.xMotivo;
    FdhRecbto := FNFeRetorno.infRec.dhRecbto;
    FTMed := FNFeRetorno.infRec.tMed;
    FcUF := FNFeRetorno.cUF;
    FPMsg := FNFeRetorno.xMotivo;
    FRecibo := FNFeRetorno.infRec.nRec;

    Result := (FNFeRetorno.CStat = 103);
  end;
end;

procedure TNFeRecepcao.FinalizarServico;
begin
  inherited FinalizarServico;

  if Assigned(FNFeRetornoSincrono) then
    FreeAndNil(FNFeRetornoSincrono);

  if Assigned(FNFeRetorno) then
    FreeAndNil(FNFeRetorno);
end;

function TNFeRecepcao.GerarMsgLog: String;
begin
  {(*}
  if Assigned(FNFeRetornoSincrono) then
    Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + sLineBreak +
                           'dhRecbto: %s ' + sLineBreak +
                           'chNFe: %s ' + LineBreak),
                     [FNFeRetornoSincrono.versao,
                      TpAmbToStr(FNFeRetornoSincrono.TpAmb),
                      FNFeRetornoSincrono.verAplic,
                      IntToStr(FNFeRetornoSincrono.protNFe.cStat),
                      FNFeRetornoSincrono.protNFe.xMotivo,
                      CodigoParaUF(FNFeRetornoSincrono.cUF),
                      FormatDateTimeBr(FNFeRetornoSincrono.dhRecbto),
                      FNFeRetornoSincrono.chNfe])
  else if Assigned(FNFeRetorno) then
    Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                             'Ambiente: %s ' + LineBreak +
                             'Vers�o Aplicativo: %s ' + LineBreak +
                             'Status C�digo: %s ' + LineBreak +
                             'Status Descri��o: %s ' + LineBreak +
                             'UF: %s ' + sLineBreak +
                             'Recibo: %s ' + LineBreak +
                             'Recebimento: %s ' + LineBreak +
                             'Tempo M�dio: %s ' + LineBreak),
                     [FNFeRetorno.versao,
                      TpAmbToStr(FNFeRetorno.TpAmb),
                      FNFeRetorno.verAplic,
                      IntToStr(FNFeRetorno.cStat),
                      FNFeRetorno.xMotivo,
                      CodigoParaUF(FNFeRetorno.cUF),
                      FNFeRetorno.infRec.nRec,
                      IfThen(FNFeRetorno.InfRec.dhRecbto = 0, '',
                             FormatDateTimeBr(FNFeRetorno.InfRec.dhRecbto)),
                      IntToStr(FNFeRetorno.InfRec.TMed)])
  else
    Result := '';
  {*)}
end;

function TNFeRecepcao.GerarPrefixoArquivo: String;
begin
  if Assigned(FNFeRetornoSincrono) then  // Esta procesando nome do Retorno Sincrono ?
  begin
    if FRecibo <> '' then
    begin
      Result := Recibo;
      FPArqResp := 'pro-rec';
    end
    else
    begin
      Result := Lote;
      FPArqResp := 'pro-lot';
    end;
  end
  else
    Result := Lote;
end;

{ TNFeRetRecepcao }

constructor TNFeRetRecepcao.Create(AOwner: TACBrDFe; ANotasFiscais: TNotasFiscais);
begin
  inherited Create(AOwner);

  FNotasFiscais := ANotasFiscais;
  FNFeRetorno := TRetConsReciNFe.Create;

  FPStatus := stNFeRetRecepcao;
  FPLayout := LayNfeRetRecepcao;
  FPArqEnv := 'ped-rec';
  FPArqResp := 'pro-rec';
end;

destructor TNFeRetRecepcao.Destroy;
begin
  FNFeRetorno.Free;

  inherited Destroy;
end;

function TNFeRetRecepcao.GetRecibo: String;
begin
  Result := Trim(FRecibo);
end;

function TNFeRetRecepcao.TratarRespostaFinal: Boolean;
var
  I, J: integer;
  AProcNFe: TProcNFe;
  AInfProt: TProtNFeCollection;
  SalvarXML: Boolean;
  NomeXML: String;
begin
  Result := False;

  AInfProt := FNFeRetorno.ProtNFe;

  if (AInfProt.Count > 0) then
  begin
    FPMsg := FNFeRetorno.ProtNFe.Items[0].xMotivo;
    FxMotivo := FNFeRetorno.ProtNFe.Items[0].xMotivo;
  end;

  //Setando os retornos das notas fiscais;
  for I := 0 to AInfProt.Count - 1 do
  begin
    for J := 0 to FNotasFiscais.Count - 1 do
    begin
      if OnlyNumber(AInfProt.Items[I].chNFe) = FNotasFiscais.Items[J].NumID then
      begin
        if (TACBrNFe(FPDFeOwner).Configuracoes.Geral.ValidarDigest) and
          (FNotasFiscais.Items[J].NFe.signature.DigestValue <>
          AInfProt.Items[I].digVal) and (AInfProt.Items[I].digVal <> '') then
        begin
          raise EACBrNFeException.Create('DigestValue do documento ' +
            FNotasFiscais.Items[J].NumID + ' n�o confere.');
        end;

        with FNotasFiscais.Items[J] do
        begin
          NFe.procNFe.tpAmb := AInfProt.Items[I].tpAmb;
          NFe.procNFe.verAplic := AInfProt.Items[I].verAplic;
          NFe.procNFe.chNFe := AInfProt.Items[I].chNFe;
          NFe.procNFe.dhRecbto := AInfProt.Items[I].dhRecbto;
          NFe.procNFe.nProt := AInfProt.Items[I].nProt;
          NFe.procNFe.digVal := AInfProt.Items[I].digVal;
          NFe.procNFe.cStat := AInfProt.Items[I].cStat;
          NFe.procNFe.xMotivo := AInfProt.Items[I].xMotivo;
        end;

        NomeXML := '-nfe.xml';

        if (AInfProt.Items[I].cStat = 110) or (AInfProt.Items[I].cStat = 301) then
          NomeXML := '-den.xml';

        // Monta o XML da NF-e assinado e com o protocolo de Autoriza��o ou Denega��o
        if (AInfProt.Items[I].cStat = 100) or (AInfProt.Items[I].cStat = 110) or
           (AInfProt.Items[I].cStat = 301) then
        begin
          AProcNFe := TProcNFe.Create;
          try
            AProcNFe.XML_NFe := StringReplace(FNotasFiscais.Items[J].XMLAssinado,
                                       '<' + ENCODING_UTF8 + '>', '',
                                       [rfReplaceAll]);
            AProcNFe.XML_Prot := AInfProt.Items[I].XMLprotNFe;
            AProcNFe.Versao := FPVersaoServico;
            AProcNFe.GerarXML;

            with FNotasFiscais.Items[J] do
            begin
              XML := AProcNFe.Gerador.ArquivoFormatoXML;
              XMLOriginal := XML;
              XMLAssinado := XML;

              if FPConfiguracoesNFe.Arquivos.Salvar then
              begin
                SalvarXML := (not FPConfiguracoesNFe.Arquivos.SalvarApenasNFeProcessadas) or
                             Processada;

                // Salva o XML da NF-e assinado e protocolado
                if SalvarXML then
                  FPDFeOwner.Gravar(AInfProt.Items[I].chNFe + NomeXML,
                                    XML,
                                    PathWithDelim(FPConfiguracoesNFe.Arquivos.GetPathNFe(0)));
              end;
            end;
          finally
            AProcNFe.Free;
          end;
        end;
        (*
        if FPConfiguracoesNFe.Arquivos.Salvar or NaoEstaVazio(
          FNotasFiscais.Items[J].NomeArq) then
        begin
          if FileExists(PathWithDelim(FPConfiguracoesNFe.Arquivos.PathSalvar) +
                        AInfProt.Items[I].chNFe + '-nfe.xml') and
             FileExists(PathWithDelim(FPConfiguracoesNFe.Arquivos.PathSalvar) +
                        FNFeRetorno.nRec + '-pro-rec.xml') then
          begin
            AProcNFe := TProcNFe.Create;
            try
              AProcNFe.PathNFe :=
                PathWithDelim(FPConfiguracoesNFe.Arquivos.PathSalvar) +
                AInfProt.Items[I].chNFe + '-nfe.xml';
              AProcNFe.PathRetConsReciNFe :=
                PathWithDelim(FPConfiguracoesNFe.Arquivos.PathSalvar) +
                FNFeRetorno.nRec + '-pro-rec.xml';

              AProcNFe.Versao := FPVersaoServico;
              AProcNFe.GerarXML;

              if NaoEstaVazio(AProcNFe.Gerador.ArquivoFormatoXML) then
              begin
                if NaoEstaVazio(FNotasFiscais.Items[J].NomeArq) then
                  AProcNFe.Gerador.SalvarArquivo(FNotasFiscais.Items[J].NomeArq)
                else
                  AProcNFe.Gerador.SalvarArquivo(
                    PathWithDelim(FPConfiguracoesNFe.Arquivos.PathSalvar) +
                    AInfProt.Items[I].chNFe + '-nfe.xml');
              end;
            finally
              AProcNFe.Free;
            end;
          end;
        end;

        if FPConfiguracoesNFe.Arquivos.Salvar then
        begin
          SalvarXML := (not FPConfiguracoesNFe.Arquivos.SalvarApenasNFeProcessadas) or
                       FNotasFiscais.Items[J].Processada;

          if SalvarXML then
          begin
            with FNotasFiscais.Items[J] do
            begin
              GerarXML;   // Gera novamente, para incluir informa��es de "procNFe" no XML
              GravarXML;
            end;
          end;
        end;
        *)
        break;
      end;
    end;
  end;

  //Verificando se existe alguma nota confirmada
  for I := 0 to FNotasFiscais.Count - 1 do
  begin
    if FNotasFiscais.Items[I].Confirmada then
    begin
      Result := True;
      break;
    end;
  end;

  //Verificando se existe alguma nota nao confirmada
  for I := 0 to FNotasFiscais.Count - 1 do
  begin
    if not FNotasFiscais.Items[I].Confirmada then
    begin
      FPMsg := ACBrStr('Nota(s) n�o confirmadas:') + LineBreak;
      break;
    end;
  end;

  //Montando a mensagem de retorno para as notas nao confirmadas
  for I := 0 to FNotasFiscais.Count - 1 do
  begin
    if not FNotasFiscais.Items[I].Confirmada then
      FPMsg := FPMsg + IntToStr(FNotasFiscais.Items[I].NFe.Ide.nNF) +
        '->' + FNotasFiscais.Items[I].Msg + LineBreak;
  end;

  if AInfProt.Count > 0 then
  begin
    FChaveNFe := AInfProt.Items[0].chNFe;
    FProtocolo := AInfProt.Items[0].nProt;
    FcStat := AInfProt.Items[0].cStat;
  end;
end;

function TNFeRetRecepcao.Executar: Boolean;
var
  IntervaloTentativas, Tentativas: integer;
begin
  Result := False;

  TACBrNFe(FPDFeOwner).SetStatus(stNfeRetRecepcao);
  try
    Sleep(FPConfiguracoesNFe.WebServices.AguardarConsultaRet);

    Tentativas := 0;
    IntervaloTentativas := max(FPConfiguracoesNFe.WebServices.IntervaloTentativas, 1000);

    while (inherited Executar) and
      (Tentativas < FPConfiguracoesNFe.WebServices.Tentativas) do
    begin
      Inc(Tentativas);
      sleep(IntervaloTentativas);
    end;
  finally
    TACBrNFe(FPDFeOwner).SetStatus(stIdle);
  end;

  if FNFeRetorno.CStat = 104 then  // Lote processado ?
    Result := TratarRespostaFinal;
end;

procedure TNFeRetRecepcao.DefinirURL;
begin
  if TACBrNFe(FPDFeOwner).EhAutorizacao then
    FPLayout := LayNfeRetAutorizacao
  else
    FPLayout := LayNfeRetRecepcao;

  inherited DefinirURL;
end;

procedure TNFeRetRecepcao.DefinirServicoEAction;
begin
  if FPLayout = LayNfeRetAutorizacao then
    FPServico := GetUrlWsd + 'NfeRetAutorizacao'
  else
    FPServico := GetUrlWsd + 'NfeRetRecepcao2';

  FPSoapAction := FPServico;
end;

procedure TNFeRetRecepcao.DefinirDadosMsg;
var
  ConsReciNFe: TConsReciNFe;
begin
  ConsReciNFe := TConsReciNFe.Create;
  try
    ConsReciNFe.tpAmb := FPConfiguracoesNFe.WebServices.Ambiente;
    ConsReciNFe.nRec := FRecibo;
    ConsReciNFe.Versao := FPVersaoServico;
    ConsReciNFe.GerarXML;

    FPDadosMsg := ConsReciNFe.Gerador.ArquivoFormatoXML;
  finally
    ConsReciNFe.Free;
  end;
end;

function TNFeRetRecepcao.TratarResposta: Boolean;
begin
  if FPLayout = LayNfeRetAutorizacao then
  begin
    FPRetWS := SeparaDados(FPRetornoWS, 'nfeRetAutorizacaoResult');
    if FPRetWS = '' then
      FPRetWS := SeparaDados(FPRetornoWS, 'nfeRetAutorizacaoLoteResult');
  end
  else
    FPRetWS := SeparaDados(FPRetornoWS, 'nfeRetRecepcao2Result');

  // Limpando variaveis internas
  FNFeRetorno.Free;
  FNFeRetorno := TRetConsReciNFe.Create;

  FNFeRetorno.Leitor.Arquivo := FPRetWS;
  FNFeRetorno.LerXML;

  Fversao := FNFeRetorno.versao;
  FTpAmb := FNFeRetorno.TpAmb;
  FverAplic := FNFeRetorno.verAplic;
  FcStat := FNFeRetorno.cStat;
  FcUF := FNFeRetorno.cUF;
  FPMsg := FNFeRetorno.xMotivo;
  FxMotivo := FNFeRetorno.xMotivo;
  FcMsg := FNFeRetorno.cMsg;
  FxMsg := FNFeRetorno.xMsg;

  Result := (FNFeRetorno.CStat = 105); // Lote em Processamento
end;

procedure TNFeRetRecepcao.FinalizarServico;
begin
  // Sobrescrito, para n�o liberar para stIdle... n�o ainda...;
end;

function TNFeRetRecepcao.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Recibo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak +
                           'cMsg: %s ' + LineBreak +
                           'xMsg: %s ' + LineBreak),
                   [FNFeRetorno.versao, TpAmbToStr(FNFeRetorno.tpAmb),
                    FNFeRetorno.verAplic, FNFeRetorno.nRec,
                    IntToStr(FNFeRetorno.cStat), FNFeRetorno.xMotivo,
                    CodigoParaUF(FNFeRetorno.cUF), IntToStr(FNFeRetorno.cMsg),
                    FNFeRetorno.xMsg]);
  {*)}
end;

function TNFeRetRecepcao.GerarPrefixoArquivo: String;
begin
  Result := Recibo;
end;

{ TNFeRecibo }

constructor TNFeRecibo.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FNFeRetorno := TRetConsReciNFe.Create;

  FPStatus := stNFeRecibo;
  FPLayout := LayNfeRetRecepcao;
  FPArqEnv := 'ped-rec';
  FPArqResp := 'pro-rec';
end;

destructor TNFeRecibo.Destroy;
begin
  FNFeRetorno.Free;

  inherited Destroy;
end;

procedure TNFeRecibo.DefinirServicoEAction;
begin
  if FPLayout = LayNfeRetAutorizacao then
    FPServico := GetUrlWsd + 'NfeRetAutorizacao'
  else
    FPServico := GetUrlWsd + 'NfeRetRecepcao2';

  FPSoapAction := FPServico;
end;

procedure TNFeRecibo.DefinirURL;
begin
  if TACBrNFe(FPDFeOwner).EhAutorizacao then
    FPLayout := LayNfeRetAutorizacao
  else
    FPLayout := LayNfeRetRecepcao;

  inherited DefinirURL;
end;

procedure TNFeRecibo.DefinirDadosMsg;
var
  ConsReciNFe: TConsReciNFe;
begin
  ConsReciNFe := TConsReciNFe.Create;
  try
    ConsReciNFe.tpAmb := FPConfiguracoesNFe.WebServices.Ambiente;
    ConsReciNFe.nRec := FRecibo;
    ConsReciNFe.Versao := FPVersaoServico;
    ConsReciNFe.GerarXML;

    FPDadosMsg := ConsReciNFe.Gerador.ArquivoFormatoXML;
  finally
    ConsReciNFe.Free;
  end;
end;

function TNFeRecibo.TratarResposta: Boolean;
begin
  if FPLayout = LayNfeRetAutorizacao then
  begin
    FPRetWS := SeparaDados(FPRetornoWS, 'nfeRetAutorizacaoResult');
    if FPRetWS = '' then
      FPRetWS := SeparaDados(FPRetornoWS, 'nfeRetAutorizacaoLoteResult');
  end
  else
    FPRetWS := SeparaDados(FPRetornoWS, 'nfeRetRecepcao2Result');

  // Limpando variaveis internas
  FNFeRetorno.Free;
  FNFeRetorno := TRetConsReciNFe.Create;

  FNFeRetorno.Leitor.Arquivo := FPRetWS;
  FNFeRetorno.LerXML;

  Fversao := FNFeRetorno.versao;
  FTpAmb := FNFeRetorno.TpAmb;
  FverAplic := FNFeRetorno.verAplic;
  FcStat := FNFeRetorno.cStat;
  FxMotivo := FNFeRetorno.xMotivo;
  FcUF := FNFeRetorno.cUF;
  FxMsg := FNFeRetorno.xMsg;
  FcMsg := FNFeRetorno.cMsg;
  FPMsg := FxMotivo;

  Result := (FNFeRetorno.CStat = 104);
end;

function TNFeRecibo.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Recibo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak),
                   [FNFeRetorno.versao, TpAmbToStr(FNFeRetorno.TpAmb),
                   FNFeRetorno.verAplic, FNFeRetorno.nRec,
                   IntToStr(FNFeRetorno.cStat),
                   FNFeRetorno.ProtNFe.Items[0].xMotivo,
                   CodigoParaUF(FNFeRetorno.cUF)]);
  {*)}
end;

{ TNFeConsulta }

constructor TNFeConsulta.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FprotNFe := TProcNFe.Create;
  FretCancNFe := TRetCancNFe.Create;
  FprocEventoNFe := TRetEventoNFeCollection.Create(AOwner);

  FPStatus := stNfeConsulta;
  FPLayout := LayNfeConsulta;
  FPArqEnv := 'ped-sit';
  FPArqResp := 'sit';
end;

destructor TNFeConsulta.Destroy;
begin
  FprotNFe.Free;
  FretCancNFe.Free;
  if Assigned(FprocEventoNFe) then
    FprocEventoNFe.Free;

  inherited Destroy;
end;

procedure TNFeConsulta.DefinirServicoEAction;
begin
  if (FPConfiguracoesNFe.Geral.ModeloDF = moNFe) and
     (FPConfiguracoesNFe.Geral.VersaoDF = ve310) and
     (FPConfiguracoesNFe.WebServices.UFCodigo in [29]) then // 29 = BA
    FPServico := GetUrlWsd + 'NfeConsulta'
  else
    FPServico := GetUrlWsd + 'NfeConsulta2';

  FPSoapAction := FPServico;
end;

procedure TNFeConsulta.DefinirDadosMsg;
var
  ConsSitNFe: TConsSitNFe;
  OK: Boolean;
begin
  OK := False;
  ConsSitNFe := TConsSitNFe.Create;
  try
    ConsSitNFe.TpAmb := FPConfiguracoesNFe.WebServices.Ambiente;
    ConsSitNFe.chNFe := FNFeChave;

    FPConfiguracoesNFe.Geral.ModeloDF :=
      StrToModeloDF(OK, ExtrairModeloChaveAcesso(ConsSitNFe.chNFe));

    ConsSitNFe.Versao := FPVersaoServico;
    ConsSitNFe.GerarXML;

    FPDadosMsg := ConsSitNFe.Gerador.ArquivoFormatoXML;
  finally
    ConsSitNFe.Free;
  end;
end;

function TNFeConsulta.TratarResposta: Boolean;
var
  NFeRetorno: TRetConsSitNFe;
  SalvarXML, NFCancelada, Atualiza: Boolean;
  aEventos, aMsg, NomeArquivo, aNFe, aNFeDFe, NomeXML: String;
  AProcNFe: TProcNFe;
  I, J, Inicio, Fim: integer;
  Data: TDateTime;
begin
  NFeRetorno := TRetConsSitNFe.Create;

  try
    FPRetWS := SeparaDados(FPRetornoWS, 'NfeConsultaNF2Result');
    if FPRetWS = '' then
      FPRetWS := SeparaDados(FPRetornoWS, 'NfeConsultaNFResult');

    NFeRetorno.Leitor.Arquivo := FPRetWS;
    NFeRetorno.LerXML;

    NFCancelada := False;
    aEventos := '';

    // <retConsSitNFe> - Retorno da consulta da situa��o da NF-e
    // Este � o status oficial da NF-e
    Fversao := NFeRetorno.versao;
    FTpAmb := NFeRetorno.tpAmb;
    FverAplic := NFeRetorno.verAplic;
    FcStat := NFeRetorno.cStat;
    FXMotivo := NFeRetorno.xMotivo;
    FcUF := NFeRetorno.cUF;
    FNFeChave := NFeRetorno.chNfe;
    FPMsg := FXMotivo;

    // Verifica se a nota fiscal est� cancelada pelo m�todo antigo. Se estiver,
    // ent�o NFCancelada ser� True e j� atribui Protocolo, Data e Mensagem
    if NFeRetorno.retCancNFe.cStat > 0 then
    begin
      FRetCancNFe.versao := NFeRetorno.retCancNFe.versao;
      FretCancNFe.tpAmb := NFeRetorno.retCancNFe.tpAmb;
      FretCancNFe.verAplic := NFeRetorno.retCancNFe.verAplic;
      FretCancNFe.cStat := NFeRetorno.retCancNFe.cStat;
      FretCancNFe.xMotivo := NFeRetorno.retCancNFe.xMotivo;
      FretCancNFe.cUF := NFeRetorno.retCancNFe.cUF;
      FretCancNFe.chNFE := NFeRetorno.retCancNFe.chNFE;
      FretCancNFe.dhRecbto := NFeRetorno.retCancNFe.dhRecbto;
      FretCancNFe.nProt := NFeRetorno.retCancNFe.nProt;

      NFCancelada := True;
      FProtocolo := NFeRetorno.retCancNFe.nProt;
      FDhRecbto := NFeRetorno.retCancNFe.dhRecbto;
      FPMsg := NFeRetorno.xMotivo;
    end;

    // <protNFe> - Retorno dos dados do ENVIO da NF-e
    // Consider�-los apenas se n�o existir nenhum evento de cancelamento (110111)
    FprotNFe.PathNFe := NFeRetorno.protNFe.PathNFe;
    FprotNFe.PathRetConsReciNFe := NFeRetorno.protNFe.PathRetConsReciNFe;
    FprotNFe.PathRetConsSitNFe := NFeRetorno.protNFe.PathRetConsSitNFe;
    FprotNFe.PathRetConsSitNFe := NFeRetorno.protNFe.PathRetConsSitNFe;
    FprotNFe.tpAmb := NFeRetorno.protNFe.tpAmb;
    FprotNFe.verAplic := NFeRetorno.protNFe.verAplic;
    FprotNFe.chNFe := NFeRetorno.protNFe.chNFe;
    FprotNFe.dhRecbto := NFeRetorno.protNFe.dhRecbto;
    FprotNFe.nProt := NFeRetorno.protNFe.nProt;
    FprotNFe.digVal := NFeRetorno.protNFe.digVal;
    FprotNFe.cStat := NFeRetorno.protNFe.cStat;
    FprotNFe.xMotivo := NFeRetorno.protNFe.xMotivo;

    {(*}
    if Assigned(NFeRetorno.procEventoNFe) and (NFeRetorno.procEventoNFe.Count > 0) then
    begin
      aEventos := '=====================================================' +
        LineBreak + '================== Eventos da NF-e ==================' +
        LineBreak + '=====================================================' +
        LineBreak + '' + LineBreak + 'Quantidade total de eventos: ' +
        IntToStr(NFeRetorno.procEventoNFe.Count);

      FprocEventoNFe.Clear;
      for I := 0 to NFeRetorno.procEventoNFe.Count - 1 do
      begin
        with FprocEventoNFe.Add.RetEventoNFe do
        begin
          idLote := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.idLote;
          tpAmb := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.tpAmb;
          verAplic := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.verAplic;
          cOrgao := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.cOrgao;
          cStat := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.cStat;
          xMotivo := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.xMotivo;
          XML := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.XML;

          InfEvento.ID := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.InfEvento.ID;
          InfEvento.tpAmb := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.InfEvento.tpAmb;
          InfEvento.CNPJ := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.InfEvento.CNPJ;
          InfEvento.chNFe := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.InfEvento.chNFe;
          InfEvento.dhEvento := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.InfEvento.dhEvento;
          InfEvento.TpEvento := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.InfEvento.TpEvento;
          InfEvento.nSeqEvento := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.InfEvento.nSeqEvento;
          InfEvento.VersaoEvento := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.InfEvento.VersaoEvento;
          InfEvento.DetEvento.xCorrecao := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.InfEvento.DetEvento.xCorrecao;
          InfEvento.DetEvento.xCondUso := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.InfEvento.DetEvento.xCondUso;
          InfEvento.DetEvento.nProt := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.InfEvento.DetEvento.nProt;
          InfEvento.DetEvento.xJust := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.InfEvento.DetEvento.xJust;

          retEvento.Clear;
          for J := 0 to NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Count-1 do
          begin
            with retEvento.Add.RetInfEvento do
            begin
              Id := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.Id;
              tpAmb := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.tpAmb;
              verAplic := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.verAplic;
              cOrgao := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.cOrgao;
              cStat := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.cStat;
              xMotivo := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.xMotivo;
              chNFe := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.chNFe;
              tpEvento := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.tpEvento;
              xEvento := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.xEvento;
              nSeqEvento := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.nSeqEvento;
              CNPJDest := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.CNPJDest;
              emailDest := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.emailDest;
              dhRegEvento := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.dhRegEvento;
              nProt := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.nProt;
              XML := NFeRetorno.procEventoNFe.Items[I].RetEventoNFe.retEvento.Items[J].RetInfEvento.XML;
            end;
          end;
        end;

        with NFeRetorno.procEventoNFe.Items[I].RetEventoNFe do
        begin
          for j := 0 to retEvento.Count -1 do
          begin
            aEventos := aEventos + LineBreak + LineBreak +
              Format(ACBrStr('N�mero de sequ�ncia: %s ' + LineBreak +
                             'C�digo do evento: %s ' + LineBreak +
                             'Descri��o do evento: %s ' + LineBreak +
                             'Status do evento: %s ' + LineBreak +
                             'Descri��o do status: %s ' + LineBreak +
                             'Protocolo: %s ' + LineBreak +
                             'Data/Hora do registro: %s '),
                     [IntToStr(InfEvento.nSeqEvento),
                      TpEventoToStr(InfEvento.TpEvento),
                      InfEvento.DescEvento,
                      IntToStr(retEvento.Items[J].RetInfEvento.cStat),
                      retEvento.Items[J].RetInfEvento.xMotivo,
                      retEvento.Items[J].RetInfEvento.nProt,
                      FormatDateTimeBr(retEvento.Items[J].RetInfEvento.dhRegEvento)]);

            if retEvento.Items[J].RetInfEvento.tpEvento = teCancelamento then
            begin
              NFCancelada := True;
              FProtocolo := retEvento.Items[J].RetInfEvento.nProt;
              FDhRecbto := retEvento.Items[J].RetInfEvento.dhRegEvento;
              FPMsg := retEvento.Items[J].RetInfEvento.xMotivo;
            end;
          end;
        end;
      end;
    end;
    {*)}

    if not NFCancelada and (NaoEstaVazio(NFeRetorno.protNFe.nProt))  then
    begin
      FProtocolo := NFeRetorno.protNFe.nProt;
      FDhRecbto := NFeRetorno.protNFe.dhRecbto;
      FPMsg := NFeRetorno.protNFe.xMotivo;
    end;

    //TODO: Verificar porque monta "aMsg", pois ela n�o est� sendo usada em lugar nenhum
    aMsg := GerarMsgLog;
    if aEventos <> '' then
      aMsg := aMsg + sLineBreak + aEventos;

    Result := (NFeRetorno.CStat in [100, 101, 110, 150, 151, 155]);

    NomeArquivo := PathWithDelim(FPConfiguracoesNFe.Arquivos.PathSalvar) + FNFeChave;

    for i := 0 to TACBrNFe(FPDFeOwner).NotasFiscais.Count - 1 do
    begin
      with TACBrNFe(FPDFeOwner).NotasFiscais.Items[i] do
      begin
        if (OnlyNumber(FNFeChave) = NumID) then
        begin
          Atualiza := True;
          if (NFeRetorno.CStat in [101, 151, 155]) then
            Atualiza := False;

          // Atualiza o Status da NFe interna //
          NFe.procNFe.cStat := NFeRetorno.cStat;

          if Atualiza then
          begin
            if (FPConfiguracoesNFe.Geral.ValidarDigest) and
              (NFeRetorno.protNFe.digVal <> '') and (NFe.signature.DigestValue <> '') and
              (UpperCase(NFe.signature.DigestValue) <> UpperCase(NFeRetorno.protNFe.digVal)) then
            begin
              raise EACBrNFeException.Create('DigestValue do documento ' +
                NumID + ' n�o confere.');
            end;

            NFe.procNFe.tpAmb := NFeRetorno.tpAmb;
            NFe.procNFe.verAplic := NFeRetorno.verAplic;
            NFe.procNFe.chNFe := NFeRetorno.chNfe;
            NFe.procNFe.dhRecbto := FDhRecbto;
            NFe.procNFe.nProt := FProtocolo;
            NFe.procNFe.digVal := NFeRetorno.protNFe.digVal;
            NFe.procNFe.cStat := NFeRetorno.cStat;
            NFe.procNFe.xMotivo := NFeRetorno.xMotivo;

            NomeXML := '-nfe.xml';
            if (NFeRetorno.protNFe.cStat = 110) or (NFeRetorno.protNFe.cStat = 301) then
              NomeXML := '-den.xml';

            AProcNFe := TProcNFe.Create;
            try
              AProcNFe.XML_NFe := StringReplace(XMLAssinado,
                                         '<' + ENCODING_UTF8 + '>', '',
                                         [rfReplaceAll]);
              AProcNFe.XML_Prot := NFeRetorno.XMLprotNFe;
              AProcNFe.Versao := FPVersaoServico;
              AProcNFe.GerarXML;

              XML := AProcNFe.Gerador.ArquivoFormatoXML;
              XMLOriginal := XML;
              XMLAssinado := XML;

              FRetNFeDFe := '';

              if (NaoEstaVazio(SeparaDados(FPRetWS, 'procEventoNFe'))) then
              begin
                Inicio := Pos('<procEventoNFe', FPRetWS);
                Fim    := Pos('</retConsSitNFe', FPRetWS) -1;

                aEventos := Copy(FPRetWS, Inicio, Fim - Inicio + 1);

                aNFeDFe := '<?xml version="1.0" encoding="UTF-8" ?>' +
                           '<NFeDFe>' +
                            '<procNFe versao="' + FVersao + '">' +
                              SeparaDados(XML, 'nfeProc') +
                            '</procNFe>' +
                            '<procEventoNFe versao="' + FVersao + '">' +
                              aEventos +
                            '</procEventoNFe>' +
                           '</NFeDFe>';

                FRetNFeDFe := aNFeDFe;
              end;
            finally
              AProcNFe.Free;
            end;

            if FPConfiguracoesNFe.Arquivos.Salvar then
            begin
              if FPConfiguracoesNFe.Arquivos.EmissaoPathNFe then
                Data := NFe.Ide.dEmi
              else
                Data := Now;

              SalvarXML := (not FPConfiguracoesNFe.Arquivos.SalvarApenasNFeProcessadas) or
                           Processada;

              // Salva o XML do NF-e assinado e protocolado
              if SalvarXML then
                FPDFeOwner.Gravar(FNFeChave + NomeXML,
                                  XML,
                                  PathWithDelim(FPConfiguracoesNFe.Arquivos.GetPathNFe(Data)));

              // Salva o XML do NF-e assinado, protocolado e com os eventos
              if SalvarXML  and (FRetNFeDFe <> '') then
                FPDFeOwner.Gravar(FNFeChave + '-NFeDFe.xml',
                                  aNFeDFe,
                                  PathWithDelim(FPConfiguracoesNFe.Arquivos.GetPathNFe(Data)));

            end;
          end;

          break;
            (*
            if FileExists(NomeArquivo + '-nfe.xml') or NaoEstaVazio(NomeArq) then
            begin
              AProcNFe := TProcNFe.Create;
              try
                if NaoEstaVazio(NomeArq) then
                  AProcNFe.PathNFe := NomeArq
                else
                  AProcNFe.PathNFe := NomeArquivo + '-nfe.xml';

                AProcNFe.PathRetConsSitNFe := NomeArquivo + '-sit.xml';

                if FPConfiguracoesNFe.Geral.VersaoDF >= ve310 then
                  AProcNFe.Versao :=
                    TACBrNFe(FPDFeOwner).LerVersaoDeParams(LayNfeAutorizacao)
                else
                  AProcNFe.Versao :=
                    TACBrNFe(FPDFeOwner).LerVersaoDeParams(LayNfeRecepcao);

                AProcNFe.GerarXML;

                if NaoEstaVazio(AProcNFe.Gerador.ArquivoFormatoXML) then
                  AProcNFe.Gerador.SalvarArquivo(AProcNFe.PathNFe);
              finally
                AProcNFe.Free;
              end;
            end;

            if FPConfiguracoesNFe.Arquivos.Salvar then
            begin
              SalvarXML := (not FPConfiguracoesNFe.Arquivos.SalvarApenasNFeProcessadas) or
                           Processada;

              if SalvarXML then
              begin
                GerarXML;   // Gera novamente, para incluir informa��es de "procNFe" no XML
                GravarXML;
              end;
            end;
          *)
        end;
      end;
    end;

    if (TACBrNFe(FPDFeOwner).NotasFiscais.Count <= 0) then
    begin
      if FPConfiguracoesNFe.Arquivos.Salvar then
      begin
        if FileExists(NomeArquivo + '-nfe.xml') then
        begin
          AProcNFe := TProcNFe.Create;
          try
            AProcNFe.PathNFe := NomeArquivo + '-nfe.xml';
            AProcNFe.PathRetConsSitNFe := NomeArquivo + '-sit.xml';

            if FPConfiguracoesNFe.Geral.VersaoDF >= ve310 then
              AProcNFe.Versao :=
                TACBrNFe(FPDFeOwner).LerVersaoDeParams(LayNfeAutorizacao)
            else
              AProcNFe.Versao := TACBrNFe(FPDFeOwner).LerVersaoDeParams(LayNfeRecepcao);

            AProcNFe.GerarXML;

            aNFe := AProcNFe.Gerador.ArquivoFormatoXML;

            if NaoEstaVazio(AProcNFe.Gerador.ArquivoFormatoXML) then
              AProcNFe.Gerador.SalvarArquivo(AProcNFe.PathNFe);

            if (NaoEstaVazio(aNFe)) and (NaoEstaVazio(SeparaDados(FPRetWS, 'procEventoNFe'))) then
            begin
              Inicio := Pos('<procEventoNFe', FPRetWS);
              Fim    := Pos('</retConsSitNFe', FPRetWS) -1;

              aEventos := Copy(FPRetWS, Inicio, Fim - Inicio + 1);

              aNFeDFe := '<?xml version="1.0" encoding="UTF-8" ?>' +
                         '<NFeDFe>' +
                          '<procNFe versao="' + FVersao + '">' +
                            SeparaDados(aNFe, 'nfeProc') +
                          '</procNFe>' +
                          '<procEventoNFe versao="' + FVersao + '">' +
                            aEventos +
                          '</procEventoNFe>' +
                         '</NFeDFe>';

              FRetNFeDFe := aNFeDFe;
            end;
          finally
            AProcNFe.Free;
          end;
        end;

        if FRetNFeDFe <> '' then
        begin
          if FPConfiguracoesNFe.Arquivos.EmissaoPathNFe then
            Data := TACBrNFe(FPDFeOwner).NotasFiscais.Items[i].NFe.Ide.dEmi
          else
            Data := Now;

          FPDFeOwner.Gravar(FNFeChave + '-NFeDFe.xml',
                                     aNFeDFe,
                                     PathWithDelim(FPConfiguracoesNFe.Arquivos.GetPathNFe(Data)));
        end;
      end;
    end;
  finally
    NFeRetorno.Free;
  end;
end;

function TNFeConsulta.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Identificador: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak +
                           'Chave Acesso: %s ' + LineBreak +
                           'Recebimento: %s ' + LineBreak +
                           'Protocolo: %s ' + LineBreak +
                           'Digest Value: %s ' + LineBreak),
                   [Fversao, FNFeChave, TpAmbToStr(FTpAmb), FverAplic,
                    IntToStr(FcStat), FXMotivo, CodigoParaUF(FcUF), FNFeChave,
                    FormatDateTimeBr(FDhRecbto), FProtocolo, FprotNFe.digVal]);
  {*)}
end;

function TNFeConsulta.GerarPrefixoArquivo: String;
begin
  Result := Trim(FNFeChave);
end;

{ TNFeInutilizacao }

constructor TNFeInutilizacao.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FPStatus := stNFeInutilizacao;
  FPLayout := LayNfeInutilizacao;
  FPArqEnv := 'ped-inu';
  FPArqResp := 'inu';
end;

procedure TNFeInutilizacao.SetJustificativa(AValue: String);
var
  TrimValue: String;
begin
  TrimValue := Trim(AValue);

  if EstaVazio(TrimValue) then
    GerarException(ACBrStr('Informar uma Justificativa para Inutiliza��o de ' +
      'numera��o da Nota Fiscal Eletronica'));

  if Length(TrimValue) < 15 then
    GerarException(ACBrStr('A Justificativa para Inutiliza��o de numera��o da ' +
      'Nota Fiscal Eletronica deve ter no minimo 15 caracteres'));

  FJustificativa := TrimValue;
end;

function TNFeInutilizacao.GerarPathPorCNPJ(): String;
var
  CNPJ: String;
begin
  if FPConfiguracoesNFe.Arquivos.SepararPorCNPJ then
    CNPJ := FCNPJ
  else
    CNPJ := '';

  Result := FPConfiguracoesNFe.Arquivos.GetPathInu(CNPJ);
end;

procedure TNFeInutilizacao.DefinirServicoEAction;
begin
  if (FPConfiguracoesNFe.Geral.ModeloDF = moNFe) and
     (FPConfiguracoesNFe.Geral.VersaoDF = ve310) and
     (FPConfiguracoesNFe.WebServices.UFCodigo in [29]) then // 29 = BA
  begin
    FPServico := GetUrlWsd + 'NfeInutilizacao';
    FPSoapAction := FPServico + '/NfeInutilizacao';
  end
  else
  begin
    FPServico := GetUrlWsd + 'NfeInutilizacao2';
    FPSoapAction := FPServico;
  end;
end;

procedure TNFeInutilizacao.DefinirDadosMsg;
var
  InutNFe: TinutNFe;
  OK: Boolean;
begin
  OK := False;
  InutNFe := TinutNFe.Create;
  try
    InutNFe.tpAmb := FPConfiguracoesNFe.WebServices.Ambiente;
    InutNFe.cUF := FPConfiguracoesNFe.WebServices.UFCodigo;
    InutNFe.ano := FAno;
    InutNFe.CNPJ := FCNPJ;
    InutNFe.modelo := FModelo;
    InutNFe.serie := FSerie;
    InutNFe.nNFIni := FNumeroInicial;
    InutNFe.nNFFin := FNumeroFinal;
    InutNFe.xJust := FJustificativa;

    FPConfiguracoesNFe.Geral.ModeloDF := StrToModeloDF(OK, IntToStr(InutNFe.modelo));

    InutNFe.Versao := FPVersaoServico;
    InutNFe.GerarXML;

    AssinarXML(InutNFe.Gerador.ArquivoFormatoXML, 'inutNFe', 'infInut',
      'Falha ao assinar Inutiliza��o Nota Fiscal Eletr�nica ');

    FID := InutNFe.ID;
  finally
    InutNFe.Free;
  end;
end;

procedure TNFeInutilizacao.SalvarEnvio;
var
  aPath: String;
begin
  inherited SalvarEnvio;

  if FPConfiguracoesNFe.Geral.Salvar then
  begin
    aPath := GerarPathPorCNPJ;
    FPDFeOwner.Gravar(GerarPrefixoArquivo + '-' + ArqEnv + '.xml', FPDadosMsg, aPath);
  end;
end;

procedure TNFeInutilizacao.SalvarResposta;
var
  aPath: String;
begin
  inherited SalvarResposta;

  if FPConfiguracoesNFe.Geral.Salvar then
  begin
    aPath := GerarPathPorCNPJ;
    FPDFeOwner.Gravar(GerarPrefixoArquivo + '-' + ArqResp + '.xml', FPRetWS, aPath);
  end;
end;

function TNFeInutilizacao.TratarResposta: Boolean;
var
  NFeRetorno: TRetInutNFe;
  wProc: TStringList;
begin
  NFeRetorno := TRetInutNFe.Create;
  try
    FPRetWS := SeparaDados(FPRetornoWS, 'nfeInutilizacaoNF2Result');
    if FPRetWS = '' then
      FPRetWS := SeparaDados(FPRetornoWS, 'nfeInutilizacaoNFResult');

    NFeRetorno.Leitor.Arquivo := FPRetWS;
    NFeRetorno.LerXml;

    Fversao := NFeRetorno.versao;
    FTpAmb := NFeRetorno.TpAmb;
    FverAplic := NFeRetorno.verAplic;
    FcStat := NFeRetorno.cStat;
    FxMotivo := NFeRetorno.xMotivo;
    FcUF := NFeRetorno.cUF;
    FdhRecbto := NFeRetorno.dhRecbto;
    Fprotocolo := NFeRetorno.nProt;
    FPMsg := NFeRetorno.XMotivo;

    Result := (NFeRetorno.cStat = 102);

    //gerar arquivo proc de inutilizacao
    if ((NFeRetorno.cStat = 102) or (NFeRetorno.cStat = 563)) then
    begin
      wProc := TStringList.Create;
      try
        wProc.Add('<' + ENCODING_UTF8 + '>');
        wProc.Add('<ProcInutNFe versao="' + FPVersaoServico +
          '" xmlns="http://www.portalfiscal.inf.br/nfe">');

        wProc.Add(FPDadosMsg);
        wProc.Add(FPRetWS);
        wProc.Add('</ProcInutNFe>');
        FXML_ProcInutNFe := wProc.Text;
      finally
        wProc.Free;
      end;

//      if FPConfiguracoesNFe.Geral.Salvar then
//        FPDFeOwner.Gravar(GerarPrefixoArquivo + '-procInutNFe.xml',
//          FXML_ProcInutNFe);

      if FPConfiguracoesNFe.Arquivos.Salvar then
        FPDFeOwner.Gravar(GerarPrefixoArquivo + '-procInutNFe.xml',
          FXML_ProcInutNFe, GerarPathPorCNPJ);
    end;
  finally
    NFeRetorno.Free;
  end;
end;

function TNFeInutilizacao.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak +
                           'Recebimento: %s ' + LineBreak),
                   [Fversao, TpAmbToStr(FTpAmb), FverAplic, IntToStr(FcStat),
                    FxMotivo, CodigoParaUF(FcUF),
                    IfThen(FdhRecbto = 0, '', FormatDateTimeBr(FdhRecbto))]);
  {*)}
end;

function TNFeInutilizacao.GerarPrefixoArquivo: String;
begin
  Result := Trim(OnlyNumber(FID));
end;

{ TNFeConsultaCadastro }

constructor TNFeConsultaCadastro.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FRetConsCad := TRetConsCad.Create;

  FPStatus := stNFeCadastro;
  FPLayout := LayNfeCadastro;
  FPArqEnv := 'ped-cad';
  FPArqResp := 'cad';
end;

destructor TNFeConsultaCadastro.Destroy;
begin
  FRetConsCad.Free;

  inherited Destroy;
end;

procedure TNFeConsultaCadastro.SetCNPJ(const Value: String);
begin
  if NaoEstaVazio(Value) then
  begin
    FIE := '';
    FCPF := '';
  end;

  FCNPJ := Value;
end;

procedure TNFeConsultaCadastro.SetCPF(const Value: String);
begin
  if NaoEstaVazio(Value) then
  begin
    FIE := '';
    FCNPJ := '';
  end;

  FCPF := Value;
end;

procedure TNFeConsultaCadastro.SetIE(const Value: String);
begin
  if NaoEstaVazio(Value) then
  begin
    FCNPJ := '';
    FCPF := '';
  end;

  FIE := Value;
end;

procedure TNFeConsultaCadastro.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'CadConsultaCadastro2';
  FPSoapAction := FPServico;
end;

procedure TNFeConsultaCadastro.DefinirURL;
var
  Versao: Double;
begin
  FPVersaoServico := '';
  FPURL := '';
  Versao := VersaoDFToDbl(FPConfiguracoesNFe.Geral.VersaoDF);

  TACBrNFe(FPDFeOwner).LerServicoDeParams(
    TACBrNFe(FPDFeOwner).GetNomeModeloDFe,
    Self.FUF,
    FPConfiguracoesNFe.WebServices.Ambiente,
    LayOutToServico(FPLayout),
    Versao,
    FPURL
  );

  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;

procedure TNFeConsultaCadastro.DefinirDadosMsg;
var
  ConCadNFe: TConsCad;
begin
  ConCadNFe := TConsCad.Create;
  try
    ConCadNFe.UF := FUF;
    ConCadNFe.IE := FIE;
    ConCadNFe.CNPJ := FCNPJ;
    ConCadNFe.CPF := FCPF;
    ConCadNFe.Versao := FPVersaoServico;
    ConCadNFe.GerarXML;

    FPDadosMsg := ConCadNFe.Gerador.ArquivoFormatoXML;
  finally
    ConCadNFe.Free;
  end;
end;

function TNFeConsultaCadastro.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'consultaCadastro2Result');

  // Limpando variaveis internas
  FRetConsCad.Free;
  FRetConsCad := TRetConsCad.Create;

  FRetConsCad.Leitor.Arquivo := FPRetWS;
  FRetConsCad.LerXml;

  Fversao := FRetConsCad.versao;
  FverAplic := FRetConsCad.verAplic;
  FcStat := FRetConsCad.cStat;
  FxMotivo := FRetConsCad.xMotivo;
  FdhCons := FRetConsCad.dhCons;
  FcUF := FRetConsCad.cUF;
  FPMsg := FRetConsCad.XMotivo;

  Result := (FRetConsCad.cStat in [111, 112]);
end;

function TNFeConsultaCadastro.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'UF: %s ' + LineBreak +
                           'Consulta: %s ' + sLineBreak),
                   [FRetConsCad.versao, FRetConsCad.verAplic,
                   IntToStr(FRetConsCad.cStat), FRetConsCad.xMotivo,
                   CodigoParaUF(FRetConsCad.cUF),
                   FormatDateTimeBr(FRetConsCad.dhCons)]);
  {*)}
end;

function TNFeConsultaCadastro.GerarUFSoap: String;
begin
  Result := '<cUF>' + IntToStr(UFparaCodigo(FUF)) + '</cUF>';
end;

{ TNFeEnvEvento }

constructor TNFeEnvEvento.Create(AOwner: TACBrDFe; AEvento: TEventoNFe);
begin
  inherited Create(AOwner);

  FEventoRetorno := TRetEventoNFe.Create;
  FEvento := AEvento;

  FPStatus := stNFeEvento;
  FPLayout := LayNFeEvento;
  FPArqEnv := 'ped-eve';
  FPArqResp := 'eve';
end;

destructor TNFeEnvEvento.Destroy;
begin
  FEventoRetorno.Free;

  inherited;
end;

function TNFeEnvEvento.GerarPathEvento: String;
begin
  with FEvento.Evento.Items[0].InfEvento do
  begin
    Result := FPConfiguracoesNFe.Arquivos.GetPathEvento(tpEvento);
  end;
end;

procedure TNFeEnvEvento.DefinirURL;
var
  UF : String;
  Versao: Double;
begin
  { Verifica��o necess�ria pois somente os eventos de Cancelamento e CCe ser�o tratados pela SEFAZ do estado
    os outros eventos como manifestacao de destinat�rios ser�o tratados diretamente pela RFB }

  if not (FEvento.Evento.Items[0].InfEvento.tpEvento in [teCCe, teCancelamento]) then
  begin
    FPLayout := LayNFeEventoAN;
    UF := 'AN';
  end
  else
  begin
    FPLayout := LayNFeEvento;
    UF := FPConfiguracoesNFe.WebServices.UF;
  end;

  if (FEvento.Evento.Items[0].InfEvento.tpEvento = teEPECNFe) and
     (FPConfiguracoesNFe.WebServices.UFCodigo = 35) and
     (FPConfiguracoesNFe.Geral.ModeloDF = moNFCe) then
  begin
    FPLayout := LayNFCeEPEC;
    UF := FPConfiguracoesNFe.WebServices.UF;
  end;

  Versao := 0;
  FPVersaoServico := '';
  FPURL := '';
  Versao := VersaoDFToDbl(FPConfiguracoesNFe.Geral.VersaoDF);

  TACBrNFe(FPDFeOwner).LerServicoDeParams(TACBrNFe(FPDFeOwner).GetNomeModeloDFe, UF ,
    FPConfiguracoesNFe.WebServices.Ambiente, LayOutToServico(FPLayout),
    Versao, FPURL);

  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;

procedure TNFeEnvEvento.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'RecepcaoEvento';
  FPSoapAction := FPServico;
end;

procedure TNFeEnvEvento.DefinirDadosMsg;
var
  EventoNFe: TEventoNFe;
  I, J, F: integer;
  Lote, Evento, Eventos, EventosAssinados: String;
begin
  EventoNFe := TEventoNFe.Create;
  try
    EventoNFe.idLote := FidLote;

    {(*}
    for I := 0 to TNFeEnvEvento(Self).FEvento.Evento.Count - 1 do
    begin
      with EventoNFe.Evento.Add do
      begin
        infEvento.tpAmb := FPConfiguracoesNFe.WebServices.Ambiente;
        infEvento.CNPJ := FEvento.Evento[I].InfEvento.CNPJ;
        infEvento.cOrgao := FEvento.Evento[I].InfEvento.cOrgao;
        infEvento.chNFe := FEvento.Evento[I].InfEvento.chNFe;
        infEvento.dhEvento := FEvento.Evento[I].InfEvento.dhEvento;
        infEvento.tpEvento := FEvento.Evento[I].InfEvento.tpEvento;
        infEvento.nSeqEvento := FEvento.Evento[I].InfEvento.nSeqEvento;

        case InfEvento.tpEvento of
          teCCe:
          begin
            infEvento.detEvento.xCorrecao := FEvento.Evento[I].InfEvento.detEvento.xCorrecao;
            infEvento.detEvento.xCondUso := FEvento.Evento[I].InfEvento.detEvento.xCondUso;
          end;

          teCancelamento:
          begin
            infEvento.detEvento.nProt := FEvento.Evento[I].InfEvento.detEvento.nProt;
            infEvento.detEvento.xJust := FEvento.Evento[I].InfEvento.detEvento.xJust;
          end;

          teManifDestOperNaoRealizada:
            infEvento.detEvento.xJust := FEvento.Evento[I].InfEvento.detEvento.xJust;

          teEPECNFe:
          begin
            infEvento.detEvento.cOrgaoAutor := FEvento.Evento[I].InfEvento.detEvento.cOrgaoAutor;
            infEvento.detEvento.tpAutor := FEvento.Evento[I].InfEvento.detEvento.tpAutor;
            infEvento.detEvento.verAplic := FEvento.Evento[I].InfEvento.detEvento.verAplic;
            infEvento.detEvento.dhEmi := FEvento.Evento[I].InfEvento.detEvento.dhEmi;
            infEvento.detEvento.tpNF := FEvento.Evento[I].InfEvento.detEvento.tpNF;
            infEvento.detEvento.IE := FEvento.Evento[I].InfEvento.detEvento.IE;

            infEvento.detEvento.dest.UF := FEvento.Evento[I].InfEvento.detEvento.dest.UF;
            infEvento.detEvento.dest.CNPJCPF := FEvento.Evento[I].InfEvento.detEvento.dest.CNPJCPF;
            infEvento.detEvento.dest.idEstrangeiro := FEvento.Evento[I].InfEvento.detEvento.dest.idEstrangeiro;
            infEvento.detEvento.dest.IE := FEvento.Evento[I].InfEvento.detEvento.dest.IE;

            infEvento.detEvento.vNF := FEvento.Evento[I].InfEvento.detEvento.vNF;
            infEvento.detEvento.vICMS := FEvento.Evento[I].InfEvento.detEvento.vICMS;
            infEvento.detEvento.vST := FEvento.Evento[I].InfEvento.detEvento.vST;
          end;

          tePedProrrog1,
          tePedProrrog2:
          begin
            infEvento.detEvento.nProt := FEvento.Evento[I].InfEvento.detEvento.nProt;

            for j := 0 to FEvento.Evento.Items[I].InfEvento.detEvento.itemPedido.count - 1 do
            begin
              with infEvento.detEvento.itemPedido.Add do
              begin
                numItem := FEvento.Evento[I].InfEvento.detEvento.itemPedido.Items[J].numItem;
                qtdeItem := FEvento.Evento[I].InfEvento.detEvento.itemPedido.Items[J].qtdeItem;
              end;
            end;

          end;

          teCanPedProrrog1,
          teCanPedProrrog2:
          begin
            infEvento.detEvento.idPedidoCancelado := FEvento.Evento[I].InfEvento.detEvento.idPedidoCancelado;
            infEvento.detEvento.nProt := FEvento.Evento[I].InfEvento.detEvento.nProt;
          end;

        end;
      end;
    end;
    {*)}

    EventoNFe.Versao := FPVersaoServico;
    EventoNFe.GerarXML;

    // Separa os grupos <evento> e coloca na vari�vel Eventos
    I := Pos('<evento ', EventoNFe.Gerador.ArquivoFormatoXML);
    Lote := Copy(EventoNFe.Gerador.ArquivoFormatoXML, 1, I - 1);
    Eventos := SeparaDados(EventoNFe.Gerador.ArquivoFormatoXML, 'envEvento');
    I := Pos('<evento ', Eventos);
    Eventos := Copy(Eventos, I, length(Eventos));

    EventosAssinados := '';

    // Realiza a assinatura para cada evento
    while Eventos <> '' do
    begin
      F := Pos('</evento>', Eventos);

      if F > 0 then
      begin
        Evento := Copy(Eventos, 1, F + 8);
        Eventos := Copy(Eventos, F + 9, length(Eventos));

        AssinarXML(Evento, 'evento', 'infEvento', 'Falha ao assinar o Envio de Evento ');

        EventosAssinados := EventosAssinados + StringReplace(
          FPDadosMsg, '<?xml version="1.0"?>', '', []);
      end
      else
        Break;
    end;

    F := Pos('?>', EventosAssinados);
    if F <> 0 then
      FPDadosMsg := copy(EventosAssinados, 1, F + 1) + Lote +
        copy(EventosAssinados, F + 2, Length(EventosAssinados)) + '</envEvento>'
    else
      FPDadosMsg := Lote + EventosAssinados + '</envEvento>';

    with TACBrNFe(FPDFeOwner) do
    begin
      SSL.Validar(FPDadosMsg, GerarNomeArqSchema(FPLayout, StringToFloatDef(FPVersaoServico,0)), FPMsg);
    end;

    for I := 0 to FEvento.Evento.Count - 1 do
      FEvento.Evento[I].InfEvento.id := EventoNFe.Evento[I].InfEvento.id;
  finally
    EventoNFe.Free;
  end;
end;

function TNFeEnvEvento.TratarResposta: Boolean;
var
  Leitor: TLeitor;
  I, J: integer;
  wProc: TStringList;
  NomeArq, VersaoEvento: String;
begin
  FEvento.idLote := idLote;

  FPRetWS := SeparaDados(FPRetornoWS, 'nfeRecepcaoEventoResult');

  // Limpando variaveis internas
  FEventoRetorno.Free;
  FEventoRetorno := TRetEventoNFe.Create;

  EventoRetorno.Leitor.Arquivo := FPRetWS;
  EventoRetorno.LerXml;

  FcStat := EventoRetorno.cStat;
  FxMotivo := EventoRetorno.xMotivo;
  FPMsg := EventoRetorno.xMotivo;
  FTpAmb := EventoRetorno.tpAmb;

  Result := (EventoRetorno.cStat = 128) or (EventoRetorno.cStat = 135) or
    (EventoRetorno.cStat = 136) or (EventoRetorno.cStat = 155);

  //gerar arquivo proc de evento
  if Result then
  begin
    Leitor := TLeitor.Create;
    try
      for I := 0 to FEvento.Evento.Count - 1 do
      begin
        for J := 0 to EventoRetorno.retEvento.Count - 1 do
        begin
          if FEvento.Evento.Items[I].InfEvento.chNFe =
            EventoRetorno.retEvento.Items[J].RetInfEvento.chNFe then
          begin
            FEvento.Evento.Items[I].RetInfEvento.tpAmb :=
              EventoRetorno.retEvento.Items[J].RetInfEvento.tpAmb;
            FEvento.Evento.Items[I].RetInfEvento.nProt :=
              EventoRetorno.retEvento.Items[J].RetInfEvento.nProt;
            FEvento.Evento.Items[I].RetInfEvento.dhRegEvento :=
              EventoRetorno.retEvento.Items[J].RetInfEvento.dhRegEvento;
            FEvento.Evento.Items[I].RetInfEvento.cStat :=
              EventoRetorno.retEvento.Items[J].RetInfEvento.cStat;
            FEvento.Evento.Items[I].RetInfEvento.xMotivo :=
              EventoRetorno.retEvento.Items[J].RetInfEvento.xMotivo;

            wProc := TStringList.Create;
            try
              VersaoEvento := TACBrNFe(FPDFeOwner).LerVersaoDeParams(LayNfeEvento);

              wProc.Add('<' + ENCODING_UTF8 + '>');
              wProc.Add('<procEventoNFe versao="' + VersaoEvento +
                '" xmlns="http://www.portalfiscal.inf.br/nfe">');
              wProc.Add('<evento versao="' + VersaoEvento + '">');
              Leitor.Arquivo := FPDadosMsg;
              wProc.Add(Leitor.rExtrai(1, 'infEvento', '', I + 1));
              wProc.Add('<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">');

              Leitor.Arquivo := FPDadosMsg;
              wProc.Add(Leitor.rExtrai(1, 'SignedInfo', '', I + 1));

              Leitor.Arquivo := FPDadosMsg;
              wProc.Add(Leitor.rExtrai(1, 'SignatureValue', '', I + 1));

              Leitor.Arquivo := FPDadosMsg;
              wProc.Add(Leitor.rExtrai(1, 'KeyInfo', '', I + 1));
              wProc.Add('</Signature>');
              wProc.Add('</evento>');
              wProc.Add('<retEvento versao="' + VersaoEvento + '">');

              Leitor.Arquivo := FPRetWS;
              wProc.Add(Leitor.rExtrai(1, 'infEvento', '', J + 1));
              wProc.Add('</retEvento>');
              wProc.Add('</procEventoNFe>');

              EventoRetorno.retEvento.Items[J].RetInfEvento.XML := wProc.Text;

              FEvento.Evento.Items[I].RetInfEvento.XML := wProc.Text;

              NomeArq := OnlyNumber(FEvento.Evento.Items[i].InfEvento.Id) +
                '-procEventoNFe.xml';

//              if FPConfiguracoesNFe.Geral.Salvar then
//                FPDFeOwner.Gravar(NomeArq, wProc.Text);

              if FPConfiguracoesNFe.Arquivos.Salvar then
                FPDFeOwner.Gravar(NomeArq, wProc.Text, GerarPathEvento);
            finally
              wProc.Free;
            end;

            break;
          end;
        end;
      end;
    finally
      Leitor.Free;
    end;
  end;
end;

procedure TNFeEnvEvento.SalvarEnvio;
begin
  inherited SalvarEnvio;

  if FPConfiguracoesNFe.Geral.Salvar then
    FPDFeOwner.Gravar(GerarPrefixoArquivo + '-' + ArqEnv + '.xml',
      FPDadosMsg, GerarPathEvento);
end;

procedure TNFeEnvEvento.SalvarResposta;
begin
  inherited SalvarResposta;

  if FPConfiguracoesNFe.Geral.Salvar then
		FPDFeOwner.Gravar(GerarPrefixoArquivo + '-' + ArqEnv + '.xml',
			FPDadosMsg, GerarPathEvento);
end;

function TNFeEnvEvento.GerarMsgLog: String;
var
  aMsg: String;
begin
  {(*}
  aMsg := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                         'Ambiente: %s ' + LineBreak +
                         'Vers�o Aplicativo: %s ' + LineBreak +
                         'Status C�digo: %s ' + LineBreak +
                         'Status Descri��o: %s ' + LineBreak),
                 [FEventoRetorno.versao, TpAmbToStr(FEventoRetorno.tpAmb),
                  FEventoRetorno.verAplic, IntToStr(FEventoRetorno.cStat),
                  FEventoRetorno.xMotivo]);

  if FEventoRetorno.retEvento.Count > 0 then
    aMsg := aMsg + Format(ACBrStr('Recebimento: %s ' + LineBreak),
       [IfThen(FEventoRetorno.retEvento.Items[0].RetInfEvento.dhRegEvento = 0, '',
               FormatDateTimeBr(FEventoRetorno.retEvento.Items[0].RetInfEvento.dhRegEvento))]);

  Result := aMsg;
  {*)}
end;

function TNFeEnvEvento.GerarPrefixoArquivo: String;
begin
  Result := IntToStr(FEvento.idLote);
end;

{ TNFeConsNFeDest }

constructor TNFeConsNFeDest.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FretConsNFeDest := TretConsNFeDest.Create;

  FPStatus := stConsNFeDest;
  FPLayout := LayNFeConsNFeDest;
  FPArqEnv := 'con-nfe-dest';
  FPArqResp := 'nfe-dest';
end;

destructor TNFeConsNFeDest.Destroy;
begin
  FretConsNFeDest.Free;

  inherited Destroy;
end;

procedure TNFeConsNFeDest.DefinirURL;
var
  UF : String;
  Versao: Double;
begin
  { Esse m�todo � tratado diretamente pela RFB }

  UF := 'AN';

  Versao := 0;
  FPVersaoServico := '';
  FPURL := '';
  Versao := VersaoDFToDbl(FPConfiguracoesNFe.Geral.VersaoDF);

  TACBrNFe(FPDFeOwner).LerServicoDeParams(TACBrNFe(FPDFeOwner).GetNomeModeloDFe, UF ,
    FPConfiguracoesNFe.WebServices.Ambiente, LayOutToServico(FPLayout),
    Versao, FPURL);

  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;

procedure TNFeConsNFeDest.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'NfeConsultaDest';
  FPSoapAction := FPServico + '/nfeConsultaNFDest';
end;

procedure TNFeConsNFeDest.DefinirDadosMsg;
var
  ConsNFeDest: TConsNFeDest;
begin
  ConsNFeDest := TConsNFeDest.Create;
  try
    ConsNFeDest.TpAmb := FPConfiguracoesNFe.WebServices.Ambiente;
    ConsNFeDest.CNPJ := FCNPJ;
    ConsNFeDest.indNFe := FindNFe;
    ConsNFeDest.indEmi := FindEmi;
    ConsNFeDest.ultNSU := FultNSU;
    ConsNFeDest.Versao := FPVersaoServico;
    ConsNFeDest.GerarXML;

    FPDadosMsg := ConsNFeDest.Gerador.ArquivoFormatoXML;
  finally
    ConsNFeDest.Free;
  end;
end;

function TNFeConsNFeDest.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'nfeConsultaNFDestResult');

  // Limpando variaveis internas
  FretConsNFeDest.Free;
  FretConsNFeDest := TRetConsNFeDest.Create;

  FretConsNFeDest.Leitor.Arquivo := FPRetWS;
  FretConsNFeDest.LerXml;

  FPMsg := FretConsNFeDest.xMotivo;

  Result := (FretConsNFeDest.CStat = 137) or (FretConsNFeDest.CStat = 138);
end;

function TNFeConsNFeDest.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'Recebimento: %s ' + LineBreak +
                           'Ind. Continua��o: %s ' + LineBreak +
                           '�ltimo NSU: %s ' + LineBreak),
                   [FretConsNFeDest.versao, TpAmbToStr(FretConsNFeDest.tpAmb),
                    FretConsNFeDest.verAplic, IntToStr(FretConsNFeDest.cStat),
                    FretConsNFeDest.xMotivo,
                    IfThen(FretConsNFeDest.dhResp = 0, '', FormatDateTimeBr(RetConsNFeDest.dhResp)),
                    IndicadorContinuacaoToStr(FretConsNFeDest.indCont),
                    FretConsNFeDest.ultNSU]);
  {*)}
end;

function TNFeConsNFeDest.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService Consulta NF-e Destinadas:' + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

{ TNFeDownloadNFe }

constructor TNFeDownloadNFe.Create(AOwner: TACBrDFe; ADownload: TDownloadNFe);
begin
  inherited Create(AOwner);

  FRetDownloadNFe := TretDownloadNFe.Create;
  FDownload := ADownload;

  FPStatus := stDownloadNFe;
  FPLayout := LayNFeDownloadNFe;
  FPArqEnv := 'ped-down-nfe';
  FPArqResp := 'down-nfe';
end;

destructor TNFeDownloadNFe.Destroy;
begin
  FRetDownloadNFe.Free;

  inherited Destroy;
end;

procedure TNFeDownloadNFe.DefinirURL;
var
  UF : String;
  Versao: Double;
begin
  { Esse m�todo � tratado diretamente pela RFB }

  UF := 'AN';

  Versao := 0;
  FPVersaoServico := '';
  FPURL := '';
  Versao := VersaoDFToDbl(FPConfiguracoesNFe.Geral.VersaoDF);

  TACBrNFe(FPDFeOwner).LerServicoDeParams(TACBrNFe(FPDFeOwner).GetNomeModeloDFe, UF ,
    FPConfiguracoesNFe.WebServices.Ambiente, LayOutToServico(FPLayout),
    Versao, FPURL);

  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;

procedure TNFeDownloadNFe.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'NfeDownloadNF';
  FPSoapAction := FPServico + '/nfeDownloadNF';
end;

procedure TNFeDownloadNFe.DefinirDadosMsg;
var
  DownloadNFe: TDownloadNFe;
  I: integer;
begin
  DownloadNFe := TDownloadNFe.Create;
  try
    DownloadNFe.TpAmb := FPConfiguracoesNFe.WebServices.Ambiente;
    DownloadNFe.CNPJ := FDownload.CNPJ;

    for I := 0 to FDownload.Chaves.Count - 1 do
    begin
      with DownloadNFe.Chaves.Add do
      begin
        chNFe := FDownload.Chaves[I].chNFe;
      end;
    end;

    DownloadNFe.Versao := FPVersaoServico;
    DownloadNFe.GerarXML;

    FPDadosMsg := DownloadNFe.Gerador.ArquivoFormatoXML;
  finally
    DownloadNFe.Free;
  end;
end;

function TNFeDownloadNFe.TratarResposta: Boolean;
var
  I: integer;
  NomeArq: String;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'nfeDownloadNFResult');

  // Limpando variaveis internas
  FretDownloadNFe.Free;
  FRetDownloadNFe := TRetDownloadNFe.Create;

  FRetDownloadNFe.Leitor.Arquivo := FPRetWS;
  FRetDownloadNFe.LerXml;

  FPMsg := FretDownloadNFe.xMotivo;

  Result := (FRetDownloadNFe.cStat = 139);

  for I := 0 to FRetDownloadNFe.retNFe.Count - 1 do
  begin
    if FRetDownloadNFe.retNFe.Items[I].cStat = 140 then
    begin
      NomeArq := FRetDownloadNFe.retNFe.Items[I].chNFe + '-nfe.xml';
      FPDFeOwner.Gravar(NomeArq, FRetDownloadNFe.retNFe.Items[I].procNFe,
                        GerarPathDownload(FRetDownloadNFe.retNFe.Items[I]));
    end;
  end;
end;

function TNFeDownloadNFe.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'Recebimento: %s ' + LineBreak),
                   [FretDownloadNFe.versao, TpAmbToStr(FretDownloadNFe.tpAmb),
                    FretDownloadNFe.verAplic, IntToStr(FretDownloadNFe.cStat),
                    FretDownloadNFe.xMotivo,
                    IfThen(FretDownloadNFe.dhResp = 0, '',
                           FormatDateTimeBr(FRetDownloadNFe.dhResp))]);
  {*)}
end;

function TNFeDownloadNFe.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService Download de NF-e:' + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

function TNFeDownloadNFe.GerarPathDownload(AItem :TRetNFeCollectionItem): String;
var
  Data: TDateTime;
begin
  if FPConfiguracoesNFe.Arquivos.EmissaoPathNFe then
    Data := AItem.dhEmi
  else
    Data := Now;

  Result := FPConfiguracoesNFe.Arquivos.GetPathDownload('',
                                                        Copy(AItem.chNFe,7,14),
                                                        Data);
end;

{ TAdministrarCSCNFCe }

constructor TAdministrarCSCNFCe.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FretAdmCSCNFCe := TretAdmCSCNFCe.Create;

  FPStatus := stAdmCSCNFCe;
  FPLayout := LayAdministrarCSCNFCe;
  FPArqEnv := 'ped-csc';
  FPArqResp := 'csc';
end;

destructor TAdministrarCSCNFCe.Destroy;
begin
  FretAdmCSCNFCe.Free;

  inherited Destroy;
end;

procedure TAdministrarCSCNFCe.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'CscNFCe';
  FPSoapAction := FPServico + '/admCscNFCe';
end;

procedure TAdministrarCSCNFCe.DefinirDadosMsg;
var
  AdmCSCNFCe: TAdmCSCNFCe;
begin
  AdmCSCNFCe := TAdmCSCNFCe.Create;
  try
    AdmCSCNFCe.TpAmb := FPConfiguracoesNFe.WebServices.Ambiente;
    AdmCSCNFCe.RaizCNPJ := FRaizCNPJ;
    AdmCSCNFCe.indOP := FindOp;
    AdmCSCNFCe.idCsc := FIdCSC;
    AdmCSCNFCe.codigoCsc := FCodigoCSC;

    AdmCSCNFCe.Versao := FPVersaoServico;
    AdmCSCNFCe.GerarXML;

    FPDadosMsg := AdmCSCNFCe.Gerador.ArquivoFormatoXML;
  finally
    AdmCSCNFCe.Free;
  end;
end;

function TAdministrarCSCNFCe.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'admCscNFCeResult');

  // Limpando variaveis internas
  FretAdmCSCNFCe.Free;
  FretAdmCSCNFCe := TRetAdmCSCNFCe.Create;

  FretAdmCSCNFCe.Leitor.Arquivo := FPRetWS;
  FretAdmCSCNFCe.LerXml;

  FPMsg := FretAdmCSCNFCe.xMotivo;

  Result := (FretAdmCSCNFCe.CStat in [150..153]);
end;

function TAdministrarCSCNFCe.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak),
                   [FretAdmCSCNFCe.versao, TpAmbToStr(FretAdmCSCNFCe.tpAmb),
                    IntToStr(FretAdmCSCNFCe.cStat), FretAdmCSCNFCe.xMotivo]);
  {*)}
end;

function TAdministrarCSCNFCe.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService Administrar CSC da NFC-e:' + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

{ TDistribuicaoDFe }

constructor TDistribuicaoDFe.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FretDistDFeInt := TretDistDFeInt.Create;

  FPStatus := stDistDFeInt;
  FPLayout := LayDistDFeInt;
  FPArqEnv := 'con-dist-dfe';
  FPArqResp := 'dist-dfe';
  FPBodyElement := 'nfeDistDFeInteresse';
  FPHeaderElement := '';
end;

destructor TDistribuicaoDFe.Destroy;
begin
  FretDistDFeInt.Free;

  inherited;
end;

procedure TDistribuicaoDFe.DefinirURL;
var
  UF : String;
  Versao: Double;
begin
  { Esse m�todo � tratado diretamente pela RFB }

  UF := 'AN';

  Versao := 0;
  FPVersaoServico := '';
  FPURL := '';
  Versao := VersaoDFToDbl(FPConfiguracoesNFe.Geral.VersaoDF);

  TACBrNFe(FPDFeOwner).LerServicoDeParams(TACBrNFe(FPDFeOwner).GetNomeModeloDFe, UF ,
    FPConfiguracoesNFe.WebServices.Ambiente, LayOutToServico(FPLayout),
    Versao, FPURL);

  FPVersaoServico := FloatToString(Versao, '.', '0.00');
end;

procedure TDistribuicaoDFe.DefinirServicoEAction;
begin
  FPServico := GetUrlWsd + 'NFeDistribuicaoDFe';
  FPSoapAction := FPServico + '/nfeDistDFeInteresse';
end;

procedure TDistribuicaoDFe.DefinirDadosMsg;
var
  DistDFeInt: TDistDFeInt;
begin
  DistDFeInt := TDistDFeInt.Create;
  try
    DistDFeInt.TpAmb := FPConfiguracoesNFe.WebServices.Ambiente;
    DistDFeInt.cUFAutor := FcUFAutor;
    DistDFeInt.CNPJCPF := FCNPJCPF;
    DistDFeInt.ultNSU := FultNSU;
    DistDFeInt.NSU := FNSU;
    DistDFeInt.Versao := FPVersaoServico;
    DistDFeInt.GerarXML;

    FPDadosMsg := DistDFeInt.Gerador.ArquivoFormatoXML;
  finally
    DistDFeInt.Free;
  end;
end;

function TDistribuicaoDFe.TratarResposta: Boolean;
var
  I: integer;
  AXML, NomeArq: String;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'nfeDistDFeInteresseResult');

  // Limpando variaveis internas
  FretDistDFeInt.Free;
  FretDistDFeInt := TRetDistDFeInt.Create;

  FretDistDFeInt.Leitor.Arquivo := FPRetWS;
  FretDistDFeInt.LerXml;

  FPMsg := FretDistDFeInt.xMotivo;
  Result := (FretDistDFeInt.CStat = 137) or (FretDistDFeInt.CStat = 138);

  for I := 0 to FretDistDFeInt.docZip.Count - 1 do
  begin
    AXML := FretDistDFeInt.docZip.Items[I].XML;
    NomeArq := '';
    if (AXML <> '') then
    begin
      case FretDistDFeInt.docZip.Items[I].schema of
        schresNFe:
          NomeArq := FretDistDFeInt.docZip.Items[I].resNFe.chNFe + '-resNFe.xml';
        schresEvento:
          NomeArq := OnlyNumber(TpEventoToStr(FretDistDFeInt.docZip.Items[I].resEvento.tpEvento) +
             FretDistDFeInt.docZip.Items[I].resEvento.chNFe +
             Format('%.2d', [FretDistDFeInt.docZip.Items[I].resEvento.nSeqEvento])) +
             '-resEventoNFe.xml';
        schprocNFe:
          NomeArq := FretDistDFeInt.docZip.Items[I].resNFe.chNFe + '-nfe.xml';
        schprocEventoNFe:
          NomeArq := OnlyNumber(FretDistDFeInt.docZip.Items[I].procEvento.Id) +
            '-procEventoNFe.xml';
      end;

      if (FPConfiguracoesNFe.Arquivos.Salvar) and NaoEstaVazio(NomeArq) then
        FPDFeOwner.Gravar(NomeArq, AXML, GerarPathDistribuicao(FretDistDFeInt.docZip.Items[I]));
    end;
  end;
end;

function TDistribuicaoDFe.GerarMsgLog: String;
begin
  {(*}
  Result := Format(ACBrStr('Vers�o Layout: %s ' + LineBreak +
                           'Ambiente: %s ' + LineBreak +
                           'Vers�o Aplicativo: %s ' + LineBreak +
                           'Status C�digo: %s ' + LineBreak +
                           'Status Descri��o: %s ' + LineBreak +
                           'Resposta: %s ' + LineBreak +
                           '�ltimo NSU: %s ' + LineBreak +
                           'M�ximo NSU: %s ' + LineBreak),
                   [FretDistDFeInt.versao, TpAmbToStr(FretDistDFeInt.tpAmb),
                    FretDistDFeInt.verAplic, IntToStr(FretDistDFeInt.cStat),
                    FretDistDFeInt.xMotivo,
                    IfThen(FretDistDFeInt.dhResp = 0, '',
                           FormatDateTimeBr(RetDistDFeInt.dhResp)),
                    FretDistDFeInt.ultNSU, FretDistDFeInt.maxNSU]);
  {*)}
end;

function TDistribuicaoDFe.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService Distribui��o de DFe:' + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

function TDistribuicaoDFe.GerarPathDistribuicao(AItem: TdocZipCollectionItem): String;
var
  Data: TDateTime;
begin
  if FPConfiguracoesNFe.Arquivos.EmissaoPathNFe then
    Data := AItem.resNFe.dhEmi
  else
    Data := Now;

  Result := FPConfiguracoesNFe.Arquivos.GetPathDownload(AItem.resNFe.xNome,
                                                        AItem.resNFe.CNPJCPF,
                                                        Data);
end;

{ TNFeEnvioWebService }

constructor TNFeEnvioWebService.Create(AOwner: TACBrDFe);
begin
  inherited Create(AOwner);

  FPStatus := stEnvioWebService;
  FVersao := '';
end;

destructor TNFeEnvioWebService.Destroy;
begin
  inherited Destroy;
end;

function TNFeEnvioWebService.Executar: Boolean;
begin
  Result := inherited Executar;
end;

procedure TNFeEnvioWebService.DefinirURL;
begin
  FPURL := FPURLEnvio;
end;

procedure TNFeEnvioWebService.DefinirServicoEAction;
begin
  FPServico := FPSoapAction;
end;

procedure TNFeEnvioWebService.DefinirDadosMsg;
var
  LeitorXML: TLeitor;
begin
  LeitorXML := TLeitor.Create;
  try
    LeitorXML.Arquivo := FXMLEnvio;
    LeitorXML.Grupo := FXMLEnvio;
    FVersao := LeitorXML.rAtributo('versao')
  finally
    LeitorXML.Free;
  end;

  FPDadosMsg := FXMLEnvio;
end;

function TNFeEnvioWebService.TratarResposta: Boolean;
begin
  FPRetWS := SeparaDados(FPRetornoWS, 'soap:Body');
  Result := True;
end;

function TNFeEnvioWebService.GerarMsgErro(E: Exception): String;
begin
  Result := ACBrStr('WebService: '+FPServico + LineBreak +
                    '- Inativo ou Inoperante tente novamente.');
end;

function TNFeEnvioWebService.GerarVersaoDadosSoap: String;
begin
  Result := '<versaoDados>' + FVersao + '</versaoDados>';
end;

{ TWebServices }

constructor TWebServices.Create(AOwner: TACBrDFe);
begin
  FACBrNFe := TACBrNFe(AOwner);

  FStatusServico := TNFeStatusServico.Create(FACBrNFe);
  FEnviar := TNFeRecepcao.Create(FACBrNFe, TACBrNFe(FACBrNFe).NotasFiscais);
  FRetorno := TNFeRetRecepcao.Create(FACBrNFe, TACBrNFe(FACBrNFe).NotasFiscais);
  FRecibo := TNFeRecibo.Create(FACBrNFe);
  FConsulta := TNFeConsulta.Create(FACBrNFe);
  FInutilizacao := TNFeInutilizacao.Create(FACBrNFe);
  FConsultaCadastro := TNFeConsultaCadastro.Create(FACBrNFe);
  FEnvEvento := TNFeEnvEvento.Create(FACBrNFe, TACBrNFe(FACBrNFe).EventoNFe);
  FConsNFeDest := TNFeConsNFeDest.Create(FACBrNFe);
  FDownloadNFe := TNFeDownloadNFe.Create(FACBrNFe, TACBrNFe(
    FACBrNFe).DownloadNFe.Download);
  FAdministrarCSCNFCe := TAdministrarCSCNFCe.Create(FACBrNFe);
  FDistribuicaoDFe := TDistribuicaoDFe.Create(FACBrNFe);
  FEnvioWebService := TNFeEnvioWebService.Create(FACBrNFe);
end;

destructor TWebServices.Destroy;
begin
  FStatusServico.Free;
  FEnviar.Free;
  FRetorno.Free;
  FRecibo.Free;
  FConsulta.Free;
  FInutilizacao.Free;
  FConsultaCadastro.Free;
  FEnvEvento.Free;
  FConsNFeDest.Free;
  FDownloadNFe.Free;
  FAdministrarCSCNFCe.Free;
  FDistribuicaoDFe.Free;
  FEnvioWebService.Free;

  inherited Destroy;
end;

function TWebServices.Envia(ALote: integer; const ASincrono: Boolean): Boolean;
begin
  Result := Envia(IntToStr(ALote), ASincrono);
end;

function TWebServices.Envia(ALote: String; const ASincrono: Boolean): Boolean;
begin
  FEnviar.FLote := ALote;
  FEnviar.FSincrono := ASincrono;

  if not Enviar.Executar then
    Enviar.GerarException( Enviar.Msg );

  if not ASincrono then
  begin
    FRetorno.Recibo := FEnviar.Recibo;
    if not FRetorno.Executar then
      FRetorno.GerarException( FRetorno.Msg );
  end;

  Result := True;
end;

procedure TWebServices.Inutiliza(CNPJ, AJustificativa: String;
  Ano, Modelo, Serie, NumeroInicial, NumeroFinal: integer);
begin
  CNPJ := OnlyNumber(CNPJ);

  if not ValidarCNPJ(CNPJ) then
    raise EACBrNFeException.Create('CNPJ: ' + CNPJ + ', inv�lido.');

  FInutilizacao.CNPJ := CNPJ;
  FInutilizacao.Modelo := Modelo;
  FInutilizacao.Serie := Serie;
  FInutilizacao.Ano := Ano;
  FInutilizacao.NumeroInicial := NumeroInicial;
  FInutilizacao.NumeroFinal := NumeroFinal;
  FInutilizacao.Justificativa := AJustificativa;

  if not FInutilizacao.Executar then
    FInutilizacao.GerarException( FInutilizacao.Msg );
end;

end.