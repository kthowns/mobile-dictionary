package com.kthowns.mobidic.api.user.controller;

import com.kthowns.mobidic.api.global.dto.ErrorResponse;
import com.kthowns.mobidic.api.global.dto.GeneralResponse;
import com.kthowns.mobidic.api.user.dto.request.SignUpRequestDto;
import com.kthowns.mobidic.api.user.dto.request.UpdateUserRequestDto;
import com.kthowns.mobidic.api.user.dto.response.UserResponse;
import com.kthowns.mobidic.domain.user.facade.UserFacade;
import com.kthowns.mobidic.domain.user.model.User;
import com.kthowns.mobidic.domain.user.service.UserService;
import com.kthowns.mobidic.security.model.AuthUser;
import com.kthowns.mobidic.security.properties.JwtProperties;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static com.kthowns.mobidic.common.code.GeneralResponseCode.OK;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/users")
@Tag(name = "사용자 관련 서비스", description = "닉네임 및 패스워드 변경, 회원탈퇴 등")
public class UserController {
    private final UserService userService;
    private final UserFacade userFacade;
    private final JwtProperties jwtProperties;

    @Operation(
            summary = "현재사용자 정보 조회",
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
    @GetMapping("/me")
    public ResponseEntity<GeneralResponse<UserResponse>> getMe(
            @AuthenticationPrincipal AuthUser authUser
    ) {
        User user = userService.getUserById(authUser.getId());

        return GeneralResponse.toResponseEntity(OK, UserResponse.fromModel(user));
    }

    @Operation(
            summary = "사용자 정보 변경",
            description = "정보 변경, 닉네임 중복체크 있음",
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
            @ApiResponse(responseCode = "409", description = "중복된 요청",
                    content = @Content(schema = @Schema(hidden = true))),
            @ApiResponse(responseCode = "500", description = "서버 오류",
                    content = @Content(schema = @Schema(hidden = true)))
    })
    @PatchMapping("/me")
    public ResponseEntity<GeneralResponse<UserResponse>> updateMe(
            @RequestBody @Valid UpdateUserRequestDto request,
            @AuthenticationPrincipal AuthUser authUser
    ) {
        User user = userService.updateUser(authUser.getId(), request.nickname(), request.password());

        return GeneralResponse.toResponseEntity(OK, UserResponse.fromModel(user));
    }

    @Operation(
            summary = "회원 탈퇴",
            description = "완전 삭제는 아니며 계정 비활성화",
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
    @DeleteMapping("/me")
    public ResponseEntity<GeneralResponse<UserResponse>> deactivateUser(
            @AuthenticationPrincipal AuthUser authUser
    ) {
        User user = userService.deactivateUser(authUser.getId(), jwtProperties.getJwtAccessExp());

        return GeneralResponse.toResponseEntity(OK, UserResponse.fromModel(user));
    }

    @Operation(
            summary = "회원가입",
            description = "회원가입"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청",
                    content = @Content(schema = @Schema(implementation = ErrorResponse.class))),
            @ApiResponse(responseCode = "401", description = "인가되지 않은 요청",
                    content = @Content(schema = @Schema(hidden = true))),
            @ApiResponse(responseCode = "404", description = "존재하지 않는 리소스",
                    content = @Content(schema = @Schema(hidden = true))),
            @ApiResponse(responseCode = "409", description = "중복된 요청",
                    content = @Content(schema = @Schema(hidden = true))),
            @ApiResponse(responseCode = "500", description = "서버 오류",
                    content = @Content(schema = @Schema(hidden = true)))
    })
    @PostMapping("/signup")
    public ResponseEntity<GeneralResponse<Void>> signUp(@Valid @RequestBody SignUpRequestDto request) {
        userFacade.signUp(
                request.email(),
                request.nickname(),
                request.password(),
                request.agreeTermIds()
        );

        return GeneralResponse.toResponseEntity(OK, null);
    }
}
