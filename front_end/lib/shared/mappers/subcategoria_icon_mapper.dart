class SubcategoriaIconMapper {
  SubcategoriaIconMapper._();

  static String icone({
    required String categoria,
    required String subcategoria,
  }) {
    final cat = _normalizar(categoria);
    final sub = _normalizar(subcategoria);

    switch (cat) {
      // 🥤 BEBIDAS
      case 'BEBIDAS':
        switch (sub) {
          case 'REFRIGERANTES':
            return "assets/icons/subcategorias/icon_refri.png";

          case 'BEBIDASNATURAIS':
            return "assets/icons/subcategorias/icon_limao.png";

          case 'BEBIDASALCOOLICAS':
            return "assets/icons/subcategorias/icon_cerveja.png";

          case 'BEBIDASQUENTES':
            return "assets/icons/subcategorias/icon_cafe.png";

          case 'BEBIDASENERGETICAS':
            return "assets/icons/subcategorias/icon_raio.png";

          case 'BEBIDASLACTEAS':
            return "assets/icons/subcategorias/icon_milkshack.png";

          case 'BEBIDASFUNCIONAIS':
            return "assets/icons/subcategorias/icon_agua.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }

      // 🥩 CARNES
      case 'CARNES':
        switch (sub) {
          case 'CARNESBOVINAS':
            return "assets/icons/subcategorias/icon_vaca.png";

          case 'CARNESSUINAS':
            return "assets/icons/subcategorias/icon_porco.png";

          case 'AVES':
            return "assets/icons/subcategorias/icon_galinha.png";

          case 'PEIXESEFRUTOSDOMAR':
            return "assets/icons/subcategorias/icon_camarao.png";

          case 'CARNESPROCESSADAS':
            return "assets/icons/subcategorias/icon_salsicha.png";

          case 'OUTRASPROTEINAS':
            return "assets/icons/subcategorias/icon_ovo.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }
      // 🥐 PADARIA
      case 'PADARIA':
        switch (sub) {
          case 'PAES':
            return "assets/icons/subcategorias/icon_pao.png";

          case 'BOLOS':
            return "assets/icons/subcategorias/icon_bolo.png";

          case 'SALGADOS':
            return "assets/icons/subcategorias/icon_croissant.png";

          case 'DOCESDEPADARIA':
            return "assets/icons/subcategorias/icon_cupcake.png";

          case 'MASSASFRESCAS':
            return "assets/icons/subcategorias/icon_macarrao.png";

          case 'PRODUTOSINTEGRAIS':
            return "assets/icons/subcategorias/icon_trigo.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }

      // 🥬 HORTIFRUTI
      case 'HORTIFRUTI':
        switch (sub) {
          case 'FRUTAS':
            return "assets/icons/subcategorias/icon_banana.png";

          case 'LEGUMES':
            return "assets/icons/subcategorias/icon_cenoura.png";

          case 'VERDURAS':
            return "assets/icons/subcategorias/icon_alface.png";

          case 'TEMPEROSNATURAIS':
            return "assets/icons/subcategorias/icon_folha.png";

          case 'GRAOSECEREAIS':
            return "assets/icons/subcategorias/icon_graos.png";

          case 'TUBERCULOS':
            return "assets/icons/subcategorias/icon_batata.png";

          case 'ORGANICOS':
            return "assets/icons/subcategorias/icon_organico.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }

      // 🥛 LATICINIOS
      case 'LATICINIOS':
        switch (sub) {
          case 'LEITE':
            return "assets/icons/subcategorias/icon_vaca2.png";

          case 'QUEIJOS':
            return "assets/icons/subcategorias/icon_queijo.png";

          case 'IOGURTES':
            return "assets/icons/subcategorias/icon_yogurt.png";

          case 'MANTEIGASEMARGARINAS':
            return "assets/icons/subcategorias/icon_manteiga.png";

          case 'CREMEDELEITEEDERIVADOS':
            return "assets/icons/subcategorias/icon_creme_leite.png";

          case 'SOBREMESASLACTEAS':
            return "assets/icons/subcategorias/icon_pudim.png";

          case 'LEITESVEGETAIS':
            return "assets/icons/subcategorias/icon_leite_soja.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }

      // 🛒 MERCEARIA
      case 'MERCEARIA':
        switch (sub) {
          case 'GRAOSECEREAIS':
            return "assets/icons/subcategorias/icon_graos.png";

          case 'MASSAS':
            return "assets/icons/subcategorias/icon_macarrao.png";

          case 'MOLHOSETEMPEROS':
            return "assets/icons/subcategorias/icon_ketchup.png";

          case 'ENLATADOSECONSERVAS':
            return "assets/icons/subcategorias/icon_enlatado.png";

          case 'OLEOSEAZEITES':
            return "assets/icons/subcategorias/icon_azeite.png";

          case 'ACUCARESEFARINHAS':
            return "assets/icons/subcategorias/icon_farinha.png";

          case 'CAFEECHA':
            return "assets/icons/subcategorias/icon_graos_cafe.png";

          case 'BISCOITOSESNACKS':
            return "assets/icons/subcategorias/icon_biscoito.png";

          case 'PRODUTOSBASICOS':
            return "assets/icons/subcategorias/icon_basicos.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }

      // 🧴 HIGIENE
      case 'HIGIENE':
        switch (sub) {
          case 'HIGIENEPESSOAL':
            return "assets/icons/subcategorias/icon_cuidados.png";

          case 'CUIDADOSBUCAIS':
            return "assets/icons/subcategorias/icon_higiene_pessoal.png";

          case 'HIGIENECORPORAL':
            return "assets/icons/subcategorias/icon_corporal.png";

          case 'DESODORANTES':
            return "assets/icons/subcategorias/icon_desodorante.png";

          case 'SABONETES':
            return "assets/icons/subcategorias/icon_sabonete.png";

          case 'SHAMPOOECONDICIONADOR':
            return "assets/icons/subcategorias/icon_shampoo.png";

          case 'CUIDADOSINTIMOS':
            return "assets/icons/subcategorias/icon_higiene.png";

          case 'BARBEAR':
            return "assets/icons/subcategorias/icon_barba.png";

          case 'ABSORVENTESECUIDADOSFEMININOS':
            return "assets/icons/subcategorias/icon_feminino.png";

          case 'HIGIENEINFANTIL':
            return "assets/icons/subcategorias/icon_crianca.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }

      // 🧼 LIMPEZA
      case 'LIMPEZA':
        switch (sub) {
          case 'LIMPEZAGERAL':
            return "assets/icons/subcategorias/icon_paninho.png";

          case 'LIMPEZADACOZINHA':
            return "assets/icons/subcategorias/icon_cozinha.png";

          case 'LIMPEZADOBANHEIRO':
            return "assets/icons/subcategorias/icon_vaso.png";

          case 'DETERGENTESESABAO':
            return "assets/icons/subcategorias/icon_maquina_lavar.png";

          case 'DESINFETANTES':
            return "assets/icons/subcategorias/icon_produto.png";

          case 'AGUASANITARIAEALVEJANTES':
            return "assets/icons/subcategorias/icon_agua_sanitaria.png";

          case 'DESENGORDURANTES':
            return "assets/icons/subcategorias/icon_agua.png";

          case 'LIMPAVIDROS':
            return "assets/icons/subcategorias/icon_desodorante.png";

          case 'ESPONJASEPANOS':
            return "assets/icons/subcategorias/icon_esponja.png";

          case 'VASSOURASERODOS':
            return "assets/icons/subcategorias/icon_vassoura.png";

          case 'PERFUMESEAROMATIZADORES':
            return "assets/icons/subcategorias/icon_aromatizador.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }

      // 🐾 PETS
      case 'PETS':
        switch (sub) {
          case 'ALIMENTOSPARACAES':
            return "assets/icons/subcategorias/icon_sorriso_dog.png";

          case 'ALIMENTOSPARAGATOS':
            return "assets/icons/subcategorias/icon_gato.png";

          case 'RACOESESPECIAIS':
            return "assets/icons/subcategorias/icon_racao.png";

          case 'PETISCOS':
            return "assets/icons/subcategorias/icon_osso.png";

          case 'HIGIENEANIMAL':
            return "assets/icons/subcategorias/icon_paninho.png";

          case 'SHAMPOOEBANHO':
            return "assets/icons/subcategorias/icon_sabonete.png";

          case 'ACESSORIOSPARAPETS':
            return "assets/icons/subcategorias/icon_coleira.png";

          case 'BRINQUEDOSPARAPETS':
            return "assets/icons/subcategorias/icon_ratinho.png";

          case 'MEDICAMENTOSVETERINARIOS':
            return "assets/icons/subcategorias/icon_pipula.png";

          case 'CAMASECONFORTO':
            return "assets/icons/subcategorias/icon_coracao_dog.png";

          case 'AREIAEHIGIENEDEGATOS':
            return "assets/icons/subcategorias/icon_caixa_areia.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }

      // 🍬 DOCES
      case 'DOCES':
        switch (sub) {
          case 'CHOCOLATES':
            return "assets/icons/subcategorias/icon_cocoa.png";

          case 'BARRASDECHOCOLATE':
            return "assets/icons/subcategorias/icon_chocolate.png";

          case 'BALASECHICLETES':
            return "assets/icons/subcategorias/icon_doce.png";

          case 'BISCOITOSDOCES':
            return "assets/icons/subcategorias/icon_biscoito.png";

          case 'SOBREMESASPRONTAS':
            return "assets/icons/subcategorias/icon_bolo.png";

          case 'DOCESTRADICIONAIS':
            return "assets/icons/subcategorias/icon_brigadeiro.png";

          case 'GELATINASEPUDINS':
            return "assets/icons/subcategorias/icon_pudim.png";

          case 'DOCESEMCALDA':
            return "assets/icons/subcategorias/icon_comida_bebe.png";

          case 'CONFEITARIAEBOLOS':
            return "assets/icons/subcategorias/icon_cupcake.png";

          case 'DOCESDIETEZEROACUCAR':
            return "assets/icons/subcategorias/icon_diet.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }

      // 🛠 UTILIDADES
      case 'UTILIDADES':
        switch (sub) {
          case 'UTENSILIOSDOMESTICOS':
            return "assets/icons/subcategorias/icon_rolo.png";

          case 'ORGANIZACAOEARMAZENAMENTO':
            return "assets/icons/subcategorias/icon_caixa.png";

          case 'PLASTICOSEDESCARTAVEIS':
            return "assets/icons/subcategorias/icon_papel_amassado.png";

          case 'PAPELALUMINIOEFILMEPLASTICO':
            return "assets/icons/subcategorias/icon_papel.png";

          case 'PANELASECOZINHA':
            return "assets/icons/subcategorias/icon_panela.png";

          case 'FERRAMENTASBASICAS':
            return "assets/icons/subcategorias/icon_martelo.png";

          case 'PILHASEBATERIAS':
            return "assets/icons/subcategorias/icon_pilha.png";

          case 'ILUMINACAO':
            return "assets/icons/subcategorias/icon_lampada.png";

          case 'ELETRONICOSSIMPLES':
            return "assets/icons/subcategorias/icon_torradeira.png";

          case 'UTILIDADESGERAIS':
            return "assets/icons/subcategorias/icon_maleta.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }

      // 👶 BEBÊS
      case 'BEBES':
        switch (sub) {
          case 'FRALDASDESCARTAVEIS':
            return "assets/icons/subcategorias/icon_fralda.png";

          case 'FRALDASDEPANOEACESSORIOS':
            return "assets/icons/subcategorias/icon_paninho.png";

          case 'LENCOSUMEDECIDOS':
            return "assets/icons/subcategorias/icon_lenco.png";

          case 'ALIMENTACAOINFANTIL':
            return "assets/icons/subcategorias/icon_bebe_comendo.png";

          case 'PAPINHASEFORMULAS':
            return "assets/icons/subcategorias/icon_biscoito.png";

          case 'MAMADEIRASEBICOS':
            return "assets/icons/subcategorias/icon_mamadeira.png";

          case 'HIGIENEDOBEBE':
            return "assets/icons/subcategorias/icon_crianca.png";

          case 'CUIDADOSCOMAPELE':
            return "assets/icons/subcategorias/icon_lavar_mao.png";

          case 'ROUPASDEBEBE':
            return "assets/icons/subcategorias/icon_body.png";

          case 'ACESSORIOSESEGURANCA':
            return "assets/icons/subcategorias/icon_chupeta.png";

          case 'BRINQUEDOSINFANTIS':
            return "assets/icons/subcategorias/icon_urinho.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }

      // 🎉 SAZONAIS
      case 'SAZONAIS':
        switch (sub) {
          case 'NATAL':
            return "assets/icons/subcategorias/icon_natal.png";

          case 'ANONOVO':
            return "assets/icons/subcategorias/icon_ano_novo.png";

          case 'PASCOA':
            return "assets/icons/subcategorias/icon_coelho.png";

          case 'CARNAVAL':
            return "assets/icons/subcategorias/icon_carnaval.png";

          case 'FESTAJUNINA':
            return "assets/icons/subcategorias/icon_festa_junina.png";

          case 'DIADASMAES':
            return "assets/icons/subcategorias/icon_cabelo_mulher.png";

          case 'DIADOSPAIS':
            return "assets/icons/subcategorias/icon_bigode.png";

          case 'DIADASCRIANCAS':
            return "assets/icons/subcategorias/icon_urinho.png";

          case 'HALLOWEEN':
            return "assets/icons/subcategorias/icon_halloween.png";

          case 'VERAO':
            return "assets/icons/subcategorias/icon_sol.png";

          case 'INVERNO':
            return "assets/icons/subcategorias/icon_inverno.png";

          default:
            return "assets/icons/subcategorias/icon_error.png";
        }

      default:
        return "assets/icons/subcategorias/icon_error.png";
    }
  }

  static String _normalizar(String value) {
    return value
        .trim()
        .toUpperCase()
        .replaceAll(RegExp(r'\s+'), '')
        .replaceAll(RegExp(r'[ÁÀÂÃ]'), 'A')
        .replaceAll(RegExp(r'[ÉÈÊ]'), 'E')
        .replaceAll(RegExp(r'[ÍÌÎ]'), 'I')
        .replaceAll(RegExp(r'[ÓÒÔÕ]'), 'O')
        .replaceAll(RegExp(r'[ÚÙÛ]'), 'U')
        .replaceAll(RegExp(r'Ç'), 'C')
        .replaceAll(RegExp(r'[^A-Z0-9_]'), '');
  }
}
