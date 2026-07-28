package com.kthowns.mobidic.storage.preset.jpaentity;

import com.kthowns.mobidic.storage.global.jpaentity.BaseAuditingEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity
@Table(name = "preset_vocabularies")
public class PresetVocabularyJpaEntity extends BaseAuditingEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(columnDefinition = "BINARY(16)", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "description")
    private String description;

    @OneToMany(mappedBy = "vocabulary", fetch = FetchType.LAZY)
    private List<PresetWordJpaEntity> words;

    public static PresetVocabularyJpaEntity create(String title, String description, List<PresetWordJpaEntity> words) {
        PresetVocabularyJpaEntity entity = new PresetVocabularyJpaEntity();
        entity.title = title;
        entity.description = description;
        entity.words = words != null ? words : new java.util.ArrayList<>();
        return entity;
    }
}