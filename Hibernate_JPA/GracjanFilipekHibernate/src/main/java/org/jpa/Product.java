package org.jpa;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class Product {
    @Id
    private String ProductName;
    private int UnitsOnStock;

    public Product() {

    }

    public Product(String productName) {
        this(productName, 0);
    }

    public Product(String productName, int unitsOnStock) {
        this.ProductName = productName;
        this.UnitsOnStock = unitsOnStock;
    }
}
