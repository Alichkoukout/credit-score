package com.creditscoring.dto;

import jakarta.validation.constraints.*;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class CreateCreditRequestDTO {
    @NotNull(message = "Amount is required")
    @DecimalMin(value = "100.0", message = "Minimum amount is 100")
    @DecimalMax(value = "100000.0", message = "Maximum amount is 100000")
    private BigDecimal amountRequested;
    
    @NotBlank(message = "Purpose is required")
    private String purpose;
    
    @NotBlank(message = "Employment status is required")
    private String employmentStatus;
    
    @NotNull(message = "Monthly income is required")
    @DecimalMin(value = "0.0", message = "Monthly income must be positive")
    private BigDecimal monthlyIncome;
    
    @NotNull(message = "Employment duration is required")
    @Min(value = 0, message = "Employment duration must be positive")
    private Integer employmentDurationMonths;
    
    @DecimalMin(value = "0.0", message = "Current debt must be positive")
    private BigDecimal currentDebt = BigDecimal.ZERO;
    
    @NotNull(message = "Credit history is required")
    @Min(value = 0, message = "Credit history must be positive")
    private Integer creditHistoryMonths;
    
    @NotNull(message = "Age is required")
    @Min(value = 18, message = "Minimum age is 18")
    @Max(value = 100, message = "Maximum age is 100")
    private Integer age;
    
    private String maritalStatus;
    
    @Min(value = 0, message = "Dependents must be positive")
    private Integer dependents = 0;
    
    private Boolean propertyOwned = false;
    
    private String educationLevel;
}

