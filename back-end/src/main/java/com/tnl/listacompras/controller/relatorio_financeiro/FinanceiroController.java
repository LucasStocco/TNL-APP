package com.tnl.listacompras.controller.relatorio_financeiro;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.tnl.listacompras.dto.responseDTO.relatorio_financeiro.GastoPorCategoriaDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_financeiro.GastoPorListaDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_financeiro.GastoTotalDTO;
import com.tnl.listacompras.service.relatorio_financeiro.FinanceiroService;

import response.ApiResponse;

@RestController
@RequestMapping("/financeiro")
public class FinanceiroController {

    private final FinanceiroService financeiroService;

    public FinanceiroController(
            FinanceiroService financeiroService
    ) {
        this.financeiroService = financeiroService;
    }

    @GetMapping("/listas/{id}/total")
    public ResponseEntity<ApiResponse<GastoTotalDTO>>
    calcularTotalLista(
            @PathVariable Long id
    ) {

        GastoTotalDTO dto =
                financeiroService.calcularTotalLista(id);

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Total calculado",
                        dto
                )
        );
    }

    @GetMapping("/listas/{id}/categorias")
    public ResponseEntity<ApiResponse<List<GastoPorCategoriaDTO>>>
    calcularPorCategoria(
            @PathVariable Long id
    ) {

        List<GastoPorCategoriaDTO> dto =
                financeiroService.calcularPorCategoria(id);

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Gastos por categoria",
                        dto
                )
        );
    }

    @GetMapping("/total-geral")
    public ResponseEntity<ApiResponse<GastoTotalDTO>>
    calcularTotalGeral() {

        GastoTotalDTO dto =
                financeiroService.calcularTotalGeral();

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Total geral calculado",
                        dto
                )
        );
    }

    @GetMapping("/media-gastos")
    public ResponseEntity<ApiResponse<GastoTotalDTO>>
    calcularMediaGastos() {

        GastoTotalDTO dto =
                financeiroService.calcularMediaGastos();

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Média de gastos calculada",
                        dto
                )
        );
    }

    @GetMapping("/total-por-lista")
    public ResponseEntity<ApiResponse<List<GastoPorListaDTO>>>
    calcularTotalPorLista() {

        List<GastoPorListaDTO> dto =
                financeiroService.calcularTotalPorLista();

        return ResponseEntity.ok(
                ApiResponse.success(
                        "Total por lista calculado",
                        dto
                )
        );
    }
}