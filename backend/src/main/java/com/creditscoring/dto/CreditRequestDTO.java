package com.creditscoring.dto;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class CreditRequestDTO {
    private Long id;
    private String requestNumber;
    private BigDecimal amountRequested;
    private String purpose;
    private String employmentStatus;
    private BigDecimal monthlyIncome;
    private Integer employmentDurationMonths;
    private BigDecimal currentDebt;
    private Integer creditHistoryMonths;
    private Integer age;
    private String maritalStatus;
    private Integer dependents;
    private Boolean propertyOwned;
    private String educationLevel;
    private BigDecimal aiScore;
    private BigDecimal aiConfidence;
    private BigDecimal finalScore;
    private String status;
    private Long agentId;
    private LocalDateTime validatedAt;
    private String rejectionReason;
    private LocalDateTime createdAt;
    private UserDTO user;
}

