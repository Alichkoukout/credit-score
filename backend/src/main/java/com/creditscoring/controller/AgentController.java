package com.creditscoring.controller;

import com.creditscoring.dto.CreditRequestDTO;
import com.creditscoring.dto.ValidationRequestDTO;
import com.creditscoring.service.CreditRequestService;
import com.creditscoring.service.ValidationService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/agent")
public class AgentController {

    @Autowired
    private CreditRequestService creditRequestService;

    @Autowired
    private ValidationService validationService;

    @GetMapping("/pending-requests")
    public ResponseEntity<List<CreditRequestDTO>> getPendingRequests() {
        List<CreditRequestDTO> requests = creditRequestService.getPendingRequests();
        return ResponseEntity.ok(requests);
    }

    @GetMapping("/requests")
    public ResponseEntity<List<CreditRequestDTO>> getAllRequests() {
        List<CreditRequestDTO> requests = creditRequestService.getAllRequests();
        return ResponseEntity.ok(requests);
    }

    @GetMapping("/requests/{id}")
    public ResponseEntity<CreditRequestDTO> getRequest(@PathVariable Long id) {
        CreditRequestDTO request = creditRequestService.getRequestById(id);
        return ResponseEntity.ok(request);
    }

    @PostMapping("/requests/{id}/validate")
    public ResponseEntity<Void> validateRequest(@PathVariable Long id,
            @Valid @RequestBody ValidationRequestDTO dto) {
        validationService.validateRequest(id, dto);
        return ResponseEntity.ok().build();
    }
}
