package com.kimtaeyang.mobidic.repository;

import com.kimtaeyang.mobidic.entity.Vocab;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface VocabRepository extends JpaRepository<Vocab, UUID> {

}