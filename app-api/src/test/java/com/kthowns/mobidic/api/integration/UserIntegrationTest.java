package com.kthowns.mobidic.api.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kthowns.mobidic.api.user.dto.request.SignUpRequestDto;
import com.kthowns.mobidic.api.user.dto.request.UpdateUserRequestDto;
import com.kthowns.mobidic.common.code.AuthResponseCode;
import com.kthowns.mobidic.common.code.GeneralResponseCode;
import com.kthowns.mobidic.domain.definition.model.PartOfSpeech;
import com.kthowns.mobidic.domain.user.model.User;
import com.kthowns.mobidic.domain.user.model.UserRole;
import com.kthowns.mobidic.domain.user.service.UserBlackListService;
import com.kthowns.mobidic.security.properties.JwtProperties;
import com.kthowns.mobidic.security.util.JwtProvider;
import com.kthowns.mobidic.storage.definition.jpaentity.DefinitionJpaEntity;
import com.kthowns.mobidic.storage.definition.jparepository.DefinitionJpaRepository;
import com.kthowns.mobidic.storage.preset.jpaentity.PresetDefinitionJpaEntity;
import com.kthowns.mobidic.storage.preset.jpaentity.PresetVocabularyJpaEntity;
import com.kthowns.mobidic.storage.preset.jpaentity.PresetWordJpaEntity;
import com.kthowns.mobidic.storage.preset.jparepository.PresetVocabularyJpaRepository;
import com.kthowns.mobidic.storage.user.jpaentity.UserJpaEntity;
import com.kthowns.mobidic.storage.user.jparepository.UserJpaRepository;
import com.kthowns.mobidic.storage.vocabulary.jpaentity.VocabularyJpaEntity;
import com.kthowns.mobidic.storage.vocabulary.jparepository.VocabularyJpaRepository;
import com.kthowns.mobidic.storage.word.jpaentity.WordJpaEntity;
import com.kthowns.mobidic.storage.word.jparepository.WordJpaRepository;
import io.jsonwebtoken.Jwts;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.support.TransactionTemplate;

