package org.jpa;

import org.hibernate.*;
import org.hibernate.cfg.Configuration;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Main {
    private static final SessionFactory ourSessionFactory;

    static {
        try {
            Configuration configuration = new Configuration();
            configuration.configure();

            ourSessionFactory = configuration.buildSessionFactory();
        } catch (Throwable ex) {
            throw new ExceptionInInitializerError(ex);
        }
    }

    public static Session getSession() throws HibernateException {
        return ourSessionFactory.openSession();
    }

    public static void main(final String[] args) throws Exception {
        writeToDatabase();
    }

    public static void writeToDatabase() {
        try (Session session = getSession()) {
            Transaction transaction = session.beginTransaction();

            // creating objects
            List<Address> addresses = new ArrayList<>(Arrays.asList(
                    new Address("Petrograd", "Slimstone", "12-345"),
                    new Address("Burkoberg", "Mamma Mia", "67-890")
            ));

            List<Supplier> suppliers = new ArrayList<>(Arrays.asList(
                    new Supplier("Pikapol", "Petrograd", "Slimstone", "12-345", "1234567890123456"),
                    new Supplier("The Rolling Bowl", "Burkoberg", "Mamma Mia", "67-890", "0987654321098765"),
                    new Supplier("Profit as Huge as Inflation", "Burkoberg", "Mamma Mia", "67-890", "1647385694072539")
            ));

            List<Customer> customers = new ArrayList<>(Arrays.asList(
                    new Customer("John Lock's Stock", "London", "Drowning Street", "45-745", 0.3),
                    new Customer("Market Like Your Carpet", "Teheran", "Shah-Mat", "23-445", 0.2),
                    new Customer("Rejuvenation Home", "Athlantis", "Eldorado", "00-001", 0.18)
            ));

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
            suppliers.get(0).addProduct(products.get(0));
            suppliers.get(0).addProduct(products.get(3));

            suppliers.get(1).addProduct(products.get(2));

            suppliers.get(2).addProduct(products.get(1));
            suppliers.get(2).addProduct(products.get(4));

            // add products to invoices
            invoices.get(0).addProduct(products.get(0));
            invoices.get(0).addProduct(products.get(2));
            invoices.get(0).addProduct(products.get(3));
            invoices.get(1).addProduct(products.get(2));
            invoices.get(1).addProduct(products.get(3));


            // persist all objects
            for (Supplier supplier: suppliers) {
                session.persist(supplier);
            }

            for (Customer customer: customers) {
                session.persist(customer);
            }

            for (Category category: categories) {
                session.persist(category);
            }

            for (Product product: products) {
                session.persist(product);
            }
/*
            for (Invoice invoice: invoices) {
                session.persist(invoice);
            }
*/

            transaction.commit();
        }
    }

    /*
    public static void readProductsIncludedInInvoice() {
        try (Session session = getSession()) {
            Transaction transaction = session.beginTransaction();

            Invoice invoice = session.get(Invoice.class, 1);

            for (Product product : invoice.getIncludedProducts()) {
                System.out.println(product.getProductName());
            }

            transaction.commit();
        }
    }

    public static void readInvoicesWhereProductWasSold() {
        try (Session session = getSession()) {
            Transaction transaction = session.beginTransaction();

            Product product = session.get(Product.class, 3);

            for (Invoice invoice: product.getCanBeSoldIn()) {
                System.out.println("Invoice id: " + invoice.getInvoiceNumber());
            }

            transaction.commit();
        }
    }

    public static void readProductsFromCategory() {
        try (Session session = getSession()) {
            Transaction transaction = session.beginTransaction();

            Category category = session.get(Category.class, 2);
            System.out.println(category.getCategoryName());

            for (Product product : category.getProducts()) {
                System.out.println(product.getProductName());
            }

            transaction.commit();
        }
    }

    public static void readCategoryFromProduct() {
        try (Session session = getSession()) {
            Transaction transaction = session.beginTransaction();

            Product product = session.get(Product.class, 2);
            System.out.println(product.getCategory().getCategoryName());

            transaction.commit();
        }
    }*/
}
