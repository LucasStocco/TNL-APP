package exception.handler;

import java.time.LocalDateTime;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import exception.business.BusinessException;
import exception.business.NotFoundException;
import response.ApiError;

@RestControllerAdvice
public class GlobalExceptionHandler {

    // =========================================================
    // 🔴 NOT FOUND (404)
    // =========================================================
    @ExceptionHandler(NotFoundException.class)
    public ResponseEntity<ApiError> handleNotFound(NotFoundException ex) {

        ApiError error = new ApiError(
                HttpStatus.NOT_FOUND.value(),
                "NOT_FOUND",
                ex.getMessage(),
                LocalDateTime.now()
        );

        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(error);
    }

    // =========================================================
    // 🟠 BUSINESS ERROR (400)
    // =========================================================
    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiError> handleBusiness(BusinessException ex) {

        ApiError error = new ApiError(
                HttpStatus.BAD_REQUEST.value(),
                "BUSINESS_ERROR",
                ex.getMessage(),
                LocalDateTime.now()
        );

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(error);
    }

    // =========================================================
    // 🔴 VALIDATION ERROR (400 - opcional mas recomendado)
    // =========================================================
    @ExceptionHandler(org.springframework.web.bind.MethodArgumentNotValidException.class)
    public ResponseEntity<ApiError> handleValidation(
            org.springframework.web.bind.MethodArgumentNotValidException ex) {

        String message = ex.getBindingResult()
                .getFieldErrors()
                .stream()
                .findFirst()
                .map(err -> err.getDefaultMessage())
                .orElse("Erro de validação");

        ApiError error = new ApiError(
                HttpStatus.BAD_REQUEST.value(),
                "VALIDATION_ERROR",
                message,
                LocalDateTime.now()
        );

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(error);
    }

    // =========================================================
    // 🔴 GENERIC ERROR (500)
    // =========================================================
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiError> handleGeneric(Exception ex) {

        ApiError error = new ApiError(
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "INTERNAL_ERROR",
                "Erro inesperado no servidor",
                LocalDateTime.now()
        );

        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(error);
    }
}