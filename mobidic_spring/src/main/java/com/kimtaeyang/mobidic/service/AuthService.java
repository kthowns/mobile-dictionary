package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.member.JoinDto;
import com.kimtaeyang.mobidic.dto.member.LoginDto;
import com.kimtaeyang.mobidic.dto.member.LogoutDto;
import com.kimtaeyang.mobidic.entity.Member;
import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.repository.MemberRepository;
import com.kimtaeyang.mobidic.security.JwtBlacklistService;
import com.kimtaeyang.mobidic.security.JwtUtil;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.DUPLICATED_EMAIL;
import static com.kimtaeyang.mobidic.code.GeneralResponseCode.DUPLICATED_NICKNAME;

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
    public LoginDto.Response login(LoginDto.Request request) {
        Authentication auth = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        Member member = (Member) auth.getPrincipal();

        return LoginDto.Response.builder()
                .memberId(member.getId().toString())
                .token(jwtUtil.generateToken(member.getId()))
                .build();
    }

    @Transactional
    public JoinDto.Response join(@Valid JoinDto.Request request) {
        if(memberRepository.countByNickname(request.getNickname()) > 0){
            throw new ApiException(DUPLICATED_NICKNAME);
        }

        if(memberRepository.countByEmail(request.getEmail()) > 0){
            throw new ApiException(DUPLICATED_EMAIL);
        }

        Member member = Member.builder()
                .email(request.getEmail())
                .nickname(request.getNickname())
                .password(passwordEncoder.encode(request.getPassword()))
                .build();

        return JoinDto.Response.fromEntity(memberRepository.save(member));
    }

    @PreAuthorize("@memberAccessHandler.ownershipCheck(#memberId)")
    public LogoutDto.Response logout(UUID memberId, String token) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        auth.setAuthenticated(false); //인증 Context 초기화

        LogoutDto.Response response = LogoutDto.Response.builder()
                .id(jwtUtil.getIdFromToken(token))
                .build();

        jwtBlacklistService.logoutToken(token); //Redis 블랙리스트에 토큰 추가

        return response;
    }
}