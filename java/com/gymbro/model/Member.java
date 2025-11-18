package com.gymbro.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "members")
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String fullName;

    private String email;

    private String contactNumber;

    private LocalDate dateJoined;

    private LocalDate dateExpiration;

    @ManyToOne
    @JoinColumn(name = "plan_id")
    private Plan plan;

    public Member() {}

    public Member(String fullName, String email, String contactNumber, LocalDate dateJoined, LocalDate dateExpiration, Plan plan) {
        this.fullName = fullName;
        this.email = email;
        this.contactNumber = contactNumber;
        this.dateJoined = dateJoined;
        this.dateExpiration = dateExpiration;
        this.plan = plan;
    }

    public Long getId() {
        return id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public LocalDate getDateJoined() {
        return dateJoined;
    }

    public void setDateJoined(LocalDate dateJoined) {
        this.dateJoined = dateJoined;
    }

    public LocalDate getDateExpiration() {
        return dateExpiration;
    }

    public void setDateExpiration(LocalDate dateExpiration) {
        this.dateExpiration = dateExpiration;
    }

    public Plan getPlan() {
        return plan;
    }

    public void setPlan(Plan plan) {
        this.plan = plan;
    }
}
