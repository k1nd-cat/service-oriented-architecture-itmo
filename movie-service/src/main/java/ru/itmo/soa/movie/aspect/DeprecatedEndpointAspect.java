package ru.itmo.soa.movie.aspect;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import ru.itmo.soa.movie.annotation.DeprecatedEndpoint;

import jakarta.servlet.http.HttpServletResponse;
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

        String redirectUrl = method.getAnnotation(DeprecatedEndpoint.class).see();
        ServletRequestAttributes attributes = 
            (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();

        if (attributes != null) {
            HttpServletResponse response = attributes.getResponse();
            if (response != null) {
                response.setStatus(HttpServletResponse.SC_FOUND);
                response.setHeader("Location", redirectUrl);
                return null;
            }
        }

        return joinPoint.proceed();
    }

}
