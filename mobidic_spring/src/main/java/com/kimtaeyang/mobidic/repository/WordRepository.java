package com.kimtaeyang.mobidic.repository;

import com.kimtaeyang.mobidic.entity.Vocab;
import com.kimtaeyang.mobidic.entity.Word;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface WordRepository extends JpaRepository<Word, UUID> {
    List<Word> findByVocab(Vocab vocab);

    Optional<Word> findByExpression(String expression);
}
