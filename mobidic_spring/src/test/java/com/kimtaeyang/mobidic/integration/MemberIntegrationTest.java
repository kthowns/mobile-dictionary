package com.kimtaeyang.mobidic.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kimtaeyang.mobidic.dto.JoinDto;
import com.kimtaeyang.mobidic.dto.LoginDto;
import com.kimtaeyang.mobidic.dto.UpdateNicknameDto;
import com.kimtaeyang.mobidic.dto.UpdatePasswordDto;
import com.kimtaeyang.mobidic.repository.MemberRepository;
import com.kimtaeyang.mobidic.security.JwtUtil;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.util.UUID;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.UNAUTHORIZED;
import static com.kimtaeyang.mobidic.code.GeneralResponseCode.INVALID_REQUEST_BODY;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class MemberIntegrationTest {
    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private JwtUtil jwtUtil;

    @AfterEach
    void tearDown() {
        memberRepository.deleteAll();
    }

    private final JoinDto.Request joinRequest = JoinDto.Request.builder()
            .email("test@test.com")
            .nickname("test")
            .password("testTest1")
            .build();

    private final LoginDto.Request loginRequest = LoginDto.Request.builder()
            .email(joinRequest.getEmail())
            .password(joinRequest.getPassword())
            .build();

    @Test
    @DisplayName("[Member][Integration] Get member detail")
    void getMemberDetailTest() throws Exception {
        String token = loginAndGetToken();
        UUID memberId = jwtUtil.getIdFromToken(token);

        //Success
        mockMvc.perform(get("/api/user/detail")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + token)
                        .param("uId", memberId.toString()))
                .andExpect(status().isOk())
                .andExpect(
                        jsonPath("$.data.id")
                                .value(memberId.toString()))
                .andExpect(
                        jsonPath("$.data.email")
                                .value(joinRequest.getEmail()))
                .andExpect(
                        jsonPath("$.data.nickname")
                                .value(joinRequest.getNickname()))
                .andExpect(
                        jsonPath("$.data.createdAt")
                                .isNotEmpty());

        //Fail without token
        mockMvc.perform(get("/api/user/detail/" + memberId)
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isUnauthorized())
                .andExpect(
                        jsonPath("$.message")
                                .value(UNAUTHORIZED.getMessage()));

        //Fail with unauthorized token
        mockMvc.perform(get("/api/user/detail")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + jwtUtil.generateToken(UUID.randomUUID()))
                        .param("uId", memberId.toString()))
                .andExpect(status().isUnauthorized())
                .andExpect(
                        jsonPath("$.message")
                                .value(UNAUTHORIZED.getMessage()));

        //Fail with no resource
        mockMvc.perform(get("/api/user/detail")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + jwtUtil.generateToken(UUID.randomUUID()))
                        .param("uId", UUID.randomUUID().toString()))
                .andExpect(status().isUnauthorized())
                .andExpect(
                        jsonPath("$.message")
                                .value(UNAUTHORIZED.getMessage()));
    }

    @Test
    @DisplayName("[Member][Integration] Update member nickname")
    void updateMemberNicknameTest() throws Exception {
        JoinDto.Request joinRequest = JoinDto.Request.builder()
                .email("test@test.com")
                .nickname("test")
                .password("testTest1")
                .build();

        mockMvc.perform(post("/api/auth/join")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(joinRequest)))
                .andExpect(status().isOk());

        LoginDto.Request loginRequest = LoginDto.Request.builder()
                .email(joinRequest.getEmail())
                .password(joinRequest.getPassword())
                .build();

        MvcResult loginResult = mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andReturn();

        String json = loginResult.getResponse().getContentAsString();
        String token = objectMapper.readTree(json).get("data").asText();
        UUID memberId = jwtUtil.getIdFromToken(token);

        //Success
        UpdateNicknameDto.Request updateNicknameRequest = UpdateNicknameDto.Request.builder()
                .nickname(joinRequest.getNickname() + "test")
                .build();

        mockMvc.perform(patch("/api/user/nckchn/" + memberId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + token)
                        .content(objectMapper.writeValueAsString(updateNicknameRequest)))
                .andExpect(status().isOk())
                .andExpect(
                        jsonPath("$.data.id")
                                .value(memberId.toString()))
                .andExpect(
                        jsonPath("$.data.nickname")
                                .value(updateNicknameRequest.getNickname()));

        mockMvc.perform(get("/api/user/detail")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + token)
                        .param("uId", memberId.toString()))
                .andExpect(status().isOk())
                .andExpect(
                        jsonPath("$.data.nickname")
                                .value(updateNicknameRequest.getNickname()));

        //Fail without token
        mockMvc.perform(patch("/api/user/nckchn/" + memberId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updateNicknameRequest)))
                .andExpect(status().isUnauthorized())
                .andExpect(
                        jsonPath("$.message")
                                .value(UNAUTHORIZED.getMessage()));

        //Fail with unauthorized token
        mockMvc.perform(patch("/api/user/nckchn/" + memberId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + jwtUtil.generateToken(UUID.randomUUID()))
                        .content(objectMapper.writeValueAsString(updateNicknameRequest)))
                .andExpect(status().isUnauthorized())
                .andExpect(
                        jsonPath("$.message")
                                .value(UNAUTHORIZED.getMessage()));

        //Fail with no resource
        mockMvc.perform(patch("/api/user/nckchn/" + UUID.randomUUID())
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + token)
                        .content(objectMapper.writeValueAsString(updateNicknameRequest)))
                .andExpect(status().isUnauthorized())
                .andExpect(
                        jsonPath("$.message")
                                .value(UNAUTHORIZED.getMessage()));

        //Fail with invalid nickname pattern
        updateNicknameRequest.setNickname(joinRequest.getNickname() + "testqweqweqqq");
        mockMvc.perform(patch("/api/user/nckchn/" + memberId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + token)
                        .content(objectMapper.writeValueAsString(updateNicknameRequest)))
                .andExpect(status().isBadRequest())
                .andExpect(
                        jsonPath("$.message")
                                .value(INVALID_REQUEST_BODY.getMessage()))
                .andExpect(
                        jsonPath("$.errors.nickname")
                                .value("Invalid nickname pattern"));

    }

    @Test
    @DisplayName("[Member][Integration] Update member password")
    void updateMemberPasswordTest() throws Exception {
        String token = loginAndGetToken();
        UUID memberId = jwtUtil.getIdFromToken(token);

        UpdatePasswordDto.Request updatePasswordRequest = UpdatePasswordDto.Request.builder()
                .password("testTest2")
                .build();

        //Fail without token
        mockMvc.perform(patch("/api/user/pschn/" + memberId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updatePasswordRequest)))
                .andExpect(status().isUnauthorized())
                .andExpect(
                        jsonPath("$.message")
                                .value(UNAUTHORIZED.getMessage()));

        //Fail with unauthorized token
        mockMvc.perform(patch("/api/user/pschn/" + memberId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + jwtUtil.generateToken(UUID.randomUUID()))
                        .content(objectMapper.writeValueAsString(updatePasswordRequest)))
                .andExpect(status().isUnauthorized())
                .andExpect(
                        jsonPath("$.message")
                                .value(UNAUTHORIZED.getMessage()));

        //Fail with no resource
        mockMvc.perform(patch("/api/user/pschn/" + UUID.randomUUID())
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + token)
                        .content(objectMapper.writeValueAsString(updatePasswordRequest)))
                .andExpect(status().isUnauthorized())
                .andExpect(
                        jsonPath("$.message")
                                .value(UNAUTHORIZED.getMessage()));

        //Fail with invalid nickname pattern
        updatePasswordRequest.setPassword("test");
        mockMvc.perform(patch("/api/user/pschn/" + memberId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + token)
                        .content(objectMapper.writeValueAsString(updatePasswordRequest)))
                .andExpect(status().isBadRequest())
                .andExpect(
                        jsonPath("$.message")
                                .value(INVALID_REQUEST_BODY.getMessage()))
                .andExpect(
                        jsonPath("$.errors.password")
                                .value("Invalid password pattern"));

        updatePasswordRequest.setPassword("testTest2");

        //Success
        mockMvc.perform(patch("/api/user/pschn/" + memberId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + token)
                        .content(objectMapper.writeValueAsString(updatePasswordRequest)))
                .andExpect(status().isOk());

        mockMvc.perform(get("/api/user/detail")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", "Bearer " + token)
                        .param("uId", memberId.toString()))
                .andExpect(status().isUnauthorized())
                .andExpect(
                        jsonPath("$.message")
                                .value(UNAUTHORIZED.getMessage()));
    }

    private String loginAndGetToken() throws Exception {
        mockMvc.perform(post("/api/auth/join")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(joinRequest)))
                .andExpect(status().isOk());

        MvcResult loginResult = mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andReturn();

        String json = loginResult.getResponse().getContentAsString();
        return objectMapper.readTree(json).get("data").asText();
    }
}
// Resource api integration test convention
//Success
// -> OK
//Fail without token
// -> UNAUTHORIZED
//Fail with unauthorized token
// -> UNAUTHORIZED
//Fail with no resource
// -> UNAUTHORIZED
//Fail with invalid pattern
// -> INVALID_REQUEST_BODY