package org.jpa;

import jakarta.persistence.*;

@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public class Company {
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	int CompanyId;
	String CompanyName;

	String Street;
	String City;
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
