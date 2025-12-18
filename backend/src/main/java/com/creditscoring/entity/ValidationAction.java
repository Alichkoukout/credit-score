package com.creditscoring.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "validation_actions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ValidationAction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "request_id", nullable = false)
    private CreditRequest request;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "agent_id", nullable = false)
    private User agent;
    
    @Column(name = "ai_score", precision = 5, scale = 2)
    private BigDecimal aiScore;
    
    @Column(name = "original_score", precision = 5, scale = 2)
    private BigDecimal originalScore;
    
    @Column(name = "final_score", precision = 5, scale = 2)
    private BigDecimal finalScore;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "action_type", nullable = false)
    private ActionType actionType;
    
    @Column(nullable = false, columnDefinition = "TEXT")
    private String justification;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
    
    public enum ActionType {
        APPROVED, REJECTED, MODIFIED
    }
}

