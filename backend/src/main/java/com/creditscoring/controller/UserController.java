package com.creditscoring.controller;

import com.creditscoring.dto.CreateCreditRequestDTO;
import com.creditscoring.dto.CreditRequestDTO;
import com.creditscoring.service.CreditRequestService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private CreditRequestService creditRequestService;

    @PostMapping("/requests")
    public ResponseEntity<CreditRequestDTO> createRequest(@Valid @RequestBody CreateCreditRequestDTO dto) {
        CreditRequestDTO request = creditRequestService.createRequest(dto);
        return ResponseEntity.ok(request);
    }

    @GetMapping("/requests")
    public ResponseEntity<List<CreditRequestDTO>> getUserRequests() {
        List<CreditRequestDTO> requests = creditRequestService.getUserRequests();
        return ResponseEntity.ok(requests);
    }

    @GetMapping("/requests/{id}")
    public ResponseEntity<CreditRequestDTO> getRequest(@PathVariable Long id) {
        CreditRequestDTO request = creditRequestService.getRequestById(id);
        return ResponseEntity.ok(request);
    }
}
