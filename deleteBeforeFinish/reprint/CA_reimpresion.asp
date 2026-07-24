<%@ LANGUAGE = VBScript %>
<%Option Explicit %>
<!--#include File="../../Include/inicio.inc"-->
<!--#include File="../../Include/util.inc"-->
<!--#include File="../../Include/ModGlb.inc"-->
<!--#include File="../../Include/Menu.inc"-->
<!--#include File="../../Include/const.inc"-->
<!--#include File="../../Include/funciones_vbscript.inc"-->
<!--#include File="../../Include/fondo.inc"-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<%

'Declaración de constantes


'DECLARACION DE VARIABLES

Dim nro_tran, fecha_consulta, fecha, cod_trans, desc_trans, VLNombre, VLFactura, VLEmpresa, VLNumtarjeta
Dim arrDescripTemp, arrFechaTemp, VLEmpresaTemp

Dim strDescrip
Dim strFecha
Dim strHora
Dim strMonto
Dim strCuenta
Dim strSecuencial
Dim strCodigo
Dim arrayFecha, arrayF, arrayHora
Dim nroCuenta
Dim strTipoCuenta
Dim strArray
Dim strTipoOperacion
Dim strRemesa
Dim strEmpresa
Dim strNombre
Dim strServicio
Dim intResultado
Dim strIdBitacora
Dim strNombreEmpresa,strTran,R1,ref1,R2,ref2,R3,ref3,R4,ref4,R5,ref5,strTotal,reso1,reso2,reso3,reso4,reso5,reso6,strOficina,strCajaRural
Dim esp
Dim strCuentaR
Dim strFechaR
Dim strUsuarioR
Dim strHoraR
Dim VLTipoCliente
Dim nombreEmpresa_retiros_gen
Dim strLinea1, strLinea2,strLinea3
Dim arrDatosCom
Dim refCom
Dim medioEnvioOfuscado
Dim ComisionClienteCXCA 'celd2023 
Dim MontoComisionCXCA 'celd2023 
Dim NoBoletaComisionCXCA 'celd2023 
Dim tarjetaOfuscada 'loaao 30052025
Dim DPIOfuscado 'loaao 30052025
Dim cuentaOfuscada 'loaao 30052025


'inicializacion de valores
'para la consulta del detalle de boleta

	nro_tran = Request.Form("hdNoTransaccion")  'numero unico que identifica a cada transaccion
	fecha_consulta= Request.Form("hdFecha")
	cod_trans= Request.Form("hdCodTran")
	nroCuenta =  Request.Form("hdCuenta")
	esp = " "	
 


%>


<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML//EN">
<html>

<head>
<title>Reimpresiones</title>
<% FilesMenu %>

</head>
<link rel=stylesheet type="text/css" href="../../css/estilos.css">
<body background="<%=Session("VGPathImg")%>tabla_left.gif" leftmargin="0" topmargin="0" marginwidth ="0" marginheight ="0" >

<style type="text/css">
 .textoRef{
      display: flex;
      flex-direction: row;
      justify-content: center;
      align-items: center;
  }
  @media print {
    .oculto {display:none}
  }
   .textoCGC{ 
        color: black; 
        font-size: 9; 
        font-weight: 500; 
        font-family: verdana  
    }
	.textoImpresionMaycom {font-size: 9; font-weight: 500; font-family: verdana;}
	.textoImpresionSecuencial {font-size: 15; font-weight: bold; font-family: verdana;}
</style>

<script language="JavaScript">
	function Imprimir(tipoImpresion)
	{
		//Impresion Hibrida
		if (tipoImpresion ==0) {
			var seleccionTipoImpresion;
			seleccionTipoImpresion = document.getElementsByName("chValida");
			if(seleccionTipoImpresion[0].checked){
				document.getElementById('boleta1').border = '0';
				document.getElementById('boleta2').border = '0';
				document.getElementById('tbPrint').style.display = 'none';
				document.getElementById('dvPrint').style.display = 'block';
				document.getElementById('tbTipoImpresion').style.display = 'none';

				window.print();
				document.getElementById('boleta1').border = '1';
				document.getElementById('boleta2').border = '1';
				document.getElementById('tbPrint').style.display =  'block';
				document.getElementById('dvPrint').style.display = 'none';
				document.getElementById('tbTipoImpresion').style.display = 'block';	
			}else{
				document.getElementById('boleta3').border = '0';
				document.getElementById('tbPrint').style.display = 'none';
				document.getElementById('tbTipoImpresion').style.display = 'none';
				window.print();
				document.getElementById('boleta3').border = '1';
				document.getElementById('tbPrint').style.display =  'block';
				document.getElementById('tbTipoImpresion').style.display = 'block';	
			}
		//Impresion Termica
		}else if (tipoImpresion== 2){
			document.getElementById('boleta3').border = '0';
			document.getElementById('tbPrint').style.display = 'none';
			window.print();
			document.getElementById('boleta3').border = '1';
			document.getElementById('tbPrint').style.display =  'block';
		//Impresion Tinta
		}else{
			document.getElementById('boleta1').border = '0';
			document.getElementById('boleta2').border = '0';
			document.getElementById('tbPrint').style.display = 'none';
			document.getElementById('dvPrint').style.display = 'block';
			window.print();
			document.getElementById('boleta1').border = '1';
			document.getElementById('boleta2').border = '1';
			document.getElementById('tbPrint').style.display =  'block';
			document.getElementById('dvPrint').style.display = 'none';
		}
	}

	function validaTipoImpresion(tipoImpresion)
	{
		var seleccionTipoImpresion;
		seleccionTipoImpresion = document.getElementsByName("chValida");
		if (tipoImpresion == 1) {
			seleccionTipoImpresion[0].checked = true;
			seleccionTipoImpresion[1].checked = false;														 
			document.getElementById('boleta3').style.display = 'none';
			document.getElementById('boleta1').style.display = 'block';								 
			document.getElementById('boleta1_info').style.display = 'block';
		}
		if (tipoImpresion==2){			
			seleccionTipoImpresion[0].checked = false;
			seleccionTipoImpresion[1].checked = true;
			document.getElementById('boleta1').style.display = 'none';
			document.getElementById('boleta1_info').style.display = 'none';
			document.getElementById('boleta3').style.display = 'block';

		}
																	
															
	}

	function ImprimirComision(tipoImpresion) {
			if (tipoImpresion ==0) {
			var seleccionTipoImpresion;
			seleccionTipoImpresion = document.getElementsByName("chValida");
			//Selecciona impresion Tinta
			if(seleccionTipoImpresion[0].checked){

				document.getElementById('boleta1').border = '0';
				document.getElementById('boleta2').border = '0';
				document.getElementById('boleta3').style.display = 'none';
				document.getElementById('tbPrint').style.display = 'none';
				document.getElementById('dvPrint').style.display = 'block';
				document.getElementById('dvPrintComisionTermica').style.display = 'none';
            	document.getElementById('dvPrintComision').style.display = 'block';
				document.getElementById('tbTipoImpresion').style.display = 'none';
				window.print();
				document.getElementById('boleta1').border = '1';
				document.getElementById('boleta2').border = '1';
				document.getElementById('tbPrint').style.display = 'block';
				document.getElementById('dvPrintComision').style.display = 'none';
				document.getElementById('boleta3').style.display = 'none';
				document.getElementById('dvPrintComisionTermica').style.display = 'none';
				document.getElementById('dvPrint').style.display = 'none';
				document.getElementById('tbTipoImpresion').style.display = 'block';	
				//Selecciona Impresion Termica
			}else{

				document.getElementById('boleta3').style.display = 'block';
				document.getElementById('boleta3').border = '0';
            	document.getElementById('tbPrint').style.display = 'none';
            	document.getElementById('dvPrint').style.display = 'none';
				document.getElementById('tbPrint').style.display = 'none';
				document.getElementById('tbTipoImpresion').style.display = 'none';
				document.getElementById('dvPrintComisionTermica').style.display = 'block';											   
				document.getElementById('boletaComision3').border = '0';
	
				window.print();
				document.getElementById('boleta3').border = '1';
				document.getElementById('tbPrint').style.display =  'block';
				document.getElementById('tbTipoImpresion').style.display = 'block';	
				document.getElementById('boleta3').style.display = 'block';
				document.getElementById('dvPrintComisionTermica').style.display = 'none';
			}
		//Impresion Termica
		}else if (tipoImpresion== 2){
			
				document.getElementById('boleta3').style.display = 'block';
				document.getElementById('boleta3').border = '0';
            	document.getElementById('tbPrint').style.display = 'none';
				document.getElementById('dvPrintComisionTermica').style.display = 'block';
				document.getElementById('boletaComision3').border = '0';
	
				window.print();
				document.getElementById('boleta3').border = '1';
				document.getElementById('boleta3').style.display = 'block';
				document.getElementById('dvPrintComisionTermica').style.display = 'none';
				document.getElementById('tbPrint').style.display =  'block';

		//Impresion Tinta
		}else{

			
			document.getElementById('boleta1').border = '0';
			document.getElementById('boleta2').border = '0';
			document.getElementById('tbPrint').style.display = 'none';
			document.getElementById('dvPrint').style.display = 'block';
			document.getElementById('dvPrintComision').style.display = 'block';
			window.print();
			document.getElementById('boleta1').border = '1';
			document.getElementById('boleta2').border = '1';
			document.getElementById('tbPrint').style.display = 'block';
			document.getElementById('dvPrintComision').style.display = 'none';
			document.getElementById('dvPrint').style.display = 'none';

		}
	}
</script>
<%
	'-------VALIDACION DE PERMISO PARA REALIZAR LA TRANSACCION--------------------------
	'If Not Verifica_Acceso(REIMPRESION_DE_BOLETAS, Session("VGLogin"), Session("VG_Oficina")) then
	'	Call DibujaTablaError(MENSAJE_ERROR_ACCESO, 1, "../../blank.asp", "../../images")

	'Response.end
	'end if
%>
  
		<%
		
		if cod_trans = 18152 or cod_trans = 18150 or cod_trans = 18253  or cod_trans = 18255 or cod_trans = 18156  or cod_trans = 18155 or cod_trans = 18157 or cod_trans = 18158 or cod_trans = 18159 or cod_trans = 18160 or cod_trans = 19653 or cod_trans = 18161 or cod_trans = 18162 or cod_trans = 18163 or cod_trans = 18165 or cod_trans = 18166 or cod_trans = 19371 or cod_trans = 18258 or cod_trans = 18167  then
			Call ReimpremeCobroEmp(nro_tran)
		end if	

		if cod_trans = 18150 then 'celd2023 
			call ConsultaTipoComisionCXCA (strCuentaR, strTran ) 'se llama a metodo para identificar el tipo de comision  de la transaccion  del cxca 
			if ComisionClienteCXCA = "S" then 'si la transaccion del cxca tiene configurada comision al cliente se consultan los datos en la bitacora de comisiones 
				Call ConsultaDatosComisionCXCA(strTran,nro_tran)
			end if 
		end if 
		
	On Error Resume Next
	call DatosBoleta
	Call CltaPagoComision()
	If Err.number<>0 then
			Call DibujaTablaError(MENSAJE_ERROR_WS, 1, "CA_Reimpresion_boleta.asp", "../../images")
		Response.End
	End If
	'Impresion Termica
		if Session("VG_Impresion")="2" then 'aqui tiene que ir el 2
					PLReciboTermica "boleta3", "display:block"
  
		%>
		
		<%if (cod_trans = 18102 or cod_trans = 18156 or cod_trans = 18155 or cod_trans = 18157 or cod_trans = 18158 or cod_trans = 18159 or cod_trans = 18160 or cod_trans = 18161 or cod_trans = 18162 or cod_trans = 18166)  and refCom = 0  then %>
			<div style="display:block" id="dvPrintComisionTermica">
				
				<%if cod_trans = 18160 or cod_trans = 18161  or cod_trans = 18162 then %>
					
						<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
						<%BoletaComisionTermica ("boletaComision3")%>
					</div>

				<%else%>
					<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
					<%BoletaComisionTermica ("boletaComision3")%>
				<%end if%>
			</div>
		<% end if%>
		<%if cod_trans = 18150  then 'celd2023 llamado a metodo de impresion de boleta de comision para cxca %>
			<%if ComisionClienteCXCA = "S"  then%>
				<div style="display:none" id="dvPrintComisionTermica">
					<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
					<%BoletaComisionTermicaCXCA ("boletaComision3")%>
				</div>
			<% end if%>
		<% end if%>
			
		<center>   
		  <table name="tbPrint" id="tbPrint" style="display:block">
		    <td height="65" align="center"> 
				<a href="CA_Reimpresion_boleta.asp" onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('Regresar1','','../../images/regresaron.gif',1);" ><img name="regresar1" src="../../images/regresaroff.gif" border="0"></a>	
			</td>
			<%if (cod_trans = 18102 or cod_trans = 18156 or cod_trans = 18155 or cod_trans = 18157 or cod_trans = 18158  or cod_trans = 18159 or cod_trans = 18160 or cod_trans = 18161 or cod_trans = 18162 or cod_trans = 18166)  and refCom = 0 then %>
				<td>
					<a onClick="ImprimirComision(2);" onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('imprimir','','../../images/imprimiron.gif',1);" ><input type="image" value="Imprimir"Img name="imprimir" src="../../images/imprimiroff.gif" height="60" border="0"></a> 
				</td>
			<%
			else
			'celd2023 
			%>
				<%if cod_trans = 18150 and ComisionClienteCXCA = "S"  then %>
					<td>
						<a onClick="ImprimirComision(2);" onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('imprimir','','../../images/imprimiron.gif',1);" ><input type="image" value="Imprimir"Img name="imprimir" src="../../images/imprimiroff.gif" height="60" border="0"></a> 
					</td>
				<%else %>
					<td>
						<a onClick="Imprimir(2);" onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('imprimir','','../../images/imprimiron.gif',1);" ><input type="image" value="Imprimir"Img name="imprimir" src="../../images/imprimiroff.gif" height="60" border="0"></a> 
					</td>
				<% end if%>

			<% end if%>
			</table>
		</center> 

		<%
		'Impresion Hibrida
		elseif Session("VG_Impresion")="0" then 'aqui tiene que ir el 0
			PLRecibo ("boleta1")
			PLReciboTermica "boleta3", "display:none"
		%>
		<div style="display:none" id="dvPrint">
			<%if cod_trans = 18160 or cod_trans = 18161 then  %>
				<% PLRecibo ("boleta2") %>
			<%Elseif cod_trans = 18163 then %> 
				<br><br>
				<% PLRecibo ("boleta2") %> 
			<%Elseif cod_trans = 19371 then %>
				<br><br>
				<% PLRecibo ("boleta2") %> 
			<%else%>
				<br><br><br> 
				<% PLRecibo ("boleta2") %> 
			<%end if%>
			
		</div>
		<%if (cod_trans = 18102 or cod_trans = 18156 or cod_trans = 18155 or cod_trans = 18157 or cod_trans = 18158 or cod_trans = 18159 or cod_trans = 18160 or cod_trans = 18161 or cod_trans = 18162 or cod_trans = 18166)  and refCom = 0  then %>
			
			<%if cod_trans = 18160 or cod_trans = 18161 or cod_trans = 18162 then %>
				<div style="display:none" id="dvPrintComisionTermica">
					<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
					<%BoletaComisionTermica ("boletaComision3")%>
				</div>
				<div style="display:none" id="dvPrintComision">
					<br><br><br><br><br><br><br><br><br>
					<% BoletaComision("boletaComision") %>
					<br><br><br><br><br><br><br>
					<% BoletaComision ("boletaComision2")%>
				</div>
			<%elseif cod_trans = 18157 then%>
				<div style="display:none" id="dvPrintComisionTermica">
					<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
					<%BoletaComisionTermica ("boletaComision3")%>
				</div>
				<div style="display:none" id="dvPrintComision">
					<br><br><br>
					<% BoletaComision("boletaComision") %>
					<br><br><br><br><br><br><br>
					<% BoletaComision ("boletaComision2")%>
				</div>
			<%else%>
				<div style="display:none" id="dvPrintComisionTermica">
					<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
					<%BoletaComisionTermica ("boletaComision3")%>
				</div>
				<div style="display:none" id="dvPrintComision">
					<br><br><br><br><br><br><br><br><br>
					<% BoletaComision("boletaComision") %>
					<br><br><br><br><br><br><br>
					<% BoletaComision ("boletaComision2")%>
				</div>
			<%end if%>
			
		<% end if%>

		<%if cod_trans = 18150  then 'celd2023 llamado a metodo de impresion de boleta de comision para cxca %>
			<%if ComisionClienteCXCA = "S"  then%>
				<div style="display:none" id="dvPrintComisionTermica">
				<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
				<%BoletaComisionTermicaCXCA ("boletaComision3")%>
				</div>
				<div style="display:none" id="dvPrintComision">
					<br><br><br><br><br><br><br><br><br><br><br><br><br><br>
					<% BoletaComisionCXCA("boletaComision") %>
					<br><br><br><br><br><br><br> <br><br><br> <br><br><br>
					<% BoletaComisionCXCA ("boletaComision2")%>
				</div>
			<% end if%>
		<% end if%>


		<center>   
					<table name = "tbTipoImpresion" id = "tbTipoImpresion">
						<tr>
						<td class="textoP">
							<input name="chValida" type="checkbox" onClick="validaTipoImpresion(1)" checked id="bmc">
								<label for="bmc">Impresora de tinta : Boletas media carta</label>
							</td>
						</tr>
						<tr>
						<td class="textoP">
							<input name="chValida" type="checkbox" onClick="validaTipoImpresion(2)" id="btv">
							<label for="btv">Impresora t&eacute;rmica : Boletas tipo voucher</label>
							</td>
						</tr>
					</table>
		</center>
		<center>   
		  <table name="tbPrint" id="tbPrint" style="display:block">
		    <td height="65" align="center"> 
				<a href="CA_Reimpresion_boleta.asp" onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('Regresar1','','../../images/regresaron.gif',1);" ><img name="regresar1" src="../../images/regresaroff.gif" border="0"></a>
			</td>

			<%if (cod_trans = 18102 or cod_trans = 18156 or cod_trans = 18155  or cod_trans = 18157 or cod_trans = 18158  or cod_trans = 18159 or cod_trans = 18160 or cod_trans = 18161 or cod_trans = 18162 or cod_trans = 18163 or cod_trans = 18166) and refCom = 0 then %>
				<td>
					<a onClick="ImprimirComision(0);" onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('imprimir','','../../images/imprimiron.gif',1);" ><input type="image" value="Imprimir"Img name="imprimir" src="../../images/imprimiroff.gif" height="60" border="0"></a> 
				</td>
				
			<%
			else
			'celd2023
			%>
				<%if cod_trans = 18150 and ComisionClienteCXCA = "S"  then %>
					<td>
						<a onClick="ImprimirComision(0);" onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('imprimir','','../../images/imprimiron.gif',1);" ><input type="image" value="Imprimir"Img name="imprimir" src="../../images/imprimiroff.gif" height="60" border="0"></a> 
					</td>
				<%else %>
					<td>
						<a onClick="Imprimir(0);" onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('imprimir','','../../images/imprimiron.gif',1);" ><input type="image" value="Imprimir"Img name="imprimir" src="../../images/imprimiroff.gif" height="60" border="0"></a> 
					</td>
				<% end if%>
			<% end if%>
			
          </table>
		</center> 
		<% 
		else'impresion tinta 
			PLRecibo ("boleta1")
		%>
		<div style="display:none" id="dvPrint">
												  
			<%if cod_trans = 18160 or cod_trans = 18161 then %>
				<% PLRecibo ("boleta2") %> 
			<%else%>
				<br><br><br> 
				<% PLRecibo ("boleta2") %> 
			<%end if%>
		</div>
		<%if (cod_trans = 18102  or cod_trans = 18156 or cod_trans = 18155   or cod_trans = 18157  or cod_trans = 18158  or cod_trans = 18159 or cod_trans = 18160 or cod_trans = 18161 or cod_trans = 18162 or cod_trans = 18166 ) and refCom = 0 then %>
			
		<div style="display:none" id="dvPrintComision">
			<%if cod_trans = 18160 or cod_trans = 18161  then %>
			
				<br><br><br><br><br><br><br><br><br><br><br>
				<% BoletaComision("boletaComision") %>
				<br><br><br><br><br><br><br>
				<% BoletaComision ("boletaComision2")%>

			<%else%>
				<%if cod_trans = 18162 then  %>
					<br><br><br><br><br>
				<%else%>
					<br><br><br><br><br><br><br><br><br><br><br><br><br><br>
				<%end if%>
				
				<% BoletaComision("boletaComision") %>
				<br><br><br><br><br><br><br>
				<% BoletaComision ("boletaComision2")%>
			<%end if%>
		</div>
		<% end if%>

		<%if cod_trans = 18150  then 'celd2023 llamado a metodo de impresion de boleta de comision para cxca %>
			<%if ComisionClienteCXCA = "S"  then%>
				<div style="display:none" id="dvPrintComision">
					<br><br><br><br><br><br><br><br><br><br><br><br><br><br>
					<%BoletaComisionCXCA ("boletaComision")%>
					<br><br><br><br><br><br><br> <br><br><br> <br><br><br>
					<%BoletaComisionCXCA ("boletaComision2")%>
				</div>
			<% end if%>
		<% end if%>

		<center>   
		  <table name="tbPrint" id="tbPrint" style="display:block">
		    <td height="65" align="center"> 
				<a href="CA_Reimpresion_boleta.asp" onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('Regresar1','','../../images/regresaron.gif',1);" ><img name="regresar1" src="../../images/regresaroff.gif" border="0"></a>
				
			</td>
			<%if (cod_trans = 18102  or cod_trans = 18156 or cod_trans = 18155   or cod_trans = 18157 or cod_trans = 18158  or cod_trans = 18159 or cod_trans = 18160 or cod_trans = 18161 or cod_trans = 18162 or cod_trans = 18166)  and refCom = 0 then %>
				<td>
					<a onClick="ImprimirComision(1);" onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('imprimir','','../../images/imprimiron.gif',1);" ><input type="image" value="Imprimir"Img name="imprimir" src="../../images/imprimiroff.gif" height="60" border="0"></a> 
				</td>

			<%else
			'celd2023
			%>
				<%if cod_trans = 18150 and ComisionClienteCXCA = "S"  then %>
					<td>
						<a onClick="ImprimirComision(1);" onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('imprimir','','../../images/imprimiron.gif',1);" ><input type="image" value="Imprimir"Img name="imprimir" src="../../images/imprimiroff.gif" height="60" border="0"></a> 
					</td>
				<%else %>

					<td>
						<a onClick="Imprimir(1);" onMouseOut="MM_swapImgRestore()"  onMouseOver="MM_swapImage('imprimir','','../../images/imprimiron.gif',1);" ><input type="image" value="Imprimir"Img name="imprimir" src="../../images/imprimiroff.gif" height="60" border="0"></a> 
					</td>
				<% end if%>	
			<% end if%>
		</div>
		
	
        </table>
		</center>
		<%End if

Sub DatosBoleta ()

	Const ANCHO_COLUMNA = 100

	Dim srtJson, httpRequest, url, responseText
	Dim oJSON, resultado, jsonData, i, datos, this, arrDescripPagoM
	
	if(cod_trans = 18001)then
		'consulta detalle de pago de remesa(CR)
		strTipoOperacion="CR"
		
	elseif(cod_trans = 18004)then
		strTipoOperacion="RM"  'Pago Remesas Mixto	
		
	else
		'consulta detalle de pago de servicios, depositos y retiros de TD
		strTipoOperacion="C"
	end if

	url = BR_RUTA_WEBSERVICE_REIMPRIME_BOLETA & "detalle_transacciones"

	srtJson =	"{" & _
					"""operacion""" & ":" & """"&strTipoOperacion&""""  & "," & _
					"""usuario""" & ":" & """"&Session("VGLogin")&""""  & "," & _
					"""secuencial""" & ":" & """"&nro_tran&""""  & "," & _
					"""fecha""" & ":" & """"&fecha_consulta&""""  & "," & _
					"""noRemesa""" & ":" & """"&nroCuenta&""""  & "," & _
					"""oficina""" & ":" & """"&Session("VG_Oficina")&""""  & "," & _
					"""ip""" & ":" & """"&Session("VGIPAddress")&""""  & "" & _
				"}"	

	Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
	httpRequest.setTimeouts 60000,60000,60000,60000
	httpRequest.Open "POST", url, False
	httpRequest.setRequestHeader "Content-Type", "application/json"	
	httpRequest.Send srtJson
	responseText = httpRequest.ResponseText
	If httpRequest.status = 200 Then
		Set oJSON = New aspJSON
		oJSON.loadJSON(responseText)
		set jsonData = oJSON.data.item("detalleTransacciones")
		set resultado = jsonData.item("resultado")
		if resultado.item("codigo") = "1" then
			set datos = jsonData.item("datos")
			strDescrip = Trim(datos.item("descripcion"))
			strFecha = datos.item("fecha")
			strHora = Trim(datos.item("hora"))
			strCodigo = Trim(datos.item("codigoTrn"))
			strMonto = Trim(datos.item("valor"))
			strNombre =  Trim(datos.item("tipoEmpresa"))    'nombre del beneficiario(remesa) ó numero de empresa
			strCuenta = Trim(datos.item("cuenta"))
			strSecuencial= Trim(datos.item("secuencial"))
			
			'strIdBitacora= Trim(arrDatos(9).text)
			
			if (cod_trans  <> 18004) then
				strIdBitacora= Trim(datos.item("id"))
				
			else
				
				arrDescripPagoM = Split(strDescrip, "|") 
				If ubound(arrDescripPagoM) >= 8 then
					strIdBitacora = arrDescripPagoM(8)
				Else
					strIdBitacora= 0
				End If

				
			end if 
			if strCuenta = nroCuenta then
			end if
			
		
					'separa hora y fecha de la transaccion
				arrayFecha = split(strFecha, " ")
				strFecha = arrayFecha(0)
				PLTransformaFecha strFecha,strFecha	
				
				arrayHora = split (strHora, " ")
				strHora = left(arrayHora(1),8) & " "&right(arrayHora(1),2)
		Else	
			Response.Write "<center>" & _
							   "<font face=""Verdana""><b>" & _
							   "No se obtuvo resultados." & _
							   "</font>" & _
						   "</center>"
			Response.End
		End If
	else
		Response.Write "<center>" & _
						   "<font face=""Verdana""><b>" & _
						   "OCURRIO UN ERROR EN LA RESPUESTA DEL WEB SERVICES." & _
						   "</font>" & _
					   "</center>"
		Response.End
	end if
End Sub 
'loaao migración 23-12-2024
Sub ReimpremeCobroEmp(secuencial)
	Const ANCHO_COLUMNA = 100
	Dim srtJson, httpRequest, url, responseText
	Dim oJSON, resultado, jsonData, i, datos, this

	url = BR_REIMPRESION_CXCA & "detalleTransacciones"

	srtJson =	"{" & _
					"""secuencial""" & ":" & """"&secuencial&""""  & "," & _
					"""fecha""" & ":" & """"&fecha_consulta&""""  & "," & _
					"""usuario""" & ":" & """"&Session("VGLogin")&""""  & "," & _
					"""oficina""" & ":" & """"&Session("VG_Oficina")&""""  & "," & _
					"""ip""" & ":" & """"&Session("VGIPAddress")&""""  & "" & _
				"}"	

	Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
	httpRequest.setTimeouts 60000,60000,60000,60000
	httpRequest.Open "POST", url, False
	httpRequest.setRequestHeader "Content-Type", "application/json"	
	httpRequest.Send srtJson
	responseText = httpRequest.ResponseText
	If httpRequest.status = 200 Then
		Set oJSON = New aspJSON
		oJSON.loadJSON(responseText)
		set jsonData = oJSON.data.item("detalleTransacciones")
		set resultado = jsonData.item("resultado")
		if resultado.item("codigo") = "1" then
			set datos = jsonData.item("datos")
			strSecuencial = Trim(datos.item("secuencial"))
			strFechaR = datos.item("fecha")
			strHoraR = Trim(datos.item("hora"))
			strNombreEmpresa = Trim(datos.item("nombreEmpresa"))
			strTran = Trim(datos.item("transaccion"))
			R1 = Trim(datos.item("descripcionReferencia1"))
			ref1 = Trim(datos.item("valorReferencia1"))
			R2 = Trim(datos.item("descripcionReferencia2"))
			ref2 = Trim(datos.item("valorReferencia2"))
			R3 = Trim(datos.item("descripcionReferencia3"))
			ref3 = Trim(datos.item("valorReferencia3"))
			R4 = Trim(datos.item("descripcionReferencia4"))
			ref4 = Trim(datos.item("valorReferencia4"))
			R5 = Trim(datos.item("descripcionReferencia5"))
			ref5 = Trim(datos.item("valorReferencia5"))
			strTotal = Trim(datos.item("total"))
			reso1 = Trim(datos.item("resol1"))
			reso2 = Trim(datos.item("resol2"))
			reso3 = Trim(datos.item("resol3"))
			reso4 = Trim(datos.item("resol4"))
			reso5 = Trim(datos.item("resol5"))
			reso6 = Trim(datos.item("resol6"))
			strOficina = Trim(datos.item("oficina"))
			strCajaRural = Trim(datos.item("cajaRural"))
			strCuentaR = Trim(datos.item("cuenta")) 


		else	
			Response.Write "<center>" & _
							   "<font face=""Verdana""><b>" & _
								"No se obtuvo resultados." & _
							   "</font>" & _
						   "</center>"
			Response.End
		End If
	else
		Response.Write "<center>" & _
						   "<font face=""Verdana""><b>" & _
							"OCURRIO UN ERROR EN LA RESPUESTA DEL WEB SERVICES." & _
						   "</font>" & _
					   "</center>"
		Response.End
	end if
End Sub


Sub PLReciboTermica(id, display)
	%>
	<table id="<%=id%>" width="275" border="1" cellspacing="0" cellpadding="0" align="center" style="<%=display%>" >
	<tr>
		<td width="275" >
			<table border="0" CELLSPACING="0" CELLPADDING="2" align="center">						
				<tr >
					<td align= center colspan="5">
						<center><img src="../../images/logo_reimpresion.jpg"></center>
					</td>
				</tr> 
				<%
				Select Case (cod_trans)
					case 18151 ' Pago Avon
					arrDescripTemp = split(strDescrip,"|")
				%>
				<tr>
					<td align= center colspan="5">
						<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIOS </font></div>
						<br>
					</td>
				</tr>
				<tr>
					<td width=135><p align="right" class="textoImpresionP" >PAGO DE SERVICIO:</td>
					<td colspan="4"><span class="textoImpresionP">AVON<br></span></td>
				
				</tr>
				<tr> 
						
					<td width=135 ><p align="right" class="textoImpresionP" >COD. CLIENTE:</span></td>
					<td colspan="4"><span class="textoImpresionP"><%=strCuenta%><br></span></td>
					
			
				</tr>
				<tr>
						
					<td width=135 ><p align="right" class="textoImpresionP">NOMBRE CLIENTE:</td>
					<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
						
				</tr>
				<tr>
						
					<td width=135><p align="right" class="textoImpresionP" >VALOR:</td>
					<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
					
				</tr>
					
				<tr>
						
					<td width=135><p align="right" class="textoImpresionP">BOLETA:</td>
					<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
				</tr>
					
				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">FECHA:</td>
					<td colspan="4"><span class="textoImpresionP"> <%= strFecha & " "&strHora %></span></td>
				</tr>					
				<tr>
					<td align= center colspan="5">
						<span class="textoImpresionP">
						<br>
						<br>
						F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
					<tr>
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table>
			<%
					case 19351 ' Solicitud de chequera
					arrDescripTemp = split(strDescrip,"|")
					Dim NoCuenta
					Dim cantidadchequessoli
					Dim cantidadchequerassoli
					Dim nombreubid
					Dim nombreubimuni 
					Dim agenciasoli
					Dim strnombresoli
					Dim monedasoli
					Dim cuentaOfuscadasoli
					Dim cuentasoli
					Dim cuentaFinsoli
					Dim lenCuentasoli
                    Dim isoli
		
					cantidadchequessoli = trim(arrDescripTemp(2))
					cantidadchequerassoli = trim(arrDescripTemp(3))
					nombreubid = trim(arrDescripTemp(4))
					nombreubimuni = trim(arrDescripTemp(5))
					agenciasoli = trim(arrDescripTemp(6))
					agenciasoli = agenciasoli +","+ nombreubimuni + "," +  nombreubid
					strnombresoli = trim(arrDescripTemp(7))
					strnombresoli=server.htmlEncode(strnombresoli)

					if ubound(arrDescripTemp) > 8 then
						monedasoli = trim(arrDescripTemp(8))
						cuentasoli = trim(arrDescripTemp(9))
						lenCuentasoli = len(cuentasoli) - 4
						cuentaFinsoli = mid(cuentasoli, lenCuentasoli, 4)
						

						For isoli = 0 to (lenCuentasoli - 1)
							cuentaOfuscadasoli = cuentaOfuscadasoli + "X"
						Next	
						cuentaOfuscadasoli = cuentaOfuscadasoli + cuentaFinsoli
					else
					monedasoli = 0
					end if
					%>

			<tr>
				<td align= center colspan="5">
					<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">GESTI&Oacute;N - SOLICITUD DE CHEQUERA</font></div>
					<br>
				</td>
			</tr>
			<tr> 
				
				<td width=135 ><p align="right" class="textoImpresionP" >No. de cuenta:</span></td>
				<td colspan="4"><span class="textoImpresionP">
					<%
					if Moneda = 1 then
					%>
					USD/<%=cuentaOfuscadasoli%>/<%=strnombresoli%><br></span></td>
					<%
					else
					%>
					GTQ/<%=cuentaOfuscadasoli%>/<%=strnombresoli%><br></span></td>
					<%
					end if
					%>


			</tr>
			<tr>
				
				<td width=135 ><p align="right" class="textoImpresionP">Cantidad de cheques:</td>
				<td colspan="4"><span class="textoImpresionP"><%=cantidadchequessoli%><br></span></td>
				
			</tr>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP" >Cantidad de chequera(s):</td>
				<td colspan="4"><span class="textoImpresionP"><%=cantidadchequerassoli%></span></td>

			</tr>

			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Age:</td>
				<td colspan="4"><span class="textoImpresionP"><%=agenciasoli%></span></td>
			</tr>

			<tr>
				<td  width=135 ><p align="right" class="textoImpresionP">Fecha:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
			</tr>	
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Hora:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strHora%></span></td>
			</tr>
			<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
				<tr>				
					<td width=135><p align="right" class="textoImpresionP">Monto a pagar:</td>
					<td colspan="4"><span class="textoImpresionP"> 
						<%
						if Moneda = 1 then
						%>
						$&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
						<%
						else
						%>
						Q&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
						<%
						end if
						%>
				</tr>
			<%End if %>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Secuencial:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
			</tr>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Ref:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
			</tr>				
			<tr>
				<td align= center colspan="5">
					<span class="textoImpresionP">
					<br>
					<br>
					F: ___________________________________________<br>
					(Recib&iacute; Conforme)
					<br>
					<br>
					</span>
				</td>																
			</tr>
			<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
				<tr>
					<td colspan="6" >
						<div align="center">
							<span class="textoImpresionP"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
						</div>
					</td>
				</tr>	
			<%End if%>

			<tr>
				<td align= center colspan="5">
					<span class="textoG">
					<br>
					ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
					<br>
					<br>
					</span>
					</td>																
				</tr>
			<tr align= center colspan="4">
				<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
				<td>&nbsp;</td>	
				<td>&nbsp;</td>					
				<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
			</tr>
			</table>
			<table>		
			<tr>
			<br>
			<td align= center colspan="4">
				<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
				</span>
			</td>						
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			</table>
			<%
					case 19352 ' Bloqueo de cheques
					arrDescripTemp = split(strDescrip,"|")
				
					
					Dim nochequeini
					Dim nochequefin
					Dim causa
					Dim strnombrebloq
					
					Dim monedabloq
					Dim cuentabloq
					Dim cuentaOfuscadabloq
					Dim cuentaFinbloq
					Dim lenCuentabloq
                    Dim ibloq
					Dim cantidadChequesBloq
					
					nochequeini = trim(arrDescripTemp(2))
					nochequefin = trim(arrDescripTemp(3))
					causa = trim(arrDescripTemp(1))
					cantidadChequesBloq = trim(arrDescripTemp(7))

					strnombrebloq = trim(arrDescripTemp(4))
					strnombrebloq=server.htmlEncode(strnombrebloq)
					if ubound(arrDescripTemp) > 4 then
					monedabloq = trim(arrDescripTemp(5))
					cuentabloq = trim(arrDescripTemp(6))
					lenCuentabloq = len(cuentabloq) - 4
					cuentaFinbloq = mid(cuentabloq, lenCuentabloq+1, 4)
					

					For ibloq = 0 to (lenCuentabloq - 1)
						cuentaOfuscadabloq = cuentaOfuscadabloq + "X"
					Next	
					cuentaOfuscadabloq = cuentaOfuscadabloq + cuentaFinbloq
					else
					monedabloq = 0
					end if
					
					%>

			<tr>
				<td align= center colspan="5">
					<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">GESTI&Oacute;N - BLOQUEO DE CHEQUES</font></div>
					<br>
				</td>
			</tr>
			<tr> 
				
				<td width=135 ><p align="right" class="textoImpresionP" >No. de cuenta:</span></td>
				<td colspan="4"><span class="textoImpresionP">
					<%
					if monedabloq = 1 then
					%>
					USD/<%=cuentaOfuscadabloq%>/<%=strnombrebloq%><br></span></td>
					<%
					else
					%>
					GTQ/<%=cuentaOfuscadabloq%>/<%=strnombrebloq%><br></span></td>
					<%
					end if
					%>


			</tr>
			<tr>
						
				<td width=135 ><p align="right" class="textoImpresionP">Acci&oacute;n:</td>
				<td colspan="4"><span class="textoImpresionP">Bloqueo<br></span></td>
				
			</tr>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP" >N&uacute;mero de cheque:</td>
				<td colspan="4"><span class="textoImpresionP"><%=nochequeini%> - <%=nochequefin%></span></td>
			
			</tr>

			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Cantidad de cheques bloqueados:</td>
				<td colspan="4"><span class="textoImpresionP"><%=cantidadChequesBloq%></span></td>
			</tr>
			
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Causa:</td>
				<td colspan="4"><span class="textoImpresionP"><%=causa%></span></td>
			</tr>

			<tr>
				<td  width=135 ><p align="right" class="textoImpresionP">Fecha:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
			</tr>	
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Hora:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strHora%></span></td>
			</tr>
			<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
				<tr>
					
					<td width=135><p align="right" class="textoImpresionP">Monto a pagar:</td>
					<td colspan="4"><span class="textoImpresionP"> 
						<%
						if Moneda = 1 then
						%>
						$&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
						<%
						else
						%>
						Q&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
						<%
						end if
						%>
				</tr>
			<%End if %>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Secuencial:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
			</tr>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Ref:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
			</tr>				
			<tr>
				<td align= center colspan="5">
					<span class="textoImpresionP">
					<br>
					<br>
					F: ___________________________________________<br>
					(Recib&iacute; Conforme)
					<br>
					<br>
					</span>
				</td>																
			</tr>
			<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
				<tr>
					<td colspan="6" >
						<div align="center">
							<span class="textoImpresionP"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
						</div>
					</td>
				</tr>	
			<%End if%>
			<tr>
				<td align= center colspan="5">
					<span class="textoG">
					<br>
					ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
					<br>
					<br>
					</span>
					</td>																
				</tr>
			<tr align= center colspan="4">
				<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
				<td>&nbsp;</td>	
				<td>&nbsp;</td>					
				<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
			</tr>
			</table>
			<table>		
			<tr>
			<br>
			<td align= center colspan="4">
				<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
				</span>
			</td>						
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			</table>
			<%
					case 19353 ' Desbloqueo de cheques
					arrDescripTemp = split(strDescrip,"|")
				
					
					Dim nochequeinidesbloq
					Dim nochequefindesbloq
					Dim strnombredesbloq
					
					Dim monedadesbloq
					Dim cuentadesbloq
					Dim cuentaOfuscadadesbloq
					Dim cuentaFindesbloq
					Dim lenCuentadesbloq
                    Dim idesbloq
					Dim cantidadChequesDesbloq
	
					cantidadChequesDesbloq = trim(arrDescripTemp(6))
					nochequeinidesbloq = trim(arrDescripTemp(1))
					nochequefindesbloq = trim(arrDescripTemp(2))
					

					strnombredesbloq = trim(arrDescripTemp(3))
					strnombredesbloq=server.htmlEncode(strnombredesbloq)
					if ubound(arrDescripTemp) > 3 then
					monedadesbloq = trim(arrDescripTemp(4))
					cuentadesbloq = trim(arrDescripTemp(5))
					lenCuentadesbloq = len(cuentadesbloq) - 4
					cuentaFindesbloq = mid(cuentadesbloq, lenCuentadesbloq, 4)

					For idesbloq = 0 to (lenCuentadesbloq - 1)
						cuentaOfuscadadesbloq = cuentaOfuscadadesbloq + "X"
					Next	
					cuentaOfuscadadesbloq = cuentaOfuscadadesbloq + cuentaFindesbloq
					
					else
					monedadesbloq = 0
					end if
					
					%>

			<tr>
				<td align= center colspan="5">
					<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">GESTI&Oacute;N - DESBLOQUEO DE CHEQUES</font></div>
					<br>
				</td>
			</tr>
			<tr> 
				
				<td width=135 ><p align="right" class="textoImpresionP" >No. de cuenta:</span></td>
				<td colspan="4"><span class="textoImpresionP">
					<%
					if monedadesbloq = 1 then
					%>
					USD/<%=cuentaOfuscadadesbloq%>/<%=strnombredesbloq%><br></span></td>
					<%
					else
					%>
					GTQ/<%=cuentaOfuscadadesbloq%>/<%=strnombredesbloq%><br></span></td>
					<%
					end if
					%>


			</tr>
			<tr>
						
				<td width=135 ><p align="right" class="textoImpresionP">Acci&oacute;n:</td>
				<td colspan="4"><span class="textoImpresionP">Desbloqueo<br></span></td>
				
			</tr>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP" >N&uacute;mero de cheque:</td>
				<td colspan="4"><span class="textoImpresionP"><%=nochequeinidesbloq%> - <%=nochequefindesbloq%></span></td>
			
			</tr>

			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Cantidad de cheques Desbloqueados:</td>
				<td colspan="4"><span class="textoImpresionP"><%=cantidadChequesDesbloq%></span></td>
			</tr>
			<tr>
				<td  width=135 ><p align="right" class="textoImpresionP">Fecha:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
			</tr>	
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Hora:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strHora%></span></td>
			</tr>
			<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
				<tr>
					
					<td width=135><p align="right" class="textoImpresionP">Monto a pagar:</td>
					<td colspan="4"><span class="textoImpresionP"> 
						<%
						if Moneda = 1 then
						%>
						$&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
						<%
						else
						%>
						Q&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
						<%
						end if
						%>
				</tr>
			<%End if %>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Secuencial:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
			</tr>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Ref:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
			</tr>				
			<tr>
				<td align= center colspan="5">
					<span class="textoImpresionP">
					<br>
					<br>
					F: ___________________________________________<br>
					(Recib&iacute; Conforme)
					<br>
					<br>
					</span>
				</td>																
			</tr>
			<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
				<tr>
					<td colspan="6" >
						<div align="center">
							<span class="textoImpresionP"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
						</div>
					</td>
				</tr>	
			<%End if%>
			<tr>
				<td align= center colspan="5">
					<span class="textoG">
					<br>
					ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
					<br>
					<br>
					</span>
					</td>																
				</tr>
			<tr align= center colspan="4">
				<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
				<td>&nbsp;</td>	
				<td>&nbsp;</td>					
				<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
			</tr>
			</table>
			<table>		
			<tr>
			<br>
			<td align= center colspan="4">
				<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
				</span>
			</td>						
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			</table>

			<%
					case 19354 ' Predeclaracion de cheques
					arrDescripTemp = split(strDescrip,"|")
				
					
					Dim nochequepredecla
					Dim strnombrepredecla
					
					Dim monedapredecla
					Dim cuentapredecla
					Dim cuentaOfuscadapredecla
					Dim cuentaFinpredecla
					Dim lenCuentapredecla
                    Dim ipredecla
					Dim beneficiariopredecla
                    Dim valorchequepredecla
					Dim montoPagarpredecla
		
					nochequepredecla = trim(arrDescripTemp(0))
					valorchequepredecla = trim(arrDescripTemp(1))
					beneficiariopredecla = trim(arrDescripTemp(4))
					beneficiariopredecla=server.htmlEncode(beneficiariopredecla)
					strnombrepredecla = trim(arrDescripTemp(2))
					strnombrepredecla=server.htmlEncode(strnombrepredecla)
					if ubound(arrDescripTemp) > 3 then
						monedapredecla = trim(arrDescripTemp(3))
						cuentapredecla = trim(arrDescripTemp(5))
						lenCuentapredecla = len(cuentapredecla) - 4
						cuentaFinpredecla = mid(cuentapredecla, lenCuentapredecla+1, 4)

						For ipredecla = 0 to (lenCuentapredecla - 1)
							cuentaOfuscadapredecla = cuentaOfuscadapredecla + "X"
						Next	
						cuentaOfuscadapredecla = cuentaOfuscadapredecla + cuentaFinpredecla
					else
					monedapredecla = 0
					end if
					
					%>

			<tr>
				<td align= center colspan="5">
					<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">GESTI&Oacute;N - PREDECLARACI&Oacute;N DE CHEQUES</font></div>
					<br>
				</td>
			</tr>
			<tr> 
				
				<td width=135 ><p align="right" class="textoImpresionP" >No. de cuenta:</span></td>
				<td colspan="4"><span class="textoImpresionP">
					<%
					if monedapredecla = 1 then
					%>
					USD/<%=cuentaOfuscadapredecla%>/<%=strnombrepredecla%><br></span></td>
					<%
					else
					%>
					GTQ/<%=cuentaOfuscadapredecla%>/<%=strnombrepredecla%><br></span></td>
					<%
					end if
					%>
			</tr>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP" >Cheque predeclarado:</td>
				<td colspan="4"><span class="textoImpresionP"><%=nochequepredecla%></span></td>
			
			</tr>
			<tr>
						
				<td width=135><p align="right" class="textoImpresionP" >Beneficiario:</td>
				<td colspan="4"><span class="textoImpresionP"><%=beneficiariopredecla%></span></td>
			
			</tr>
			
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP" >Monto:</td>
				<td colspan="4"><span class="textoImpresionP">
					<%
					if monedapredecla = 1 then
					%>
					$. <%=valorchequepredecla%></span></td>
					<%
					else
					%>
					Q. <%=valorchequepredecla%></span></td>
					<%
					end if
					%>
			
			</tr>
			<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
				<tr>
							
					<td width=135><p align="right" class="textoImpresionP" >Monto Comisi&oacuten:</td>
					<td colspan="4"><span class="textoImpresionP">Q. <%=FormatNumber(strMonto)%> </span></td>
				
				</tr>
			<%End if%>
			<tr>
				<td  width=135 ><p align="right" class="textoImpresionP">Fecha:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
			</tr>	
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Hora:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strHora%></span></td>
			</tr>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Secuencial:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
			</tr>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Ref:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
			</tr>				
			<tr>
				<td align= center colspan="5">
					<span class="textoImpresionP">
					<br>
					F: ___________________________________________<br>
					(Recib&iacute; Conforme)
					</span>
				</td>																
			</tr>
			<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
				<tr>
					<td colspan="6" >
						<div align="center">
							<span class="textoImpresionP"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
						</div>
					</td>
				</tr>	
			<%End if%>
			<tr>
					<td align= center colspan="4">
						<br>
						<span class="textoImpresionP"><strong>IMPORTANTE:</strong>La predeclaraci&oacute;n de cheques no garantiza el pago de cheques con firmas variadas, redacciones incorrectas o cualquier otra causa al momento de su pago , el <strong>CLIENTE</strong> acepta los t&eacute;rminos y condiciones de uso.
						</span>
					</td>					
				</tr>
			<tr>
				<td align= center colspan="5">
					<span class="textoG">
					<br>
					ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
					<br>
					<br>
					</span>
					</td>																
				</tr>
			<tr align= center colspan="4">
				<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
				<td>&nbsp;</td>	
				<td>&nbsp;</td>					
				<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
			</tr>
			</table>
			<table>		
			<tr>
			<br>
			<td align= center colspan="4">
				<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
				</span>
			</td>						
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			</table>

			<%
					case 19361 ' Bloqueo de TC
					arrDescripTemp = split(strDescrip,"|")
				
					
				
					Dim strnombrebloqtc
					
					Dim monedabloqtc
					Dim tarjetabloqtc
					Dim tarjetaOfuscadabloqtc
					Dim tarjetaFinbloqtc
					Dim tarjetaInibloqtc
					Dim lenTarjetabloqtc
                    Dim ibloqtc
					Dim causabloqtc
					Dim mensajeBoletaBloqTC
          
		
					
					causabloqtc = trim(arrDescripTemp(1))
					if causabloqtc = "ROBO" then
						mensajeBoletaBloqTC = "Cliente amigo este bloqueo es para su cancelaci&oacuten y reposici&oacuten de pl&aacutestico, el &aacuterea de tarjeta de cr&eacutedito se estar&aacute poniendo en contacto para su entrega."
					else
						mensajeBoletaBloqTC = "Cliente amigo este bloqueo es temporal, para su desbloqueo solo puede realizarse en una agencia."
					end if

					strnombrebloqtc = trim(arrDescripTemp(2))
					strnombrebloqtc=server.htmlEncode(strnombrebloqtc)
					if ubound(arrDescripTemp) > 3 then
						monedabloqtc = trim(arrDescripTemp(3))
						tarjetabloqtc = trim(arrDescripTemp(4))
						lenTarjetabloqtc = len(tarjetabloqtc) - 4
						tarjetaFinbloqtc = mid(tarjetabloqtc, lenTarjetabloqtc+1, 4)
						tarjetaInibloqtc = mid(tarjetabloqtc, 1,4)
						For ibloqtc = 0 to (lenTarjetabloqtc - 1)
							tarjetaOfuscadabloqtc = tarjetaOfuscadabloqtc + "X"
						Next	
						tarjetaOfuscadabloqtc = tarjetaInibloqtc + tarjetaOfuscadabloqtc + tarjetaFinbloqtc
					else
					monedabloqtc = 0
					end if
					
					%>

			<tr>
				<td align= center colspan="5">
					<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000"> Gesti&oacute;n Tarjeta de Cr&eacutedito - Bloqueo </font></div>
					<br>
				</td>
			</tr>
			<tr>
						
				<td width=135 ><p align="right" class="textoImpresionP">Nombre de la cuenta: </td>
				<td colspan="4"><span class="textoImpresionP"><%=strnombrebloqtc%><br></span></td>
				
			</tr>
			<tr> 
				
				<td width=135 ><p align="right" class="textoImpresionP" >No. de tarjeta:</span></td>
				<td colspan="4"><span class="textoImpresionP">
					<%
					if monedabloqtc= 1 then
					%>
					USD/<%=tarjetaOfuscadabloqtc%>/<%=strnombrebloqtc%> (Tarjeta de Cr&eacutedito)<br></span></td>
					<%
					else
					%>
					GTQ/<%=tarjetaOfuscadabloqtc%>/<%=strnombrebloqtc%> (Tarjeta de Cr&eacutedito)<br></span></td>
					<%
					end if
					%>
			</tr>
			<tr>
						
				<td width=135 ><p align="right" class="textoImpresionP">Acci&oacute;n:</td>
				<td colspan="4"><span class="textoImpresionP">Bloqueo<br></span></td>
				
			</tr>
	
			
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Causa:</td>
				<td colspan="4"><span class="textoImpresionP"><%=causabloqtc%></span></td>
			</tr>
			<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Monto a pagar:</td>
				<td colspan="4"><span class="textoImpresionP"> 
					
					Q&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
					
			</tr>
			<%End if%>	
			<tr>
				<td  width=135 ><p align="right" class="textoImpresionP">Fecha:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
			</tr>	
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Hora:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strHora%></span></td>
			</tr>
			
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Secuencial:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
			</tr>
			<tr>
				
				<td width=135><p align="right" class="textoImpresionP">Ref:</td>
				<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
			</tr>				
			<tr>
				<td align= center colspan="5">
					<span class="textoImpresionP">
					<br>
					F: ___________________________________________<br>
					(Recib&iacute; Conforme)
					</span>
				</td>																
			</tr>

			<tr>
				<td align= center colspan="4">
					<br>
					<span class="textoImpresionP"><strong><%=mensajeBoletaBloqTC%></strong>
					</span>
				</td>					
			</tr>
			
			<tr>
				<td align= center colspan="5">
					<span class="textoG">
					<br>
					ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
					<br>
					<br>
					</span>
					</td>																
				</tr>
			<tr align= center colspan="4">
				<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
				<td>&nbsp;</td>	
				<td>&nbsp;</td>					
				<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
			</tr>
			</table>
			<table>		
			<tr>
			<br>
			<td align= center colspan="4">
				<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
				</span>
			</td>						
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
			</table>
			
			

				<%
					case 18150 ' Cobros empresariales Genericos
					arrDescripTemp = split(strDescrip,"|")
					Dim Recibo
					Dim Resolucion
					Dim usa_re
					Dim SecuencialCon
					Dim strNombreTran
					Dim fec_proc
					
					'cche formato fecha
					dim fecha_actual, fecha_actual_format , fecha_actual_array, fecha_con_array, fecha_con_final 
					fecha_actual = Now()
					fecha_actual_array = Split(fecha_actual,"/")
					fec_proc = split(strFechaR,"/")
						
					fecha_actual_format 	= fecha_actual_array(1) & "/" & fecha_actual_array(0) & "/" & fecha_actual_array(2)
					fecha_actual_format =  Split(fecha_actual_format," ")
					'transformar fecha consulta
					fecha_con_array = Split(fecha_consulta,"/")
					
					fecha_con_final 	= CInt(fecha_con_array(1)) & "/" & CInt(fecha_con_array(0)) & "/" & CInt(fecha_con_array(2))
					'cche fin formato fecha
							
							
					
					SecuencialCon = trim(arrDescripTemp(5))
					strNombreTran = trim(arrDescripTemp(6))
					usa_re = trim(arrDescripTemp(4))
					
					if usa_re = "2" then
						 Recibo = "----"
						 Resolucion = "---"
						 
					else
						Recibo = trim(arrDescripTemp(3))
						Resolucion = trim(arrDescripTemp(2))
						
					end if
				%>	
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGOS VARIOS </font></div>
						</td>
					</tr>		
						<br>
					
					<tr> 
						<td colspan="5"><p align="justify">
							<span class="textoImpresionP">
								BANCO DE DESARROLLO RURAL S,A. - CxCA 16800 - <%=strCuenta%> - <%=strNombreEmpresa %> - N-ON - QUETZALES  996 <%=Session("VGLogin")%> <%=esp%> <%=strFechaR%> <%=esp%> <%=strHora%> <%=esp%> <%=fec_proc(2)%> <%=fec_proc(1)%> <%=fec_proc(0)%> <%=esp%> <%=trim(arrDescripTemp(0))%> <%=esp%> <%=trim(arrDescripTemp(1))%> 
								FORMA ELECTRONICA NO:<%=Recibo%> SERIE: <%=Resolucion%> BOLETA:<%=strSecuencial%>
							</span>
						</td>
						
					</tr>

					<tr>
						<td><span class="textoImpresionP"><br></span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >TRANSACCION:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strNombreTran%><br></span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >CODIGO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strTran%><br></span></td>
				
					</tr>
				<%																																				 
					On Error Resume Next

					if fecha_con_final = fecha_actual_format(0) then 
						Call MuestraDatosCertificacion (strCuentaR, strTran, SecuencialCon,"1")
					else 
						Call MuestraDatosCertificacionHis (strCuentaR, strTran, SecuencialCon,"1")
					end if 
					If Err.number <> 0 then 'Ocurrió un error
						Response.End
					end if																				
				%>
					
				<tr>
					<td width=135><p align="right" class="textoImpresionP" >VALOR A PAGAR:</td>
					<td colspan="4"><span class="textoImpresionP"> <%=FormatNumber (strMonto) %></span></td>
				
				</tr>
				</table>			
				<table width="275">
					<tr width="275"> 
						<td width="275" colspan="5"><p align="justify" class="textoImpresionP">			
								<%if usa_re = "1" then %>
									<%=reso1&reso2%>
									<%=reso3&reso4 %>
									<%=reso5&reso6%>
								<%end if%>																						  						                          
						</td>						
					</tr>
				</table>
				<table>
					<tr>
						<td><span class="textoImpresionP"><br></span></td>
					</tr>
					<tr>
					<td align= center colspan="5">
						<span class="textoG">
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>	
					<tr>
						<td align= center colspan="4"><span class="textoImpresionP"><br>Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>.</span></td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>

						
				</table> 	
				<%case 18252 ' Retiro TC
				arrDescripTemp = split(strDescrip,"|")

				%>

					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">RETIRO TARJETA DE CREDITO </font></div>
							<br>
						</td>
					</tr>
					<tr> 
						<td width=135><p align="right" class="textoImpresionP">No. DE TARJETA:</td>
						<td colspan="4">
							<span class="textoImpresionP">
								<%=mid(strCuenta, 1, 4)& " XXXX XXXX " & mid(strCuenta, 13,16)%><br>
							</span>
						</td>
					</tr>
					<tr> 
						<td width=135><p align="right" class="textoImpresionP">A NOMBRE DE:</td>
						<td colspan="4">
							<span class="textoImpresionP">
								<%=arrDescripTemp(1)%><br>
							</span>
						</td>
					</tr>

					
					<tr>
						<td width=135><p align="right"  class="textoImpresionP">POR UN VALOR DE:</td>
						<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
					</tr>
					
					<tr>
						<td width=135><p align="right" class="textoImpresionP">NUMERO DE BOLETA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
						<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %></span></td>
					</tr>	
					<tr>
						<td align= center colspan="5">
							<span class="textoImpresionP">
							<br>
							<br>
						    F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
					<tr>
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>

					<tr  align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>	
						<td align="right"><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%></span></td>
					</tr>				
				</table>
				<table>		
					<tr>
					<br>
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table>
				<% case 18254
					arrDescripTemp = split(strDescrip,"|")
				%>
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">CONSTANCIA DE PAGO</font></div>
							<br>
						</td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP">&nbsp;</td>
						<td colspan="4"><span class="textoImpresionP">&nbsp;</span></td>
					</tr>
					<tr>

						<td width=135><p align="right" class="textoImpresionSecuencial" >Documento:</td>
						<td colspan="4"><span class="textoImpresionSecuencial"><%=strSecuencial%></span></td>
					
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP">&nbsp;</td>
						<td colspan="4"><span class="textoImpresionP">&nbsp;</span></td>
					</tr>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP">Autorizo debito a la cuenta por haber recibido el monto certificado. Firmo o coloco la huella en los espacios reservados.<br> 
						NOTA DE DEBITO POR PAGO JUBILADOS Y/O PENSIONADOS<br><br></span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >No. de cuenta:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strCuenta%><br></span></td>
				
					</tr>
					<tr> 
						
						<td width=135 ><p align="right" class="textoImpresionP" >A nombre de:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strDescrip%><br></span></td>
					
			
					</tr>
					<tr>
						
						<td width=135 ><p align="right" class="textoImpresionP">Monto retirado:</td>
						<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
						
					</tr>

					
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">Fecha:</td>
						<%'cche Fecha en MM/DD/AAAA cuando viene como mes/dia/año 
									Dim fecha_actual_separada, fecha_mes, fecha_dia, fecha_anio, fecha_dia_string, fecha_mes_string, fecha_con_formato
									fecha_actual_separada = Split(strFecha,"/")
									fecha_dia = CInt(fecha_actual_separada(1))
									fecha_mes = CInt(fecha_actual_separada(0))
									fecha_anio = fecha_actual_separada(2)

									'corregir dia 
									if fecha_dia < 10 then
										fecha_dia_string = "0" & fecha_dia
									else
										fecha_dia_string = CStr(fecha_dia) 
									end if

									'corregir mes
									if fecha_mes < 10 then
										fecha_mes_string = "0" & fecha_mes
									else
										fecha_mes_string = CStr(fecha_mes)
									end if

									fecha_con_formato = fecha_mes_string + "/" + fecha_dia_string + "/" +  fecha_anio
							%>
						<td colspan="4"><span class="textoImpresionP"><%=fecha_con_formato%></span></td>
					</tr>
					<tr>
						<td align= center colspan="5">
							<span class="textoImpresionP">
							<br>
							<br>
							<br>
							<br>
						    F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
				
					<tr>
						<td align= center colspan="5">
							<span class="textoImpresionP">
							<br>
						   AVISO: Estimado pensionado, le recordamos que a partir del 1 de mayo de 2010, su acta de supervivencia debera presentarla el dia de su cumplea&ntilde;os o 30 dias calendario posteriores a este en: Centro de Atencion al Afiliado CATAFI, Trabajo Social, CAMIP PAMPLONA, CAMIP BARRANQUILLA y en Cajas y Delegaciones Departamentales, cualquier consulta al telefono 1-801-0014477 la llamada es gratis.<br>
							<br>
							</span>
						</td>																
					</tr>
					<tr>
						<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table>
			<% case 18253
					Dim arrFecha, strYear
					arrFecha = split(strFechaR,"/")
					strYear = mid(arrFecha(2),3,4)
					arrDescripTemp = split(strDescrip,"|")
				%>
			
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">RETIRO ADULTO MAYOR </font></div>
							<br>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP">Retiro Adulto Mayor - n  GTQ  <%=reso3%> </span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP">&nbsp;</td>
						<td colspan="4"><span class="textoImpresionP">&nbsp;</span></td>
					</tr>
					
					<tr>
						
						<td colspan="5"><p align="center" class="textoImpresionSecuencial">SEC: &nbsp;<span class="textoImpresionSecuencial"><%=strYear%><%=arrFecha(1)%><%=arrFecha(0)%><%=strSecuencial%> </span></td>
						
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP">&nbsp;</td>
						<td colspan="4"><span class="textoImpresionP">&nbsp;</span></td>
					</tr>
					<tr> 
						
						<td width=135 ><p align="right" class="textoImpresionP" >CODIGO BENEFICIARIO:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strCuenta%></span></td>
					
			
					</tr>
					<tr>
						
						<td width=135 ><p align="right" class="textoImpresionP">RECIBE EL PAGO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%> - <%=strNombreEmpresa%></span></td>
						
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP" >NOMBRE BENEFICIARIO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
					
					</tr>
					
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">NOMBRE APODERADO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=R1%></span></td>
					</tr>
					
					<tr>
						<td  width=135 ><p align="right" class="textoImpresionP">DPI:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
					</tr>
                    <tr>
						
						<td width=135><p align="right" class="textoImpresionP">EXTENDIDO EN:</td>
						<td colspan="4"><span class="textoImpresionP"><%=Ref1%></span></td>
					</tr>
                     <tr>
						
						<td width=135><p align="right" class="textoImpresionP">REFERENCIA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=reso4%></span></td>
					</tr>
                    <tr>
						
						<td width=135><p align="right" class="textoImpresionP">TOTAL PAGADO:</td>
						<td colspan="4"><span class="textoImpresionP"><%="Q " & FormatNumber(strMonto)%><br><br></span></td>
					</tr>
                    <tr>
						<td align="center" colspan="5"><span class="textoImpresionP">DESGLOSE DE PAGO </span></td>
					</tr>
                    <%
					 if R2 <> "" or Ref3 = "" then 
					%>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP"><%=R2%> : <%="Q " & FormatNumber(Ref3)%> </span></td>
						
					</tr>
					<%
					 end if
					%>
					<%
					 if Ref2 <> "" or R4 = "" then 
					%>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP"><%=Ref2%> : <%="Q " & FormatNumber(R4)%> </span></td>
						
					</tr>
					<%
					 end if
					%>
					<%
					 if R3 <> "" or Ref4 = "" then 
					%>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP"><%=R3%> : <%="Q " & FormatNumber(Ref4)%> </span></td>
						
					</tr>
					<%
					 end if
					%>

                    <tr>
						<td align="center" colspan="5"><span class="textoImpresionP">EVITE SUSPENSION DE APORTE, EN MIN.TRABAJO ACDO.GUB 99-2012 <br><br></span></td>
						
					</tr>
                    <tr>
						<td align="center" colspan="5"><span class="textoImpresionP">__________________________________</span></td>
						
					</tr>
                    <tr>
						<td align="center" colspan="5"><span class="textoImpresionP">Firma Beneficiario<br><br></span></td>
						
					</tr>					
					<tr>
						<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table>
			<%case 18801
			arrDescripTemp = Split(strDescrip, "|") 'obtener desglose de la descripcion
			%>
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago de Cheque Propio</font></div>
							<br>
						</td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >No.BOLETA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
				
					</tr>
					<tr> 
						
						<td width=135 ><p align="right" class="textoImpresionP" >No.REF:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%><br></span></td>
					
			
					</tr>
					<tr>
						
						<td width=135 ><p align="right" class="textoImpresionP">No.CUENTA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strCuenta%><br></span></td>
						
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP" >No.CHEQUE:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%>&nbsp;</span></td>
					
					</tr>
					
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">No.INVENTARIO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
					</tr>
					
					<tr>
						<td  width=135 ><p align="right" class="textoImpresionP">VALOR:</td>
						<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">LLAVE:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%>&nbsp;<br></span></td>
					</tr>	
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">DOCUMENTO DE IDENTIFICACI&oacute;N:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%><br></span></td>
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">NOMBRE:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(5)%><br></span></td>
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
						<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "& strHora %><br></span></td>
					</tr>				
					<tr>
						<td align= center colspan="5">
							<span class="textoImpresionP">
							<br>
							<br>
						    F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table>
			<%case 18802
			arrDescripTemp = Split(strDescrip, "|") 'obtener desglose de la descripcion
			%>
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago de Cheque Predeclarado</font></div>
							<br>
						</td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >No.BOLETA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
				
					</tr>
					<tr> 
						
						<td width=135 ><p align="right" class="textoImpresionP" >No.REF:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%><br></span></td>
					
			
					</tr>
					<tr>
						
						<td width=135 ><p align="right" class="textoImpresionP">No.CUENTA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strCuenta%><br></span></td>
						
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP" >No.CHEQUE:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%>&nbsp;</span></td>
					
					</tr>
					
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">No.INVENTARIO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
					</tr>
					
					<tr>
						<td  width=135 ><p align="right" class="textoImpresionP">VALOR:</td>
						<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">LLAVE:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%>&nbsp;<br></span></td>
					</tr>	
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">DOCUMENTO DE IDENTIFICACI&oacute;N:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%><br></span></td>
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">NOMBRE:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(5)%><br></span></td>
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
						<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "& strHora %><br></span></td>
					</tr>				
					<tr>
						<td align= center colspan="5">
							<span class="textoImpresionP">
							<br>
							<br>
						    F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table>
			<% case 18001 
			arrDescripTemp = Split(strDescrip, "|") 'obtiene los datos de remesador y beneficiario
			%>
				<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE REMESA</font></div>
							<br>
						</td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >REMESADOR:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
				
					</tr>
					<tr> 
						
						<td width=135 ><p align="right" class="textoImpresionP" >REMITENTE:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strNombre%><br></span></td>
					
			
					</tr>
					<tr>
						
						<td width=135 ><p align="right" class="textoImpresionP">BENEFICIARIO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%><br></span></td>
						
					</tr>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP">DATOS DE LA REMESA </span></td>
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP" >No. REMESA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strCuenta%>&nbsp;</span></td>
					
					</tr>
					
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">PAIS ORIGEN:</td>
						<td colspan="4"><span class="textoImpresionP">ESTADOS UNIDOS DE AMERICA</span></td>
					</tr>
					<%
					if ubound(arrDescripTemp) >= 4 then
						if ubound(arrDescripTemp) = 5 then
							VLTipoCliente = arrDescripTemp(5)
						end if %>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">ESTADO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%></span></td>
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">CIUDAD:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%></span></td>
					</tr>
					<%end if%>	
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">TOTAL A RECIBIR(EN QUETZALES):</td>
						<td colspan="4"><span class="textoImpresionP">Q.<%=strMonto%><br></span></td>
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">No. DE BOLETA</td>
						<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%><br></span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
						<td colspan="4"><span class="textoImpresionP"><%= strFecha &" "& strHora %><br></span></td>
					</tr>				
					<tr>
						<td align= center colspan="5">
							<span class="textoImpresionP">
							<br>
							<br>
						    F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<% if VLTipoCliente = "B" then%>
					<tr>
						<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">FAVOR ACERCARSE A LA AGENCIA MAS CERCANA PARA COMPLETAR SU EXPEDIENTE CON DOCUMENTO DE IDENTIFICACION Y RECIBO DE SERVICIOS OPCIONAL.
							</span>
						</td>					
					</tr>
				<% 	end if %>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table>
			<% case 18004 
			arrDescripTemp = Split(strDescrip, "|") 'obtiene los datos de remesador y beneficiario
			%>
			<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE REMESA MIXTA</font></div>
							<br>
						</td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >REMESADOR:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
				
					</tr>
					<tr> 
						
						<td width=135 ><p align="right" class="textoImpresionP" >REMITENTE SISTEMA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strNombre%><br></span></td>
					
			
					</tr>
					<tr>
						
						<td width=135 ><p align="right" class="textoImpresionP">BENEFICIARIO SISTEMA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%><br></span></td>
						
					</tr>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP">DATOS DE LA REMESA </span></td>
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP" >No. REMESA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strCuenta%>&nbsp;</span></td>
					
					</tr>
					<tr>
					
						<td width=135><p align="right" class="textoImpresionP" >No. DE BOLETA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%>&nbsp;</span></td>
					
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
						<td colspan="4"><span class="textoImpresionP"><%= strFecha &" "& strHora %>&nbsp;</span></td>
					
					</tr>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP">DESGLOCE DEL PAGO</span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP">EFECTIVO:</td>
						<td colspan="4"><span class="textoImpresionP">Q.<%=FormatNumber(arrDescripTemp(7), 2)%><br></span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP">DEPOSITO:</td>
						<td colspan="4"><span class="textoImpresionP">Q.<%=FormatNumber(arrDescripTemp(8), 2)%><br></span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP">CUENTA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(9)%><br></span></td>
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">TOTAL A PAGAR(EN QUETZALES):</td>
						<td colspan="4"><span class="textoImpresionP">Q.<%=FormatNumber(strMonto, 2)%><br></span></td>
					</tr>
					<tr>
						<td align= center colspan="5">
							<span class="textoImpresionP">
							<br>
							<br>
						    F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table>
			<% 	case 18107, 18103, 18105, 18108, 18109, 18106 %>
			<%
				arrDescripTemp = split(strDescrip,"|")

				select case (cod_trans)
					case 18107
						strServicio = "PAGO LINEA FIJA (CLARO)"
					case 18103
						strServicio ="TIGO - POST PAGO"
					case 18105
						strServicio ="PAGO TELEFONICA POSTPAGO"
					case 18108
						strServicio ="PAGO CLARO POSTPAGO"
					case 18109
						strServicio ="PAGO CLARO PREPAGO"
					case 18106
						strServicio ="PAGO TELEFONICA PREPAGO"
				end select
				%>
				
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIOS </font></div>
							<br>
						</td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >PAGO DE:</td>
						<td colspan="4"><span class="textoImpresionP">TEL&Eacute;FONO: <%=strCuenta%></span></td>
					</tr>
					<%if (cod_trans = 18103) then%>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >A NOMBRE DE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
					<%end if%>

					<tr>
						<td width=135 ><p align="right" class="textoImpresionP">POR UN VALOR DE:</td>
						<td colspan="4"><span class="textoImpresionP">Q. <%=formatNumber(strMonto) %></span></td>
					</tr>

					<%if (cod_trans = 18103) then
						'cche Fecha en MM/DD/AAAA cuando viene como dia/mes/año 
						Dim fecha_actual_separada_tigo, fecha_mes_tigo, fecha_dia_tigo, fecha_anio_tigo, fecha_dia_string_tigo, fecha_con_formato_tigo
						fecha_actual_separada_tigo = Split(strFecha,"/")
									
						fecha_dia_tigo = CInt(fecha_actual_separada_tigo(1))
						fecha_mes_tigo = CInt(fecha_actual_separada_tigo(0))
						fecha_anio_tigo = fecha_actual_separada_tigo(2)

						'corregir dia 
						if fecha_dia_tigo < 10 then
							fecha_dia_string_tigo = "0" & fecha_dia_tigo
						else
							fecha_dia_string_tigo = CStr(fecha_dia_tigo) 
						end if

						fecha_con_formato_tigo = fecha_dia_string_tigo + "/" +   CStr(fecha_mes_tigo) + "/" +  fecha_anio_tigo
					%>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP">No. AUTORIZACI&Oacute;N:</td>
						<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(0) %></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP">FECHA:</td>
						<td colspan="4"><span class="textoImpresionP"><%= fecha_con_formato_tigo %></span></td>
					</tr>
					<%end if%>

					<%if ((cod_trans <> 18103)and(cod_trans <> 18106)and(cod_trans <> 18109)) then %>
					<tr> 
						<td width=135 ><p align="right" class="textoImpresionP" >FACTURA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strDescrip%></span></td>
					</tr>
					<%end if%>

					
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP">POR CONCEPTO DE:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strServicio%> </span></td>
					</tr>
					<tr>
						<td  width=135 ><p align="right" class="textoImpresionP">N&Uacute;MERO DE BOLETA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
					</tr>
					<tr>
					<%if (cod_trans <> 18103) then%>
						<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
						<td colspan="4"><span class="textoImpresionP"><%= strFecha %></span></td>
					
					</tr>
					<%end if%>

					<tr>
						<td align= center colspan="5">
							<span class="textoImpresionP">
							<br>
							<br>
						    F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>					
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<tr align= center colspan="4">	
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table>
			<%case 18104 ' pago de tigo Prepago
				arrDescripTemp = split(strDescrip,"|")
			%>
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIOS</font></div>
							<br>
						</td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >Ud ha realizado un pago de servicios:</td>
						<td colspan="4"><span class="textoImpresionP">TIGO - <%=arrDescripTemp(3)%><br></span></td>
				
					</tr>
					<tr> 
						
						<td width=135 ><p align="right" class="textoImpresionP" >Por un valor de:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%></span></td>
					
			
					</tr>
					<tr>
						
						<td width=135 ><p align="right" class="textoImpresionP">Telefono:</td>
						<td colspan="4"><span class="textoImpresionP"><%= strCuenta %><br></span></td>
						
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP" >Fecha:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
					
					</tr>
					
					<tr>
						<td width=135><p align="right" class="textoImpresionP">Referencia de pago:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP">No. Boleta:</td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%><br></span></td>
					</tr>

					<tr>
						<td align= center colspan="5">
							<span class="textoImpresionP">
							<br>
							<br>
						    F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table>
			<%case 18117 ' Pago Upana
				arrDescripTemp = split(strDescrip,"|")

			%>
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIOS</font></div>
							<br>
						</td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >PAGO DE:</td>
						<td colspan="4"><span class="textoImpresionP">UNIVERSIDAD PANAMERICANA<br></span></td>
				
					</tr>
					<tr> 
						
						<td width=135 ><p align="right" class="textoImpresionP" >No. CARN&Eacute;:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strCuenta%></span></td>
					</tr>
					<tr> 
						<td width=135 ><p align="right" class="textoImpresionP" >Nombre:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>			
					</tr>
					<tr>
						
						<td width=135 ><p align="right" class="textoImpresionP">VALOR:</td>
						<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%>&nbsp;<br></span></td>
						
					</tr>
					<tr>
						
						<td width=135><p align="right" class="textoImpresionP" >NO. REFERENCIA:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
					
					</tr>
					
					<tr>
						<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
						<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %></span></td>
					</tr>
				
					<tr>
						<td align= center colspan="5">
							<span class="textoImpresionP">
							<br>
							<br>
						    F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table>
			<%case 18115 'Pago de Kingo
				arrDescripTemp = split(strDescrip,"|")
				%>
					<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO SERVICIOS</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >PAGO DE SERVICIO:</td>
							<td colspan="4"><span class="textoImpresionP">KINGO ENERGY<br></span></td>
						</tr>
						<tr> 
							<td width=135 ><p align="right" class="textoImpresionP" ></span></td>
							<td colspan="4"><span class="textoImpresionP"></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">COD. CLIENTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strCuenta%><br></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE CLIENTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >VALOR:</td>
							<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NO. AUTORIZACION:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>	
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">
								Cualquier reclamo debera dirigirlo a Kingo Energy, al siguiente telefono 1-801-42-54646	
								</span>
							</td>						
						</tr>		

						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
			<% case 18114 'LECLEIRE
					arrDescripTemp = Split(strDescrip, "|") 'obtiene los datos del retiro de TD nombre de la tarjeta|numero de la tarjeta|noombre de la cuenta
				%>
					<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">LECLEIRE</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >CODIGO CONSEJERO(A):</td>
							<td colspan="4"><span class="textoImpresionP"><%=strCuenta%><br></span></td>
						</tr>
						<tr> 
							<td width=135 ><p align="right" class="textoImpresionP">CODIGO ALTERNO:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%><br></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">POR UN VALOR DE:</td>
							<td colspan="4"><span class="textoImpresionP">Q.<%=FormatNumber(strMonto)%><br></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE CONSEJERO(A):</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NUMERO DE FACTURA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NO. DE REFERENCIA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<% case 18111 'empagua
					If InStr(strDescrip, "|") > 0 Then
	            		arrDescripTemp = Split(strDescrip, "|")
				 
            		Else
						arrDescripTemp = Array(strDescrip,"","","")
            		End If	   
				%>
					<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIO</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >USTED HA REALIZADO UN PAGO DE:</td>
							<td colspan="4"><span class="textoImpresionP">EMPAGUA<br></span></td>
						</tr>
						<tr> 
							<td width=135 ><p align="right" class="textoImpresionP"></span></td>
							<td colspan="4"><span class="textoImpresionP"><br></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">FACTURA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >POR UN VALOR DE:</td>
							<td colspan="4"><span class="textoImpresionP">Q. <%=strMonto%><br></span></td>
						</tr>
						<%If arrDescripTemp(2) <> "" Then%>
							<td width=135><p align="right" class="textoImpresionP" >No. SERIE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						<%End If%> 
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE:</td>
							<%If arrDescripTemp(1) = "" Then%>
								<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
							<%Else%>
								<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
							<%End If%>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NO. CONTADOR:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strCuenta%></span></td>
						</tr>
						<%If arrDescripTemp(3) <> "" Then%>
							<td width=135><p align="right" class="textoImpresionP" >MES DE SERVICIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%></span></td>
						<%End If%>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NO. DE BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha& " "  & strHora %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<% case 18112, 18113 'ENERGUATE
						if (strNombre = 1) then strEmpresa= "DEORSA"
						if (strNombre = 2) then strEmpresa= "DEOCSA"
					%>
					<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIO</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >USTED HA REALIZADO UN PAGO DE:</td>
							<td colspan="4"><span class="textoImpresionP">ENERGUATE<br></span></td>
						</tr>
						<tr> 
							<td width=135 ><p align="right" class="textoImpresionP"></span></td>
							<td colspan="4"><span class="textoImpresionP"><br></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">FACTURA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strDescrip%><br></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >POR UN VALOR DE:</td>
							<td colspan="4"><span class="textoImpresionP">Q. <%=strMonto%><br></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strDescrip%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NO. CONTADOR:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strCuenta%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NO. DE BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
			<% case 18152 %>
			<tr>
						<td align= center colspan="3">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">COBROS EMPRESARIALES</font></div>
							<br>
						</td>
					</tr>
					<tr >
						<td colspan="3">
							<p align="center" class="textoImpresionP" >BANCO DE DESARROLLO RURAL S.A. - COBROS EMPRESARIALES CXCA - 249 Boleta: <%=strSecuencial%>      
										N-ON [QUETZALES] 996  <%=strUsuarioR%> <%=esp%> <%=strFechaR%> <%=esp%> <%=strHoraR%> <%=esp%>  <%=strSecuencial%><br><br></p>
						</td>
					</tr> 
					<tr>
						<td ><p align="left" class="textoImpresionP" >Instituci&oacute;n:</td>
						<td  ><span align="left" class="textoImpresionP"><%=strNombreEmpresa%> </span></td>
					
						<td ><p align="right" class="textoImpresionP" >Trans: <%=strTran%></p></td>
					</tr>
					<tr> 
					<td ><p align="left" class="textoImpresionP">
							<%=R1%>:
					</td>
					<td >
						<span align="left" class="textoImpresionP">
							<%=ref1%>
						</span>
					</td>
					</tr>
					<tr> 
					<td><p align="left" class="textoImpresionP">
							<%=R2%>:
					</td>
					
					<td>
						<span align="left" class="textoImpresionP">
							<%=ref2%>
						</span>
					</td>
					</tr>
					<tr> 
					<td ><p align="left" class="textoImpresionP">
							<%=R3%>:
					</td>
					
					<td >
						<span align="left" class="textoImpresionP">
							<%=ref3%>
						</span>
					</td>
					
					</tr>
					<tr> 
					<td ><p align="left" class="textoImpresionP">
							<%=R4%>:
					</td>
					
					<td>
						<span align="left" class="textoImpresionP">
							<%=ref4%>
						</span>
					</td>
					</tr>
					<tr> 
					<td><p align="left" class="textoImpresionP">
							<%=R5%>:
					</td>
					
					<td>
						<span align="left" class="textoImpresionP">
							<%=ref5%>
						</span>
					</td>
					</tr>
					<tr> 
						<td  ><p align="right" class="textoImpresionP" >Total:</td>
						<td><span class="textoImpresionP">Q <%= FormatNumber(strTotal)%> </span></td>
					</tr>
							
					<tr>
						<td align= center colspan="3">
							<span class="textoImpresionP">
							<br>
							<br>
						    F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
					<tr>
					<td align= center colspan="3"><span class="textoImpresionP"><%=reso1 & reso2 & reso3 & reso4 & reso5 & reso6%><br><br></span></td>
					</tr>

					<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>	
					<tr align= center>
						<td>
							<p align="left" class="textoImpresionP" >Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></p>
						</td>
						<td colspan = "3">
							<p align="right" class="textoImpresionP" >Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Municipio: <%=Session("VG_Municipio")%></p>
						</td>
					</tr>
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="3">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table>
			<% case 18201 
			If Mid(strCuenta,1,1) = "3" or Mid(strCuenta,1,2) = "03" Then strTipoCuenta = "MONETARIO"
			If Mid(strCuenta,1,1) = "4" or Mid(strCuenta,1,2) = "04" Then strTipoCuenta = "AHORRO"
			%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">DEPOSITO <%=strTipoCuenta%></font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >No. DE CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strCuenta%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">POR UN VALOR DE:</td>
							<td colspan="4"><span class="textoImpresionP">Q. <%=formatNumber(strMonto,2)%><br></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE DE CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strDescrip%><br></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NUMERO DE DEP&Oacute;SITO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				
			<% case 18110%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIO</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >USTED HA REALIZADO UN PAGO DE:</td>
							<td colspan="4"><span class="textoImpresionP"> EMPRESA ELECTRICA DE GUATEMALA S.A <br>CONTADOR: <%=strCuenta%> </span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">POR UN VALOR DE:</td>
							<td colspan="4"><span class="textoImpresionP">Q.<%=strMonto%><br></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FACTURA:</td>
							<td colspan="4"><span class="textoImpresionP"> <%=strDescrip%><br></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >N&Uacute;MERO DE DEP&Oacute;SITO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<% case 18251
				arrDescripTemp = Split(strDescrip, "|") 'obtiene los datos del retiro de TD nombre de la tarjeta|numero de la tarjeta|noombre de la cuenta
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">RETIRO CON TARJETA DE D&Eacute;BITO</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >No. DE TARJETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=Mid(arrDescripTemp(1),1,6)&"XXXXXX"&Mid(arrDescripTemp(1),13,16)%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">A NOMBRE DE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >No. DE CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strCuenta%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >POR UN VALOR DE:</td>
							<td colspan="4"><span class="textoImpresionP">Q.<%=strMonto%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE DE LA CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
												<tr>
							<td width=135><p align="right" class="textoImpresionP" >No. DE BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						</tr>
												<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<% case 18258
				arrDescripTemp = Split(strDescrip, "|") 'obtiene los datos del retiro en cuenta DPI nombre de la tarjeta|numero de la tarjeta|noombre de la cuenta
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">RETIRO EN CUENTA</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >DPI:</td>
							<td colspan="4"><span class="textoImpresionP"><%=ofuscaDPI(ref2)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >No. DE TARJETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=ofuscaTarjeta(arrDescripTemp(1))%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">A NOMBRE DE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >No. DE CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=ofuscarCuenta(strCuenta)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >POR UN VALOR DE:</td>
							<td colspan="4"><span class="textoImpresionP">Q.<%=strMonto%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE DE LA CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
												<tr>
							<td width=135><p align="right" class="textoImpresionP" >No. DE BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						</tr>
												<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<% 
				case 19101  
					arrDescripTemp = split(strDescrip,"|")
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE TRANSFERENCIA MOVIL EN EFECTIVO</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >REMITENTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">BENEFICIARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >MONTO:</td>
							<td colspan="4"><span class="textoImpresionP">Q. <%=FormatNumber(strMonto,2)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >REFERENCIA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						</tr>
												<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " " & strHora%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 19002
				arrDescripTemp = split(strDescrip,"|")
				%>
					<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO CR&Eacute;DITOS</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NO. DE CR&Eacute;DITO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strCuenta%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">TIPO DE CR&Eacute;DITO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >TITULAR DEL CREDITO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr> 	
							<td width=135 ><p align="right" class="textoImpresionP" ></span></td>
							<td colspan="4"><span class="textoImpresionP"><br></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >VALOR PAGADO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto,2)%></span></td>
						</tr>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >No. de Recibo:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " " & strHora%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%
					case 19103 
					arrDescripTemp = split(strDescrip,"|")
				%>
				<tr>
					<td align= center colspan="5">
						<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">ENV&Iacute;O DE TRANSFERENCIA LOCAL </font></div>
						<br>
					</td>
				</tr>
				<tr>
					<td width=135><p align="right" class="textoImpresionP" >REMITENTE:</td>
					<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
				
				</tr>
				<tr> 
						
					<td width=135 ><p align="right" class="textoImpresionP" >IDENTIFICACI&Oacute;N:</span></td>
					<td colspan="4"><span class="textoImpresionP">DPI <%=arrDescripTemp(1)%><br></span></td>
					
			
				</tr>
				<tr>
						
					<td width=135 ><p align="right" class="textoImpresionP">BENEFICIARIO:</td>
					<td colspan="4"><span class="textoImpresionP"> <%=arrDescripTemp(2)%></span>   <span class="textoImpresionP"><%=arrDescripTemp(3)%></span>   <span class="textoImpresionP"><%=arrDescripTemp(4)%></span></td>	
				</tr>
				<tr>
						
					<td width=135><p align="right" class="textoImpresionP" >PARENTESCO:</td>
					<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(5)%>&nbsp;</span></td>
					
				</tr>
					
				<tr>
						
					<td width=135><p align="right" class="textoImpresionP">C&Oacute;DIGO DE TRANSFERENCIA:</td>
					<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(9)%></span></td>
				</tr>
					
				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">VALOR DE TRANSFERENCIA:</td>
					<td colspan="4"><span class="textoImpresionP"> <%= "Q" & FormatNumber(arrDescripTemp(6))%></span></td>
				</tr>

				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">COMISION:</td>
					<td colspan="4"><span class="textoImpresionP"> <%= "Q" & FormatNumber(arrDescripTemp(7))%></span></td>
				</tr>
				
				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">TOTAL A PAGAR:</td>
					<td colspan="4"><span class="textoImpresionP"> <%= "Q" & FormatNumber(strMonto)%></span></td>
				</tr>

				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">NO BOLETA:</td>
					<td colspan="4"><span class="textoImpresionP"> <%=strSecuencial%></span></td>
				</tr>
				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">FECHA:</td>
					<td colspan="4"><span class="textoImpresionP"> <%= strFecha& " "  & strHora%></span></td>
				</tr>
				<tr>
					<td align= center colspan="5">
						<span class="textoImpresionP">
						<br>
						<br>
						F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
					<tr>
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>	
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table>
			<%
					case 19104 
					arrDescripTemp = split(strDescrip,"|")
				%>
				<tr>
					<td align= center colspan="5">
						<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Cambio de Beneficiario</font></div>
						<br>
					</td>
				</tr>
				<tr>
					<td width=135><p align="right" class="textoImpresionP" >REMITENTE:</td>
					<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
				
				</tr>
				<tr> 
						
					<td width=135 ><p align="right" class="textoImpresionP" >IDENTIFICACI&Oacute;N:</span></td>
					<td colspan="4"><span class="textoImpresionP">DPI <%=arrDescripTemp(1)%><br></span></td>
					
			
				</tr>
				<tr>
						
					<td width=135 ><p align="right" class="textoImpresionP">BENEFICIARIO:</td>
					<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3) & " "%><%=arrDescripTemp(4) & " "%><%=arrDescripTemp(5)%><br></span></td>
						
				</tr>
				<tr>
						
					<td width=135><p align="right" class="textoImpresionP" >CODIGO DE TRANSFERENCIA:</td>
					<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%>&nbsp;</span></td>
					
				</tr>
					
				<tr>
						
					<td width=135><p align="right" class="textoImpresionP">MONTO A PAGAR:</td>
					<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%></span></td>
				</tr>
					
				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">NO. BOLETA:</td>
					<td colspan="4"><span class="textoImpresionP"> <%=strSecuencial%></span></td>
				</tr>

				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">FECHA:</td>
					<td colspan="4"><span class="textoImpresionP"> <%= strFecha& " "  & strHora%></span></td>
				</tr>
				<tr>
					<td align= center colspan="5">
						<span class="textoImpresionP">
						<br>
						<br>
						F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
					<tr>
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
			</table>
			<table>		
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
			</table> 
				<%case 18116 ' Pago de Genesis
				arrDescripTemp = split(strDescrip,"|")

				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIOS</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >PAGO DE:</td>
							<td colspan="4"><span class="textoImpresionP">FUNDACION GENESIS EMPRESARIAL</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">CREDITO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strCuenta%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >POR UN VALOR DE:</td>
							<td colspan="4"><span class="textoImpresionP">Q. <%=FormatNumber(strMonto)%></span></td>
						</tr>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >AUTORIZACI&Oacute;N:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >N&Uacute;MERO DE BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<% case 19003   ' Paga Tarjeta de Credito
						Dim  moneda
						moneda = 0
					arrDescripTemp = split(strDescrip,"$")
					if ubound(arrDescripTemp) > 1 then
						moneda = 1
					end if
				
										
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO TARJETA DE CREDITO</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >TARJETA:</td>
							<%if moneda = 0 then%>
							<td colspan="4"><span class="textoImpresionP"><%=mid(strCuenta, 1, 4)& " XXXX XXXX " & mid(strCuenta, 13,16)%></span></td>
							<%else%>
							<td colspan="4"><span class="textoImpresionP"><%=mid(arrDescripTemp(0), 1, 4)& " XXXX XXXX " & mid(arrDescripTemp(0), 13,16)%></span></td>
							<%end if%>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">NOMBRE CLIENTE:</td>
							<%if moneda = 1 then%>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%></span></td>
							<%else%>
							<td colspan="4"><span class="textoImpresionP"><%=strDescrip%></span></td>
							<%end if%>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >VALOR:</td>
							<td colspan="4"><span class="textoImpresionP">
							<%
							if moneda = 1 then
								strMonto = arrDescripTemp(2)
								strMonto = strMonto / arrDescripTemp(1)
							%>
							$&nbsp;
							<%
							else
							%>
							Q&nbsp;
							<%
							end if
							%>
							<%=FormatNumber(strMonto)%>&nbsp;</span></td>
						</tr>
						<%if moneda = 1 then%>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >TASA DE CAMBIO:</td>
							<td colspan="4"><span class="textoImpresionP">Q&nbsp;<%=arrDescripTemp(1)%>&nbsp;</span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >EQUIVALENTE Q:</td>
							<td colspan="4"><span class="textoImpresionP">Q&nbsp;<%=FormatNumber(arrDescripTemp(2))%>&nbsp;</span></td>
						</tr>
						<%end if%>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >REFERENCIA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %></span></td>
						</tr>
					
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 18119 'Pago de PMA
				arrDescripTemp = split(strDescrip,"|")
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIOS</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >PAGO DE SERVICIO:</td>
							<td colspan="4"><span class="textoImpresionP">APORTE PROGRAMA MUNDIAL DE ALIMENTOS</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">TIPO DE BENEFICIARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >CODIGO BENEFICIARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >IDENTIFICACION:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE BENEFICIARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >No. BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >TOTAL APORTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
						</tr>
							<tr>
							<td width=135><p align="right" class="textoImpresionP" >TOTAL A PAGAR:</td>
							<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
						</tr>
							<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<% case 18154 ' Pago MUNDIAL MILLON
						Dim acuerdoGub1
						Dim acuerdoGub2
						Dim arrAcuerdos

						arrDescripTemp = split(strDescrip,"|")
						arrAcuerdos = split(arrDescripTemp(8), ",")
						acuerdoGub1 = arrAcuerdos(0)
						acuerdoGub2 = arrAcuerdos(1)
				%>		
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">EXPEDIENTE <%=acuerdoGub1%> BAJO LA RESOLUCI&Oacute;N <%=acuerdoGub2%> EMITIDA POR GOBERNACI&Oacute;N DEPARTAMENTAL DE GUATEMALA. 
								</span>
							</td>		
						</tr>						
						<tr>
						<td align= center colspan="5"><div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIOS</font></div>
							<br>
						</td>
						</tr>						
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >PAGO DE SERVICIO:</td>
							<td colspan="4"><span class="textoImpresionP">MUNDIAL DEL MILLON BANRURAL</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">NOMBRE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >IDENTIFICACI&Oacute;N:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >TELEFONO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >VATICINIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%></span></td>
						</tr>
						<% IF arrDescripTemp(5) = "2" THEN  %>
							<tr>
								<td width=135><p align="right" class="textoImpresionP" >NO TARJETA:</td>
								<td colspan="4"><span class="textoImpresionP"><%=mid(arrDescripTemp(6), 1, 4)& " XXXX XXXX " & mid(arrDescripTemp(6), 13,16)%></span></td>
							</tr>
							<tr>
								<td width=135><p align="right" class="textoImpresionP" >NO AUTORIZACI&Oacute;N:</td>
								<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(7)%></span></td>
							</tr>
						<% END IF  %>
						
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NO BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
							<tr>
							<td width=135><p align="right" class="textoImpresionP" >MONTO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
						</tr>
							<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha& " "  & strHora%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
			
			<%CASE 18255 'retiros genericos 
			%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGOS GEN&Eacute;RICOS</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td align= left colspan="4">
								<span class="textoImpresionP">
                         			BANCO DE DESARROLLO RURAL S,A. - Pagos Genericos 1700 - <%=reso5 %> - <%=strNombreEmpresa %> - N-ON - QUETZALES  996 <%=Session("VGLogin")%> <%=esp%> <%=strFechaR%> <%=strHoraR%> <%=esp%> <%=strSecuencial%> <%=esp%> <%=strSecuencial + 1%>
								    FORMA ELECTRONICA NO:<%=Recibo%>  SERIE: <%=Resolucion%> BOLETA:<%=strSecuencial%>
                        		<br><br>
                        		</span>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >TRANSACCION:</td>
							<td colspan="4"><span class="textoImpresionP"><%=reso1%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">NO. BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >DPI:</td>
							<td colspan="4"><span class="textoImpresionP"><%=reso2%></span></td>
						</tr>
						<%  if reso6 <> "" Then%>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >LLAVE ALTERNA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=reso6%></span></td>
						</tr>
						<% end if%>
						
						<tr>
							<td width=135><p align="right" class="textoImpresionP" ><%=R1%></td>
							<td colspan="4"><span class="textoImpresionP"><%=ref1%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" ><%=R2%></td>
							<td colspan="4"><span class="textoImpresionP"><%=ref2%></span></td>
						</tr>

						<tr>
							<td width=135><p align="right" class="textoImpresionP" ><%=R3%></td>
							<td colspan="4"><span class="textoImpresionP"><%=ref3%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" ><%=R4%></td>
							<td colspan="4"><span class="textoImpresionP"><%=ref4%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" ><%=R5%></td>
							<td colspan="4"><span class="textoImpresionP"><%=ref5%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" ><%=reso3%></td>
							<td colspan="4"><span class="textoImpresionP"><%=reso4%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >VALOR A PAGAR:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strTotal%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strHoraR%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
						<br>
						
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 18102 'Pago de Renap
				arrDescripTemp = split(strDescrip,"|")
				Call PagoRenap()
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIOS</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP"><%=strLinea1%><%=strLinea2%><%=strLinea3%><br><br></span>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >PAGO DE SERVICIO:</td>
							<td colspan="4"><span class="textoImpresionP">RENAP</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">REFERENCIA NO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(7)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >TRAMITE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NO. COPIAS:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%></span></td>
						</tr>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >MONTO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOTA DE PAGO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >CORRELATIVO CGC NO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(5)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
			<% case 19303
					arrDescripTemp = split(strDescrip,"|")
				%>
			<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">COMPRA DE POLIZA DE SEGURO MIGRANTE<br><br></font></div>
								
							</td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">DATOS DE LA POLIZA<br><br></span>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NUMERO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strCuenta%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">FORMA DE PAGO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >PLAN CONTRATADO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA DE EMISION:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">DATOS DEL CLIENTE<br><br></span>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >TOTAL A PAGAR:</td>
							<td colspan="4"><span class="textoImpresionP">Q <%= formatNumber(strMonto)%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<% case 19302
					arrDescripTemp = split(strDescrip,"|")
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">COMPRA DE POLIZA DE SEGURO MIGRANTE<br><br></font></div>
								
							</td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">DATOS DE LA POLIZA<br><br></span>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NUMERO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strCuenta%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">FORMA DE PAGO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >PLAN CONTRATADO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA DE EMISION:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strFecha%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">DATOS DEL CLIENTE<br><br></span>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >TOTAL A PAGAR:</td>
							<td colspan="4"><span class="textoImpresionP">Q <%= formatNumber(strMonto)%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
			<% case 18002 
				arrDescripTemp = Split(strDescrip, "|") 'obtiene los datos de remesador y beneficiario
			%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REVERSI&Oacute;N DE PAGO DE REMESAS<br><br></font></div>
								
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >REMESADOR:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">NUMERO DE REMESA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strCuenta%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >BENEFICIARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >TOTAL A REVERSAR (QUETZALES):</td>
							<td colspan="4"><span class="textoImpresionP"><%=FormatNumber(strMonto,2)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha %></span></td>
						</tr>
		
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
			<% case 19102 ' Pago TRANSFERENCIAS LOCALES
				arrDescripTemp = split(strDescrip,"|")
			%>	
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE TRANSFERENCIA<br><br></font></div>
								
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE DEL BENEFICIARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">DPI BENEFICIARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE DEL REMITENTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >DPI REMITENTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >C&Oacute;DIGO DE TRANSFERENCIA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NO. BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >MONTO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha& " "  & strHora%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<% case 19401 ' >COMPRA CON TARJETA DE CREDITO 
						arrDescripTemp = split(strDescrip,"|")
					%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">COMPRA CON TARJETA DE CR&Eacute;DITO<br><br></font></div>
								
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >SERVICIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">No TARJETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=mid(arrDescripTemp(3), 1, 4)& " XXXX XXXX " & mid(arrDescripTemp(3), 13,16)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >MONTO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >AUTORIZACI&Oacute;N:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NO. BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><% = strFecha& " "  & strHora%>&nbsp;</span></td>
						</tr>
				
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%
					case 19371 ' Apertura Cuenta
					arrDescripTemp = split(strDescrip,"|")

					Dim strnombreAperturaT, numeroCuentaAperturaT, tipoCuentaAperturaT, agenciaMatrizAperturaT
					Dim solicitaChequeraT, solicitaTarjetaT, solicitaNotifiT, solicitaBancaT
					Dim telefonoT, correoT

					strnombreAperturaT = trim(arrDescripTemp(2))
					strnombreAperturaT = server.htmlEncode(strnombreAperturaT)
					
					tipoCuentaAperturaT = trim(arrDescripTemp(0))
					tipoCuentaAperturaT = server.htmlEncode(tipoCuentaAperturaT)
					agenciaMatrizAperturaT = trim(arrDescripTemp(1))
					
					solicitaChequeraT = trim(arrDescripTemp(4))
					solicitaTarjetaT = trim(arrDescripTemp(5))
					solicitaNotifiT = trim(arrDescripTemp(6))
					solicitaBancaT = trim(arrDescripTemp(7))
					telefonoT = trim(arrDescripTemp(8))
					correoT = trim(arrDescripTemp(9))

					if solicitaChequeraT = "S" Then 
						solicitaChequeraT = "S&iacute;"
					else 
						solicitaChequeraT = "No"
					end If

					if solicitaTarjetaT = "S" Then 
						solicitaTarjetaT= "S&iacute;"
					else 
						solicitaTarjetaT = "No"
					end If

					if solicitaNotifiT = "S" Then 
						solicitaNotifiT= "S&iacute;"
					else 
						solicitaNotifiT = "No"
					end If

					if solicitaBancaT = "S" Then 
						solicitaBancaT= "S&iacute;"
					else 
						solicitaBancaT = "No"
					end If
					%>

				<tr>
					<td align= center colspan="5">
						<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">SOLICITUD DE APERTURA DE CUENTA</font></div>
						<br>
					</td>
				</tr>
				<tr>
					<td width=135 ><p align="right" class="textoImpresionP">Nombre: </td>
					<td colspan="4"><span class="textoImpresionP"><%=strNombreAperturaT%><br></span></td>
				</tr>
				<tr> 
						
					<td width=135 ><p align="right" class="textoImpresionP">N&uacute;mero de Cuenta:</td>
					<td colspan="4"><span class="textoImpresionP"><%=strCuenta%> <br></span></td>
				</tr>
				<tr>
					<td width=135 ><p align="right" class="textoImpresionP">Tipo de Cuenta:</td>
					<td colspan="4"><span class="textoImpresionP"><%=tipoCuentaAperturaT%><br></span></td>
				</tr>
				<tr>
					<td width=135><p align="right" class="textoImpresionP" >Deposito Inicial:</td>
					<td colspan="4"><span class="textoImpresionP">Q.&nbsp; <%=FormatNumber(strMonto)%></span></td>
				</tr>
				<% if Left(tipoCuentaAperturaT, 1) = "M" then %>
				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">Solicitud de chequera:</td>
					<td colspan="4"><span class="textoImpresionP"><%=solicitaChequeraT%></span></td>
				</tr>
				<%end if%>
				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">Solicitud de tarjeta de d&eacute;bito:</td>
					<td colspan="4"><span class="textoImpresionP"><%=solicitaTarjetaT%></span></td>
				</tr>	
				<% if solicitaTarjetaT = "S&iacute;" or solicitaChequeraT = "S&iacute;" then %>
				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">Agencia para entrega de productos:</td>
					<td colspan="4"><span class="textoImpresionP"><%=R2%></span></td>
				</tr>
				<%end if%>
				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">Solicitud de notificaciones m&oacute;viles:</td>
					<td colspan="4"><span class="textoImpresionP"><%=solicitaNotifiT %></span></td>
				</tr>
				
				<tr>
					<td width=135><p align="right" class="textoImpresionP">N&uacute;mero de tel&eacute;fono:</td>
					<% if telefonoT <> "" then %>
						<% if len(telefonoT) >= 8 then %>
							<td colspan="4"><span class="textoImpresionP"><%=ofuscaTelefono(telefonoT)%></span></td>
						<% else %>
							<td colspan="4"><span class="textoImpresionP"><%=""%></span></td>
						<% end if %>
					<% else %>
						<td colspan="4"><span class="textoImpresionP"><%=""%></span></td>
					<% end if %>
				</tr>
				
				<tr>
					
					<td width=135><p align="right" class="textoImpresionP">Correo electr&oacute;nico:</td>
					<td colspan="6"><span class="textoImpresionP"><%=correoT%></span></td>
				</tr>
				<tr>
					
					<td width=135><p align="right" class="textoImpresionP">Fecha:</td>
					<td colspan="4"><span class="textoImpresionP"><%=strFecha%>&nbsp;<%=strHora%></span></td>
				</tr>
				<tr>
                    <td align= center colspan="4">
                        <span class="textoImpresionP">
                            <br>Cliente amigo para finalizar la gesti&oacute;n de solicitud de apertura de cuenta, deber&aacute;s acercarte a la agencia de entrega del producto en un tiempo no mayor a 30 dias, presentando DPI y recibo original.
                        </span><br>
                    </td>
                </tr>
				<% if solicitaNotifiT= "S&iacute;" then %>
					<tr>
                        <td align= center colspan="4">
                            <span class="textoImpresionP">
                                Cliente amigo las tarifas de notificaciones m&oacute;viles a partir del tercer mes ser&aacute;:
                            </span><br>
                            <span class="textoImpresionP">
                                De 01 a 60 Q.5.00, de 61 a 500 Q.10.00 y de 501 en adelante Q.10cts por mensaje.
                            </span>
                        </td>
                    </tr>
				<%end if%>
				<% if solicitaTarjetaT= "S&iacute;" then %>
					</br>	
					<tr>
						<td colspan="4" align="center">
							<span class="textoImpresionP"> <b>IMPORTANTE</b> BANRURAL por este medio autoriza la adhesi&oacute;n de la PRESTACI&Oacute;N DE SERVICIOS BANCARIOS PARA USO DE FONDOS A TRAV&Eacute;S DE TARJETA DE D&Eacute;BITO formalizada en este contrato enviado por correo electr&oacute;nico, el CLIENTE acepta los t&eacute;rminos y condiciones de uso. 
							</span>
						</td>						
					</tr>
				<%end if%>	
            		<br>			
					<tr>
						<td align= center colspan="4">
							<span class="textoImpresionP">
								<br>Cliente amigo esta transacci&oacute;n no tiene ning&uacute;n costo.
							</span>
						</td>					
					</tr>
					<br>
				<tr>
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
				<tr align= center colspan="4">
					<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
					<td>&nbsp;</td>	
					<td>&nbsp;</td>					
					<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
				</tr>
				</table>
				<table>		
				<tr>
				<br>
				<td align= center colspan="4">
					<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
					</span>
				</td>						
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				</table>
				<%
					case 18167 ' Universidad DaVinci
					arrDescripTemp = split(strDescrip,"|")

					Dim strCarne, strCarrera, strNombre, strTipoPago
					Dim strAnio, strPeriodo, strMontoPago, strSaldoPendiente
					Dim arrFechaAnio, descripcionPago, periodoArr
					
					strCarne = trim(arrDescripTemp(1))
					strCarrera = trim(arrDescripTemp(6))
					strNombre = trim(arrDescripTemp(0))
					strTipoPago = trim(arrDescripTemp(3))
					Select Case strTipoPago
						case "MEN":
								descripcionPago = "MENSUALIDADES"
						case "INS":
								descripcionPago = "INSCRIPCION"
					End Select
					
					arrFechaAnio = Split(arrDescripTemp(5),"/")
					
					strPeriodo = trim(arrDescripTemp(4))
					
					strPeriodo = Replace(strPeriodo, "Año:", " ")
					strPeriodo = Replace(strPeriodo, "Periodo:", " ")

					periodoArr = Split(strPeriodo,"-")
					
					strMontoPago = trim(arrDescripTemp(2))
					strSaldoPendiente = trim(ref2)

					%>

				<tr>
					<td align= center colspan="5">
						<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">UNIVERSIDAD DA VINCI</font></div>
						<br>
					</td>
				</tr>
				<tr>
					<td width=135 ><p align="right" class="textoImpresionP">Carne: </td>
					<td colspan="4"><span class="textoImpresionP"><%=strCarne%><br></span></td>
				</tr>
				<tr> 
						
					<td width=135 ><p align="right" class="textoImpresionP">Carrera:</td>
					<td colspan="4"><span class="textoImpresionP"><%=strCarrera%> <br></span></td>
				</tr>
				<tr>
					<td width=135 ><p align="right" class="textoImpresionP">Nombre:</td>
					<td colspan="4"><span class="textoImpresionP"><%=strNombre%><br></span></td>
				</tr>
				<tr>
					<td width=135><p align="right" class="textoImpresionP" >Tipo de pago:</td>
					<td colspan="4"><span class="textoImpresionP"><%=strTipoPago%> - <%=descripcionPago%></span></td>
				</tr>
				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">Año:</td>
					<td colspan="4"><span class="textoImpresionP"><%=Trim(periodoArr(0))%></span></td>
				</tr>
				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">Periodo:</td>
					<td colspan="4"><span class="textoImpresionP"><%=Trim(periodoArr(1))%></span></td>
				</tr>	
				<tr>
					<td  width=135 ><p align="right" class="textoImpresionP">N&uacute;mero de boleta:</td>
					<td colspan="4"><span class="textoImpresionP"><%=strSecuencial %></span></td>
				</tr>
				<tr>
					<td width=135><p align="right" class="textoImpresionP">Monto a pagar:</td>
					<td colspan="4"><span class="textoImpresionP">Q. <%=FormatNumber(strMontoPago)%></span></td>
				</tr>
				<tr>
					
					<td width=135><p align="right" class="textoImpresionP">Saldo pendiente:</td>
					<td colspan="6"><span class="textoImpresionP">Q. <%=FormatNumber(strSaldoPendiente)%></span></td>
				</tr>
				<tr>
					
					<td width=135><p align="right" class="textoImpresionP">Recibo:</td>
					<td colspan="6"><span class="textoImpresionP"><%=R1%></span></td>
				</tr>
				<tr>
					<td width=135><p align="right" class="textoImpresionP">Fecha:</td>
					<td colspan="4"><span class="textoImpresionP"><%=strFecha%>&nbsp;<%=strHora%></span></td>
				</tr>
				<tr>
					<td align= center colspan="5">
						<span class="textoImpresionP">
						<br>
						<br>
						<br>	
						<br>
						<br>
						F: ___________________________________________<br>
						(Recib&iacute; Conforme)
						<br>
						<br>
						</span>
					</td>																
				</tr>
				<tr>
                    <td align= center colspan="4">
                        <span class="textoImpresionP">
                            <br><%=ref1%>, <%=R2%>
                        </span><br>
                    </td>
                </tr>
					<br>
				<tr>
					<td align= center colspan="5">
						<span class="textoG">
						<br>
						ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
						<br>
						<br>
						</span>
						</td>																
					</tr>
				<tr align= center colspan="4">
					<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
					<td>&nbsp;</td>	
					<td>&nbsp;</td>					
					<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
				</tr>
				</table>
				<table>		
				<tr>
				<br>
				<td align= center colspan="4">
					<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
					</span>
				</td>						
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				</table>
				<%case 18902 ' Beneficio Social
					arrDescripTemp = split(strDescrip,"|")
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">RETIRO - PROGRAMA DE BENEFICIO SOCIAL<br><br></font></div>
								
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">&nbsp;</td>
							<td colspan="4"><span class="textoImpresionP">&nbsp;</span></td>
						</tr>
						<tr>
						
							<td colspan="5"><p align="center" class="textoImpresionSecuencial">BOLETA: &nbsp;&nbsp;&nbsp;&nbsp;<span class="textoImpresionSecuencial"><%= strSecuencial %></td>
						
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">&nbsp;</td>
							<td colspan="4"><span class="textoImpresionP">&nbsp;</span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >PROGRAMA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(7) %><br></span></td>
				
						</tr>
						
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">ID PRIMARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(1) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >ID SECUNDARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(2) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >DOCUMENTO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strCuenta %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NOMBRE DEL BENEFICIARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(3) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >DEPARTAMENTO DE PAGO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(5) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >MUNICIPIO DE PAGO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(6) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(4) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >MONTO A RETIRAR:</td>
							<td colspan="4"><span class="textoImpresionP">Q <%= FormatNumber(strMonto,2) %></span></td>
						</tr>

						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								<br>	
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 19151 ' Teleton
					arrDescripTemp = split(strDescrip,"|")
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">APORTE TELET&Oacute;N<br><br></font></div>
								
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >No. DE CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP">9999</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">NOMBRE DE LA CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP">Aportes - Banrural Telet&oacute;n</span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >VALOR DEL APORTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto,2)%>&nbsp;</span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NUMERO DE TRASACCI&Oacute;N:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " " & strHora%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 18156 'Pago Pensiones Alimenticias OJ
					arrDescripTemp = split(strDescrip,"|")
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">DEPOSITO PENSIONES ALIMENTICIAS</font></div>
								<br>
							</td>
						</tr>
						<tr>
							<td align="center" colspan="5"><span class="textoImpresionP"><%= R1 & " " & ref1 & " " & R2 & " " & ref2 & " " & R3%></span></td>
						</tr>
					
						<tr>
							<td align="center" colspan="5">
								<span class="textoImpresionP">SERIE: <%=arrDescripTemp(1)%>&nbsp;</span>
								<span class="textoImpresionP">&nbsp;No.: <%=arrDescripTemp(2)%>&nbsp;</span>
							</td> 
						</tr>
						<tr>
							<td colspan="5">&nbsp;</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >REFERENCIA NO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=(strSecuencial)%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">CASO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(2) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >MESES:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(0) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >BENEFICIARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=R5%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >DEPENDENCIA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=ref5%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >DEPOSITANTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=R4%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=ref4%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >MONTO:</td>
							<td colspan="4"><span class="textoImpresionP">Q <%= FormatNumber(strMonto,2) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="5">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>	
							<td>&nbsp;</td>								
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 18155 'Pago Antecedentes OJ
					arrDescripTemp = split(strDescrip,"|")
					%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO ANTECEDENTES PENALES<br><br></font></div>
							</td>
							<tr>
								<td align="center" colspan="5"><span class="textoImpresionP"><%= R1 & " " & ref1 & " " & R2 & " " & ref2 & " " & R3%></span></td>
							</tr>
							<tr align="center">
								<td align="center" colspan="1"><span class="textoImpresionP">SERIE: <%=arrDescripTemp(0)%></span></td> 
								<td align="center" colspan="2"><span class="textoImpresionP">NO: <%=arrDescripTemp(1)%></span></td> 
								<td align="center" colspan="2"><span class="textoImpresionP">V.: <%=arrDescripTemp(7)%></span></td> 
							</tr>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >TRANSACCION:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">REFERENCIA NO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= (strSecuencial) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >BENEFICIARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(5) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >DEPENDENCIA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(6) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(4) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >MONTO:</td>
							<td colspan="4"><span class="textoImpresionP">Q <%= FormatNumber(strMonto,2) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
		<%case  18157 'PAGO FEI FORMULARIO ELECTRONICO
					arrDescripTemp = split(strDescrip,"|")
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">O.J. - DEPOSITOS FORMULARIO ELECTRONICO DE INGRESOS (FEI) <br><br></font></div>
							</td>
							<tr>
								<td align="center" colspan="5"><span class="textoImpresionP"><%= R1 & " " & ref1 & " " & R2 & " " & ref2 & " " & R3%></span></td>
							</tr>
							<tr align="center">
								<td align="center" colspan="1"><span class="textoImpresionP">SERIE: <%=arrDescripTemp(0)%></span></td> 
								<td align="center" colspan="3"><span class="textoImpresionP">NO: <%=arrDescripTemp(1)%></span></td> 
								<td align="center" colspan="1"><span class="textoImpresionP">VERIF: <%=arrDescripTemp(2)%></span></td> 
							</tr>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP">REFERENCIA NO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= (strSecuencial) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >NO FEI:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%></span></td>
						</tr>
						
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >CASO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(5) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >DEPOSITANTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=R4%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >BENEFICIARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=R5%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=ref4%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >DEPENDENCIA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(6) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >MONTO:</td>
							<td colspan="4"><span class="textoImpresionP">Q <%= FormatNumber(strMonto,2) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 18158 'contraloria
					arrDescripTemp = split(strDescrip,"|")
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">CONTRALOR&Iacute;A GENERAL DE CUENTAS<br><br></font></div>
							</td>
						</tr>
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP"><%=reso1%><%=reso2%><%=reso3%><%=reso4%><%=reso5%><%=reso6%><br><br></span>

							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">PAGO DE SERVICIO:</td>
							<td colspan="4"><span class="textoImpresionP">CONTRALOR&Iacute;A GENERAL DE CUENTAS</span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FORMA 63A NO.:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(7)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">MARCA DE CAJA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(6)%></span></td>
						</tr>
                        <tr>
							<td width=135><p align="right" class="textoImpresionP">BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">TIPO PAGO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%>-<%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">CODIGO PAGO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%>-<%=arrDescripTemp(3)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">DESCRIPCION:</td>
							<td colspan="4"><span class="textoImpresionP"><%=R2%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">NIT:</td>
							<td colspan="4"><span class="textoImpresionP"><%=R1%> -<%=ref1%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">VALOR UNITARIO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto / arrDescripTemp(5))%></span></td>  
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">NO. COPIAS:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(5)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FORMA DE PAGO:</td>
							<td colspan="4"><span class="textoImpresionP">EFECTIVO: <%= "Q" & FormatNumber(strMonto)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">MONTO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 18159 'Antecedentes Policiales
					arrDescripTemp = split(strDescrip,"|")
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO SERVICIOS<br><br></font></div>
								
							</td>
						</tr>
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP"><%=reso1%><%=reso2%><%=reso3%><%=reso4%><%=reso5%><%=reso6%><br><br></span>

							</td>
						</tr>
						<tr align="center">
							<td align="center" colspan="2"><span class="textoImpresionP">FORMA 63A NO.: <%=arrDescripTemp(1)%><br><br></span></td> 
							<td align="center" colspan="3"><span class="textoImpresionP">No.: <%=arrDescripTemp(2)%><br><br></span></td> 
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">PAGO DE SERVICIO:</td>
							<td colspan="4"><span class="textoImpresionP">ANTECEDENTES POLICIALES</span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">BOLETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">REFERENCIA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">No. AUTORIZACION:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">MONTO:</td>
							<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto,2)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
		<%case 18160 'servicios extranjeria
					arrDescripTemp = split(strDescrip,"|")
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO SERVICIOS<br><br></font></div>
								
							</td>
						</tr>
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP"><%=reso1%><%=reso2%><%=reso3%><%=reso4%><%=reso5%><%=reso6%><br><br></span>

							</td>
						</tr>
				
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">IGM - EXTRANJERIA - <%=R1%> - <%=arrDescripTemp(5)%><br></span>

							</td>
						</tr>
						<tr>
							<td align= center colspan="4">
							<span class="textoImpresionP">CORRELATIVO CGC No.: <%=arrDescripTemp(4)%> Boleta: <%=strSecuencial%><br></span>

							</td>
						</tr>
						<tr align="center">
							<td colspan="5"><span class="textoImpresionP">&nbsp;</span></td>
						</tr>
				
						<tr> 	
							<td width=135 ><p align="right" class="textoImpresionP" >ORDEN PAGO:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=R3%></span></td>
						</tr>
				
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >PASAPORTE:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=ref2%><br></span></td>
						</tr>
						
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >NOMBRES:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=R2%><br></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >TOTAL EN $:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=FormatNumber(arrDescripTemp(1),2)%><br></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >TASA:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%= FormatNumber(arrDescripTemp(2),2)%><br></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >TOTAL Q.:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%= FormatNumber(strMonto,2)%><br></span></td>
						</tr>
						<tr align="center">
							<td colspan="5"><span class="textoImpresionP">FORMA DE PAGO</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >EFECTIVO:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=  FormatNumber(strMonto,2)%>&nbsp;</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >CH/PROPIO:</span></td>
							<td colspan="4"><span class="textoImpresionP">Q 0.00</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >TOTAL PAGADO:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=  FormatNumber(strMonto,2)%>&nbsp;</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >ORIGINAL:</span></td>
							<td colspan="4"><span class="textoImpresionP">USUARIO</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >DUPLICADO:</span></td>
							<td colspan="4"><span class="textoImpresionP">UNIDAD DE ARCHIVO IGM</span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>						  
				<%case 18161 'servicios pasaportes
					arrDescripTemp = split(strDescrip,"|")
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO SERVICIOS - PASAPORTES<br><br></font></div>
								
							</td>
						</tr>
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP"><%=reso1%><%=reso2%><%=reso3%><%=reso4%><%=reso5%><%=reso6%><br><br></span>

							</td>
						</tr>
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">COBRO IGM - PASAPORTES - <%=R1%> - <%=arrDescripTemp(4)%><br></span>

							</td>
						</tr>
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">CORRELATIVO CGC No.: <%=arrDescripTemp(3)%> Boleta: <%=strSecuencial%><br></span>
		
							</td>
						</tr>
						<tr align="center">
							<td colspan="5"><span class="textoImpresionP">&nbsp;</span></td>
						</tr>
		
					
						<tr> 	
							<td width=135 ><p align="right" class="textoImpresionP" >TIPO PASAPORTE:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=ref2 & " - "& ref3%></span></td>
						</tr>
				
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >BOLETA IDENTIFICACI&Oacute;N:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=R4%><br></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >NOMBRES:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=R2%><br></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >APELLIDO:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=R3%><br></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >MONTO EN $:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=FormatNumber(arrDescripTemp(0),2)%><br></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >TASA:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%= FormatNumber(arrDescripTemp(1),2)%><br></span></td>
						</tr>
					
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >TOTAL Q:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=  FormatNumber(strMonto,2)%>&nbsp;</span></td>
						</tr>
						<tr align="center">
							<td colspan="5"><span class="textoImpresionP">FORMA DE PAGO</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >EFECTIVO:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=  FormatNumber(strMonto,2)%>&nbsp;</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >CH/PROPIO:</span></td>
							<td colspan="4"><span class="textoImpresionP">Q 0.00</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >TOTAL PAGADO:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=  FormatNumber(strMonto,2)%>&nbsp;</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >ORIGINAL:</span></td>
							<td colspan="4"><span class="textoImpresionP">USUARIO</span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >DUPLICADO:</span></td>
							<td colspan="4"><span class="textoImpresionP">UNIDAD DE ARCHIVO IGM</span></td>
						</tr>
						
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 19501 'BLOQUEO DE TARJETA DE DEBITO
					arrDescripTemp = split(strDescrip,"|")
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">BLOQUEO TARJETA DE DEBITO<br><br></font></div>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">NOMBRE DE LA CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">NO. DE TARJETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=ofuscaCuenta(arrDescripTemp(2))%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">ACCI&Oacute;N:</td>
							<td colspan="4"><span class="textoImpresionP">BLOQUEO</span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">CAUSA BLOQUEO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
							<tr>
								<td width=135><p align="right" class="textoImpresionP">MONTO:</td>
								<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%></span></td>
							</tr>
						<%End if %>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">SECUENCIAL:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
							<tr>
								<td colspan="6" >
									<div align="center">
										<span class="textoG"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
									</div>
								</td>
							</tr>
						<%End if%>
								
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 19502 'SOLICITUD DE TARJETA DE DEBITO
					arrDescripTemp = split(strDescrip,"|")

					if InStr(arrDescripTemp(2), "@") = 0 then
						medioEnvioOfuscado=ofuscaTelefono(arrDescripTemp(2))
					else
						medioEnvioOfuscado=ofuscaCorreo(arrDescripTemp(2))
					end if
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">SOLICITUD TARJETA DE DEBITO<br><br></font></div>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">NOMBRE DE TARJETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">NUMERO DE CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=ofuscaCuenta(arrDescripTemp(3))%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">AGENCIA DE ENTREGA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">ENVIADO A:</td>
							<td colspan="4"><span class="textoImpresionP"><%=medioEnvioOfuscado%></span></td>
						</tr>
						<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
							<tr>
								<td width=135><p align="right" class="textoImpresionP">MONTO:</td>
								<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%></span></td>
							</tr>
						<%End if%>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">SECUENCIAL:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " " &strHora %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
							<tr>
								<td colspan="6">
									<div align="center">
										<span class="textoG"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
									</div>
								</td>
							</tr>
						<%End if%>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr>
							<td colspan="5" >
								<br><span class="textoG"> <b>IMPORTANTE</b> BANRURAL por este medio autoriza la adhesi&oacute;n de la PRESTACI&Oacute;N DE SERVICIOS BANCARIOS PARA USO DE FONDOS A TRAV&Eacute;S DE TARJETA DE D&Eacute;BITO formalizada en este contrato enviado por correo electr&oacute;nico, el CLIENTE acepta los t&eacute;rminos y condiciones de uso. 
								</span><br>
							</td>
						</tr>
						<tr align= center colspan="5">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 19503 'REPOSICION DE TARJETA DE DEBITO
					arrDescripTemp = split(strDescrip,"|")
					
					if InStr(arrDescripTemp(2), "@") = 0 then
						medioEnvioOfuscado=ofuscaTelefono(arrDescripTemp(2))
					else
						medioEnvioOfuscado=ofuscaCorreo(arrDescripTemp(2))
					end if
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REPOSICION TARJETA DE DEBITO<br><br></font></div>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">NOMBRE DE TARJETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">NUMERO DE CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=ofuscaCuenta(arrDescripTemp(3))%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">AGENCIA DE ENTREGA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">ENVIADO A:</td>
							<td colspan="4"><span class="textoImpresionP"><%=medioEnvioOfuscado%></span></td>
						</tr>
						<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
							<tr>
								<td width=135><p align="right" class="textoImpresionP">MONTO:</td>
								<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%></span></td>
							</tr>
						<%End if%>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">SECUENCIAL:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " " &strHora %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
							<tr>
								<td colspan="6" >
									<div align="center">
										<span class="textoG"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
									</div>
								</td>
							</tr>
						<%End if%>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr>
							<td colspan="5" >
			                        <span class="textoG"> <b>IMPORTANTE</b> BANRURAL por este medio autoriza la adhesi&oacute;n de la PRESTACI&Oacute;N DE SERVICIOS BANCARIOS PARA USO DE FONDOS A TRAV&Eacute;S DE TARJETA DE D&Eacute;BITO formalizada en este contrato enviado por correo electr&oacute;nico, el CLIENTE acepta los t&eacute;rminos y condiciones de uso.<br>
                                                    <b>IMPORTANTE</b> La reposici&oacute;n por robo, extrav&iacute;o o deterioro tiene un costo de <b>Q.50.00<b> que se debitar&aacute; autm&aacute;ticamente de la cuenta asociada. </span>
			                    </td>
						</tr>
						<tr align= center colspan="5">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 19504 'CANCELACION DE TARJETA DE DEBITO
						arrDescripTemp = split(strDescrip,"|")
						Dim lenTarjetacancelada
						Dim tarjetaFincancelada
						Dim icancelar
						Dim tarjetaOfuscadacancelada
						lenTarjetacancelada = (len(arrDescripTemp(1))+1) - 4
						tarjetaFincancelada = mid(arrDescripTemp(1), lenTarjetacancelada, 4)
						For icancelar = 0 to (lenTarjetacancelada - 1)
							tarjetaOfuscadacancelada = tarjetaOfuscadacancelada + "X"
						Next
						tarjetaOfuscadacancelada = tarjetaOfuscadacancelada + tarjetaFincancelada
						
					%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">CANCELACI&Oacute;N TARJETA DE D&Eacute;BITO<br><br></font></div>
							</td>
						</tr>
						<tr>



							
							<td width=135><p align="right" class="textoImpresionP">CLIENTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">TARJETA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=tarjetaOfuscadacancelada%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">MOTIVO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
						
						<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
							<tr>
								<td width=135><p align="right" class="textoImpresionP">MONTO:</td>
								<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%></span></td>
							</tr>
						<%End if%>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">SECUENCIAL:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " " &strHora %></span></td>
						</tr>
												<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
							<tr>
								<td colspan="6" >
									<div align="center">
										<span class="textoG"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
									</div>
								</td>
							</tr>
						<%End if%>
						<tr>
							<td align= center colspan="5">
								<span class="textoG">
								<br>
								ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<tr align= center colspan="5">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 19701 'DINERO AL CHILAZO
					Dim cuentaAfiliadaDinero
					Dim lenCuentaAfiDinero
					Dim cuentaFinAfiDinero
					Dim iAfiDinero
					Dim cuentaOfusAfiDinero
					arrDescripTemp = split(strDescrip,"|")
					medioEnvioOfuscado=ofuscaTelefono(arrDescripTemp(1))

					cuentaAfiliadaDinero = trim(arrDescripTemp(3))
					lenCuentaAfiDinero = len(cuentaAfiliadaDinero) - 4
					cuentaFinAfiDinero = mid(cuentaAfiliadaDinero, lenCuentaAfiDinero+1, 4)

					For iAfiDinero = 0 to (lenCuentaAfiDinero - 1)
						cuentaOfusAfiDinero = cuentaOfusAfiDinero + "X"
					Next	
					cuentaOfusAfiDinero = cuentaOfusAfiDinero + cuentaFinAfiDinero
					
				%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">DINERO AL CHILAZO<br><br></font></div>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">No. DE CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP">GTQ/<%=cuentaOfusAfiDinero%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">CLIENTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">MONTO:</td>
							<td colspan="4"><span class="textoImpresionP">Q.<%=arrDescripTemp(2)%></span></td>
						</tr>
						<%
						If strMonto <> 0 Then
						%>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">COMISI&Oacute;N:</td>
							<td colspan="4"><span class="textoImpresionP">Q.<%=strMonto%></span></td>
						</tr>
						<%
						End If
						%>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">SECUENCIAL:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						
						<tr>
							<td width=135><p align="right" class="textoImpresionP">N&Uacute;MERO DE TEL&Eacute;FONO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=medioEnvioOfuscado%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " " &strHora %></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
						<tr>
							<td colspan="5" >
			                        <div align="center">
			                        	<span class="textoG"><br><strong> IMPORTANTE <br> El cliente acepta t&eacute;rminos y condiciones del servicio.<br> Amigo Banrural, el monto retirado y la comisi&oacute;n ser&aacute;n debitados de tu pr&oacute;ximo pago.</strong></span><br>
			                    	</div></td>
						</tr>
						
						<tr align= center colspan="5">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 19652 'CONSULTA SALDO NOTIFICACIONES MOVILES
					    arrDescripTemp = split(strDescrip,"|")
					    medioEnvioOfuscado=ofuscaTelefono(arrDescripTemp(1))
					%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">CONSULTA DE SALDO<br><br></font></div>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">CLIENTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">CUENTA:</td>
							<td colspan="4"><span class="textoImpresionP"><%=ofuscaCuenta(strCuenta)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">N&Uacute;MERO DE TEL&Eacute;FONO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=medioEnvioOfuscado%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " " &strHora %></span></td>
						</tr>
						<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
							<tr>
								<td width=135><p align="right" class="textoImpresionP">MONTO:</td>
								<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%></span></td>
							</tr>
						<%ELSE%>
							<tr>
								<td colspan="5" >
									<div align="center">
										<span class="textoG"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
									</div>
								</td>
							</tr>
						<%End if%>
						<tr>
							<td align= center colspan="5">
								<span class="textoG">
								<br>
								ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<tr align= center colspan="5">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 19653 'AFILIACION NOTIFICACIONES MOVILES
						Dim correoAfiliacion
						Dim telefonoAfiliado
						Dim telOfusAfi
						Dim strCuentasAfi
						Dim c

						arrDescripTemp = split(strDescrip,"|")
						For Each c In arrDescripTemp
							strCuentasAfi = strCuentasAfi + ofuscaCuenta(c) + "<br>"
						Next

						correoAfiliacion= ofuscaCorreo(R2)

						telefonoAfiliado = ofuscaTelefono(trim(ref1))
					%>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">AFILIACI&Oacute;N DE NOTIFICACIONES M&Oacute;VILES<br><br></font></div>
							</td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">CLIENTE:</td>
							<td colspan="4"><span class="textoImpresionP"><%=R1%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">N&Uacute;MERO(S) DE CUENTA(S):</td>
							<td colspan="4"><span class="textoImpresionP"><%=strCuentasAfi%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">N&Uacute;MERO DE TEL&Eacute;FONO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=telefonoAfiliado%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">CORREO ELECTR&Oacute;NICO:</td>
							<td colspan="4"><span class="textoImpresionP"><%=correoAfiliacion%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">FECHA:</td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " " &strHora %></span></td>
						</tr>
						<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
							<tr>
								<td width=135><p align="right" class="textoImpresionP">MONTO:</td>
								<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%></span></td>
							</tr>
						<%End if%>
						<tr>
						
							<td width=135><p align="right" class="textoImpresionP">SECUENCIAL:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
							<tr>
								<td align= center colspan="5">
									<span class="textoImpresionP">
										Cliente amigo esta transacci&oacute;n no tiene ning&uacute;n costo.
									</span>
								</td>					
							</tr>
						<%End if%>	
						<tr>
							<td colspan="5" >
								<div align="center">
									<span class="textoImpresionP">
										Cliente amigo las tarifas de notificaciones m&oacute;viles a partir del tercer mes ser&aacute;:
									</span><br>
									<span class="textoImpresionP">
										De 01 a 60 Q.5.00, de 61 a 500 Q.10.00 y de 501 en adelante Q.10cts por mensaje.
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoG">
								<br>
								ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<tr align= center colspan="5">
							<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
							<td>&nbsp;</td>	
							<td>&nbsp;</td>					
							<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>
				<%case 18162 'Pago tramites licencias
				Dim LeyendaTermL
				Dim tipoTramite
				LeyendaTermL = "N-ON [QUETZALES] " + R1 + " " + ref3
				arrDescripTemp = split(strDescrip,"|") 
				If arrDescripTemp(0) = "RENV" Then
					tipoTramite = "RENOVACION"
				elseif arrDescripTemp(0) = "REPN" Then
					tipoTramite = "REPOSICION NORMAL"
				elseif arrDescripTemp(0) = "REPT" Then
					tipoTramite = "REPOSICION POR TRANSFERENCIA"
				End if
				%>
				<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">TR&Aacute;MITE DE LICENCIAS <br><br></font></div>
							</td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionMaycom">FORMA 63-A NO. <%=ref2%>&nbsp;DV&nbsp;<%=R3%>&nbsp;<%=R4%></span>
							</td>																
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Tramite:</td>
							<td colspan="4"><span class="textoImpresionP"><%=tipoTramite%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Tipo de licencia:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Licencia:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(2) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Dpi:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Fecha de vencimiento:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Nombres y apellidos:</td>
							<td colspan="4"><span class="textoImpresionP"><%=R2%></span></td>
						</tr>
						<% if arrDescripTemp(6) <> "0" then%>

							<tr>
								<td width=135><p align="right" class="textoImpresionP">A&ntilde;os a pagar:</td>
								<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(6)%> A&Ntilde;OS</span></td>
							</tr>
						<%end if%>

						<tr>
								<td width=135><p align="right" class="textoImpresionP">Monto a pagar:</td>
								<td colspan="4"><span class="textoImpresionP">Q<%= FormatNumber(strMonto,2)%></span></td>
							</tr>
						<tr>
						
							<td width=135><p align="right" class="textoImpresionP">Referencia:</td>
							<td colspan="4"><span class="textoImpresionP"><%=ref3%></span></td>
						</tr>
						<tr>
						
							<td width=135><p align="right" class="textoImpresionP">Boleta:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
			
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
			

								</span>
							</td>																
						</tr>
						<tr>
							<br>
							<td align= center colspan="5">
								<span class="textoImpresionP">VALIDE LOS DATOS DE SU TRANSACCI&Oacute;N</span>
							</td>					
						</tr>
						
						<tr>
							<td align= center colspan="5">
								<span class="textoG">
								<br>
								ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
								<br>
								<br>
								</span>
							</td>																
						</tr>
						
						<tr align= center colspan="4">
							<td colspan="2" align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>											
							<td colspan="2" align="right"><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio:<%=Session("VG_Municipio")%></span></td>						
						</tr>  
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td align="center" colspan="2">     
								<br>                   
								<span class="textoImpresionP"> <%= server.htmlEncode(reso1)%> <%= server.htmlEncode(reso2)%> <%= server.htmlEncode(reso3)%> <%= server.htmlEncode(reso4)%> <%= server.htmlEncode(reso5)%> <%= server.htmlEncode(reso6)%>
								</span>
								<br>                   
								<span class="textoImpresionP"> BANCO DE DESARROLLO RURAL S.A. - COBRO DEPTO. TRANSITO - LICENCIAS - 339
								</span>
								<br>
								<span class="textoImpresionP">  <%= LeyendaTermL %>
								</span>
								<br>                   
								<span class="textoImpresionP"> ESTE DOCUMENTO TIENE VIGENCIA DE 30 D&Iacute;AS
								</span>
							</td>						
						</tr>
				</table>
				<%case 18163 'Pago Multas Tramites Licencias 
				Dim LeyendaTerm
				LeyendaTerm = "N-ON [QUETZALES] " + R1 + " " + R3
				arrDescripTemp = split(strDescrip,"|") %>
				<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">MULTAS DE TR&Aacute;MITE DE LICENCIAS <br><br></font></div>
							</td>
						</tr>
						<tr>
							
							<td align= center colspan="5">
								<span class="textoImpresionP">FORMA 63-A NO. <%=arrDescripTemp(5)%>&nbsp;DV&nbsp;<%=arrDescripTemp(6)%>&nbsp;<%=ref2%></span>
						
							</td>																
						</tr>	
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Tipo de licencia:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Licencia:</td>
							<td colspan="4"><span class="textoImpresionP"><%= arrDescripTemp(1) %></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Dpi:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Fecha de vencimiento:</td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(4)%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Nombres y apellidos:</td>
							<td colspan="4"><span class="textoImpresionP"><%=R2%></span></td>
						</tr>
						
							<tr>
								<td width=135><p align="right" class="textoImpresionP">Monto a pagar:</td>
								<td colspan="4"><span class="textoImpresionP">Q<%= FormatNumber(strMonto,2)%></span></td>
							</tr>
				
						<tr>
						
							<td width=135><p align="right" class="textoImpresionP">Secuencial:</td>
							<td colspan="4"><span class="textoImpresionP"><%=R3%></span></td>
						</tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Boleta:</td>
							<td colspan="4"><span class="textoImpresionP"><%=strSecuencial%></span></td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						
						
						<tr>
							<td align= center colspan="5">
								<span class="textoG">
								<br>
								ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td colspan="2" align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>											
							<td colspan="2" align="right"><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio:<%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td align="center" colspan="2">     
								<br>                   
								<span class="textoImpresionP"> <%=server.htmlEncode(reso1)%> <%=server.htmlEncode(reso2)%> <%=server.htmlEncode(reso3)%> <%=server.htmlEncode(reso4)%> <%=server.htmlEncode(reso5)%> <%=server.htmlEncode(reso6)%>
								</span>
								<br>                   
								<span class="textoImpresionP"> BANCO DE DESARROLLO RURAL S.A. - COBRO DEPTO. TRANSITO - MULTAS - 348 
								</span>
								<br>                   
								<span class="textoImpresionP">  <%= LeyendaTerm %>
								</span>
								<br>                   
								<span class="textoImpresionP"> ESTE DOCUMENTO TIENE VIGENCIA DE 30 D&Iacute;AS
								</span>
							</td>						
						</tr>
				</table>
				<%case 18165 'Pago Centros Educativos 
				
				arrDescripTemp = split(strDescrip,"|") %>
						<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">COBROS CENTROS EDUCATIVOS <br><br></font></div>
							</td>
						</tr>
						<tr >
							<td colspan="3">
								<p align="center" class="textoImpresionP" >BANCO DE DESARROLLO RURAL S.A. - CENTROS EDUCATIVOS CXCA - 249 Boleta: <%=arrDescripTemp(0)%>      
										N-ON [QUETZALES] 996 <%=strFechaR%> <%=esp%> <%=strHoraR%> <%=esp%>  2447866<br><br></p>
							</td>
        
							</span>
						</tr> 
						<tr>
							<td ><p align="left" class="textoImpresionP" >Centro Educativo:</td>
							<td  ><span align="left" class="textoImpresionP"><%=R1%> </span></td>
					
							<td ><p align="left" class="textoImpresionP" >Trans: <%=arrDescripTemp(2)%></p></td>
						</tr>
						
						<tr> 
							<td ><p align="left" class="textoImpresionP">
								Divisi&oacute;n:
							</td>
							<td >
								<span align="left" class="textoImpresionP">
									<%=R2%>
								</span>
							</td>
						</tr>
					
                    	<tr> 
							<td ><p align="left" class="textoImpresionP">
								C&oacute;digo:
							</td>
							<td >
								<span align="left" class="textoImpresionP">
									<%=ref1%>
								</span>
							</td>
						</tr>
                    	<tr> 
							<td ><p align="left" class="textoImpresionP">
								Nombre del cliente:
							</td>
							<td >
								<span align="left" class="textoImpresionP">
									<%=R3%>
								</span>
							</td>
						</tr>
                    	<tr> 
							<td ><p align="left" class="textoImpresionP">
								Total:
							</td>
							<td >
								<span align="left" class="textoImpresionP">
									<%=FormatNumber(strMonto,2)%>
								</span>
							</td>
						</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						
						
						<tr>
							<td align= center colspan="5">
								<span class="textoG">
								<br>
								ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td colspan="2" align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>											
							<td colspan="2" align="right"><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio:<%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>
						</tr>
				</table>
                <%case 18166 'Pago Multas PNC

                    arrDescripTemp = split(strDescrip,"|")
				    LeyendaTerm = "N-ON [QUETZALES] " + R1 + " " + arrDescripTemp(6)
				%>
				<tr>
							<td align= center colspan="5">
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">MULTAS PNC DEPTO. TRANSITO <br><br></font></div>
							</td>
						</tr>
						<tr>
						    <td align="center" colspan="4" >          
							    <span class="textoImpresionP">FORMA 63-A NO.<%=arrDescripTemp(2)%>&nbsp;<%=arrDescripTemp(3)%>&nbsp;DV&nbsp;<%=arrDescripTemp(5)%> &nbsp;Boleta:<%=strSecuencial%>&nbsp; <%=arrDescripTemp(4)%>
							    </span>
						    </td>						
					    </tr>	
						<tr>						
						    <td width=135><p align="right" class="textoImpresionP">Tramite:</td>
						    <td colspan="4"><span class="textoImpresionP">MULTAS PNC</span></td>
					    </tr>
						<tr>						
						    <td width=135><p align="right" class="textoImpresionP">Años pagados:</td>
						    <td colspan="4"><span class="textoImpresionP">N/A</span></td>
					    </tr>
						<tr>						
						    <td width=135><p align="right" class="textoImpresionP">Identificacion:</td>
						    <td colspan="4"><span class="textoImpresionP"> 
							    <%=ref2%>		
						        </span>
                            </td>
					    </tr>
						<tr>						
						    <td width=135><p align="right" class="textoImpresionP">Nombre:</td>
						    <td colspan="4"><span class="textoImpresionP"> 
                                <%=R2%>
						        </span></td>
					    </tr>
                        <tr>						
						    <td width=135><p align="right" class="textoImpresionP">NIT:</td>
						    <td colspan="4"><span class="textoImpresionP"> 
                            <%=R3%>
						    </span></td>
					    </tr>
						<tr>						
						    <td width=135><p align="right" class="textoImpresionP">No. Remisi&oacute;n:</td>
						    <td colspan="4"><span class="textoImpresionP"> 
                                <%=arrDescripTemp(1)%><%=arrDescripTemp(0)%>
						    </span></td>
					    </tr>
						<tr>
							<td width=135><p align="right" class="textoImpresionP">Monto a pagar:</td>
							<td colspan="4"><span class="textoImpresionP">Q<%= FormatNumber(strMonto,2)%></span></td>
						</tr>
				
						<tr>						
						    <td width=135><p align="right" class="textoImpresionP">Fecha de Imp:</td>
						    <td colspan="4"><span class="textoImpresionP"> 
                                <%=ref3%>
						    </span></td>
					    </tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								</span>
							</td>																
						</tr>
						
						
						<tr>
							<td align= center colspan="5">
								<span class="textoG">
								<br>
								ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<tr align= center colspan="4">
							<td colspan="2" align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>											
							<td colspan="2" align="right"><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio:<%=Session("VG_Municipio")%></span></td>						
						</tr>
				</table>
				<table>		
						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td align="center" colspan="2">     
								<br>                   
								<span class="textoImpresionP"> <%=reso1%> <%=reso2%> <%=reso3%> <%=reso4%> <%=reso5%> <%=reso6%>
								</span>
								<br>                   
								<span class="textoImpresionP">  BANCO DE DESARROLLO RURAL S.A. - MULTAS PNC DEPTO. TRANSITO 184 
								</span>
								<br>                   
								<span class="textoImpresionP">  <%= LeyendaTerm %>
								</span>
								
							</td>						
						</tr>
				</table>							
				<% case 19305, 19306 'VIVO SEGURA
					arrDescripTemp = split(strDescrip,"|")
				%>
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REIMPRESION DE P&Oacute;LIZA DE VIVO SEGURA<br><br></font></div>
							
						</td>
					</tr>
					<tr>
					<td align="center" colspan="5"><span class="textoImpresionP">DATOS DE LA POLIZA </span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >NUMERO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strCuenta%><br></span></td>
				
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >FORMA DE PAGO:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >PLAN CONTRATADO:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%><br></span></td>
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >FECHA DE EMISION:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strFecha%><br></span></td>
					</tr>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP">DATOS DEL CLIENTE </span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >NOMBRE:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%><br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >CUENTA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%><br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >FECHA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strFecha%>&nbsp;<br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >TOTAL A PAGAR:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%><br></span></td>
					</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
				</table>
				<table>
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agante bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table>
				<% case 19307, 19308, 19309, 19310 'VIVO SALUDABLE
					arrDescripTemp = split(strDescrip,"|")
				%>
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REIMPRESION DE P&Oacute;LIZA DE VIVO SALUDABLE<br><br></font></div>
							
						</td>
					</tr>
					<tr>
					<td align="center" colspan="5"><span class="textoImpresionP">DATOS DE LA POLIZA </span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >NUMERO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strCuenta%><br></span></td>
				
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >FORMA DE PAGO:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >PLAN CONTRATADO:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%><br></span></td>
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >FECHA DE EMISION:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strFecha%><br></span></td>
					</tr>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP">DATOS DEL CLIENTE </span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >NOMBRE:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%><br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >CUENTA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%><br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >FECHA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strFecha%>&nbsp;<br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >TOTAL A PAGAR:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%><br></span></td>
					</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
				</table>
				<table>
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agante bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table>
<% case 19311, 19312, 19313, 19314 'VIVO INTEGRAL
					arrDescripTemp = split(strDescrip,"|")
				%>
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REIMPRESION DE P&Oacute;LIZA DE VIVO INTEGRAL<br><br></font></div>
							
						</td>
					</tr>
					<tr>
					<td align="center" colspan="5"><span class="textoImpresionP">DATOS DE LA POLIZA </span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >NUMERO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strCuenta%><br></span></td>
				
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >FORMA DE PAGO:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >PLAN CONTRATADO:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%><br></span></td>
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >FECHA DE EMISION:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strFecha%><br></span></td>
					</tr>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP">DATOS DEL CLIENTE </span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >NOMBRE:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%><br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >CUENTA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%><br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >FECHA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strFecha%>&nbsp;<br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >TOTAL A PAGAR:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%><br></span></td>
					</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
				</table>
				<table>
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agante bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table>
				<% case 19315, 19316, 19317, 19318 'ACCIDENTES PERSONALES
					arrDescripTemp = split(strDescrip,"|")
				%>
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REIMPRESION DE P&Oacute;LIZA DE ACCIDENTES PERSONALES<br><br></font></div>
							
						</td>
					</tr>
					<tr>
					<td align="center" colspan="5"><span class="textoImpresionP">DATOS DE LA POLIZA </span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >NUMERO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strCuenta%><br></span></td>
				
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >FORMA DE PAGO:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >PLAN CONTRATADO:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%><br></span></td>
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >FECHA DE EMISION:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strFecha%><br></span></td>
					</tr>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP">DATOS DEL CLIENTE </span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >NOMBRE:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%><br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >CUENTA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(3)%><br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >FECHA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strFecha%>&nbsp;<br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >TOTAL A PAGAR:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%><br></span></td>
					</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
				</table>
				<table>
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agante bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table>
<% case 19319 'PAGOS PENDIENTES
					arrDescripTemp = split(strDescrip,"|")
				%>
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REIMPRESION DE P&Oacute;LIZA DE PAGOS PENDIENTES<br><br></font></div>
							
						</td>
					</tr>
					<tr>
					<td align="center" colspan="5"><span class="textoImpresionP">DATOS DE LA POLIZA </span></td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >NUMERO:</td>
						<td colspan="4"><span class="textoImpresionP"><%=strCuenta%><br></span></td>
				
					</tr>					
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >FECHA DE EMISION:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strFecha%><br></span></td>
					</tr>
					<tr>
						<td align="center" colspan="5"><span class="textoImpresionP">DATOS DEL CLIENTE </span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >NOMBRE:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(1)%><br></span></td>
					</tr>
					<%										
					If Trim(arrDescripTemp(4)) <> "C" Then
					%>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >CUENTA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%><br></span></td>
					</tr>
					<%										
					End if
					%>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >FECHA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%=strFecha & " " & strHora%>&nbsp;<br></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >TOTAL A PAGAR:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%= "Q" & FormatNumber(strMonto)%><br></span></td>
					</tr>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
				</table>
				<table>
					<tr>
					<br>
					
						<td align= center colspan="4">
							<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agante bancario <%=Session("VG_Nombre")%>
							</span>
						</td>					
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table>
			<% end select %>
		</td>
	</tr>
	</table>
	<%
End Sub 'termina Impresion Boletas Termicas

Sub PLRecibo(id)
	 if cod_trans <> 18158 then
	%>		
        <br>
    <%
    End If
    %>																					   
	<table id="<%=id%>" width="600" border="1" cellspacing="0" cellpadding="0" align="center">
	<%
	Select Case (cod_trans)
			case 18201
			
			If Mid(strCuenta,1,1) = "3" or Mid(strCuenta,1,2) = "03" Then strTipoCuenta = "MONETARIO"
			If Mid(strCuenta,1,1) = "4" or Mid(strCuenta,1,2) = "04" Then strTipoCuenta = " AHORRO"     %>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">DEPOSITO <%=strTipoCuenta%> </font></div>
			</td>
		</tr>
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="2" align="center">
					<tr>
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;</td>
					</tr>	
					<tr> 
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE CUENTA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strCuenta%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr> 
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">POR UN VALOR DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">Q. <%=strMonto%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr> 
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">NOMBRE DE CUENTA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strDescrip%></span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>					
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">NUMERO DE DEP&Oacute;SITO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FECHA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%= strFecha %></span></td>
						<td>&nbsp;</td>
					</tr>	
					<tr>
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;</td>
					</tr>	
				</table>
			<% 	case 18107, 18103, 18105, 18108, 18109, 18106 %>
				<%
				
				arrDescripTemp = split(strDescrip,"|")

				select case (cod_trans)
					case 18107
						strServicio = "PAGO LINEA FIJA (CLARO)"
					case 18103
						strServicio ="TIGO - POST PAGO"
					case 18105
						strServicio ="PAGO TELEFONICA POSTPAGO"
					case 18108
						strServicio ="PAGO CLARO POSTPAGO"
					case 18109
						strServicio ="PAGO CLARO PREPAGO"
					case 18106
						strServicio ="PAGO TELEFONICA PREPAGO"
				end select
				%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIOS</font></div>
			</td>
		</tr>
		<tr>
			<td>
				<table width="600" border="0" CELLSPACING="0" CELLPADDING="2" align="center">
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">PAGO DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">T&Eacute;LEFONO <%=strCuenta%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">POR UN VALOR DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">Q. <%=strMonto%></span></td>
						<td>&nbsp;</td>
					</tr>
					<%if ((cod_trans <> 18103)and(cod_trans <> 18106)and(cod_trans <> 18109)) then %>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FACTURA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strDescrip%></span></td>
						<td>&nbsp;</td>
					</tr>
					<%end if%>
					<%if (cod_trans=18103) then%>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE AUTORIZACI&Oacute;N:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<%end if%>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">POR CONCEPTO DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strServicio%> </span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">N&Uacute;MERO DE BOLETA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FECHA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%= strFecha %></span></td>
						<td>&nbsp;</td>
					</tr>	
					<tr>
						<td align= center colspan="5">
							<span class="textoImpresionP">
							<br>
							<br>
						    F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
			</table>		
		<% 	case 18103
				strServicio ="TIGO - POST PAGO"
				arrDescripTemp = split(strDescrip,"|")
		%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIOS</font></div>
			</td>
		</tr>
		<tr>
			<td>
				<table width="600" border="0" CELLSPACING="0" CELLPADDING="2" align="center">
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">PAGO DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">TEL&Eacute;FONO <%=strCuenta%></span></td>
						<td>&nbsp;</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">A NOMBRE DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(1)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">POR UN VALOR DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">Q. <%=FormatNumber(strMonto)%></span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE AUTORIZACI&Oacute;N:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FECHA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%= strFecha %></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">POR CONCEPTO DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strServicio%> </span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">N&Uacute;MERO DE BOLETA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align= center colspan="5">
							<span class="textoImpresionP">
							<br>
							<br>
						    F: ___________________________________________<br>
							(Recib&iacute; Conforme)
							<br>
							<br>
							</span>
						</td>																
					</tr>
			</td>
		</tr>
</table>
	<% case 19303
					arrDescripTemp = split(strDescrip,"|")
				%>

				
					<tr>
						<td>
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">COMPRA DE POLIZA DE SEGURO MIGRANTE</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600" bgcolor="#FFFFFF" >
						<br>
							<table border="0" CELLSPACING="0" CELLPADDING="1" align="center" width="100%">
								<tr> 
									<td align="center" class="TextoG" colspan="5">DATOS DE LA POLIZA</td>
								</tr>
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Numero:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strCuenta%></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG" >Forma de pago:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(0)%></td>
									<td class="textoG" width="10%">&nbsp;</td>
								</tr>
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG" >Plan contratado:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(1)%></td>
									<td class="textoG" width="10%">&nbsp;</td>
								</tr>
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG" >Fecha de emision:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></td>
									<td class="textoG" width="10%">&nbsp;</td>
								</tr>
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG">&nbsp;</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG">&nbsp;</td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>					
								<tr> 
									<td align="center" class="TextoG" colspan="5">DATOS DEL CLIENTE</td>
								</tr>
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG" >Nombre:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(2)%></td>
									<td class="textoG" width="10%">&nbsp;</td>
								</tr>
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG" >Cuenta:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%= arrDescripTemp(3)%></td>
									<td class="textoG" width="10%">&nbsp;</td>
								</tr>							
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG">&nbsp;</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG">&nbsp;</td>
									<td class="textoG" width="10%">&nbsp;</td>
								</tr>										
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG" >Fecha:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></tr>												
									<td class="textoG" width="10%">&nbsp;</td>
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Total a Pagar:</b></td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG" >Q <%= formatNumber(strMonto)%></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td colspan="5" ><p align="center"><span class="textoG">F:______________________________</span></p></td>
								</tr>
								<tr>
									<td colspan="5" ><p align="center"><span class="textoG">(Recib&iacute; Conforme)</span></p></td>
								</tr>																
							</table>
						</td>
					</tr>

		<% case 18254
					arrDescripTemp = split(strDescrip,"|")
				%>
				
				<tr>
					<td width="600">
						<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">CONSTANCIA DE PAGO</font></div>
					</td>
				</tr>		
				<tr>
					<td width="600">
						<table border="0" CELLSPACING="0" CELLPADDING="2" align="center">
						<tr>
							<td>&nbsp;</td>
							</tr>
							<tr>
								<td class="textoG" width="10%">&nbsp;</td>
								<td align="center" colspan="3"><span class="textoG">Autorizo debito a la cuenta por haber recibido el monto certificado.<br> Firmo o coloco la huella en los espacios reservados.<br> 
								NOTA DE DEBITO POR PAGO JUBILADOS Y/O PENSIONADOS</span></td>
								<td class="textoG" width="10%">&nbsp;</td>
							</tr>					
							<tr> 
								<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								<td><p align="right"><span class="textoG">No. de cuenta:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"><%= strCuenta %><br></span></td>
								<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							</tr>
							<tr> 
								<td class="textoG" width="10%">&nbsp;</td>
								<td><p align="right"><span class="textoG">A nombre de:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"><%=strDescrip%><br></span>						</td>
								<td class="textoG" width="10%">&nbsp;</td>
							</tr>
							<tr>
								<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								<td><p align="right"><span class="textoG">Monto retirado:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
								<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							</tr>					
							<tr>
								<td class="textoG" width="10%">&nbsp;</td>
								<td><p align="right"><span class="textoG">Documento:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"><%=strSecuencial%></span></td>
								<td class="textoG" width="10%">&nbsp;</td>
							</tr>
							<tr>
								<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								<td><p align="right"><span class="textoG">Fechaaaa:</span></td>
								<td>&nbsp;</td>
								<%'cche Fecha en MM/DD/AAAA cuando viene como dia/mes/año 
									Dim fecha_actual_separada, fecha_mes, fecha_dia, fecha_anio, fecha_dia_string, fecha_mes_string, fecha_con_formato
									fecha_actual_separada = Split(strFecha,"/")
									
									fecha_dia = CInt(fecha_actual_separada(0))
									fecha_mes = CInt(fecha_actual_separada(1))
									
									fecha_anio = fecha_actual_separada(2)

									'corregir dia 
									if fecha_dia < 10 then
										fecha_dia_string = "0" & fecha_dia
									else
										fecha_dia_string = CStr(fecha_dia) 
									end if

									'corregir mes
									if fecha_mes < 10 then
										fecha_mes_string = "0" & fecha_mes
									else
										fecha_mes_string = CStr(fecha_mes)
									end if

									fecha_con_formato = fecha_mes_string + "/" + fecha_dia_string + "/" +  fecha_anio
								%>
								<td><span class="textoG"><%=fecha_con_formato%></span></td>
								<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							</tr>	
							<tr>
								<td class="textoG" width="10%">&nbsp;</td>					
								<td><p align="right"><span class="textoG">Numero de Identificacion:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG">f.____________________</span></td>
								<td class="textoG" width="10%">&nbsp;</td>						
							</tr>
							<tr>
								<td class="textoG" width="10%">&nbsp;</td>	
								<td align= center colspan="3"><span class="textoG">AVISO: Estimado pensionado, le recordamos que a partir del 1 de mayo de 2010, su acta de supervivencia debera presentarla el dia de su cumplea&ntilde;os o 30 dias calendario posteriores a este en: Centro de Atencion al Afiliado CATAFI, Trabajo Social, CAMIP PAMPLONA, CAMIP BARRANQUILLA y en Cajas y Delegaciones Departamentales, cualquier consulta al telefono 1-801-0014477 la llamada es gratis.</span></td>
								<td class="textoG" width="10%">&nbsp;</td>	
							</tr>
							<tr>
								<td align= center colspan="3"><span class="textoG"></span></td>
							</tr>					
																
							<tr>
								<td>&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
			
		
		<% case 18253
					Dim arrFecha, strYear
					arrFecha = split(strFechaR,"/")
					strYear = mid(arrFecha(2),3,4)
					arrDescripTemp = split(strDescrip,"|")
				%>
		
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">RETIRO ADULTO MAYOR</font></div>
			</td>
		</tr>		
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="2" align="center">
				<tr>
					<td>&nbsp;</td>
					</tr>
					<tr> 
						<td colspan="5 "width=ANCHO_COLUMNA><p align="center"><span class="textoG">Retiro Adulto Mayor - n  GTQ  <%=reso3%> </span></td>
						
					</tr>
					<tr>
						<td class="textoG" width="10%">&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">SECUENCIAL:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strYear%><%=arrFecha(1)%><%=arrFecha(0)%><%=strSecuencial%></span></td>
						<td class="textoG" width="10%">&nbsp;</td>
					</tr>
					<tr>
						<td class="textoG" width="10%">&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CODIGO BENEFICIARIO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strCuenta%></span></td>
						<td class="textoG" width="10%">&nbsp;</td>
					</tr>					
					<tr> 
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">RECIBE EL PAGO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(2)%> - <%=strNombreEmpresa%></span></td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					</tr>
					<tr> 
						<td class="textoG" width="10%">&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOMBRE BENEFICIARIO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
						<td class="textoG" width="10%">&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOMBRE APODERADO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=R1%></span></td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					</tr>					
					<tr>
						<td class="textoG" width="10%">&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">DPI:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(1)%></span></td>
						<td class="textoG" width="10%">&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">EXTENDIDO EN:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=Ref1%></span></td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					</tr>	
					<tr>
						<td class="textoG" width="10%">&nbsp;</td>					
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">REFERENCIA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=reso4%></span></td>
						<td class="textoG" width="10%">&nbsp;</td>						
					</tr>
					<tr>
						<td class="textoG" width="10%">&nbsp;</td>					
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">TOTAL PAGADO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%="Q " & FormatNumber(strMonto)%></span></td>
						<td class="textoG" width="10%">&nbsp;</td>						
					</tr>
					<tr>
						<td class="textoG" width="10%">&nbsp;</td>					
						<td colspan="3"width=ANCHO_COLUMNA><p align="center"><span class="textoG">DESGLOSE DE PAGO</span></td>
						<td>&nbsp;</td>				
					</tr>
					<%
					 if R2 <> "" or Ref3 = "" then 
					%>
					<tr>
						<td colspan="5" width=ANCHO_COLUMNA><p align="center"><span class="textoG"><%=R2%> : <%="Q " & FormatNumber(Ref3)%></span></td>
						
					</tr>
					<%
					 end if
					%>
					<%
					 if Ref2 <> "" or R4 = "" then 
					%>
					<tr>
						<td colspan="5" width=ANCHO_COLUMNA><p align="center"><span class="textoG"><%=Ref2%> : <%="Q " & FormatNumber(R4)%></span></td>
						
					</tr>
					<%
					 end if
					%>
					<%
					if R3 <> "" or Ref4 = "" then 
					%>
					<tr>
						<td colspan="5" width=ANCHO_COLUMNA><p align="center"><span class="textoG"><%=R3%> : <%="Q " & FormatNumber(Ref4)%></span></td>
						
					</tr>
					<%
					 end if
					%>
					<tr>
						
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="5" align="center"><span class="textoG">EVITE SUSPENSION DE APORTE, EN MIN.TRABAJO ACDO.GUB 99-2012</span></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="5" align="center"><span class="textoG">__________________________________</span></td>
					</tr>					
					<tr>
						<td colspan="5" align="center"><span class="textoG">Firma Beneficiario</span></td>
					</tr>									
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
	

		<% case 19302	
					arrDescripTemp = split(strDescrip,"|")
				%>

				
					<tr>
						<td>
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">COMPRA DE POLIZA DE SEGURO MIGRANTE</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600" bgcolor="#FFFFFF" >
						<br>
							<table border="0" CELLSPACING="0" CELLPADDING="1" align="center" width="100%">
								<tr> 
									<td align="center" class="TextoG" colspan="5">DATOS DE LA POLIZA</td>
								</tr>
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Numero:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strCuenta%></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG" >Forma de pago:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(0)%></td>
									<td class="textoG" width="10%">&nbsp;</td>
								</tr>
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG" >Plan contratado:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(1)%></td>
									<td class="textoG" width="10%">&nbsp;</td>
								</tr>
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG" >Fecha de emision:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></td>
									<td class="textoG" width="10%">&nbsp;</td>
								</tr>
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG">&nbsp;</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG">&nbsp;</td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>					
								<tr> 
									<td align="center" class="TextoG" colspan="5">DATOS DEL CLIENTE</td>
								</tr>
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG" >Nombre:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(2)%></td>
									<td class="textoG" width="10%">&nbsp;</td>
								</tr>
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG" >Cuenta:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%= arrDescripTemp(3)%></td>
									<td class="textoG" width="10%">&nbsp;</td>
								</tr>							
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG">&nbsp;</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG">&nbsp;</td>
									<td class="textoG" width="10%">&nbsp;</td>
								</tr>										
								<tr> 
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="right" class="TextoG" >Fecha:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></tr>												
									<td class="textoG" width="10%">&nbsp;</td>
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Total a Pagar:</b></td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG" >Q <%= formatNumber(strMonto)%></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td colspan="5" ><p align="center"><span class="textoG">F:______________________________</span></p></td>
								</tr>
								<tr>
									<td colspan="5" ><p align="center"><span class="textoG">(Recib&iacute; Conforme)</span></p></td>
								</tr>																
							</table>
						</td>
					</tr>
						
		<% case 18001 
			arrDescripTemp = Split(strDescrip, "|") 'obtiene los datos de remesador y beneficiario
		%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE REMESA</font></div>
			</td>
		</tr>
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="2" align="center" width="100%">
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>		
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">REMESADOR: </span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">REMITENTE:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"><%=strNombre%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">BENEFICIARIO:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(2)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td align="center" class="TextoG" colspan="3">DATOS DE LA REMESA</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. REMESA:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"> <%=strCuenta%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">PAIS ORIGEN:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG">ESTADOS UNIDOS DE AMERICA</span></td>
						<td>&nbsp;</td>
					</tr>
					<%
					if ubound(arrDescripTemp) >= 4 then
						if ubound(arrDescripTemp) = 5 then
							VLTipoCliente = arrDescripTemp(5)
						end if %>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">ESTADO:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(3)%> </span></td>
						<td>&nbsp;</td>
					</tr>
					
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">CIUDAD:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(4)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<%end if%>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">TOTAL A RECIBIR(EN QUETZALES):</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG">Q.<%=strMonto%></span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE BOLETA:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"> <%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FECHA:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"> <%= strFecha &" "& strHora %></span></td>
						<td>&nbsp;</td>
					</tr>	
					<tr>
						<td colspan="5" ><p align="center"><span class="textoG">F:______________________________</span></p></td>
					</tr>
					<tr>
						<td colspan="5" ><p align="center"><span class="textoG">(Recib&iacute; Conforme)</span></p></td>
					</tr>
			</table>
		<% case 18002 
			arrDescripTemp = Split(strDescrip, "|") 'obtiene los datos de remesador y beneficiario
		%>	
			<tr>
				<td>
					<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Reversi&oacute;n de Pago de Remesas</font></div>
				</td>
			</tr>		
			<tr>
				<td width="600" bgcolor="#FFFFFF" >
					<br>
					<table border="0" CELLSPACING="0" CELLPADDING="1" align="center" width="100%">
						<tr>
							<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
						</tr>	
						<tr> 
							<td>&nbsp;</td>
							<td align="right" class="textoG" width="45%">REMESADOR: </td>
							<td>&nbsp;</td>
							<td class="textoG" width="45%"><%=arrDescripTemp(0)%></td>
							<td>&nbsp;</td>
						</tr>
						<tr> 
							<td>&nbsp;</td>
							<td align="right" class="TextoG" >NUMERO DE REMESA:</td>
							<td>&nbsp;</td>
							<td align="left" class="TextoG"><%=strCuenta%></td>
							<td>&nbsp;</td>
						</tr>
						<tr> 
							<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							<td align="right" class="TextoG" >BENEFICIARIO:</td>
							<td>&nbsp;</td>
							<td align="left" class="TextoG"><%=arrDescripTemp(2)%></td>
							<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
						</tr>
						<tr> 
							<td>&nbsp;</td>
							<td align="right" class="TextoG" >TOTAL A REVERSAR (QUETZALES):</b></td>
							<td>&nbsp;</td>
							<td align="left" class="TextoG" ><%=FormatNumber(strMonto,2)%></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td ><p align="right"><span class="textoG">FECHA:</span></td>
							<td>&nbsp;</td>
							<td><span class="textoG"> <%= strFecha %></span></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
						</tr>	
				</table>
				
		<% case 18004 
			arrDescripTemp = Split(strDescrip, "|") 'obtiene los datos de remesador y beneficiario
		%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE REMESA MIXTA</font></div>
			</td>
		</tr>
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="2" align="center" width="100%">
				<tr>
					<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
				</tr>	
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">REMESADOR: </span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">REMITENTE SISTEMA:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"><%=strNombre%></span></td>
						<td>&nbsp;</td>
					</tr>					
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">BENEFICIARIO SISTEMA:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(2)%></span></td>
						<td>&nbsp;</td>
					</tr>									
						<tr> 
							<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							<td align="center" class="TextoG" colspan="3">DATOS DE LA REMESA</td>
							<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
						</tr>					
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. REMESA:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"> <%=strCuenta%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE BOLETA:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"> <%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FECHA:</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"> <%= strFecha &" "& strHora %></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr> 
							<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							<td align="center" class="TextoG" colspan="3">DESGLOSE DEL PAGO</td>
							<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
						</tr>
					
					<tr>
						<td align="left">&nbsp;</td>
						<td ><p align="right"><span class="textoG">EFECTIVO</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG">Q.<%=FormatNumber(arrDescripTemp(7), 2)%></span></td>
						<td align="right">&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;</td>
						<td ><p align="right"><span class="textoG">DEPOSITO</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG">Q.<%= FormatNumber(arrDescripTemp(8), 2)%></span></td>
						<td align="left">&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;</td>
						<td ><p align="right"><span class="textoG">Cuenta: </span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(9)%></span></td>
						<td align="left">&nbsp;</td>
					</tr>
					<tr class="spaceUnder">
						<td align="left">&nbsp;</td>
						<td ><p align="right"><span class="textoG">TOTAL A PAGAR(EN QUETZALES):</span></td>
						<td class="textoG" width="10%">&nbsp;</td>
						<td><span class="textoG">Q.<%=FormatNumber(strMonto, 2)%></span></td>
						<td align="right">&nbsp;</td>
					</tr>
					<tr>
						<td> &nbsp;</td>
						<td> &nbsp;</td>
						<td> &nbsp;</td>
						<td> &nbsp;</td>
						<td> &nbsp;</td>
					</tr>
					<tr>
						<td> &nbsp;</td>
						<td> &nbsp;</td>
						<td> &nbsp;</td>
						<td> &nbsp;</td>
						<td> &nbsp;</td>
					</tr>		
					<tr>
						<td></td>
						<td colspan="3"><p align="center"><span class="textoG">F:______________________________</span></p></td>
					</tr>
					<tr>
						<td></td>
						<td colspan="3"><p align="center"><span class="textoG">(Recib&iacute; Conforme)</span></p></td>
					</tr>
			</table>				
	<% case 18152 %>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Cobros Empresariales</font></div>
			</td>
		</tr>	
		<tr>			
			<td>
			<table border="0" CELLSPACING="0" CELLPADDING="3" align="center">
				<tr>
				</br>
					<span class="textoG">BANCO DE DESARROLLO RURAL S.A. - COBROS EMPRESARIALES CXCA - 249 Boleta: <%=strSecuencial%>      
										N-ON [QUETZALES] 996   <%=strUsuarioR%> <%=esp%> <%=strFechaR%> <%=esp%> <%=strHoraR%> <%=esp%>  <%=strSecuencial%>    
					</span>
				</tr>					
					<td width=150><p align="left">
						<span class="textoG">
							Institución:
						</span>
					</td>
					<td width=250 align="left">
						<span class="textoG">
							<%=strNombreEmpresa%> 
						</span>
					</td>
					<td align="right">
						<span class="textoG">Trans: <%=strTran%> </span>
					</td>
		</tr>
				<tr> 
					<td width=150><p align="left">
						<span class="textoG">
							<%=R1%>:
						</span>
					</td>
					<td width=250 align="left">
						<span class="textoG">
							<%=ref1%>
						</span>
					</td>
				</tr>
				<tr> 
					<td width=150><p align="left">
						<span class="textoG">
							<%=R2%>:
						</span>
					</td>
					
					<td width=150>
						<span class="textoG">
							<%=ref2%>
						</span>
					</td>
				</tr>
				<tr> 
					<td width=150><p align="left">
						<span class="textoG">
							<%=R3%>:
						</span>
					</td>
					
					<td width=150>
						<span class="textoG">
							<%=ref3%>
						</span>
					</td>
					
				</tr>
				<tr> 
					<td width=150><p align="left">
						<span class="textoG">
							<%=R4%>:
						</span>
					</td>
					
					<td width=150>
						<span class="textoG">
							<%=ref4%>
						</span>
					</td>
				</tr>
				<tr> 
					<td width=150><p align="left">
						<span class="textoG">
							<%=R5%>:
						</span>
					</td>
					
					<td width=150>
						<span class="textoG">
							<%=ref5%>
						</span>
					</td>
				</tr>															
				<tr>
					<td><p align="left"><span class="textoG">Total:</span></td>
					
					<td><span class="textoG">Q <%= FormatNumber(strTotal)%> </span></td>
					
				</tr>
				</br>
			</table>

		</br>

			<table align= center  >
				<tr>
					<td align= center ><span class="textoG">
					F: _________________________________<br>
					(Recibe Conforme)</span>
					</td>
				</tr>	
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					
				</tr>
				<tr>
					<td align= center colspan="3"><span class="textoG"><%=reso1 & reso2 & reso3 & reso4 & reso5 & reso6%></span></td>
				</tr>				
			</table>
		
		<% case 18112, 18113
			if (strNombre = 1) then strEmpresa= "DEORSA"
			if (strNombre = 2) then strEmpresa= "DEOCSA"
		%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIO</font></div>
			</td>
		</tr>
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">USTED HA REALIZADO UN PAGO DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">UNIÓN FENOSA </span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">N.I.S.:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=strCuenta%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">EMPRESA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strEmpresa%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">NOMBRE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strDescrip%></span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">POR UN VALOR DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">Q.<%=strMonto%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE BOLETA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FECHA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%= strFecha %></span></td>
						<td>&nbsp;</td>
					</tr>	
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
				</table>
		<% case 18110
		%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIO</font></div>
			</td>
		</tr>
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">USTED HA REALIZADO UN PAGO DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> EMPRESA ELECTRICA DE GUATEMALA S.A <br>CONTADOR: <%=strCuenta%> </span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">POR UN VALOR DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">Q.<%=strMonto%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">FACTURA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strDescrip%></span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE BOLETA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=nro_tran%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FECHA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%= strFecha %></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
				</table>
		<% case 18111
			If InStr(strDescrip, "|") > 0 Then
	            arrDescripTemp = Split(strDescrip, "|")
				 
            Else
				arrDescripTemp = Array(strDescrip,"","","")
            End If	   
		%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIO</font></div>
			</td>
		</tr>
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">USTED HA REALIZADO UN PAGO DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">EMPAGUA</span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FACTURA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">POR UN VALOR DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">Q. <%=strMonto%></span></td>
						<td>&nbsp;</td>
					</tr>
					<%If arrDescripTemp(2) <> "" Then%>
						<tr>
							<td>&nbsp;</td>
							<td ><p align="right"><span class="textoG">No. SERIE:</span></td>
							<td>&nbsp;</td>
							<td><span class="textoG"><%=arrDescripTemp(2)%></span></td>
							<td>&nbsp;</td>
						</tr>
					<%End If%> 
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">NOMBRE:</span></td>
						<td>&nbsp;</td>
						<%If arrDescripTemp(1) = "" Then%>
							<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
						<%Else%>
							<td><span class="textoG"><%=arrDescripTemp(1)%></span></td>
						<%End If%>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. CONTADOR:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strCuenta%></span></td>
						<td>&nbsp;</td>
					</tr>
					<%If arrDescripTemp(3) <> "" Then%>
						<tr>
							<td>&nbsp;</td>
							<td ><p align="right"><span class="textoG">MES DE SERVICIO:</span></td>
							<td>&nbsp;</td>
							<td><span class="textoG"><%=arrDescripTemp(3)%></span></td>
							<td>&nbsp;</td>
						</tr> 
					<%End If%>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE BOLETA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FECHA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%= strFecha& " "  & strHora %></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
				</table>
					
		<%case 18104 ' pago de tigo Prepago
				arrDescripTemp = split(strDescrip,"|")
			%>
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago de Servicios</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td>&nbsp;</td>							
									<td>&nbsp;</td>							
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>								
								<tr> 
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Ud ha realizado un pago de servicios:</span></td>
									<td><span class="textoG">TIGO - <%=arrDescripTemp(3)%><br></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Por un valor de:</span></td>									
									<td><span class="textoG"><%=arrDescripTemp(4)%></span></td>
									<td>&nbsp;</td>									
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Telefono:</span></td>									
									<td><span class="textoG"><%= strCuenta %></span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>					
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>									
									<td><span class="textoG"><%=strFecha%></span></td>
									<td>&nbsp;</td>
								</tr>					
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Referencia de pago:</span></td>									
									<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
									<td>&nbsp;</td>
								</tr>					
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. Boleta:</span></td>									
									<td><span class="textoG"><%=arrDescripTemp(1)%></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td>&nbsp;</td>							
									<td>&nbsp;</td>							
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>								
							</table>
						</td>
					</tr>
		
		<%case 18115 'Pago de Kingo
				arrDescripTemp = split(strDescrip,"|")
				%>
					
				<tr>
					<td width="600">
						<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago Servicios </font></div>
					</td>
				</tr>		
				<tr>
					<td width="600">
						<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
							<tr>
								<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">PAGO DE SERVICIO:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG">KINGO ENERGY<br></span></td>
								<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							</tr>				
							
							<tr> 
								
								<td>&nbsp;</td>
								<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">COD. CLIENTE::</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"><%=strCuenta%><br></span></td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								
								<td>&nbsp;</td>
								<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOMBRE CLIENTE:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"><%=arrDescripTemp(1)%><br></span></td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								
								<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">VALOR:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
								<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							</tr>
							<tr>
								
								<td>&nbsp;</td>
								<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NO. AUTORIZACION:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								
								<td>&nbsp;</td>
								<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">BOLETA:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"><%=strSecuencial%></span></td>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"><%=strFecha%></span></td>
								<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							</tr>						
							<tr>
								<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								<td align= center colspan="3">
									<span class="textoG">
									<br>
									<br>
								<br>F: _________________________________<br>
									(Recib&iacute; Conforme)
									</span>
								</td>											
								<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>					
							</tr>	
						</table>	
						<br>
						<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
								<tr>
									<td align="center" colspan="3">
										<span class="textoG">
											Cualquier reclamo debera dirigirlo a Kingo Energy, al siguiente telefono 1-801-42-54646	
										</span>
									</td>						
								</tr>
						</table>	

						<br>




					<%case 18119 'Pago de PMA
				arrDescripTemp = split(strDescrip,"|")
				%>
				
						<tr>
							<td width="600">
								<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000">PAGO DE SERVICIOS</font></div>
							</td>
						</tr>		
						<tr>
							<td width="600">
								<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
									<tr>
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">PAGO DE SERVICIO:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG">APORTE PROGRAMA MUNDIAL DE ALIMENTOS<br></span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>				
									
									<tr> 
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">TIPO DE BENEFICIARIO:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=arrDescripTemp(3)%><br></span></td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CODIGO BENEFICIARIO:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=arrDescripTemp(4)%><br></span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
									<tr>
									
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">IDENTIFICACION:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=arrDescripTemp(1)%><br></span></td>
										<td>&nbsp;</td>
									</tr>
									<tr>
									
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOMBRE BENEFICIARIO:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=arrDescripTemp(0)%><br></span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
									<tr>
										
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. Boleta:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=strSecuencial%></span></td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Total aporte:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Total a pagar:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
										<td>&nbsp;</td>
									</tr>															
									<tr>
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=strFecha%></span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>																
								</table>
							</td>
						</tr>		
						
				<% case 19102 ' Pago TRANSFERENCIAS LOCALES
						arrDescripTemp = split(strDescrip,"|")
					%>				
						<tr>
							<td width="600">
								<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000">PAGO DE TRANSFERENCIA</font></div>
							</td>
						</tr>		
						<tr>
							<td width="600">
								<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
									
									<tr> 
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Nombre del beneficiario:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=arrDescripTemp(0)%><br></span></td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">DPI Beneficiario:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=arrDescripTemp(1)%><br></span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
									<tr>
									
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Nombre del Remitente:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=arrDescripTemp(2)%><br></span></td>
										<td>&nbsp;</td>
									</tr>
									<tr>
									
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Dpi Remitente:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=arrDescripTemp(3)%><br></span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
									<tr>
										
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">C&oacute;digo de transferencia :</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=arrDescripTemp(4)%></span></td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. Boleta:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=strSecuencial%></span></td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Monto:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
																							
									<tr>
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%= strFecha& " "  & strHora%></span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>	
									
									<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td align= center colspan="3">
												<span class="textoG">
												<br>
												<br>
											<br>F: _________________________________<br>
												(Recib&iacute; Conforme)
												</span>
											</td>											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>					
									</tr>	
								</table>
							</td>
						</tr>		
					
		
				</table>		
	<% case 19103 ' ENVIO DE TRANSFERENCIA LOCAL
						arrDescripTemp = split(strDescrip,"|")
					%>				
						<tr>
							<td width="630">
								<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000">ENV&Iacute;O DE TRANSFERENCIA LOCAL</font></div>
							</td>
						</tr>		
						<tr>
							<td width="630">
							<table border="0" CELLSPACING="0" CELLPADDING="2" align="center">	
								<tr> 
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">REMITENTE:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(0)%><br></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr> 
									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">IDENTIFICACI&Oacute;N::</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG">DPI <%=arrDescripTemp(1)%><br></span></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>								
								<tr> 
									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">BENEFICIARIO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%=arrDescripTemp(2)%></span>   <span class="textoG"><%=arrDescripTemp(3)%></span>   <span class="textoG"><%=arrDescripTemp(4)%></span></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>				
								
								<tr> 
									
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">PARENTESCO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(5)%><br></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">C&Oacute;DIGO DE TRANSFERENCIA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(9)%><br></span></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									
								</tr>
								
								<tr>						
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">VALOR DE TRANSFERENCIA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%= "Q" & FormatNumber(arrDescripTemp(6))%>&nbsp;<br></span></td>
									<td>&nbsp;</td>
								</tr>	
								<tr>
									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">COMISION:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%= "Q" & FormatNumber(arrDescripTemp(7))%><br></span></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									
								</tr>	
								
							<tr>

									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">TOTAL A PAGAR:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									
								</tr>
								<tr>
									
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NO BOLETA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strSecuencial%></span></td>
									<td>&nbsp;</td>
								</tr>
								
								<tr>

									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%= strFecha& " "  & strHora%></span></td>
									<td>&nbsp;</td>
								</tr>						
								<tr>
									<td align= center colspan="5">
										<span class="textoG">
										
										<br>
									<br>F: _________________________________<br>
										(Recib&iacute; Conforme)
										</span>
									</td>																
								</tr>
											
							</table>

							</td>
						</tr>		
					
				</table>
														   
											
		
		  
						
																																			 
			 
			  
		   
						
   
			
																		  
			  
																				
																							   
						  
																		  
																				 
				   
		  
			   
		   
						  
																									
						  
																		  
						  
			   
			  
						  
																								  
						  
																																  
						  
			   
			  
		   
						  
																											 
						  
																		  
						  
			   
			  
		   
																				
																								   
						  
																						
																				 
			   
			  
		   
						  
																								
						  
																  
						  
			   
		  
			  
						  
																						   
						  
																			  
						  
					 
			  
																				
										 
								 
				

													   
									
				   
				
																					  
						 
					
			 
			
			 
	<% case 18154 ' Pago MUNDIAL MILLON
						Dim acuerdoGub1
						Dim acuerdoGub2
						Dim arrAcuerdos

						arrDescripTemp = split(strDescrip,"|")
						arrAcuerdos = split(arrDescripTemp(8), ",")
						acuerdoGub1 = arrAcuerdos(0)
						acuerdoGub2 = arrAcuerdos(1)
					%>				
						<tr>
							<td width="600">
								<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000">PAGO DE SERVICIOS</font></div>
							</td>
						</tr>		
						<tr>
							<td width="600">
							<table width="600">
								<tr>
									<td align= center colspan="5">
										<span class="textoG">EXPEDIENTE <%=acuerdoGub1%> BAJO LA RESOLUCI&Oacute;N <%=acuerdoGub2%> EMITIDA POR GOBERNACI&Oacute;N DEPARTAMENTAL DE GUATEMALA. 
										</span>
									</td>						
								</tr>				
							</table>
							<table border="0" CELLSPACING="0" CELLPADDING="2" align="center">	
								<tr> 
									
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">PAGO DE SERVICIO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG">MUNDIAL DEL MILLON BANRURAL <br></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr> 
									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOMBRE:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(0)%><br></span></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>								
								<tr> 
									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">IDENTIFICACI&Oacute;N:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG">DPI <%=arrDescripTemp(1)%><br></span></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>				
								
								<tr> 
									
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">TELEFONO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(2)%><br></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">VATICINIO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(3)%><br></span></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									
								</tr>
								<% IF arrDescripTemp(5) = "2" THEN  %>
								<tr>						
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NO TARJETA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=mid(arrDescripTemp(6), 1, 4)& " XXXX XXXX " & mid(arrDescripTemp(6), 13,16)%><br></span></td>
									<td>&nbsp;</td>
								</tr>	
								<tr>
									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NO AUTORIZACI&Oacute;N:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(7)%><br></span></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									
								</tr>	
								<% END IF  %>
								<tr>
									
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NO BOLETA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strSecuencial%></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									
								</tr>
								<tr>
									
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%= strFecha& " "  & strHora%></span></td>
									<td>&nbsp;</td>
								</tr>						
								<tr>
									<td align= center colspan="5">
										<span class="textoG">
										<br>
										<br>
									<br>F: _________________________________<br>
										(Recib&iacute; Conforme)
										</span>
									</td>																
								</tr>
											
							</table>

							</td>
						</tr>		
					
		
				</table>	

					<% case 19401 ' >COMPRA CON TARJETA DE CREDITO 
						arrDescripTemp = split(strDescrip,"|")
					%>	
					<tr>
								<td width="600">
									<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">COMPRA CON TARJETA DE CR&Eacute;DITO </font></div>
								</td>
							</tr>		
							<tr>
								<td width="600">
									<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">	
										<tr> 
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">SERVICIO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"> <%=arrDescripTemp(2)%><br></span></td>
											<td>&nbsp;</td>
										</tr>					
										<tr> 
											
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No TARJETA:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=mid(arrDescripTemp(3), 1, 4)& " XXXX XXXX " & mid(arrDescripTemp(3), 13,16)%><br></span></td>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>				
										<tr> 
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOMBRE:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(0)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr> 
											
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%><br></span></td>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
												
										</tr>
										<tr>
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">AUTORIZACI&Oacute;N:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(4)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
									
										<tr>
											
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>											
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NO BOLETA:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=strSecuencial%></span></td>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
								
										<tr>
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><% = strFecha& " "  & strHora%></span></td>
											<td>&nbsp;</td>
										</tr>						
										<tr>
											<td align= center colspan="5">
												<span class="textoG">
												<br>
												<br>
											<br>F: _________________________________<br>
												(Recibí Conforme)
												</span>
											</td>																
										</tr>
									
								</table>				
		<%case 18102 'Pago de Renap

				arrDescripTemp = split(strDescrip,"|")
				
				Call PagoRenap()
				%>
							<tr>
								<td width="600">
									<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago Servicios </font></div>
								</td>
							</tr>		
							<tr>
								<td width="600">
									<table width="600">
										<tr>
											<td align= center colspan="5">
												<span class="textoG"><%=strLinea1%>
												</span>
											</td>						
										</tr>
										<tr>
											<td align= center colspan="5">
												<span class="textoG"><%=strLinea2%>
												</span>
											</td>						
										</tr>
										<tr>
											<td align= center colspan="5">
												<span class="textoG"><%=strLinea3%>
												</span>
											</td>					
										</tr>				
								</table>
								<br>
									<table border="0" CELLSPACING="0" CELLPADDING="0" align="center">
										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">PAGO DE SERVICIO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG">RENAP<br></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>				
										
										<tr> 
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">REFERENCIA NO.:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(7)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">TRAMITE:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(2)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NO. COPIAS:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(3)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
										<tr>
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOTA DE PAGO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(4)%></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CORRELATIVO CGC NO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(5)%></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=strFecha%></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>						
										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td align= center colspan="3">
												<span class="textoG">
												<br>
												<br>
											<br>F: _________________________________<br>
												(Recib&iacute; Conforme)
												</span>
											</td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>					
										</tr>										
								</table>				
								</td>
							</tr>
						</table>
				<%case 18116 ' Pago de Genesis
				arrDescripTemp = split(strDescrip,"|")

				%>
					
						<tr>
							<td width="600">
								<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000">PAGO DE SERVICIOS</font></div>
							</td>
						</tr>		
						<tr>
							<td width="600">
								<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
									<tr>
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
									<tr> 

										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">PAGO DE:</span></td>
										<td>&nbsp;</td>
										<td>
											<span class="textoG">FUNDACION GENESIS EMPRESARIAL</span>						
										</td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CREDITO:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=strCuenta%></span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOMBRE:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=arrDescripTemp(1)%></span></td>
										<td>&nbsp;</td>
									</tr>		
									<tr>
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">POR UN VALOR DE:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG">Q. <%=FormatNumber(strMonto)%>&nbsp; </span></td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">AUTORIZACI&Oacute;N:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>									
									<tr>
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">N&Uacute;MERO DE BOLETA:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%=arrDescripTemp(4)%></span></td>
										<td>&nbsp;</td>									
									</tr>
									<tr>
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>																		
								</table>
							</td>
						</tr>		
				
	
		
		<% case 18251
			arrDescripTemp = Split(strDescrip, "|") 'obtiene los datos del retiro de TD nombre de la tarjeta|numero de la tarjeta|noombre de la cuenta
		%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Retiro con Tarjeta de Débito</font></div>
			</td>
		</tr>
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE TARJETA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=Mid(arrDescripTemp(1),1,6)&"XXXXXX"&Mid(arrDescripTemp(1),13,16)%> </span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">A NOMBRE DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE CUENTA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strCuenta%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">POR UN VALOR DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> Q.<%=strMonto%></span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">NOMBRE DE LA CUENTA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(2)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE BOLETA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FECHA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%= strFecha %></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
				</table>
		<% case 18258
			arrDescripTemp = Split(strDescrip, "|") 'obtiene los datos del retiro en cuenta DPI nombre de la tarjeta|numero de la tarjeta|noombre de la cuenta
		%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">RETIRO EN CUENTA</font></div>
			</td>
		</tr>
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">DPI:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=ofuscaDPI(ref2)%> </span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE TARJETA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=ofuscaTarjeta(arrDescripTemp(1))%> </span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">A NOMBRE DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE CUENTA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=ofuscarCuenta(strCuenta)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">POR UN VALOR DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> Q.<%=strMonto%></span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">NOMBRE DE LA CUENTA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(2)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE BOLETA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FECHA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%= strFecha %></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
				</table>
				
				<%case 18801
			arrDescripTemp = Split(strDescrip, "|") 'obtener desglose de la descripcion
		%>
			<tr>
				<td width="600">
					<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago de Cheque Propio</font></div>
				</td>
			</tr>
			<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="0.7" align="center">
				<tr>
					<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. BOLETA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%> </span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. REF:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE CUENTA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strCuenta%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. CHEQUE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(1)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. INVENTARIO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(2)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">VALOR:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> Q.<%=FormatNumber(strMonto)%></span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">LLAVE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(3)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">DOCUMENTO DE IDENTIFICACI&Oacute;N:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(4)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">NOMBRE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(5)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
							<td>&nbsp;</td>
							<td ><p align="right"><span class="textoG">FECHA:</span></td>
							<td>&nbsp;</td>
							<td><span class="textoG"> <%= strFecha & " "& strHora %></span></td>
							<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td colspan="5" align="center" class="textoG">
							<br/>F. ______________________________________<br />
							(Recib&iacute; conforme)
						</td>
					</tr>
				</table>
				<br/>
			</tr>
			<%case 18802
			arrDescripTemp = Split(strDescrip, "|") 'obtener desglose de la descripcion
		%>
			<tr>
				<td width="600">
					<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago de Cheque Predeclarado</font></div>
				</td>
			</tr>
			<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="0.7" align="center">
				<tr>
					<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. BOLETA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%> </span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. REF:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE CUENTA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strCuenta%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. CHEQUE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(1)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. INVENTARIO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(2)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">VALOR:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> Q.<%=FormatNumber(strMonto)%></span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">LLAVE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(3)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">DOCUMENTO DE IDENTIFICACI&Oacute;N:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(4)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">NOMBRE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(5)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
							<td>&nbsp;</td>
							<td ><p align="right"><span class="textoG">FECHA:</span></td>
							<td>&nbsp;</td>
							<td><span class="textoG"> <%= strFecha & " "& strHora %></span></td>
							<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td colspan="5" align="center" class="textoG">
							<br/>F. ______________________________________<br />
							(Recib&iacute; conforme)
						</td>
					</tr>
				</table>
				<br/>
			</tr>
			<% 
		
		case 19101  
					arrDescripTemp = split(strDescrip,"|")
					'response.write strDescrip
						'if ubound(arrDescripTemp) >= 1 then
				
				%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago de Transferencia M&oacute;vil en Efectivo</font></div>
			</td>
		</tr>
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="left"><span class="textoG">REMITENTE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(4)%></span></td>
						<td>&nbsp;</td>
					</tr>					
					<tr>
						<td>&nbsp;</td>
						<td ><p align="left"><span class="textoG">BENEFICIARIO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(3)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="left"><span class="textoG">MONTO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">Q. <%=FormatNumber(strMonto,2)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="left"><span class="textoG">REFERENCIA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="left"><span class="textoG">FECHA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%= strFecha & " " & strHora%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="5" align="center" class="textoG"><br />
							F. ______________________________________<br />
								 (Recib&iacute; Conforme)
						</td>
					</tr>
					<tr>
																																			 
		  
		 
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
				</table>
			
			<%case 19002
				arrDescripTemp = split(strDescrip,"|")
				
		%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago Cr&eacute;ditos </font></div>
			</td>
		</tr>		
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
					<tr> 
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NO. DE CR&Eacute;DITO:</span></td>
						<td>&nbsp;</td>
						<td>
							<span class="textoG">
								<%=strCuenta%><br>
							</span>
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">TIPO DE CR&Eacute;DITO:</span></td>
						<td>&nbsp;</td>
						<td>
							<span class="textoG">
								<%=arrDescripTemp(1)%><br>
							</span>
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA>
							<p align="right"><span class="textoG">TITULAR DEL CREDITO:</span>
						</td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">VALOR PAGADO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%= "Q" & FormatNumber(strMonto,2)%>&nbsp;</span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. de Recibo:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%= strFecha & " " & strHora%> </span></td>
						<td>&nbsp;</td>
					</tr>					
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
			
			<% case 18114
			arrDescripTemp = Split(strDescrip, "|") 'obtiene los datos del retiro de TD nombre de la tarjeta|numero de la tarjeta|noombre de la cuenta
		%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">LECLEIRE</font></div>
			</td>
		</tr>
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
				<tr>
					<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
					<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">CODIGO CONSEJERO (A):</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strCuenta %> </span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">CODIGO ALTERNO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(1)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">POR UN VALOR DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">Q.<%=FormatNumber(strMonto)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">NOMBRE CONSEJERO(A):</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=arrDescripTemp(0)%></span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">NUMERO DE FACTURA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(2)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">No. DE REFERENCIA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
							<td>&nbsp;</td>
							<td ><p align="right"><span class="textoG">FECHA:</span></td>
							<td>&nbsp;</td>
							<td><span class="textoG"> <%= strFecha & " "&strHora %></span></td>
							<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
				</table>
				
				<% case 18901  
					arrDescripTemp = split(strDescrip,"|")
					'response.write strDescrip
						if ubound(arrDescripTemp) >= 1 then
				
				%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">RETIRO MI BONO SEGURO</font></div>
			</td>
		</tr>
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">CODIGO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%> -  <%=arrDescripTemp(1)%></span></td>
						<td>&nbsp;</td>
					</tr>					
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">IDENTIFICACION:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(2)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">CUENTA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strCuenta%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">COMUNIDAD:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(3)%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td ><p align="right"><span class="textoG">LOCALIDAD:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(4)%> - <%=arrDescripTemp(5)%></span></td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FECHA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strFecha%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">POR UN VALOR DE:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">Q. <%=strMonto%></span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="5" width=ANCHO_COLUMNA><p align="center"><span class="textoG"><b>REFERENCIA:&nbsp;&nbsp;<%=strSecuencial%></b></span></td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
				</table>				
		<%end if%>
		
		
			<%case 18151 ' Pago Avon
				arrDescripTemp = split(strDescrip,"|")

				%>
					
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000">PAGO DE SERVICIOS</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">PAGO DE SERVICIO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG">AVON<br></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr> 
									
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">COD. CLIENTE::</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strCuenta%><br></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOMBRE CLIENTE:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(0)%><br></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									
									<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">VALOR:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
									<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
								</tr>
								
								<tr>
									
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">BOLETA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strSecuencial%></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%= strFecha & " "&strHora %></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>																		
							</table>
						</td>
					</tr>
					<% case 19104 ' CAMBIO DE BENEFICIARIO TRANSFERENCIAS LOCALES
						arrDescripTemp = split(strDescrip,"|")
				%>	

				<tr>
							<td width="600">
								<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000">Cambio de Beneficiario</font></div>
							</td>
						</tr>		
						<tr>
							<td width="600">
								<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
									
									<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">REMITENTE:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(0)%><br></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>				
										
										<tr> 
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">IDENTIFICACION:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(1)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">BENEFICIARIO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(3) & " "%><%=arrDescripTemp(4) & " "%><%=arrDescripTemp(5)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CODIGO DE TRANSFERENCIA:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(2)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO A PAGAR:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
										<tr>
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NO. BOLETA:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=strSecuencial%></span></td>
											<td>&nbsp;</td>
										</tr>
										
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%= strFecha& " "  & strHora%></span></td>
											<td>&nbsp;</td>
										</tr>
									
									<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td align= center colspan="3">
												<span class="textoG">
												<br>
												<br>
											<br>F: _________________________________<br>
												(Recib&iacute; Conforme)
												</span>
											</td>											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>					
									</tr>	
								</table>
							</td>
						</tr>		
					
				</table>
					<%
					case 19351 ' Solicitud de chequera
					arrDescripTemp = split(strDescrip,"|")
					Dim NoCuenta
					Dim cantidadchequessoli
					Dim cantidadchequerassoli
					Dim nombreubid
					Dim nombreubimuni 
					Dim agenciasoli
					Dim strnombresoli
					
					Dim monedasoli
					Dim cuentaOfuscadasoli
					Dim cuentasoli
					Dim cuentaFinsoli
					Dim lenCuentasoli
                    Dim isoli
		
					cantidadchequessoli = trim(arrDescripTemp(2))
					cantidadchequerassoli = trim(arrDescripTemp(3))
					nombreubid = trim(arrDescripTemp(4))
					nombreubimuni = trim(arrDescripTemp(5))
					agenciasoli = trim(arrDescripTemp(6))
					agenciasoli = agenciasoli +","+ nombreubimuni + "," +  nombreubid
					strnombresoli = trim(arrDescripTemp(7))
					strnombresoli=server.htmlEncode(strnombresoli)

					if ubound(arrDescripTemp) > 8 then
						monedasoli = trim(arrDescripTemp(8))
						cuentasoli = trim(arrDescripTemp(9))
						lenCuentasoli = len(cuentasoli) - 4
						cuentaFinsoli = mid(cuentasoli, lenCuentasoli, 4)
						

						For isoli = 0 to (lenCuentasoli - 1)
							cuentaOfuscadasoli = cuentaOfuscadasoli + "X"
						Next	
						cuentaOfuscadasoli = cuentaOfuscadasoli + cuentaFinsoli
					else
					monedasoli = 0
					end if

					
					%>

                    <tr>
                        <td width="600">
                            <div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">GESTI&Oacute;N - SOLICITUD DE CHEQUERA</font></div>
                        </td>
                    </tr>		
                    <tr>
                        <td width="600">
                            <table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
                                <tr> 
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. de cuenta:</span></td>
									<td><span class="textoG"><%
                                        if Moneda = 1 then
                                        %>
                                        USD/<%=cuentaOfuscadasoli%>/<%=strnombresoli%></span></td>
                                        <%
                                        else
                                        %>
                                        GTQ/<%=cuentaOfuscadasoli%>/<%=strnombresoli%></span></td>
                                        <%
                                        end if
                                        %>
										<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Cantidad de cheques:</span></td>
									<td><span class="textoG"><%=cantidadchequessoli%><br></span></td>
									<td></td>
                                </tr>
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Cantidad de chequera(s):</span></td>
									<td><span class="textoG"><%=cantidadchequerassoli%></span></td>
									<td></td>
                                </tr>
                                
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Age:</span></td>
                                    <td><span class="textoG"><%=agenciasoli%></span></td>
									<td></td>
                                </tr>	
                                <tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
									<td><span class="textoG"><%=strFecha%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>		
	
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Hora:</span></td>
                                    <td><span class="textoG"><%=strHora%></span></td>
									<td></td>
                                </tr>
								<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
									<tr>
										<td></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Monto a pagar:</span></td>
										<td><span class="textoG">
											<%
											if Moneda = 1 then
											%>
											$&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
											<%
											else
											%>
											Q&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
											<%
											end if
											%>
											<td></td>
									</tr>
								<%End if%>
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Secuencial:</span></td>
                                    <td><span class="textoG"><%=strSecuencial%></span></td>
                                </tr>
                                <tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Ref:</span></td>
                                    <td><span class="textoG"><%=strSecuencial%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>				
                                <tr>
                                    <td align= center colspan="5">
                                        <span class="textoG">
                                        <br>
                                    <br>F: _________________________________<br>
                                        (Recib&iacute; Conforme)
                                        </span>
                                    </td>																
                                </tr>	
                                <% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
									<tr>
										<td colspan="6" >
											<div align="center">
												<span class="textoG"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
											</div>
										</td>
									</tr>
								<%End if%>                                                		
                        </td>
                    </tr>
					<%
					case 19352 ' Bloqueo de cheques
					arrDescripTemp = split(strDescrip,"|")
				
					
					Dim nochequeini
					Dim nochequefin
					Dim causa
					Dim strnombrebloq
					Dim cuentabloq
					Dim monedabloq
					Dim cuentaOfuscadabloq
					Dim cuentaFinbloq
					Dim lenCuentabloq
                    Dim ibloq
					Dim cantidadChequesBloq
	
					
					nochequeini = trim(arrDescripTemp(2))
					nochequefin = trim(arrDescripTemp(3))
					causa = trim(arrDescripTemp(1))
					cantidadChequesBloq = trim(arrDescripTemp(7))

					strnombrebloq = trim(arrDescripTemp(4))
					strnombrebloq=server.htmlEncode(strnombrebloq)
					
					if ubound(arrDescripTemp) > 4 then
					monedabloq = trim(arrDescripTemp(5))
					cuentabloq = trim(arrDescripTemp(6))
					lenCuentabloq = len(cuentabloq) - 4
					cuentaFinbloq = mid(cuentabloq, lenCuentabloq+1, 4)
					

					For ibloq = 0 to (lenCuentabloq - 1)
						cuentaOfuscadabloq = cuentaOfuscadabloq + "X"
					Next	
					cuentaOfuscadabloq = cuentaOfuscadabloq + cuentaFinbloq
					else
					monedabloq = 0
					end if
					
					%>
					<tr>
                        <td width="600">
                            <div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">GESTI&Oacute;N - BLOQUEO DE CHEQUES</font></div>
                        </td>
                    </tr>		
                    <tr>
                        <td width="600">
                            <table border="0" CELLSPACING="0" CELLPADDING="2" align="center">
                                <tr> 
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. de cuenta:</span></td>
									<td><span class="textoG"><%
                                        if monedabloq = 1 then
                                        %>
                                        USD/<%=cuentaOfuscadabloq%>/<%=strnombrebloq%></span></td>
                                        <%
                                        else
                                        %>
                                        GTQ/<%=cuentaOfuscadabloq%>/<%=strnombrebloq%></span></td>
                                        <%
                                        end if
                                        %>
										<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Acci&oacute;n:</span></td>
									<td><span class="textoG">Bloqueo<br></span></td>
									<td></td>
                                </tr>

                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">N&uacute;mero de cheque:</span></td>
									<td><span class="textoG"><%=nochequeini%> - <%=nochequefin%></span></td>
									<td></td>
                                </tr>
								<tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Cantidad de cheques bloqueados:</span></td>
                                    <td><span class="textoG"><%=cantidadChequesBloq%></span></td>
									<td></td>
                                </tr>
                                
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Causa:</span></td>
                                    <td><span class="textoG"><%=causa%></span></td>
									<td></td>
                                </tr>	
                                <tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
									<td><span class="textoG"><%=strFecha%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>		
	
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Hora:</span></td>
                                    <td><span class="textoG"><%=strHora%></span></td>
									<td></td>
                                </tr>
								<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
									<tr>
										<td></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Monto a pagar:</span></td>
										<td><span class="textoG">
											<%
											if Moneda = 1 then
											%>
											$&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
											<%
											else
											%>
											Q&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
											<%
											end if
											%>
											<td></td>
									</tr>
								<%End if %>
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Secuencial:</span></td>
                                    <td><span class="textoG"><%=strSecuencial%></span></td>
                                </tr>
                                <tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Ref:</span></td>
                                    <td><span class="textoG"><%=strSecuencial%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>				
                                <tr>
                                    <td align= center colspan="5">
                                        <span class="textoG">
                                        <br>
                                    <br>F: _________________________________<br>
                                        (Recib&iacute; Conforme)
                                        </span>
                                    </td>																
                                </tr>	
								<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
									<tr>
										<td colspan="5" >
											<div align="center">
												<span class="textoImpresionP"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
											</div>
										</td>
									</tr>	
								<%End if%>
                                <tr>
									<td align= center colspan="4">
										<span class="textoG">Cliente amigo si necesitas realizar nuevamente el bloqueo de este n&uacutemero de cheque solo podr&aacutes realizarlo en una agencia. 
										</span>
									</td>						
								</tr>
                        
                        		
                        </td>
                    </tr>

					<%
					case 19353 ' Desbloqueo de cheques
					arrDescripTemp = split(strDescrip,"|")
				
					
					Dim nochequeinidesbloq
					Dim nochequefindesbloq
					Dim strnombredesbloq
					
					Dim monedadesbloq
					Dim cuentadesbloq
					Dim cuentaOfuscadadesbloq
					Dim cuentaFindesbloq
					Dim lenCuentadesbloq
                    Dim idesbloq
					Dim cantidadChequesDesbloq
	
					cantidadChequesDesbloq = trim(arrDescripTemp(6))
		
	
					
					nochequeinidesbloq = trim(arrDescripTemp(1))
					nochequefindesbloq = trim(arrDescripTemp(2))

					strnombredesbloq = trim(arrDescripTemp(3))
					strnombredesbloq=server.htmlEncode(strnombredesbloq)
					if ubound(arrDescripTemp) > 3 then
						monedadesbloq = trim(arrDescripTemp(4))
						cuentadesbloq = trim(arrDescripTemp(5))
						lenCuentadesbloq = len(cuentadesbloq) - 4
						cuentaFindesbloq = mid(cuentadesbloq, lenCuentadesbloq, 4)

						For idesbloq = 0 to (lenCuentadesbloq - 1)
							cuentaOfuscadadesbloq = cuentaOfuscadadesbloq + "X"
						Next	
						cuentaOfuscadadesbloq = cuentaOfuscadadesbloq + cuentaFindesbloq
					else
					monedadesbloq = 0
					end if
					
					%>
					<tr>
                        <td width="600">
                            <div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">GESTI&Oacute;N - DESBLOQUEO DE CHEQUES</font></div>
                        </td>
                    </tr>		
                    <tr>
                        <td width="600">
                            <table border="0" CELLSPACING="0" CELLPADDING="2" align="center">
                                <tr> 
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. de cuenta:</span></td>
									<td><span class="textoG"><%
                                        if monedadesbloq = 1 then
                                        %>
                                        USD/<%=cuentaOfuscadadesbloq%>/<%=strnombredesbloq%></span></td>
                                        <%
                                        else
                                        %>
                                        GTQ/<%=cuentaOfuscadadesbloq%>/<%=strnombredesbloq%></span></td>
                                        <%
                                        end if
                                        %>
										<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Acci&oacute;n:</span></td>
									<td><span class="textoG">Desbloqueo<br></span></td>
									<td></td>
                                </tr>

                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">N&uacute;mero de cheque:</span></td>
									<td><span class="textoG"><%=nochequeinidesbloq%> - <%=nochequefindesbloq%></span></td>
									<td></td>
                                </tr>
								<tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Cantidad de cheques Desbloqueados:</span></td>
                                    <td><span class="textoG"><%=cantidadChequesDesbloq%></span></td>
									<td></td>
                                </tr>	
                                <tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
									<td><span class="textoG"><%=strFecha%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>		
	
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Hora:</span></td>
                                    <td><span class="textoG"><%=strHora%></span></td>
									<td></td>
                                </tr>
								<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
									<tr>
										<td></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Monto a pagar:</span></td>
										<td><span class="textoG">
											<%
											if Moneda = 1 then
											%>
											$&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
											<%
											else
											%>
											Q&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
											<%
											end if
											%>
											<td></td>
									</tr>
								<%End if %>
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Secuencial:</span></td>
                                    <td><span class="textoG"><%=strSecuencial%></span></td>
                                </tr>
                                <tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Ref:</span></td>
                                    <td><span class="textoG"><%=strSecuencial%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>				
                                <tr>
                                    <td align= center colspan="5">
                                        <span class="textoG">
                                        <br>
                                    <br>F: _________________________________<br>
                                        (Recib&iacute; Conforme)
                                        </span>
                                    </td>																
                                </tr>	
								<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
									<tr>
										<td colspan="6" >
											<div align="center">
												<span class="textoImpresionP"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
											</div>
										</td>
									</tr>	
								<%End if%>
                                
                        
                        		
                        </td>
                    </tr>	
					<%
					case 19354 ' Predeclaracion de cheques
					arrDescripTemp = split(strDescrip,"|")
				
					
					Dim nochequepredecla
					Dim strnombrepredecla
					
					Dim monedapredecla
					Dim cuentapredecla
					Dim cuentaOfuscadapredecla
					Dim cuentaFinpredecla
					Dim lenCuentapredecla
                    Dim ipredecla
                    Dim beneficiariopredecla
                    Dim valorchequepredecla
		
					nochequepredecla = trim(arrDescripTemp(0))
					valorchequepredecla = trim(arrDescripTemp(1))
					beneficiariopredecla = trim(arrDescripTemp(4))
					beneficiariopredecla=server.htmlEncode(beneficiariopredecla)

					strnombrepredecla = trim(arrDescripTemp(2))
					strnombrepredecla=server.htmlEncode(strnombrepredecla)
					if ubound(arrDescripTemp) > 3 then
						monedapredecla = trim(arrDescripTemp(3))
						cuentapredecla = trim(arrDescripTemp(5))
						lenCuentapredecla = len(cuentapredecla) - 4
						cuentaFinpredecla = mid(cuentapredecla, lenCuentapredecla+1, 4)

						For ipredecla = 0 to (lenCuentapredecla - 1)
							cuentaOfuscadapredecla = cuentaOfuscadapredecla + "X"
						Next	
						cuentaOfuscadapredecla = cuentaOfuscadapredecla + cuentaFinpredecla
					else
					monedapredecla = 0
					end if
					
					%>
					<tr>
                        <td width="600">
                            <div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">GESTI&Oacute;N - PREDECLARACI&Oacute;N DE CHEQUES</font></div>
                        </td>
                    </tr>		
                    <tr>
                        <td width="600">
                            <table border="0" CELLSPACING="0" CELLPADDING="3" align="center">
                                <tr> 
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. de cuenta:</span></td>
									<td><span class="textoG"><%
                                        if monedapredecla = 1 then
                                        %>
                                        USD/<%=cuentaOfuscadapredecla%>/<%=strnombrepredecla%></span></td>
                                        <%
                                        else
                                        %>
                                        GTQ/<%=cuentaOfuscadapredecla%>/<%=strnombrepredecla%></span></td>
                                        <%
                                        end if
                                        %>
										<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Cheque predeclarado:</span></td>
									<td><span class="textoG"><%=nochequepredecla%></span></td>
									<td></td>
                                </tr>	
                                <tr>
                                    <td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Beneficiario:</span></td>
                                    <td><span class="textoG"><%=beneficiariopredecla%></span></td>
                                    <td></td>
                                </tr>
								
									<tr>
										<td></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Monto:</span></td>
										<td><span class="textoG"><%
											if monedapredecla = 1 then
											%>
											$. <%=valorchequepredecla%></span></td>
											<%
											else
											%>
											Q. <%=valorchequepredecla%></span></td>
											<%
											end if
											%>
											
										<td></td>
									</tr>
									
								<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
								<tr>
									<td width="10%"></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Monto Comisi&oacute;n:</span></td>
									<td><span class="textoG">Q. <%=formatnumber(strMonto)%></span></td>
									<td width="10%"></td>
														
								</tr>
								<%End if %>
                                <tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
									<td><span class="textoG"><%=strFecha%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>		
	
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Hora:</span></td>
                                    <td><span class="textoG"><%=strHora%></span></td>
									<td></td>
                                </tr>
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Secuencial:</span></td>
                                    <td><span class="textoG"><%=strSecuencial%></span></td>
                                </tr>
                                <tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Ref:</span></td>
                                    <td><span class="textoG"><%=strSecuencial%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>				
                                <tr>
                                    <td align= center colspan="5">
                                        <span class="textoG">
                                    <br>F: _________________________________<br>
                                        (Recib&iacute; Conforme)
                                        </span>
                                    </td>																
                                </tr>	
								<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
									<tr>
										<td colspan="6" >
											<div align="center">
												<span class="textoImpresionP"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
											</div>
										</td>
									</tr>	
								<%End if%>
                                <tr>
									<td align= center colspan="4">
										<span class="textoImpresionP"><strong>IMPORTANTE: </strong>La predeclaraci&oacute;n de cheques no garantiza el pago de cheques con firmas variadas, redacciones incorrectas o cualquier otra causa al momento de su pago , el <strong>CLIENTE</strong> acepta los t&eacute;rminos y condiciones de uso.
										</span>
									</td>					
								</tr>	
                        </td>
                    </tr>	

					<%
					case 19361 ' Bloqueo de TC
					arrDescripTemp = split(strDescrip,"|")
				
					
				
					Dim strnombrebloqtc
					
					Dim monedabloqtc
					Dim tarjetabloqtc
					Dim tarjetaOfuscadabloqtc
					Dim tarjetaFinbloqtc
					Dim tarjetaInibloqtc
					Dim lenTarjetabloqtc
                    Dim ibloqtc
					Dim causabloqtc
					Dim mensajeBoletaBloqTC
		
				
					causabloqtc = trim(arrDescripTemp(1))
					if causabloqtc = "ROBO" then
						mensajeBoletaBloqTC = "Cliente amigo este bloqueo es para su cancelaci&oacuten y reposici&oacuten de pl&aacutestico, el &aacuterea de tarjeta de cr&eacutedito se estar&aacute poniendo en contacto para su entrega."
					else
						mensajeBoletaBloqTC = "Cliente amigo este bloqueo es temporal, para su desbloqueo solo puede realizarse en una agencia."
					end if


					strnombrebloqtc = trim(arrDescripTemp(2))
					strnombrebloqtc=server.htmlEncode(strnombrebloqtc)

					
						monedabloqtc = 0
						'monedabloqtc = trim(arrDescripTemp(3))
						tarjetabloqtc = trim(arrDescripTemp(4))
						lenTarjetabloqtc = len(tarjetabloqtc) - 4
						tarjetaFinbloqtc = mid(tarjetabloqtc, lenTarjetabloqtc+1, 4)
						tarjetaInibloqtc = mid(tarjetabloqtc, 1,4)
						For ibloqtc = 0 to (lenTarjetabloqtc - 1)
							tarjetaOfuscadabloqtc = tarjetaOfuscadabloqtc + "X"
						Next	
						tarjetaOfuscadabloqtc = tarjetaInibloqtc + tarjetaOfuscadabloqtc + tarjetaFinbloqtc
					
					%>
					<tr>
                        <td width="600">
                            <div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Gesti&oacute;n Tarjeta de Cr&eacutedito - Bloqueo</font></div>
                        </td>
                    </tr>		
                    <tr>
                        <td width="600">
                            <table border="0" CELLSPACING="0" CELLPADDING="2" align="center">
								<tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Nombre de la cuenta: </span></td>
									<td><span class="textoG"><%=strnombrebloqtc%><br></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>

                                <tr> 
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. de Tarjeta:</span></td>
									<td><span class="textoG"><%
                                        if monedabloqtc = 1 then
                                        %>
                                        USD/<%=tarjetaOfuscadabloqtc%>/<%=strnombrebloqtc%> (Tarjeta de Cr&eacutedito) </span></td>
                                        <%
                                        else
                                        %>
                                        GTQ/<%=tarjetaOfuscadabloqtc%>/<%=strnombrebloqtc%> (Tarjeta de Cr&eacutedito) </span></td>
                                        <%
                                        end if
                                        %>
										<td></td>
                                </tr>
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Acci&oacute;n:</span></td>
									<td><span class="textoG">Bloqueo<br></span></td>
									<td></td>
                                </tr>

                               
                                
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Causa:</span></td>
                                    <td><span class="textoG"><%=causabloqtc%></span></td>
									<td></td>
                                </tr>
								<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
								<tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Monto a pagar:</span></td>
                                    <td><span class="textoG">
                                        
                                        Q&nbsp; <%=FormatNumber(strMonto)%>&nbsp;</span></td>
                                      
										<td></td>
                                </tr>
								<%End if%>	

                                <tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
									<td><span class="textoG"><%=strFecha%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>		
	
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Hora:</span></td>
                                    <td><span class="textoG"><%=strHora%></span></td>
									<td></td>
                                </tr>
                               
                                <tr>
									<td></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Secuencial:</span></td>
                                    <td><span class="textoG"><%=strSecuencial%></span></td>
                                </tr>
                                <tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                    <td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Ref:</span></td>
                                    <td><span class="textoG"><%=strSecuencial%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
                                </tr>				
                                <tr>
                                    <td align= center colspan="5">
                                        <span class="textoG">
                                        <br>
                                    <br>F: _________________________________<br>
                                        (Recib&iacute; Conforme)
                                        </span>
                                    </td>																
                                </tr>
								<tr>
									<td align= center colspan="4">
										<span class="textoG"><strong><%=mensajeBoletaBloqTC%></strong>
										</span>
									</td>					
								</tr>	
                                
                        
                        		
                        </td>
                    </tr>	
					
					<%
					case 19371 ' Apertura Cuenta
					arrDescripTemp = split(strDescrip,"|")
				
					Dim strnombreApertura, tipoCuentaApertura, agenciaMatrizApertura
					Dim solicitaChequera, solicitaTarjeta, solicitaNotifi, solicitaBanca
					Dim telefono, correo

					strnombreApertura = trim(arrDescripTemp(2))
					strnombreApertura=server.htmlEncode(strnombreApertura)

					tipoCuentaApertura = trim(arrDescripTemp(0))
					tipoCuentaApertura=server.htmlEncode(tipoCuentaApertura)
					agenciaMatrizApertura = trim(arrDescripTemp(1))
					
					solicitaChequera = trim(arrDescripTemp(4))
					solicitaTarjeta = trim(arrDescripTemp(5))
					solicitaNotifi = trim(arrDescripTemp(6))
					solicitaBanca = trim(arrDescripTemp(7))
					telefono = trim(arrDescripTemp(8))
					correo = trim(arrDescripTemp(9))

					if solicitaChequera = "S" Then 
						solicitaChequera = "S&iacute;"
					else 
						solicitaChequera = "No"
					end If

					if solicitaTarjeta = "S" Then 
						solicitaTarjeta= "S&iacute;"
					else 
						solicitaTarjeta = "No"
					end If

					if solicitaNotifi = "S" Then 
						solicitaNotifi= "S&iacute;"
					else 
						solicitaNotifi = "No"
					end If

					if solicitaBanca = "S" Then 
						solicitaBanca= "S&iacute;"
					else 
						solicitaBanca = "No"
					end If
					%>
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">SOLICITUD DE APERTURA DE CUENTA</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600">
						<% if solicitaTarjeta = "S&iacute;" and solicitaNotifi = "S&iacute;" then %>
							<table border="0" CELLSPACING="2" CELLPADDING="0.5" align="center" style="justify-content: center; line-height: 1;">	
						<% elseif solicitaTarjeta = "No" and solicitaNotifi = "S&iacute;" then 	
							if	solicitaChequera <> "No" then %>
								<table border="0" CELLSPACING="2" CELLPADDING="1" align="center" style="justify-content: center; line-height: 1.10;">	
							<% else %>
								<table border="0" CELLSPACING="2" CELLPADDING="2" align="center" style="justify-content: center; line-height: 1.30;">	
							<% end if %>							
						<% elseif solicitaTarjeta = "S&iacute;" and solicitaNotifi= "No" then 
							if	solicitaChequera <> "No" then %>
								<table border="0" CELLSPACING="2" CELLPADDING="0.5" align="center" style="justify-content: center; line-height: 1.20;">	
							<% else %>
								<table border="0" CELLSPACING="2" CELLPADDING="1.5" align="center" style="justify-content: center; line-height: 1.20;">					
							<% end if %>							
						<%else
							if	solicitaChequera<> "No" then %>		
								<table border="0" CELLSPACING="2" CELLPADDING="1.5" align="center" style="justify-content: center;">				
							<% else %>
								<table border="0" CELLSPACING="2" CELLPADDING="3" align="center" style="justify-content: center;">				
							<% end if %>							
						<%end if%>		
								<tr>
									
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Nombre:</span></td>
									<td><span class="textoG"><%=strnombreApertura%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									
								</tr>
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">N&uacute;mero de Cuenta:</span></td>
									<td><span class="textoG"><%=strCuenta%></span></td>
									<td></td>
								</tr>
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Tipo de Cuenta:</span></td>
									<td><span class="textoG"><%=tipoCuentaApertura%></span></td>
									<td></td>
								</tr>
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Dep&oacute;sito Inicial:</span></td>
									<td><span class="textoG">Q.&nbsp;<%=FormatNumber(strMonto)%></span></td>
									<td></td>
								</tr>
								<% if Left(tipoCuentaApertura, 1) = "M" then %>
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Solicitud de chequera:</span></td>
									<td><span class="textoG"><%=solicitaChequera%></span></td>
									<td></td>
								</tr>		
								<%end if%>
								<tr>
									
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Solicitud de tarjeta de d&eacute;bito:</span></td>
									<td><span class="textoG"><%=solicitaTarjeta%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<% if solicitaTarjeta = "S&iacute;" or solicitaChequera = "S&iacute;" then %>
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Agencia para entrega de productos:</span></td>
									<td><span class="textoG"><%=R2%></span></td>
									<td></td>
								</tr>
								<%end if%>
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Solicitud de notificaciones m&oacute;viles:</span></td>
									<td><span class="textoG"><%=solicitaNotifi%></span></td>
									<td></td>
								</tr>
								<% if telefono <> "" then %>
									<% if len(telefono) >= 8 then %>
										<tr>
											<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">N&uacute;mero de tel&eacute;fono:</span></td>
											<td><span class="textoG"><%=ofuscaTelefono(telefono)%></span></td>
											<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
									<%else%>
										<tr>
											<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">N&uacute;mero de tel&eacute;fono:</span></td>
											<td><span class="textoG"><%=""%></span></td>
											<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
									
									<%end if%>
								<%else%>
									<tr>
										<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">N&uacute;mero de tel&eacute;fono:</span></td>
										<td><span class="textoG"><%=""%></span></td>
										<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
								<%end if%>
								
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Correo electr&oacute;nico:</span></td>
									<td><span class="textoG"><%=correo%></span></td>
									<td></td>
								</tr>
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
									<td><span class="textoG"><%=strFecha%>&nbsp;<%=strHora%></span></td>
									<td></td>
								</tr>
								<tr>
									<td align= center colspan="4">
										<span class="textoG">
											<br>
											Cliente amigo para finalizar la gesti&oacute;n de solicitud de apertura de cuenta, deber&aacute;s acercarte a la agencia de entrega del producto en un tiempo no mayor a 30 dias, presentando DPI y recibo original.
										</span><br><br>
							
									</td>
								</tr>
								<% if solicitaNotifi = "S&iacute;" then %>
								<tr>
									<td align= center colspan="4">
										<span class="textoG">
											Cliente amigo las tarifas de notificaciones m&oacute;viles a partir del tercer mes ser&aacute;:
										</span><br>
										<span class="textoG">
											De 01 a 60 Q.5.00, de 61 a 500 Q.10.00 y de 501 en adelante Q.10cts por mensaje.
										</span>
									</td>
								</tr>
								<%end if%>
								<% if solicitaTarjeta = "S&iacute;" then %>
									<table cellSpacing="0" cellPadding="0" width="600" align="center" border="0" style="justify-content: center; line-height: 1;">	
										<tr>
											<td colspan="4" align="center">
												<span class="textoG"> <br><b>IMPORTANTE</b> BANRURAL por este medio autoriza la adhesi&oacute;n de la PRESTACI&Oacute;N DE SERVICIOS BANCARIOS PARA USO DE FONDOS A TRAV&Eacute;S DE TARJETA DE D&Eacute;BITO formalizada en este contrato enviado por correo electr&oacute;nico, el CLIENTE acepta los t&eacute;rminos y condiciones de uso.</span>
											</td>						
										</tr>  
									</table>
								<%end if %>
							</table>
							<table cellSpacing="0" cellPadding="0" width="600" align="center" border="0" style="justify-content: center; line-height: 1;">	
								
								<tr>
									<td align= center colspan="4">
										<span class="textoG"> 
											<br> Cliente amigo esta transacci&oacute;n no tiene ning&uacute;n costo.
										</span>
									</td>					
								</tr>

						</td>
					</tr>
				<%
					case 18167 ' Universidad DaVinci

					arrDescripTemp = split(strDescrip,"|")

					Dim strCarne, strCarrera, strNombre, strTipoPago
					Dim strAnio, strPeriodo, strMontoPago, strSaldoPendiente
					Dim arrFechaAnio, descripcionPago, periodoArr
					
					strCarne = trim(arrDescripTemp(1))
					strCarrera = trim(arrDescripTemp(6))
					strNombre = trim(arrDescripTemp(0))
					strTipoPago = trim(arrDescripTemp(3))
					Select Case strTipoPago
						case "MEN":
								descripcionPago = "MENSUALIDADES"
						case "INS":
								descripcionPago = "INSCRIPCION"
					End Select
					
					arrFechaAnio = Split(arrDescripTemp(5),"/")
					
					strPeriodo = trim(arrDescripTemp(4))
					strPeriodo = Replace(strPeriodo, "Año:", " ")
					strPeriodo = Replace(strPeriodo, "Periodo:", " ")

					periodoArr = Split(strPeriodo,"-")
					
					strMontoPago = trim(arrDescripTemp(2))
					strSaldoPendiente = trim(ref2)
					%>
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">UNIVERSIDAD DA VINCI</font></div>
						</td>
					</tr>	
					
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
								<tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Carne:</span></td>
									<td><span class="textoG"><%=strCarne%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									
								</tr>
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Carrera:</span></td>
									<td><span class="textoG"><%=strCarrera%></span></td>
									<td></td>
								</tr>
								<tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Nombre:</span></td>
									<td><span class="textoG"><%=strNombre%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Tipo de pago:</span></td>
									<td><span class="textoG"><%=strTipoPago%> - <%=descripcionPago%></span></td>
									<td></td>
								</tr>
								<tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Año:</span></td>
									<td><span class="textoG"><%=Trim(periodoArr(0))%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Periodo:</span></td>
									<td><span class="textoG"><%=Trim(periodoArr(1))%></span></td>
									<td></td>
								</tr>
								<tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">N&uacute;mero de boleta:</span></td>
									<td><span class="textoG"><%=strSecuencial%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>	
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Monto a pagar:</span></td>
									<td><span class="textoG">Q.&nbsp;<%=FormatNumber(strMontoPago)%></span></td>
									<td></td>
								</tr>
								<tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Saldo pendiente:</span></td>
									<td><span class="textoG">Q.&nbsp;<%=FormatNumber(strSaldoPendiente)%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Recibo:</span></td>
									<td><span class="textoG"><%=R1%></span></td>
									<td></td>
								</tr>
								<tr>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
									<td><span class="textoG"><%=strFecha%>&nbsp;<%=strHora%></span></td>
									<td>&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
							</table>
						</td>
						
					</tr>
				<%case 18902 ' Beneficio Social
				arrDescripTemp = split(strDescrip,"|")

				%>
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000">RETIRO - PROGRAMA DE BENEFICIO SOCIAL</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
								<tr> 
									
									<td colspan="5" class="textoG" width="2%">&nbsp;</td>
									
								</tr>
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width="45%"><p align="right"><span class="textoG">PROGRAMA: </span></td>
									<td class="textoG" width="2%">&nbsp;</td>
									<td class="textoG" width="45%"><%= arrDescripTemp(7) %></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td class="textoG" width="2%">&nbsp;</td>
									<td width="45%"><p align="right"><span class="textoG">ID PRIMARIO: </span></td>
									<td class="textoG" width="2%">&nbsp;</td>
									<td class="textoG" width="45%"><%= arrDescripTemp(1) %></td>
									<td class="textoG" width="2%">&nbsp;</td>
								</tr>
								<tr> 
									<td class="textoG" width="2%">&nbsp;</td>
									<td width="45%"><p align="right"><span class="textoG">ID SECUNDARIO: </span></td>
									<td class="textoG" width="2%">&nbsp;</td>
									<td class="textoG" width="45%"><%= arrDescripTemp(2) %></td>
									<td class="textoG" width="2%">&nbsp;</td>
								</tr>
								<tr> 
									<td class="textoG" width="2%">&nbsp;</td>
									<td width="45%"><p align="right"><span class="textoG">DOCUMENTO: </span></td>
									<td class="textoG" width="2%">&nbsp;</td>
									<td class="textoG" width="45%"><%= strCuenta %></td>
									<td class="textoG" width="2%">&nbsp;</td>
								</tr>
								<tr>
									<td class="textoG" width="2%">&nbsp;</td>
									<td width="45%"><p align="right"><span class="textoG">NOMBRE DEL BENEFICIARIO:</span></td>
									<td class="textoG" width="2%">&nbsp;</td>
									<td align="left" class="textoG" ><%= arrDescripTemp(3) %></td>
									<td class="textoG" width="2%">&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width="45%"><p align="right"><span class="textoG">DEPARTAMENTO DE PAGO: </span></td>
									<td>&nbsp;</td>
									<td class="textoG" width="45%"><%= arrDescripTemp(5) %></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td class="textoG" width="2%">&nbsp;</td>
									<td width="45%"><p align="right"><span class="textoG">MUNICIPIO DE PAGO: </span></td>
									<td class="textoG" width="2%">&nbsp;</td>
									<td class="textoG" width="45%"><%= arrDescripTemp(6) %></td>
									<td class="textoG" width="2%">&nbsp;</td>
								</tr>
								<tr>
									<td class="textoG" width="2%">&nbsp;</td>
									<td width="45%"><p align="right"><span class="textoG">CUENTA: </span></td>
									<td class="textoG" width="2%">&nbsp;</td>
									<td class="textoG" width="45%"><%= arrDescripTemp(4) %></td>
									<td class="textoG" width="2%">&nbsp;</td>
								</tr>					
								<tr>
									<td class="textoG" width="2%">&nbsp;</td>
									<td width="45%"><p align="right"><span class="textoG">MONTO A RETIRAR:</span></td>
									<td class="textoG" width="2%">&nbsp;</td>
									<td align="left" class="textoG" >Q <%= FormatNumber(strMonto,2) %></td>
									<td class="textoG" width="2%">&nbsp;</td>
								</tr>
								<tr>
									<td class="textoG" width="2%">&nbsp;</td>
									<td width="45%"><p align="right"><span class="textoG">BOLETA NO.:</span></td>
									<td class="textoG" width="2%">&nbsp;</td>
									<td align="left" class="textoG" ><%= strSecuencial %></td>
									<td class="textoG" width="2%">&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td class="textoG" width="2%">&nbsp;</td>
									<td><span class="textoG"> <%= strFecha & " "&strHora %></span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5"><br><br><br></td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5">F:____________________</td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5">(Recib&iacute; Conforme)</td>
								</tr>
								<tr> 
									<td class="textoG" width="2%">&nbsp;</td>
									<td align="right" class="TextoG">&nbsp;</td>
									<td class="textoG" width="2%">&nbsp;</td>
									<td align="left" class="textoG" >&nbsp;</td>
									<td class="textoG" width="2%">&nbsp;</td>
								</tr>																		
							</table>
						</td>
					</tr>
				
				<%case 18252 ' Retiro TC
				arrDescripTemp = split(strDescrip,"|")

				%>
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000">RETIRO TARJETA DE CREDITO</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
				<tr>
					<td>&nbsp;</td>
					</tr>
					<tr> 
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. DE TARJETA::</span></td>
						<td class="textoG" width="2%">&nbsp;</td>
						<td><span class="textoG"><%=mid(strCuenta, 1, 4)& " XXXX XXXX " & mid(strCuenta, 13,16)%></span></td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					</tr>
					<tr> 
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">A NOMBRE DE:</span></td>
						<td class="textoG" width="2%">&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(1)%><br></span></td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					</tr>					
					<tr>
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">POR UN VALOR DE:</span></td>
						<td class="textoG" width="2%">&nbsp;</td>
						<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NUMERO DE BOLETA:</span></td>
						<td class="textoG" width="2%">&nbsp;</td>
						<td><span class="textoG"><%=strSecuencial%></span></td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					</tr>
					<tr>
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA::</span></td>
						<td class="textoG" width="2%">&nbsp;</td>
						<td><span class="textoG"> <%= strFecha & " "&strHora %></span></td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					</tr>	
					<tr>
						<td>&nbsp; 
						</td>
					</tr>				
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table>
						</td>
					</tr>
				
				<%case 18117 ' Pago Upana
				arrDescripTemp = split(strDescrip,"|")

				%>
					
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000">PAGO DE SERVICIOS</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
								
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">PAGO DE:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG">UNIVERSIDAD PANAMERICANA<br></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr> 
								
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. CARNÉ::</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strCuenta%><br></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
								
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOMBRE:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(0)%><br></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
								
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">VALOR:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
								
									<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NO. REFERENCIA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strSecuencial%></span></td>
									<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
								</tr>
								<tr>
								
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%= strFecha & " "&strHora %></span></td>
									<td>&nbsp;</td>
								</tr>						
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>																		
							</table>
						</td>
					</tr>
					<% case 19003   ' Paga Tarjeta de Credito
						Dim  moneda
						moneda = 0
					arrDescripTemp = split(strDescrip,"$")
					if ubound(arrDescripTemp) > 1 then
						moneda = 1
					end if
				
										
				%>
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO TARJETA DE CREDITO</font></div>
			</td>
		</tr>
		<tr>
			<td width="600">
				<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">TARJETA:</span></td>
						<td>&nbsp;</td>
						
						<%if moneda = 0 then%>
						<td><span class="textoG"><%=mid(strCuenta, 1, 4)& " XXXX XXXX " & mid(strCuenta, 13,16)%></span></td>
						<%else%>
						<td><span class="textoG"><%=mid(arrDescripTemp(0), 1, 4)& " XXXX XXXX " & mid(arrDescripTemp(0), 13,16)%></span></td>
						<%end if%>
						
						<td>&nbsp;</td>
					</tr>					
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">NOMBRE CLIENTE:</span></td>
						<td>&nbsp;</td>
						<%if moneda = 1 then%>
						<td><span class="textoG"><%=arrDescripTemp(3)%></span></td>
						<%else%>
						<td><span class="textoG"><%=strDescrip%></span></td>
						<%end if%>
						<td>&nbsp;</td>
					</tr>
					<tr>
						
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">VALOR:</span></td>
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA1><span class="textoG">
						<%
						if moneda = 1 then
							strMonto = arrDescripTemp(2)
							strMonto = strMonto / arrDescripTemp(1)
						%>
						$&nbsp;
						<%
						else
						%>
						Q&nbsp;
						<%
						end if
						%>
						
						<%=FormatNumber(strMonto)%>&nbsp;</span></td>
						<td>&nbsp;</td>
					</tr>
					<%if moneda = 1 then%>
					<tr>
						
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">TASA DE CAMBIO:</span></td>
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA1><span class="textoG">Q&nbsp;<%=arrDescripTemp(1)%>&nbsp;</span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">EQUIVALENTE Q:</span></td>
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA1><span class="textoG">Q&nbsp;<%=FormatNumber(arrDescripTemp(2))%>&nbsp;</span></td>
						<td>&nbsp;</td>
					</tr>
					<%end if%>
					
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">REFERENCIA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%=strSecuencial%></span></td>
						<td>&nbsp;</td>
					</tr>
					
					<tr>
						<td>&nbsp;</td>
						<td ><p align="right"><span class="textoG">FECHA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"> <%= strFecha & " "&strHora %></span></td>
						<td>&nbsp;</td>
					</tr>
		
				
					<tr>
						<td align="left">&nbsp;&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td align="right"><strong>Reimpresi&oacute;n</strong>&nbsp;&nbsp;&nbsp;</td>
					</tr>	
				</table>
				
	<%CASE 18255 'retiros genericos 
				%>

				<tr>
                    <td width="600px">
				        <div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGOS GEN&Eacute;RICOS</font></div>
			        </td>
		        </tr>

                <tr> 
                    <td>
                        <table border="0" CELLSPACING="0" CELLPADDING="3" align="center" width="595px" >
					        <tr> 
						        <td colspan="5"><p align="justify">
							        <span class="textoG">
								        BANCO DE DESARROLLO RURAL S,A. - Pagos Genericos 17000 - <%=reso5 %> - <%=strNombreEmpresa %> - N-ON - QUETZALES  996 <%=Session("VGLogin")%> <%=esp%> <%=strFechaR%> <%=strHoraR%> <%=esp%> <%=strSecuencial%> <%=esp%> <%=strSecuencial + 1%>
								        FORMA ELECTRONICA NO:<%=Recibo%>  SERIE: <%=Resolucion%> BOLETA:<%=strSecuencial%>
							        </span>
						        </td>
					        </tr>
				        </table>

                        <br>
				        <table class="textoRef" border="0" CELLSPACING="0" CELLPADDING="0" align="left" width="550px">
                            <tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
									<td>&nbsp;</td>
									
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							</tr>

							 <tr >
                                
                                <td class="textoG" align="right">TRANSACCION: </td>
                                <td></td>
                                <td class="textoG" align="left"><%=reso1%></td>
                                
                            </tr>

							<tr >
                                <td class="textoG" align="right" >No. Boleta: </td>
                                <td>&nbsp;</td>
                                <td class="textoG" align="left"> <%=strSecuencial%></td>
                            </tr>

							<tr >
                                <td class="textoG" align="right" >DPI: </td>
                                <td>&nbsp;</td>
                                <td class="textoG" align="left"><%=reso2%></td>
                            </tr>						
							
							 <%  if reso6 <> "" Then%>
                            <tr> 
						        <td class="textoG" align="right"> Llave Alterna: </td>
						        <td>&nbsp;</td>
						        <td class="textoG" align="left"><%=reso6%></td>
					        </tr>
                            <% end if%>


                            <tr>
                                <td class="textoG" align="right"> <%=R1%></td>
                                <td>&nbsp;</td>
                                <td class="textoG" align="left"> <%=ref1%></td>
                            </tr>

                           
                            <tr>
                                <td class="textoG" align="right"> <%=R2%></td>
                                <td>&nbsp;</td>
                                <td class="textoG" align="left"> <%=ref2%></td>
                            </tr>

							<%  if reso6 <> "" Then%>
							<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
									<td>&nbsp;</td>
									
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							</tr>
							<% end if%>

                            <tr>
                                <td class="textoG" align="right"> <%=R3%></td>
                                <td>&nbsp;</td>
                                <td class="textoG" align="left"> <%=ref3%></td>
                            </tr>

							<%  if reso6 = "" Then%>
							<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
									<td>&nbsp;</td>
									
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							</tr>
							<% end if%>

                            <tr>
                                <td class="textoG" align="right"> <%=R4%></td>
                                <td>&nbsp;</td>
                                <td class="textoG" align="left"> <%=ref4%></td>
                            </tr>
                             
                            <tr>
                                <td class="textoG" align="right"> <%=R5%></td>
                                <td>&nbsp;</td>
                                <td class="textoG" align="left"> <%=ref5%></td>
                            </tr>						

							<tr>
                                <td class="textoG" align="right"> <%=reso3%></td>
                                <td>&nbsp;</td>
                                <td class="textoG" align="left"> <%=reso4%></td>
                            </tr>					


                            <tr>
                                <td class="textoG" align="right"> Valor a Pagar: </td>
                                <td>&nbsp;</td>
                                <td class="textoG" align="left"> <%=strTotal%></td>
                            </tr>

							<tr>
                                <td class="textoG" align="right"> Fecha: </td>
                                <td>&nbsp;</td>
                                <td class="textoG" align="left"> <%=strHoraR%></td>
                            </tr>

							<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
									<td>&nbsp;</td>
									
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							</tr>

							<tr>
								<td align= center colspan="5">
									<span class="textoImpresionP">
									<br>
									<br>
									F: ___________________________________________<br>
									(Recib&iacute; Conforme)
									<br>
									<br>
									</span>
								</td>																
							</tr>
						</table>
					</tr>
					<%	
			case 19151
				arrDescripTemp = split(strDescrip,"|")	
		%>
		
	
				<tr>
					<td width="600">
						<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000"> APORTE TELET&Oacute;N </font></div>
					</td>
				</tr>		
				<tr>
					<td width="600">
						<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
						<tr>
							<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							<td>&nbsp;</td>							
							<td>&nbsp;</td>							
							<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						</tr>
							<tr> 
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. DE CUENTA::</span></td>
						<td>&nbsp;</td>
						<td>
							<span class="textoG">
								9999<br>
							</span>
						</td>
						</tr>
						<tr>
							<td width=ANCHO_COLUMNA>
								<p align="right"><span class="textoG">NOMBRE DE LA CUENTA:</span>
							</td>
							<td>&nbsp;</td>
							<td><span class="textoG">Aportes - Banrural Telet&oacute;n</span></td>
						</tr>		
							<tr>
								<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">VALOR DEL APORTE:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"><%= "Q" & FormatNumber(strMonto,2)%>&nbsp;</span></td>
							</tr>					
							<tr>
								<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NUMERO DE TRASACCI&Oacute;N:</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"> <%=strSecuencial%> </span></td>
							</tr>
							<tr>
								<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA::</span></td>
								<td>&nbsp;</td>
								<td><span class="textoG"> <%= strFecha & " " & strHora%> </span></td>
							</tr>	
														<tr>
								<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
								<td>&nbsp;</td>
								<td>&nbsp;</td>								
								<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							</tr>		
						</table>
					</td>
				</tr>
				<%case 18150 ' Cobros empresariales Genericos
					arrDescripTemp = split(strDescrip,"|")
					Dim Recibo
					Dim Resolucion
					Dim usa_re
					Dim SecuencialCon
					Dim strNombreTran
					Dim fec_proc
					
					'cche formato fecha
					dim fecha_actual, fecha_actual_format , fecha_actual_array, fecha_con_array, fecha_con_final 
					fecha_actual = Now()
					fecha_actual_array = Split(fecha_actual,"/")
					fec_proc = split(strFechaR,"/")
						
					fecha_actual_format 	= fecha_actual_array(1) & "/" & fecha_actual_array(0) & "/" & fecha_actual_array(2)
					fecha_actual_format =  Split(fecha_actual_format," ")
					'transformar fecha consulta
					fecha_con_array = Split(fecha_consulta,"/")
					
					fecha_con_final 	= CInt(fecha_con_array(1)) & "/" & CInt(fecha_con_array(0)) & "/" & CInt(fecha_con_array(2))
					'cche fin formato fecha
							
							
					
					SecuencialCon = trim(arrDescripTemp(5))
					strNombreTran = trim(arrDescripTemp(6))
					usa_re = trim(arrDescripTemp(4))
					
					if usa_re = "2" then
						 Recibo = "----"
						 Resolucion = "---"
						 
					else
						Recibo = trim(arrDescripTemp(3))
						Resolucion = trim(arrDescripTemp(2))
						
					end if
				%>
					
						<tr>
							<td width="600">
								<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000">PAGOS VARIOS</font></div>
							</td>
						</tr>		
						<tr>
							<td width="600">
								<table border="0" CELLSPACING="0" CELLPADDING="3" align="center">
										
									<tr>			
										<td>
											<table border="0" CELLSPACING="0" CELLPADDING="3" align="center">
												<tr> 
													<td colspan="5"><p align="justify">
														<span class="textoG">
															BANCO DE DESARROLLO RURAL S,A. - CxCA 16800 - <%=strCuenta%> - <%=strNombreEmpresa %> - N-ON - QUETZALES  996 <%=Session("VGLogin")%> <%=esp%> <%=strFechaR%> <%=esp%> <%=strHora%> <%=esp%> <%=fec_proc(2)%> <%=fec_proc(1)%> <%=fec_proc(0)%> <%=esp%> <%=trim(arrDescripTemp(0))%> <%=esp%> <%=trim(arrDescripTemp(1))%> 
															FORMA ELECTRONICA NO:<%=Recibo%> SERIE: <%=Resolucion%> BOLETA:<%=strSecuencial%>
														</span>
													</td>
													
												</tr>
											</table>	
											<br>
											<table  border="0" CELLSPACING="0" CELLPADDING="0" align="left">
										
												<tr > 
													<td class="textoG" align="right">
															TRANSACCION:
													</td>
													<td>&nbsp;</td>
													<td class="textoG">
															<%=strNombreTran%>
													</td>
												</tr>
												
												<tr > 
													<td class="textoG" align="right">
															CODIGO:
													</td>
													<td>&nbsp;</td>
													<td class="textoG" align="left">
															<%=strTran%>
													</td>
												</tr>
																						
												  	<%																																				 
														On Error Resume Next

														if fecha_con_final = fecha_actual_format(0) then 
															Call MuestraDatosCertificacion (strCuentaR, strTran, SecuencialCon,"0")
														else 
															Call MuestraDatosCertificacionHis (strCuentaR, strTran, SecuencialCon,"0")
														end if 
														If Err.number <> 0 then 'Ocurrió un error
															Response.End
														end if																				
													%>
												
												<tr > 
													<td class="textoG" align="right">
															VALOR A PAGAR:
													</td>
													<td>&nbsp;</td>
													<td class="textoG" align="left">
															 <%=formatNumber(strMonto) %>
													</td>
												</tr>
														
											</table>			
											</br></br></br></br></br>
												
										</td>
									</tr>				
									</table>
							</td>
						</tr>
				<%case 18156 'Pago Pensiones Alimenticias OJ
					arrDescripTemp = split(strDescrip,"|")
					%>
					<tr>
						<td width="600">
							<div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#000">Pago Servicios</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="0" CELLPADDING="0" align="center">
								<tr>
									<td align="center" colspan="5"><span class="textoG"><%= R1 & " " & ref1 & " " & R2 & " " & ref2 & " " & R3%></span></td>
								</tr>
								<tr align="center">
									<td align="center" colspan="2"><span class="textoG">SERIE: <%=arrDescripTemp(1)%></span></td> 
									<td align="center" colspan="3"><span class="textoG">NO: <%=arrDescripTemp(2)%></span></td> 
								</tr>								
								<tr>
									<td colspan="5">&nbsp;</td>
								</tr>	
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">TRANSACCION:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG">DEPOSITO PENSIONES ALIMENTICIAS<br></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">REFERENCIA NO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=(strSecuencial)%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CASO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(2)%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MESES:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(0)%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">BENEFICIARIO:</span></td> 
									<td>&nbsp;</td>
									<td><span class="textoG"><%=R5%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">DEPENDENCIA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=ref5%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">DEPOSITANTE:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=R4%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CUENTA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=ref4%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%= strFecha &" "& strHora %></span></td>
									<td>&nbsp;</td>
								</tr>						
								<tr>
									<td align= center colspan="5">
										<span class="textoImpresionP">
										<br>
										<br>
										F: ___________________________________________<br>
										(Recib&iacute; Conforme)
										<br>
										<br>
										</span>
									</td>																
								</tr>																		
							</table>
						</td>
					</tr>
				<%case 18155 'Pago Antecedentes OJ					
					arrDescripTemp = split(strDescrip,"|")
					%>					
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000">Pago Servicios</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="0" CELLPADDING="2" align="center">
								<tr>
									<td colspan="5" align="center"><span class="textoG"><%= R1 & " " & ref1 & " " & R2 & " " & ref2 & " " & R3%></span></td>
								</tr>	
								<tr>
									<td colspan="5" align="center">
										<span class="textoG">SERIE: <%=arrDescripTemp(0)%>&nbsp;</span>
										<span class="textoG">&nbsp;No.: <%=arrDescripTemp(1)%>&nbsp;</span>
										<span class="textoG">&nbsp;V. <%=arrDescripTemp(7)%></span>
									</td>
								</tr>								
								<tr>
									<td colspan="5">&nbsp;</td>
								</tr>					
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">TRANSACCION:</span></td>
									<td><span class="textoG">ANTECEDENTES PENALES</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td colspan="3" width=ANCHO_COLUMNA><p align="right"><span class="textoG">REFERENCIA NO:</span></td>
									<td><span class="textoG"><%=(strSecuencial)%></span></td>
									<td>&nbsp;</td>
								</tr>																
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">BENEFICIARIO:</span></td>
									<td><span class="textoG"><%=UCase(arrDescripTemp(5))%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>																		
								<tr>
									<td>&nbsp;</td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">DEPENDENCIA:</span></td>
									<td><span class="textoG"><%=arrDescripTemp(6)%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>	
								<tr>
									<td>&nbsp;</td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">CUENTA:</span></td>
									<td><span class="textoG"><%=arrDescripTemp(4)%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
									<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td><span class="textoG"> <%= strFecha &" "& strHora %></span></td>
									<td>&nbsp;</td>
								</tr>						
								<tr>
									<td align= center colspan="5">
										<span class="textoImpresionP">
										<br>
										<br>
										F: ___________________________________________<br>
										(Recib&iacute; Conforme)
										<br>
										<br>
										<br>
										<br>
										</span>
									</td>																
								</tr>																		
							</table>
						</td>
					</tr>
		<%case 18157 'PAGO FEI FORMULARIO ELECTRONICO
					arrDescripTemp = split(strDescrip,"|")%>
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago Servicios</font></div>
						</td>
					</tr>	
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="0" CELLPADDING="0" align="center">
								<tr>
									<td align="center" colspan="5"><span class="textoG"><%= R1 & " " & ref1 & " " & R2 & " " & ref2 & " " & R3%></span></td>
								</tr>
								<tr>
									<td align="center" colspan="5">
										<span class="textoG">SERIE: <%=arrDescripTemp(0)%>&nbsp;</span>
										<span class="textoG">&nbsp;No.: <%=arrDescripTemp(1)%>&nbsp;</span>
										<span class="textoG">&nbsp;V. <%=arrDescripTemp(2)%></span>
									</td> 
								</tr>
								<tr>
									<td colspan="5">&nbsp;</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">TRANSACCION:</span></td>
									<td><span class="textoG">DEPOSITOS FORMULARIO <br> ELECTRONICO DE INGRESOS (FEI)</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">REFERENCIA:</span></td>
									<td><span class="textoG"><%=strSecuencial%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">NO FEI:</span></td>
									<td><span class="textoG"><%=arrDescripTemp(4)%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;</strong></td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">CASO:</span></td>
									<td><span class="textoG"><%=arrDescripTemp(5)%>&nbsp;</span></td>
									<td align="right">&nbsp;</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;</strong></td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">DEPOSITANTE:</span></td>
									<td><span class="textoG"><%=R4%>&nbsp;</span></td>
									<td align="right">&nbsp;</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">BENEFICIARIO:</span></td>
									<td><span class="textoG"><%=R5%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;</strong></td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">CUENTA:</span></td>
									<td><span class="textoG"><%=ref4%>&nbsp;</span></td>
									<td align="right">&nbsp;</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;</strong></td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">DEPENDENCIA:</span></td>
									<td><span class="textoG"><%=arrDescripTemp(6)%>&nbsp;</span></td>
									<td align="right">&nbsp;</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
									<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td colspan="2" width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td><span class="textoG"> <%= strFecha &" "& strHora %></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align= center colspan="5">
										<span class="textoImpresionP">
										<br>
										<br>
										F: ___________________________________________<br>
										(Recib&iacute; Conforme)
										<br>
										<br>
										</span>
									</td>																
								</tr>																		
							</table>
						</td>
					</tr>
				<%case 18158 'PAGO CONTRALORIA GENERAL DE CUENTAS
					arrDescripTemp = split(strDescrip,"|")%>
							<tr>
								<td width="600">
									<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago Servicios </font></div>
								</td>
							</tr>		
							<tr>
								<td width="600">
									<table width="600">
										<tr>
											<td align= center colspan="4">
												<span class="textoCGC"><%=reso1%> <%=reso2%> <%=reso3%> <%=reso4%> <%=reso5%> <%=reso6%>
												</span>
											</td>
										</tr>	
								</table>
								<br>
									<table border="0" CELLSPACING="0" CELLPADDING="0" align="center">
										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">PAGO DE SERVICIO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC">CONTRALOR&Iacute;A GENERAL DE CUENTAS<br></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
										<tr> 
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">FORMA 63A NO.:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC"><%=arrDescripTemp(7)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr> 
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">MARCA DE CAJA:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC"><%=arrDescripTemp(6)%><br></span></td>
											<td>&nbsp;</td>
										</tr>				

										<tr> 
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">BOLETA:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC"><%=strSecuencial%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										
										<!-- CCHE -->
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">TIPO PAGO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC"><%=arrDescripTemp(0)%>-<%=arrDescripTemp(1)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">CODIGO PAGO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC"><%=arrDescripTemp(2)%>-<%=arrDescripTemp(3)%><br></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
										<tr> 
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">DESCRIPCION:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC"><%=R2%><br></span></td>
											<td>&nbsp;</td>
										</tr>

										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">NIT:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC"><%=R1%> -<%=ref1%><br></span></td>
											<td>&nbsp;</td>	
										</tr>
											
										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">VALOR UNITARIO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC"><%= "Q" & FormatNumber(strMonto / arrDescripTemp(5))%>&nbsp;</span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>

										<!-- CCHE -->
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">NO. COPIAS:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC"><%=arrDescripTemp(5)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">FORMA DE PAGO: </span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC">EFECTIVO: <%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">MONTO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoCGC">Fecha:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoCGC"><%=strFecha &" "& strHora%></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>						
										<tr>
											<td>&nbsp;</td>
											<td align= center colspan="3">
												<span class="textoCGC">
												<br>
											F: _________________________________<br>
												(Recib&iacute; Conforme)
												</span>
											</td>
											<td>&nbsp;</td>
										</tr>										
									</table>				
								</td>
							</tr>
<%case 18159 'Antecedentes Policiales
					arrDescripTemp = split(strDescrip,"|")%>
							<tr><td><br/><br/></td></tr>
							<tr>
								<td width="600">
									<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago Servicios</font></div>
								</td>
							</tr>		
							<tr>
								<td width="600">
									<table border="0" CELLSPACING="1" CELLPADDING="1" align="center">
										<tr>
											<td align= center colspan="5">
												<span class="textoG"><%=reso1%> <%=reso2%> <%=reso3%> <%=reso4%> <%=reso5%> <%=reso6%>
												</span>
											</td>
										</tr>
                    					<tr align="center">
					    					<td colspan="5">
						    					<table border="0" CELLSPACING="0" CELLPADDING="0" align="center" width="70%">
						    						<tr>
								    					<td colspan="2" align="center">
									    					<span class="textoG">FORMA 63A NO.: <%=arrDescripTemp(1)%>&nbsp;</span>
									    					<span class="textoG">&nbsp;No.:<%=arrDescripTemp(2)%>&nbsp;</span>
								    					</td>
							    					</tr>
						   						 </table>
					  	 			 		</td>
				   	 					</tr>

										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">PAGO DE SERVICIO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG">ANTECEDENTES POLICIALES<br></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
										<tr> 
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">BOLETA:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=strSecuencial%><br></span></td>
											<td>&nbsp;</td>
										</tr>	
										
										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">REFERENCIA:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(3)%><br></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. AUTORIZACION:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=arrDescripTemp(0)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
											<td>&nbsp;</td>
												<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=strFecha &" "& strHora%></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>						
										<tr>
											<td>&nbsp;</td>
											<td align= center colspan="3">
												<span class="textoG">
												<br>
											F: _________________________________<br>
												(Recib&iacute; Conforme)
												</span>
											</td>
											<td>&nbsp;</td>
										</tr>										
									</table>				
								</td>
							</tr>
					<%case 18160 'Servicios de extranjeria
					arrDescripTemp = split(strDescrip,"|")%>
							<tr>
								<td width="600">
									<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago Servicios </font></div>
								</td>
							</tr>		
							<tr>
								<td width="600">
									<table border="0" CELLSPACING="0" CELLPADDING="0" align="center">
										<tr>
											<td align= center colspan="5">
												<span class="textoG"><%=reso1%> <%=reso2%> <%=reso3%> <%=reso4%> <%=reso5%> <%=reso6%>
												</span>
											</td>
										</tr>
                    					
										<tr>
											<td align= center colspan="5">
												<span class="textoG">IGM - EXTRANJERIA - <%=R1%> - <%=LimpiarString(arrDescripTemp(5))%>
												</span>
											</td>
										</tr>
										<tr>
											<td align= center colspan="5">
												<span class="textoG">CORRELATIVO CGC No.: <%=LimpiarString(arrDescripTemp(4))%> Boleta: <%=LimpiarString(strSecuencial)%>
												</span>
											</td>
										</tr>
											<tr align="center">
												<td colspan="5">&nbsp;</td>
											</tr>
									
										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Orden de pago:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=R3%><br></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
										
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Pasaporte:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=ref2%>&nbsp;</span></td>
											<td>&nbsp;</td>
										</tr>
											<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Nombres:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=R2%>&nbsp;</span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
						
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Total en $:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%= FormatNumber(arrDescripTemp(1),2)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
						
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Tasa:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%= FormatNumber(arrDescripTemp(2),2)%><br></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Total Q.:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG">Q. <%= FormatNumber(strMonto,2)%></span></td>
											<td>&nbsp;</td>
										</tr>
									
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FORMA DE PAGO</span></td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
				
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Efectivo:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG">Q. <%= FormatNumber(strMonto,2)%></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CH/Propio:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"> Q. 0.00</span></td>
											<td>&nbsp;</td>
										</tr>	
										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Total pagado:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG">Q. <%= FormatNumber(strMonto,2)%></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>	
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">ORIGINAL:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG">USUARIO</span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">DUPLICADO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG">UNIDAD DE ARCHIVO IGM</span></td>
											<td>&nbsp;</td>
										</tr>							
										<tr>
											<td>&nbsp;</td>
											<td align= center colspan="3">
												<span class="textoG">
												<br>
											F: _________________________________<br>
												(Recib&iacute; Conforme)
												</span>
											</td>
											<td>&nbsp;</td>
										</tr>										
									</table>				
								</td>
							</tr>
					<%case 18161 'Pago Pasaportes
						arrDescripTemp = split(strDescrip,"|")%>
							<tr>
								<td width="600">
									<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago Servicios - Pasaportes </font></div>
								</td>
							</tr>		
							<tr>
								<td width="600">
									<table border="0" CELLSPACING="0" CELLPADDING="0" align="center">
										<tr>
											<td align= center colspan="5">
												<span class="textoG"><%=reso1%> <%=reso2%> <%=reso3%> <%=reso4%> <%=reso5%> <%=reso6%>
												</span>
											</td>
										</tr>
                    					
						
										<tr>
											<td align= center colspan="5">
												<span class="textoG">COBRO IGM - PASAPORTES - <%=R1%> - <%=arrDescripTemp(4)%>
												</span>
											</td>
										</tr>
										<tr>
											<td align= center colspan="5">
												<span class="textoG">CORRELATIVO CGC No.: <%=arrDescripTemp(3)%> Boleta: <%=strSecuencial%>
												</span>
											</td>
										</tr>
										<tr align="center">
											<td colspan="5">&nbsp;</td>
										</tr>
									
										
										<tr> 
											
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Tipo Pasaporte:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=ref2 & " - "& ref3%><br></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
										
										<tr>
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Boleta Identificaci&oacute;n:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=R4%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Nombres:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=R2%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Apellido:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%=R3%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Monto en $:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%= FormatNumber(arrDescripTemp(0),2)%><br></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Tasa:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"><%= FormatNumber(arrDescripTemp(1),2)%><br></span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
									
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Total Q:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"> <%= FormatNumber(strMonto,2)%></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FORMA DE PAGO</span></td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
											<td>&nbsp;</td>
										</tr>
									
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Efectivo:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG">Q. <%= FormatNumber(strMonto,2)%></span></td>
											<td>&nbsp;</td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CH/Propio:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG"> Q. 0.00</span></td>
											<td>&nbsp;</td>
										</tr>	
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Total pagado:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG">Q. <%= FormatNumber(strMonto,2)%></span></td>
											<td>&nbsp;</td>
										</tr>	
										<tr>
											<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">ORIGINAL:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG">USUARIO</span></td>
											<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										</tr>
										<tr>
											<td>&nbsp;</td>
											<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">DUPLICADO:</span></td>
											<td>&nbsp;</td>
											<td><span class="textoG">UNIDAD DE ARCHIVO IGM</span></td>
											<td>&nbsp;</td>
										</tr>									
										<tr>
											<td>&nbsp;</td>
											<td align= center colspan="3">
												<span class="textoG">
												<br>
											F: _________________________________<br>
												(Recib&iacute; Conforme)
												</span>
											</td>
											<td>&nbsp;</td>
										</tr>										
									</table>				
								</td>
							</tr>
							<%case 18162 'Pago Tramites Licencias
							Dim tipoTramiteN
							arrDescripTemp = split(strDescrip,"|")
							If arrDescripTemp(0) = "RENV" Then
								tipoTramiteN = "RENOVACION"
							elseif arrDescripTemp(0) = "REPN" Then
								tipoTramiteN = "REPOSICION NORMAL"
							elseif arrDescripTemp(0) = "REPT" Then
								tipoTramiteN = "REPOSICION POR TRANSFERENCIA"
							End if
							%>
								<tr>
									<td width="600">
										<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">TR&Aacute;MITE DE LICENCIAS </font></div>
									</td>
								</tr>		
								<tr>
								<td width="600">
									<table border="0" CELLSPACING="0" CELLPADDING="0" align="center" style="width: 95%; border-collapse: collapse; line-height: 1;">
								
											<tr>
												<td align= center colspan="5">
													<span class="textoG">FORMA 63-A NO. <%=ref2%>&nbsp;DV&nbsp;<%=R3%>&nbsp;<%=R4%></span>
						
												</td>
											</tr>
											
											<tr> 
												
												<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
												<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Tramite:</span></td>
												<td>&nbsp;</td>
												<td><span class="textoG"><%=tipoTramiteN%><br></span></td>
												<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											</tr>
											
											<tr>
												
												<td>&nbsp;</td>
												<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Tipo de licencia:</span></td>
												<td>&nbsp;</td>
												<td><span class="textoG"><%=arrDescripTemp(1)%><br></span></td>
												<td>&nbsp;</td>
											</tr>
											<tr>
												
												<td>&nbsp;</td>
												<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Licencia:</span></td>
												<td>&nbsp;</td>
												<td><span class="textoG"><%=arrDescripTemp(2)%><br></span></td>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
												<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">DPI:</span></td>
												<td>&nbsp;</td>
												<td><span class="textoG"><%=arrDescripTemp(3)%><br></span></td>
												<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											</tr>
											<tr>
												<td>&nbsp;</td>
												<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha de vencimiento:</span></td>
												<td>&nbsp;</td>
												<td><span class="textoG"><%=arrDescripTemp(4)%><br></span></td>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td>&nbsp;</td> 	
												<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Nombres y apellidos:</span></td>
												<td>&nbsp;</td>
												<td><span class="textoG"><%=R2%><br></span></td>
												<td>&nbsp;</td>
											</tr>
											<% if arrDescripTemp(6) <> "0" then%>
											<tr> 	
												<td>&nbsp;</td>
												<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">A&ntilde;os a pagar:</span></td>
												<td>&nbsp;</td>
												<td><span class="textoG"><%=arrDescripTemp(6)%> A&Ntilde;OS<br></span></td>
												<td>&nbsp;</td>
											</tr>
											<%end if%>
											<tr>
												<td>&nbsp;</td>
												<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Monto a pagar:</span></td>
												<td>&nbsp;</td>
												<td><span class="textoG">Q<%= FormatNumber(strMonto,2)%><br></span></td>
												<td>&nbsp;</td>
											</tr>
										
											<tr>
												<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
												<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Referencia:</span></td>
												<td>&nbsp;</td>
												<td><span class="textoG"><%=ref3%></span></td>
												<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
											</tr>
											<tr>
												<td>&nbsp;</td>
												<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Boleta:</span></td>
												<td>&nbsp;</td>
												<td><span class="textoG"><%= strSecuencial%><br></span></td>
												<td>&nbsp;</td>
											</tr>								
											<tr>
												<td>&nbsp;</td>
												<td align= center colspan="3">
													<span class="textoG">
													<br>
												F: _________________________________<br>
													<br>
													(Recib&iacute; Conforme)
													<br>
													</span>
												</td>
												<td>&nbsp;</td>
											</tr>	
											<tr>
												<td align= center colspan="5">
													<span class="textoImpresionP">VALIDE LOS DATOS DE SU TRANSACCI&Oacute;N</span>
												</td>					
											</tr>									
				
									</td>
								</tr>
								<%case 18163 'Pago Multas Tramites Licencias
								arrDescripTemp = split(strDescrip,"|")%>
									<tr>
										<td width="600">
											<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000"> MULTAS DE TR&Aacute;MITE DE LICENCIAS </font></div>
										</td>
									</tr>		
									<tr>
										<td width="600">
											<table border="0" CELLSPACING="0" CELLPADDING="0" align="center">
												<tr>
													
													<td align= center colspan="5">
														<span class="textoG">FORMA 63-A NO. <%=arrDescripTemp(5)%>&nbsp;DV&nbsp;<%=arrDescripTemp(6)%>&nbsp;<%=ref2%></span>
													</td>
												</tr>
												<tr> 
													
													<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Tipo de licencia:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG"><%=arrDescripTemp(2)%><br></span></td>
													<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
												</tr>
			
												<tr>
													
													<td>&nbsp;</td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Licencia:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG"><%= arrDescripTemp(1) %><br></span></td>
													<td>&nbsp;</td>
												</tr>
												<tr>
													
													<td>&nbsp;</td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Dpi:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG"><%=arrDescripTemp(1)%><br></span></td>
													<td>&nbsp;</td>
												</tr>
												<tr>
													<td>&nbsp;</td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha de vencimiento:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG"><%=arrDescripTemp(4)%><br></span></td>
													<td>&nbsp;</td>
												</tr>
												<tr> 	
													<td>&nbsp;</td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Nombres y apellidos:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG"><%=R2%><br></span></td>
													<td>&nbsp;</td>
												</tr>
												
												<tr>
													
													<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Monto a pagar:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG">Q<%= FormatNumber(strMonto,2)%><br></span></td>
													<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
												</tr>
											
												<tr>
													<td>&nbsp;</td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Secuencial:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG"><%=R3%></span></td>
													<td>&nbsp;</td>
												</tr>
												<tr>
													<td>&nbsp;</td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Boleta:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG"><%=strSecuencial%></span></td>
													<td>&nbsp;</td>
												</tr>								
												<tr>
													<td>&nbsp;</td>
													<td align= center colspan="3">
														<span class="textoG">
														<br>
													F: _________________________________<br>
														(Recib&iacute; Conforme)
														</span>
													</td>
													<td>&nbsp;</td>
												</tr>										
														
										</td>
									</tr>
								<%case 18165 'Pago Centros Educativos
								arrDescripTemp = split(strDescrip,"|")%>
									<tr>
										<td width="600">
											<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000"> COBROS CENTROS EDUCATIVOS </font></div>
										</td>
									</tr>		
									<tr>
										<td width="600">
											<table border="0" CELLSPACING="0" CELLPADDING="3" align="center">
												<tr>
													</br>
													<span class="textoG">BANCO DE DESARROLLO RURAL S.A. - CENTROS EDUCATIVOS CXCA - 249 Boleta: <%=arrDescripTemp(0)%>      
														N-ON [QUETZALES] 996   bv1 <%=strFechaR%> <%=esp%> <%=strHoraR%> <%=esp%>   2447866  
													</span>
												</tr>
												<tr>
																		
													<td width=150><p align="left">
														<span class="textoG">
															Centro Educativo: 
														</span>
													</td>
													<td width=250 align="left">
														<span class="textoG">
															<%=R1%> 
														</span>
													</td>
													<td align="right">
														<span class="textoG">Trans: <%=arrDescripTemp(2)%> </span>
													</td>
												</tr>

                								<tr> 
													<td width=150><p align="left">
														<span class="textoG">
															Divisi&oacute;n:
														</span>
													</td>
													<td width=250 align="left">
														<span class="textoG">
															<%=R2%>
														</span>
													</td>
													
												</tr>
                								<tr> 
													<td width=150><p align="left">
														<span class="textoG">
															C&oacute;digo:
														</span>
													</td>
													<td width=250 align="left">
														<span class="textoG">
															<%=ref1%>
														</span>
													</td>
												</tr>
                								<tr> 
													<td width=150><p align="left">
														<span class="textoG">
															Nombre del cliente:
														</span>
													</td>
													<td width=250 align="left">
														<span class="textoG">
															<%=R3%>
														</span>
													</td>
												</tr>
                								<tr> 
													<td width=150><p align="left">
														<span class="textoG">
															Total:
														</span>
													</td>
													<td width=250 align="left">
														<span class="textoG">
															Q. <%= FormatNumber(strMonto,2)%>
														</span>
													</td>
													
												</tr>
								
												<tr>
													<td>&nbsp;</td>
													<td align= center colspan="3">
														<span class="textoG">
														<br>
													F: _________________________________<br>
														(Recib&iacute; Conforme)
														</span>
													</td>
													<td>&nbsp;</td>
												</tr>										
														
										</td>
									</tr>
                                <%case 18166 'Pago Multas PNC
								arrDescripTemp = split(strDescrip,"|")%>
									<tr>
										<td width="600">
											<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000"> MULTAS PNC DEPTO. TRANSITO </font></div>
										</td>
									</tr>		
									<tr>
										<td width="600">
											<table border="0" CELLSPACING="0" CELLPADDING="0" align="center">
												<tr>
													<td align= center colspan="5">
														<span class="textoG">FORMA 63-A NO.<%=arrDescripTemp(2)%>&nbsp;<%=arrDescripTemp(3)%>&nbsp;DV&nbsp;<%=arrDescripTemp(5)%> &nbsp;Boleta:<%=strSecuencial%>&nbsp; <%=arrDescripTemp(4)%>
							                            </span>
													</td>
												</tr>
												<tr> 
													
													<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Tramite:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG">MULTAS PNC<br></span></td>
													<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
												</tr>
			
												<tr>
													
													<td>&nbsp;</td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Años pagados:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG">N/A<br></span></td>
													<td>&nbsp;</td>
												</tr>
												<tr>
													
													<td>&nbsp;</td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Identificacion:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG"><%=ref2%><br></span></td>
													<td>&nbsp;</td>
												</tr>
												<tr>
													<td>&nbsp;</td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Nombre:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG"><%=R2%><br></span></td>
													<td>&nbsp;</td>
												</tr>
												<tr> 	
													<td>&nbsp;</td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NIT:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG"><%=R3%><br></span></td>
													<td>&nbsp;</td>
												</tr>
												
												<tr>
													
													<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. Remisi&oacute;n:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG"><%=arrDescripTemp(1)%><%=arrDescripTemp(0)%><br></span></td>
													<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
												</tr>
											
												<tr>
													<td>&nbsp;</td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Monto a pagar:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG">Q<%=FormatNumber(strMonto,2)%></span></td>
													<td>&nbsp;</td>
												</tr>
												<tr>
													<td>&nbsp;</td>
													<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha de Imp:</span></td>
													<td>&nbsp;</td>
													<td><span class="textoG"><%=ref3%></span></td>
													<td>&nbsp;</td>
												</tr>								
												<tr>
													<td>&nbsp;</td>
													<td align= center colspan="3">
														<span class="textoG">
														<br>
													F: _________________________________<br>
														(Recib&iacute; Conforme)
														</span>
													</td>
													<td>&nbsp;</td>
												</tr>										
														
										</td>
									</tr>
					<%case 19501 'BLOQUEO DE TARJETA DE DEBITO
						arrDescripTemp = split(strDescrip,"|")					
					%>
					
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">BLOQUEO TARJETA DE DEBITO</font></div>
						</td>
					</tr>	
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="2" CELLPADDING="2" align="center">
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOMBRE DE LA CUENTA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(0)%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NO. DE TARJETA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=ofuscaCuenta(arrDescripTemp(2))%></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">ACCI&Oacute;N:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG">BLOQUEO</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CAUSA BLOQUEO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(1)%>&nbsp;</span></td>
									<td align="right">&nbsp;</strong></td>
								</tr>
								<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
									<tr>
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
								<%End if%>
								<tr>
									<td align="left">&nbsp;</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">SECUENCIAL:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strSecuencial%>&nbsp;</span></td>
									<td align="right">&nbsp;</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%= strFecha &" "& strHora %></span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td align= center colspan="5">
										<span class="textoG">
										<br>
										<br>
										F: ___________________________________________<br>
										(Recib&iacute; Conforme)
										<br>
										</span>
									</td>																
								</tr>									
								<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
									<tr>
										<td colspan="6" >
											<div align="center">
												<span class="textoG"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br><br><br>
											</div>
										</td>		
									</tr>																
								<%End if%>
						</td>
					</tr>
					<%case 19502 'SOLICITUD DE TARJETA DE DEBITO
						arrDescripTemp = split(strDescrip,"|")
						
						if InStr(arrDescripTemp(2), "@") = 0 then
							medioEnvioOfuscado=ofuscaTelefono(arrDescripTemp(2))
						else
							medioEnvioOfuscado=ofuscaCorreo(arrDescripTemp(2))
						end if
					%>
					
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">SOLICITUD TARJETA DE DEBITO</font></div>
						</td>
					</tr>	
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="1" CELLPADDING="2" align="center">
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOMBRE DE TARJETA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(0)%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NUMERO DE CUENTA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=ofuscaCuenta(arrDescripTemp(3))%></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">AGENCIA DE ENTREGA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(1)%></span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">ENVIADO A:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=medioEnvioOfuscado%></span></td>
									<td align="right">&nbsp;</strong></td>
								</tr>
								<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
									<tr>
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
								<%End if%>
								<tr>
									<td align="left">&nbsp;</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">SECUENCIAL:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strSecuencial%>&nbsp;</span></td>
									<td align="right">&nbsp;</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%= strFecha &" "& strHora %></span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td align= center colspan="5">
										<span class="textoG">
										<br>
										<br>
										F: ___________________________________________<br>
										(Recib&iacute; Conforme)
										<br>
										</span>
									</td>																
								</tr>
								<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
									<tr>
										<td colspan="6" >
											<div align="center">
												<span class="textoG"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br><br><br>
											</div>
										</td>		
									</tr>																
								<%End if%>
								<tr>
				                    <td colspan="5" >
				                        <br><span class="textoG"> <b>IMPORTANTE</b> BANRURAL por este medio autoriza la adhesi&oacute;n de la PRESTACI&Oacute;N DE SERVICIOS BANCARIOS PARA USO DE FONDOS A TRAV&Eacute;S DE TARJETA DE D&Eacute;BITO formalizada en este contrato enviado por correo electr&oacute;nico, el CLIENTE acepta los t&eacute;rminos y condiciones de uso. 
				                        </span><br>
				                    </td>						
				                </tr>																	
						</td>
					</tr>
					<%case 19503 'REPOSICION DE TARJETA DE DEBITO
					
					arrDescripTemp = split(strDescrip,"|")

					if InStr(arrDescripTemp(2), "@") = 0 then
						medioEnvioOfuscado=ofuscaTelefono(arrDescripTemp(2))
					else
						medioEnvioOfuscado=ofuscaCorreo(arrDescripTemp(2))
					end if
					%>
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REPOSICION TARJETA DE DEBITO</font></div>
						</td>
					</tr>	
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="1" CELLPADDING="2" align="center">
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NOMBRE DE TARJETA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(0)%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NUMERO DE CUENTA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=ofuscaCuenta(arrDescripTemp(3))%></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">AGENCIA DE ENTREGA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(1)%></span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">ENVIADO A:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=medioEnvioOfuscado%>&nbsp;</span></td>
									<td align="right">&nbsp;</strong></td>
								</tr>
								<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
									<tr>
										<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
								<%End if%>
								<tr>
									<td align="left">&nbsp;</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">SECUENCIAL:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strSecuencial%>&nbsp;</span></td>
									<td align="right">&nbsp;</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%= strFecha &" "& strHora %></span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td align= center colspan="5">
										<span class="textoG">
										<br>
										<br>
										F: ___________________________________________<br>
										(Recib&iacute; Conforme)
										<br>
										</span>
									</td>																
								</tr>
								<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
									<tr>
										<td colspan="6" >
											<div align="center">
												<span class="textoG"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br><br><br>
											</div>
										</td>		
									</tr>																
								<%End if%>
								<tr>
					                    <td colspan="6" >
					                        <span class="textoG"> <b>IMPORTANTE</b> BANRURAL por este medio autoriza la adhesi&oacute;n de la PRESTACI&Oacute;N DE SERVICIOS BANCARIOS PARA USO DE FONDOS A TRAV&Eacute;S DE TARJETA DE D&Eacute;BITO formalizada en este contrato enviado por correo electr&oacute;nico, el CLIENTE acepta los t&eacute;rminos y condiciones de uso.<br>
                                                    <b>IMPORTANTE</b> La reposici&oacute;n por robo, extrav&iacute;o o deterioro tiene un costo de <b>Q.50.00<b> que se debitar&aacute; autom&aacute;ticamente de la cuenta asociada. 
                            				</span>
					                    </td>						
					                </tr>																		
						</td>
					</tr>
					<%case 19504 'CANCELACION DE TARJETA DE DEBITO					
					    arrDescripTemp = split(strDescrip,"|")
						Dim lenTarjetacancelada
						Dim tarjetaFincancelada
						Dim icancelar
						Dim tarjetaOfuscadacancelada
						lenTarjetacancelada = (len(arrDescripTemp(1))+1) - 4
						tarjetaFincancelada = mid(arrDescripTemp(1), lenTarjetacancelada, 4)
						For icancelar = 0 to (lenTarjetacancelada - 1)
							tarjetaOfuscadacancelada = tarjetaOfuscadacancelada + "X"
						Next
						tarjetaOfuscadacancelada = tarjetaOfuscadacancelada + tarjetaFincancelada
					%>
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">CANCELACI&Oacute;N TARJETA DE D&Eacute;BITO</font></div>
						</td>
					</tr>	
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="5.5" CELLPADDING="5.5" align="center">
							
								<tr>
									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
																							  
						
																	  
																			   
			 
			
						
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CLIENTE:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(0)%></span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">TARJETA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=tarjetaOfuscadacancelada%></span></td>
									<td align="right">&nbsp;</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MOTIVO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(2)%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
									<tr>
										<td align="left">&nbsp;</strong></td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"><%= "Q" & FormatNumber(strMonto)%>&nbsp;</span></td>
										<td align="right">&nbsp;</strong></td>
									</tr>
								<%End if%>
								<tr>
									<td align="left">&nbsp;</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">SECUENCIAL:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strSecuencial%>&nbsp;</span></td>
									<td align="right">&nbsp;</strong></td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%= strFecha &" "& strHora %></span></td>
									
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td align= center colspan="5">
										<span class="textoG">
										<br>
										<br>
										F: ___________________________________________<br>
										(Recib&iacute; Conforme)
										<br>
										</span>
									</td>																
								</tr>
								<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
									<tr>
										<td colspan="6" >
											<div align="center">
												<span class="textoG"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
											</div>
										</td>		
									</tr>																
								<%End if%>
			
						</td>
					</tr>
					<%case 19701 'DINERO AL CHILAZO
						Dim cuentaAfiliadaDinero
						Dim lenCuentaAfiDinero
						Dim cuentaFinAfiDinero
						Dim iAfiDinero
						Dim cuentaOfusAfiDinero
					    arrDescripTemp = split(strDescrip,"|")
					    medioEnvioOfuscado=ofuscaTelefono(arrDescripTemp(1))
						
						cuentaAfiliadaDinero = trim(arrDescripTemp(3))
						lenCuentaAfiDinero = len(cuentaAfiliadaDinero) - 4
						cuentaFinAfiDinero = mid(cuentaAfiliadaDinero, lenCuentaAfiDinero+1, 4)

						For iAfiDinero = 0 to (lenCuentaAfiDinero - 1)
							cuentaOfusAfiDinero = cuentaOfusAfiDinero + "X"
						Next	
						cuentaOfusAfiDinero = cuentaOfusAfiDinero + cuentaFinAfiDinero
					%>
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">DINERO AL CHILAZO</font></div>
						</td>
					</tr>	
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="4" CELLPADDING="2" align="center">
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. DE CUENTA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG">GTQ/<%=cuentaOfusAfiDinero%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CLIENTE: </span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(0)%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO: </span></td>
									<td>&nbsp;</td>
									<td><span class="textoG">Q.<%=arrDescripTemp(2)%>&nbsp;</span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<%
								If strMonto <> 0 Then
								%>
                                <tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">COMISI&Oacute;N: </span></td>
									<td>&nbsp;</td>
									<td><span class="textoG">Q.<%=strMonto%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
                                    <td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="left">&nbsp;</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">SECUENCIAL:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%=strSecuencial%></span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">N&Uacute;MERO DE TEL&Eacute;FONO: </span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=medioEnvioOfuscado%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
                                    <td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="left">&nbsp;</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%= strFecha &" "& strHora %></span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<%
								Else
								%>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">SECUENCIAL: </span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strSecuencial%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
                                    <td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="left">&nbsp;</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">N&Uacute;MERO DE TEL&Eacute;FONO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%=medioEnvioOfuscado%></span></td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA: </span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%= strFecha &" "& strHora %>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<%
								End if
								%>
								<tr>
								
									
									<td align= center colspan="6">
										<span class="textoG">
										<br>
										<br>
										F: ___________________________________________<br>
										(Recib&iacute; Conforme)
										<br>
										</span>
									</td>																
								</tr>
								<tr>
							    <td colspan="6" >
									<div align="center">
			                        	<span class="textoG"><br><br> <strong>IMPORTANTE <br> El cliente acepta t&eacute;rminos y condiciones del servicio. <br> Amigo Banrural, el monto retirado y la comisi&oacute;n ser&aacute;n debitados de tu pr&oacute;ximo pago.</strong></span><br>
			                    	</div>
								</td>
								</tr>
								
																										
						</td>
					</tr>
					<%case 19652 'CONSULTA SALDO NOTIFICACIONES MOVILES
					    arrDescripTemp = split(strDescrip,"|")
					    medioEnvioOfuscado=ofuscaTelefono(arrDescripTemp(1))
					%>
					<tr>
						<td width="600">
							&nbsp;
						</td>
					</tr>	
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">CONSULTA DE SALDO</font></div>
						</td>
					</tr>	
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="3" CELLPADDING="2" align="center">
								<tr>
									<td align="left">&nbsp;</td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CLIENTE: </span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=arrDescripTemp(0)%>&nbsp;</span></td>
									<td align="right">&nbsp;</td>
								</tr>
								<tr>
                                	<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
                                <tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CUENTA: </span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=ofuscaCuenta(arrDescripTemp(2))%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
                                	<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
                                	<td>&nbsp;</td>
									<td align="left">&nbsp;</strong></td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">NUMERO DE TELEFONO: </span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=medioEnvioOfuscado%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
                                	<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
									<tr>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"> <%=  "Q" & FormatNumber(strMonto) %></span></td>
										<td>&nbsp;</td>
									</tr>
									<tr>
	                                	<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
								<%End if%>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%= strFecha &" "& strHora %></span></td>
									<td>&nbsp;</td>
								</tr>
								<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
									<tr>
	                                	<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
								<% else %>
									<tr>
	                                		<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
									<tr>
										<td colspan="6" >
											<div align="center">
												<span class="textoG"><br> Cliente amigo, esta transaccion no tiene ning&uacute;n costo </span><br>
											</div>
										</td>
									</tr>
									<tr>
	                                	<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									</tr>
								<%End if%>
						</td>
					</tr>
				<%case 19653 'AFILIACION NOTIFICACIONES MOVILES
						Dim correoAfiliacion
						Dim telefonoAfiliado
						Dim telOfusAfi
						Dim strCuentasAfi
						Dim c

						arrDescripTemp = split(strDescrip,"|")
						For Each c In arrDescripTemp
							strCuentasAfi = strCuentasAfi + ofuscaCuenta(c) + "<br>"
						Next

						correoAfiliacion= ofuscaCorreo(R2)

						telefonoAfiliado = ofuscaTelefono(trim(ref1))
					%>
					<tr>
						<td width="600">
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">AFILIACI&Oacute;N DE NOTIFICACIONES M&Oacute;VILES</font></div>
						</td>
					</tr>	
					<tr>
						<td width="600">
							<table border="0" CELLSPACING="2" CELLPADDING="2" align="center">
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CLIENTE: </span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=R1%>&nbsp;</span></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr>
                                	<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">N&Uacute;MERO(S) DE CUENTAS(S): </span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strCuentasAfi%>&nbsp;</span></td>
									<td>&nbsp;</td>
									
								</tr>
								<tr>
                                	<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">N&Uacute;MERO DE TEL&Eacute;FONO: </span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=telefonoAfiliado%>&nbsp;</span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CORREO ELECTR&Oacute;NICO:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=correoAfiliacion%>&nbsp;</span></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<% if strMonto <> "0" and strMonto <> "0.00"  and strMonto <> "0.0000" Then %>
									<tr>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
										<td>&nbsp;</td>
										<td><span class="textoG"> <%=  "Q" & FormatNumber(strMonto) %></span></td>
										<td>&nbsp;</td>
									</tr>
								<%End if%>
								<tr>
																			  
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">FECHA:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"> <%= strFecha &" "& strHora %></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">SECUENCIAL:</span></td>
									<td>&nbsp;</td>
									<td><span class="textoG"><%=strSecuencial%></span></td>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td align= center colspan="6">
										<span class="textoG">
										<br>
										F: ___________________________________________<br>
										(Recib&iacute; Conforme)
										<br>
										</span>
									</td>																
								</tr>
								<% if strMonto = "0" or strMonto = "0.00"  or strMonto = "0.0000" Then %>
									<tr>
										<td align= center colspan="6">
											<span class="textoG"> 
												Cliente amigo esta transacci&oacute;n no tiene ning&uacute;n costo.
											</span>
										</td>					
									</tr>	
								<%End if%> 	
									<tr>
										<td colspan="6" >
											<div align="center">
												<span class="textoG">
													Cliente amigo las tarifas de notificaciones m&oacute;viles a partir del tercer mes ser&aacute;:
												</span><br>
												<span class="textoG">
													De 01 a 60 Q.5.00, de 61 a 500 Q.10.00 y de 501 en adelante Q.10cts por mensaje.
												</span>
											</div>
										</td>
									</tr>
						</td>
					</tr>
					<%case 19305, 19306 'VIVO SEGURA
					    arrDescripTemp = split(strDescrip,"|")				    
					%>
					
					<tr>
						<td>
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REIMPRESI&Oacute;N DE P&Oacute;LIZA DE VIVO SEGURA</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600" bgcolor="#FFFFFF" >
						<br>
							<table border="0" CELLSPACING="0" CELLPADDING="1" align="center" width="100%">
								<tr> 
									<td align="center" class="TextoG" colspan="5">DATOS DE LA POLIZA</td>
								</tr>
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Numero:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strCuenta%></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Forma de pago:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(0)%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Plan contratado:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(1)%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Fecha de emision:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG">&nbsp;</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG">&nbsp;</td>
									<td></td>
								</tr>					
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="center" class="TextoG" colspan="3">DATOS DEL CLIENTE</td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Nombre:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(2)%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Cuenta:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(3)%></td>
									<td></td>
								</tr>							
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Boleta:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strSecuencial%></td>
									<td></td>
									</td>
								</tr>									
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Fecha:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></td>
									<td></td>
								</tr>												
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Total a Pagar:</b></td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG" ><%= "Q" & FormatNumber(strMonto)%>&nbsp;</td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="2"><br><br></td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5">F:____________________</td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5">(Recib&iacute; Conforme)</td>
																</tr> 
								<tr>
									<td align="center" class="TextoG" colspan="4">
										<br>							
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<%case 19307, 19308, 19309, 19310 'VIVO SALUDABLE
					    arrDescripTemp = split(strDescrip,"|")				    
					%>
					
					<tr>
						<td>
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REIMPRESI&Oacute;N DE P&Oacute;LIZA DE VIVO SALUDABLE</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600" bgcolor="#FFFFFF" >
						<br>
							<table border="0" CELLSPACING="0" CELLPADDING="1" align="center" width="100%">
								<tr> 
									<td align="center" class="TextoG" colspan="5">DATOS DE LA POLIZA</td>
								</tr>
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Numero:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strCuenta%></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Forma de pago:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(0)%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Plan contratado:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(1)%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Fecha de emision:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG">&nbsp;</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG">&nbsp;</td>
									<td></td>
								</tr>					
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="center" class="TextoG" colspan="3">DATOS DEL CLIENTE</td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Nombre:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(2)%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Cuenta:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(3)%></td>
									<td></td>
								</tr>							
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Boleta:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strSecuencial%></td>
									<td></td>
									</td>
								</tr>									
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Fecha:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></td>
									<td></td>
								</tr>												
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Total a Pagar:</b></td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG" ><%= "Q" & FormatNumber(strMonto)%>&nbsp;</td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="2"><br><br></td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5">F:____________________</td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5">(Recib&iacute; Conforme)</td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="4">
										<br>							
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<%case 19311, 19312, 19313, 19314 'VIVO INTEGRAL
					    arrDescripTemp = split(strDescrip,"|")				    
					%>
					
					<tr>
						<td>
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REIMPRESI&Oacute;N DE P&Oacute;LIZA DE VIVO INTEGRAL</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600" bgcolor="#FFFFFF" >
						<br>
							<table border="0" CELLSPACING="0" CELLPADDING="1" align="center" width="100%">
								<tr> 
									<td align="center" class="TextoG" colspan="5">DATOS DE LA POLIZA</td>
								</tr>
								<tr> 									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Numero:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strCuenta%></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr> 
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Forma de pago:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(0)%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Plan contratado:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(1)%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Fecha de emision:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG">&nbsp;</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG">&nbsp;</td>
									<td></td>
								</tr>					
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="center" class="TextoG" colspan="3">DATOS DEL CLIENTE</td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Nombre:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(2)%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Cuenta:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(3)%></td>
									<td></td>
								</tr>															
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Boleta:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strSecuencial%></td>
									<td></td>
								</td>
								</tr>									
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Fecha:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></td>
									<td></td>
								</tr>												
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Total a Pagar:</b></td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG" ><%= "Q" & FormatNumber(strMonto)%>&nbsp;</td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="2"><br><br></td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5">F:____________________</td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5">(Recib&iacute; Conforme)</td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="4">
										<br>							
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<%case 19315, 19316, 19317, 19318 'ACCIDENTES PERSONALES
					    arrDescripTemp = split(strDescrip,"|")				    
					%>
					
					<tr>
						<td>
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REIMPRESI&Oacute;N DE P&Oacute;LIZA DE ACCIDENTES PERSONALES</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600" bgcolor="#FFFFFF" >
						<br>
							<table border="0" CELLSPACING="0" CELLPADDING="1" align="center" width="100%">
								<tr> 
									<td align="center" class="TextoG" colspan="5">DATOS DE LA POLIZA</td>
								</tr>
								<tr> 									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Numero:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strCuenta%></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Forma de pago:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(0)%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Plan contratado:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(1)%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Fecha de emision:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG">&nbsp;</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG">&nbsp;</td>
									<td></td>
								</tr>					
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="center" class="TextoG" colspan="3">DATOS DEL CLIENTE</td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Nombre:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(2)%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Cuenta:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(3)%></td>
									<td></td>
								</tr>															
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Boleta:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strSecuencial%></td>
									<td></td>
								</td>
								</tr>									
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Fecha:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></td>
									<td></td>
								</tr>												
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Total a Pagar:</b></td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG" ><%= "Q" & FormatNumber(strMonto)%>&nbsp;</td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="2"><br><br></td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5">F:____________________</td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5">(Recib&iacute; Conforme)</td>
								</tr>															
								<tr> 
									<td align="center" class="TextoG" colspan="4">
										<br>							
									</td>
								</tr>
							</table>
						</td>
					</tr>
<%case 19319 'PAGOS PENDIENTES
					    arrDescripTemp = split(strDescrip,"|")				    
					%>
					
					<tr>
						<td>
							<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">REIMPRESI&Oacute;N DE P&Oacute;LIZA DE PAGOS PENDIENTES</font></div>
						</td>
					</tr>		
					<tr>
						<td width="600" bgcolor="#FFFFFF" >
						<br>
							<table border="0" CELLSPACING="0" CELLPADDING="1" align="center" width="100%">
								<tr> 
									<td align="center" class="TextoG" colspan="5">DATOS DE LA POLIZA</td>
								</tr>
								<tr> 									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Numero:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(0)%></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>								
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Fecha de emision:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha%></td>
									<td></td>
								</tr>
								<tr> 
									<td></td>
									<td align="right" class="TextoG">&nbsp;</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG">&nbsp;</td>
									<td></td>
								</tr>					
								<tr> 		
									<td></td>							
									<td align="center" class="TextoG" colspan="3">DATOS DEL CLIENTE</td>									
									<td></td>
								</tr>
								<tr> 									
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Nombre:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=arrDescripTemp(1)%></td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>																
								<%										
								If Trim(arrDescripTemp(4)) <> "C" Then
								%>
								<tr>
									<td></td> 
									<td align="right" class="TextoG">Cuenta:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strCuenta%></td>
									<td></td>
								</tr>
								<%
								End If
								%>
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Boleta:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strSecuencial%></td>
									<td></td>
								</td>
								</tr>									
								<tr> 
									<td></td>
									<td align="right" class="TextoG" >Fecha:</td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG"><%=strFecha & " " & strHora%></td>
									<td></td>
								</tr>												
								<tr> 
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
									<td align="right" class="TextoG" >Total a Pagar:</b></td>
									<td class="textoG" width="10%">&nbsp;</td>
									<td align="left" class="TextoG" ><%= "Q" & FormatNumber(strMonto)%>&nbsp;</td>
									<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="2"><br><br></td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5">F:____________________</td>
								</tr>
								<tr> 
									<td align="center" class="TextoG" colspan="5">(Recib&iacute; Conforme)</td>
								</tr>															
								<tr> 
									<td align="center" class="TextoG" colspan="4">
										<br>							
									</td>
								</tr>
							</table>
						</td>
					</tr>
				<% End Select %>
					<%
					arrayFecha= split(strFecha, " ")
					arrayF= split(arrayFecha(0), "/")
					Dim strFechaFormated
					strFechaFormated = arrayF(1)&"/"&arrayF(0)&"/"&arrayF(2)
				
					%>
				<table border="0" width=600 CELLSPACING="0" CELLPADDING="2" align="center" id="<%= id%>_info">
					<tr>
						<td align="center" colspan="3">
							<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.</font>
						</td>
					</tr>	
					
					<% if cod_trans = 18001 and VLTipoCliente = "B" then%>
						<tr>
							<td align="center" colspan="3">
								<font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">FAVOR ACERCARSE A LA AGENCIA MAS CERCANA PARA COMPLETAR SU EXPEDIENTE CON DOCUMENTO DE IDENTIFICACION Y RECIBO DE SERVICIOS OPCIONAL.</font>
							</td>
						</tr>
					<% 	end if %>
					<tr>
						<td><span class="textoG">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>
						<td align="right"><span class="textoG">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>
					</tr>
					<% if cod_trans = 18167 then%>
						<tr>
							<td align= center colspan="4">
								<span class="textoG">
									<br>
									<%=ref1%>, <%=R2%>
								</span><br>
					
							</td>
						</tr>
					<% 	end if %>
					<tr>
						<td align= center colspan="3"><span class="textoG">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%></span></td>
					</tr>
					
					<% if cod_trans = 18162 then%>
					<%
						Dim leyendaLic
						leyendaLic = "N-ON [QUETZALES] " + R1 + " "+ ref3 
					%>
						<tr>
							<td align= center colspan="4">
								<span class="textoG"><%=server.htmlEncode(reso1)%> <%=server.htmlEncode(reso2)%> <%=server.htmlEncode(reso3)%> <%=server.htmlEncode(reso4)%>  <%=server.htmlEncode(reso5)%> <%=server.htmlEncode(reso6)%><br></span>
								<br> 
                                <span class="textoG">BANCO DE DESARROLLO RURAL S.A. - COBRO DEPTO. TRANSITO - LICENCIAS - 339 </span>
								<br>
                                <span class="textoG"><%=leyendaLic%></span>
								<br>
								<span class="textoG">ESTE DOCUMENTO TIENE VIGENCIA DE 30 D&Iacute;AS</span>
							</td>
						</tr>
					<% 	end if %>		
					<% if cod_trans = 18163 then%>
					<%
						Dim leyenda
						leyenda = "N-ON [QUETZALES] " +R1 + " " + R3
					%>
						<tr>
							<td align= center colspan="4">
								<span class="textoG"><%=server.htmlEncode(reso1)%> <%=server.htmlEncode(reso2)%> <%=server.htmlEncode(reso3)%> <%=server.htmlEncode(reso4)%>  <%=server.htmlEncode(reso5)%> <%=server.htmlEncode(reso6)%><br></span>
								<br> 
                                <span class="textoG">BANCO DE DESARROLLO RURAL S.A. - COBRO DEPTO. TRANSITO - MULTAS - 348 </span>
								<br> 
                                <span class="textoG"><%=leyenda%></span>
								<br>
								<span class="textoG">ESTE DOCUMENTO TIENE VIGENCIA DE 30 D&Iacute;AS</span>
							</td>
						</tr>
					<% 	end if %>
                    <% if cod_trans = 18166 then%>
					<%
						
						leyenda = "N-ON [QUETZALES] " + + R1 + " " + arrDescripTemp(6) 
					%>
						<tr>
							<td align= center colspan="4">
								<span class="textoG"><%=reso1%> <%=reso2%> <%=reso3%> <%=reso4%>  <%=reso5%> <%=reso6%><br></span>
								<br> 
                                <span class="textoG">BANCO DE DESARROLLO RURAL S.A. - MULTAS PNC DEPTO. TRANSITO 184  </span>
								<br> 
                                <span class="textoG"><%=leyenda%></span>
								
							</td>
						</tr>
					<% 	end if %>
					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<%
End Sub 'termina PLRecibo - Impresion de boletas en tinta

Sub BoletaComisionTermica(id)
	%>
	<table id="<%=id%>" width="275" border="0" cellspacing="0" cellpadding="0" align="center" style="display:block">
		<tr>
			<td width="275" >
				<table border="0" CELLSPACING="0" CELLPADDING="2" align="center">				
					<tr >
						<td align= center colspan="5">
							<center><img src="../../images/logo_reimpresion.jpg"></center>
						</td>
					</tr> 
					<tr>
						<td align= center colspan="5">
							
							<%  if  cod_trans <> 18166 then%>
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGO DE SERVICIO</font></div>
							<% else%>
								<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">MULTAS PNC DEPTO. TRANSITO</font></div>

							<% end if%>
							<br>
						</td>
					</tr>
					<%  if  cod_trans <> 18102 then%>
						<tr>
							<td width=135><p align="right" class="textoImpresionP" >PAGO DE SERVICIOS:</td>
							<td colspan="4">
								<span class="textoImpresionP">
								<% If cod_trans = 18162 Then
										Dim arrLic, tipoTramiteC
										arrLic = split(arrDatosCom(4).text,"|")
					
										If arrLic(4) = "RENV" Then
											tipoTramiteC = "RENOVACION"
										elseif arrLic(4) = "REPN" Then
											tipoTramiteC = "REPOSICION NORMAL"
										elseif arrLic(4) = "REPT" Then
											tipoTramiteC = "REPOSICION POR TRANSFERENCIA"
										End if
										
									End if 
								%>
								<%Select Case (cod_trans)
								case 18102%>
									CERTIFICADOS RENAP
								<%case 18155%>
									ORGANISMO JUDICIAL
								<%case 18156%>
									ORGANISMO JUDICIAL
								<%case 18157%>
									ORGANISMO JUDICIAL
								<%case 18158%>
									CONTALORIA GENERAL DE CUENTAS
								<%case 18159%>
									POLICIA NACIONAL CIVIL
								<%case 18160%>
									INSTITUTO GUATEMALTECO DE MIGRACI&Oacute;N
								<%case 18161%>
									INSTITUTO GUATEMALTECO DE MIGRACI&Oacute;N
								<%case 18162%>
									<%= tipoTramiteC %>
								<%case 18163%>
									PAGO MULTAS LICENCIAS MAYCOM
								<%case 18166%>
									MULTAS PNC
								<%end select %>
								<br>
								</span>
							</td>
						</tr>
					<% end if%>
					<%  if cod_trans <> 18158  then%>
						<%  if cod_trans <> 18166  then%>
							<tr> 	
								<td width=135 ><p align="right" class="textoImpresionP" >TRAMITE:</span></td>
								<td colspan="4">
									<span class="textoImpresionP">
									<%Select Case (cod_trans)
									case 18155%>
										ANTECEDENTES PENALES
									<%case 18156%>
										DEPOSITO PENSIONES ALIMENTICIAS
									<%case 18157%>
										DEPOSITOS FORMULARIO ELECTRONICO DE INGRESOS (FEI)
									<%case 18102%>
										<%= Trim(arrDatosCom(1).text) %>
									<%case 18159%>
										ANTECEDENTES POLICIALES
									<%case 18160%>
										SERVICIOS DE EXTRANJER&Iacute;A
									<%case 18161%>
										PASAPORTES
									<%case 18162%>
										RENOVACI&Oacute;N DE LICENCIA
                                	<%case 18163%>
										PAGO DE MULTAS DE TR&Aacute;MITE DE LICENCIAS
									<%end select %>
									<br>
									</span>
								</td>
							</tr>
						<%End if%>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >REFERENCIA NO:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%= Trim(arrDatosCom(0).text) %></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >MONTO:</span></td>
						<td colspan="4"><span class="textoImpresionP">Q <%= formatNumber(Trim(arrDatosCom(2).text)) %>&nbsp;</span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >FECHA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %></span></td>
					</tr>
					<% end if%>
					<%  if cod_trans =  18158 then%>
						<tr> 	
							<td width=135 ><p align="right" class="textoImpresionP" >TIPO PAGO:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(0)%>-<%=arrDescripTemp(1)%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >CODIGO PAGO:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%=arrDescripTemp(2)%>-<%=arrDescripTemp(3)%></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >BOLETA:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%= Trim(arrDatosCom(0).text) %></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >MONTO:</span></td>
							<td colspan="4"><span class="textoImpresionP">Q <%= formatNumber(Trim(arrDatosCom(2).text)) %><br></span></td>
						</tr>
						<tr>
							<td width=135 ><p align="right" class="textoImpresionP" >FECHA:</span></td>
							<td colspan="4"><span class="textoImpresionP"><%= strFecha & " "&strHora %><br></span></td>
						</tr>
					<%end if%>
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
				</table>
				<table>

						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>				
			</td>
		</tr>
	</table>
	<%
End Sub 'termina Boleta Comision Termica

'celd2023 metodo para comision cxca boleta terminca 
Sub BoletaComisionTermicaCXCA(id) 
	%>
	<table id="<%=id%>" width="275" border="0" cellspacing="0" cellpadding="0" align="center" style="display:block">
		<tr>
			<td width="275" >
				<table border="0" CELLSPACING="0" CELLPADDING="2" align="center">				
					<tr >
						<td align= center colspan="5">
							<center><img src="../../images/logo_reimpresion.jpg"></center>
						</td>
					</tr> 
					<tr>
						<td align= center colspan="5">
							<div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGOS VARIOS</font></div>
							<br>
						</td>
					</tr>
					<tr>
						<td width=135><p align="right" class="textoImpresionP" >EMPRESA:</td>
						<td colspan="4">
							<span class="textoImpresionP">
							<%= strNombreEmpresa%>
							<br>
							</span>
						</td>
					</tr>					
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >DESCRIPCI&OacuteN:</span></td>
						<td colspan="4">
							<span class="textoImpresionP">
							Comisi&oacuten por servicios bancarios								
							<br>
							</span>
						</td>
					</tr>
					<tr> 	
						<td width=135 ><p align="right" class="textoImpresionP" >BOLETA NO:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%= NoBoletaComisionCXCA %></span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >MONTO:</span></td>
						<td colspan="4"><span class="textoImpresionP">Q <%= formatNumber(MontoComisionCXCA) %>&nbsp;</span></td>
					</tr>
					<tr>
						<td width=135 ><p align="right" class="textoImpresionP" >FECHA:</span></td>
						<td colspan="4"><span class="textoImpresionP"><%= strFechaR & " "&strHora %></span></td>
					</tr>										
						<tr>
							<td align= center colspan="5">
								<span class="textoImpresionP">
								<br>
								<br>
								F: ___________________________________________<br>
								(Recib&iacute; Conforme)
								<br>
								<br>
								</span>
							</td>																
						</tr>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.
							<br>
							<br>
							</span>
							</td>																
						</tr>
					<tr align= center colspan="4">
						<td align="left"><span class="textoImpresionP">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%><br/>Departamento: <%=Session("VG_Departamento")%></span></td>
						<td>&nbsp;</td>	
						<td>&nbsp;</td>					
						<td align="right" ><span class="textoImpresionP">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%><br/>Municipio: <%=Session("VG_Municipio")%></span></td>						
					</tr>
				</table>
				<table>

						<tr>
							<td align= center colspan="4">
								<span class="textoImpresionP">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
								</span>
							</td>					
						</tr>
						<tr>
							<td>&nbsp;</td>
						</tr>
				</table>				
			</td>
		</tr>
	</table>
	<%
End Sub 'termina Boleta Comision Termica CXCA

Sub BoletaComision(id)
	'Call CltaPagoComision()
	%>
	<table id="<%= id %>" width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="display:block">
		<tr>
			<td width="600">
				
				<%  if  cod_trans <> 18166 then%>
					<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Pago Servicios </font></div>
				<% else%>
					<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">MULTAS PNC DEPTO. TRANSITO</font></div>

				<% end if%>
			</td>
		</tr>		
		<tr>
			<td width="100%">
			<br>
				<table border="0" CELLSPACING="0" CELLPADDING="5" align="center">
					<%  if  cod_trans <> 18102 then%>
						<tr>
							<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
							
							<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">PAGO DE SERVICIOS:</span></td>
						
							<td>&nbsp;</td>
							<td>
								<span class="textoG">
								<% If cod_trans = 18162 Then
									Dim arrLicN, tipoTramiteCN
									arrLicN = split(arrDatosCom(4).text,"|")
				
									If arrLicN(4) = "RENV" Then
										tipoTramiteCN = "RENOVACION"
									elseif arrLicN(4) = "REPN" Then
										tipoTramiteCN = "REPOSICION NORMAL"
									elseif arrLicN(4) = "REPT" Then
										tipoTramiteCN = "REPOSICION POR TRANSFERENCIA"
									End if
									
								End if 
								%>
								<%Select Case (cod_trans)
								case 18102%>
									CERTIFICADOS RENAP
								<%case 18155%>
									ORGANISMO JUDICIAL
								<%case 18156%>
									ORGANISMO JUDICIAL
								<%case 18157%>
									ORGANISMO JUDICIAL
								<%case 18158%>
									Certificados CGC
								<%case 18159%>
									POLICIA NACIONAL CIVIL
								<%case 18160%>
									INSTITUTO GUATEMALTECO DE MIGRACI&Oacute;N
								<%case 18161%>
									INSTITUTO GUATEMALTECO DE MIGRACI&Oacute;N
								<%case 18162%>
									<%= tipoTramiteCN %>
								<%case 18163%>
									PAGO MULTAS LICENCIAS MAYCOM
								<%case 18166%>
									MULTAS PNC
								
								<%end select %>
								</span>
							</td>
							<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						</tr>
					<% end if%>					

					<%  if cod_trans <> 18158  then%>
						<%  if cod_trans <> 18166  then%>
							<tr>
								<td align="left">&nbsp;&nbsp;</td>
								<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">TRAMITE:</span></td>
								<td>&nbsp;</td>
								<td>
								<span class="textoG">
									<%Select Case (cod_trans)
									case 18155%>
										ANTECEDENTES PENALES
									<%case 18156%>
										DEPOSITO PENSIONES ALIMENTICIAS
									<%case 18157%>
										DEPOSITO FORMULARIO ELECTRONICO DE INGRESOS (FEI)
									<%case 18102%>
										<%= Trim(arrDatosCom(1).text) %>
									<%case 18159%>
										ANTECEDENTES POLICIALES
									<%case 18160%>
										SERVICIOS DE EXTRANJER&Iacute;A
									<%case 18161%>
										PASAPORTES
									<%case 18162%>
										RENOVACI&Oacute;N DE LICENCIA
									<%case 18163%>
										PAGO DE MULTAS DE TR&Aacute;MITE DE LICENCIAS
									<%end select %>
									<br>
								</span>
								</td>
								<td align="right">&nbsp;&nbsp;</td>
							</tr>			
						<% End if%>
					<tr> 
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">No. Referencia:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%= Trim(arrDatosCom(0).text) %><br></span></td>
						<td>&nbsp;</td>
					</tr>

					<tr>
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">Q <%= formatNumber(Trim(arrDatosCom(2).text)) %><br></span></td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					</tr>

					
					<tr>
						<td align="left">&nbsp;&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%= strFecha & " "&strHora %><br></span></td>
						<td align="right">&nbsp;&nbsp;</td>
					</tr>		
					<% end if%>

					<!-- cche -->
					
					<%  if cod_trans =  18158 then
						
					%>
					<tr>
						<td align="left">&nbsp;&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">TIPO PAGO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(0)%>-<%=arrDescripTemp(1)%><br></span></td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
					<tr> 
                        <td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">CODIGO PAGO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=arrDescripTemp(2)%>-<%=arrDescripTemp(3)%><br></span></td>
						<td>&nbsp;</td>	
					</tr>

					<tr> 
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">BOLETA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%= Trim(arrDatosCom(0).text) %><br></span></td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
					</tr>

					
					<tr>
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">Q <%= formatNumber(Trim(arrDatosCom(2).text)) %><br></span></td>
						<td>&nbsp;</td>
					</tr>

					
					<tr>
						<td align="left">&nbsp;&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%= strFecha & " "&strHora %><br></span></td>
						<td align="right">&nbsp;&nbsp;</td>
					</tr>
					<% end if%>

					<!-- cche -->
							
					<tr>
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td align= center colspan="3">
							<span class="textoG">
							
						<br>F: _________________________________<br>
							(Recib&iacute; Conforme)
							</span>
						</td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>					
					</tr>										
				</table>				
			</td>
		</tr>
		<tr>
			
				<table border="0" width=600 CELLSPACING="0" CELLPADDING="2" align="center" id="<%= id%>_info" style="display:block">
					<tr>
						<td align="center" colspan="3">
							<font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">ESTA ES UNA REIMPRESI&Oacute;N DEL DOCUMENTO ORIGINAL.</font>
						</td>
					</tr>	
					
					<% if cod_trans = 18001 and VLTipoCliente = "B" then%>
						<tr>
							<td align="center" colspan="3">
								<font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">FAVOR ACERCARSE A LA AGENCIA MAS CERCANA PARA COMPLETAR SU EXPEDIENTE CON DOCUMENTO DE IDENTIFICACION Y RECIBO DE SERVICIOS OPCIONAL.</font>
							</td>
						</tr>
					<% 	end if %>
					<tr>
						<td><span class="textoG">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%>
                          
                              <br/>
                           
                            Departamento: <%=Session("VG_Departamento")%>
                          
                            </span></td>

						<td>&nbsp;</td>
						<td align="right"><span class="textoG">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%>
                               <br/>
                           
                            Municipio: <%=Session("VG_Municipio")%>
                          
						     </span></td>
					</tr>
					<tr>
						<td align= center colspan="3"><span class="textoG">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%></span></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
				</table>
		</tr>
	</table>
	<%
End Sub 'termina Boleta comision

Sub BoletaComisionCXCA(id)
	'celd2023 se agrega metodo para imprimir boleta de comision para CXCA (impresion de tinta)
	%>	
	<table id="<%=id%>" width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="display:block">
		<tr>
			<td width="600">
				<div align="center"><font size="3" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">PAGOS VARIOS </font></div>
			</td>
		</tr>		
		<tr>
			<td width="600">
				<br>
				<table border="0" CELLSPACING="0" CELLPADDING="2" align="center">				
					<tr>
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">EMPRESA:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=strNombreEmpresa%><br></span></td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>		
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">DESCRIPCI&OacuteN:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG">Comisi&oacuten por servicios bancarios<br></span></td>
						<td>&nbsp;</td>
					</tr>
                    <tr> 
						<tr> 					
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">BOLETA NO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%=NoBoletaComisionCXCA%><br></span></td>
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>	
					</tr>    			
					<tr>
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">MONTO:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><%= "Q" & FormatNumber(MontoComisionCXCA)%>&nbsp;</span></td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td width=ANCHO_COLUMNA><p align="right"><span class="textoG">Fecha:</span></td>
						<td>&nbsp;</td>
						<td><span class="textoG"><% PLTransformaFecha Now, strFechaR %><%=strFechaR%></span></td>
						<td>&nbsp;</td>
					</tr>						
					<tr>
						<td align="left">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>
						<td align= center colspan="5">
							<span class="textoG">
							<br>
							<br>
						<br>F: _________________________________<br>
							(Recib&iacute; Conforme)
							</span>
						</td>	
						<td align="right">&nbsp;&nbsp;<strong>Reimpresi&oacute;n</strong></td>																	
					</tr>
					<tr>
						<td colspan="2"><span class="textoG">Oficina: <%=Session("VG_Oficina")%><br/>Nombre: <%=Session("VG_Nombre")%></span></td>	
						<td align="right" colspan="3"><span class="textoG">Usuario: <%=Session("VGLogin")%><br/>Nombre: <%=Session("VG_Usuario")%></span></td>						
					</tr>				
			</table>
			<table>			
					<tr>
						<td align= center colspan="4">
							<span class="textoG">Banco de Desarrollo Rural S.A. es responsable por las operaciones  realizadas y por los servicios prestados, por cuenta de &eacute;ste, por el agente bancario <%=Session("VG_Nombre")%>
							</span>
						</td>						
					</tr>
			</table>				
			</td>
		</tr>
	</table>
	<%
End Sub 'termina Boleta comisionCXCA

Sub PLTransformaFecha (parFechaO, parFechaD)
	'PNA 29/Ago/2000
	'Procedimiento para separar los datos por procesarse
	dim  VTl
	dim par1
	dim par2
	VTl=InStr(parFechaO,"/")
	par1=Mid(parFechaO,1,VTl-1)
	parFechaO=Mid(parFechaO,VTl+1,Len(parFechaO))
	VTl=InStr(parFechaO,"/")
	par2=Mid(parFechaO,1,VTl-1)
	parFechaO=Mid(parFechaO,VTl+1,Len(parFechaO))
    parFechaD=par2 & "/" & par1 & "/" & parFechaO
End Sub	 

Sub MuestraDatosCertificacion (empresa, transaccion, secuencial,tipoImpresion)
 'declaración de variables
        Dim i
		Dim jsonData ,result , dato, det
	    Dim strJson, httpRequest, url, responseText, objJSON
	   'asignaciones iniciales

       url = C_WS_CR_CXCA_GEN & "/obtener_datos_cert"

        strJson =	"{" & _
			"""empresa"":"     & """"& empresa  			   &""""    & "," & _
			"""transaccion"":" & """"& transaccion             &""""    & "," & _
			"""secuencial"":"  & """"& secuencial              &""""    & "," & _
			"""usuario"":"     & """"& Session("VGLogin")  	   &""""    & "," & _
			"""ip"":"   	   & """"& Session("VGIPAddress")  &""""    & "," & _
			"""oficina"":"     & """"& Session("VG_Oficina")   &""""    	  & _
		"}"	

		Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
		httpRequest.Open "POST", url, False
		httpRequest.setRequestHeader "Content-Type", "application/json"
		httpRequest.Send strJson

		responseText = httpRequest.ResponseText


		If httpRequest.status = 200 Then
			Set objJSON = New aspJSON
			objJSON.loadJSON(responseText)
			Set jsonData =  objJSON.data.item("obtener_datos_cert")
			Set result = jsonData.item("resultado")

			If result.item("codigo") = "1" then
				Set dato = jsonData.item("datos")

				if tipoImpresion = "0" then
					For i = 0 to (dato.count -1)

							Set det = dato.item(i)	
							If det.item("correlativo") <> "" then
								Response.Write "<tr>" 
								Response.Write "<td class=""textoG"" align=""right"">" & det.item("nombre_imp") &":" & "</td>"
								Response.Write "<td>&nbsp;</td>"
								Response.Write "<td class=""textoG"" align=""left"">"& det.item("valor")  &"</td>"
								Response.Write "</tr>"

							End If 		
					Next
				else						
					For i = 0 to (dato.count -1)

							Set det = dato.item(i)	
							If det.item("correlativo") <> "" then
								Response.Write "<tr>" 
								Response.Write "<td width=135><p align =""right"" class=""textoImpresionP"">" & UCASE(det.item("nombre_imp")) & ":" & "</td>"							
								Response.Write "<td colspan=""4""><span class=""textoImpresionP"">" & det.item("valor") & "</span></td>"								
								Response.Write "</tr>"

							End If 		
					Next
				End if	

			else 
				msj_error = result.item("descripcion")
			end if
	    Else
		   	Response.Write "<p class=""error"" align=""center"">" & httpRequest.Status & " - ERROR AL OBTENER LOS DATOS, INTENTE DE NUEVO"  & "</p>"   
	    End If  
End Sub 

sub PagoRenap()
   
    strLinea1= "Forma 63-A2 Electronico del 46,000,001 al 50,000,000 Serie BR1 autorizada segun resolucion"
    strLinea2= "F.O.-JO-70-2023/001832 Gestion: 813915 de Fecha 11-4-2023 Correl. de Fecha 5-5-2023 E.Fis"
    strLinea3= "cal 4-A1-CCC 17153 de Fecha 5-5-2023.LIBRO AB2.FOLIO 314, RENAP NIT 5246905-0"
   
End Sub

sub CltaPagoComision()
	Dim objWS
    Dim parametros
    Dim strXML
    Dim objxml
	Dim Mensaje_Error
    Dim arrElementos
    Dim arrDatos
	
    Set objWS = Server.CreateObject("MSSOAP.SoapClient30")
    objWS.ClientProperty("ServerHTTPRequest") = True 
    Call objWS.mssoapinit(C_WS_PAGO_COMISION, "", "") 
	strXML = objWS.consultaReimpresionComision(strSecuencial)
    Set objXML = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.4.0")
    Call objXML.setProperty("SelectionLanguage", "XPath")
    Call objXML.setProperty("NewParser", True)
	
    If objXML.loadXML(strXML) Then
		Set arrElementos = objxml.documentElement.childNodes
		if arrElementos(0).getattribute("codigo") = "1" then
			Set arrDatosCom = arrElementos(1).childNodes
			refCom = 0
		else
			refCom = 1 'NO imprime boleta comision
       	end if
	End If
End Sub

'loaao migración 23-12-2024
Sub MuestraDatosCertificacionHis (empresa, transaccion, secuencial,tipoImpresion)
	Dim srtJson, httpRequest, url, responseText
	Dim oJSON, resultado, jsonData, i, datos, this

	url = BR_REIMPRESION_CXCA & "obtenerDatosCertificacion"

	srtJson =	"{" & _
					"""empresa""" & ":" & """"&empresa&""""  & "," & _
					"""transaccion""" & ":" & """"&transaccion&""""  & "," & _
					"""secuencial""" & ":" & """"&secuencial&""""  & "," & _
					"""usuario""" & ":" & """"&Session("VGLogin")&""""  & "," & _
					"""ip""" & ":" & """"&Session("VGIPAddress")&""""  & "," & _
					"""oficina""" & ":" & """"&Session("VG_Oficina")&""""  & "" & _
				"}"	

	Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
	httpRequest.setTimeouts 60000,60000,60000,60000
	httpRequest.Open "POST", url, False
	httpRequest.setRequestHeader "Content-Type", "application/json"	
	httpRequest.Send srtJson
	responseText = httpRequest.ResponseText
	If httpRequest.status = 200 Then
		Set oJSON = New aspJSON
		oJSON.loadJSON(responseText)
		set jsonData = oJSON.data.item("obtenerDatosCertificacion")
		set resultado = jsonData.item("resultado")
		if resultado.item("codigo") = "1" then
			set datos = jsonData.item("datosCertificacion")
			if tipoImpresion = "0" then
				For i = 0 to datos.Count - 1
					Set this = datos.item(i)
					If this.item("correlativo") <> "" then
						   Response.Write "<tr>" 
						   Response.Write "<td class=""textoG"" align=""right"">" & this.item("nombreImp") &":" & "</td>"
						   Response.Write "<td>&nbsp;</td>"
						   Response.Write "<td class=""textoG"" align=""left"">"& LimitaCaracteres(this.item("valor"))  &"</td>"
						   Response.Write "</tr>"

					 End If 
				next
			Else
				For i = 0 to datos.Count - 1
					Set this = datos.item(i)
					If this.item("correlativo") <> "" then
						   Response.Write "<tr>" 
						   Response.Write "<td width=135><p align =""right"" class=""textoImpresionP"">" & UCASE(this.item("nombreImp")) & ":" & "</td>"							
						   Response.Write "<td colspan=""4""><span class=""textoImpresionP"">" & "Q" & LimitaCaracteres(this.item("valor"))  & "</span></td>"								
						   Response.Write "</tr>"
					 End If 
				next
			end if
		else	
			Response.Write "<center>" & _
							   "<font face=""Verdana""><b>" & _
								"No se obtuvo resultados." & _
							   "</font>" & _
						   "</center>"
			Response.End
		End If
	else
		Response.Write "<center>" & _
						   "<font face=""Verdana""><b>" & _
							"OCURRIO UN ERROR EN LA RESPUESTA DEL WEB SERVICES." & _
						   "</font>" & _
					   "</center>"
		Response.End
	end if 
End Sub 

Sub reimpresion_retiros_genericos(secuencial)
      Dim objWS    
      Dim strXML
      Dim objxml
      Dim arrElementos    
      Dim arrDatos

      'Datos a mostrar
        Dim bcc_secuencial 
        Dim bcc_fecha 
        Dim bcc_hora 
        Dim bcc_nombre_empresa 
        Dim bcc_transaccion 
        Dim bcc_ref1_desc 
        Dim bcc_ref1_val 
        Dim bcc_ref2_desc 
        Dim bcc_ref2_val 
        Dim bcc_ref3_desc 
        Dim bcc_ref3_val 
        Dim bcc_ref4_desc 
        Dim bcc_ref4_val 
        Dim bcc_ref5_desc 
        Dim bcc_ref5_val 
        Dim bcc_total 
        Dim bcc_reso1 
        Dim bcc_reso2 
        Dim bcc_reso3 
        Dim bcc_reso4 
        Dim bcc_reso5 
        Dim bcc_reso6 
        Dim bcc_oficina 
        Dim bcc_caja_rural 
        Dim bcc_cuenta 
        Dim bcc_usuario 

      Set objWS = Server.CreateObject("MSSOAP.SoapClient30")      
      objWS.ClientProperty("ServerHTTPRequest") = True    
      Call objWS.mssoapinit(C_WS_CR_PAGOS_GENERICOS, "", "")  
      strXML = objWS.obtener_datos_reimpresion(secuencial)    
      Response.Write "<p>" & strXML &  secuencial & "</p>"     

      Set objXML = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.4.0")
      Call objXML.setProperty("SelectionLanguage", "XPath")
      Call objXML.setProperty("NewParser", True)
      If objxml.loadXML(strXML) Then
		Set arrElementos = objxml.documentElement.childNodes
        if arrElementos(0).getattribute("codigo") = "1" then
            ' asignar valor a variables
            bcc_secuencial = Trim(arrDatos(1).text)
            bcc_fecha = Trim(arrDatos(2).text)
            bcc_hora = Trim(arrDatos(3).text)
            bcc_nombre_empresa = Trim(arrDatos(4).text)
            bcc_transaccion = Trim(arrDatos(5).text)
            bcc_ref1_desc = Trim(arrDatos(6).text)
            bcc_ref1_val = Trim(arrDatos(7).text)
            bcc_ref2_desc = Trim(arrDatos(8).text)
            bcc_ref2_val = Trim(arrDatos(9).text)
            bcc_ref3_desc = Trim(arrDatos(10).text)
            bcc_ref3_val = Trim(arrDatos(11).text)
            bcc_ref4_desc = Trim(arrDatos(12).text)
            bcc_ref4_val = Trim(arrDatos(13).text)
            bcc_ref5_desc = Trim(arrDatos(14).text)
            bcc_ref5_val = Trim(arrDatos(15).text)
            bcc_total = Trim(arrDatos(16).text)
            bcc_reso1 = Trim(arrDatos(17).text)
            bcc_reso2 = Trim(arrDatos(18).text)
            bcc_reso3 = Trim(arrDatos(19).text)
            bcc_reso4 = Trim(arrDatos(20).text)
            bcc_reso5 = Trim(arrDatos(21).text)
            bcc_reso6 = Trim(arrDatos(22).text)
            bcc_oficina = Trim(arrDatos(23).text)
            bcc_caja_rural = Trim(arrDatos(24).text)
            bcc_cuenta = Trim(arrDatos(25).text)
            bcc_usuario = Trim(arrDatos(26).text)
            nombreEmpresa_retiros_gen = bcc_nombre_empresa
            ' mostrar datos, solo vienen 8 referencias
              '1
            Response.Write "<tr>" 
			Response.Write "<td class=""textoG"" align=""right"">" & "CODIGO: " & "</td>"
            Response.Write "<td>&nbsp;</td>"
		    Response.Write "<td class=""textoG"" align=""left"">"& bcc_transaccion & "</td>"
			Response.Write "</tr>"
             '1
            Response.Write "<tr>" 
			Response.Write "<td class=""textoG"" align=""right"">" & UCASE(bcc_ref1_desc) & ":" & "</td>"
            Response.Write "<td>&nbsp;</td>"
		    Response.Write "<td class=""textoG"" align=""left"">"& bcc_ref1_val & "</td>"
			Response.Write "</tr>"
            '2
            Response.Write "<tr>" 
			Response.Write "<td class=""textoG"" align=""right"">" & UCASE(bcc_ref2_desc) & ":" & "</td>"
            Response.Write "<td>&nbsp;</td>"
		    Response.Write "<td class=""textoG"" align=""left"">"& bcc_ref2_val & "</td>"
			Response.Write "</tr>"
            '3
            Response.Write "<tr>" 
			Response.Write "<td class=""textoG"" align=""right"">" & UCASE(bcc_ref3_desc) & ":" & "</td>"
            Response.Write "<td>&nbsp;</td>"
		    Response.Write "<td class=""textoG"" align=""left"">"& bcc_ref3_val & "</td>"
			Response.Write "</tr>"
            '4
            Response.Write "<tr>" 
			Response.Write "<td class=""textoG"" align=""right"">" & UCASE(bcc_ref4_desc) & ":" & "</td>"
            Response.Write "<td>&nbsp;</td>"
		    Response.Write "<td class=""textoG"" align=""left"">"& bcc_ref4_val & "</td>"
			Response.Write "</tr>"
            '5
            Response.Write "<tr>" 
			Response.Write "<td class=""textoG"" align=""right"">" & UCASE(bcc_ref5_desc) & ":" & "</td>"
            Response.Write "<td>&nbsp;</td>"
		    Response.Write "<td class=""textoG"" align=""left"">"& bcc_ref5_val & "</td>"
			Response.Write "</tr>"
            '6
            Response.Write "<tr>" 
			Response.Write "<td class=""textoG"" align=""right"">" & UCASE(bcc_reso1) & ":" & "</td>"
            Response.Write "<td>&nbsp;</td>"
		    Response.Write "<td class=""textoG"" align=""left"">"& bcc_reso2 & "</td>"
			Response.Write "</tr>"
            '7
            Response.Write "<tr>" 
			Response.Write "<td class=""textoG"" align=""right"">" & UCASE(bcc_reso3) & ":" & "</td>"
            Response.Write "<td>&nbsp;</td>"
		    Response.Write "<td class=""textoG"" align=""left"">"& bcc_reso4 & "</td>"
			Response.Write "</tr>"
            '8
            Response.Write "<tr>" 
			Response.Write "<td class=""textoG"" align=""right"">" & UCASE(bcc_reso5) & ":" & "</td>"
            Response.Write "<td>&nbsp;</td>"
		    Response.Write "<td class=""textoG"" align=""left"">"& bcc_reso5 & "</td>"
			Response.Write "</tr>"
            'Monto
            Response.Write "<tr>" 
			Response.Write "<td class=""textoG"" align=""right"">" & "VALOR A PAGAR:" & "</td>"
            Response.Write "<td>&nbsp;</td>"
		    Response.Write "<td class=""textoG"" align=""left"">"& bcc_total & "</td>"
			Response.Write "</tr>"
        else
            Call DibujaTablaError("NO SE PUDIERON OBTENER LOS DATOS DE REIMPRESION DE LA BOLETA", 1, "ca_retiros_genericos.asp", "../../images")
        end if
      Else
            Call DibujaTablaError("NO SE PUDIERON OBTENER LOS DATOS DE REIMPRESION DE LA BOLETA", 1, "ca_retiros_genericos.asp", "../../images")
      End If
End Sub

Sub ConsultaTipoComisionCXCA(empresa, transaccion) 
    'celd2023 metodo para consultar tipo de comision de un cxca 
	'declaracion de variables
        Dim strJson, httpRequest, respTxt, objJson
		Dim root, resultado

        Dim arrDatos
        Dim i
		Dim msjErrorCom

        Dim comision_cliente
	
	   'asignaciones iniciales
               
        strJson = 	"{" & _
						"""empresa"":""" & empresa & """," & _
						"""transaccion"":""" & transaccion & """," & _
						"""usuario"": """ & Session("VGLogin") & """" & _
					"}"

		Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
		httpRequest.Open "POST", C_WS_CR_CXCA_GEN & "/consulta_tipo_comision", False
		httpRequest.setRequestHeader "Content-Type", "application/json;charset=utf-8"
		httpRequest.send strJson

		respTxt = httpRequest.responseText
                
        If httpRequest.Status = 200 Then
		    Set objJson = new aspJSON
			objJson.loadJson(respTxt)
			Set root = objJson.data.item("consulta_tipo_comision")
			Set resultado = root.item("resultado")
	   
		    if resultado.item("codigo") = "1" then
                       
				 set arrDatos = root.item("datos")		
                 comision_cliente = arrDatos.item("comision_cliente")
                 ComisionClienteCXCA =  comision_cliente                    				
		        	
			else 				
				msjErrorCom = resultado.item("descripcion")
				Call DibujaTablaError(msjErrorCom, 1, "CA_Reimpresion_boleta.asp", "../../images")
				 

            end if
	    Else
		   Response.Write "<p class=""error"" align=""center"">" & httpRequest.Status & " - ERROR AL REALIZAR LA CONSULTA DE TIPO DE COMISION, INTENTE DE NUEVO"  & "</p>" 
	    End If

End Sub

'celd2023 metodo para consultar datos de la comision de un cxca para reimpresion  
Sub ConsultaDatosComisionCXCA(transaccion, secuencial) 
    'declaracion de variables
        Dim strJson, httpRequest, respTxt, objJson
		Dim root, resultado 

        Dim arrDatos
		Dim msjErrorCom

        Dim monto_comision
		Dim boleta_comision
	
	   'asignaciones iniciales
	   	strJson = 	"{" & _
						"""transaccion"":""" & transaccion & """," & _
						"""secuencial_pago"":""" & secuencial & """," & _
						"""usuario"": """ & Session("VGLogin") & """" & _
					"}"

		Set httpRequest = Server.CreateObject("MSXML2.ServerXMLHTTP")
		httpRequest.Open "POST", C_WS_CR_CXCA_GEN & "/consulta_bitacora_comision", False
		httpRequest.setRequestHeader "Content-Type", "application/json;charset=utf-8"
		httpRequest.send strJson

		respTxt = httpRequest.responseText
                
        If httpRequest.Status = 200 Then
		    Set objJson = new aspJSON
			objJson.loadJson(respTxt)
			Set root = objJson.data.item("consulta_bitacora_comision")
			Set resultado = root.item("resultado")
	   
		    if resultado.item("codigo") = "1" then
                       
				 set arrDatos = root.item("datos")
                 monto_comision = arrDatos.item("monto_comision")
				 boleta_comision = arrDatos.item("boleta_comision")

                 MontoComisionCXCA =  monto_comision                    				
				 NoBoletaComisionCXCA =  boleta_comision    
		        	
			else 				
				msjErrorCom = resultado.item("descripcion")
				Call DibujaTablaError(msjErrorCom, 1, "CA_Reimpresion_boleta.asp", "../../images")

            end if
	    Else
		   Response.Write "<p class=""error"" align=""center"">" & httpRequest.Status & " - ERROR AL REALIZAR LA CONSULTA DE DATOS, INTENTE DE NUEVO"  & "</p>" 
	    End If

End Sub

Function ofuscaCuenta(ByVal cuentadesbloq)
	Dim lenCuentadesbloq
	Dim cuentaFindesbloq
	Dim idesbloq
	Dim cuentaOfuscadadesbloq
	lenCuentadesbloq = (len(cuentadesbloq)+1) - 4
	cuentaFindesbloq = mid(cuentadesbloq, lenCuentadesbloq, 4)
	For idesbloq = 0 to (lenCuentadesbloq - 1)
		cuentaOfuscadadesbloq = cuentaOfuscadadesbloq + "X"
	Next
	cuentaOfuscadadesbloq = cuentaOfuscadadesbloq + cuentaFindesbloq
	ofuscaCuenta = cuentaOfuscadadesbloq
End Function

Function ofuscaTelefono(ByVal telefonoOfuscar)
	Dim longitudDatoNoOfuscado
	Dim datoFindesbloq
	Dim contadorBloqueo
	Dim datoFinal
	longitudDatoNoOfuscado = (len(telefonoOfuscar)+1) - 4
	datoFindesbloq = mid(telefonoOfuscar, longitudDatoNoOfuscado, 4)
	For contadorBloqueo = 0 to (longitudDatoNoOfuscado - 2)
		datoFinal = datoFinal + "X"
	Next
	datoFinal = datoFinal + "-" + datoFindesbloq
	ofuscaTelefono = datoFinal
End Function

Function LimitaCaracteres(ByVal texto)
    Dim textoLimitado
    If Len(texto) > 60 Then
        textoLimitado = Mid(texto,1,60)   
	else 
		 textoLimitado = texto
    End If
    LimitaCaracteres = textoLimitado
End Function

Function ofuscaCorreo(ByVal correoOfuscar)
	Dim longitudDatoNoOfuscado
	Dim datoNoOfuscado
	Dim contadorBloqueo
	Dim datoFinal
	Dim correoIngresado
	Dim correoParte1 
	Dim correoParte2
	Dim valCorreoSeleccionado
	Dim valor
	Dim contador

	correoIngresado = correoOfuscar
	valCorreoSeleccionado = Split(correoIngresado, "@")	

	For Each valor In valCorreoSeleccionado
		contador = contador + 1
		Select Case contador 
			Case 1
				correoParte1 = valor
			Case 2
				correoParte2 = valor 
		End Select
	Next

	correoOfuscar = correoParte1	
	longitudDatoNoOfuscado = (len(correoOfuscar)+1) - 4
	datoNoOfuscado = mid(correoOfuscar, longitudDatoNoOfuscado, 4)
	For contadorBloqueo = 0 to (longitudDatoNoOfuscado - 1)
		datoFinal = datoFinal + "X"
	Next
	datoFinal = datoFinal + datoNoOfuscado
	datoFinal = datoFinal + "@" + correoParte2
	ofuscaCorreo = datoFinal
End Function


Function ofuscaTarjeta(tarjeta)'Muestra los primeros 4 digitos y los ultimos 4 digitos de la tarjeta loaao 02-06-2025
	Dim lenTarjeta, tarjetaFin, tarjetaIni, i
	
	tarjetaOfuscada = ""
	
	lenTarjeta = len(tarjeta) - 4
	tarjetaFin = mid(tarjeta, lenTarjeta+1, 4)
	tarjetaIni = mid(tarjeta, 1,4)
	For i = 0 to (lenTarjeta - 5) 'se deben restar los otros 4
		tarjetaOfuscada = tarjetaOfuscada + "X"
	Next	
	tarjetaOfuscada = tarjetaIni + tarjetaOfuscada + tarjetaFin
	ofuscaTarjeta = tarjetaOfuscada
End Function

Function ofuscaDPI(dpi)'Muestra los primeros 4 digitos y los ultimos 4 digitos del numero de DPI loaao 02-06-2025
	Dim lenDPI, DPIFin, DPIIni, i
	
	DPIOfuscado = ""
	
	lenDPI = len(dpi) - 4
	DPIFin = mid(dpi, lenDPI+1, 4)
	DPIIni = mid(dpi, 1,4)
	For i = 0 to (lenDPI - 5) 'se deben restar los otros 4
		DPIOfuscado = DPIOfuscado + "X"
	Next	
	DPIOfuscado = DPIIni + DPIOfuscado + DPIFin
	ofuscaDPI = DPIOfuscado
End Function

Function ofuscarCuenta(cuenta)'Muestra los primeros 2 digitos y los ultimos 4 digitos del numero de Cuenta loaao 02-06-2025
	Dim lenCuenta, cuentaFin, cuentaIni, i
	
	cuentaOfuscada = ""
	
	lenCuenta = len(cuenta) - 4
	cuentaFin = mid(cuenta, lenCuenta+1, 4)
	cuentaIni = mid(cuenta, 1,2)
	For i = 0 to (lenCuenta - 3) 'se deben restar los otros 4
		cuentaOfuscada = cuentaOfuscada + "X"
	Next	
	cuentaOfuscada = cuentaIni + cuentaOfuscada + cuentaFin
	ofuscarCuenta = cuentaOfuscada
End Function
%>