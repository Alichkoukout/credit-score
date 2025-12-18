package com.creditscoring.repository;

import com.creditscoring.entity.ValidationAction;
import com.creditscoring.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ValidationActionRepository extends JpaRepository<ValidationAction, Long> {
    List<ValidationAction> findByAgent(User agent);
    List<ValidationAction> findByRequestId(Long requestId);
}

