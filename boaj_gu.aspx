<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
<head>
    <title> </title>
    <script src="../script/jquery.min.js" type="text/javascript"></script>
    <script src='../script/qj2.js' type="text/javascript"></script>
    <script src='qset.js' type="text/javascript"></script>
    <script src='../script/qj_mess.js' type="text/javascript"></script>
    <script src="../script/qbox.js" type="text/javascript"></script>
    <script src='../script/mask.js' type="text/javascript"></script>
    <link href="../qbox.css" rel="stylesheet" type="text/css" /> 
    <script type="text/javascript">
        this.errorHandler = null;
        function onPageError(error) {
            alert("An error occurred:\r\n" + error.Message);
        }
        var q_name="boaj";
        var q_readonly = ['txtWorker','txtWorker2','txtDatea'];
        var bbmNum = []; 
        var bbmMask = []; 
        q_sqlCount = 6; brwCount = 6; brwList =[] ; brwNowPage = 0 ; brwKey = 'noa';
        //ajaxPath = ""; //  execute in Root
		aPop = new Array(['txtInspection_compno', 'lblInspection_comp', 'tgg', 'noa,comp', 'txtInspection_compno,txtInspection_comp', 'tgg_b.aspx']
		,['txtBcompno', 'lblBcomp', 'tgg', 'noa,comp', 'txtBcompno,txtBcomp', 'tgg_b.aspx']
		,['txtForwarderno', 'lblForwarder', 'tgg', 'noa,comp', 'txtForwarderno,txtForwarder', 'tgg_b.aspx']
		,['txtTrancompno', 'lblTrancomp', 'tgg', 'noa,comp', 'txtTrancompno,txtTrancomp', 'tgg_b.aspx']
		);
        $(document).ready(function () {
            bbmKey = ['noa'];
            q_brwCount();
           	q_gt(q_name, q_content, q_sqlCount, 1)
            $('#txtNoa').focus();
            
            //一個出貨單只有一個boaj
            $('#dview').hide();
            //不用新增、查詢、列印、翻頁
            $('#btnIns').hide();
            $('#btnSeek').hide();
            $('#btnPrint').hide();
            $('#btnPrevPage').hide();
            $('#btnPrev').hide();
            $('#btnNext').hide();
            $('#btnNextPage').hide();
            $('#q_menu').hide();
        });
 
       function main() {
           if (dataErr)   
           {
               dataErr = false;
               return;
           }
            mainForm(0); // 1=Last  0=Top
        }  

        function mainPost() { 
            bbmMask = [['txtDatea', r_picd],['txtEta', r_picd],['txtEtd', r_picd],['txtOnboarddate', r_picd],['txtShippingdate', r_picd]
            ,['txtCldate', r_picd+'-99:99'],['txtSaildate', r_picd]];
        	q_mask(bbmMask);
        	
        	if(window.parent.q_name=='vcc'){
				//讀取嘜頭選項
				var wParent = window.parent.document;
				var t_custno= wParent.getElementById("txtCustno").value;
				var t_where="where=^^ custno='"+t_custno+"'^^";
	            q_gt('ucam', t_where, 0, 0, 0, "", r_accy);
           }
        	
            $('#cmbMarkno').change(function() {
            	if($('#cmbMarkno').val()==''){
            		$('#txtMain').val('');
            		$('#txtSide').val('');
            		return;
            	}
            	for( i = 0; i < ucam_as.length; i++) {
            		if($('#cmbMarkno').val()==ucam_as[i].noa){
            			$('#txtMain').val(ucam_as[i].main);
            			$('#txtSide').val(ucam_as[i].side);
            			$('#txtMain').val(replaceAll($('#txtMain').val(),'chr(10)','\n'));
			            $('#txtSide').val(replaceAll($('#txtSide').val(),'chr(10)','\n')) ;
			            $('#txtMain').val($('#txtMain').val().replace(/　/g,' '));
			            $('#txtSide').val($('#txtSide').val().replace(/　/g,' '));
            			break;
            		}
            	}
            });
        }


        function q_boxClose( s2) {
            var ret; 
            switch (b_pop) {
            case q_name + '_s':
                    q_boxClose2(s2); ///   q_boxClose 3/4
                    break;
            }   /// end Switch
        }

		var ucam_as;
        function q_gtPost(t_name) {  
            switch (t_name) {
            	case 'check_Noa':
                	var as = _q_appendData("boaj", "", true);
					if (as[0] != undefined){
						alert('船務資料已存在!!');
						return;
					}
                	break;
				case 'check_btnOk':
					var as = _q_appendData("boaj", "", true);
					if (as[0] != undefined){
						alert('船務資料已存在!!');
						return;
					}else{
						wrServer($('#txtNoa').val());
					} 
                	break;
            	case 'ucam':
            		ucam_as = _q_appendData("ucam", "", true);
            		if(ucam_as[0] != undefined){
            			var t_markno='@';
            			for( i = 0; i < ucam_as.length; i++) {
                            t_markno = t_markno + (t_markno.length>0?',':'') + ucam_as[i].noa +'@' + ucam_as[i].namea;
                        }
            			q_cmbParse("cmbMarkno", t_markno);
            			if(abbm[0]!=undefined)
            				$('#cmbMarkno').val(abbm[0].markno);
            		}
                    break;
				case 'vccnogetordei':
					var as = _q_appendData("view_vcc", "", true);
					if(as[0] != undefined){
						var t_ordeno= as[0].ordeno;
						var t_where="where=^^ noa='"+t_ordeno+"'^^";
			            q_gt('ordei', t_where, 0, 0, 0, "", r_accy);
					}
					break;
				case 'ordei':
					var as = _q_appendData("ordei", "", true);
					if(as[0] != undefined){
						$('#txtNotify').val(as[0].notify);
						$('#txtTrancompno').val(as[0].trancompno);
						$('#txtTrancomp').val(as[0].trancomp);
						$('#txtInspection_compno').val(as[0].inspection_compno);
						$('#txtInspection_comp').val(as[0].inspection_comp);
						$('#txtBcompno').val(as[0].bcompno);
						$('#txtBcomp').val(as[0].bcomp);
						$('#txtBdock').val(as[0].bdock);
						$('#txtEdock').val(as[0].edock);
						$('#txtGoal').val(as[0].goal);
						$('#cmbMarkno').val(as[0].markno);
						$('#txtMain').val(replaceAll(as[0].main,'chr(10)','\n'));
						$('#txtSide').val(replaceAll(as[0].side,'chr(10)','\n')) ;
						$('#txtMain').val($('#txtMain').val().replace(/　/g,' '));
						$('#txtSide').val($('#txtSide').val().replace(/　/g,' '));
					}
					break;
                case q_name: 
                		if (q_cur == 4)  
                        q_Seek_gtPost();
                    break;
            }  /// end switch
        }
        
        function _btnSeek() {
            if (q_cur > 0 && q_cur < 4)  // 1-3
                return;
            q_box('boaj_s.aspx', q_name + '_s', "500px", "400px", q_getMsg( "popSeek"));
        }

        function btnIns() {
            _btnIns();
            $('#txtExportno').focus();
            $('#txtDatea').val(q_date());
            var t_key = q_getHref();
            if(t_key[1] != undefined){
				$('#txtNoa').val(t_key[1]);
			}
			if(window.parent.q_name=='vcc'){
				//讀取嘜頭選項
				var wParent = window.parent.document;
				var t_ordeno= wParent.getElementById("txtOrdeno").value;
				var t_where="where=^^ noa='"+t_ordeno+"'^^";
	            q_gt('ordei', t_where, 0, 0, 0, "", r_accy);
           }else if ($('#txtNoa').val().length>0){
           		var t_where="where=^^ noa='"+$('#txtNoa').val()+"'^^";
	            q_gt('view_vcc', t_where, 0, 0, 0, "vccnogetordei", r_accy);
           }
        }

        function btnModi() {
            if (emp($('#txtNoa').val()))
                return;

            _btnModi();
            $('#txtExportno').focus();
        }

        function btnPrint() {
 
        }
        
        function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
        }
        
        function btnOk() {
        	if(q_cur==1)
				$('#txtWorker').val(r_name);
			else
				$('#txtWorker2').val(r_name);
			
			$('#txtMain').val($('#txtMain').val().replace(/ /g,'　'))
			$('#txtSide').val($('#txtSide').val().replace(/ /g,'　'))
			
			if(q_cur==1){
				t_where="where=^^ noa='"+$('#txtNoa').val()+"'^^";
                q_gt('boaj', t_where, 0, 0, 0, "check_btnOk", r_accy);
			}else
				wrServer($('#txtNoa').val());
        }

        function wrServer( key_value) {
            var i;

            xmlSql = '';
            if (q_cur == 2)   /// popSave
                xmlSql = q_preXml();

            $('#txt' + bbmKey[0].substr( 0,1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
            _btnOk(key_value, bbmKey[0], '','',2);
        }
       
        function refresh(recno) {
            _refresh(recno);
            
            $('#txtMain').val(replaceAll($('#txtMain').val(),'chr(10)','\n'));
            $('#txtSide').val(replaceAll($('#txtSide').val(),'chr(10)','\n')) ;
            $('#txtMain').val($('#txtMain').val().replace(/　/g,' '));
            $('#txtSide').val($('#txtSide').val().replace(/　/g,' '));
        }
        
        function readonly(t_para, empty) {
            _readonly(t_para, empty);
            if(abbm[0]==undefined && t_para)
				btnIns();
        }

        function btnMinus(id) {
            _btnMinus(id);
        }

        function btnPlus(org_htm, dest_tag, afield) {
            _btnPlus(org_htm, dest_tag, afield);  
        }

        function q_appendData(t_Table) {
            return _q_appendData(t_Table);
        }

        function btnSeek(){
            _btnSeek();
        }

        function btnTop() {
            _btnTop();
        }
        function btnPrev() {
            _btnPrev();
        }
        function btnPrevPage() {
            _btnPrevPage();
        }

        function btnNext() {
            _btnNext();
        }
        function btnNextPage() {
            _btnNextPage();
        }

        function btnBott() {
            _btnBott();
        }
        function q_brwAssign(s1) {
            _q_brwAssign(s1);
        }

        function btnDele() {
            _btnDele();
        }

        function btnCancel() {
            _btnCancel();
        }
        
	</script>
    <style type="text/css">
          #dmain {
                overflow: hidden;
            }
            .dview {
                float: left;
                width: 98%;
            }
            .tview {
                margin: 0;
                padding: 2px;
                border: 1px black double;
                border-spacing: 0;
                font-size: medium;
                background-color: #FFFF66;
                color: blue;
            }
            .tview td {
                padding: 2px;
                text-align: center;
                border: 1px black solid;
            }
            .dbbm {
                float: left;
                width: 98%;
                margin: -1px;
                border: 1px black solid;
                border-radius: 5px;
            }
            .tbbm {
                padding: 0px;
                border: 1px white double;
                border-spacing: 0;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: #cad3ff;
                width: 100%;
            }
            .tbbm tr {
                height: 35px;
            }
            .tbbm tr td {
                
            }
            .tbbm .tdZ {
                width: 2%;
            }
            .tbbm tr td span {
                float: right;
                display: block;
                width: 5px;
                height: 10px;
            }
            .tbbm tr td .lbl {
                float: right;
                color: blue;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn {
                color: #4297D7;
                font-weight: bolder;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn:hover {
                color: #FF8F19;
            }
            .txt.c1 {
                width: 98%;
                float: left;
            }
            .txt.c2 {
                width: 38%;
                float: left;
            }
            .txt.c3 {
                width: 60%;
                float: left;
            }
            .txt.c4 {
                width: 18%;
                float: left;
            }
            .txt.c5 {
                width: 80%;
                float: left;
            }
            .txt.c6 {
                width: 50%;
                float: left;
            }
            .txt.num {
                text-align: right;
            }
            .tbbm td {
                margin: 0 -1px;
                padding: 0;
            }
            .tbbm td input[type="text"] {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                float: left;
            }
            .tbbm select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                font-size:medium;
            }
            .tbbm textarea {
            	font-size: medium;
            }
            
             input[type="text"],input[type="button"] {     
                font-size: medium;
            }
    </style>
</head>
<body>
<!--#include file="../inc/toolbar.inc"-->
        <div id='dmain' style="overflow:hidden;">
        <div class="dview" id="dview" style="float: left;  width:25%;"  >
           <table class="tview" id="tview"   border="1" cellpadding='2'  cellspacing='0' style="background-color: #FFFF66;">
            <tr>
                <td align="center" style="width:5%"><a id='vewChk'> </a></td>
                <td align="center" style="width:25%"><a id='vewDatea'> </a></td>
                <td align="center" style="width:40%"><a id='vewNoa'> </a></td>
            </tr>
             <tr>
                   <td ><input id="chkBrow.*" type="checkbox" style=''/></td>
                   <td align="center" id='datea'>~datea</td>
                   <td align="center" id='noa'>~noa</td>
            </tr>
        </table>
        </div>
        <div class='dbbm' style="width: 100%;float: left;">
        <table class="tbbm"  id="tbbm"   border="0" cellpadding='2'  cellspacing='5'>
          <tr style="height:1px;">
			  <td><input id="txtNoa" type="hidden" class="txt c1"/></td>
			  <td><input id="txtDatea" type="hidden" class="txt c1"/></td>
			  <td> </td>
			  <td> </td>
			  <td> </td>
			  <td> </td>
			  <td class="tdZ"> </td>
		  </tr>
          <tr>
               <td><span> </span><a id="lblExportno" class="lbl"> </a></td>
               <td><input id="txtExportno" type="text" class="txt c1"/></td>
               <td><span> </span><a id="lblBilloflading" class="lbl"> </a></td>
               <td><input id="txtBilloflading" type="text" class="txt c1"/></td>
               <td><span> </span><a id="lblDeliveryorder" class="lbl"> </a></td>
               <td><input id="txtDeliveryorder" type="text" class="txt c1"/></td>
            </tr>
            <tr>
               <td><span> </span><a id="lblNotify" class="lbl"> </a></td>
               <td><input id="txtNotify" type="text" class="txt c1"/></td> 
               <td><span> </span><a id="lblEntryno" class="lbl"> </a></td>
               <td><input id="txtEntryno" type="text" class="txt c1"/></td>
               <!--<td><span> </span><a id="lblInvoiceno" class="lbl"></a></td>
               <td><input id="txtInvoiceno" type="text" class="txt c1"/></td>-->                
            </tr>
            <tr>
               <td><span> </span><a id="lblTrancomp" class="lbl btn"> </a></td>
               <td colspan="3">
               		<input id="txtTrancompno" type="text" class="txt c2"/>
					<input id="txtTrancomp" type="text" class="txt c3"/>
				</td>
            </tr>
            <tr>
               <td><span> </span><a id="lblInspection_comp" class="lbl btn"> </a></td>
               <td colspan="3">
               		<input id="txtInspection_compno" type="text" class="txt c2"/>
               		<input id="txtInspection_comp" type="text" class="txt c3"/>
               	</td>
            </tr>
            <tr>
               <td><span> </span><a id="lblBcomp" class="lbl btn"> </a></td>
               <td colspan="3">
               		<input id="txtBcompno" type="text" class="txt c2"/>
               		<input id="txtBcomp" type="text" class="txt c3"/>
               	</td> 
            </tr>
            <tr>
               <td><span> </span><a id="lblForwarder" class="lbl btn"> </a></td>
               <td colspan="3">
					<input id="txtForwarderno" type="text" class="txt c2"/>
					<input id="txtForwarder" type="text" class="txt c3"/>
               </td>
               <td><span> </span><a id="lblCustoms" class="lbl"> </a></td>
               <td><input id="txtCustoms" type="text" class="txt c1"/></td>
            </tr>
            <tr>
               <td><span> </span><a id="lblEta" class="lbl"> </a></td>
               <td><input id="txtEta" type="text" class="txt c1"/></td>
               <td><span> </span><a id="lblEtd" class="lbl"> </a></td>
               <td><input id="txtEtd" type="text" class="txt c1"/></td>
            </tr>
            <tr>
               <td><span> </span><a id="lblCaseno" class="lbl"> </a></td>
               <td><input id="txtCaseno" type="text" class="txt c1"/></td>
               <td><span> </span><a id="lblCasesize" class="lbl"> </a></td>
               <td><input id="txtCasesize" type="text" class="txt num c1"/></td>
               <td><span> </span><a id="lblCaseyard" class="lbl"> </a></td>
               <td><input id="txtCaseyard" type="text" class="txt c1"/></td>
            </tr>
            <tr>
               <td><span> </span><a id="lblBillmemo" class="lbl"> </a></td>
               <td colspan="5"><input id="txtBillmemo" type="text" class="txt c1"/></td>
            </tr>
            <tr>
               <td><span> </span><a id="lblDeivery_addr" class="lbl"> </a></td>
               <td colspan="5"><input id="txtDeivery_addr" type="text" class="txt c1"/></td>
            </tr>
            <tr>
               <td><span> </span><a id="lblBdock" class="lbl"> </a></td>
               <td><input id="txtBdock" type="text" class="txt c1"/></td>
               <td><span> </span><a id="lblEdock" class="lbl"> </a></td>
               <td><input id="txtEdock" type="text" class="txt c1"/></td>
               <td><span> </span><a id="lblGoal" class="lbl"> </a></td>
               <td><input id="txtGoal" type="text" class="txt c1"/></td>
            </tr>
            <tr>
				<td><span> </span><a id="lblSono" class="lbl"> </a></td>
				<td><input id="txtSono" type="text" class="txt c1"/></td>
				<td><span> </span><a id="lblBoatname" class="lbl"> </a></td>
				<td><input id="txtBoatname" type="text" class="txt c1"/></td>
				<td><span> </span><a id="lblShip" class="lbl"> </a></td>
				<td><input id="txtShip" type="text" class="txt c1"/></td>
            </tr>
            <tr>
               <td><span> </span><a id="lblOnboarddate" class="lbl"> </a></td>
               <td><input id="txtOnboarddate" type="text" class="txt c1"/></td>
               <td><span> </span><a id="lblShippingdate" class="lbl"> </a></td>
               <td><input id="txtShippingdate" type="text" class="txt c1"/></td>
            </tr>
            <tr>
				<td><span> </span><a id="lblSaildate" class="lbl"> </a></td>
				<td><input id="txtSaildate" type="text" class="txt c1" /></td>
				<td><span> </span><a id="lblCldate" class="lbl"> </a></td>
				<td><input id="txtCldate" type="text" class="txt c1"/></td>
				<td><span> </span><a id="lblPallet" class="lbl"> </a></td>
				<td><input id="txtPallet" type="text" class="txt c1"/></td>
            </tr>
            <tr>
				<td><span> </span><a id="lblMarkno" class="lbl"> </a></td>
				<td><select id="cmbMarkno" class="txt c1"> </select></td> 
		  	</tr>
            <tr>
               <td><span> </span><a id="lblMain" class="lbl"> </a></td>
               <td colspan="2"><textarea id="txtMain"  rows='5' cols='50' style="width:300px; height: 250px;"> </textarea></td>
               <td><span> </span><a id="lblSide" class="lbl"> </a></td>
               <td colspan="2"><textarea id="txtSide"  rows='15' cols='50' style="width:300px; height: 250px;"> </textarea></td> 
            </tr>
            <tr>
               <td><span> </span><a id="lblWorker" class="lbl"> </a></td>
               <td><input id="txtWorker" type="text" class="txt c1"/></td>
               <td><span> </span><a id="lblWorker2" class="lbl"> </a></td>
               <td><input id="txtWorker2" type="text" class="txt c1"/></td>
            </tr>
        </table>
        </div>
        </div> 
        <input id="q_sys" type="hidden" />
</body>
</html>
