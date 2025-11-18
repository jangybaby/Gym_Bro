package com.gymbro.repository;

import com.gymbro.model.Member;
import com.gymbro.model.Plan;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MemberRepository extends JpaRepository<Member, Long> {

    // For filtering by plan
    List<Member> findByPlan(Plan plan);

    // For searching member name
    List<Member> findByFullNameContainingIgnoreCase(String name);
}
