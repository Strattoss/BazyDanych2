package org.jpa;

import jakarta.persistence.*;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int ProductId;
    private String ProductName;
    private int UnitsOnStock;

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
}
