package com.creditscoring.repository;

import com.creditscoring.entity.CreditRequest;
import com.creditscoring.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface CreditRequestRepository extends JpaRepository<CreditRequest, Long> {
    List<CreditRequest> findByUser(User user);
    List<CreditRequest> findByStatus(CreditRequest.RequestStatus status);
    List<CreditRequest> findByAgent(User agent);
    Optional<CreditRequest> findByRequestNumber(String requestNumber);
}

