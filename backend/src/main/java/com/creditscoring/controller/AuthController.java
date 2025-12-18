package com.creditscoring.controller;

import com.creditscoring.dto.JwtAuthenticationResponse;
import com.creditscoring.dto.LoginRequest;
import com.creditscoring.dto.RegisterRequest;
import com.creditscoring.service.AuthService;
import com.creditscoring.repository.UserRepository;
import com.creditscoring.entity.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/login")
    public ResponseEntity<JwtAuthenticationResponse> login(@Valid @RequestBody LoginRequest loginRequest) {
        JwtAuthenticationResponse response = authService.login(loginRequest);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/register")
    public ResponseEntity<JwtAuthenticationResponse> register(@Valid @RequestBody RegisterRequest registerRequest) {
        JwtAuthenticationResponse response = authService.register(registerRequest);
        return ResponseEntity.ok(response);
    }

    // Dev-only: inspect agent2 account
    @GetMapping("/debug/agent2")
    public ResponseEntity<?> debugAgent() {
        return userRepository.findByEmail("agent2@example.com")
                .map(user -> ResponseEntity.ok(java.util.Map.of(
                        "email", user.getEmail(),
                        "username", user.getUsername(),
                        "role", user.getRole().name(),
                        "active", user.getIsActive())))
                .orElse(ResponseEntity.notFound().build());
    }

    // Dev-only: reset agent2 credentials (password=agent1234, role=AGENT,
    // active=true)
    @PostMapping("/debug/reset-agent2")
    public ResponseEntity<?> resetAgent() {
        User user = userRepository.findByEmail("agent2@example.com").orElseGet(() -> {
            User u = new User();
            u.setEmail("agent2@example.com");
            u.setUsername("agent2");
            u.setFirstName("Agent");
            u.setLastName("Deux");
            return u;
        });
        user.setPassword(passwordEncoder.encode("agent1234"));
        user.setRole(User.Role.AGENT);
        user.setIsActive(true);
        userRepository.save(user);
        return ResponseEntity.ok(java.util.Map.of("status", "reset-ok"));
    }
}
