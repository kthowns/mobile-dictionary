package com.kthowns.mobidic.api.user.dto.response;

import com.kthowns.mobidic.domain.user.model.User;
import com.kthowns.mobidic.domain.user.model.UserRole;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.UUID;

public record UserResponse(
        UUID id,
        String email,
        String nickname,
        UserRole role,
        boolean isActive,
        Instant createdAt,
        Instant updatedAt,
        LocalDateTime deactivatedAt
) {
    public static UserResponse fromModel(User user) {
        return new UserResponse(
                user.id(),
                user.email(),
                user.nickname(),
                user.role(),
                user.isActive(),
                user.auditTime().createdAt(),
                user.auditTime().updatedAt(),
                user.deactivatedAt()
        );
    }
}
