package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.dto.ApiResponse;
import com.kimtaeyang.mobidic.dto.UpdateNicknameDto;
import com.kimtaeyang.mobidic.dto.UpdatePasswordDto;
import com.kimtaeyang.mobidic.service.MemberService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.OK;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/api/user")
public class MemberController {
    private final MemberService memberService;

    @GetMapping("/detail/{memberId}")
    public ResponseEntity<?> getMemberDetail(
            @PathVariable @Valid String memberId
    ) {
        return ApiResponse.toResponseEntity(OK,
                memberService.getMemberDetailById(UUID.fromString(memberId)));
    }

    @PatchMapping("/nckchn/{memberId}")
    public ResponseEntity<?> updateMemberNickname(
            @PathVariable String memberId,
            @RequestBody @Valid UpdateNicknameDto.Request request
    ) {
        return ApiResponse.toResponseEntity(OK,
                memberService.updateMemberNickname(UUID.fromString(memberId), request));
    }

    @PatchMapping("/pschn/{memberId}")
    public ResponseEntity<?> updateMemberPassword(
            @PathVariable String memberId,
            @RequestBody @Valid UpdatePasswordDto.Request request
    ){
        return ApiResponse.toResponseEntity(OK,
                memberService.updateMemberPassword(UUID.fromString(memberId), request));
    }

    @PatchMapping("/withdraw/{memberId}")
    public ResponseEntity<?> withdrawMember(
            @PathVariable String memberId,
            HttpServletRequest request
    ){
        String token = request.getHeader("Authorization").substring(7);

        return ApiResponse.toResponseEntity(OK,
                memberService.withdrawMember(token, UUID.fromString(memberId)));
    }

    @DeleteMapping("/delete/{memberId}")
    public ResponseEntity<?> deleteMember(
            @PathVariable String memberId,
            HttpServletRequest servletRequest
    ){
        String token = servletRequest.getHeader("Authorization").substring(7);

        return ApiResponse.toResponseEntity(OK,
                memberService.deleteMember(token, UUID.fromString(memberId)));
    }
}
