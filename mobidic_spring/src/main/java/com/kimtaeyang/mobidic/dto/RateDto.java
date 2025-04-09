package com.kimtaeyang.mobidic.dto;

import com.kimtaeyang.mobidic.entity.Rate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RateDto {
    private UUID wordId;
    private Integer correctCount;
    private Integer incorrectCount;
    private Integer isLearned;

    public static RateDto fromEntity(Rate rate) {
        return RateDto.builder()
                .wordId(rate.getWordId())
                .correctCount(rate.getCorrectCount())
                .incorrectCount(rate.getIncorrectCount())
                .isLearned(rate.getIsLearned())
                .build();
    }
}
