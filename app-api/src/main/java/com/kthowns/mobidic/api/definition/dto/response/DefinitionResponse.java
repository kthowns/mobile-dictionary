package com.kthowns.mobidic.api.definition.dto.response;

import com.kthowns.mobidic.domain.definition.model.Definition;
import com.kthowns.mobidic.domain.definition.model.PartOfSpeech;

import java.time.Instant;
import java.util.UUID;

public record DefinitionResponse(
        UUID id,
        UUID wordId,
        String meaning,
        PartOfSpeech part,
        Instant createdAt,
        Instant updatedAt
) {
    public static DefinitionResponse fromModel(Definition definition) {
        return new DefinitionResponse(
                definition.id(),
                definition.wordId(),
                definition.meaning(),
                definition.part(),
                definition.auditTime().createdAt(),
                definition.auditTime().updatedAt()
        );
    }
}
