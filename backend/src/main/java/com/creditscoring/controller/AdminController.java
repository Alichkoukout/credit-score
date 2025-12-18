package com.creditscoring.controller;

import com.creditscoring.dto.CreditRequestDTO;
import com.creditscoring.dto.UserDTO;
import com.creditscoring.entity.AdminAuditLog;
import com.creditscoring.entity.User;
import com.creditscoring.repository.AdminAuditLogRepository;
import com.creditscoring.repository.UserRepository;
import com.creditscoring.service.CreditRequestService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CreditRequestService creditRequestService;

    @Autowired
    private AdminAuditLogRepository auditLogRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    private void logAction(String actionType, String entityType, Long entityId, String description,
            HttpServletRequest request) {
        AdminAuditLog log = new AdminAuditLog();
        log.setAdmin(getCurrentUser());
        log.setActionType(actionType);
        log.setEntityType(entityType);
        log.setEntityId(entityId);
        log.setDescription(description);
        log.setIpAddress(request.getRemoteAddr());
        log.setUserAgent(request.getHeader("User-Agent"));
        auditLogRepository.save(log);
    }

    @GetMapping("/users")
    public ResponseEntity<List<UserDTO>> getAllUsers() {
        List<UserDTO> users = userRepository.findAll()
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
        return ResponseEntity.ok(users);
    }

    @PostMapping("/users")
    public ResponseEntity<UserDTO> createUser(@Valid @RequestBody UserDTO userDTO, HttpServletRequest request) {
        User user = new User();
        user.setUsername(userDTO.getUsername());
        user.setEmail(userDTO.getEmail());
        user.setPassword(passwordEncoder.encode("password123")); // Default password
        user.setFirstName(userDTO.getFirstName());
        user.setLastName(userDTO.getLastName());
        user.setPhone(userDTO.getPhone());
        user.setRole(User.Role.valueOf(userDTO.getRole()));
        user.setIsActive(userDTO.getIsActive() != null ? userDTO.getIsActive() : true);

        user = userRepository.save(user);
        logAction("USER_CREATED", "users", user.getId(), "Created user: " + user.getEmail(), request);

        return ResponseEntity.ok(convertToDTO(user));
    }

    @PutMapping("/users/{id}")
    public ResponseEntity<UserDTO> updateUser(@PathVariable Long id,
            @Valid @RequestBody UserDTO userDTO,
            HttpServletRequest request) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setFirstName(userDTO.getFirstName());
        user.setLastName(userDTO.getLastName());
        user.setPhone(userDTO.getPhone());
        user.setRole(User.Role.valueOf(userDTO.getRole()));
        user.setIsActive(userDTO.getIsActive());

        user = userRepository.save(user);
        logAction("USER_UPDATED", "users", user.getId(), "Updated user: " + user.getEmail(), request);

        return ResponseEntity.ok(convertToDTO(user));
    }

    @DeleteMapping("/users/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id, HttpServletRequest request) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        userRepository.delete(user);
        logAction("USER_DELETED", "users", id, "Deleted user: " + user.getEmail(), request);

        return ResponseEntity.ok().build();
    }

    @GetMapping("/requests")
    public ResponseEntity<List<CreditRequestDTO>> getAllRequests() {
        List<CreditRequestDTO> requests = creditRequestService.getAllRequests();
        return ResponseEntity.ok(requests);
    }

    @GetMapping("/stats")
    public ResponseEntity<Object> getStats() {
        // Statistiques simples
        long totalUsers = userRepository.count();
        long totalRequests = creditRequestService.getAllRequests().size();

        return ResponseEntity.ok(java.util.Map.of(
                "totalUsers", totalUsers,
                "totalRequests", totalRequests));
    }

    private UserDTO convertToDTO(User user) {
        UserDTO dto = new UserDTO();
        dto.setId(user.getId());
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        dto.setFirstName(user.getFirstName());
        dto.setLastName(user.getLastName());
        dto.setPhone(user.getPhone());
        dto.setRole(user.getRole().name());
        dto.setIsActive(user.getIsActive());
        return dto;
    }
}
