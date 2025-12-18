package com.creditscoring.service;

import com.creditscoring.dto.ValidationRequestDTO;
import com.creditscoring.entity.CreditRequest;
import com.creditscoring.entity.User;
import com.creditscoring.entity.ValidationAction;
import com.creditscoring.repository.CreditRequestRepository;
import com.creditscoring.repository.UserRepository;
import com.creditscoring.repository.ValidationActionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;

@Service
public class ValidationService {
    
    @Autowired
    private CreditRequestRepository creditRequestRepository;
    
    @Autowired
    private ValidationActionRepository validationActionRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    private User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        return userRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("User not found"));
    }
    
    @Transactional
    public void validateRequest(Long requestId, ValidationRequestDTO dto) {
        User agent = getCurrentUser();
        CreditRequest request = creditRequestRepository.findById(requestId)
            .orElseThrow(() -> new RuntimeException("Request not found"));
        
        // Créer l'action de validation
        ValidationAction action = new ValidationAction();
        action.setRequest(request);
        action.setAgent(agent);
        action.setAiScore(request.getAiScore());
        action.setOriginalScore(request.getAiScore());
        action.setFinalScore(dto.getFinalScore());
        action.setJustification(dto.getJustification());
        action.setActionType(ValidationAction.ActionType.valueOf(dto.getActionType()));
        
        validationActionRepository.save(action);
        
        // Mettre à jour la demande
        request.setFinalScore(dto.getFinalScore());
        request.setAgent(agent);
        request.setValidatedAt(LocalDateTime.now());
        request.setStatus(CreditRequest.RequestStatus.TREATED);
        
        if (dto.getActionType().equals("REJECTED")) {
            request.setRejectionReason(dto.getJustification());
        }
        
        creditRequestRepository.save(request);
    }
}

