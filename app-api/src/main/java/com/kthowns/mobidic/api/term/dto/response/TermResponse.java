package com.kthowns.mobidic.api.term.dto.response;

import com.kthowns.mobidic.domain.term.model.Term;
import com.kthowns.mobidic.domain.term.model.TermType;

import java.time.Instant;

public record TermResponse(
        Long id,
        TermType type,
        String version,
        boolean required,
        String content,
        Instant createdAt,
        Instant updatedAt
) {
    public static TermResponse fromModel(Term term) {
        return new TermResponse(
                term.id(),
                term.type(),
                term.version(),
                term.required(),
                term.content(),
                term.auditTime().createdAt(),
                term.auditTime().updatedAt()
        );
    }
}
