package com.kimtaeyang.mobidic.dto;


import com.kimtaeyang.mobidic.entity.Def;
import com.kimtaeyang.mobidic.entity.Word;
import com.kimtaeyang.mobidic.type.Difficulty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class WordDetailDto {
    private UUID id;
    private UUID vocabId;
    private String expression;
    private Difficulty difficulty;
    private Timestamp createdAt;
    private List<Def> defs;

    public static WordDetailDto fromEntity (Word word, List<Def> defs, Difficulty difficulty) {
        return WordDetailDto.builder()
                .id(word.getId())
                .vocabId(word.getVocab().getId())
                .expression(word.getExpression())
                .difficulty(difficulty)
                .createdAt(word.getCreatedAt())
                .defs(defs)
                .build();
    }
}