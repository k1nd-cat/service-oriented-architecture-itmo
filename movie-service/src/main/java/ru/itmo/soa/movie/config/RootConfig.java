package ru.itmo.soa.movie.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@ComponentScan(basePackages = {
    "ru.itmo.soa.movie.service",
    "ru.itmo.soa.movie.repository",
    "ru.itmo.soa.movie.mapper",
    "ru.itmo.soa.movie.aspect"
})
@EnableJpaRepositories(basePackages = "ru.itmo.soa.movie.repository")
@EnableTransactionManagement
@Import({DataSourceConfig.class, ModelMapperConfig.class})
public class RootConfig {
}

