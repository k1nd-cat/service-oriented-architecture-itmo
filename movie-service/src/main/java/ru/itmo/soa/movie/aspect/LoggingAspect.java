package ru.itmo.soa.movie.aspect;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.stream.Collectors;

@Slf4j
@Aspect
@Component
public class LoggingAspect {

    @Pointcut("within(@org.springframework.web.bind.annotation.RestController *)")
    public void controllerMethods() {
    }

    @Around("controllerMethods()")
    public Object logAround(ProceedingJoinPoint joinPoint) throws Throwable {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();

        String httpMethod = getHttpMethod(method);
        String path = getRequestPath(method);

        if (httpMethod != null && path != null) {
            log.info("{} {} - {}", httpMethod, path, method.getName());
        } else {
            log.info("Executing: {}.{}()", 
                    joinPoint.getSignature().getDeclaringTypeName(),
                    joinPoint.getSignature().getName());
        }

        if (log.isDebugEnabled()) {
            Object[] args = joinPoint.getArgs();
            if (args != null && args.length > 0) {
                String params = Arrays.stream(args)
                        .map(arg -> arg != null ? arg.getClass().getSimpleName() : "null")
                        .collect(Collectors.joining(", "));
                log.debug("Request parameters: {}", params);
            }
        }
        
        long startTime = System.currentTimeMillis();
        
        try {
                        Object result = joinPoint.proceed();
            
            long executionTime = System.currentTimeMillis() - startTime;
            
                        if (httpMethod != null && path != null) {
                log.info("{} {} completed in {} ms", httpMethod, path, executionTime);
            } else {
                log.info("{}.{}() completed in {} ms", 
                        joinPoint.getSignature().getDeclaringTypeName(),
                        joinPoint.getSignature().getName(),
                        executionTime);
            }
            
            return result;
            
        } catch (Exception e) {
            long executionTime = System.currentTimeMillis() - startTime;
            
                        if (httpMethod != null && path != null) {
                log.error("{} {} failed after {} ms: {}", 
                        httpMethod, path, executionTime, e.getMessage());
            } else {
                log.error("{}.{}() failed after {} ms: {}", 
                        joinPoint.getSignature().getDeclaringTypeName(),
                        joinPoint.getSignature().getName(),
                        executionTime,
                        e.getMessage());
            }
            
            throw e;
        }
    }

        private String getHttpMethod(Method method) {
        if (method.isAnnotationPresent(GetMapping.class)) {
            return "GET";
        } else if (method.isAnnotationPresent(PostMapping.class)) {
            return "POST";
        } else if (method.isAnnotationPresent(PutMapping.class)) {
            return "PUT";
        } else if (method.isAnnotationPresent(DeleteMapping.class)) {
            return "DELETE";
        } else if (method.isAnnotationPresent(PatchMapping.class)) {
            return "PATCH";
        } else if (method.isAnnotationPresent(RequestMapping.class)) {
            RequestMapping requestMapping = method.getAnnotation(RequestMapping.class);
            if (requestMapping.method().length > 0) {
                return requestMapping.method()[0].name();
            }
        }
        return null;
    }

        private String getRequestPath(Method method) {
        String basePath = getClassLevelPath(method.getDeclaringClass());
        String methodPath = "";
        
        if (method.isAnnotationPresent(GetMapping.class)) {
            GetMapping mapping = method.getAnnotation(GetMapping.class);
            methodPath = mapping.value().length > 0 ? mapping.value()[0] : "";
        } else if (method.isAnnotationPresent(PostMapping.class)) {
            PostMapping mapping = method.getAnnotation(PostMapping.class);
            methodPath = mapping.value().length > 0 ? mapping.value()[0] : "";
        } else if (method.isAnnotationPresent(PutMapping.class)) {
            PutMapping mapping = method.getAnnotation(PutMapping.class);
            methodPath = mapping.value().length > 0 ? mapping.value()[0] : "";
        } else if (method.isAnnotationPresent(DeleteMapping.class)) {
            DeleteMapping mapping = method.getAnnotation(DeleteMapping.class);
            methodPath = mapping.value().length > 0 ? mapping.value()[0] : "";
        } else if (method.isAnnotationPresent(PatchMapping.class)) {
            PatchMapping mapping = method.getAnnotation(PatchMapping.class);
            methodPath = mapping.value().length > 0 ? mapping.value()[0] : "";
        } else if (method.isAnnotationPresent(RequestMapping.class)) {
            RequestMapping mapping = method.getAnnotation(RequestMapping.class);
            methodPath = mapping.value().length > 0 ? mapping.value()[0] : "";
        }
        
        if (basePath != null || methodPath != null) {
            return (basePath != null ? basePath : "") + (methodPath != null ? methodPath : "");
        }
        
        return null;
    }

        private String getClassLevelPath(Class<?> clazz) {
        if (clazz.isAnnotationPresent(RequestMapping.class)) {
            RequestMapping requestMapping = clazz.getAnnotation(RequestMapping.class);
            if (requestMapping.value().length > 0) {
                return requestMapping.value()[0];
            }
        }
        return null;
    }
}

