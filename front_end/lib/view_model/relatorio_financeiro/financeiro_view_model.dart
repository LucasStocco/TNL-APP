import 'package:flutter/material.dart';

import '../../model/relatorio_financeiro/financeiro.dart';
import '../../service/relatorio_financeiro/financeiro_service.dart';


class FinanceiroViewModel 
 extends ChangeNotifier {
	
	final FinanceiroService _service =
	FinanceiroService();
	
	bool loading = false;
	String? erro;
	
	GastoTotalModel? totalGeral;
	
	Future<void> carregarTotalGeral() async{
		
		loading = true;
		
		notifyListeners();
		
		try {
			totalGeral = 
			await _service.buscarTotalGeral();
		} catch (e) {
			erro = e.toString();
		}
		
		loading = false;
		notifyListeners();
	}
 }