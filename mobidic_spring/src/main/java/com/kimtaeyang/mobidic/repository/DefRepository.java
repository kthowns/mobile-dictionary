package com.kimtaeyang.mobidic.repository;

import com.kimtaeyang.mobidic.entity.Def;
import com.kimtaeyang.mobidic.entity.Word;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface DefRepository extends JpaRepository<Def, UUID> {
    List<Def> findByWord(Word word);

    int countByDefinitionAndIdNot(String definition, UUID id);

    int countByDefinition(String definition);
}
