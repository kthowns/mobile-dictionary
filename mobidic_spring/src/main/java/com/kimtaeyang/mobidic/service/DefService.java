package com.kimtaeyang.mobidic.service;

import com.kimtaeyang.mobidic.dto.AddDefDto;
import com.kimtaeyang.mobidic.dto.DefDto;
import com.kimtaeyang.mobidic.entity.Def;
import com.kimtaeyang.mobidic.entity.Member;
import com.kimtaeyang.mobidic.entity.Word;
import com.kimtaeyang.mobidic.exception.ApiException;
import com.kimtaeyang.mobidic.repository.DefRepository;
import com.kimtaeyang.mobidic.repository.WordRepository;
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
import static com.kimtaeyang.mobidic.code.GeneralResponseCode.*;

@Service
@Slf4j
@RequiredArgsConstructor
public class DefService {
    private final WordRepository wordRepository;
    private final DefRepository defRepository;

    @Transactional
    public AddDefDto.Response addDef(UUID wordId, AddDefDto.Request request) {
        Word word = wordRepository.findById(wordId)
                .orElseThrow(() -> new ApiException(NO_WORD));
        authorizeWord(word);

        defRepository.findByDefinition(request.getDefinition())
                .ifPresent((d) -> {
                    throw new ApiException(DUPLICATED_DEFINITION);
                });

        Def def = Def.builder()
                .word(word)
                .part(request.getPart())
                .definition(request.getDefinition())
                .build();
        defRepository.save(def);

        return AddDefDto.Response.fromEntity(def);
    }

    @Transactional(readOnly = true)
    public List<DefDto> getDefsByWordId(UUID wordId) {
        Word word = wordRepository.findById(wordId)
                .orElseThrow(() -> new ApiException(NO_WORD));
        authorizeWord(word);

        return defRepository.findByWord(word)
                .stream().map(DefDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    public AddDefDto.Response updateDef(UUID defId, AddDefDto.Request request) {
        Def def = defRepository.findById(defId)
                .orElseThrow(() -> new ApiException(NO_DEF));
        authorizeDef(def);

        defRepository.findByDefinition(request.getDefinition())
                .ifPresent((d) -> { throw new ApiException(DUPLICATED_DEFINITION); });

        def.setDefinition(request.getDefinition());
        def.setPart(request.getPart());
        defRepository.save(def);

        return AddDefDto.Response.fromEntity(def);
    }

    @Transactional
    public DefDto deleteDef(UUID defId) {
        Def def = defRepository.findById(defId)
                .orElseThrow(() -> new ApiException(NO_DEF));
        authorizeDef(def);

        defRepository.delete(def);

        return DefDto.fromEntity(def);
    }

    private void authorizeDef(Def def) {
        if (!def.getWord().getVocab().getMember().getId().equals(getCurrentMemberId())) {
            throw new ApiException(UNAUTHORIZED);
        }
    }

    private void authorizeWord(Word word) {
        if (!word.getVocab().getMember().getId().equals(getCurrentMemberId())) {
            throw new ApiException(UNAUTHORIZED);
        }
    }

    private UUID getCurrentMemberId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        return ((Member) auth.getPrincipal()).getId();
    }
}
