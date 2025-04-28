package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.dto.AddDefDto;
import com.kimtaeyang.mobidic.dto.DefDto;
import com.kimtaeyang.mobidic.dto.GeneralResponse;
import com.kimtaeyang.mobidic.service.DefService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.OK;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/def")
@Tag(name = "뜻 관련 서비스", description = "단어 별 뜻 불러오기, 추가, 수정 등")
public class DefController {
    private final DefService defService;

    @Operation(
            summary = "뜻 추가",
            description = "단어 식별자를 통한 뜻 추가",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @PostMapping("/{wordId}")
    public ResponseEntity<GeneralResponse<AddDefDto.Response>> addDef(
            @PathVariable String wordId,
            @RequestBody @Valid AddDefDto.Request request
    ) {
        return GeneralResponse.toResponseEntity(OK,
                defService.addDef(UUID.fromString(wordId), request));
    }

    @Operation(
            summary = "뜻 조회",
            description = "단어 식별자를 통한 모든 뜻 조회",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @GetMapping("/all")
    public ResponseEntity<GeneralResponse<List<DefDto>>> getDefsByWordId(
            @RequestParam String wId
    ) {
        return GeneralResponse.toResponseEntity(OK,
                defService.getDefsByWordId(UUID.fromString(wId)));
    }

    @Operation(
            summary = "뜻 수정",
            description = "뜻 식별자를 통한 표현과 품사 수정",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @PatchMapping("/{defId}")
    public ResponseEntity<GeneralResponse<AddDefDto.Response>> updateDef(
            @PathVariable String defId,
            @RequestBody @Valid AddDefDto.Request request
    ){
        return GeneralResponse.toResponseEntity(OK,
                defService.updateDef(UUID.fromString(defId), request));
    }

    @Operation(
            summary = "뜻 삭제",
            description = "",
            security = @SecurityRequirement(name = "bearerAuth")
    )
    @DeleteMapping("/{defId}")
    public ResponseEntity<GeneralResponse<DefDto>> deleteDef(
            @PathVariable String defId
    ) {
        return GeneralResponse.toResponseEntity(OK,
                defService.deleteDef(UUID.fromString(defId)));
    }
}
