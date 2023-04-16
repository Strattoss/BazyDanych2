package org.jpa;

import jakarta.persistence.*;

import java.util.HashSet;
import java.util.Set;

@Entity
public class Supplier {
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int SupplierId;
	private String CompanyName;
	@Embedded
	Address address;

	@OneToMany
	@JoinColumn(name = "SUPPLIER_FK")
	private Set<Product> suppliedProducts = new HashSet<>();

	public Supplier() {
		// required by Hibernate
	}

	public Supplier(String companyName, Address address) {
		CompanyName = companyName;
		this.address = address;
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
		return CompanyName;
	}
}
