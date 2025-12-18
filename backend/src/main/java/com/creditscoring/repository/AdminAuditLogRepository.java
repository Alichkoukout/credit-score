package com.creditscoring.repository;

import com.creditscoring.entity.AdminAuditLog;
import com.creditscoring.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface AdminAuditLogRepository extends JpaRepository<AdminAuditLog, Long> {
    List<AdminAuditLog> findByAdmin(User admin);
}

