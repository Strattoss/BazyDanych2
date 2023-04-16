package org.jpa;

import jakarta.persistence.*;
import jdk.jfr.Frequency;

@Entity
@SecondaryTable(name = "ADDRESS")
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public class Company {
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	int CompanyId;
	String CompanyName;

	@Column(table = "ADDRESS")
	String Street;
	@Column(table = "ADDRESS")
	String City;
	@Column(table = "ADDRESS")
	String ZipCode;

	public Company() {
		// required by Hibernate
	}

	public Company(String companyName, String street, String city, String zipCode) {
		CompanyName = companyName;
		Street = street;
		City = city;
		ZipCode = zipCode;
	}
}
