package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.AddVocabDto;
import com.kimtaeyang.mobidic.dto.UpdateVocabDto;
import com.kimtaeyang.mobidic.dto.VocabDto;
import com.kimtaeyang.mobidic.entity.Member;
import com.kimtaeyang.mobidic.entity.Vocab;
import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.repository.MemberRepository;
import com.kimtaeyang.mobidic.repository.VocabRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.UNAUTHORIZED;
import static com.kimtaeyang.mobidic.code.GeneralResponseCode.NO_VOCAB;

@Service
@Slf4j
@RequiredArgsConstructor
public class VocabService {
    private final VocabRepository vocabRepository;

    @Transactional
    public AddVocabDto.Response addVocab(
            UUID memberId,
            AddVocabDto.@Valid Request request
    ) {
        authorizeMember(memberId);
        Vocab vocab = Vocab.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .member(Member.builder()
                        .id(memberId)
                        .build())
                .build();
        vocab = vocabRepository.save(vocab);

        return AddVocabDto.Response.builder()
                .id(vocab.getId())
                .title(vocab.getTitle())
                .description(vocab.getDescription())
                .build();
    }

    @Transactional(readOnly = true)
    public List<VocabDto> getVocabsByMemberId(UUID memberId) {
        authorizeMember(memberId);

        return vocabRepository.findByMember(Member.builder().id(memberId).build())
                .stream().map((vocab) -> VocabDto.builder()
                        .title(vocab.getTitle())
                        .memberId(vocab.getMember().getId())
                        .id(vocab.getId())
                        .description(vocab.getDescription())
                        .createdAt(vocab.getCreatedAt())
                        .build()
        ).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public VocabDto getVocabById(UUID vId) {
        Vocab vocab = vocabRepository.findById(vId)
                .orElseThrow(() -> new ApiException(NO_VOCAB));
        authorizeMember(vocab.getMember().getId());
        authorizeVocab(vocab);

        return VocabDto.builder()
                .id(vocab.getId())
                .memberId(vocab.getMember().getId())
                .title(vocab.getTitle())
                .description(vocab.getDescription())
                .createdAt(vocab.getCreatedAt())
                .build();
    }

    @Transactional
    public UpdateVocabDto.Response updateVocab(UUID vocabId, UpdateVocabDto.Request request) {
        Vocab vocab = vocabRepository.findById(vocabId)
                .orElseThrow(() -> new ApiException(NO_VOCAB));
        authorizeMember(vocab.getMember().getId());
        authorizeVocab(vocab);

        vocab.setTitle(request.getTitle());
        vocab.setDescription(request.getDescription());
        vocab = vocabRepository.save(vocab);

        return UpdateVocabDto.Response.builder()
                .id(vocab.getId())
                .title(vocab.getTitle())
                .description(vocab.getDescription())
                .build();
    }

    @Transactional
    public VocabDto deleteVocab(UUID vocabId) {
        Vocab vocab = vocabRepository.findById(vocabId)
                .orElseThrow(() -> new ApiException(NO_VOCAB));
        authorizeMember(vocab.getMember().getId());
        authorizeVocab(vocab);

        vocabRepository.delete(vocab);

        return VocabDto.builder()
                .id(vocab.getId())
                .memberId(vocab.getMember().getId())
                .title(vocab.getTitle())
                .description(vocab.getDescription())
                .build();
    }

    private void authorizeMember(UUID memberId) {
        if (!getCurrentMemberId().equals(memberId)) {
            throw new ApiException(UNAUTHORIZED);
        }
    }

    private void authorizeVocab(Vocab vocab) {
        if (!getCurrentMemberId().equals(vocab.getMember().getId())) {
            throw new ApiException(UNAUTHORIZED);
        }
    }

    private UUID getCurrentMemberId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        return ((Member) auth.getPrincipal()).getId();
    }
}