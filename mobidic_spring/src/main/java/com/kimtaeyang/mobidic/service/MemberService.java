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
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.UUID;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.DUPLICATED_NICKNAME;
import static com.kimtaeyang.mobidic.code.AuthResponseCode.NO_MEMBER;

@Service
@Slf4j
@RequiredArgsConstructor
public class MemberService {
    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtBlacklistService jwtBlacklistService;
    private final AuthService authService;

    @Transactional(readOnly = true)
    @PreAuthorize("@memberAccessHandler.ownershipCheck(#memberId)")
    public MemberDto getMemberDetailById(UUID memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ApiException(NO_MEMBER));

        return MemberDto.fromEntity(member);
    }

    @Transactional
    @PreAuthorize("@memberAccessHandler.ownershipCheck(#memberId)")
    public UpdateNicknameDto.Response updateMemberNickname(
            UUID memberId, UpdateNicknameDto.Request request
    ) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ApiException(NO_MEMBER));

        memberRepository.findByNickname(request.getNickname())
                        .ifPresent((m) -> { throw new ApiException(DUPLICATED_NICKNAME); });

        member.setNickname(request.getNickname());
        member = memberRepository.save(member);

        return UpdateNicknameDto.Response.builder()
                .nickname(member.getNickname())
                .id(member.getId())
                .build();
    }

    @Transactional
    @PreAuthorize("@memberAccessHandler.ownershipCheck(#memberId)")
    public UpdatePasswordDto.Response updateMemberPassword(
            UUID memberId, UpdatePasswordDto.Request request, String token
    ) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ApiException(NO_MEMBER));

        member.setPassword(passwordEncoder.encode(request.getPassword()));
        memberRepository.save(member);

        authService.logout(memberId, token);

        return UpdatePasswordDto.Response.builder()
                .id(member.getId())
                .build();
    }

    @Transactional
    @PreAuthorize("@memberAccessHandler.ownershipCheck(#memberId)")
    public WithdrawMemberDto.Response withdrawMember(String token, UUID memberId) {
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
    @PreAuthorize("@memberAccessHandler.ownershipCheck(#memberId)")
    public WithdrawMemberDto.Response deleteMember(String token, UUID memberId) {
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
}
