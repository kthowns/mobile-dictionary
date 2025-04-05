package com.kimtaeyang.mobidic.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

public class WithdrawMemberDto {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
    @Builder
    public static class Response {
        private String email;
        private String nickname;
        private Timestamp createdAt;
        private Timestamp withdrawnAt;
    }
}