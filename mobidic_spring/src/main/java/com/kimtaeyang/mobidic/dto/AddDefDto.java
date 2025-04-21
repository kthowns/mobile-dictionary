package com.kimtaeyang.mobidic.dto;

import com.kimtaeyang.mobidic.entity.Def;
import com.kimtaeyang.mobidic.type.PartOfSpeech;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

public class AddDefDto {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Request {
        @NotBlank
        @Size(max = 32, message = "Invalid definition pattern")
        private String definition;
        @NotBlank
        @Size(max = 10, message = "Invalid part pattern")
        private String part;
    }

    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Response {
        private UUID id;
        private String definition;
        private PartOfSpeech part;

        public static Response fromEntity (Def def) {
            return Response.builder()
                    .id(def.getId())
                    .definition(def.getDefinition())
                    .part(def.getPart())
                    .build();
        }
    }
}
/*

	id binary(16) [pk]
	word_id binary(16) [not null, ref:> word.id]//cascade : delete
	definition varchar(64) [not null]
	part varchar(16) [not null]
 */