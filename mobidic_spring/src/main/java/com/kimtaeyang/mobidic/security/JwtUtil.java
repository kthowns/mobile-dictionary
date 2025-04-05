package com.kimtaeyang.mobidic.security;

import com.kimtaeyang.mobidic.config.JwtProperties;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.UUID;

@Component
@Slf4j
@RequiredArgsConstructor
public class JwtUtil {
    private final JwtProperties jwtProperties;

    public String generateToken(String userId) {
        return Jwts.builder()
                    .subject(userId)
                    .issuedAt(new Date())
                    .expiration(new Date(System.currentTimeMillis() + jwtProperties.getJwtExp()))
                    .signWith(jwtProperties.getSecretKey())
                    .compact();
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                    .verifyWith(jwtProperties.getSecretKey())
                    .build()
                    .parseSignedClaims(token);
            return true;
        } catch (Exception e) {
            Date date = new Date();
            log.error("Invalid JWT token inspected : {} {}", e.getMessage(), date);
            return false;
        }
    }

    public UUID getIdFromToken(String token) {
        Claims claims = Jwts.parser()
                .verifyWith(jwtProperties.getSecretKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
        return UUID.fromString(claims.getSubject());
    }

    public Date getExpirationFromToken(String token) {
        Claims claims = Jwts.parser()
                .verifyWith(jwtProperties.getSecretKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();

        return claims.getExpiration();
    }
}
