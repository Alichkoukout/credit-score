package com.creditscoring.service;

import com.creditscoring.dto.CreateCreditRequestDTO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import java.util.HashMap;
import java.util.Map;

@Service
public class AIService {
    
    @Value("${ai.service.url}")
    private String aiServiceUrl;
    
    private final WebClient webClient;
    
    public AIService() {
        this.webClient = WebClient.builder()
            .baseUrl(aiServiceUrl)
            .build();
    }
    
    public Map<String, Object> calculateScore(CreateCreditRequestDTO request) {
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("amount_requested", request.getAmountRequested());
        requestBody.put("monthly_income", request.getMonthlyIncome());
        requestBody.put("employment_duration_months", request.getEmploymentDurationMonths());
        requestBody.put("current_debt", request.getCurrentDebt());
        requestBody.put("credit_history_months", request.getCreditHistoryMonths());
        requestBody.put("age", request.getAge());
        requestBody.put("dependents", request.getDependents());
        requestBody.put("property_owned", request.getPropertyOwned());
        
        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> response = webClient.post()
                .uri("/predict")
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(requestBody)
                .retrieve()
                .bodyToMono(Map.class)
                .block();
            
            return response != null ? response : createDefaultResponse();
        } catch (Exception e) {
            e.printStackTrace();
            return createDefaultResponse();
        }
    }
    
    private Map<String, Object> createDefaultResponse() {
        Map<String, Object> response = new HashMap<>();
        response.put("score", 65.0);
        response.put("confidence", 0.7);
        response.put("explanation", "Score calculé par défaut");
        return response;
    }
}

