package org.jpa;

import jakarta.persistence.*;

import java.util.HashSet;
import java.util.Set;

@Entity
public class Category {
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int CategoryId;
	private String CategoryName;

	@OneToMany
	@JoinColumn(name = "CATEGORY_FK")
	private Set<Product> products = new HashSet<>();

	public Category() {
		// required by Hibernate
	}

	public Category(String categoryName) {
		CategoryName = categoryName;
	}

	public void addProduct(Product product) {
		this.products.add(product);
		product.setCategory(this);
	}

	public boolean containsProduct(Product product) {
		return this.products.contains(product);
	}

	public Set<Product> getProducts() {
		return products;
	}

	public String getCategoryName() {
		return CategoryName;
	}
}
