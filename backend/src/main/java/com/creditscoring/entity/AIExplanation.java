package com.creditscoring.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "ai_explanations")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AIExplanation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "request_id", nullable = false, unique = true)
    private CreditRequest request;
    
    @Column(name = "feature_importance", columnDefinition = "JSON")
    private String featureImportance;
    
    @Column(name = "explanation_text", columnDefinition = "TEXT")
    private String explanationText;
    
    @Column(name = "risk_factors", columnDefinition = "JSON")
    private String riskFactors;
    
    @Column(name = "positive_factors", columnDefinition = "JSON")
    private String positiveFactors;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
}

