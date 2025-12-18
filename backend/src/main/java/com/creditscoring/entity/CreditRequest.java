package com.creditscoring.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "credit_requests")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreditRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @Column(name = "request_number", unique = true, nullable = false, length = 50)
    private String requestNumber;
    
    @Column(name = "amount_requested", nullable = false, precision = 15, scale = 2)
    private BigDecimal amountRequested;
    
    private String purpose;
    
    @Column(name = "employment_status", length = 50)
    private String employmentStatus;
    
    @Column(name = "monthly_income", precision = 15, scale = 2)
    private BigDecimal monthlyIncome;
    
    @Column(name = "employment_duration_months")
    private Integer employmentDurationMonths;
    
    @Column(name = "current_debt", precision = 15, scale = 2)
    private BigDecimal currentDebt = BigDecimal.ZERO;
    
    @Column(name = "credit_history_months")
    private Integer creditHistoryMonths;
    
    private Integer age;
    
    @Column(name = "marital_status", length = 20)
    private String maritalStatus;
    
    private Integer dependents = 0;
    
    @Column(name = "property_owned")
    private Boolean propertyOwned = false;
    
    @Column(name = "education_level", length = 50)
    private String educationLevel;
    
    @Column(name = "ai_score", precision = 5, scale = 2)
    private BigDecimal aiScore;
    
    @Column(name = "ai_confidence", precision = 5, scale = 2)
    private BigDecimal aiConfidence;
    
    @Column(name = "final_score", precision = 5, scale = 2)
    private BigDecimal finalScore;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private RequestStatus status = RequestStatus.PENDING;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "agent_id")
    private User agent;
    
    @Column(name = "validated_at")
    private LocalDateTime validatedAt;
    
    @Column(name = "rejection_reason", columnDefinition = "TEXT")
    private String rejectionReason;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    public enum RequestStatus {
        PENDING, PROCESSING, APPROVED, REJECTED, TREATED
    }
}

