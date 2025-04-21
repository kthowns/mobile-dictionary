package com.kimtaeyang.mobidic.controller;

import com.kimtaeyang.mobidic.dto.AddDefDto;
import com.kimtaeyang.mobidic.dto.ApiResponse;
import com.kimtaeyang.mobidic.service.DefService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

import static com.kimtaeyang.mobidic.code.GeneralResponseCode.OK;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("/api/def")
public class DefController {
    private final DefService defService;

    @PostMapping("/{wordId}")
    public ResponseEntity<?> addDef(
            @PathVariable String wordId,
            @RequestBody @Valid AddDefDto.Request request
    ) {
        return ApiResponse.toResponseEntity(OK,
                defService.addDef(UUID.fromString(wordId), request));
    }

    @GetMapping("/all")
    public ResponseEntity<?> getDefsByWordId(
            @RequestParam String wId
    ) {
        return ApiResponse.toResponseEntity(OK,
                defService.getDefsByWordId(UUID.fromString(wId)));
    }

    @PatchMapping("/{defId}")
    public ResponseEntity<?> updateDef(
            @PathVariable String defId,
            @RequestBody @Valid AddDefDto.Request request
    ){
        return ApiResponse.toResponseEntity(OK,
                defService.updateDef(UUID.fromString(defId), request));
    }

    @DeleteMapping("/{defId}")
    public ResponseEntity<?> deleteDef(
            @PathVariable String defId
    ) {
        return ApiResponse.toResponseEntity(OK,
                defService.deleteDef(UUID.fromString(defId)));
    }
}
