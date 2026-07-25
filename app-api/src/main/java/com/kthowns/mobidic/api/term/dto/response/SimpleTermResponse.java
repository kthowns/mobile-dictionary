package com.kthowns.mobidic.api.term.dto.response;

import com.kthowns.mobidic.domain.term.model.SimpleTerm;
import com.kthowns.mobidic.domain.term.model.TermType;

import java.time.Instant;

public record SimpleTermResponse(
        Long id,
        TermType type,
        String version,
        boolean required,
        String contentUri,
        Instant createdAt,
        Instant updatedAt
) {
    public static SimpleTermResponse fromModel(SimpleTerm simpleTerm) {
        return new SimpleTermResponse(
                simpleTerm.id(),
                simpleTerm.type(),
                simpleTerm.version(),
                simpleTerm.required(),
                simpleTerm.contentUri(),
                simpleTerm.auditTime().createdAt(),
                simpleTerm.auditTime().updatedAt()
        );
    }
}
