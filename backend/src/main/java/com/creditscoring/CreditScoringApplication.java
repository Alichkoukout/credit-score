package com.creditscoring;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class CreditScoringApplication {
    public static void main(String[] args) {
        SpringApplication.run(CreditScoringApplication.class, args);
    }
}