import java.util.HashMap;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.BDDMockito.given;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * 사용자 정보 관련 통합 테스트
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class UserIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private JwtProvider jwtProvider;

    @Autowired
    private UserJpaRepository userJpaRepository;

    @Autowired
    private PresetVocabularyJpaRepository presetVocabularyJpaRepository;

    @Autowired
    private VocabularyJpaRepository vocabularyJpaRepository;

    @Autowired
    private WordJpaRepository wordJpaRepository;

    @Autowired
    private DefinitionJpaRepository definitionJpaRepository;

    @Autowired
    private EntityManager entityManager;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private TransactionTemplate transactionTemplate;

    @MockitoBean
    private UserBlackListService userBlackListService;

    private UserJpaEntity testUser;
    private String userToken;

    @BeforeEach
    void setup() {
        testUser = transactionTemplate.execute(status -> {
            UserJpaEntity user = userJpaRepository.save(UserJpaEntity.createFromModel(
                    User.create("test@test.com", "test", passwordEncoder.encode("password123!"), UserRole.USER)));
            return user;
        });

        userToken = jwtProvider.generateToken(testUser.getId(), testUser.getRole().name());
    }

    @AfterEach
    void tearDown() {
        transactionTemplate.execute(status -> {
            definitionJpaRepository.deleteAllInBatch();
            wordJpaRepository.deleteAllInBatch();
            vocabularyJpaRepository.deleteAllInBatch();
            presetVocabularyJpaRepository.deleteAllInBatch();
            userJpaRepository.deleteAllInBatch();
            return null;
        });
    }

    @Test
    @DisplayName("사용자 상세 정보 조회 성공")
    void getUserDetailsSuccess() throws Exception {
        // When
        mockMvc.perform(get("/api/users/me")
                        .header("Authorization", "Bearer " + userToken))
                // Then
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.email").value("test@test.com"))
                .andExpect(jsonPath("$.data.nickname").value("test"));
    }

    @Test
    @DisplayName("사용자 닉네임 수정 성공")
    void updateNicknameSuccess() throws Exception {
        // Given
        UpdateUserRequestDto request = new UpdateUserRequestDto("newnickname", null);

        // When
        mockMvc.perform(patch("/api/users/me")
                        .header("Authorization", "Bearer " + userToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                // Then
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.nickname").value("newnickname"));

        // Then
        UserJpaEntity updatedUser = userJpaRepository.findById(testUser.getId()).orElseThrow();
        assertThat(updatedUser.getNickname()).isEqualTo("newnickname");
    }

    @Test
    @DisplayName("사용자 닉네임 수정 실패 - 중복된 닉네임")
    void updateNicknameFailDuplicated() throws Exception {
        // Given
        userJpaRepository.save(UserJpaEntity.createFromModel(
                User.create("other@test.com", "other", "pass", UserRole.USER)));

        UpdateUserRequestDto request = new UpdateUserRequestDto("other", null);

        // When
        mockMvc.perform(patch("/api/users/me")
                        .header("Authorization", "Bearer " + userToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                // Then
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.message").value(GeneralResponseCode.DUPLICATED_NICKNAME.getMessage()));
    }

    @Test
    @DisplayName("사용자 비밀번호 수정 성공")
    void updatePasswordSuccess() throws Exception {
        // Given
        UpdateUserRequestDto request = new UpdateUserRequestDto(null, "newPassword123!");

        // When
        mockMvc.perform(patch("/api/users/me")
                        .header("Authorization", "Bearer " + userToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                // Then
                .andExpect(status().isOk());

        // Then
        UserJpaEntity updatedUser = userJpaRepository.findById(testUser.getId()).orElseThrow();
        assertThat(passwordEncoder.matches("newPassword123!", updatedUser.getPassword())).isTrue();
    }

    @Test
    @DisplayName("회원 탈퇴(비활성화) 성공")
    void withdrawSuccess() throws Exception {
        // When
        mockMvc.perform(delete("/api/users/me")
                        .header("Authorization", "Bearer " + userToken))
                // Then
                .andExpect(status().isOk());

        // Then
        UserJpaEntity deactivatedUser = userJpaRepository.findById(testUser.getId()).orElseThrow();
        assertThat(deactivatedUser.isActive()).isFalse();
        assertThat(deactivatedUser.getDeactivatedAt()).isNotNull();
    }

    @Test
    @DisplayName("보안 테스트 - 인증 토큰 없이 요청 시 실패")
    void securityFailNoToken() throws Exception {
        // When
        mockMvc.perform(get("/api/users/me"))
                // Then
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.message").value(AuthResponseCode.UNAUTHORIZED.getMessage()));
    }

    @Test
    @DisplayName("보안 테스트 - 잘못된 토큰으로 요청 시 실패")
    void securityFailInvalidToken() throws Exception {
        // When
        mockMvc.perform(get("/api/users/me")
                        .header("Authorization", "Bearer invalid-token"))
                // Then
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.message").value(AuthResponseCode.UNAUTHORIZED.getMessage()));
    }

    @Autowired
    private JwtProperties jwtProperties;

    @Test
    @DisplayName("보안 테스트 - 만료된 토큰으로 요청 시 실패")
    void securityFailExpiredToken() throws Exception {
        // Given
        String expiredToken = Jwts.builder()
                .subject(testUser.getId().toString())
                .claim("role", testUser.getRole().name())
                .issuedAt(new java.util.Date(System.currentTimeMillis() - 100000))
                .expiration(new java.util.Date(System.currentTimeMillis() - 50000))
                .signWith(jwtProperties.getSecretKey())
                .compact();

        // When
        mockMvc.perform(get("/api/users/me")
                        .header("Authorization", "Bearer " + expiredToken))
                // Then
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("보안 테스트 - 탈퇴한(비활성화된) 사용자 토큰으로 요청 시 실패")
    void securityFailDeactivatedUser() throws Exception {
        // Given
        transactionTemplate.execute(status -> {
            UserJpaEntity user = userJpaRepository.findById(testUser.getId()).orElseThrow();
            User deactivatedUser = user.toModel().deactivate();
            user.updateFromModel(deactivatedUser);
            userJpaRepository.save(user);
            return null;
        });

        // Mock 설정: 해당 유저 ID 조회 시 블랙리스트에 있다고 가정
        given(userBlackListService.isDeactivatedUser(testUser.getId())).willReturn(true);

        // When
        mockMvc.perform(get("/api/users/me")
                        .header("Authorization", "Bearer " + userToken))
                // Then
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("회원가입 성공 - 유효한 정보를 입력하면 새로운 사용자가 생성되고 프리셋 단어장, 단어, 뜻이 함께 복사 부여된다.")
    void signUpSuccess() throws Exception {
        // Given - 사전 프리셋 단어장, 단어, 뜻 저장
        transactionTemplate.execute(status -> {
            PresetVocabularyJpaEntity preset = PresetVocabularyJpaEntity.create("기초 단어장", "기초 단어장 설명", new java.util.ArrayList<>());
            entityManager.persist(preset);

            PresetWordJpaEntity word = PresetWordJpaEntity.create(preset, "apple", new java.util.ArrayList<>());
            entityManager.persist(word);

            PresetDefinitionJpaEntity definition = PresetDefinitionJpaEntity.create(word, "사과", PartOfSpeech.NOUN);
            entityManager.persist(definition);

            preset.getWords().add(word);
            word.getDefinitions().add(definition);

            entityManager.flush();
            return null;
        });

        SignUpRequestDto request = new SignUpRequestDto(
                "signup@test.com",
                "signupuser",
                "signupTest1!",
                List.of()
        );

        // When
        mockMvc.perform(post("/api/users/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                // Then
                .andExpect(status().isOk());

        // Then - 사용자 생성 검증
        UserJpaEntity savedUser = userJpaRepository.findByEmail("signup@test.com").orElseThrow();
        assertThat(savedUser.getNickname()).isEqualTo("signupuser");
        assertThat(passwordEncoder.matches("signupTest1!", savedUser.getPassword())).isTrue();

        // Then - 프리셋 단어장 복사 검증
        VocabularyJpaEntity userVocab = vocabularyJpaRepository.findAll().stream()
                .filter(v -> v.getUserId().equals(savedUser.getId()))
                .findFirst().orElseThrow();
        assertThat(userVocab.getTitle()).isEqualTo("기초 단어장");
        assertThat(userVocab.getWordCount()).isEqualTo(1);

        // Then - 프리셋 단어 복사 검증
        WordJpaEntity userWord = wordJpaRepository.findAll().stream()
                .filter(w -> w.getVocabulary().getId().equals(userVocab.getId()))
                .findFirst().orElseThrow();
        assertThat(userWord.getExpression()).isEqualTo("apple");

        // Then - 프리셋 뜻 복사 검증
        DefinitionJpaEntity userDef = definitionJpaRepository.findAll().stream()
                .filter(d -> d.getWord().getId().equals(userWord.getId()))
                .findFirst().orElseThrow();
        assertThat(userDef.getMeaning()).isEqualTo("사과");
        assertThat(userDef.getPart()).isEqualTo(PartOfSpeech.NOUN);
    }

    @Test
    @DisplayName("회원가입 실패 - 중복된 이메일로 가입할 수 없다.")
    void signUpFailDuplicatedEmail() throws Exception {
        // Given
        SignUpRequestDto request = new SignUpRequestDto(
                "test@test.com",
                "newnickname",
                "password123!",
                List.of()
        );

        // When
        mockMvc.perform(post("/api/users/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                // Then
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.message").value(GeneralResponseCode.DUPLICATED_EMAIL.getMessage()));
    }

    @Test
    @DisplayName("회원가입 실패 - 중복된 닉네임으로 가입할 수 없다.")
    void signUpFailDuplicatedNickname() throws Exception {
        // Given
        SignUpRequestDto request = new SignUpRequestDto(
                "newemail@test.com",
                "test",
                "password123!",
                List.of()
        );

        // When
        mockMvc.perform(post("/api/users/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                // Then
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.message").value(GeneralResponseCode.DUPLICATED_NICKNAME.getMessage()));
    }

    @Test
    @DisplayName("회원가입 실패 - 유효하지 않은 입력값(이메일, 닉네임, 비밀번호 형식)")
    void signUpFailInvalidInput() throws Exception {
        // Given
        SignUpRequestDto request = new SignUpRequestDto(
                "invalid-email",
                "a",
                "123",
                List.of()
        );

        HashMap<String, String> expectedErrors = new HashMap<>();
        expectedErrors.put("email", "유효하지 않은 이메일 형식입니다.");
        expectedErrors.put("nickname", "닉네임은 2~16자의 한글, 영문 소문자, 숫자, -, _ 만 사용할 수 있습니다.");
        expectedErrors.put("password", "비밀번호는 8~128자이며 영문자, 숫자, 특수문자(@$!%*?&)를 각각 1개 이상 포함해야 합니다.");

        // When
        mockMvc.perform(post("/api/users/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                // Then
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.message").value(GeneralResponseCode.INVALID_REQUEST_BODY.getMessage()))
                .andExpect(jsonPath("$.errors").value(expectedErrors));
    }
}
