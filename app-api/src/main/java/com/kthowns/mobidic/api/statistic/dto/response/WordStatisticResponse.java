package com.kthowns.mobidic.api.statistic.dto.response;

import com.kthowns.mobidic.domain.statistic.model.WordStatistic;

import java.time.Instant;
import java.util.UUID;

public record WordStatisticResponse(
        UUID wordId,
        long correctCount,
        long incorrectCount,
        boolean isLearned,
        double difficulty,
        double accuracy,
        Instant createdAt,
        Instant updatedAt
) {

    public static WordStatisticResponse fromModel(WordStatistic wordStatistic) {
        return new WordStatisticResponse(
                wordStatistic.wordId(),
                wordStatistic.correctCount(),
                wordStatistic.incorrectCount(),
                wordStatistic.isLearned(),
                wordStatistic.difficulty(),
                wordStatistic.accuracy(),
                wordStatistic.auditTime().createdAt(),
                wordStatistic.auditTime().updatedAt()
        );
    }
}
