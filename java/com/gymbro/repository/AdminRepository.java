package com.gymbro.repository;

import com.gymbro.model.Admin;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AdminRepository extends JpaRepository<Admin, Long> {

    // Custom finder for login
    Admin findByUsername(String username);
}
