package exception.business;

public class NotFoundException extends RuntimeException {

    public NotFoundException(String message) {
        super(message);
    }
}