package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.dto.response.ErrorResponse;
import com.kimtaeyang.mobidic.dto.response.GeneralResponse;
import com.kimtaeyang.mobidic.dto.quiz.QuizDto;
import com.kimtaeyang.mobidic.security.JwtUtil;
import com.kimtaeyang.mobidic.service.QuizService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.OK;

@Tag(name = "퀴즈 관련 서비스", description = "문제 생성 및 채점 등")
@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/quiz")
public class QuizController {
    private final QuizService quizService;
    private final JwtUtil jwtUtil;

    @Operation(
            summary = "단어 통계 조회",
            description = "단어 식별자를 통한 단어 통계 조회, 틀린 횟수 맞은 횟수 등",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class))),
            @ApiResponse(responseCode = "401", description = "인가되지 않은 요청",
                    content = @Content(schema = @Schema(hidden = true))),
            @ApiResponse(responseCode = "404", description = "존재하지 않는 리소스",
                    content = @Content(schema = @Schema(hidden = true))),
            @ApiResponse(responseCode = "500", description = "서버 오류",
                    content = @Content(schema = @Schema(hidden = true)))
    })
    @GetMapping("/ox")
    public ResponseEntity<GeneralResponse<QuizDto>> getOxQuiz(
            @RequestParam("vId") UUID vId,
            HttpServletRequest request
    ) {
        String token = request.getHeader("Authorization").substring(7);
        UUID memberId = jwtUtil.getIdFromToken(token);

        return GeneralResponse.toResponseEntity(OK,
                quizService.getOxQuiz(memberId, vId));
    }
}
