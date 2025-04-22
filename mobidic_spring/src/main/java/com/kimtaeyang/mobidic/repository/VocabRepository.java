package com.kimtaeyang.mobidic.repository;

import com.kimtaeyang.mobidic.entity.Member;
import com.kimtaeyang.mobidic.entity.Vocab;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface VocabRepository extends JpaRepository<Vocab, UUID> {
    List<Vocab> findByMember(Member member);

    Optional<Vocab> findByTitle(String title);

    int countByTitleAndIdNot(String title, UUID id);
}