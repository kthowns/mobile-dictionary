package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.dto.ApiResponse;
import com.kimtaeyang.mobidic.dto.JoinDto;
import com.kimtaeyang.mobidic.dto.LoginDto;
import com.kimtaeyang.mobidic.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.JOIN_OK;
import static com.kimtaeyang.mobidic.code.AuthResponseCode.LOGIN_OK;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginDto.Request request) {
        return ApiResponse.toResponseEntity(LOGIN_OK, authService.login(request));
    }

    @PostMapping("/join")
    public ResponseEntity<?> join(@Valid @RequestBody JoinDto.Request request) {
        authService.join(request);
        return ApiResponse.toResponseEntity(JOIN_OK, null);
    }
}