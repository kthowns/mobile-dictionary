package com.kimtaeyang.mobidic.dto;

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
public class VocabDto {
    private UUID id;
    private UUID memberId;
    private String title;
    private String description;
    private Timestamp createdAt;
}
