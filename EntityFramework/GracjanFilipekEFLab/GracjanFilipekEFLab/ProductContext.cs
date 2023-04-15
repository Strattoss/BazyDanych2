using GracjanFilipekEFLab.Migrations;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;

namespace GracjanFilipekEFLab
{
    public class ProductContext: DbContext
    {
        public DbSet<Product> Products { get; set;}
        //public DbSet<Company> Companies { get; set; }
        //public DbSet<Supplier> Suppliers { get; set;}
        public DbSet<Invoice> Invoices { get; set;}
        //public DbSet<Customer> Customers { get; set; }
        public DbSet<InvoiceProduct> InvoicesProduct { get; set;}

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            base.OnConfiguring(optionsBuilder);
            optionsBuilder.UseSqlite("Datasource=ProductsDatabase");
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Company>().UseTpcMappingStrategy();

            modelBuilder.Entity<InvoiceProduct>().HasKey(p => new { p.InvoiceId, p.ProductId });
        }
    }
}
