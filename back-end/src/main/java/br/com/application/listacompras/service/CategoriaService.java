package br.com.application.listacompras.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import br.com.application.listacompras.dto.CategoriaRequestDTO;
import br.com.application.listacompras.dto.CategoriaResponseDTO;
import br.com.application.listacompras.model.Categoria;
import br.com.application.listacompras.repository.CategoriaRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CategoriaService {

    @Autowired
    private CategoriaRepository categoriaRepository;

    public List<CategoriaResponseDTO> listarTodos() {
        return categoriaRepository.findAll()
                .stream()
                .map(this::converterParaDTO)
                .collect(Collectors.toList());
    }

    public CategoriaResponseDTO buscarPorId(Long id) {
        return categoriaRepository.findById(id)
                .map(this::converterParaDTO)
                .orElse(null);
    }

    public CategoriaResponseDTO criar(CategoriaRequestDTO dto) {
        Categoria categoria = new Categoria();
        categoria.setNome(dto.getNome());
        return converterParaDTO(categoriaRepository.save(categoria));
    }

    public CategoriaResponseDTO atualizar(Long id, CategoriaRequestDTO dto) {
        return categoriaRepository.findById(id)
                .map(c -> {
                    c.setNome(dto.getNome());
                    return converterParaDTO(categoriaRepository.save(c));
                }).orElse(null);
    }

    public boolean deletar(Long id) {
        return categoriaRepository.findById(id)
                .map(c -> {
                    categoriaRepository.delete(c);
                    return true;
                }).orElse(false);
    }

    private CategoriaResponseDTO converterParaDTO(Categoria categoria) {
        return new CategoriaResponseDTO(categoria.getId(), categoria.getNome());
    }
}