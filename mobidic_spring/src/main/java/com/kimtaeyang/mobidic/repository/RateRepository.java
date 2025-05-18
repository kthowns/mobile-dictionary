package com.kimtaeyang.mobidic.repository;

import com.kimtaeyang.mobidic.entity.Rate;
import com.kimtaeyang.mobidic.entity.Word;
import io.lettuce.core.dynamic.annotation.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;
import java.util.UUID;

public interface RateRepository extends JpaRepository<Rate, UUID> {
    @Query("select (1.0*sum(r.isLearned)) / count(w)"+
            " from Word w join Rate r"+
            " on w = r.word"+
            " where w.vocab.id = :vocabId")
    Optional<Double> getVocabLearningRate(@Param("vocab") UUID vocabId);

    Optional<Rate> findRateByWord(Word word);
}
