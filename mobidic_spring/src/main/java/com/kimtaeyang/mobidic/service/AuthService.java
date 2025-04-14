package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.JoinDto;
import com.kimtaeyang.mobidic.dto.LoginDto;
import com.kimtaeyang.mobidic.dto.LogoutDto;
import com.kimtaeyang.mobidic.entity.Member;
import com.kimtaeyang.mobidic.repository.MemberRepository;
import com.kimtaeyang.mobidic.security.JwtBlacklistService;
import com.kimtaeyang.mobidic.security.JwtUtil;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

@Service
@Slf4j
@RequiredArgsConstructor
public class AuthService {
    private final AuthenticationManager authenticationManager;
    private final MemberRepository memberRepository;
    private final JwtUtil jwtUtil;
    private final PasswordEncoder passwordEncoder;
    private final JwtBlacklistService jwtBlacklistService;

    @Transactional(readOnly = true)
    public String login(LoginDto.Request request) {
        Authentication auth = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        Member claim = (Member) auth.getPrincipal();

        return jwtUtil.generateToken(claim.getId());
    }

    @Transactional
    public JoinDto.Response join(@Valid JoinDto.Request request) {
        Member member = Member.builder()
                .email(request.getEmail())
                .nickname(request.getNickname())
                .password(passwordEncoder.encode(request.getPassword()))
                .build();

        return JoinDto.Response.fromEntity(memberRepository.save(member));
    }

    public LogoutDto.Response logout(UUID token) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Member curretMember = (Member) auth.getPrincipal();

        auth.setAuthenticated(false);

        LogoutDto.Response response = LogoutDto.Response.builder()
                .id(curretMember.getId())
                .build();

        jwtBlacklistService.logoutToken(token.toString());

        return response;
    }
}