package com.kthowns.mobidic.api.auth.service;

import com.kthowns.mobidic.api.auth.dto.request.LoginRequest;
import com.kthowns.mobidic.api.auth.dto.response.LoginResponse;
import com.kthowns.mobidic.security.model.AuthUser;
import com.kthowns.mobidic.security.util.JwtProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final AuthenticationManager authenticationManager;
    private final JwtProvider jwtProvider;

    public LoginResponse login(LoginRequest request) {
        Authentication auth = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.email(), request.password())
        );

        AuthUser authUser = (AuthUser) auth.getPrincipal();

        return new LoginResponse(jwtProvider.generateToken(authUser.getId(), authUser.getRole()));
    }
}
