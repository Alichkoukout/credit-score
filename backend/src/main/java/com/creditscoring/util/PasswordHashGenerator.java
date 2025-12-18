package com.creditscoring.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Utilitaire pour générer des hash BCrypt pour les mots de passe
 * Utilise ce code pour préparer ton dataset avec des mots de passe hashés
 */
public class PasswordHashGenerator {

    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        // Exemples de génération de hash
        String[] passwords = { "password123", "admin2024", "user123", "agent456" };

        System.out.println("=== Hash BCrypt pour ton dataset ===\n");

        for (String password : passwords) {
            String hash = encoder.encode(password);
            System.out.println("Mot de passe: " + password);
            System.out.println("Hash BCrypt:  " + hash);
            System.out.println();
        }

        // Pour tester si un mot de passe match un hash
        System.out.println("=== Test de validation ===");
        String testPassword = "password123";
        String testHash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy";
        boolean matches = encoder.matches(testPassword, testHash);
        System.out.println("Password: " + testPassword);
        System.out.println("Match: " + matches);
    }

    /**
     * Méthode pour générer un hash BCrypt depuis ton code
     */
    public static String hashPassword(String plainPassword) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        return encoder.encode(plainPassword);
    }
}
