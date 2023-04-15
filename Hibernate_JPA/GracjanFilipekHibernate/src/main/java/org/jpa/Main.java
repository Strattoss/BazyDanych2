package org.jpa;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

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
        try (Session session = getSession()) {
            Transaction transaction = session.beginTransaction();

            Supplier supplier = new Supplier("Fred's Automobiles", "Slimstone", "Petrograd");

            Set<Product> products = new HashSet<>(Arrays.asList(
                    new Product("Chocolate bar", 7),
                    new Product("Stone wheel", 4),
                    new Product("Gummybear juice", 9),
                    new Product("From Zero to Hero - guide for beginners", 6)
            ));

            // add products to supplier's supplied products
            for (Product product: products) {
                supplier.addProduct(product);
            }

            // persist object
            session.persist(supplier);
            for (Product product: products) {
                session.persist(product);
            }

            transaction.commit();
        }
    }
}

//Product dbProduct = session.get(Product.class, 1);