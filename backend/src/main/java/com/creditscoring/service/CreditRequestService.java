package com.creditscoring.service;

import com.creditscoring.dto.CreateCreditRequestDTO;
import com.creditscoring.dto.CreditRequestDTO;
import com.creditscoring.dto.UserDTO;
import com.creditscoring.entity.CreditRequest;
import com.creditscoring.entity.User;
import com.creditscoring.repository.CreditRequestRepository;
import com.creditscoring.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class CreditRequestService {
    
    @Autowired
    private CreditRequestRepository creditRequestRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private AIService aiService;
    
    private User getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        return userRepository.findByEmail(email)
            .orElseThrow(() -> new RuntimeException("User not found"));
    }
    
    @Transactional
    public CreditRequestDTO createRequest(CreateCreditRequestDTO dto) {
        User user = getCurrentUser();
        
        CreditRequest request = new CreditRequest();
        request.setUser(user);
        request.setRequestNumber("REQ-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        request.setAmountRequested(dto.getAmountRequested());
        request.setPurpose(dto.getPurpose());
        request.setEmploymentStatus(dto.getEmploymentStatus());
        request.setMonthlyIncome(dto.getMonthlyIncome());
        request.setEmploymentDurationMonths(dto.getEmploymentDurationMonths());
        request.setCurrentDebt(dto.getCurrentDebt());
        request.setCreditHistoryMonths(dto.getCreditHistoryMonths());
        request.setAge(dto.getAge());
        request.setMaritalStatus(dto.getMaritalStatus());
        request.setDependents(dto.getDependents());
        request.setPropertyOwned(dto.getPropertyOwned());
        request.setEducationLevel(dto.getEducationLevel());
        request.setStatus(CreditRequest.RequestStatus.PENDING);
        
        // Appel au service IA
        var aiResult = aiService.calculateScore(dto);
        request.setAiScore(new BigDecimal(aiResult.get("score").toString()));
        request.setAiConfidence(new BigDecimal(aiResult.get("confidence").toString()));
        
        request = creditRequestRepository.save(request);
        return convertToDTO(request);
    }
    
    public List<CreditRequestDTO> getUserRequests() {
        User user = getCurrentUser();
        return creditRequestRepository.findByUser(user)
            .stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }
    
    public CreditRequestDTO getRequestById(Long id) {
        User user = getCurrentUser();
        CreditRequest request = creditRequestRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Request not found"));
        
        // Vérifier que l'utilisateur peut accéder à cette demande
        if (!user.getRole().equals(User.Role.ADMIN) && 
            !user.getRole().equals(User.Role.AGENT) && 
            !request.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Access denied");
        }
        
        return convertToDTO(request);
    }
    
    public List<CreditRequestDTO> getPendingRequests() {
        return creditRequestRepository.findByStatus(CreditRequest.RequestStatus.PENDING)
            .stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }
    
    public List<CreditRequestDTO> getAllRequests() {
        return creditRequestRepository.findAll()
            .stream()
            .map(this::convertToDTO)
            .collect(Collectors.toList());
    }
    
    private CreditRequestDTO convertToDTO(CreditRequest request) {
        CreditRequestDTO dto = new CreditRequestDTO();
        dto.setId(request.getId());
        dto.setRequestNumber(request.getRequestNumber());
        dto.setAmountRequested(request.getAmountRequested());
        dto.setPurpose(request.getPurpose());
        dto.setEmploymentStatus(request.getEmploymentStatus());
        dto.setMonthlyIncome(request.getMonthlyIncome());
        dto.setEmploymentDurationMonths(request.getEmploymentDurationMonths());
        dto.setCurrentDebt(request.getCurrentDebt());
        dto.setCreditHistoryMonths(request.getCreditHistoryMonths());
        dto.setAge(request.getAge());
        dto.setMaritalStatus(request.getMaritalStatus());
        dto.setDependents(request.getDependents());
        dto.setPropertyOwned(request.getPropertyOwned());
        dto.setEducationLevel(request.getEducationLevel());
        dto.setAiScore(request.getAiScore());
        dto.setAiConfidence(request.getAiConfidence());
        dto.setFinalScore(request.getFinalScore());
        dto.setStatus(request.getStatus().name());
        dto.setValidatedAt(request.getValidatedAt());
        dto.setRejectionReason(request.getRejectionReason());
        dto.setCreatedAt(request.getCreatedAt());
        
        if (request.getAgent() != null) {
            dto.setAgentId(request.getAgent().getId());
        }
        
        UserDTO userDTO = new UserDTO();
        userDTO.setId(request.getUser().getId());
        userDTO.setEmail(request.getUser().getEmail());
        userDTO.setFirstName(request.getUser().getFirstName());
        userDTO.setLastName(request.getUser().getLastName());
        dto.setUser(userDTO);
        
        return dto;
    }
}

