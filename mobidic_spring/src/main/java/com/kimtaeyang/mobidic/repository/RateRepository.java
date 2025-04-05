package com.kimtaeyang.mobidic.repository;

import com.kimtaeyang.mobidic.entity.Rate;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface RateRepository extends JpaRepository<Rate, UUID> {
}
