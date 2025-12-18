package com.creditscoring.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class JwtAuthenticationResponse {
    private String token;
    private String type = "Bearer";
    private String email;
    private String role;
    private Long userId;
}

