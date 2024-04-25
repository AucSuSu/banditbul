package org.banditbul.bandi.toilet.repository;

import org.banditbul.bandi.toilet.entity.Toilet;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ToiletRepository extends JpaRepository<Toilet, Long> {
}
