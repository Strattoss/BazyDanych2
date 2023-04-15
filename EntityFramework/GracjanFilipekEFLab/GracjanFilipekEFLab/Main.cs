namespace GracjanFilipekEFLab
{
    class Program
    {
        static void Main(string[] args)
        {
            //AddToDatabase();

            //QuerryFromDatabase();

            ProductContext productContext = new ProductContext();

            ICollection<Invoice> invoices = new HashSet<Invoice>
            {
                new Invoice { },
                new Invoice { },
                new Invoice { },
            };

            ICollection<Product> products = new HashSet<Product>
            {
                new Product { ProductName = "Red tea", UnitsOnStock = 10},
                new Product { ProductName = "Green tea", UnitsOnStock = 10 },
                new Product { ProductName = "White tea", UnitsOnStock = 10 }
            };

            // connect invoices and products
            ICollection<InvoiceProduct> invoiceProducts = new HashSet<InvoiceProduct>
            {
                new InvoiceProduct { Invoice = invoices.ElementAt(0), Product = products.ElementAt(0), Quantity = 1},
                new InvoiceProduct { Invoice = invoices.ElementAt(0), Product = products.ElementAt(1), Quantity = 2},

                new InvoiceProduct { Invoice = invoices.ElementAt(1), Product = products.ElementAt(2), Quantity = 3},

                new InvoiceProduct { Invoice = invoices.ElementAt(2), Product = products.ElementAt(0), Quantity = 2},
                new InvoiceProduct { Invoice = invoices.ElementAt(2), Product = products.ElementAt(1), Quantity = 1},
                new InvoiceProduct { Invoice = invoices.ElementAt(2), Product = products.ElementAt(2), Quantity = 2},
            };

            // finalise each invoice
            foreach (var invProd in invoiceProducts)
            {
                invProd.Sell();
            }


            productContext.Invoices.AddRange(invoices);
            productContext.Products.AddRange(products);

            productContext.SaveChanges();

        }

        /*static void AddToDatabase()
        {
            ProductContext productContext = new ProductContext();

            ICollection<Customer> customers = new HashSet<Customer>
            {
                new Customer { City = "London", CompanyName = "Customer1", Discount = 0.2f, Street = "St. James", ZipCode = "00-000"},
                new Customer { City = "Paris", CompanyName = "Customer2", Discount = 0.0f, Street = "Trafalgar", ZipCode = "11-222"},
                new Customer { City = "Budapest", CompanyName = "Customer3", Discount = 0.1f, Street = "Rouge st.", ZipCode = "33-444"},
            };

            ICollection<Supplier> suppliers = new HashSet<Supplier>
            {
                new Supplier { City = "Phoenix", CompanyName = "Supplier1", BankAccountNumber = "0123456789012345", Street = "St. Pierre", ZipCode = "55-6666"},
                new Supplier { City = "Beijing", CompanyName = "Supplier2", BankAccountNumber = "3453453463242352", Street = "Tianan", ZipCode = "77-888"},
                new Supplier { City = "Nan Madol", CompanyName = "Supplier3", BankAccountNumber = "4673529174837284", Street = "Uloka", ZipCode = "99-999"},
            };

            productContext.Customers.AddRange(customers);
            productContext.Suppliers.AddRange(suppliers);

            productContext.SaveChanges();
        }


        static void QuerryFromDatabase()
        {
            ProductContext productContext = new ProductContext();

            var supp_query = from supp in productContext.Suppliers
                             select supp;

            Console.WriteLine("Suppliers:");
            foreach (var supplier in supp_query)
            {
                Console.WriteLine(supplier);
            }
            Console.WriteLine();


            var cust_query = from cust in productContext.Customers
                             select cust;

            Console.WriteLine("Customers");
            foreach (var cust in cust_query)
            {
                Console.WriteLine(cust);
            }
        }*/
    }
}

