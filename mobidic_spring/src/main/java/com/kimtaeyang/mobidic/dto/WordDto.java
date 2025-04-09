package com.kimtaeyang.mobidic.dto;

import com.kimtaeyang.mobidic.entity.Word;
import com.kimtaeyang.mobidic.type.Difficulty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class WordDto {
    private UUID id;
    private String expression;
    private Difficulty difficulty;
    private Timestamp createdAt;

    public static WordDto fromEntity (Word word, Difficulty difficulty) {
        return WordDto.builder()
                .id(word.getId())
                .expression(word.getExpression())
                .difficulty(difficulty)
                .createdAt(word.getCreatedAt())
                .build();
    }
}
