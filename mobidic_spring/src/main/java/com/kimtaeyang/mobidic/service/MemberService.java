package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.MemberDto;
import com.kimtaeyang.mobidic.dto.UpdateNicknameDto;
import com.kimtaeyang.mobidic.dto.UpdatePasswordDto;
import com.kimtaeyang.mobidic.dto.WithdrawMemberDto;
import com.kimtaeyang.mobidic.entity.Member;
import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.repository.MemberRepository;
import com.kimtaeyang.mobidic.security.JwtBlacklistService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.UUID;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.*;

@Service
@Slf4j
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtBlacklistService jwtBlacklistService;

    @Transactional(readOnly = true)
    public MemberDto getMemberDetailById(UUID memberId) {
        authorizeMember(memberId);

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ApiException(NO_MEMBER));

        return MemberDto.fromEntity(member);
    }

    @Transactional
    public UpdateNicknameDto.Response updateMemberNickname(
            UUID memberId, UpdateNicknameDto.Request request
    ) {
        authorizeMember(memberId);

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ApiException(NO_MEMBER));

        memberRepository.findByNickname(request.getNickname())
                        .ifPresent((m) -> { throw new ApiException(DUPLICATED_NICKNAME); });

        member.setNickname(request.getNickname());
        memberRepository.save(member);

        return UpdateNicknameDto.Response.builder()
                .nickname(member.getNickname())
                .id(member.getId())
                .build();
    }

    @Transactional
    public UpdatePasswordDto.Response updateMemberPassword(
            UUID memberId, UpdatePasswordDto.Request request
    ) {
        authorizeMember(memberId);

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ApiException(NO_MEMBER));

        member.setPassword(passwordEncoder.encode(request.getPassword()));
        memberRepository.save(member);

        return UpdatePasswordDto.Response.builder()
                .id(member.getId())
                .build();
    }

    @Transactional
    public WithdrawMemberDto.Response withdrawMember(String token, UUID memberId) {
        authorizeMember(memberId);

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ApiException(NO_MEMBER));

        member.setWithdrawnAt(Timestamp.valueOf(LocalDateTime.now()));
        member.setIsActive(false);
        memberRepository.save(member);

        jwtBlacklistService.withdrawToken(token);
        SecurityContextHolder.clearContext();

        return WithdrawMemberDto.Response.builder()
                .withdrawnAt(member.getWithdrawnAt())
                .email(member.getEmail())
                .nickname(member.getNickname())
                .createdAt(member.getCreatedAt())
                .build();
    }

    @Transactional
    public WithdrawMemberDto.Response deleteMember(String token, UUID memberId) {
        authorizeMember(memberId);

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ApiException(NO_MEMBER));
        memberRepository.deleteById(memberId);

        jwtBlacklistService.withdrawToken(token);
        SecurityContextHolder.clearContext();

        return WithdrawMemberDto.Response.builder()
                .createdAt(member.getCreatedAt())
                .withdrawnAt(Timestamp.valueOf(LocalDateTime.now()))
                .email(member.getEmail())
                .nickname(member.getNickname())
                .build();
    }

    private void authorizeMember(UUID memberId) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        UUID currentId = ((Member) auth.getPrincipal()).getId();
        if (!memberId.equals(currentId)) {
            throw new ApiException(UNAUTHORIZED);
        }
    }
}
