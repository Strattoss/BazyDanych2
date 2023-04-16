package org.jpa;

import jakarta.persistence.*;

import java.util.HashSet;
import java.util.Set;

@Entity
public class Supplier extends Company{
	private String bankAccountNumber;

	@OneToMany
	@JoinColumn(name = "SUPPLIER_FK")
	private Set<Product> suppliedProducts = new HashSet<>();

	public Supplier() {
		// required by Hibernate
	}

	public Supplier(String companyName, String street, String city, String zipCode, String bankAccountNumber) {
		super(companyName, street, city, zipCode);
		this.bankAccountNumber = bankAccountNumber;
	}

	public void addProduct(Product product) {
		this.suppliedProducts.add(product);
		product.setSupplier(this);
	}

	public boolean suppliesProduct(Product product) {
		return this.suppliedProducts.contains(product);
	}

	public Set<Product> getSuppliedProducts() {
		return suppliedProducts;
	}

	public String getCompanyName() {
		return this.CompanyName;
	}
}
