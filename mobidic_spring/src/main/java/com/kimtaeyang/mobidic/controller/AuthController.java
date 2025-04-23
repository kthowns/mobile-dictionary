package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.dto.GeneralResponse;
import com.kimtaeyang.mobidic.dto.JoinDto;
import com.kimtaeyang.mobidic.dto.LoginDto;
import com.kimtaeyang.mobidic.dto.LogoutDto;
import com.kimtaeyang.mobidic.security.JwtUtil;
import com.kimtaeyang.mobidic.service.AuthService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
@Tag(name = "인증 관련 서비스", description = "로그인, 회원가입 등")
public class AuthController {
    private final AuthService authService;
    private final JwtUtil jwtUtil;

    @PostMapping("/login")
    public ResponseEntity<GeneralResponse<String>> login(@Valid @RequestBody LoginDto.Request request) {
        return GeneralResponse.toResponseEntity(LOGIN_OK, authService.login(request));
    }

    @PostMapping("/join")
    public ResponseEntity<GeneralResponse<JoinDto.Response>> join(@Valid @RequestBody JoinDto.Request request) {
        return GeneralResponse.toResponseEntity(JOIN_OK, authService.join(request));
    }

    @PostMapping("/logout")
    public ResponseEntity<GeneralResponse<LogoutDto.Response>> logout(HttpServletRequest request) {
        String token = request.getHeader("Authorization").substring(7);
        UUID memberId = jwtUtil.getIdFromToken(token);

        return GeneralResponse.toResponseEntity(LOGOUT_OK, authService.logout(memberId, token));
    }
}