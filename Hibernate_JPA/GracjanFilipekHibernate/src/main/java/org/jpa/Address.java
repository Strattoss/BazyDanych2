package org.jpa;

import jakarta.persistence.Embeddable;
import jakarta.persistence.Id;

@Embeddable
public class Address {
	private String city;
	private String street;
	private String zipCode;

	public Address() {

	}

	public Address(String city, String street, String zipCode) {
		this.city = city;
		this.street = street;
		this.zipCode = zipCode;
	}
}
