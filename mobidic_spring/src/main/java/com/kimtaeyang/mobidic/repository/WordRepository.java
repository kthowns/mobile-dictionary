package com.kimtaeyang.mobidic.repository;

import com.kimtaeyang.mobidic.entity.Word;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface WordRepository extends JpaRepository<Word, UUID> {
}
