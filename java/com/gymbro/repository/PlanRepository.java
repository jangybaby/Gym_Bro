package com.gymbro.repository;

import com.gymbro.model.Plan;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PlanRepository extends JpaRepository<Plan, Long> {

    // For searching (optional)
    boolean existsByName(String name);
}
