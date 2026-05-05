package response;

public class ApiResponse<T> {

    private String message;
    private boolean success;
    private T data;

    public ApiResponse() {}

    public ApiResponse(String message, T data) {
        this.message = message;
        this.data = data;
        this.success = true;
    }

    public ApiResponse(String message, boolean success, T data) {
        this.message = message;
        this.success = success;
        this.data = data;
    }

    // =========================
    // GETTERS
    // =========================

    public String getMessage() {
        return message;
    }

    public boolean isSuccess() {
        return success;
    }

    public T getData() {
        return data;
    }

    // =========================
    // STATIC FACTORIES (opcional mas recomendado)
    // =========================

    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(message, data);
    }

    public static <T> ApiResponse<T> fail(String message) {
        return new ApiResponse<>(message, false, null);
    }
}