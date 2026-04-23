package com.tnl.listacompras.service.gerenciar_lista;

import java.util.List;

import org.springframework.stereotype.Service;

import com.tnl.listacompras.dto.requestDTO.gerenciar_lista.*;
import com.tnl.listacompras.dto.responseDTO.gerenciar_lista.ItemResponseDTO;
import com.tnl.listacompras.model.gerenciar_lista.Item;

@Service
public class ItemService {

    private final ItemManualService manualService;
    private final ItemGlobalService globalService;

    public ItemService(ItemManualService manualService,
                       ItemGlobalService globalService) {
        this.manualService = manualService;
        this.globalService = globalService;
    }

    // ================= CREATE MANUAL =================
    public ItemResponseDTO criarManual(Long idLista, ItemManualRequestDTO dto) {
        return manualService.criar(idLista, dto);
    }

    // ================= CREATE GLOBAL =================
    public ItemResponseDTO criarGlobal(Long idLista, ItemGlobalRequestDTO dto) {
        return globalService.criar(idLista, dto);
    }

    // ================= LISTAR =================
    public List<ItemResponseDTO> listarPorLista(Long idLista) {
        return manualService.listarPorLista(idLista);
    }

    // ================= POR CATEGORIA =================
    public List<ItemResponseDTO> buscarPorCategoria(Long idLista, Long idCategoria) {
        return manualService.buscarPorCategoria(idLista, idCategoria);
    }

    // ================= UPDATE =================
    public ItemResponseDTO atualizar(Long idLista, Long idItem, ItemUpdateDTO dto) {

        Item item = manualService.getEntity(idLista, idItem);

        // 🔥 SE FOR GLOBAL → usa globalService
        if (item.getIdProduto() != null) {
            return globalService.atualizar(item, dto);
        }

        // 🔥 SE FOR MANUAL → usa manualService
        return manualService.atualizar(idLista, idItem, dto);
    }

    // ================= DELETE =================
    public void deletar(Long idLista, Long idItem) {
        Item item = manualService.getEntity(idLista, idItem);
        globalService.deletar(item);
    }

    // ================= COMPRADO (FIXADO) =================
    public void marcarComprado(Long idLista, Long idItem) {
        manualService.marcarComprado(idLista, idItem, true);
    }

    // (OPCIONAL - MELHOR FUTURO)
    public void toggleComprado(Long idLista, Long idItem) {
        manualService.marcarComprado(idLista, idItem, true);
    }
}