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
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import static com.kimtaeyang.mobidic.code.AuthResponseCode.NO_MEMBER;
import static com.kimtaeyang.mobidic.code.GeneralResponseCode.DUPLICATED_TITLE;
import static com.kimtaeyang.mobidic.code.GeneralResponseCode.NO_VOCAB;

@Service
@Slf4j
@RequiredArgsConstructor
public class VocabService {
    private final VocabRepository vocabRepository;
    private final MemberRepository memberRepository;

    @Transactional
    @PreAuthorize("@memberAccessHandler.ownershipCheck(#memberId)")
    public AddVocabDto.Response addVocab(
            UUID memberId,
            AddVocabDto.@Valid Request request
    ) {
        vocabRepository.findByTitle(request.getTitle())
                .ifPresent((v) -> { throw new ApiException(DUPLICATED_TITLE); });

        Vocab vocab = Vocab.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .member(Member.builder()
                        .id(memberId)
                        .build())
                .build();
        vocab = vocabRepository.save(vocab);

        return AddVocabDto.Response.fromEntity(vocab);
    }

    @Transactional(readOnly = true)
    @PreAuthorize("@memberAccessHandler.ownershipCheck(#memberId)")
    public List<VocabDto> getVocabsByMemberId(UUID memberId) {
        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new ApiException(NO_MEMBER));

        return vocabRepository.findByMember(member)
                .stream().map(VocabDto::fromEntity).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#vId)")
    public VocabDto getVocabById(UUID vId) {
        Vocab vocab = vocabRepository.findById(vId)
                .orElseThrow(() -> new ApiException(NO_VOCAB));

        return VocabDto.fromEntity(vocab);
    }

    @Transactional
    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#vocabId)")
    public UpdateVocabDto.Response updateVocab(UUID vocabId, UpdateVocabDto.Request request) {
        Vocab vocab = vocabRepository.findById(vocabId)
                .orElseThrow(() -> new ApiException(NO_VOCAB));

        vocabRepository.findByTitle(request.getTitle())
                .ifPresent((v) -> { throw new ApiException(DUPLICATED_TITLE); });

        vocab.setTitle(request.getTitle());
        vocab.setDescription(request.getDescription());
        vocab = vocabRepository.save(vocab);

        return UpdateVocabDto.Response.fromEntity(vocab);
    }

    @Transactional
    @PreAuthorize("@vocabAccessHandler.ownershipCheck(#vocabId)")
    public VocabDto deleteVocab(UUID vocabId) {
        Vocab vocab = vocabRepository.findById(vocabId)
                .orElseThrow(() -> new ApiException(NO_VOCAB));

        vocabRepository.delete(vocab);

        return VocabDto.fromEntity(vocab);
    }
}