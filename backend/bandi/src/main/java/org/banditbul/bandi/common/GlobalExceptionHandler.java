package org.banditbul.bandi.common;

import org.banditbul.bandi.common.exception.EntityNotFoundException;
import org.banditbul.bandi.common.exception.ExistException;
import org.banditbul.bandi.common.exception.PasswordIncorrectException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(EntityNotFoundException.class)
    public ResponseEntity<String> handleEntityNotFound(EntityNotFoundException e){
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
    }

    @ExceptionHandler(ExistException.class)
    public ResponseEntity<String> handleExist(ExistException e){
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(e.getMessage());
    }

    @ExceptionHandler(PasswordIncorrectException.class)
    public ResponseEntity<String> handlePasswordIncorrect(PasswordIncorrectException e){
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
    }


}
