package ru.itmo.soa.movie.aspect;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import ru.itmo.soa.movie.annotation.DeprecatedEndpoint;

import java.lang.reflect.Method;

@Slf4j
@Aspect
@Component
@Order(1)
public class DeprecatedEndpointAspect {

    @Around("@annotation(ru.itmo.soa.movie.annotation.DeprecatedEndpoint)")
    public Object handleSeeOther(
            ProceedingJoinPoint joinPoint
    ) throws Throwable {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();

        DeprecatedEndpoint annotation = method.getAnnotation(DeprecatedEndpoint.class);
        String redirectUrl = annotation.see();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Location", redirectUrl);

        return ResponseEntity
                .status(HttpStatus.FOUND)
                .headers(headers)
                .build();
    }

}
