package com.kimtaeyang.mobidic.repository;

import com.kimtaeyang.mobidic.entity.Def;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface DefRepository extends JpaRepository<Def, UUID> {
}
