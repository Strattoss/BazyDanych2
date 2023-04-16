package org.jpa;

import jakarta.persistence.*;

import java.util.HashSet;
import java.util.Set;

@Entity
public class Invoice {
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int InvoiceNumber;
	private int Quantity = 0;

	@ManyToMany
	private Set<Product> includedProducts = new HashSet<>();

	public Invoice() {
		// required by Hibernate
	}

	public void addProduct(Product product) {
		this.includedProducts.add(product);
		product.getCanBeSoldIn().add(this);
		this.Quantity += 1;
	}

	public Set<Product> getIncludedProducts() {
		return includedProducts;
	}

	public int getInvoiceNumber() {
		return InvoiceNumber;
	}
}
