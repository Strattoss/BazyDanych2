package org.jpa;

import jakarta.persistence.*;

import java.util.HashSet;
import java.util.Set;

@Entity
@SecondaryTable(name = "ADDRESS")
public class Supplier {
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int SupplierId;
	private String CompanyName;

	@Column(table = "ADDRESS")
	private String Street;
	@Column(table = "ADDRESS")
	private String City;
	@Column(table = "ADDRESS")
	private String ZipCode;

	@OneToMany
	@JoinColumn(name = "SUPPLIER_FK")
	private Set<Product> suppliedProducts = new HashSet<>();

	public Supplier() {
		// required by Hibernate
	}

	public Supplier(String companyName, String street, String city, String zipCode) {
		CompanyName = companyName;
		Street = street;
		City = city;
		ZipCode = zipCode;
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
