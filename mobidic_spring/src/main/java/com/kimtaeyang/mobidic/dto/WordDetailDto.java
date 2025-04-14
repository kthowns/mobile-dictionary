package com.kimtaeyang.mobidic.dto;

import com.kimtaeyang.mobidic.entity.Def;
import com.kimtaeyang.mobidic.entity.Word;
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
    private String expression;
    private Timestamp createdAt;
    private List<Def> defs;

    public static WordDetailDto fromEntity(Word word, List<Def> definitions) {
        return WordDetailDto.builder()
                .id(word.getId())
                .expression(word.getExpression())
                .createdAt(word.getCreatedAt())
                .defs(definitions)
                .build();
    }
}
