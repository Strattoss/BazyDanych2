package org.jpa;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.EntityTransaction;
import jakarta.persistence.Persistence;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class JPA_Main {
	/*private static final EntityManagerFactory entityManagerFactory = Persistence.
			createEntityManagerFactory("derby");

	public static EntityManager getEntityManager() {
		return entityManagerFactory.createEntityManager();
	}

	public static void main(final String[] args) {
		writeToDatabase();
	}

	public static void writeToDatabase() {
		EntityManager entityManager = getEntityManager();
		EntityTransaction entityTransaction = entityManager.getTransaction();
		entityTransaction.begin();

		Supplier supplier = new Supplier("Fred's Automobiles", "Slimstone", "Petrograd");

		List<Product> products = new ArrayList<>(Arrays.asList(
				new Product("Orb of Winter", 7),
				new Product("Stone wheel", 4),
				new Product("Gummybear juice", 9),
				new Product("From Zero to Hero - guide for beginners", 6),
				new Product("Druid's Magic Duck", 13)
		));

		List<Category> categories = new ArrayList<>(Arrays.asList(
				new Category("Toys"),
				new Category("Magical artifacts"),
				new Category("Books")
		));

		List<Invoice> invoices = new ArrayList<>(Arrays.asList(
				new Invoice(),
				new Invoice()
		));


		// add products to appropriate categories
		categories.get(0).addProduct(products.get(1));

		categories.get(1).addProduct(products.get(0));
		categories.get(1).addProduct(products.get(2));
		categories.get(1).addProduct(products.get(4));

		categories.get(2).addProduct(products.get(3));

		// add products to supplier's supplied products
		for (Product product : products) {
			supplier.addProduct(product);
		}

		// add products to invoices
		invoices.get(0).addProduct(products.get(0));
		invoices.get(0).addProduct(products.get(2));
		invoices.get(0).addProduct(products.get(3));
		invoices.get(1).addProduct(products.get(2));
		invoices.get(1).addProduct(products.get(3));


		// persist all objects
		entityManager.persist(supplier);

		for (Category category : categories) {
			entityManager.persist(category);
		}

		for (Product product : products) {
			entityManager.persist(product);
		}

		for (Invoice invoice : invoices) {
			entityManager.persist(invoice);
		}

		entityTransaction.commit();
		entityManager.close();
	}

	public static void readProductsIncludedInInvoice() {
		EntityManager entityManager = getEntityManager();
		EntityTransaction entityTransaction = entityManager.getTransaction();
		entityTransaction.begin();

		Invoice invoice = entityManager.find(Invoice.class, 1);

		for (Product product : invoice.getIncludedProducts()) {
			System.out.println(product.getProductName());
		}

		entityTransaction.commit();
		entityManager.close();
	}

	public static void readInvoicesWhereProductWasSold() {
		EntityManager entityManager = getEntityManager();
		EntityTransaction entityTransaction = entityManager.getTransaction();
		entityTransaction.begin();

		Product product = entityManager.find(Product.class, 3);

		for (Invoice invoice : product.getCanBeSoldIn()) {
			System.out.println("Invoice id: " + invoice.getInvoiceNumber());
		}

		entityTransaction.commit();
		entityManager.close();
	}

	public static void readProductsFromCategory() {
		EntityManager entityManager = getEntityManager();
		EntityTransaction entityTransaction = entityManager.getTransaction();
		entityTransaction.begin();

		Category category = entityManager.find(Category.class, 2);
		System.out.println(category.getCategoryName());

		for (Product product : category.getProducts()) {
			System.out.println(product.getProductName());
		}

		entityTransaction.commit();
		entityManager.close();
	}

	public static void readCategoryFromProduct() {
		EntityManager entityManager = getEntityManager();
		EntityTransaction entityTransaction = entityManager.getTransaction();
		entityTransaction.begin();

		Product product = entityManager.find(Product.class, 2);
		System.out.println(product.getCategory().getCategoryName());

		entityTransaction.commit();
		entityManager.close();
	}*/
}
