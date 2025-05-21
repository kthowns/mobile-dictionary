package com.kimtaeyang.mobidic.repository;

import com.kimtaeyang.mobidic.entity.Rate;
import com.kimtaeyang.mobidic.entity.Vocab;
import com.kimtaeyang.mobidic.entity.Word;
import io.lettuce.core.dynamic.annotation.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;
import java.util.UUID;

public interface RateRepository extends JpaRepository<Rate, UUID> {
    @Query("select (1.0*sum(r.isLearned)) / count(w)"+
            " from Word w join Rate r"+
            " on w = r.word"+
            " where w.vocab = :vocab")
    Optional<Double> getVocabLearningRate(@Param("vocab") Vocab vocab);

    Optional<Rate> findRateByWord(Word word);

    @Modifying
    @Query("update Rate r " +
            " set r.correctCount = r.correctCount + 1" +
            " where r.word = :word")
    void increaseCorrectCount(@Param("word") Word word);

    @Modifying
    @Query("update Rate r " +
            " set r.incorrectCount = r.incorrectCount + 1" +
            " where r.word = :word")
    void increaseIncorrectCount(@Param("word") Word word);
}
