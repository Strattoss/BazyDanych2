package org.jpa;

import jakarta.persistence.*;

import java.util.HashSet;
import java.util.Set;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int ProductId;
    private String ProductName;
    private int UnitsOnStock;

    @ManyToOne
    @JoinColumn(name = "SUPPLIER_FK")
    private Supplier supplier;

    @ManyToOne
    @JoinColumn(name = "CATEGORY_FK")
    private Category category;

    @ManyToMany(mappedBy = "includedProducts", cascade = {CascadeType.PERSIST})
    private Set<Invoice> canBeSoldIn = new HashSet<>();

    public Product() {
    // required by Hibernate
    }

    public Product(String productName) {
        this(productName, 0);
    }

    public Product(String productName, int unitsOnStock) {
        this.ProductName = productName;
        this.UnitsOnStock = unitsOnStock;
    }

    public Product(String productName, int unitsOnStock, Supplier supplier) {
        ProductName = productName;
        UnitsOnStock = unitsOnStock;
        this.supplier = supplier;
    }

    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
        if (!this.supplier.suppliesProduct(this)) {
            this.supplier.addProduct(this);
        }
    }

    public void setCategory(Category category) {
        this.category = category;
        if (!this.category.containsProduct(this)) {
            category.addProduct(this);
        }
    }

    public Set<Invoice> getCanBeSoldIn() {
        return canBeSoldIn;
    }

    public Supplier getSupplier() {
        return supplier;
    }

    public Category getCategory() {
        return category;
    }

    public String getProductName() {
        return ProductName;
    }
}
