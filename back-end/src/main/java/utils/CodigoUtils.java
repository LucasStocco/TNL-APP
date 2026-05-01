package utils;

public class CodigoUtils {

    public static String gerarCodigo(String nome) {
        return nome
                .toUpperCase()
                .trim()
                .replaceAll(" ", "_")
                .replaceAll("[^A-Z0-9_]", "");
    }
}