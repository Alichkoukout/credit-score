package com.creditscoring.dto;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class ValidationRequestDTO {
    @NotNull(message = "Final score is required")
    private BigDecimal finalScore;
    
    @NotBlank(message = "Justification is required")
    private String justification;
    
    private String actionType; // APPROVED, REJECTED, MODIFIED
}

