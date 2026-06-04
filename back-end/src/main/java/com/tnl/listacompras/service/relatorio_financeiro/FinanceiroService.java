package com.tnl.listacompras.service.relatorio_financeiro;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.tnl.listacompras.dto.responseDTO.relatorio_financeiro.GastoPorCategoriaDTO;
import com.tnl.listacompras.dto.responseDTO.relatorio_financeiro.GastoTotalDTO;
import com.tnl.listacompras.model.gerenciar_lista.Item;
import com.tnl.listacompras.model.gerenciar_lista.Lista;
import com.tnl.listacompras.repository.gerenciar_lista.ItemRepository;
import com.tnl.listacompras.repository.gerenciar_lista.ListaRepository;
import com.tnl.listacompras.session.Session;
import com.tnl.listacompras.dto.responseDTO.relatorio_financeiro.GastoPorListaDTO;

@Service
public class FinanceiroService {
    private final ItemRepository itemRepository;
    private final ListaRepository listaRepository;

    public FinanceiroService(
            ItemRepository itemRepository,
            ListaRepository listaRepository
    ) {

        this.itemRepository = itemRepository;
        this.listaRepository = listaRepository;
    }

    public GastoTotalDTO calcularTotalLista(Long listaId) {

        List<Item> itens =
                itemRepository.findByListaIdAndDeletadoFalse(listaId);

        double total = itens.stream()
                .mapToDouble(Item::getTotal)
                .sum();
        return new GastoTotalDTO(total);
    }

    public List<GastoPorCategoriaDTO> calcularPorCategoria(Long listaId) {
        List<Item> itens =
                itemRepository.findByListaIdAndDeletadoFalse(listaId);
        Map<String, Double> totaisPorCategoria =
                new HashMap<>();
        for (Item item : itens) {

           String categoria =
        item.getProduto()
            .getSubcategoria()
            .getCategoria()
            .getNome();

            Double totalItem = item.getTotal();
            totaisPorCategoria.merge(
                    categoria,
                    totalItem,
                    Double::sum
            );
        }
        List<GastoPorCategoriaDTO> resultado = new ArrayList<>();
       for (Map.Entry<String, Double> entry :
             totaisPorCategoria.entrySet()) {
    	   
            GastoPorCategoriaDTO dto =
                    new GastoPorCategoriaDTO(
                            entry.getKey(),
                            entry.getValue() );
           resultado.add(dto);
       } 
        return resultado;
        }
    public GastoTotalDTO calcularTotalGeral() {
    	Long userId = Session.getUsuarioId();
    	List<Lista> listas = listaRepository.findByUsuarioIdAndDeletadoFalse(userId);    	
    	double totalGeral = 0;    
   
   	  for (Lista lista : listas) {
    	        List<Item> itens =
    	        itemRepository.findByListaIdAndDeletadoFalse(lista.getId());
    	        double totalLista = itens.stream()
    	                .mapToDouble(Item::getTotal)
    	                .sum();
    	        
    	    totalGeral += totalLista;
    	    }
   	  
    	    return new GastoTotalDTO(totalGeral); 	
    }
    public GastoTotalDTO calcularMediaGastos() {
    	Long userId = Session.getUsuarioId();
    	List<Lista> listas = listaRepository.findByUsuarioIdAndDeletadoFalse(userId);
    	
    	if(listas.isEmpty()) {
    		return new GastoTotalDTO(0.0);
    	}
    	double totalGeral = 0;
    	
    	for (Lista lista : listas) {
    		List<Item> itens =
    			itemRepository.findByListaIdAndDeletadoFalse(lista.getId());
    		double totalLista = itens.stream().mapToDouble(Item::getTotal)
    				.sum();
    		totalGeral += totalLista;		   		
    	}
    	
    	double media = totalGeral / listas.size();
    	return new GastoTotalDTO(media);
    }
public List<GastoPorListaDTO> calcularTotalPorLista() {

    Long userId = Session.getUsuarioId();

    List<Lista> listas =
            listaRepository.findByUsuarioIdAndDeletadoFalse(userId);

    List<GastoPorListaDTO> resultado = new ArrayList<>();

    for (Lista lista : listas) {

        List<Item> itens =
                itemRepository.findByListaIdAndDeletadoFalse(
                        lista.getId()
                );

        double totalLista = itens.stream()
                .mapToDouble(Item::getTotal)
                .sum();

        resultado.add(
                new GastoPorListaDTO(
                        lista.getNome(),
                        totalLista
                )
        );
    }

    return resultado;
}
}