package com.creditscoring.config;

import com.creditscoring.entity.User;
import com.creditscoring.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.security.crypto.password.PasswordEncoder;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        final String agentEmail = "agent2@example.com";

        userRepository.findByEmail(agentEmail).ifPresentOrElse(existing -> {
            // Ensure role and password are correct for agent
            existing.setRole(User.Role.AGENT);
            existing.setIsActive(true);
            existing.setPassword(passwordEncoder.encode("agent1234"));
            if (existing.getUsername() == null || existing.getUsername().isBlank()) {
                existing.setUsername("agent2");
            }
            if (existing.getFirstName() == null || existing.getFirstName().isBlank()) {
                existing.setFirstName("Agent");
            }
            if (existing.getLastName() == null || existing.getLastName().isBlank()) {
                existing.setLastName("Deux");
            }
            userRepository.save(existing);
        }, () -> {
            User agent = new User();
            agent.setUsername("agent2");
            agent.setEmail(agentEmail);
            agent.setPassword(passwordEncoder.encode("agent1234"));
            agent.setFirstName("Agent");
            agent.setLastName("Deux");
            agent.setPhone("0600000000");
            agent.setRole(User.Role.AGENT);
            agent.setIsActive(true);
            userRepository.save(agent);
        });
    }
}
